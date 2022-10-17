% ---------------------------------------------------------------------
%  Simple bottlenose dolphin click detector with easy classification 
% --------------------------------------------------------------------- 
% The click detector is based on: 
%     Walter M. X. Zimmer, Passive Acoustic Monitoring of Cetaceans
%     2011, ISBN:  9780511977107, Chapter 4.1
% The classification parameters are based on: 
%      A. Luís, M. Couchinho, M. dos Santos, 
%      A Quantitative Analysis of Pulsed Signals Emitted by Wild 
%      Bottlenose Dolphins 
%      DOI: https://doi.org/10.1371/journal.pone.0157781
% Coder: Rocco De Marco - rocco.demarco@irbim.cnr.it (c) 2022
% ---------------------------------------------------------------------
% Please note that the function do_SimpleDetection0 is NOT included
% in this release, since it is the same showed in chapter 4.1 of the
% cited Zimmer et al. book.
% ---------------------------------------------------------------------
% Usage:
%      This software has been developed and tested using GNU octave,
%      version 5.2.0.
%      A full/relative path filename of the wavefile to be processed 
%      can be passed as command line argument.
%      A recording block to be used as noise referece must be specified
%      assigning the correct filename to the noise_wav variable 
%
% Output:
%      Peaks are detected and (pseudo) classified and printed directly
%      on the standard output
% ---------------------------------------------------------------------


pkg load signal

cmd = argv();
noise_wav = "record001.wav";

% read filename from commandline (first argument)
[wave, br] = audioread(cmd{1});
[noise, br_noise] = audioread(noise_wav);

% Threshold
th = 4.5;

% Pruning window size
t_max = 5/10000;	% 0.5ms


% time vector
tt = (1: length(wave))'/br;

% constant offset removal
ss = wave - mean(wave);
ss2 = noise - mean(noise);

% Noise estimation over complete wave
nn = sqrt ( mean (ss2.^2));


% signal-to-noise ratio
snr = abs(ss)/nn;

% Simple peak detection
peaks = do_SimpleDetection0(snr,tt,th,t_max);

% peaks time vector
t_peaks = tt(peaks);


% time vector of detections
tdet=[];

% detection classification
% 1: squawk
% 2: spb
% 3: creack
% 4: Slow click train
det=[];



printf ("Time offset\tSNR level\tICInterval\tCLASS\n");

# for each peak found:
for ii=1:length(t_peaks)-1
   current=t_peaks(ii);
   % inter click interval with the next peak
   ici=t_peaks(ii+1)-current;
   
   % if the interval is below 7 ms
   if (ici < 0.007)
      % taking a time window of 0.06 second
      T_end=tt(peaks)(ii)+0.06;
      % we count the number of peak inside the time window
      nn=length(t_peaks(t_peaks>=current & t_peaks<T_end));
      % since the squawk have an expected ICI of 2ms, we expect more the 15 peaks inside
      if (nn>15)
         % storing possible squawk
         tdet=[tdet;t_peaks(ii)];
         det=[det;1]; 	%squawk
         printf ("%f\t%f\t%f\t%d\n",current,snr(peaks(ii)),ici,1);
      % otherwise if the peaks number is between 7 and 15 we consider those as possible sbp 
      elseif (nn>=7 && nn<=15)
         tdet=[tdet;t_peaks(ii)];
         det=[det;2]; 	%spb
         printf ("%f\t%f\t%f\t%d\n",current,snr(peaks(ii)),ici,2);
      else
         m="skipping"
      endif
   % clicks with ici between 0.007 and 0.027 are considered as possible creak
   elseif (ici>=0.007 && ici<0.027)
      tdet=[tdet;t_peaks(ii)];
      det=[det;3]; 	%creak
      printf ("%f\t%f\t%f\t%d\n",current,snr(peaks(ii)),ici,3);
   % all the others are considered as possible slow click train   
   elseif (ici>=0.027 && ici<1)   
      tdet=[tdet;t_peaks(ii)];
      det=[det;4]; 	%ClickTrain        
      printf ("%f\t%f\t%f\t%d\n",current,snr(peaks(ii)),ici,4);
   endif     
end




