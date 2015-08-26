%% real data stepwise 
clear
clc
cd('C:\Users\ruiguo1\Desktop\simulation_r');
load('C:\Users\ruiguo1\Desktop\2008OPlink.mat')
load('C:\Users\ruiguo1\Desktop\2009OPlink.mat')


U1 = math0808OPlink;  %%%%%%%%%need change
U2 = math0809OPlink; %%%%%%%%%need change

N = size(U1,1);
D = 1.703;
n = size(U1,2);
alpha = [.01 0.05 0.1 .15 .2 .25 .3];

Im = zeros(length(alpha),n);
sample=randsample(1:N,500)';
datamatrix=[[U1(sample,:) zeros(length(sample),1)]; [U2(sample,:) ones(length(sample),1)]];

%write datamatrix into a text file
dlmwrite('datamatrix.dat',datamatrix,'delimiter','\t','precision',6,'newline','pc');

%%
 for alpha_index = 1:length(alpha)



%% initialize initial matching set
Iman_new = 1:n;

%% 

%% write R control file
fid = fopen('mantel.R','wt');
fprintf(fid,'%13s','library(difR)');fprintf(fid,'\n');
fprintf(fid,'%83s','datamatrix=read.table("c:/users/ruiguo1/desktop/simulation_r/datamatrix.dat")');fprintf(fid,'\n');
fprintf(fid,'%37s %2d %20s %4.2f %22s','mantel_result=difMH(datamatrix,group=',size(datamatrix,2),',focal.name=1,alpha=',alpha(alpha_index),',purify=TRUE)');fprintf(fid,'\n');
fprintf(fid,'%32s','Iman_diff=mantel_result$DIFitems');fprintf(fid,'\n');
fprintf(fid,'%36s','if (Iman_diff=="No DIF item detected")');fprintf(fid,'\n');
fprintf(fid,'%13s','{Iman_diff=c()}');fprintf(fid,'\n');
fprintf(fid,'%32s','write(Iman_diff,file="Iman_diff.dat",ncolumns=1)');fprintf(fid,'\n');
fclose(fid);

%% Mantel Test using R Package 
!C:\Users\ruiguo1\Documents\R\R-3.1.1\bin\x64\Rscript.exe  C:\\Users\ruiguo1\desktop\simulation_r\mantel.R 
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
%%
delete  Iman_diff.DAT mantel.R

Im(alpha_index,Iman)=1;

end