%% prepare data
clear
clc
close all

cd('C:\Users\ruiguo1\Desktop\simulation_r');
load('C:\Users\ruiguo1\Desktop\2008parlink.mat')
load('C:\Users\ruiguo1\Desktop\2009parlink.mat')

% get all calibrated results
load('C:\Users\ruiguo1\Desktop\2008par.mat')
load('C:\Users\ruiguo1\Desktop\2009par.mat')
% 
% alpha=[.01 .05 .1 .15 .2 .25 .3];
% lengths = zeros(length(alpha),2);
% area_compare = lengths;
% conversion_d = [];
% conversion_m = [];
% 
% for index = 1:length(alpha)
%
parameter1 = math0308parlink;     %%%%%%%%%%%%%need to change
parameter2 = math0309parlink;     %%%%%%%%%%%%%need to change
I=setdiff(1:size(parameter1,1),[4,10,17,38,47]);
% load(  'C:\Users\ruiguo1\Desktop\result 2\d\Id03.mat') %%%%%%%%%%%%%%%%%%%need to change
% load('C:\Users\ruiguo1\Desktop\result 2\man\Im03.mat') %%%%%%%%%%%%%%%%%%%need to change
cali_test1 = m0308par;            %%%%%%%%%%%%%need to change
cali_test2 = m0309par;            %%%%%%%%%%%%%need to change

%% 
D = 1.703;
n = size(parameter1,1);

parameter1 = [(1:n)' parameter1];
parameter2 = [(1:n)' parameter2];

eparameter1 = parameter1(:,2:4);
eparameter2 = parameter2(:,2:4);

test1 = size(cali_test1,1)-n;
test2 = size(cali_test2,1)-n;

% % get all calibrated results
% Idsquare = find(Id(index,:)==1);       
% Iman = find(Im(index,:)==1);    
% lengths(index,1)=length(Idsquare);
% lengths(index,2)=length(Iman);

min_score1 = round(tcc(-4,cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),D));
raw_score1 =[min_score1:round(tcc(4,cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),D))]';

min_score2 =round(tcc(-4,cali_test2(:,1),cali_test2(:,2),cali_test2(:,3),D));
raw_score2 =[min_score2:round(tcc(4,cali_test2(:,1),cali_test2(:,2),cali_test2(:,3),D))]';
    
