function [f_vec, Z_vec] = read_4294A(filename)

% get number of lines
n = read_line(filename);

% read the data
n_header_start = 21;
n_header_mid = 6;
n_pts = (n-n_header_start-n_header_mid)./2;
data_abs = dlmread(filename,'\t', [n_header_start 0 n_header_start+n_pts-1 1]);
data_angle = dlmread(filename,'\t', [n_header_start+n_pts+n_header_mid 0 n_header_start+n_pts+n_header_mid+n_pts-1 1]);

% parse the data
f_vec = (data_abs(:,1).'+data_angle(:,1).')./2.0;
Z_abs_vec = data_abs(:,2).';
Z_deg_vec = data_angle(:,2).';
Z_vec = Z_abs_vec.*exp(1i.*deg2rad(Z_deg_vec));

end

function n = read_line(filename)

fid = fopen(filename);
data = textscan(fid,'%s','delimiter','\n');
fclose(fid);
assert(length(data)==1, 'invalid data');
n = length(data{1});

end