function y = nonlinear(x, gn, gp, mix) 

%----Effect Parameters - Pedal Knobs-----
gpre=20; gbias=1; gpost=1; gdry=0; %gwet=1; 
fc=5; kn=2; kp=2; Fs = 16000;

%calculate H_LPF coeffs before implementation
k = tan(pi*fc/Fs);
D = 1 + sqrt(2)*k + k^2;
b0=k^2/D; b1=2*b0; b2=b0; a1=2*(k^2-1)/D; a2=(1-sqrt(2)*k+k^2)/D;  
b = [b0 b1 b2]; a = [1 a1 a2];

%pre-amp of the signal
x = x * gpre;

%branching in dry... 
x_dry = x * gdry;

%...and wet
x_wet = abs(x);
x_wet = filter(b, a, x_wet) * gbias;
x_wet = x - x_wet;

%calculate m(x) before implementation
m1 = tanh(kp) - ((tanh(kp)^2 - 1)*tanh(gp*x_wet-kp)/gp);
m2 = tanh(x_wet);
m3 = -tanh(kn) - ((tanh(kn)^2 - 1)*tanh(gn*x_wet+kn)/gn);

m =  m1 .* heaviside(x_wet-kp) + m2 .* heaviside(kp-x_wet) .* heaviside(x_wet+kn) + m3 .* heaviside(-x_wet-kn);

%mix wet and dry signals
x_wet = x_wet .* m * mix;

y = (x_dry + x_wet) * gpost;

end