%% conduct linking using items selected by tcc method
    %get linking data
    linking1=[eparameter1(I,:);eparameter1(setdiff(1:n,I),:)];
    linking2=[eparameter2(I,:);eparameter2(setdiff(1:n,I),:)];
    
    %conduct linking for the final model %writing the control file
    fid=fopen('link.stu','wt'); fprintf(fid,'%3s%2d','NE',size(linking1,1));fprintf(fid,'\n'); 
    for j=1:size(linking1,1)
        fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3',2,' DW ',1.703,linking2(j,1),linking2(j,2),linking2(j,3));fprintf(fid,'\n');
    end
    fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s%2d','OL',size(linking1,1));fprintf(fid,'\n'); 
    for j=1:size(linking1,1)
        fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3',2,' DW ',1.703,linking1(j,1),linking1(j,2),linking1(j,3));fprintf(fid,'\n');
    end
    fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s %2d%3s','CI',length(I),'AO');fprintf(fid,'\n');
    fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%2s','OP');fprintf(fid,'\n');
    fprintf(fid,'%3s %2s','KO ','SL');fprintf(fid,'\n');
    fprintf(fid,'%3s%2d %4s %6.4f %6.4f %6.4f','ND ',181,' PN',0.0000,1.0000,4.0000);fprintf(fid,'\n'); 
    fprintf(fid,'%3s %2d %4s%6.4f %6.4f %6.4f','OD ',181,' PN',0.0000,1.0000,4.0000);fprintf(fid,'\n'); 
    fprintf(fid,'%3s %3s%2s','SY ','BI ','BI');fprintf(fid,'\n'); 
    fprintf(fid,'%3s %3s%2s','FS ','DO ','DO');fprintf(fid,'\n');
    fprintf(fid,'%2s','BY');fprintf(fid,'\n'); fclose(fid); 
    !link.bat
    !ren link.stu.out link.txt
    
    %extract link.stu.out and conduct linking fid=fopen('link.txt');
    data=textscan(fid,'%s %f %f',1,'headerLines',464+2*n); fclose(fid);
    delete link.txt
    equate(:,1)=eparameter2(:,1)*data{1,2};equate(:,2)=eparameter2(:,2)*data{1,2}+data{1,3};equate(:,3)=eparameter2(:,3);
    parameter2=[[1:n]' equate(1:n,:)];
      
    area_compare=areadiff(parameter1(I,:),parameter2(I,:),D);
    
%     
     %% conversion table 
   
% 
%     tcc_test2(:,1)=cali_test2(:,1)*data{1,2};
%     tcc_test2(:,2)=cali_test2(:,2)*data{1,2}+data{1,3};
%     tcc_test2(:,3)=cali_test2(:,3);
%     
%     if test1 <= test2
%         tcc_score=zeros(length(raw_score1),1); for
%         j_score=1:length(raw_score1)
%             tcc_score(j_score)=conversion(raw_score1(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),tcc_test2(:,1),tcc_test2(:,2),tcc_test2(:,3),D,1);
%         end %report conversion table conversion_result=[raw_score1
%         tcc_score];
%     elseif test1 > test2
%         tcc_score=zeros(length(raw_score2),1); for
%         j_score=1:length(raw_score2)
%             tcc_score(j_score)=conversion(raw_score2(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),tcc_test2(:,1),tcc_test2(:,2),tcc_test2(:,3),D,2);
%         end %report conversion table conversion_result=[tcc_score
%         raw_score2];
%     end
% 
% clear theta_mle_stepwise data; delete link.stu


% %% conduct linking using items selected by d-square method
% if ~isempty(Idsquare)
%     linking1=[eparameter1(Idsquare,:);eparameter1(setdiff(1:n,Idsquare),:)];
%     linking2=[eparameter2(Idsquare,:);eparameter2(setdiff(1:n,Idsquare),:)];
%     %conduct linking for the initial model
%     fid=fopen('link.stu','wt');
%     fprintf(fid,'%3s%2d','NE ',size(linking1,1));fprintf(fid,'\n');
%     for j=1:size(linking1,1)
%         fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, linking2(j,1),linking2(j,2),linking2(j,3));fprintf(fid,'\n');
%     end
%     fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s%2d','OL ',size(linking1,1));fprintf(fid,'\n');
%     for j=1:size(linking1,1)
%         fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, linking1(j,1),linking1(j,2),linking1(j,3));fprintf(fid,'\n');
%     end
%     fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s %2d %3s','CI',length(Idsquare),'AO');fprintf(fid,'\n');
%     fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%2s','OP');fprintf(fid,'\n');
%     fprintf(fid,'%3s %2s','KO ','SL');fprintf(fid,'\n');fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','ND ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n');
%     fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','OD ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n'); fprintf(fid,'%3s %3s %2s','SY ','BI ','BI');fprintf(fid,'\n');
%     fprintf(fid,'%3s %3s %2s','FS ','DO ','DO');fprintf(fid,'\n');
%     fprintf(fid,'%2s','BY');fprintf(fid,'\n');
%     fclose(fid);
%     !link.bat
%     !ren link.stu.out link.txt    
%     %extract link.stu.out and conduct linking
%     fid=fopen('link.txt');
%     data=textscan(fid,'%s %f %f',1,'headerLines',464+2*n);
%     fclose(fid); delete link.txt
%     equate(:,1)=eparameter2(:,1)*data{1,2};equate(:,2)=eparameter2(:,2)*data{1,2}+data{1,3};equate(:,3)=eparameter2(:,3);
%     parameter2=[ [1:n]' equate(1:n,:)];        
% 
%     area_compare(index,1)=areadiff(parameter1(Idsquare,:),parameter2(Idsquare,:),D);
%     
% 
%     %% conversion table
%     d_test2(:,1)=cali_test2(:,1)*data{1,2};
%     d_test2(:,2)=cali_test2(:,2)*data{1,2}+data{1,3};
%     d_test2(:,3)=cali_test2(:,3);
%     
%     if test1 <= test2 
%         d_score=zeros(length(raw_score1),1);
%         for j_score=1:length(raw_score1)     
%             d_score(j_score)=conversion(raw_score1(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),d_test2(:,1),d_test2(:,2),d_test2(:,3),D,1);   
%         end
%         %report conversion table
%         conversion_d=[conversion_d d_score];
%     elseif test1 > test2
%         d_score=zeros(length(raw_score2),1);
%         for j_score=1:length(raw_score2)     
%             d_score(j_score)=conversion(raw_score2(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),d_test2(:,1),d_test2(:,2),d_test2(:,3),D,2);   
%         end
%         %report conversion table
%         conversion_d=[d_score conversion_d];
%     end
%     
% else
% 
% end
% clear theta_mle_dsquare data;
% delete link.stu
% 
% %% conduct linking using items selected by mantel method
% if ~isempty(Iman)
%     linking1=[eparameter1(Iman,:);eparameter1(setdiff(1:n,Iman),:)];
%     linking2=[eparameter2(Iman,:);eparameter2(setdiff(1:n,Iman),:)];
%     %conduct linking for the initial model
%     fid=fopen('link.stu','wt');
%     fprintf(fid,'%3s%2d','NE ',size(linking1,1));fprintf(fid,'\n');
%     for j=1:size(linking1,1)
%         fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, linking2(j,1),linking2(j,2),linking2(j,3));fprintf(fid,'\n');      
%     end
% 
%     fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s%2d','OL ',size(linking1,1));fprintf(fid,'\n');
%     for j=1:size(linking1,1)
%         fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, linking1(j,1),linking1(j,2),linking1(j,3));fprintf(fid,'\n');
%     end
%     fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s %2d %3s','CI',length(Iman),'AO');fprintf(fid,'\n');
%     fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%2s','OP');fprintf(fid,'\n');
%     fprintf(fid,'%3s %2s','KO ','SL');fprintf(fid,'\n');fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','ND ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n');
%     fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','OD ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n'); fprintf(fid,'%3s %3s %2s','SY ','BI ','BI');fprintf(fid,'\n');
%     fprintf(fid,'%3s %3s %2s','FS ','DO ','DO');fprintf(fid,'\n');
%     fprintf(fid,'%2s','BY');fprintf(fid,'\n');
%     fclose(fid);
%     !link.bat
%     !ren link.stu.out link.txt   
%     
%     %extract link.stu.out and conduct linking
%     fid=fopen('link.txt');
%     data=textscan(fid,'%s %f %f',1,'headerLines',464+2*n);
%     fclose(fid); delete link.txt
%     equate(:,1)=eparameter2(:,1)*data{1,2};equate(:,2)=eparameter2(:,2)*data{1,2}+data{1,3};equate(:,3)=eparameter2(:,3);
%     parameter2=[[1:n]' equate(1:n,:)];
%       
%     area_compare(index,2)=areadiff(parameter1(Iman,:),parameter2(Iman,:),D);
%     
%     
%     %% conversion table
%     man_test2(:,1)=cali_test2(:,1)*data{1,2};
%     man_test2(:,2)=cali_test2(:,2)*data{1,2}+data{1,3};
%     man_test2(:,3)=cali_test2(:,3);
%     
%     if test1 <= test2 
%         man_score=zeros(length(raw_score1),1);
%         for j_score=1:length(raw_score1)     
%             man_score(j_score)=conversion(raw_score1(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),man_test2(:,1),man_test2(:,2),man_test2(:,3),D,1);   
%         end
%         %report conversion table
%         conversion_m=[conversion_m man_score];
%     elseif test1 > test2
%         man_score=zeros(length(raw_score2),1);
%         for j_score=1:length(raw_score2)     
%             man_score(j_score)=conversion(raw_score2(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),man_test2(:,1),man_test2(:,2),man_test2(:,3),D,2);   
%         end
%         %report conversion table
%         conversion_m=[man_score conversion_m];
%     end
% else
% 
% end
% clear theta_mle_man data;
% delete link.stu
% 
% 
% 
%% delete variables in preparation for the next replication 
clear I Inew Idsquare Iman Ilord Inewd Theta2 U1 U2 allequate ans 
clear areadiff1 areadiffI areadiffIdsquare areadiffIlord areadiffIman
clear bias_baseline bias_dsquare bias_lord bias_man bias_stepwise
clear cali_test2 conversion_diff_d conversions_diff_lord 
clear conversion_diff_man conversion_diff_tcc cutoff d d_score d_test2
clear eparameter1 eparameter2 equate fid flag index itemdiff iter 
clear j j_score k linking1 linking2 lord_score lord_test2 man_score man_test2 
clear min_score n1 n2 n3 n4 n5 newd newdiff nthrow p
clear parameter1 parameter2 raw_score rmse_baseline rmse_dsquare
clear rmse_lord rmse_man rmse_stepwise scaled_score tcc_score tcc_test2 
clear theta_equate_man theta_mle throw trupar1 trupar2 trupar_test1 trupar_test2
clear condn condp conversion_diff_lord fn_d fn_lord fn_man fn_tcc fp_d fp_lord
clear fp_man fp_tcc sens_d sens_lord sens_man sens_tcc spec_d spec_lord spec_man
clear spec_tcc testn_d testn_lord testn_man testn_tcc testp_d testp_lord testp_man
clear testp_man testp_tcc tn_d tn_lord tn_man tn_tcc tp_d tp_lord tp_man tp_tcc
delete link.stu link.txt link.stu.out 

% end