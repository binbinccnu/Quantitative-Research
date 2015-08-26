%% real data stepwise 
clear
clc
cd('C:\Users\ruiguo1\Desktop\simulation');
load('C:\Users\ruiguo1\Desktop\2008parlink.mat')
load('C:\Users\ruiguo1\Desktop\2009parlink.mat')

parameter1 = math0808parlink;
parameter2 = math0809parlink;
N = 15000;
D = 1.703;
n = size(parameter1,1);

parameter1 = [(1:n)' parameter1];
parameter2 = [(1:n)' parameter2];
%% first compute CSEM
csem=0;
for circle=1:50
    %% data preparation
    circle
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
    fprintf(fid,'%68s','DATA =   ''C:\Users\ruiguo1\Desktop\simulation\U1__.DAT'',');fprintf(fid,'\n');
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
    !MLG.EXE C:\Users\ruiguo1\Desktop\simulation\MMLE1__
    
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
    parameter1__=[(1:n)' eparameter1__(1:n,:)];
    areadiffs=zeros(n,1);
    for j=1:n
        areadiffs(j)=areadiff(parameter1(j,:),parameter1__(j,:),D);
    end
%     sorted=sort(areadiffs);
%     csem=csem+sorted(n-2);
    csem=csem+sum(areadiffs);
    clear U1__ ans eparameter1__ parameter1__ 
    delete U1__.DAT MMLE1__.OUT MMLE1__.MLG
end

%% average csem values
csem=csem/50/n;

%% backward selection
[I]=backward(1:n,parameter1,parameter2,D,csem);


%% this is the Stepwise TCC method
iter=0;
eparameter1 = parameter1(:,2:4);
eparameter2 = parameter2(:,2:4);
trupar1 = parameter1;
trupar2 = parameter2;
while (true) && iter<=100
    iter=iter+1;
    if ~isempty(I);
        %prep initial linking
        linking1=[eparameter1(I,:);eparameter1(setdiff(1:n,I),:)];
        linking2=[eparameter2(I,:);eparameter2(setdiff(1:n,I),:)];
        
        %conduct linking for the initial model
        fid=fopen('link.stu','wt');
        fprintf(fid,'%3s%2d','NE ',size(linking1,1));fprintf(fid,'\n');
        for j=1:size(linking1,1)
            fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, linking2(j,1),linking2(j,2),linking2(j,3));fprintf(fid,'\n');
        end
        fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s%2d','OL ',size(linking1,1));fprintf(fid,'\n');
        for j=1:size(linking1,1)
            fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, linking1(j,1),linking1(j,2),linking1(j,3));fprintf(fid,'\n');
        end
        fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s %2d %3s','CI',length(I),'AO');fprintf(fid,'\n');
        fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%2s','OP');fprintf(fid,'\n');
        fprintf(fid,'%3s %2s','KO ','SL');fprintf(fid,'\n');fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','ND ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n');
        fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','OD ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n'); fprintf(fid,'%3s %3s %2s','SY ','BI ','BI');fprintf(fid,'\n');
        fprintf(fid,'%3s %3s %2s','FS ','DO ','DO');fprintf(fid,'\n');
        fprintf(fid,'%2s','BY');fprintf(fid,'\n');
        fclose(fid);
        !link.bat
        !ren link.stu.out link.txt    
        
        %extract link.stu.out and conduct linking
        fid=fopen('link.txt');
        data=textscan(fid,'%s %f %f',1,'headerLines',464+2*n);
        fclose(fid); delete link.txt
        equate(:,1)=trupar2(:,2)*data{1,2};equate(:,2)=trupar2(:,3)*data{1,2}+data{1,3};equate(:,3)=trupar2(:,4);
        parameter2=[[1:n]' equate(1:n,:)];
        
        %update linking coefficients
        Inew=stepwisetcc(I,parameter1,parameter2,D,csem);
        if (length(Inew)~=length(I))
            flag=length(I)-length(Inew);
            I=Inew;       
        elseif (sum((Inew-I).^2)~=0)
            I=Inew;     
        else
            break;
        end
    else
        break;
    end
end
delete link.stu

setdiff(1:n,I)