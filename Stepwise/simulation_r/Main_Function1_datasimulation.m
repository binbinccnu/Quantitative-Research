%% data preparation

%different drift proportion
% p1=.2; p2=.04; p3=.067; p4=.04; p5=.04;
p1=0.2; p2=0; p3=0; p4=0; p5=0;

%generate single directional drift and corresponding data
[U1,U2,n1,n2,n3,n4,n5,trupar1,trupar2,trupar_test1,trupar_test2,k,Theta2]=datageneratesingle(n,test,N,p1,p2,p3,p4,p5,D,a_scale,b_scale,c_scale);

%write down the data file
fid=fopen('U2.DAT','wt');
for j=1:N
    fprintf(fid,'%5d %15s',j,num2str(U2(j,:),'%1d'));  fprintf(fid,'\n');
end
fclose(fid);

%% write MULTILOG control file
fid=fopen('MMLE2.MLG','wt');
fprintf(fid,'%24s','MULTILOG for Windows 7.00.2327.2')    ;fprintf(fid,'\n');
fprintf(fid,'%35s','Created on: 30 April 2011,  17:00:22');fprintf(fid,'\n');
fprintf(fid,'%16s','>PROBLEM RANDOM,');                    fprintf(fid,'\n');
fprintf(fid,'%20s','INDIVIDUAL,');                fprintf(fid,'\n');
fprintf(fid,'%68s','DATA =   ''C:\Users\auror_000\Desktop\TCC_revise_2\simulation\U2.DAT'',');fprintf(fid,'\n');
fprintf(fid,'%17s %2d %s','NITEMS =',n+test,',');                  fprintf(fid,'\n');
fprintf(fid,'%18s %d %s' ,'NGROUPS =',1,',');                      fprintf(fid,'\n');
fprintf(fid,'%21s %4d %s','NEXAMINEES =',N,',');                   fprintf(fid,'\n');
fprintf(fid,'%17s %d %s' ,'NCHARS =',5,';');                       fprintf(fid,'\n');
fprintf(fid,'%10s','>TEST ALL,');                                  fprintf(fid,'\n');
fprintf(fid,'%9s' ,'L3;');                                         fprintf(fid,'\n');
fprintf(fid,'%6s' ,'>END ;');                                      fprintf(fid,'\n');
fprintf(fid,'%d',2);                                               fprintf(fid,'\n');
fprintf(fid,'%2s','01');                                           fprintf(fid,'\n');
fprintf(fid,'%s',num2str(ones(n+test,1),'%1d'));                   fprintf(fid,'\n');
fprintf(fid,'%s','N');                                             fprintf(fid,'\n');
fprintf(fid,'%13s',strcat('(5A1,1X,',num2str(n+test,'%1d'),'A1)'));fprintf(fid,'\n');
fclose(fid);

%% get calibration results
eparameter1=trupar1(:,2:4);

%initial equating using second year calibration results
!MLG.EXE C:\Users\auror_000\Desktop\TCC_revise_2\simulation\MMLE2
cali_test2=[];
!ren mlogicc_file mlogicc_file.txt
for j=1:(n+test)
    fid=fopen('mlogicc_file.txt');
    data=textscan(fid,'%f %f %f',1,'headerLines',2*j-1);
    fclose(fid);
    cali_test2=[cali_test2;data];
end
cali_test2=cell2mat(cali_test2);  %first n items are common items, the remainings are unique items

% extract eparameter2
eparameter2=cali_test2(1:n,:);

%% delete files
delete mlogicc_file.txt mloginfo_file mlogscore_file U2.DAT MMLE2.OUT MMLE2.MLG;
clear ans data fid j