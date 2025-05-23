clc;
clear all;
close all;

Fp = 0.7;      % pass frequency In Hz
Fc = 0.7;      % stop frequency In Hz

M = 64;
Ts = 0.0125;
Fgost = 1 / Ts;

wp = 2*pi*Fp*Ts;
ws = 2*pi*Fc*Ts;

n=[0:1:M-1];
t=linspace(0,M*Ts,M);

wc = (ws+wp)/2, % Ideal LPF cutoff frequency
hd = ideal_lp(wc,M);      % Ideal filter but impossible to implement due to infinite elements

plot_fre_factor = 0.2;    % Scale X axis for frequency plots (BODE)

%% Moving Average Filter -> Rectangular
w_rect = boxcar(M);
w_rect = transpose(w_rect);
h_rect = hd .* w_rect;
h_rect = w_rect / M;      % To use rectangular window comment this line
                          % -> for MAF no ideal filter is used only average


[db_rect,mag_rect,pha_rect,grd_rect,w] = freqz_m(h_rect,[1]);

figure(1)
subplot(2,2,1); stem(t,hd); title('Ideal Impulse Response vs frequency');grid
axis([0 Ts*(M-1) -0.01 0.03]); xlabel('time'); ylabel('hd(n)')
subplot(2,2,2); stem(t,w_rect);title('Rectangular Window -> MAF');grid
axis([0 Ts*(M-1) 0 1.1]); xlabel('time'); ylabel('w(n)')
subplot(2,2,3); stem(t,h_rect);title('Rectangular MAF Impulse Response');grid
axis([0 Ts*(M-1) -0.01 0.03]); xlabel('time'); ylabel('h(n)')
subplot(2,2,4); plot(Fgost.*w/(2*pi),db_rect);title('Magnitude Response in dB MAF filter');grid
axis([0 plot_fre_factor*Fgost/2 -100 10]); xlabel('frequency in Hz'); ylabel('Decibels')

%% Hamming filter
w_ham = (hamming(M));
w_ham = transpose(w_ham);
h = hd .* w_ham;
[db,mag,pha,grd,w] = freqz_m(h,[1]);

delta_w = 2*pi/1000;
Rp = -(min(db(1:1:wp/delta_w+1))) % Actual Passband Ripple
As = -round(max(db(ws/delta_w+1:1:501))) % Min Stopband attenuation

% plots
figure(2)
subplot(2,2,1); stem(t,hd); title('Ideal Impulse Response');grid
axis([0 Ts*(M-1) -0.01 0.03]); xlabel('n'); ylabel('hd(n)')
subplot(2,2,2); stem(t,w_ham);title('Hamming Window');grid
axis([0 Ts*(M-1) 0 1.1]); xlabel('time'); ylabel('w(n)')
subplot(2,2,3); stem(t,h);title('Actual Impulse Response');grid
axis([0 Ts*(M-1) -0.01 0.03]); xlabel('time'); ylabel('h(n)')
subplot(2,2,4); plot(Fgost.*w/(2*pi),db);title('Magnitude Response in dB Hamming');grid
axis([0 plot_fre_factor*Fgost/2 -100 10]); xlabel('frequency in pi units'); ylabel('Decibels')

[dbid,magid,phaid,grdid,wid] = freqz_m(hd,[1]);
figure(3)
subplot(2,1,1); stem(t,hd); title('Ideal Impulse Response vs frequency')
axis([0 Ts*(M-1) -0.01 0.03]); xlabel('time'); ylabel('hd(n)')
subplot(2,1,2); plot(Fgost.*w/(2*pi),dbid);title('Magnitude Response in dB ideal filter');grid
axis([0 plot_fre_factor*Fgost/2 -100 10]); xlabel('frequency in Hz'); ylabel('Decibels')

%% IIR design

N = 2;                    % Filter order
fcut = 0.7;                % In Hz
Omega_cut = 2*pi*fcut;

wn = (2/pi) * (atan(Omega_cut * Ts / 2));
[b, a] = butter(N, wn);

[db_but,mag_but,pha_but,grd_but,w] = freqz_m(b, a);

figure(4)
plot(Fgost.*w/(2*pi),dbid);title('Magnitude Response in dB comparisson');
grid
hold
plot(Fgost.*w/(2*pi),db);
plot(Fgost.*w/(2*pi),db_rect);
plot(Fgost.*w/(2*pi),db_but);
legend('ideal', 'Hamming', 'Rectangular MAF', 'IIR Butterworth')
axis([0 plot_fre_factor*Fgost/2 -100 10]); xlabel('frequency in Hz'); ylabel('Decibels')

figure(5)
plot(Fgost.*w/(2*pi),magid / max(magid));
title('Magnitude Response in admin comparisson');
grid
hold
plot(Fgost.*w/(2*pi),mag / max(mag));
plot(Fgost.*w/(2*pi),mag_rect / max(mag_rect));
plot(Fgost.*w/(2*pi),mag_but / max(mag_but));
legend('ideal', 'Hamming', 'Rectangular MAF', 'IIR Butterworth')
axis([0 plot_fre_factor*Fgost/2 -0.05 1.05]); xlabel('frequency in Hz'); ylabel('Decibels')
