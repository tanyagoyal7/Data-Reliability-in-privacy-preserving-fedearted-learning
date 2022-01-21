clc;
clear all;
close all;

load('noise_surface_data_time30_mean_malicious5_.mat');
load('noise_surface_data.mat');

for t=1:30
   
    figure;
    noisemap=reshape(noise_map_(t,:,:),151,161);
    plot3(X,Y,noisemap,'o');
    hold on;
 
    malpoints=reshape(malicious_points(t,:,:),151,161);
    plot3(X,Y,malpoints,'.');
end
