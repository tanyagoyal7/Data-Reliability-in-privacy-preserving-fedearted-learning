function [param,mal] = product_cal(A_new)
[u0,u1]=data_split(A_new);
[m,n]=size(A_new);
F=0.1;
a=randi(128,[m,n]);
b=randi(128,[n,m]);
c=a*b;
[a0,a1]=data_split(a);
[b0,b1]=data_split(b);
[c0,c1]=data_split(c);

% load('a0');
% load('a1');
%
% load('b0');
% load('b1');
%
% load('c0');
% load('c1');
%
a0=a0/128;
b0=b0/128;

c0=c0/(128*128);

a1=a1/128;
b1=b1/128;

c1=c1/(128*128);

%server_1
alpha0= u0-a0;
beta0=  u0'-b0;
%server_2
alpha1= u1-a1;
beta1=  u1'-b1;
%both
alpha = alpha0+alpha1;
beta = beta0+beta1;
%server_1
z0 = a0*beta+alpha*b0+c0;
%server_2
z1= alpha*beta+a1*beta+alpha*b1+c1;
%both
z = z0+z1;

% p=A*A';

undiag = ones(m,m)-eye(m);

% p1=p.*undiag;
z1=z.*undiag; %cosine similarity

% sp=p1*ones(m,1);
sz=z1*ones(m,1);

%[B,I]=maxk(S,(1-F)*m);

% [bp,ip]=maxk(sp,(0.8)*m);
number_of_non_malicious_users=ceil((1-F)*m);
[bz,iz]=maxk(sz,number_of_non_malicious_users);
number_of_malicious_users=floor(F*m);
[mz,miz]=mink(sz,number_of_malicious_users);
% Af=A1(ip,:);

% figure;
%
% hold on;
% o=zeros(1,3);
% for i=1:(1-F)*m
%    plot3( [o(1),Af(i,1)],[o(2),Af(i,2)],[o(3),Af(i,3)]);
% end
% grid on;
% xlabel('X axis'), ylabel('Y axis'), zlabel('Z axis')
% set(gca,'CameraPosition',[1 2 3]);
%
Bf=A_new(iz,:);

%{
figure;

hold on;
o=zeros(1,3);
for i=1:(0.8)*m
   plot3( [o(1),Bf(i,1)],[o(2),Bf(i,2)],[o(3),Bf(i,3)]);
end
grid on;
xlabel('X axis'), ylabel('Y axis'), zlabel('Z axis')
set(gca,'CameraPosition',[1 2 3]);
%}
if number_of_non_malicious_users>1
    u0f=sum(u0(iz,:));
    u1f=sum(u1(iz,:));
else
    u0f=u0(iz,:);
    u1f=u1(iz,:);
end
mal=zeros(1,n);
if number_of_malicious_users>0
    if number_of_malicious_users>1
        m0f=sum(u0(miz,:));
        m1f=sum(u1(miz,:));
    else
        m0f=u0(miz,:);
        m1f=u1(miz,:);
    end
    mal = (m0f+m1f)/(m*F);
end

param = (u0f+u1f)/(m*(1-F));

return