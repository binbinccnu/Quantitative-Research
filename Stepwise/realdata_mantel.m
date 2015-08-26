%% real data stepwise 
clear
clc

cd('/Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation');
load('/Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation/real data/2008OPlink.mat')
load('/Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation/real data/2009OPlink.mat')

U1 = read0808OPlink;
U2 = read0809OPlink;
N = size(U1,1);
D = 1.703;
n = size(U1,2);

alpha = 0.05

% initialize initial matching set
Iman_new = 1:n;

%
sample=randsample(1:N,500)';
datamatrix=[[U1(sample,Iman_new) zeros(length(sample),1)]; [U2(sample,Iman_new) ones(length(sample),1)]];

%write datamatrix into a text file
dlmwrite('datamatrix.dat',datamatrix,'delimiter','\t','precision',6,'newline','pc');

% write R control file
fid = fopen('mantel.R','wt');
fprintf(fid,'%13s','library(difR)');fprintf(fid,'\n');
fprintf(fid,'%83s','datamatrix=read.table("/Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation/datamatrix.dat")');fprintf(fid,'\n');
fprintf(fid,'%37s %2d %20s %4.2f %22s','mantel_result=difMH(datamatrix,group=',size(datamatrix,2),',focal.name=1,alpha=',alpha,',purify=TRUE)');fprintf(fid,'\n');
fprintf(fid,'%32s','Iman_diff=mantel_result$DIFitems');fprintf(fid,'\n');
fprintf(fid,'%36s','if (Iman_diff=="No DIF item detected")');fprintf(fid,'\n');
fprintf(fid,'%13s','{Iman_diff=c()}');fprintf(fid,'\n');
fprintf(fid,'%32s','write(Iman_diff,file="/Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation/Iman_diff.dat",ncolumns=1)');fprintf(fid,'\n');
fclose(fid);
%%

%%
if exist('Iman_diff.dat','file')==2
    load Iman_diff.dat
else
    Iman_diff = [];
end

%
% Iman_new = setdiff(1:n,Iman_diff);
Iman_new_diff = Iman_new(Iman_diff); %new flagged items 
Iman_new = setdiff(Iman_new, Iman_new_diff);
% end

Iman = Iman_new;
setdiff(1:n,Iman)

delete Iman_diff.DAT mantel.R
clear Iman Iman_new Iman_new_diff Iman_diff
%%










%%
alpha=.1
% write R control file
fid = fopen('mantel.R','wt');
fprintf(fid,'%13s','library(difR)');fprintf(fid,'\n');
fprintf(fid,'%83s','datamatrix=read.table("/Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation/datamatrix.dat")');fprintf(fid,'\n');
fprintf(fid,'%37s %2d %20s %4.2f %22s','mantel_result=difMH(datamatrix,group=',size(datamatrix,2),',focal.name=1,alpha=',alpha,',purify=TRUE)');fprintf(fid,'\n');
fprintf(fid,'%32s','Iman_diff=mantel_result$DIFitems');fprintf(fid,'\n');
fprintf(fid,'%36s','if (Iman_diff=="No DIF item detected")');fprintf(fid,'\n');
fprintf(fid,'%13s','{Iman_diff=c()}');fprintf(fid,'\n');
fprintf(fid,'%32s','write(Iman_diff,file="/Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation/Iman_diff.dat",ncolumns=1)');fprintf(fid,'\n');
fclose(fid);

%% Mantel Test using R Package 
!/Applications/R.app  /Users/Aurora/Dropbox/research/TCC/TCC_revise_2/simulation/mantel.R 
%%
Iman_new = 1:n;
if exist('Iman_diff.dat','file')==2
    load Iman_diff.dat
else
    Iman_diff = [];
end

%
% Iman_new = setdiff(1:n,Iman_diff);
Iman_new_diff = Iman_new(Iman_diff); %new flagged items 
Iman_new = setdiff(Iman_new, Iman_new_diff);
% end

Iman = Iman_new;
setdiff(1:n,Iman)
%
delete datamatrix.DAT Iman_diff.DAT mantel.R
clear datamatrix Iman Iman_new Iman_new_diff Iman_diff