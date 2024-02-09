                                                    %PROJECT 1

clear;
clc;

%%
%Read wav file
[x, Fs] = audioread('guit1.wav');

Fs; % = 16000 - sample rate
size(x); % = 140278 samples extracted from wav file

plot(x);
freqz(x);

%test original file
%soundsc(x,16000);

%deconstruct-reconstruct audio file
frame = 256;
ovrlp = 0.5;

X = frame_wind(x,frame,ovrlp);
y = frame_recon(X,ovrlp);

%test de/re-constructed file
%soundsc(y,16000);

%%
frame = 512;
ovrlp = 0.5; %CAUTION:deixnei poso DEN exoume overlap

[x, Fs] = audioread('piano.wav');

X = frame_wind(x,frame,ovrlp);
[rows, cols] = size(X);

%FFT For every column-frame

XF = fft(X);
XFmag = abs(XF);
XFphase = angle(XF);

%onset-spike / Energy Method

dE(:,1) = XFmag(:,1); %initialise first dE column outisde loop, to save resources
for f=1:rows
    for k=2:cols
        dE(f,k) = XFmag(f,k) - XFmag(f,k-1);
    end
end

for k=2:cols
    DE(k) = 0;
    for f=1:rows
        DE(k) = DE(k) + dE(f,k);
    end
    DE(k) = abs(DE(k));
end

n = [1:cols];
figure();
plot(n,DE);

%onset-spike / Phase angle method
dPH1(: ,1) = zeros(rows , 1);
dPH1(: ,2) = wrapToPi(2*XFphase(: ,1));
for f=1:rows
    for k=3:cols
        dPH1(f,k) = wrapToPi(2*XFphase(f,k-1) - XFphase(f,k-2));
    end
end

for f=1:rows
    for k=1:cols
        dPH(f,k) = wrapToPi(XFphase(f,k) - dPH1(f,k));
    end
end

for k=1:cols
    DPH(k) = 0;
    for f=1:rows
        DPH(k) = DPH(k) + (abs(dPH(f,k)))^2;
    end
end

figure();
plot(DPH);

%complex numbers method

dC(:,1) = XF(:,1);
for f=1:rows
    for k=2:cols
        dC(f,k) = XF(f,k) - (XFmag(f,k-1))*exp(1j*dPH1(f,k));
    end
end

for k=1:cols
    DC(k) = 0;
    for f=1:rows
        DC(k) = DC(k) + (abs(dC(f,k)))^2;
    end
end

figure();
plot(DC);

%%
R_DE = xcorr(DE, DE);
figure();
plot(R_DE)
 
[X_Point distance] = peak_pickingGT(R_DE, length(R_DE))

%Frame distance to BPM Conversion

%Frames to samples
Samples = distance*frame*ovrlp;
BPM(1) = (Fs/Samples)*60 

%Same for DPH
R_DPH = xcorr(DPH, DPH);
figure();
plot(R_DPH)

[X_Point distance] = peak_pickingGT(R_DPH, length(R_DPH))

Samples = distance*frame*ovrlp;
BPM(2) = (Fs/Samples)*60

%Same for DC
R_DC = xcorr(DC, DC);
figure();
plot(R_DC)

[X_Point distance] = peak_pickingGT(R_DC, length(R_DC))

Samples = distance*frame*ovrlp;
BPM(3) = (Fs/Samples)*60





