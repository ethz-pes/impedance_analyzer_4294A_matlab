function run_meas_tol()
% Read an impedance measurement and evaluate the tolerances.
%
%    Read a file generated by a HP/Agilent/Keysight 4294A impedance analyzer.
%    Extract the measurement tolerances.
%    Plot the measured values and the tolerances.
%
%    For the example, a resistive-inductive load is considered.
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

close('all')
addpath('utils')

%% param
BW = 5; % bandwidth setting of the impedance analyzer
V_osc = 500e-3; % oscillator voltage of the impedance analyzer
Rs = 0.5e-3; % tolerance on the series resistance of the fixture
Ls = 5e-9; % tolerance on the series inductance of the fixture
Cp = 1e-12; % tolerance on the parallel capacitance of the fixture
f_val = [1e3, 1e4, 1e5]; % frequency where the results should be extracted

%% read the measurements
[f, Z] = read_4294A('data/impedance.txt');

%% read impedance and evaluate tolerances
[tol_abs, tol_rad, is_valid] = tolerance_4294A(f, Z, V_osc, BW);

%% chek the range validity
assert(all(all(is_valid==true)), 'invalid data (outside the ranges definied in the datasheet)')

%% init the tolerance with the nominal values
Z_tol = Z;

%% add the device tolerances
Z_tol = impedance_4294A(f, Z_tol, tol_abs, tol_rad);

%% add the fixture tolerances
Z_tol = fixture_4294A(f, Z_tol, Rs, Ls, Cp);

%% extract the resistance
R = real(Z);
R_tol = real(Z_tol);

%% extract the inductance
L = imag(Z)./(2.*pi.*f);
L_tol = imag(Z_tol)./(2.*pi.*f);

%% evaluate the tolerances
for f_tmp=f_val
    [R_val, R_rel] = extract_data(f, R, R_tol, f_tmp);
    [L_val, L_rel] = extract_data(f, L, L_tol, f_tmp);
    fprintf('f = %.3f kHz\n', 1e-3.*f_tmp)
    fprintf('    R = %.3f mOhm / tol = %.3f %%\n', 1e3.*R_val, 1e2.*R_rel)
    fprintf('    L = %.3f uH / tol = %.3f %%\n', 1e6.*L_val, 1e2.*L_rel)
end

%% plot impedance measurements and tolerances
figure()

subplot(2,1,1)
plot_data(f, 1e3.*R, 1e3.*R_tol)
set(gca,'xscale','log')
set(gca,'yscale','lin')
grid('on')
xlabel('f [Hz]')
ylabel('R [mOhm]')
title('Resistance')

subplot(2,1,2)
plot_data(f, 1e6.*L, 1e6.*L_tol)
set(gca,'xscale','log')
set(gca,'yscale','lin')
grid('on')
xlabel('f [Hz]')
ylabel('L [uH]')
title('Inductance')

end

function [v_val, v_rel] = extract_data(f, v, v_tol, f_val)
% Extract the value and tolerance at a particular frequency.
%
%    Parameters:
%        f (vector): frequency vector
%        v (vector): data vector with the nominal values
%        v_tol (matrix): data matrix for the tolerances
%        f_val (float): frequency for the evaluation
%
%    Returns:
%        v_val (float): nominal value
%        v_rel (float): relative error

% get min/max value
v_tol_max = max(v_tol, [], 1);
v_tol_min = min(v_tol, [], 1);

% interp the data
v_val = interp1(log10(f), v, log10(f_val));
v_min = interp1(log10(f), v_tol_min, log10(f_val));
v_max = interp1(log10(f), v_tol_max, log10(f_val));

% compute the relative error
v_rel = (v_max-v_min)./(2.0.*v_val);

end

function plot_data(f, v, v_tol)
% Plot a curve with the tolerance.
%
%    Parameters:
%        f (vector): frequency vector
%        v (vector): data vector with the nominal values
%        v_tol (matrix): data matrix for the tolerances

% get min/max value
v_tol_max = max(v_tol, [], 1);
v_tol_min = min(v_tol, [], 1);

% get min/max data
f_extend = [f, fliplr(f)];
v_min_max = [v_tol_min, fliplr(v_tol_max)];

% plot data
fill(f_extend, v_min_max, 'k', 'LineStyle', 'none', 'FaceAlpha', 0.2, 'FaceColor', 'r');
hold('on')
plot(f, v, 'r', 'LineWidth', 1.0)
hold('on')

end