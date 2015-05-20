function [creaky_input_features, ishi_input_features, KD_input_features] = input_creaky_features(fileName)

% Function to the full feature extraction required to create input feature for the ANN 
% creaky voice classification method

%% Load fileName
[x,fs] = audioread(fileName);
%% Extract Kane-Drugman features
[H2H1,res_p,ZCR,F0,F0mean,enerN,pow_std,creakF0] = get_KD_creak_features(x,fs);
%% Extract features from Ishi
[PwP,IFP,IPS] = get_ishi_params_inter(x,fs);
%% Create creaky feature matrix
time = round(linspace(1,length(x),length(H2H1)));
creaky_input_features = [H2H1(:) res_p(:) ZCR(:) IFP(time)' IPS(time)' PwP.fall(time)' PwP.rise(time)' ...
                            F0(:) F0mean(:) enerN(:) pow_std(:) creakF0(:)];

feat_d  = get_delta_mat(creaky_input_features); % Derive first and 
feat_dd = get_delta_mat(feat_d);				% second derivatives of features	
%% Output variables
ishi_input_features = [IFP(time)' IPS(time)' PwP.fall(time)' PwP.rise(time)']'; % Ishi features matrix
KD_input_features   = [H2H1(:) res_p(:) ZCR(:) F0(:)...                         % Kane-Drugman features matrix
                        F0mean(:) enerN(:) pow_std(:) creakF0(:)]'; 
                    
creaky_input_features  = [creaky_input_features feat_d feat_dd]'; % Ishi & Kane-Drugman features 
                                                                  % & deltas & double deltas