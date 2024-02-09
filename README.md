# Sound_Tech-Projects
<h3> Sound Technology - Signal Processing using Matlab Routines</h3> <br>
<br>
In this course -roughly translated- "Technology of Sound" Matlab is used to solve various problems<br>
involving signal processing methods as their basis (e.g Short-Time Fourier Transform). Three individual projects are implemented. <br>
<br>
<h5>1st Project</h5>
<ins>Part 1</ins>: Using STFT we deconstruct a signal and analyse it in N-frames in the frequency domain. Then we reconstruct it <br>
with the inverse procedure to showcase the STFT accuracy and how it actually works. <br>
<ins>Part 2</ins>: Detect the onset of individual notes that are played in a sound clip based on the energy(magnitude) of the FFT that is shown <br>
in the time domain or the phase or the combination of the two. <br>
<ins>Part 3</ins>: Based on part 2, find the bpm (rhythm) of the sound clip. Obviously this implementation works on songs-sound clips <br>
where a musical instrument-sound works as a metronome, meaning that its onsets are prominent and rhythmically steady.
<br>
<h5>2nd Project</h5>
The purpose of this project is to classify musical instruments. The backbone of our solution are two machine learning algorithms for training.
Our first model is produced by K-MEANS-clustering and the second one by gaussian distribution. This is essentially how we train and validate our models. 
Then we calculate some metrics to assess our models' performance. The training is done using either LPC or MFCC coeeficients which define the key characteristics 
of each individual instrument. <br>
<br>
<h5>3rd Project</h5> 
<br>
In this project we have to implement 3 different sound effects. Distortion, Rotary (Speakers) & Reverb (Schroeder Reverberator model). 
The implementation is pretty straightforward. We create a function for each effect based on their respective system functions-block diagrams,
and pass the signal through this effect (function).
