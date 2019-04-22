%% This script takes a csv file from parcellate.m and computes for each 
% parcell (columns) the Power spectrum with 3 different ways 
% in 4 different representations:
% Power spectrum analysis (spa) and Furrier Analysis (etfe)computes a Hz 
% by dBpower plot
% Fast Furrier Transform computes a log-Hz by dBMagnitude, a two sided 
% (minus-plus) radius/sec by dBMagnitude and
% (Probably most relevant to BOLD) HzFrequency by dBPower

% 3 different jpeg files are spitted out and a combined 'PSD_Full.jpeg'
%% Written by Stavros Trakoshis 26/06/2018
%%%

%% Enter Path, Data and fixed parameters
rootpath = '~/Desktop/3dRSFC';
cd(rootpath);
% make directory for ouput
mkdir('POWERSPECTRUM')
PSDpath = fullfile(rootpath, 'POWERSPECTRUM')

data = readtable('result.csv');
Ardata = table2array(data);
% Enter TR
Ts = 1.302000;

% calculate length of parcellation
ncol = size(Ardata, 2);




%% Loop over each parcel
% N = size(Ardata,1);
for K = 1:ncol
    disp(K)
    tmp_data = Ardata(:,K);
    %disp(tmp_data)
    
    % length of the sample/signal - Hz will be calculated by this
    N = length(tmp_data);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Args for the future
    %Niquist frequency as the half of the sampling rate, in seconds in
    %this case. It doesn't get used here, but can be in the future
    %FrNiquist = Ts/2
    
    % if for some reason you want to avoid negative values in the frequency 
    % calculations uncheck this and replace further down.
    % It doesn't get used here, but can be in the future
    % SQRtmp_data = power(tmp_data, 2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Here we need to take the name of the parcel for naming jpegs
    % depends on itteration of course
    var_names = sprintf('parcel_%03d',K);
    firstfig = strcat(var_names, 'Rad-dBpower_powerspectrum.jpeg');
    secndfig = strcat(var_names, 'DCB-log_powerspectrum.jpeg');
    thirdfig = strcat(var_names, 'DCB-FREQ_powerspectrum.jpeg');
    
    FullCnct = strcat(var_names, 'PSD_Full.jpeg');
    
    %% Continuing 
    % make it a frequency(iddata) data, Ts = TR
    Frdata = iddata(tmp_data, [], Ts);
    
    % Some other ways to calculate power spectrum
    % Power spectrum analysis with SD - spa, Fourrier transform etfe
    
    G = spa(Frdata);
    B = etfe(Frdata);
    bode(G,B);
    saveas(gcf, fullfile(PSDpath, firstfig))
    
    
    % Fast Fourier Transform - fft in frequency data + plot, gives log plot
    % by dB
    F = fft(Frdata);
    plot(F);
    saveas(gcf, fullfile(PSDpath,secndfig))
    
    %absolute fft from raw data
    AbsF = abs(fft(tmp_data));
    %%Plot arguments for log-log plot and Hz-Power plot
    
    %Have the x-axis start from 0 to sample
    Freq_bins = [0:N-1];
    
    %Hertz axis divided by the TR per sample (yeah, maths!)
    Freq_Hertz = Freq_bins*Ts/N;
    
    %Decimbel axis (MATHS, YEAH!) + plot with H
    N_2 = N/2;
    plot(Freq_Hertz(1:N_2),AbsF(1:N_2));
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)');
    title('PSD (Hertz)');
    axis tight;
    saveas(gcf, fullfile(PSDpath,thirdfig))
    
    disp('We made it this far')
    %spectrum(G, B)
    
    %% Add images together
    %I could have done subplots but bode above doesn't like it
    alpha = imread(fullfile(PSDpath,firstfig));
    beta = imread(fullfile(PSDpath,secndfig));
    gama = imread(fullfile(PSDpath,thirdfig));
    threeimag = [alpha, beta, gama];
    
    
    imwrite(threeimag, fullfile(PSDpath, FullCnct))
    
    %Unlock the following to free space by removing individual images 
    % - not recommended
    %!rm *DCB-log_powerspectrum.jpeg *DCB-FREQ_powerspectrum.jpeg ...
    %    *Rad-dBpower_powerspectrum.jpeg
    
    
    
end
