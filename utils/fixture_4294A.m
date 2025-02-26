function Z_tol = fixture_4294A(f, Z, Rs, Ls, Cp)
% Add the impact of the fixture tolerances on the measurements.
%
%    Get all the worst-case combinations between fixture parameters.
%    Return a matrix with all the possible error combinations.
%
%    Parameters:
%        f (vector): frequency vector
%        Z (matrix): matrix with the complex impedances
%        Rs (float): tolerance on the series resistance of the fixture
%        Ls (float): tolerance on the series inductance of the fixture
%        Cp (float): tolerance on the parallel capacitance of the fixture
%
%    Returns:
%        Z_tol (matrix): matrix with the complex impedance tolerance
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% check
validateattributes(f, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Z, {'double'},{'2d', 'nonempty', 'nonnan', 'finite'});
validateattributes(Rs, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Ls, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Cp, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
assert(size(f, 2)==size(Z, 2), 'invalid data (frequency and impedance vector should have the same size)')

% span the uncertainties
[idx_vec, Rs_vec, Ls_vec, Cp_vec] = ndgrid(1:size(Z, 1), [-Rs, +Rs], [-Ls, +Ls], [-Cp, +Cp]);
idx_vec = idx_vec(:);
Z_tol = Z(idx_vec, :);
Rs_vec = Rs_vec(:);
Ls_vec = Ls_vec(:);
Cp_vec = Cp_vec(:);

% complex frequency
s = 1i.*2.*pi.*f;

% compute the fixture impedance
Z_par = 1./(s.*Cp_vec);
Z_ser = Rs_vec+s.*Ls_vec;

% add the fixture impact
Z_tol = Z_ser+(Z_tol.*Z_par)./(Z_tol+Z_par);

% check
validateattributes(Z_tol, {'double'},{'2d', 'nonempty', 'nonnan', 'finite'});
assert(size(f, 2)==size(Z_tol, 2), 'invalid data (frequency and impedance vector should have the same size)')

end
