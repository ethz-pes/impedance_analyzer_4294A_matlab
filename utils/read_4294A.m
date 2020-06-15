function [f, Z] = read_4294A(filename)
% Read (ASCII) files from HP/Agilent/Keysight 4294A impedance analyzer.
%
%    Read frequency sweep files.
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
assert(ischar(filename), 'invalid file: name')

% get number of lines
n = read_line(filename);

% compute the header size
n_header_start = 21;
n_header_mid = 6;
n_tot = n-n_header_start-n_header_mid;
n_pts = n_tot./2;
assert(n_tot>=2, 'invalid file: number of points')
assert(mod(n_tot, 2)==0, 'invalid file: number of points')

% read the data, without the header
data_abs = dlmread(filename,'\t', [n_header_start 0 n_header_start+n_pts-1 1]);
data_angle = dlmread(filename,'\t', [n_header_start+n_pts+n_header_mid 0 n_header_start+n_pts+n_header_mid+n_pts-1 1]);

% parse the frequency
assert(all(data_abs(:,1)==data_angle(:,1)), 'invalid file: frequency vector')
f = (data_abs(:,1).'+data_angle(:,1).')./2.0;

% parse the complex impedance
Z_abs = data_abs(:,2).';
Z_deg = data_angle(:,2).';
Z = Z_abs.*exp(1i.*deg2rad(Z_deg));

% check
validateattributes(f, {'double'},{'row', 'nonempty', 'nonnan', 'real', 'finite'});
validateattributes(Z, {'double'},{'row', 'nonempty', 'nonnan', 'finite'});
assert(all(size(f)==size(Z)), 'invalid data')

end

function n = read_line(filename)
% Plot the inductance matrix between the conductors.
%
%    Parameters:
%        filename (str): name of the file
%
%    Returns:
%        n (integer): number of lines in the file

fid = fopen(filename);
data = textscan(fid,'%s','delimiter','\n');
fclose(fid);
assert(length(data)==1, 'invalid file: number of lines');
n = length(data{1});

end