function y = reverb_schroeder (x, type, mix)

%for aesthetic purposes
gAP = 0.7;

if type == 1
    
%coeffs of AP filters (Numerator b/ Denominator a)
bAP125 = [gAP, zeros(1,124), 1];
bAP42 = [gAP, zeros(1,41), 1];
bAP12 = [gAP, zeros(1,11), 1];

aAP125 = [1, zeros(1,124), gAP];
aAP42 = [1, zeros(1,41), gAP];
aAP12 = [1, zeros(1,11), gAP];

%coeffs of FBCF filters (Numerator b/ Denominator a)
bFBCFall = 1;

aFBCF901 = [1, zeros(1,900), 0.805];
aFBCF778 = [1, zeros(1,777), 0.827];
aFBCF1011 = [1, zeros(1,1010), 0.783];
aFBCF1123 = [1, zeros(1,1122), 0.764];

%calculate the output through the block diagram
e1 = filter(bFBCFall,aFBCF901,x) + filter(bFBCFall,aFBCF778,x) ...
    + filter(bFBCFall,aFBCF1011,x) + filter(bFBCFall,aFBCF1123,x);

e2 = filter(bAP125,aAP125,e1);
e3 = filter(bAP42,aAP42,e2);
y = filter(bAP12,aAP12,e3);

%add the dry signal to the final product
y = mix*y + x;

yL = y;
yR = -y;

y = [yL yR];

else if type == 2
        
%coeffs of AP filters (Numerator b/ Denominator a)
bAP1051 = [gAP, zeros(1,1050), 1];
bAP337 = [gAP, zeros(1,336), 1];
bAP113 = [gAP, zeros(1,112), 1];

aAP1051 = [1, zeros(1,1050), gAP];
aAP337 = [1, zeros(1,336), gAP];
aAP113 = [1, zeros(1,112), gAP];

%coeffs of FFCF filters (Numerator b/ Denominator a)
bFFCF4799 = [0.742, zeros(1,4798), 1];
bFFCF4999 = [0.733, zeros(1,4998), 1];
bFFCF5399 = [0.715, zeros(1,5398), 1];
bFFCF5801 = [0.697, zeros(1,5800), 1];

aFFCFall = 1;

%calculate the output through the block diagram
e1 = filter(bAP1051,aAP1051,x);
e2 = filter(bAP337,aAP337,e1);
e3 = filter(bAP113,aAP113,e2);

y = filter(bFFCF4799,aFFCFall,e3) + filter(bFFCF4999,aFFCFall,e3) ...
    + filter(bFFCF5399,aFFCFall,e3) + filter(bFFCF5801,aFFCFall,e3);

%add the dry signal to the final product
y = mix*y + x;

yL = y;
yR = -y;

y = [yL yR];
    else 

    disp("error occured while passing type argument");
    y = 1;
    quit force;
    end
end
end