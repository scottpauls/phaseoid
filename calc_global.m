function A=calc_global(filename,hour,startindex)
%CALC_GLOBAL computes the phases of the signal for each pixel from the HOUR
%period compnent of the Fourier decomposition, converts the units to hours,
%and presents them as an image.
%
%INPUTS:
%
%FILENAME: this is the file name of the .mat file with the data.  The file
%needs to contain an n x k matrix of data (n pixels by k points in the time
%series) and a vector of indices giving the mask that identifies the SCN
%tissue.
%
%HOUR: the period of the Fourier component from which you wish to compute
%the phase.
%
%STARTINDEX: the index of the time series to treat as the beginning.
%
%OUTPUTS:
%
%A: the matrix of phases arranged according to the SCN mask.
%
%

dims=[512,512]; %set the dimensions of the standard movie frame
load(filename); %load the data
out=calc_phases(H,startindex,size(H,2),hour); %call CALC_PHASES to compute the phases
A=nan(dims); %initialize the matrix
A(mask)=out.phases*12/pi; %copy the phases into the matrix, converting to hours

[h1,h2]=hist(A(mask),100); %compute the histogram of phase values to set up normalization
i1=find(h1==max(h1)); %find the indices of the bins with the largest number of counts (usually there is one)
A=A-mean(h2(i1)); %remove the mean of phases of these indices to center the range of phases
A(A<-12)=A(A<-12)+24; %Shift phase values to lie between -12 hours and 12 hours
A(A>12)=A(A>12)-24;