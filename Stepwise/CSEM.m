%% compute cutoff point using the csem using parameters repeating 100 times
%first getting the calibration and do linking using the results from
%Main_Function2

%% initializtion
csem=0;

for circle=1:100
    %% data preparation
    
    %simulate second year theta and corresponding U1__ data
    Theta2_=normrnd(0.1,1,N,1);
    U1__=Examinee_Response_Simulation(Theta2_,parameter1(:,2),parameter1(:,3),parameter1(:,4),D);
   
    %write into text file
    fid=fopen('U1__.DAT','wt');
    for j=1:N
        fprintf(fid,'%5d %15s',j,num2str(U1__(j,:),'%1d'));  fprintf(fid,'\n');
    end
    fclose(fid);
    
    %write MULTILOG control file
    fid=fopen('MMLE1__.MLG','wt');
    fprintf(fid,'%24s','MULTILOG for Windows 7.00.2327.2')    ;fprintf(fid,'\n');
    fprintf(fid,'%35s','Created on: 30 April 2011,  17:00:22');fprintf(fid,'\n');
    fprintf(fid,'%16s','>PROBLEM RANDOM,');                    fprintf(fid,'\n');
    fprintf(fid,'%20s','INDIVIDUAL,');                         fprintf(fid,'\n');
    fprintf(fid,'%68s','DATA =   ''C:\Users\auror_000\Desktop\TCC_revise_2\simulation\U1__.DAT'',');fprintf(fid,'\n');
    fprintf(fid,'%17s %2d %s','NITEMS =',n,',');               fprintf(fid,'\n');
    fprintf(fid,'%18s %d %s' ,'NGROUPS =',1,',');              fprintf(fid,'\n');
    fprintf(fid,'%21s %4d %s','NEXAMINEES =',N,',');           fprintf(fid,'\n');
    fprintf(fid,'%17s %d %s' ,'NCHARS =',5,';');               fprintf(fid,'\n');
    fprintf(fid,'%10s','>TEST ALL,');                          fprintf(fid,'\n');
    fprintf(fid,'%9s' ,'L3;');                                 fprintf(fid,'\n');
    fprintf(fid,'%6s' ,'>END ;');                              fprintf(fid,'\n');
    fprintf(fid,'%d',2);                                       fprintf(fid,'\n');
    fprintf(fid,'%2s','01');                                   fprintf(fid,'\n');
    fprintf(fid,'%s',num2str(ones(n,1),'%1d'));                fprintf(fid,'\n');   
    fprintf(fid,'%s','N');                                     fprintf(fid,'\n');
    fprintf(fid,'%13s',strcat('(5A1,1X,',num2str(n,'%1d'),'A1)'));fprintf(fid,'\n');
    fclose(fid);
    
    %% run MULTILOG to estimate parameters
    !MLG.EXE C:\Users\auror_000\Desktop\TCC_revise_2\simulation\MMLE1__
    
    %extract calibrated item parameters 
    !ren mlogicc_file mlogicc_file.txt
    eparameter1__=[];
    for j=1:n  
        fid=fopen('mlogicc_file.txt');  
        data=textscan(fid,'%f %f %f',1,'headerLines',2*j-1);  
        fclose(fid);   
        eparameter1__=[eparameter1__;data];
    end    
    eparameter1__=cell2mat(eparameter1__);delete mlogicc_file.txt;clear ans data fid j

    %compute csem by averaging area difference values
    parameter1  =[(1:n)' eparameter1(1:n,:)  ];
    parameter1__=[(1:n)' eparameter1__(1:n,:)];
    areadiffs=zeros(n,1);
    for j=1:n
        areadiffs(j)=areadiff(parameter1(j,:),parameter1__(j,:),D);
    end
%     sorted=sort(areadiffs);
%     csem=csem+sorted(n-2);
    csem=csem+sum(areadiffs);

end

%% average csem values
csem=csem/100/n;

%% clear data
clear U1__ ans eparameter1__ parameter1__ sorted 
delete U1__.DAT MMLE1__.OUT MMLE1__.MLG