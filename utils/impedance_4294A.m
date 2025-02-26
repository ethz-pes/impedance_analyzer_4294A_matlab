function Z_tol = impedance_4294A(f, Z, tol_abs, tol_rad)
% Add the impact of the device tolerances on the measurements.
%
%    Get all the worst-case combinations between amplitude and phase errors.
%    Return a matrix with all the possible error combinations.
%
%    Parameters:
%        f (vector): frequency vector
%        Z (matrix): matrix with the complex impedances
%        tol_abs (vector): tolerance of the amplitude
%        tol_rad (vector): tolerance of the phase
%
%    Returns:
%        Z_tol (matrix): matrix with the complex impedance tolerance
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% check
validateattributes(f, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Z, {'double'},{'2d', 'nonempty', 'nonnan','finite'});
validateattributes(tol_abs, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(tol_rad, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
assert(size(f, 2)==size(Z, 2), 'invalid data (invalid vector size)')

% span the uncertainties
[idx_vec, tol_abs_vec, tol_rad_vec] = ndgrid(1:size(Z, 1), [-1, +1], [-1, +1]);
idx_vec = idx_vec(:);
Z_tol = Z(idx_vec, :);
tol_abs_vec = tol_abs_vec(:);
tol_rad_vec = tol_rad_vec(:);

% add the tolerances
Z_abs = abs(Z_tol).*(1+tol_abs_vec.*tol_abs);
Z_angle = angle(Z_tol)+tol_rad_vec.*tol_rad;

% assemble the impedance
Z_tol = Z_abs.*exp(1i.*Z_angle);

% check
validateattributes(Z_tol, {'double'},{'2d', 'nonempty', 'nonnan', 'finite'});
assert(size(f, 2)==size(Z_tol, 2), 'invalid data (frequency and impedance vector should have the same size)')

end
