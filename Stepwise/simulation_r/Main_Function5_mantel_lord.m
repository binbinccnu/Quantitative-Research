%% first getting the datamatrix
%we need to sample 500 samples randomly from the examinees using weighted
%sampling

%% initialize initial matching set
Iman_new = 1:n;

%% 
sample=randsample(1:N,500)';
datamatrix=[[U1(sample,Iman_new) zeros(length(sample),1)]; [U2(sample,Iman_new) ones(length(sample),1)]];

%write datamatrix into a text file
dlmwrite('datamatrix.dat',datamatrix,'delimiter','\t','precision',6,'newline','pc');

%% write R control file
fid = fopen('mantel.R','wt');
fprintf(fid,'%13s','library(difR)');fprintf(fid,'\n');
fprintf(fid,'%90s','datamatrix=read.table("c:/users/auror_000/desktop/tcc_revise_2/simulation/datamatrix.dat")');fprintf(fid,'\n');
fprintf(fid,'%37s %2d %20s %4.2f %22s','mantel_result=difMH(datamatrix,group=',size(datamatrix,2),',focal.name=1,alpha=',alpha(alpha_index),',purify=TRUE)');fprintf(fid,'\n');
fprintf(fid,'%32s','Iman_diff=mantel_result$DIFitems');fprintf(fid,'\n');
fprintf(fid,'%36s','if (Iman_diff=="No DIF item detected")');fprintf(fid,'\n');
fprintf(fid,'%13s','{Iman_diff=c()}');fprintf(fid,'\n');
fprintf(fid,'%32s','write(Iman_diff,file="Iman_diff.dat",ncolumns=1)');fprintf(fid,'\n');
fclose(fid);

%% Mantel Test using R Package 
!c:\\Users\auror_000\Documents\R\R-3.0.2\bin\x64\Rscript.exe  C:\\Users\auror_000\desktop\TCC_revise_2\simulation\mantel.R 
if exist('Iman_diff.dat','file')==2
    load Iman_diff.dat
else
    Iman_diff = [];
end

%%
% Iman_new = setdiff(1:n,Iman_diff);
Iman_new_diff = Iman_new(Iman_diff); %new flagged items 
Iman_new = setdiff(Iman_new, Iman_new_diff);
% end

Iman = Iman_new;
%%
delete datamatrix.DAT Iman_diff.DAT U2.DAT mantel.R
clear datamatrix