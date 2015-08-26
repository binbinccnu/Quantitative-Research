%% prepare data
clear
clc
close all
cd('C:\Users\ruiguo1\Desktop\simulation');
load('C:\Users\ruiguo1\Desktop\2008parlink.mat')
load('C:\Users\ruiguo1\Desktop\2009parlink.mat')

D = 1.703;

%% real data results
I03=[4;10;17;38;47];
I04=[13;31;36;37;49];
I05=[27;34;35;36;40;50];
I06=[1;3;11;14;17;20;21;33;36;39;44;47];
I07=[15;25;26;27;34];
I08=[1;6;11;14;16;17;18;19;20;21;24;26;26;28;40;41;42;49;50;53];

Id03_005=[35;44];
Id04_005=[14;37];
Id05_005=[37;40;43];
Id06_005=[6;22;37];
Id07_005=26;
Id08_005=[23;25;50;53];

Id03_01=[4;30;31;34;35;41;44];
Id04_01=[14;35;37;38;46];
Id05_01=[37;40;43;45;48];
Id06_01=[6;13;22;28;37];
Id07_01=[14;26;35];
Id08_01=[22;23;25;40;41;50;53];

Im03_005=[8;31;34;44];
Im04_005=[14;30;31;32;33;34;35;36;37;38;39;43;44;46;47;48];
Im05_005=[1;16;17;28;31;33;34;35;37;39;40;41;42;43;44;45;46;47;48;49;50];
Im06_005=[14;15;16;20;31;32;34;38;39;40;41;42;46;48];
Im07_005=[5;10;12;13;22;28;29;31;35;37;38;39;40;41;43;44;46;47;48];
Im08_005=[9;10;13;15;21;22;28;29;31;32;34;35;37;39;40;41;44;46;47;48];

Im03_01=[8;25;31;34;44];
Im04_01=[7;14;26;27;30;31;32;33;34;35;36;37;38;39;41;43;44;46;47;48];
Im05_01=[1;2;14;16;17;22;27;28;31;33;34;35;37;39;40;41;42;43;44;45;46;47;48;49;50];
Im06_01=[15;16;20;31;32;34;38;39;40;41;42;43;46;48];
Im07_01=[5;10;12;13;22;25;27;28;29;31;32;35;37;38;39;40;41;43;44;46;47;48;49];
Im08_01=[9;10;12;13;15;21;22;28;29;31;32;34;35;37;39;40;41;43;44;46;47;48];

%%
parameter1 = math0308parlink;
parameter2 = math0309parlink;

n = size(parameter1,1);

% get all calibrated results
I = setdiff(1:n,I03);
Idsquare = setdiff(1:n,Id03_005);
Iman = setdiff(1:n,Im03_005);


cali_test1 = parameter1;
cali_test2 = parameter2;
% 
parameter1 = [(1:n)' parameter1];
parameter2 = [(1:n)' parameter2];

eparameter1 = parameter1(:,2:4);
eparameter2 = parameter2(:,2:4);



%% conduct linking using items selected by tcc method
if  ~isempty(I)
    figure_switch = 1;
    %get linking data 
    linking1=[eparameter1(I,:);eparameter1(setdiff(1:n,I),:)];
    linking2=[eparameter2(I,:);eparameter2(setdiff(1:n,I),:)];
    
    %conduct linking for the final model
    %writing the control file
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
    equate(:,1)=eparameter2(:,1)*data{1,2};equate(:,2)=eparameter2(:,2)*data{1,2}+data{1,3};equate(:,3)=eparameter2(:,3);
    parameter2=[[1:n]' equate(1:n,:)];
      
    if figure_switch==1
        figure(1)
        Draw_DIF(parameter1(I,2),parameter1(I,3),parameter1(I,4),parameter2(I,2),parameter2(I,3),parameter2(I,4),D,n);
    end
    
    %% conversion table
    min_score1 = round(tcc(-4,cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),D));
    raw_score1 = [min_score1:round(tcc(4,cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),D))]';

    tcc_test2(:,1)=cali_test2(:,1)*data{1,2};
    tcc_test2(:,2)=cali_test2(:,2)*data{1,2}+data{1,3};
    tcc_test2(:,3)=cali_test2(:,3);
    
    tcc_score=zeros(length(raw_score1),1);
    for j_score=1:length(raw_score1)
        tcc_score(j_score)=conversion(raw_score1(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),tcc_test2(:,1),tcc_test2(:,2),tcc_test2(:,3),D,1);   
    end
    %report conversion table
    conversion_tcc=[raw_score1 tcc_score];
else

    
end

clear theta_mle_stepwise data;
delete link.stu


%% conduct linking using items selected by d-square method
if ~isempty(Idsquare)
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
    fclose(fid); delete link.txt
    equate(:,1)=eparameter2(:,1)*data{1,2};equate(:,2)=eparameter2(:,2)*data{1,2}+data{1,3};equate(:,3)=eparameter2(:,3);
    parameter2=[ [1:n]' equate(1:n,:)];        

    if figure_switch==1
        figure(2)
        Draw_DIF(parameter1(Idsquare,2),parameter1(Idsquare,3),parameter1(Idsquare,4),parameter2(Idsquare,2),parameter2(Idsquare,3),parameter2(Idsquare,4),D,n);
    end

    %% conversion table
    d_test2(:,1)=cali_test2(:,1)*data{1,2};
    d_test2(:,2)=cali_test2(:,2)*data{1,2}+data{1,3};
    d_test2(:,3)=cali_test2(:,3);
    
    d_score=zeros(length(raw_score1),1);
    for j_score=1:length(raw_score1)   
        d_score(j_score)=conversion(raw_score1(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),d_test2(:,1),d_test2(:,2),d_test2(:,3),D,1);   
    end
    %report conversion table
    conversion_d=[raw_score1 d_score];
else

end
clear theta_mle_dsquare data;
delete link.stu

%% conduct linking using items selected by mantel method
if ~isempty(Iman)
    linking1=[eparameter1(Iman,:);eparameter1(setdiff(1:n,Iman),:)];
    linking2=[eparameter2(Iman,:);eparameter2(setdiff(1:n,Iman),:)];
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
    fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s %2d %3s','CI',length(Iman),'AO');fprintf(fid,'\n');
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
    equate(:,1)=eparameter2(:,1)*data{1,2};equate(:,2)=eparameter2(:,2)*data{1,2}+data{1,3};equate(:,3)=eparameter2(:,3);
    parameter2=[[1:n]' equate(1:n,:)];
      
    if figure_switch==1
        figure(3) 
        Draw_DIF(parameter1(Iman,2),parameter1(Iman,3),parameter1(Iman,4),parameter2(Iman,2),parameter2(Iman,3),parameter2(Iman,4),D,n);
    end

    
    %% conversion table
    man_test2(:,1)=cali_test2(:,1)*data{1,2};
    man_test2(:,2)=cali_test2(:,2)*data{1,2}+data{1,3};
    man_test2(:,3)=cali_test2(:,3);
    
    man_score=zeros(length(raw_score1),1);
    for j_score=1:length(raw_score1)     
        man_score(j_score)=conversion(raw_score1(j_score),cali_test1(:,1),cali_test1(:,2),cali_test1(:,3),man_test2(:,1),man_test2(:,2),man_test2(:,3),D,1);   
    end
    %report conversion table
    conversion_man=[raw_score1 man_score];    
else

end
clear theta_mle_man data;
delete link.stu

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
   