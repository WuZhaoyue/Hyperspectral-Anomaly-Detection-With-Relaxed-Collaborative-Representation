%     demo for RCRD detection algorithm
%--------------Brief description-------------------------------------------
%
% More details in:
% Z. Wu, H. Su, X. Tao, L. Han,  M. E. Paoletti, J. M. Haut, J. Plaza, and A. Plaza
% Hyperspectral Anomaly Detection With Relaxed Collaborative Representation
% IEEE Transactions on Geoscience and Remote Sensing, vol. 60, 2022


clc;
clear;
close all;
addpath(genpath(pwd));

%% load data and mask
data_number=1;
[data, data_o, data2D,data2D_o, M,m,n,b, mask]=load_data(data_number);

%% Build dictionary by using twice MSC
%%%%% The first cluster radius can be estimated by k-dist, the distance of inflection
%%%%% Point of the curve is selected as the first cluster radius.
%%%%% The second cluster radius can be set as 0.2 empirically.

k_dist(data2D, b);
bandwidth1=input('Please enter the first cluster radius');

% bandwidth1=0.5;
bandwidth2=0.2;
[Dic, TrSpe]=Dic_built(data2D, bandwidth1,bandwidth2 );
fprintf('a=%f',size(Dic, 2))
  
%% RCRD
%%%%% lambda and tau are the regularization parameters both for RCRD and
%%%%% RCRDW, gamma is the regularization parameter of RCRDW.
%%%%% Generally, gamma and tau can be set as 1e2, lambda need to be tuned
%%%%% in the range from 1e-5 to 1e0.
%%%%% k is the parameter of KNN, if the number of atoms in "Dic"
%%%%% is over 10, the k can be set as 10. Otherwise, k can be set as the
%%%%% number of atoms in the "Dic"

k=10;
lambda=[1];
tau=[1e2];
gamma=[1e2];

tic
E=RCRD(data2D, Dic, lambda,tau, k);% fast but slightly less accurate than RCRDW's
% E=RCRDW(data2D,Dic,lambda,gamma,tau,k);% high accuracy but computing slowly
toc
time_RCRD=toc;

%% Compute accuracy and display anomaly map

[PF_RCRD, PD_RCRD, area_RCRD]=AUC(mask, E);
fprintf('AUC=%f',area_RCRD)
A_RCRD=reshape(E, m,n);
figure, imagesc(A_RCRD); axis image;

