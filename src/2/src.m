%---------------------PROJECT 2 - SOUND TECH-----------------------

clear; 
clc;

%%--1a - LPC Factors--

frame = 256;
ovrlp = 0.25;
p = 29; 

[x1 Fs] = audioread("voice.wav");
X1 = frame_wind(x1, frame, ovrlp);

[a g] = LPC_Factor_Calc(X1,p)


%%--Mel-Frequency Cepstrum Coefficients (MFCC)--

[x2 Fs] = audioread("piano.wav");
MFCC = mfcc(x2, Fs, 'NumCoeffs',29);

%%--Instrument Recognition--

[x_piano Fs] = audioread("piano_samples.wav");
[x_flute Fs] = audioread("flute_samples.wav");
[x_cello Fs] = audioread("cello_samples.wav");
[x_guitar Fs] = audioread("e_guitar_samples.wav");

MFCCpiano = mfcc(x_piano, Fs, 'NumCoeffs',29);
MFCCflute = mfcc(x_flute, Fs, 'NumCoeffs',29);
MFCCcello = mfcc(x_cello, Fs, 'NumCoeffs',29);
MFCCguitar= mfcc(x_guitar, Fs, 'NumCoeffs',29);

n_learning = 4000;
n_instruments = 4;
MFCC = [MFCCpiano(1:n_learning,:); MFCCflute(1:n_learning,:); MFCCcello(1:n_learning,:); MFCCguitar(1:n_learning,:)];

%calculate mean-vector mi - Instrument ID
temp = [1:n_learning];
for i = 1:4
    mi(i,:) = mean(MFCC(temp,:));
    temp = temp + n_learning;
end

%Get the different indexes of minimum distances that correspond to different 
%instrument prototypes
piano_test_results = instrument_recognition(MFCCpiano,mi);
flute_test_results = instrument_recognition(MFCCflute,mi);
cello_test_results = instrument_recognition(MFCCcello,mi);
guitar_test_results = instrument_recognition(MFCCguitar,mi);

results = [piano_test_results;flute_test_results;cello_test_results;guitar_test_results];

for i=1:n_instruments
    for j=1:n_instruments
    plithos_indices(i,j) = sum(results(i,:)==j)
    end
    
end

figure();
cm = confusionchart(plithos_indices);

cm.XLabel = 'Recognised Instruments';
cm.YLabel = 'Actual Instruments';

cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

totalAccuracy = sum(diag(plithos_indices)) / sum(plithos_indices(:));

% Add the total accuracy to the confusion chart
cm.Title = sprintf('Confusion Matrix\nTotal Accuracy: %.2f%%', totalAccuracy*100);

% Calculate the covariance matrix

n_of_coeffs = size(mi,2);
temp1 = [1:n_learning];
temp2 = [1:n_of_coeffs];
for i = 1:4
    si(temp2,:) = cov(MFCC(temp1,:));
    temp1 = temp1 + n_learning;
    temp2 = temp2 + n_of_coeffs;
end

p_piano = PDF(MFCCpiano, mi, si);
p_flute = PDF(MFCCflute, mi, si);
p_cello = PDF(MFCCcello, mi, si);
p_guitar = PDF(MFCCguitar,mi, si);


P = [p_piano; p_flute; p_cello; p_guitar]

figure();
cm = confusionchart(P);

cm.XLabel = 'Recognised Instruments';
cm.YLabel = 'Actual Instruments';

cm.RowSummary = 'row-normalized';
%cm.ColumnSummary = 'column-normalized';

totalAccuracy = sum(diag(P)) / sum(P(:));

% Add the total accuracy to the confusion chart
cm.Title = sprintf('Confusion Matrix\nTotal Accuracy: %.2f%%', totalAccuracy*100);


%---------------------------------------------------------


%%--Same Implementation using LPC coefficients--

Xpiano = frame_wind(x_piano, frame, ovrlp);
Xflute = frame_wind(x_flute, frame, ovrlp);
Xcello = frame_wind(x_cello, frame, ovrlp);
Xguitar = frame_wind(x_guitar, frame, ovrlp);

a_piano = LPC_Factor_Calc(Xpiano,p);
a_flute = LPC_Factor_Calc(Xflute,p);
a_cello = LPC_Factor_Calc(Xcello,p);
a_guitar = LPC_Factor_Calc(Xguitar,p);

a_piano(:,4284:14796) = [];
a_flute(:,4284:14796) = [];
a_cello(:,4284:14796) = [];
a_guitar(:,4284:14796) = [];

a_piano = a_piano';
a_flute = a_flute';
a_cello = a_cello';
a_guitar = a_guitar';

a = [a_piano; a_flute; a_cello; a_guitar];

%calculate mean-vector mi - Instrument ID
temp = [1:n_learning];
for i = 1:4
    mi(i,:) = mean(a(temp,:));
    temp = temp + n_learning;
end

%Get the different indexes of minimum distances that correspond to different 
%instrument prototypes
piano_test_results = instrument_recognition(a_piano,mi);
flute_test_results = instrument_recognition(a_flute,mi);
cello_test_results = instrument_recognition(a_cello,mi);
guitar_test_results = instrument_recognition(a_guitar,mi);

results = [piano_test_results;flute_test_results;cello_test_results;guitar_test_results];

for i=1:n_instruments
    for j=1:n_instruments
    plithos_indices(i,j) = sum(results(i,:)==j)
    end
    
end

figure();
cm = confusionchart(plithos_indices);

cm.XLabel = 'Recognised Instruments';
cm.YLabel = 'Actual Instruments';

cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

totalAccuracy = sum(diag(plithos_indices)) / sum(plithos_indices(:));

% Add the total accuracy to the confusion chart
cm.Title = sprintf('Confusion Matrix\nTotal Accuracy: %.2f%%', totalAccuracy*100);

% Calculate the covariance matrix

n_of_coeffs = size(mi,2);
temp1 = [1:n_learning];
temp2 = [1:n_of_coeffs];
for i = 1:4
    si(temp2,:) = cov(a(temp1,:));
    temp1 = temp1 + n_learning;
    temp2 = temp2 + n_of_coeffs;
end

%because the 1st LPC factor of each instrument has zero covariance
%mvnpdf fails as a routine to calculcate the probability p.
p_piano = PDF(a_piano, mi, si);

% p_flute = PDF(a_flute, mi, si);
% p_cello = PDF(a_cello, mi, si);
% p_guitar = PDF(a_guitar,mi, si);
% 
% 
% P = [p_piano; p_flute; p_cello; p_guitar]
% 
% figure();
% cm = confusionchart(P);
% 
% cm.XLabel = 'Recognised Instruments';
% cm.YLabel = 'Actual Instruments';
% 
% cm.RowSummary = 'row-normalized';
% %cm.ColumnSummary = 'column-normalized';
% 
% totalAccuracy = sum(diag(P)) / sum(P(:));
% 
% % Add the total accuracy to the confusion chart
% cm.Title = sprintf('Confusion Matrix\nTotal Accuracy: %.2f%%', totalAccuracy*100);

