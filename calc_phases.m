function out=calc_phases(H,startind,stopind,hour)
%CALC_PHASES computes the phases of the signal for each pixel from the HOUR
%period component of the Fourier decomposition.  
%
%INPUTS:
%
%H: the data matrix to process
%
%STARTIND, STOPIND: the start and stop time indices use to window the time series
%
%HOUR: the period of the Fourier component from which you wish to compute
%the phase.
%
%OUTPUT:
%
%OUT: a structure with two fields, phases and y.  Out.phases is the list of
%phases computed, out.y is the full Fourier results for the data.


x=H(:,startind:stopind)'; %window the data
y = sqrt(length(x))*ifft(x); %compute the fft
y0=sqrt(length(x))*ifft(nanmean(H,1)); %compute the fft of the mean signal

sampf = 1/(60*60); %sampling frequency                           
L = numel(startind:stopind); % length of the signal
f = sampf*(0:(L/2))/L; % frequency domain
tmp=((1./f(1:10))/3600)-hour; %list periods in hours and subtract off the target HOUR
perind=find(abs(tmp)==min(abs(tmp)),1,'first'); %find the index for the entry closest to the target HOUR

%compute phases, subtracting off the phase of the mean signal
phases=angle(y(perind,:))-angle(y0(perind));
out.phases=phases;
out.y=y;
end

