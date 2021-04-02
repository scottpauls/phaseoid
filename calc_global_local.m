function out=calc_global_local(filename,figname,startindex,hour,flag)
%CALC_GLOBAL_LOCAL calculates both the phases across the sample as well as the 
%local phase differences based on an annular filter.  Further, it evaluates
%the potential relationship between the two using linear regression.  The
%function includes a flag that allows the user to generate plots.
%
%INPUTS:
%
%FILENAME:this is the file name of the .mat file with the data.  The file
%needs to contain an n x k matrix of data (n pixels by k points in the time
%series) and a vector of indices giving the mask that identifies the SCN
%tissue.
%
%FIGNAME: if you are generating figures, this is the title
%
%STARTINDEX: the start time indiex for the time series
%
%HOUR: the period of the Fourier component from which you wish to compute
%the phase.
%
%FLAG: a flag that, when set to one, generates a figure
%
%OUTPUT:
%
%OUT:
%

loc=calc_local(filename,startindex,hour); %a call to calculuate local phase differences
A=calc_global(filename,startindex,hour); %a call to calculate the phases for each pixel
i1=find(isnan(loc)==0); %find all the places that are not NaNs

t1=loc(i1); %set this to be the first data vector, omitting NaNs
t2=A(i1); %take the associated values from the phase matrix for the second data vector

[t2s,idx]=sort(t2); %sort the second data vector
t1s=t1(idx); %apply the same order to the first
[bs,~,~,~,stats]=regress(t1s,[ones(numel(t2s),1), (t2s)]); %calculate a linear regression t1s=m*t2s+b;


%record the results for output
out.A=A;
out.local=loc;
out.bs=bs;
out.stats=stats;
out.t1=t1s;
out.t2=t2s;

if flag==1  %if flag is present plot figures
figure(1);

pcolor(A); %display the phase matrix
shading flat
axis ij
axis off
title(figname);
colormap(colorcet('C1'));colorbar
set(gca,'Clim',[-12,12]);
figure(2);
subplot(1,2,1)
pcolor(loc) %display the local phase difference matrix
shading flat
axis ij
axis off
set(gca,'CLim',[-1,1]);colorbar;
title(figname);
subplot(1,2,2)

hold off
plot(t2s,t1s,'k.'); %plot the two data vectors against one another together with teh regression line
hold on
plot(t2s,bs(1)+bs(2).*t2s,'r-','linewidth',3);
set(gca,'XLim',[-12,12]);
set(gca,'YLim',[-12,12]);

end