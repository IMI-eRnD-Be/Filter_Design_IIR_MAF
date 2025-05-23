clc;
close all;
clear all;

%% IIR design
pkg load signal

N = 2;                   % Filter order
fcut = 0.0625;                % In Hz
Omega_cut = 2*pi*fcut;
Ts = 0.4;                % Sampling time in seconds
Fgost = 1 / Ts;
plot_fre_factor = 0.40;    % Scale X axis for frequency plots (BODE)

wn = (2/pi) * (atan(Omega_cut * Ts / 2));
[b, a] = butter(N, wn);

[db_but,mag_but,pha_but,grd_but,w] = freqz_m(b, a);

figure(1)
subplot(2,1,1); plot(Fgost.*w/(2*pi), db_but);title('Magnitude Response in dB IIR');grid
axis([0 plot_fre_factor*Fgost/2 -100 10]); xlabel('frequency in Hz'); ylabel('Decibels')

subplot(2,1,2);
plot(Fgost.*w/(2*pi), mag_but);title('Attenuation Response IIR');grid
axis([0 plot_fre_factor*Fgost/2 -0.05 1.05]); xlabel('frequency in Hz'); ylabel('Degrees')

figure (2)
sys = tf (b, a, Ts)
bode(sys)
