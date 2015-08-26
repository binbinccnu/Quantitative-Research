%% this procedure conducts dsquare IPD detection

%% initialization
%sort out the initial model
parameter1=[(1:n)' eparameter1(1:n,:)]; 
parameter2=[(1:n)' allequate(1:n,:)];

%Calculate d square
d=dsquare(parameter1,parameter2,D);

%sort out the alpha% drifted items and set up the cut-off point
[newd,index]=sort(d,'descend');
nthrow=round(alpha(alpha_index)*n);cutoff=newd(nthrow);
throw=find(d>=cutoff);
Idsquare=sort(setdiff(1:n,throw));

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

%% clear data
clear data;