% Filter check

clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1
% FIR filter design with the window method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% User parameters
% Sampling frequency in Hz
Fs = 1000.0;
% Filter order
%     For LP and BP, N can be any order
%     For HP and BS, N must be even
N  = 30;
% Cutoff frequency
%     For LP and HP, Fc is a single value
%     For BP and BS, Fc is an ordered array [fc1 fc2]
Fc = 120.0;
% Filter window
%     Check matlab help for available windows
W  = window(@rectwin,N+1);

% Computation
% Normalized cutoff frequency
Fn = 2.0*Fc/Fs;
% Digital FIR filter with the window method
%     LP 'low'     HP 'high'     BP 'bandpass'     BS 'stop'
a  = fir1(N,Fn,'low',W);
figure(1);
freqz(a);

% Calculo directo de la funcion normalizada [-1,1]
NN = 1024;
for i=0:NN-1
    P1 = 2.0*pi*(Fc)*i/(Fs);
    P2 = 2.0*pi*(Fc+60)*i/(Fs);
    P3 = 2.0*pi*(Fc+120)*i/(Fs);
    S(i+1) = 0.5 + (0.1*sin(P1)) + (0.1*sin(P2)) + (0.15*sin(P3));
end;

b = 1.0;
y1 = filter(a,b,S);


figure(2);stem(S,'r.');
figure(3);stem(y1,'.');
