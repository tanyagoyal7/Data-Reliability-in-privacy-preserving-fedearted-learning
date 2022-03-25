clc;
clear all;
close all;

load('noise_surface_data.mat');
load('v_point_no_malicious_corrected_10_malicious_user_percent');

% X=X(:,1:105);
% Y=Y(:,1:105);
[len,wid]=size(X);

for t=30
    participant_measured_noise_values=zeros(161,151,1000);
    participant_measured_noise_values_iter=ones(161,151);
    for random_iter_no=1:100
        for i=1:5000
            %i
            this_participant_data=reshape(participant_position_measurement_malicious(random_iter_no,i,t,:),1,3);
            nan_idx=isnan(this_participant_data(:,1));
            this_participant_data=this_participant_data(~nan_idx,:);

            [lent,~]=size(this_participant_data);
            for j=1:lent
                idx_x_1=X(1,:)>this_participant_data(lent,1);
                idx_x=max(find(idx_x_1==0));
                idx_y_1=Y(:,1)>this_participant_data(lent,2);
                idx_y=max(find(idx_y_1==0));

                participant_measured_noise_values(idx_x,idx_y,participant_measured_noise_values_iter(idx_x,idx_y))=this_participant_data(lent,3);
                participant_measured_noise_values_iter(idx_x,idx_y)=participant_measured_noise_values_iter(idx_x,idx_y)+1;
            end
        end
    end

    participant_measured_noise_values_mean=zeros(161,151);
    malicious_measured_noise_values_mean=zeros(161,151);
    
    Xi=reshape(X,1,[]);
    Yi=reshape(Y,1,[]);
    w=-2;



    for i=1:161
        for j=1:151
            i
            j
            measurements=reshape(participant_measured_noise_values(i,j,1:participant_measured_noise_values_iter(i,j)-1),1,[]);
            dim=size(measurements);

            measurements_len=dim(2);

            if  measurements_len>0
                A_new=rand(measurements_len,24311);
                for k=1:measurements_len
                    Xc=X(1,i);
                    Yc=Y(j,1);
                   
                    Vc=measurements(1,k);
                    Vi=gIDW(Xc,Yc,Vc,Xi,Yi,w);

                    A_new(k,:)=Vi;
                   
                end
% 
% 
                [param,mal]=product_cal(A_new);
%                 param
                participant_measured_noise_values_mean(i,j)=param(1,j+151*(i-1));
                malicious_measured_noise_values_mean(i,j)=mal(1,j+151*(i-1));
                

            end

        end
    end

    figure;
   
    plot3(X,Y,participant_measured_noise_values_mean,'o');
    hold on;

    plot3(X,Y,malicious_measured_noise_values_mean,'.');


end