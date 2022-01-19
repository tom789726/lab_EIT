% Review on Distinguishability
close all; clear all; clc;

num_elec = 16;
j = [1:num_elec]'-1;
j = cosd( j*(360) / num_elec );

figure
plot(j);

% Graph 1: Voltage difference vs Target diameter

cond_h = 10;
vh = 1/cond_h * j;
plot(vh);


% Graph 2: Distinguishability vs Target diameter
