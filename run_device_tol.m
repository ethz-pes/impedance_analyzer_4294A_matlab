function plot_tolerance()

close('all')
addpath('utils')

f_vec = logspace(log10(1.001.*40), log10(0.999.*110e6), 100);
Z_vec = logspace(log10(1.001.*10e-3), log10(0.999.*100e6), 100);

[f_mat, Z_mat] = meshgrid(f_vec, Z_vec);
BW = 5;
V_osc = 500e-3;

[tol_abs, tol_rad, is_valid] = tolerance_4294A(f_mat, Z_mat, V_osc, BW);
assert(all(all(is_valid==true)), 'invalid data')

vec = logspace(log10(0.01), log10(100.0), 100);

figure()

subplot(2,1,1)
contourf(f_vec, Z_vec, 100.0.*tol_abs, vec, 'Edgecolor', 'none')
hold('on')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
set(gca,'ColorScale','log')
caxis([1e-1 10])
c = colorbar();
set(c.Label, 'String', 'Abs. Tol. [%]')
xlabel('f [Hz]')
ylabel('Z [Ohm]')
title('Tolerance / Absolute')

subplot(2,1,2)
contourf(f_vec, Z_vec, rad2deg(tol_rad), vec, 'Edgecolor', 'none')
hold('on')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
set(gca,'ColorScale','log')
caxis([1e-1 10])
c = colorbar();
set(c.Label, 'String', 'Angle Tol. [deg]')
xlabel('f [Hz]')
ylabel('Z [Ohm]')
title('Tolerance / Angle')

end