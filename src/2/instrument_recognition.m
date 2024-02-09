function [instrument_test_results]  = instrument_recognition(MFCCinstrument, mi)

%testing phase 
%let piano be prototype instrument(or column in the test matrices)
% n.1, flute n.2, cello n.3, guitar n.4 in our example

n_learning = 4000;
n_of_tests = size(MFCCinstrument,1) - n_learning;
n_of_coeffs = size(MFCCinstrument,2);
n_of_instruments = size(mi,1);

for i = (n_learning+1):(n_learning+n_of_tests)
    
    instrument_tests(i,1:n_of_instruments) = 0;
    
    for k = 1:n_of_coeffs
        for j = 1:n_of_instruments
            instrument_tests(i,j) = instrument_tests(i,j) + ( MFCCinstrument(i,k) - mi(j,k) )^2;
        end
    end
    
    instrument_tests(i,:) = sqrt(instrument_tests(i,:));
    
    %distance between a test vector and an instrument-prototype
    %is stored in instrument_tests likewise: 
    %test-prototype_piano(column 1)
    %test-prototype_flute(column 2)
    %test-prototype_cello(column 3)
    %test-prototype_guitar(column 4)
    
    %every row in the test matrices coresponds to a different test

    %let's store the column index for every minimum distance in every test
    
    %with all the above we know that 1s' correspond to piano recognitions
    %2s' to flute recognitions etc
    [~, instrument_test_results(i)] = min(instrument_tests(i,:));
    
end

%could have avoided the lines below, by transforming 
%the index of instrument_tests in the for-loop likewise: i -> (i-n_learning)
%but didn't for aesthetic purposes
instrument_tests (1:4000,:) = [];
instrument_test_results (1:4000) = [];

end
