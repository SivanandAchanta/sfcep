# sfcep
Single Frequency Cepstral Coefficients

This toolbox provides codes for extracting single frequency filtering based features

The following features are extracted for a given speech signal:
[1] SFF Spectrum             - Magnitude spectrum obtained using SFF
[2] SFF Cepstrum             - Cepstrum obtained using Homo-morphic analysis on SFF spectrum
[3] SFF Cepstrum with deltas - These are like 39-dimensional MFCC features but extracted from SFF Cepstrum

% Example
The wavefiles should be placed in the "wav/" directory inside the "sfcep/" directory
Run "extract_sfcep.m" script and the features for the wavefile are stored in "sfcc/" folder



