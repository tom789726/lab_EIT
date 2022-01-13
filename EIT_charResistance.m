close all; clear all; clc;

N = 32;
l = 1:N;
theta_l = l/N * 2 * pi;

%% Model 2: Discretization effect
k = 1;

A = 1;
J = 5*cos(k*theta_l)/A;

figure
plot(l,J);