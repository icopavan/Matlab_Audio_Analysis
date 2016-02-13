function z = MAE_SNAC(x,Fs,Ws)
[x,Fs] = audioread('gtr.wav');

% Specially Normalised Autocorrelation in the time domain. Its very slow!

% out vector of pitches
z = zeros(length(x),1);
% number of windows
numWin = floor(length(x)/Ws);

for i = 1:numWin
    % windowed input signal
    xW = x((Ws*(i-1))+1:Ws*i,:);
    % windowed input signal, shift buffer
    xWS = xW;
    R = zeros(Ws,1);
    for j = 1:Ws
        % % specially normalised = 2* sum(input .* shifted) / sum(input^2 + shifted^2)
        R(j) = (2*sum(xW(j:end) .* xWS(j:end))) ./ ...
            sum(pow2(xW(j:end)) .* pow2(xWS(j:end)));
        % shift along by one sample
        xWS = circshift(xWS,1);
    end
    disp(i);
    
    % normalise AC coeffs
    R(isnan(R)) = 0;
    R = R/max(abs(R));
    pks = findpeaks(R,'minpeakdistance',200);
    m=mean(pks);
    [pks,locs] = findpeaks(R,'minpeakheight',m/2);
    z((Ws*(i-1))+1:Ws*i) = (Fs / mean(diff(locs))) / 2;
end
