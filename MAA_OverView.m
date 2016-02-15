%% Matlab Audio Analysis

[x,Fs] = audioread('twoMaleTwoFemale20Seconds.wav');
v = audioread('babble30Seconds.wav');

%% Windows
% Hanning window -
% y = MAA_HannWindows(windowLength,type (Periodic-'p',Casual-'c',Generalised-'g')
y = MAA_HannWindows(1024,'p');

% Hamming window -
% y = MAA_HammWindows(windowLength,type (Symetric-'s',Periodic-'p')
y = MAA_HammWindows(1024,'p');

%% Mix Signal and Noise to Ratio
% y(input+Noise) = (Signal,Noise,Ratio(eg 1/1))

y = MAA_SNR(x,v,1/1);

%% STFT - Short Time Fourier Transform
% y = (x,windowSize,overlap)

y = MAA_STFT(x,1024,0.5);

%% Weiner Filter (Time Domain) -  removes sampled noise (v) from input(x)
% y= (sig,noiseSamp,forgetFactX,forgetFactV,windowLength,RegParameter)

% create noisy signal
y = MAA_SNR(x,v,1/1);
% get sample of noise
vw = v(length(x):end);
%forgetting factor for input/noise sample
forgetFactX = 0.995;
forgetFactV = 0.995;
% window size
windowLength = 40;
% Regularisation Parameter
regParam = 1e-10;
% Call weiner function
y = MAA_WeinerFilter(y,vw,forgetFactX,forgetFactV,windowLength,regParam);

soundsc(y,Fs);

%% SNAC Pitch Detection - inefficent, do not recomend long sounds!
% y(vector of pitches)= (input,sampleRate,window size)

y = MAA_SNAC(x,Fs,2048);
