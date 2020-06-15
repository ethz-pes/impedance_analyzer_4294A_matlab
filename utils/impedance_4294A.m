function Z_tol = impedance_4294A(f, Z, tol_abs, tol_rad)
% Get the impedance measurement tolerance for the HP/Agilent/Keysight 4294A.
%
%    Get all the worst-case combinations between amplitude and phase errors:
%        - min amplitude / min phase
%        - min amplitude / max phase
%        - max amplitude / min phase
%        - max amplitude / max phase
%
%    Parameters:
%        f (vector): frequency vector
%        Z (vector): complex impedance vector
%        tol_abs (vector): tolerance of the amplitude
%        tol_rad (vector): tolerance of the phase
%
%    Returns:
%        Z_tol (matrix): matrix with the complex impedance tolerance
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% check
validateattributes(f, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Z, {'double'},{'row', 'nonempty', 'nonnan','finite'});
validateattributes(tol_abs, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(tol_rad, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
assert(all(size(f)==size(Z)), 'invalid data')
assert(all(size(f)==size(tol_abs)), 'invalid data')
assert(all(size(f)==size(tol_rad)), 'invalid data')

% convert to abs/rad
Z_abs = abs(Z);
Z_rad = angle(Z);

% get the worst cases combinations
Z_tol(1,:) = get_Z(Z_abs.*(1+tol_abs), Z_rad+tol_rad);
Z_tol(2,:) = get_Z(Z_abs.*(1-tol_abs), Z_rad+tol_rad);
Z_tol(3,:) = get_Z(Z_abs.*(1+tol_abs), Z_rad-tol_rad);
Z_tol(4,:) = get_Z(Z_abs.*(1-tol_abs), Z_rad-tol_rad);

% check
validateattributes(Z_tol, {'double'},{'2d', 'nonempty', 'nonnan', 'finite'});

end

function Z = get_Z(Z_abs, Z_rad)
% Combine amplitude and phase into a complex impedance.
%
%    Parameters:
%        Z_abs (vector): impedance amplitude
%        Z_rad (vector): impedance phase
%
%    Returns:
%        Z (vector): complex impedance

Z = Z_abs.*exp(1i.*Z_rad);

end
