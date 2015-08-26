%% real data stepwise 
clear
clc
cd('C:\Users\ruiguo1\Desktop\simulation_r');
load('C:\Users\ruiguo1\Desktop\2008parlink.mat')
load('C:\Users\ruiguo1\Desktop\2009parlink.mat')
parameter1 = math0708parlink;%%%need change

D = 1.703;
n = size(parameter1,1);
alpha = [.01 .05 0.1 .15 .2 .25 .3];
Id=zeros(length(alpha),n);
for alpha_index = 1:length(alpha)
    
    
parameter1 = math0708parlink;%%%need change
parameter2 = math0709parlink;%%%need change


parameter1 = [(1:n)' parameter1];
parameter2 = [(1:n)' parameter2];
%% initializing
%Calculate d square
d=dsquare(parameter1,parameter2,D);

%sort out the alpha% drifted items and set up the cut-off point
[newd,index]=sort(d,'descend');
nthrow=max(round(alpha(alpha_index)*n),1);
cutoff=newd(nthrow);
throw=find(d>=cutoff);
Idsquare=sort(setdiff(1:n,throw));

eparameter1 = parameter1(:,2:4);
eparameter2 = parameter2(:,2:4);
trupar1 = parameter1;
trupar2 = parameter2;
%% conduct dsquare IPD detection
%conduct linking recursively
while (true)
    if isempty(Idsquare)
        break;
    end
    
    %prepare linking parameters
    linking1=[eparameter1(Idsquare,:);eparameter1(setdiff(1:n,Idsquare),:)];
    linking2=[eparameter2(Idsquare,:);eparameter2(setdiff(1:n,Idsquare),:)];
    
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
    fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s %2d %3s','CI',length(Idsquare),'AO');fprintf(fid,'\n');
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
    fclose(fid); delete link.txt link.stu
    equate(:,1)=trupar2(:,2)*data{1,2};equate(:,2)=trupar2(:,3)*data{1,2}+data{1,3};equate(:,3)=trupar2(:,4);
    parameter2=[(1:n)' equate(1:n,:)];
    
    %conduct dsquare methods to remove high-diff items
    d=dsquare(parameter1(Idsquare,:),parameter2(Idsquare,:),D);
    Inewd=[];
    for j=1:length(Idsquare)
        if (d(j)<cutoff)
            Inewd=[Inewd Idsquare(j)];
        end
    end
    if (length(Idsquare)~=length(Inewd))
        Idsquare=Inewd;
    else
        break;
    end
end
Id(alpha_index,Idsquare)=1;
%% clear data
clear data;
end