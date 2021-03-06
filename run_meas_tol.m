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

%% read impedance and evaluate tolerances
[f, Z] = read_4294A('data/impedance.txt');

[tol_abs, tol_rad, is_valid] = tolerance_4294A(f, Z, V_osc, BW);
assert(all(is_valid==true), 'invalid data');

Z_tol = impedance_4294A(f, Z, tol_abs, tol_rad);

%% plot impedance measurements and tolerances
figure()

subplot(2,2,1)
plot_data(f, abs(Z), abs(Z_tol))
set(gca,'xscale','log')
set(gca,'yscale','log')
grid('on')
xlim([1e3 100e3])
xlabel('f [Hz]')
ylabel('Z [Ohm]')
title('Impedance / Abs')

subplot(2,2,2)
plot_data(f, rad2deg(angle(Z)), rad2deg(angle(Z_tol)))
set(gca,'xscale','log')
grid('on')
xlim([1e3 100e3])
xlabel('f [Hz]')
ylabel('Z [deg]')
title('Impedance / Angle')

subplot(2,2,3)
plot_data(f, 1e3.*real(Z), 1e3.*real(Z_tol))
set(gca,'xscale','log')
grid('on')
xlim([1e3 100e3])
xlabel('f [Hz]')
ylabel('R [mOhm]')
title('Impedance')

subplot(2,2,4)
plot_data(f, 1e6.*imag(Z)./(2.*pi.*f), 1e6.*imag(Z_tol)./(2.*pi.*f))
set(gca,'xscale','log')
xlim([1e3 100e3])
grid('on')
xlabel('f [Hz]')
ylabel('L [uH]')
title('Impedance')

end

function plot_data(x, y, y_tol)
% Plot a line with the tolerance.
%
%    Parameters:
%        x (vector): x vector for the line and tolerances
%        y (vector): y vector for the line
%        y_tol (matrix): y matrix for the tolerances

% get min/max value
y_tol_max = max(y_tol, [], 1);
y_tol_min = min(y_tol, [], 1);

% get min/max data
x_all = [x, fliplr(x)];
y_min_max = [y_tol_min, fliplr(y_tol_max)];

% plot data
fill(x_all, y_min_max, 'k', 'LineStyle', 'none', 'FaceAlpha', 0.2, 'FaceColor', 'r');
hold('on')
plot(x, y, 'r')

end