% run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m
close all;
imdl = mk_common_model('b2C',8);
show_fem(imdl.fwd_model,[0,1,0]); axis off;