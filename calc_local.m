function out=calc_local(filename, startindex, hour)
%CALC_LOCAL: calculate the local differences in phase using a binarized filter  
%  
%INPUTS:  
%  
%FILENAME:  this is the file name of the .mat file with the data.  The file
%needs to contain an n x k matrix of data (n pixels by k points in the time
%series) and a vector of indices giving the mask that identifies the SCN
%tissue.
%  
%STARTINDEX:  the start time index for the time series
%  
%HOUR: the period of the Fourier component from which you wish to compute
%the phase. 
% 
%OUTPUT:
%
%OUT: a matrix containing the local phase difference values
%

%Construct the filter with parameters that make the diameter of the center
%and the width of the annulus roughly the same as a neuron 
G=makefilter(1,2,1); 
G(1:5,:)=[]; %trim the filter 
G(:,1:5)=[];
G(end-5:end,:)=[];
G(:,end-5:end)=[];

Z=calc_global(filename,startindex,hour); %find phases
out=conv2(Z,G,'same'); %convolve the phases data with the filter to produce local phase differences