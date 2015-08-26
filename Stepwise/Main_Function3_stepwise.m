%% this procedure condutcts STEPWISE TCC IPD dection

%% sort out the initial model


%use backward elimination
[I]=backward(1:n,parameter1,parameter2,D,csem);

% % %
% itemdiff=zeros(n,1);
% for j=1:n
% itemdiff(j)=areadiff(parameter1(j,:),parameter2(j,:),D);
% end
% [newdiff,index]=sort(itemdiff,'descend');
% 
% newdiff=itemdiff;
% proportion=normrnd(0,1);
% proportion=exp(proportion)/(1+exp(proportion));
% nthrow=randsample(1:round(proportion*n),1);
% cutoff=newdiff(nthrow);
% throw=find(itemdiff>=cutoff);
% I=sort(setdiff(1:n,throw));

%% this is the Stepwise TCC method
iter=0;
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