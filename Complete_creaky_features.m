% Creates a creaky features of our 'wavList', located in the folder 'wavDir'
% for the ANN creaky voice classification
% clc;
% clear all;
%% list wav files
currentDir = fileparts(mfilename('fullpath'));
wavDir = [currentDir '\wav\'];
wavList = dir([wavDir '*.wav']);
nFile = length(wavList);
%% creaky features
ishi_features   = [];
KD_features     = [];
creaky_features = [];
%% Do processing
fprintf('\t please wait... \n');
for iFile=1:nFile
    % File name
    wavFileName = [wavDir wavList(iFile).name];
    % Do feature extraction
    [creaky_input_features, ...
       ishi_input_features, KD_input_features] = input_creaky_features(wavFileName);
    % Reload creaky features
    ishi_features   = [ishi_features ishi_input_features]; %#ok
    KD_features     = [KD_features KD_input_features]; %#ok
    creaky_features = [creaky_features creaky_input_features]; %#ok
end
%% Save to .mat
% save([wavDir 'creaky_features.mat'], 'creaky_features', 'ishi_features', 'KD_features' )
save([wavDir 'creaky_features.mat'], 'creaky_features') %, 'ishi_features', 'KD_features' )
fprintf('\t save %s \n', [wavDir 'creaky_features.mat']);

