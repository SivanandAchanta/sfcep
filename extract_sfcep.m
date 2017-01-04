% Purpose : Spectral envelope extraction using SFF and SFF-Cepstra

clear all; close all; clc;

% Set Paths
wavdir = 'wav/';
featpath = 'sfcc/';
fname = 'tel_0001';
fext = '.sfcc';
mkdir(featpath);

% Step0: Read wave
[y,fs] = audioread(strcat(wavdir, fname,'.wav'));

% Step1: Set SFF analysis params
nfft = 1024; % number of FFT points
step_Hz = 10; % Note if fhz/hfhz are used this is redundant
pflag = 0; % plot flag
shift_ms = 10*(fs/1000); % frame shift for subsampling SFF spectrum
cep_channels = floor(0.85*(fs/1000)); % maximum number of cepstrum coefficients to consider

% Step2: Compute SFF Spectrum and Cepstrum
% [sffspec, sffcep, sffcepdd] = sffCesptra(y,fs,step_Hz,pflag,nfft,shift_ms,cep_channels);
[sffspec, sffcep, sffcepdd] = sffCesptra_ms(y,fs,step_Hz,pflag,nfft,shift_ms,cep_channels);
dlmwrite(strcat(featpath, fname, fext), sffcepdd, 'delimiter', ' ');
