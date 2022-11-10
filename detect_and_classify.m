% ---------------------------------------------------------------------------- 
% The click detector is based on: 
%     Walter M. X. Zimmer, Passive Acoustic Monitoring of Cetaceans
%     2011, ISBN:  9780511977107, Chapter 4.1
% The classification parameters are based on: 
%      A. Luís, M. Couchinho, M. dos Santos, 
%      A Quantitative Analysis of Pulsed Signals Emitted by Wild 
%      Bottlenose Dolphins 
%      DOI: https://doi.org/10.1371/journal.pone.0157781
% Coder: Rocco De Marco - rocco.demarco@irbim.cnr.it (c) 2022
% ----------------------------------------------------------------------------
% Please note that the function do_SimpleDetection0 is NOT included
% in this release, since it is the same showed in chapter 4.1 of the
% cited Zimmer et al. book.
% ----------------------------------------------------------------------------


% Global variables -----------------------------------------------------------
noise_wav = "record001.wav";  % wavefile used as noise sample
th_rms = 10;                  % RMS threshold for peaks detection
th_bps = 0.017;               % ICI upper threshold for BPS classification
th_ct = 0.22;                 % ICI upper threshold for CT classification
tw_size = 2/1000;             % time window size for peaks detection (s)
step = 0.25;                  % time increment in classification (s)
window = 0.5;                 % time window size used in classification (s)
%-----------------------------------------------------------------------------
cmd = argv();
filename = "record001.wav" %cmd{1};
[wave, br] = audioread(filename);
[noise, br_noise] = audioread(noise_wav);
output_file = sprintf("%s.label.100_17.txt",filename);
tt = (1: length(wave))'/br;
cal = 10 ^ (27 / 20);
ss = wave - mean(wave);
ss = cal * ss;
noise_ss = noise - mean(noise);
noise_ss = cal * noise_ss;
nn = sqrt ( mean (noise_ss.^2));
snr = abs(ss)/nn;
peaks = do_SimpleDetection0(snr,tt,th_rms,tw_size);
output_fid=fopen(output_file,"w");
current=0;
types={"CT","BPS"};
cat=0;
while (current<max(tt))
   if ((current+step)<max(tt))
      last=current+step;
   else
      last=max(tt);
   endif
   if ((current+window)<max(tt))
      limit=current+window;
   else
      limit=max(tt);
   endif
   occurrences = length(tt(peaks)(tt(peaks)>=current & tt(peaks)<limit));
   if (occurrences > 0)
      ici_avg = window / occurrences;
      if (ici_avg > th_ct)
         if (cat>0) % ending the detection event
            fprintf (output_fid,"%f\t%s\n",current,types{cat});
            cat=0;
         endif
      else
         if (ici_avg <= th_bps)
            if (cat!=2)
               if (cat>0)
                  fprintf (output_fid,"%f\t%s\n",current,types{cat});
               endif
               cat=2;
               fprintf (output_fid,"%f\t",current);
            endif
         else
            if (cat!=1)
               if (cat>0)
                  fprintf (output_fid,"%f\t%s\n",current,types{cat});
               endif
               cat=1;
               fprintf (output_fid,"%f\t",current);
            endif
         endif
      endif
   else
      if (cat>0)
         fprintf (output_fid,"%f\t%s\n",last,types{cat});
         cat=0;
      endif
   endif
   current=last;
end
if (cat>0)
   fprintf (output_fid,"%f\t%s\n",last,types{cat});
   cat=0;
endif
fclose(output_fid);
