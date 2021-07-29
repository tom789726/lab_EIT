% run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m

% Reference: 
% https://www.youtube.com/watch?v=M42fTlVV7zk&ab_channel=Mecatr%C3%B3nicaM%C3%A1sters

clc;

voltage_medical = [
    0.26;    0.19;    0.18;    0.26;    0.48;    
    0.09;    0.06;    0.06;    0.11;    0.48;    
    0.26;    0.10;    0.05;    0.06;    0.26;
    0.19;    0.09;    0.10;    0.06;    0.19;    
    0.19;    0.05;    0.10;    0.09;    0.20;    
    0.27;    0.07;    0.05;    0.10;    0.29;    
    0.49;    0.12;    0.06;    0.06;    0.09;
    0.49;    0.26;    0.20;    0.21;    0.30;
    ];

model = mk_common_model('c2c2',8);

imagen = calc_jacobian_bkgnd(model);

voltage_homogen = fwd_solve(imagen);

reconstruction = inv_solve(model,voltage_homogen,voltage_medical);

show_fem(reconstruction,[1,0,0]);