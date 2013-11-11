function filtered = gaussian(data, window, srate)

%window is number of points on each side of current point that you want to
%consider
window = window*2;

b = gausswin(window);

[H, W] = freqz(b, 1, 10000);
index = find(abs(H)<(0.70710678118654752440084436210485*H(1)),1,'first'); %find index of first value that is less than 0.5 in magnitude
period3dB = (2*pi)/(60*srate*W(index));

filtered = filtfilt(gausswin(window)/sum(gausswin(window)), 1, data);