function run_impedance_meas()

close('all')
addpath('utils')

BW = 5; % bandwidth setting of the impedance analyzer
V_osc = 500e-3; % oscillator voltage of the impedance analyzer

[f_vec, Z_vec] = read_4294A('data/impedance.txt');

Z_tol_mat = impedance_4294A(f_vec, Z_vec, V_osc, BW);

%% plot
figure()

subplot(2,2,1)
plot_data(f_vec, abs(Z_vec), abs(Z_tol_mat))
set(gca,'xscale','log')
set(gca,'yscale','log')
grid('on')
xlim([1e3 100e3])
xlabel('f [Hz]')
ylabel('Z [Ohm]')
title('Impedance / Abs')

subplot(2,2,2)
plot_data(f_vec, rad2deg(angle(Z_vec)), rad2deg(angle(Z_tol_mat)))
set(gca,'xscale','log')
grid('on')
xlim([1e3 100e3])
xlabel('f [Hz]')
ylabel('Z [deg]')
title('Impedance / Angle')

subplot(2,2,3)
plot_data(f_vec, 1e3.*real(Z_vec), 1e3.*real(Z_tol_mat))
set(gca,'xscale','log')
grid('on')
xlim([1e3 100e3])
xlabel('f [Hz]')
ylabel('R [mOhm]')
title('Impedance')

subplot(2,2,4)
plot_data(f_vec, 1e6.*imag(Z_vec)./(2.*pi.*f_vec), 1e6.*imag(Z_tol_mat)./(2.*pi.*f_vec))
set(gca,'xscale','log')
xlim([1e3 100e3])
grid('on')
xlabel('f [Hz]')
ylabel('L [uH]')
title('Impedance')

end

function plot_data(x_vec, y_vec, y_tol_mat)

% get min/max value
y_tol_max_vec = max(y_tol_mat, [], 1);
y_tol_min_vec = min(y_tol_mat, [], 1);

% get min/max data
x_vec_all = [x_vec, fliplr(x_vec)];
y_min_max_vec = [y_tol_min_vec, fliplr(y_tol_max_vec)];

% plot data
fill(x_vec_all, y_min_max_vec, 'k', 'LineStyle', 'none', 'FaceAlpha', 0.2, 'FaceColor', 'r');
hold('on')
plot(x_vec, y_vec, 'r')

end