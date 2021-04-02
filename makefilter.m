function out=makefilter(sigma,K,flag_binary)
%MAKEFILTER creates a difference of Gaussians annular filter.
%
%INPUTS: 
%
%SIGMA: the standard deviationg for the two Gaussians
%
%K: a parameter to scale the second Gaussian
%
%FLAG_BINARY: a flag to leave the filter as constructed (0) or to binarize
%it (1)
%
%OUTPUT:
%
%OUT: the resulting filter
%

ts=-10:0.5:10;%set the domain of the filter
[xs,ys]=meshgrid(ts); %create a meshgrid

g1=(1/(2*pi*sigma^2))*exp(-(xs.^2+ys.^2)/(2*sigma^2)); %first Gaussian
g2=(1/(2*pi*K^2*sigma^2))*exp(-(xs.^2+ys.^2)/(2*K*sigma^2)); %second Gaussian

tmp=g1-g2; %initial construction of the difference of Gaussians
if flag_binary==0
    out=tmp; %set the output
else
    out=zeros(size(tmp)); %initialize binary filter
    out(tmp>10^(-5))=1; %set all positive values to one
    out(out==1)=1/numel(out(out==1)); %normalize
    out(tmp<-10^(-5))=-1; %set negative values to -1
   out(out==-1)=-1/numel(out(out==-1)); %normalize
 end
