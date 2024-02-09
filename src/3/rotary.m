function [yL yR] = rotary(x, M1, M2, depth1, depth2, f1, f2, fs)

n = size(x,1);

for i=1:n
    delay_unitL(i) = M1 + depth1 * sin(2*pi*f1*i/fs);
    delay_unitR(i) = M2 - depth2 * sin(2*pi*f2*i/fs);
end

k1 = ceil(max(delay_unitL));
k2 = ceil(max(delay_unitR));

if k1<k2
    for i = (k1+1):k2
        yL(i) = x(i - ceil(delay_unitL(i))) * (1 - sin(2*pi*f1*i/fs));
    end
    
    for i = (k2+1):n
        yL(i) = x(i - ceil(delay_unitL(i))) * (1 - sin(2*pi*f1*i/fs)) ;
        yR(i) = x(i - ceil(delay_unitR(i))) * (1 + sin(2*pi*f2*i/fs));
    end

else 
    for i = (k2+1):k1
        yR(i) = x(i - ceil(delay_unitR(i))) * (1 + sin(2*pi*f2*i/fs));
    end
    
    for i = (k1+1):n
        yL(i) = x(i - ceil(delay_unitL(i))) * (1 - sin(2*pi*f1*i/fs));
        yR(i) = x(i - ceil(delay_unitR(i))) * (1 + sin(2*pi*f2*i/fs));
    end
end

yL = yL + (0.7*yR); 
yR = yR + (0.7*yL);

end