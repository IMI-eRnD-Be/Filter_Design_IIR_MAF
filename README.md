# Filter_Design_IIR_MAF

This repository allows users to create and design either Moving Average Filters (AKA MAF) or Infinite Impulse Response filters (AKA IIR). Software to be used for running files is Octave or Matlab. 

 - IIR_Script_design.m : Allows to design an IIR filter, user should provide filter order (N), cutoff frqeuncy in Hz (fcut) and the sampling time (Ts) in seconds. 
 - script_design.m : Allows to design an IIR filter and a MAF, for IIR filter, the user should provide filter order (N), cutoff frqeuncy in Hz (fcut) and the sampling time (Ts) in seconds; also for MAF, the user should provide filter order for MAF (M =  number of samples in the moving average filter), pass frequency in Hz (Fp) and stop frequency in Hz (Fc).

 - filter_IIR_sim.m : Allows the user to verify and validate a IIR filter already created, user should provide coefficients a and b arrays. 
 
 - ideal_lp.m : Library function used to create and design filters. It represents an ideal low pass filter.  
 - freqz_m.m : Library function used to create and design filters. It calculates frrequency response of filter, showing attenuation and phase of filter avoiding to use the bode function (Not only in DBs but in adimensional values).

## Examples:

![Temperature filter](/TemperatureFilterImplemented/MAFVsIIR_N2Butterworth.pdf)
