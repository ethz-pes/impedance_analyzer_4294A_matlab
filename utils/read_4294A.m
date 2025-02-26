function [f, Z] = read_4294A(filename)
% Read files from HP/Agilent/Keysight 4294A impedance analyzer.
%
%    Read the frequency sweep files ((ASCII format).
%    First dataset is the amplitude of the impedance.
%    Second dataset is the phase of the impedance.
%
%    Parameters:
%        filename (str): name of the file
%
%    Returns:
%        f (vector): frequency vector
%        Z (vector): complex impedance vector
%
%    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% check
assert(ischar(filename), 'invalid file: file name should be string')
assert(isfile(filename), 'invalid file: file cannot be found')

% get number of lines
n = read_line(filename);

% define the header size
n_header_start = 21;
n_header_mid = 6;

% compute the number of points (total)
n_tot = n-n_header_start-n_header_mid;

% check the number of points
assert(n_tot>=2, 'invalid file: invalid number of lines')
assert(mod(n_tot, 2)==0, 'invalid file: invalid number of lines')

% compute the number of points (per channel)
n_pts = n_tot./2;

% indices of the cell to be extracted
range_abs = [n_header_start+1, 1, n_header_start+n_pts, 2];
range_angle = [n_header_start+n_pts+n_header_mid+1, 1, n_header_start+n_pts+n_header_mid+n_pts, 2];

% read the data, without the header
data_abs = readmatrix(filename, 'Delimiter', '\t', 'Range', range_abs);
data_angle = readmatrix(filename, 'Delimiter', '\t', 'Range', range_angle);

% check size
assert(all(size(data_abs)==size(data_angle)), 'invalid data (amplitude and angle vector should have the same size)')

% parse the frequency
f = (data_abs(:,1).'+data_angle(:,1).')./2.0;

% parse the complex impedance
Z_abs = data_abs(:,2).';
Z_deg = data_angle(:,2).';
Z = Z_abs.*exp(1i.*deg2rad(Z_deg));

% check
validateattributes(f, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Z, {'double'},{'row', 'nonempty', 'nonnan', 'finite'});
assert(length(f)==length(Z), 'invalid data (frequency and impedance vector should have the same size)')

end

function n = read_line(filename)
% Plot the inductance matrix between the conductors.
%
%    Parameters:
%        filename (str): name of the file
%
%    Returns:
%        n (integer): number of lines in the file

n = 0;
fid = fopen(filename, 'r');

while feof(fid)==false
    fgetl(fid);
    n = n+1;
end

fclose(fid);

end
