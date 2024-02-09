%--------------------------PROJECT 3------------------------------
clear;
clc;

fs = 16000;
%-----Distortion Effect------
x_guitar = audioread("guitar1.wav");
x_vocals = audioread("vocals.wav");

gn = [5 30 20 15];
gp = [5 30 20 25];
mix = 1;

y = [];

for i=1:size(gn,2)
    dist_guitar(:,i) = nonlinear(x_guitar, gn(i), gp(i), mix);
    dist_vocals(:,i) = nonlinear(x_vocals, gn(i), gp(i), mix);
end

figure('Name','Guitar - Clean','NumberTitle','off');
specgram(x_guitar)
figure('Name','Vocals - Clean','NumberTitle','off');
specgram(x_vocals)

for i=1:size(gn,2)
   
    str = sprintf("Dist %d",i);
    
    figure('Name','Guitar - ' + str,'NumberTitle','off');
    specgram(dist_guitar(:,i))
    figure('Name','Vocals - ' + str,'NumberTitle','off');
    specgram(dist_vocals(:,i))
end

soundsc(dist_guitar(:,1),fs) 
w = waitforbuttonpress;
soundsc(dist_guitar(:,2),fs)
w = waitforbuttonpress;

%-----Rotary Effect------

M1 = [800 650]; M2 = [500 400]; depth1 = [80 65]; depth2 = [50 40]; 
f1 = [1.06 0.9]; f2 = [0.88 0.5];

for i=1:size(M1,2)
    [rotary_guitarL(:,i), rotary_guitarR(:,i)] = rotary(x_guitar, M1(i), M2(i), depth1(i), depth2(i), f1(i), f2(i), fs);
    [rotary_vocalsL(:,i), rotary_vocalsR(:,i)] = rotary(x_vocals, M1(i), M2(i), depth1(i), depth2(i), f1(i), f2(i), fs);
end

rotary_vocals1 = [rotary_vocalsL(:,1), rotary_vocalsR(:,1)];
rotary_vocals_combined = [rotary_vocalsL(:,1)+rotary_vocalsL(:,2), rotary_vocalsR(:,1)+rotary_vocalsR(:,2)];
rotary_guitar_combined = [rotary_guitarL(:,1)+rotary_guitarL(:,2), rotary_guitarR(:,1)+rotary_guitarR(:,2)];

soundsc([rotary_guitarL(:,1), rotary_guitarR(:,1)],fs)
w = waitforbuttonpress;
soundsc(rotary_guitar_combined,fs)
w = waitforbuttonpress;
%-----Reverb Effect------
mix = 0.4;

reverb_guitar1 = reverb_schroeder (x_guitar, 1, mix);
reverb_guitar2 = reverb_schroeder (x_guitar, 2, mix);

reverb_vocals1 = reverb_schroeder (x_vocals, 1, mix);
reverb_vocals2 = reverb_schroeder (x_vocals, 2, mix);

soundsc(reverb_vocals1,fs)
w = waitforbuttonpress;
soundsc(reverb_vocals2,fs)
w = waitforbuttonpress;

%---------Signal Chain--------------
Dist_Rot_Rev = nonlinear(x_guitar, gn(1), gp(1), mix);
%Dist_Rot_Rev = rotary(Dist_Rot_Rev, M1(1), M2(1), depth1(1), depth2(1), f1(1), f2(1), fs);
Dist_Rot_Rev = reverb_schroeder (Dist_Rot_Rev, 1, 0.7);

soundsc(Dist_Rot_Rev,fs)
w = waitforbuttonpress;

Rev_Rot_Dist = reverb_schroeder (Rev_Rot_Dist, 1, 0.7);
Rev_Rot_Dist = nonlinear(x_guitar, gn(1), gp(1), mix);
%Dist_Rot_Rev = rotary(Dist_Rot_Rev, M1(1), M2(1), depth1(1), depth2(1), f1(1), f2(1), fs);

soundsc(Rev_Rot_Dist,fs)