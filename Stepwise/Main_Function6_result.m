%% conduct linking using items selected by tcc method
if  ~isempty(I)
    
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
      
    areadiffI=areadiff(parameter1(I,:),parameter2(I,:),D);
    if figure_switch==1
        figure(2)
        Draw_DIF(parameter1(I,2),parameter1(I,3),parameter1(I,4),parameter2(I,2),parameter2(I,3),parameter2(I,4),D,n);
    end
    
    %estimate second year theta values using equated parameters with detection
    theta_mle_stepwise=theta_mle*data{1,2}+data{1,3};
    rmse_stepwise=RMSE(Theta2,theta_mle_stepwise);
    bias_stepwise=BIAS(Theta2,theta_mle_stepwise);
    
    %conversion table
    tcc_test2(:,1)=cali_test2(n+1:n+test,1)*data{1,2};
    tcc_test2(:,2)=cali_test2(n+1:n+test,2)*data{1,2}+data{1,3};
    tcc_test2(:,3)=cali_test2(n+1:n+test,3);
    
    tcc_score=zeros(length(raw_score),1);
    for j_score=1:length(raw_score)
        tcc_score(j_score)=conversion(raw_score(j_score),trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),tcc_test2(:,1),tcc_test2(:,2),tcc_test2(:,3),D,1);
    end
    
    %report conversion table
    if y==repli
        conversion_table=[conversion_table tcc_score];
    end
    
    %conversino difference
    conversion_diff_tcc=RMSE(scaled_score,tcc_score);
    
else
    areadiffI=0;
    rmse_stepwise=0;
    bias_stepwise=0;
    conversion_diff_tcc=0;
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

    areadiffIdsquare=areadiff(parameter1(Idsquare,:),parameter2(Idsquare,:),D);
    if figure_switch==1
        figure(3)
        Draw_DIF(parameter1(Idsquare,2),parameter1(Idsquare,3),parameter1(Idsquare,4),parameter2(Idsquare,2),parameter2(Idsquare,3),parameter2(Idsquare,4),D,n);
    end
    % estimate second year theta values using equated parameters with detection
    theta_mle_dsquare=theta_mle*data{1,2}+data{1,3};
    rmse_dsquare=RMSE(Theta2,theta_mle_dsquare);
    bias_dsquare=BIAS(Theta2,theta_mle_dsquare);
    % conversion table
    d_test2(:,1)=cali_test2(n+1:n+test,1)*data{1,2};
    d_test2(:,2)=cali_test2(n+1:n+test,2)*data{1,2}+data{1,3};
    d_test2(:,3)=cali_test2(n+1:n+test,3);
    
    min_score=round(tcc(-4,trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),D));
    d_score=zeros(length(raw_score),1);
    for j_score=1:length(raw_score)
        d_score(j_score)=conversion(raw_score(j_score),trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),d_test2(:,1),d_test2(:,2),d_test2(:,3),D,1);
    end
    if y==repli
        conversion_table=[conversion_table d_score];
    end
    conversion_diff_d=RMSE(scaled_score,d_score);
else
    areadiffIdsquare=0;
    rmse_dsquare=0;
    bias_dsquare=0;
    conversion_diff_d=0;
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
      
    areadiffIman=areadiff(parameter1(Iman,:),parameter2(Iman,:),D);
    if figure_switch==1
        figure(4) 
        Draw_DIF(parameter1(Iman,2),parameter1(Iman,3),parameter1(Iman,4),parameter2(Iman,2),parameter2(Iman,3),parameter2(Iman,4),D,n);
    end
    theta_equate_man=theta_mle*data{1,2}+data{1,3};
    % estimate second year theta values using equated parameters with detection
    theta_mle_man=theta_mle*data{1,2}+data{1,3};
    rmse_man=RMSE(Theta2,theta_mle_man);
    bias_man=BIAS(Theta2,theta_mle_man);
    
    % conversion table
    man_test2(:,1)=cali_test2(n+1:n+test,1)*data{1,2};
    man_test2(:,2)=cali_test2(n+1:n+test,2)*data{1,2}+data{1,3};
    man_test2(:,3)=cali_test2(n+1:n+test,3);
    
    min_score=round(tcc(-4,trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),D));
    man_score=zeros(length(raw_score),1);
    for j_score=1:length(raw_score)
        man_score(j_score)=conversion(raw_score(j_score),trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),man_test2(:,1),man_test2(:,2),man_test2(:,3),D,1);
    end
    if y==repli
        conversion_table=[conversion_table man_score];
    end
    conversion_diff_man=RMSE(scaled_score,man_score);
else
    areadiffIman=0;
    rmse_man=0;
    bias_man=0;
    conversion_diff_man=0;
end
clear theta_mle_man data;
delete link.stu

%% summarize four rates 
condp     =[k+1:n];  %conditional positive
condn     =[1:k]  ;  %conditional negative

% test positive
testp_tcc =I;        
testp_d   =Idsquare;
testp_man =Iman;

% test negative
testn_tcc =setdiff(1:n,I);
testn_d   =setdiff(1:n,Idsquare);
testn_man =setdiff(1:n,Iman);

% true positive: condition is true & test result is true (both no drift)
tp_tcc    =intersect(condp,testp_tcc);
tp_d      =intersect(condp,testp_d);
tp_man    =intersect(condp,testp_man);

% false positive: condition is negative & test result is true (Type I error)
fp_tcc    =intersect(condn,testp_tcc);
fp_d      =intersect(condn,testp_d);
fp_man    =intersect(condn,testp_man);

% true negative: condition is negative & test result is negative 
tn_tcc    =intersect(condn,testn_tcc);
tn_d      =intersect(condn,testn_d);
tn_man    =intersect(condn,testn_man);

% false negative: condition is positive & test result is negative (Type II error)
fn_tcc    =intersect(condp,testn_tcc);
fn_d      =intersect(condp,testn_d);
fn_man    =intersect(condp,testn_man);

% sensitivity: sum(true positive)/sum(condition positive)
sens_tcc  =length(tp_tcc )/length(condp);
sens_d    =length(tp_d   )/length(condp);
sens_man  =length(tp_man )/length(condp);

% specificity: sum(true negative)/sum(condition negative)
spec_tcc  =length(tn_tcc )/length(condn);
spec_d    =length(tn_d   )/length(condn);
spec_man  =length(tn_man )/length(condn);

% summarize the results
areas(y,:)=[areadiff1 areadiffI areadiffIdsquare areadiffIman];
% areas(y,:)=[ areadiffI ];

% biases(y,:)          =[bias_baseline bias_stepwise bias_dsquare bias_man];
% rmses(y,:)           =[rmse_baseline rmse_stepwise rmse_dsquare rmse_man];
conversion_diffs(y,:)=[conversion_diff_tcc conversion_diff_d conversion_diff_man];
% conversion_diffs(y,:)=[conversion_diff_tcc ];

sensitivities(y,:)   =[sens_tcc sens_d sens_man];
specificities(y,:)   =[spec_tcc spec_d spec_man];

% sensitivities(y,:)   =[sens_tcc ];
% specificities(y,:)   =[spec_tcc ];

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
   