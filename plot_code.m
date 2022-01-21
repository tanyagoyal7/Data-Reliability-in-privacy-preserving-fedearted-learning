clc;
clear all;
close all;

load('noise_surface_data_time30_mean_malicious5.mat');
load('noise_surface_data.mat');


figure;

plot3(X,Y,noise_map_,'o');
hold on;
plot3(X,Y,malicious_points,'.');