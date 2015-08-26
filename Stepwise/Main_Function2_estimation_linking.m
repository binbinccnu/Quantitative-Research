%% conduct linking procedure first 
fid=fopen('link.stu','wt')
fprintf(fid,'%3s%2d','NE ',size(eparameter1,1));fprintf(fid,'\n');
for j=1:size(eparameter1,1)
    fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, eparameter2(j,1),eparameter2(j,2),eparameter2(j,3));fprintf(fid,'\n');
end
fprintf(fid,'%5x');fprintf(fid,'\n');fprintf(fid,'%3s%2d','OL ',size(eparameter1,1));fprintf(fid,'\n');
for j=1:size(eparameter1,1)
    fprintf(fid,'%3d %4s %1d %4s %7.4f %7.4f %7.4f %7.4f',j,' L3 ',2,' DW ',1.703, eparameter1(j,1),eparameter1(j,2),eparameter1(j,3));fprintf(fid,'\n');
end
fprintf(fid,'%5x');fprintf(fid,'\n');
fprintf(fid,'%3s %2d %3s','CI',n,'AO');fprintf(fid,'\n');
fprintf(fid,'%5x');fprintf(fid,'\n');
fprintf(fid,'%2s','OP');fprintf(fid,'\n');
fprintf(fid,'%3s %2s','KO ','SL');fprintf(fid,'\n');
fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','ND ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n');
fprintf(fid,'%3s %2d %4s %6.4f %6.4f %6.4f','OD ',181,' PN ',0.0000,1.0000,4.0000);fprintf(fid,'\n');
fprintf(fid,'%3s %3s %2s','SY ','BI ','BI');fprintf(fid,'\n');
fprintf(fid,'%3s %3s %2s','FS ','DO ','DO');fprintf(fid,'\n');
fprintf(fid,'%2s','BY');fprintf(fid,'\n');
fclose(fid);
!link.bat
!ren link.stu.out link.txt
%extract link.stu.out and conductin linking
fid=fopen('link.txt');
data=textscan(fid,'%s %f %f',1,'headerLines',464+2*n);
fclose(fid); delete link.txt
equate(:,1)=eparameter2(:,1)*data{1,2};
equate(:,2)=eparameter2(:,2)*data{1,2}+data{1,3};
equate(:,3)=eparameter2(:,3);

%Draw the TCC plot of the 1st year TCC and 2nd year TCC
if figure_switch==1
    figure(1)
    Draw_DIF(eparameter1(1:n,1),eparameter1(1:n,2),eparameter1(1:n,3),equate(1:n,1),equate(1:n,2),equate(1:n,3),D,n);
end

allequate=equate;
parameter1=[[1:n]' eparameter1(1:n,:)];
parameter2=[[1:n]' allequate(1:n,:)];
areadiff1=areadiff(parameter1(1:n,:),parameter2(1:n,:),D);

delete link.stu link.txt
%% estimate second year theta values using equated parameters without detection
%this is the baseline 
theta_mle=zeros(N,1);
for p=1:N
    theta_mle(p)=mle_theta(cali_test2(:,1),cali_test2(:,2),cali_test2(:,3),D,U2(p,:));
end
theta_mle_baseline=theta_mle*data{1,2}+data{1,3};
rmse_baseline=RMSE(Theta2,theta_mle_baseline);
bias_baseline=BIAS(Theta2,theta_mle_baseline);
clear theta_mle_baseline;

%% construct the conversion table using equated parameters without detection
%this is the baseline
min_score=round(tcc(-4,trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),D));
raw_score=[min_score:1:test]';
scaled_score=zeros(length(raw_score),1);
for j_score=1:length(raw_score)
    scaled_score(j_score)=conversion(raw_score(j_score),trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),trupar_test2(:,2),trupar_test2(:,3),trupar_test2(:,4),D,1);
end
if y~=0
    if y==repli
        conversion_table=[raw_score scaled_score];
    end
end
%compute baseline conversion difference
ecali_test2(:,1)=cali_test2(:,1)*data{1,2};
ecali_test2(:,2)=cali_test2(:,2)*data{1,2}+data{1,3};
ecali_test2(:,3)=cali_test2(:,3);

min_score=round(tcc(-4,trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),D));
baseline_score=zeros(length(raw_score),1);
for j_score=1:length(raw_score)
    baseline_score(j_score)=conversion(raw_score(j_score),trupar_test1(:,2),trupar_test1(:,3),trupar_test1(:,4),cali_test2(n:n+test,1),cali_test2(n:n+test,2),cali_test2(n:n+test,3),D);
end
if y==repli
    conversion_table=[conversion_table baseline_score];
end
conversion_diff_baseline=RMSE(scaled_score,baseline_score);
clear data;