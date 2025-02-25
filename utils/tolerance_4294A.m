function [tol_abs, tol_rad, is_valid] = tolerance_4294A(f, Z, V_osc, BW)
% Get the device tolerance for the HP/Agilent/Keysight 4294A.
%
%    Take the formula from the operation manual.
%    Different oscillator voltage and bandwidth settings are accepted.
%    The default test fixture (16047E) is accepted.
%
%    Parameters:
%        f (matrix): frequency matrix
%        Z (matrix): impedance matrix
%        V_osc (float): oscillator voltage used for the measurement
%        BW (float): bandwidth setting used for the measurement
%
%    Returns:
%        tol_abs (matrix): tolerance of the amplitude
%        tol_rad (matrix): tolerance of the phase
%        is_valid (matrix): if the points are valid (or not)
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% assert
validateattributes(f, {'double'},{'2d', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Z, {'double'},{'2d', 'nonempty', 'nonnan', 'finite'});
validateattributes(V_osc, {'double'},{'scalar', 'nonempty', 'nonnan', 'real','finite'});
validateattributes(BW, {'double'},{'scalar', 'nonempty', 'nonnan', 'real','finite'});
assert(V_osc>=5e-3, 'invalid data')
assert(V_osc<=1000e-3, 'invalid data')
assert(BW>=1, 'invalid data')
assert(BW<=5, 'invalid data')
assert(all(size(f)==size(Z)), 'invalid data')

% get dimension
dim = size(f);

% bandwidth
idx_1 = (f>1e6);
idx_2 = (f>=50e3)&(f<=1e6);
idx_3 = (f<50e3);

E_pbw = NaN(dim);
E_pbw = assign_cond(E_pbw, (BW==5)&idx_1, 0.0);
E_pbw = assign_cond(E_pbw, (BW==5)&idx_2, 0.0);
E_pbw = assign_cond(E_pbw, (BW==5)&idx_3, 0.0);
E_pbw = assign_cond(E_pbw, (BW==4)&idx_1, 0.03);
E_pbw = assign_cond(E_pbw, (BW==4)&idx_2, 0.03);
E_pbw = assign_cond(E_pbw, (BW==4)&idx_3, 0.06);
E_pbw = assign_cond(E_pbw, (BW==3)&idx_1, 0.1);
E_pbw = assign_cond(E_pbw, (BW==3)&idx_2, 0.1);
E_pbw = assign_cond(E_pbw, (BW==3)&idx_3, 0.2);
E_pbw = assign_cond(E_pbw, (BW==2)&idx_1, 0.2);
E_pbw = assign_cond(E_pbw, (BW==2)&idx_2, 0.2);
E_pbw = assign_cond(E_pbw, (BW==2)&idx_3, 0.4);
E_pbw = assign_cond(E_pbw, (BW==1)&idx_1, 0.4);
E_pbw = assign_cond(E_pbw, (BW==1)&idx_2, 0.4);
E_pbw = assign_cond(E_pbw, (BW==1)&idx_3, 0.8);

K_bw = NaN(dim);
K_bw = assign_cond(K_bw, (BW==5)&idx_1, 1.0);
K_bw = assign_cond(K_bw, (BW==5)&idx_2, 1.0);
K_bw = assign_cond(K_bw, (BW==5)&idx_3, 1.0);
K_bw = assign_cond(K_bw, (BW==4)&idx_1, 1.0);
K_bw = assign_cond(K_bw, (BW==4)&idx_2, 1.0);
K_bw = assign_cond(K_bw, (BW==4)&idx_3, 1.0);
K_bw = assign_cond(K_bw, (BW==3)&idx_1, 4.0);
K_bw = assign_cond(K_bw, (BW==3)&idx_2, 3.0);
K_bw = assign_cond(K_bw, (BW==3)&idx_3, 3.0);
K_bw = assign_cond(K_bw, (BW==2)&idx_1, 5.0);
K_bw = assign_cond(K_bw, (BW==2)&idx_2, 4.0);
K_bw = assign_cond(K_bw, (BW==2)&idx_3, 4.0);
K_bw = assign_cond(K_bw, (BW==1)&idx_1, 10.0);
K_bw = assign_cond(K_bw, (BW==1)&idx_2, 6.0);
K_bw = assign_cond(K_bw, (BW==1)&idx_3, 6.0);

% oscillator level
idx_1 = (V_osc>500e-3);
idx_2 = (V_osc>250e-3)&(V_osc<=500e-3);
idx_3 = (V_osc>125e-3)&(V_osc<=250e-3);
idx_4 = (V_osc>64e-3)&(V_osc<=125e-3);
idx_5 = (V_osc<=64e-3);

E_posc = NaN(dim);
E_posc = assign_cond(E_posc, idx_1, 0.03.*(1000e-3./V_osc-1)+(1e-6.*f./100));
E_posc = assign_cond(E_posc, idx_2, 0.03.*(500e-3./V_osc-1));
E_posc = assign_cond(E_posc, idx_3, 0.03.*(250e-3./V_osc-1));
E_posc = assign_cond(E_posc, idx_4, 0.03.*(125e-3./V_osc-1));
E_posc = assign_cond(E_posc, idx_5, (0.03+E_pbw).*(64e-3./V_osc-1));

K_yosc = NaN(dim);
K_yosc = assign_cond(K_yosc, idx_1, 1000e-3./V_osc);
K_yosc = assign_cond(K_yosc, idx_2, 500e-3./V_osc);
K_yosc = assign_cond(K_yosc, idx_3, 500e-3./V_osc);
K_yosc = assign_cond(K_yosc, idx_4, 500e-3./V_osc);
K_yosc = assign_cond(K_yosc, idx_5, 500e-3./V_osc);

K_zosc = NaN(dim);
K_zosc = assign_cond(K_zosc, idx_1, 2.0);
K_zosc = assign_cond(K_zosc, idx_2, 500e-3./V_osc);
K_zosc = assign_cond(K_zosc, idx_3, 250e-3./V_osc);
K_zosc = assign_cond(K_zosc, idx_4, 125e-3./V_osc);
K_zosc = assign_cond(K_zosc, idx_5, 64e-3./V_osc);

% offset / fixture (16047E)
Y_odc = 0.0;
E_pl = 0.0;
Y_ol = 0.0;
Z_sl = 0.0;

% parameter Y_o
idx_1 = (f<100.0);
idx_2 = (f>=100.0)&(f<=200e3);
idx_3 = (f>200e3)&(f<=1e6);
idx_4 = (f>1e6)&(f<=15e6);
idx_5 = (f>15e6);

Y_o = NaN(dim);
Y_o = assign_cond(Y_o, idx_1, 10e-9);
Y_o = assign_cond(Y_o, idx_2, 2.5e-9);
Y_o = assign_cond(Y_o, idx_3, 5e-9);
Y_o = assign_cond(Y_o, idx_4, 50e-9);
Y_o = assign_cond(Y_o, idx_5, 500e-9);

% parameter E_p
idx_1 = (f<100.0);
idx_2 = (f>=100.0)&(f<800.0);
idx_3 = (f>=800.0)&(f<=1e6);
idx_4 = (f>1e6)&(f<=15e6);
idx_5 = (f>15e6);

E_p = NaN(dim);
E_p = assign_cond(E_p, idx_1, 0.5);
E_p = assign_cond(E_p, idx_2, 0.3);
E_p = assign_cond(E_p, idx_3, 0.075);
E_p = assign_cond(E_p, idx_4, 0.1.*(1e-6.*f));
E_p = assign_cond(E_p, idx_5, 1.5);

% parameter Z_s
idx_1 = (f<100.0);
idx_2 = (f>=100.0);

Z_s = NaN(dim);
Z_s = assign_cond(Z_s, idx_1, 10e-3);
Z_s = assign_cond(Z_s, idx_2, 2.5e-3);

% error sum
E_p_p = E_pl+E_pbw+E_posc+E_p;
Z_s_p = Z_sl+K_bw.*K_zosc.*Z_s;
Y_o_p = Y_ol+K_bw.*K_yosc.*(Y_odc+Y_o);

% get tolerance for amplitude and phase
E = E_p_p+100.0.*((Z_s_p./abs(Z))+(Y_o_p.*abs(Z)));
E = E./100.0;

tol_abs = E;
tol_rad = E;

% detect invalid data
is_valid = true;
is_valid = is_valid&(f>=(40.0-10.*eps(40.0)));
is_valid = is_valid&(f<=(110e6+10.*eps(110e6)));
is_valid = is_valid&(abs(Z)>=(10e-3-10.*eps(10e-3)));
is_valid = is_valid&(abs(Z)<=(100e6+10.*eps(100e6)));

% check
validateattributes(tol_abs, {'double'},{'2d', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(tol_rad, {'double'},{'2d', 'nonempty', 'nonnan', 'real', 'finite'});

end

function var = assign_cond(var, idx, value)
% Assign value to a variable for given indices.
%
%    Parameters:
%        var (matrix): variable for assignation
%        idx (matrix): indices to be assigned
%        value (matrix): value to be assigned
%
%    Returns:
%        var (matrix): variable with the assigned value

if isscalar(value)
    value = repmat(value, size(var));
end
if isscalar(idx)
    idx = repmat(idx, size(var));
end

var(idx) = value(idx);

end
