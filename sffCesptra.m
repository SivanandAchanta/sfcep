function [log_sffspec, sffcep, sffcepdd] = sffCesptra(y,fs,step_Hz,pflag,nfft,shift_ms,cep_channels)

% Purpose: Compute SFF Spectra, Cepstral and del-del features

% Inputs: (1) y            - input signal (must be a row vector)
%         (2) fs           - sampling rate
%         (3) step_hz      - filters will be spaced with this steps in
%                            frequency domain from 0 to fs/2 Hz (20Hz) (use either 1Hz or 20Hz)
%         (4) pflag        - plot flag [1 - to plot] (0)
%         (5) nfft         - number of FFT points
%         (6) shift_ms     - frame shift in samples
%         (7) cep_channels - number of cepstral coefficients

% Outputs:
%         (1) log_sffspec  - envelopes at SF's till nyquist freq. (fs/2)
%         (2) sffcep       - SFF cepstrum using Homo-morphic Analysis 
%         (3) sffcepdd     - SFF Cepstrum with delta-delta features

% Dependencies: singleFrequencyFilt.m

% Coded by: Sivanand Achanta


% Step1: Set SFF Analysis Params
nfftby2 = round(nfft/2+1); % half-spectrum
fhz = linspace(0,fs,nfft); % full spectrum in Hz
hfhz = linspace(0,fs/2,nfftby2); % half-spectrum in Hz

% Step2: Get the SFF spectrum only till fs/2 (nyquist frequency)
[sffspec] = singleFrequencyFilt(y,fs,step_Hz,0,hfhz);

% Step2.1: SFF spectrum is inverted so invert again to get the true spectrum
sffspec = flipud(sffspec);

% Step2.2: Down sample temporally the SFF spectrum
ss_vec = 1:shift_ms:size(sffspec,2); % sub-sampling vector
sffspec = sffspec(:,ss_vec);

% Step2.3: Compute full Log-Spectrum
log_sffspec = 20*log10(sffspec);
log_sffspec = [log_sffspec;flipud(log_sffspec(2:end-1,:))];

% Cepstral/Homo-morphic analysis for spectrum envelope estimation from SFF Spectrum
% Step3: Compute Cepstrum
sffcep = real(ifft(log_sffspec,nfft));

% Step3.1: Design the cepstral analysis window (rectangual window used here)
cepwin = [ones(cep_channels,1);zeros(nfftby2-cep_channels,1)];
sffcepliftered = bsxfun(@times,sffcep(1:nfftby2,:),cepwin);

% Step3.2: Make symmetric liftered cepstrum
sffcepliftered = [sffcepliftered;flipud(sffcepliftered(2:end-1,:))];
sffse = real(fft(sffcepliftered,nfft));
sffse = sffse(1:nfftby2,:);

% Step4: SFF Cepstra and delta-delta features
sffcepfeats = sffcepliftered(1:cep_channels,:);
% Append deltas and double-deltas onto the cepstral vectors
del = deltas(sffcepfeats);
% Double deltas are deltas applied twice with a shorter window
ddel = deltas(deltas(sffcepfeats,5),5);
% Composite, 39-element feature vector, just like we use for speech recognition
sffcepdd = [sffcepfeats;del;ddel];

% Frame-wise spectrum and cepstrum plot (1-d)
if pflag
    for i = 1:size(sffspec,2)
        subplot(411); plot(y((i-1)*shift_ms+1:(i+10)*shift_ms)); axis tight; title('Waveform');
        subplot(412); plot(hfhz, log_sffspec(1:nfftby2,i)); axis tight; hold on ;
        plot(hfhz, sffse(1:nfftby2,i), 'r-'); axis tight; hold off; title('SFF Spectrum with Envelope');
        
        subplot(413); plot((1:nfftby2)/fs, sffcep(1:nfftby2,i)); axis tight; title('SFF Cepstrum');
        subplot(414); plot((1:nfftby2)/fs, sffcepliftered(1:nfftby2,i), 'r-'); axis tight; title('Liftered SFF Cepstrum');
        
        pause
    end
    
    % Spectrographic plot (2-d)
    % xax = [501:1000]*shift_ms/fs;
    % yax = hfhz;
    % [X,Y] = meshgrid(xax,yax);
    % surf(X,Y,se(1:nfftby2,501:1000),'edgecolor','none'); view(0,90);
    
end

end

