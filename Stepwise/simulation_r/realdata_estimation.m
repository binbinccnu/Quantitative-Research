clear
clc
cd('C:\Users\ruiguo1\Desktop\simulation');
load('C:\Users\ruiguo1\Desktop\2009.mat');
U = r082009OP;
%%
N = size(U,1);
n = size(U,2);
fid=fopen('U.DAT','wt');
for j=1:N
    fprintf(fid,'%5d %15s',j,num2str(U(j,:),'%1d'));               fprintf(fid,'\n');
end
fclose(fid);

%% write MULTILOG control file
fid=fopen('MMLE.MLG','wt');
fprintf(fid,'%24s','MULTILOG for Windows 7.00.2327.2');            fprintf(fid,'\n');
fprintf(fid,'%35s','Created on: 30 April 2011,  17:00:22');        fprintf(fid,'\n');
fprintf(fid,'%16s','>PROBLEM RANDOM,');                            fprintf(fid,'\n');
fprintf(fid,'%20s','INDIVIDUAL,');                                 fprintf(fid,'\n');
fprintf(fid,'%62s','DATA =   ''C:\Users\ruiguo1\Desktop\simulation\U.DAT'',');fprintf(fid,'\n');
fprintf(fid,'%17s %2d %s','NITEMS =',n,',');                       fprintf(fid,'\n');
fprintf(fid,'%18s %d %s' ,'NGROUPS =',1,',');                      fprintf(fid,'\n');
fprintf(fid,'%21s %4d %s','NEXAMINEES =',N,',');                   fprintf(fid,'\n');
fprintf(fid,'%17s %d %s' ,'NCHARS =',5,';');                       fprintf(fid,'\n');
fprintf(fid,'%10s','>TEST ALL,');                                  fprintf(fid,'\n');
fprintf(fid,'%9s' ,'L3;');                                         fprintf(fid,'\n');
fprintf(fid,'%6s' ,'>END ;');                                      fprintf(fid,'\n');
fprintf(fid,'%d',3);                                               fprintf(fid,'\n');
fprintf(fid,'%3s','019');                                          fprintf(fid,'\n');
fprintf(fid,'%s',num2str(ones(n,1),'%1d'));                        fprintf(fid,'\n');
fprintf(fid,'%s','Y');                                             fprintf(fid,'\n');
fprintf(fid,'%d',9);                                               fprintf(fid,'\n');
fprintf(fid,'%13s',strcat('(5A1,1X,',num2str(n,'%1d'),'A1)'));     fprintf(fid,'\n');
fclose(fid);

%% get calibration results

%initial equating using second year calibration results
!MLG.EXE C:\Users\ruiguo1\Desktop\simulation\MMLE
cali_test=[];
%%
!ren mlogicc_file mlogicc_file.txt
for j=1:n
    fid=fopen('mlogicc_file.txt');
    data=textscan(fid,'%f %f %f',1,'headerLines',2*j-1);
    fclose(fid);
    cali_test=[cali_test;data];
end
cali_test=cell2mat(cali_test);  %first n items are common items, the remainings are unique items

% extract eparameter
eparameter=cali_test(1:n,:);

%% delete files
delete mlogicc_file.txt mloginfo_file mlogscore_file U.DAT MMLE.OUT MMLE.MLG;
clear ans data fid j
