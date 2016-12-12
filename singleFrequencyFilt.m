function [en] = singleFrequencyFilt(y,fs,step_Hz,pflag,eval_freqsvec)

% Purpose: Single frequency filtered representation of speech signals

% Input : (1) y         - input signal (must be a row vector)
%         (2) fs        - sampling rate
%         (3) step_hz   - filters will be spaced with this steps in
%                         frequency domain from 0 to fs/2 Hz (20Hz) (use either 1Hz or 20Hz)
%         (4) pflag     - plot flag [1 - to plot] (0)

% Output  (1) en        - envelopes at SF's till nyquist freq. (fs/2)

% Example usage: (1) en = singleFrequencyFilt(y,fs); 
%                (2) en = singleFrequencyFilt(y,fs,20,0);

% Ref: "Single Frequency Filtering Approach for Discriminating Speech and Nonspeech"
% - G. Aneeja and B. Yegnanarayana, IEEE TASLP 2015.

% Coded by: Sivanand Achanta


if nargin < 3
    step_Hz = 20;
elseif nargin <4
    pflag = 0;
end

y = y(:); % make sure "y" is a row vector
nyfr = 0:step_Hz:round(fs/2);

if nargin == 5
    nyfr = eval_freqsvec;
end

xvec = (0:length(y)-1)';
en = zeros(length(nyfr),length(y));

for k = 1:length(nyfr)
    
    % Multiplication with Complex Exponential
    yk = y.*exp(1i*(2*pi/fs)*nyfr(k)*xvec);
    
    % Nyquist Frequency Filtering (NFF)
    yk_sff = filter(1,[1 0.99],yk);
    
    % Taking the Envelope of the Complex Signal
    en(k,:) = abs(yk_sff);
    
end

if pflag
    [X,Y] = meshgrid(xvec,nyfr);
    waterfall(X,Y,en); axis tight; colormap(1 - gray);
end