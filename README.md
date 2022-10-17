```
---------------------------------------------------------------------
Simple bottlenose dolphin click detector with easy classification 
--------------------------------------------------------------------- 
 The click detector is based on: 
     Walter M. X. Zimmer, Passive Acoustic Monitoring of Cetaceans
     2011, ISBN:  9780511977107, Chapter 4.1
 The classification parameters are based on: 
      A. Luís, M. Couchinho, M. dos Santos, 
      A Quantitative Analysis of Pulsed Signals Emitted by Wild 
      Bottlenose Dolphins 
      DOI: https://doi.org/10.1371/journal.pone.0157781
 Coder: Rocco De Marco - rocco.demarco@irbim.cnr.it (c) 2022
---------------------------------------------------------------------
 Please note that the function do_SimpleDetection0 is NOT included
 in this release, since it is the same showed in chapter 4.1 of the
 cited Zimmer et al. book.
---------------------------------------------------------------------
 Usage:
      This software has been developed and tested using GNU octave,
      version 5.2.0.
      A full/relative path filename of the wavefile to be processed 
      can be passed as command line argument.
      A recording block to be used as noise referece must be specified
      assigning the correct filename to the noise_wav variable 

 Output:
      Peaks are detected and (pseudo) classified and printed directly
      on the standard output
---------------------------------------------------------------------
```
