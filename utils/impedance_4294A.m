function Z_tol_mat = impedance_4294A(f_vec, Z_vec, V_osc, BW)

% check
assert(length(f_vec)==length(Z_vec), 'invalid data')

% device tolerance
[tol_abs, tol_rad, is_valid] = tolerance_4294A(f_vec, Z_vec, V_osc, BW);
assert(all(is_valid==true), 'invalid data')

% convert to abs/rad
Z_abs_vec = abs(Z_vec);
Z_rad_vec = angle(Z_vec);

% get the worst cases
Z_tol_mat(1,:) = get_Z(Z_abs_vec.*(1+tol_abs), Z_rad_vec+tol_rad);
Z_tol_mat(2,:) = get_Z(Z_abs_vec.*(1-tol_abs), Z_rad_vec+tol_rad);
Z_tol_mat(3,:) = get_Z(Z_abs_vec.*(1+tol_abs), Z_rad_vec-tol_rad);
Z_tol_mat(4,:) = get_Z(Z_abs_vec.*(1-tol_abs), Z_rad_vec-tol_rad);

end

function Z_vec = get_Z(Z_abs_vec, Z_rad_vec)

Z_vec = Z_abs_vec.*exp(1i.*Z_rad_vec);

end
