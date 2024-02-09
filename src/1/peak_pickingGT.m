function [X_Point, distance] = peak_pickingGT(R_DE, R_DE_length)

center = floor(R_DE_length/2) + 1;

m = 1;
for i = center+1 : R_DE_length-1
    if (R_DE(i) > R_DE(i-1)) && (R_DE(i) > R_DE(i+1))
        R_DEmaximas(m) = R_DE(i);
        R_DEpeakpoints(m) = i; %apothikeuoume me th seira poy vriskontai ta akrotata to diakrito k,n oti einai
        m = m+1;
    end
end

[sorted_maximas, sorted_peakpoints] = sort(R_DEmaximas, 'descend'); %soerted peakpoints krata tous deiktes m twn taksinomhmenwn akrotatwn
index  = sorted_peakpoints(1);                                         %h sorted peakpoints krata gia 1h timh px to index ths megisths timhs 
X_Point = R_DEpeakpoints(index);                                        %mesa ston pinaka R_DE MAXIMAS. ayto omws den antapokrinetai sto pragmatiko i
                                                                        % alla
                                                                        % sto                                                                      % m                                                                        % /                                                                       % deixnei
 %deixnei poy vrisketai h timh sorte_maxima sto RDE MAXIMAS                                                                                                                                                                                                        % timh
                                                     
                                             

% Find the distance between second peakpoint and center of RDE
distance = abs(X_Point - center);

end