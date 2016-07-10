clear
close all
clc

cd('C:\Users\auror_000\Dropbox\research\drift_cat');

single_switch=1;                         %single_swith=1 means single directional shift

repli=1;                                 %how many replications
N=50000;                                 %number of examinees
n=300;                                   %number of items in the item pool
figure_switch=1;                         %whether to plot ICC figures
D=1.703; 

test_length =24;                         %test length

a_scale=.5;                              %the scale of drift
b_scale=.5;
c_scale=.2;

nqt=81;                                  %number of quadrature points used in eap estimation

exposure_cat_1=zeros(repli,n);
exposure_cat_2=zeros(repli,n);
exposure_stra_1=exposure_cat_1;
exposure_stra_2=exposure_cat_2;
typeI_sb=zeros(repli,2);                    %Ho is true(no drift in real), but reject Ho
power_sb=zeros(repli,2);                    %Ha is true(drift in real), and reject Ho
typeI_chi=zeros(repli,2);                 %Ho is true(no drift in real), but reject Ho
power_chi=zeros(repli,2);                 %Ha is true(drift in real), and reject Ho
best_number_points=zeros(repli,2);
%%
for replication=1:repli
    replication
%%
    if mod(replication,5)==0
        replication=replication;                   
    end    

    if replication==repli;
        figure_switch=1;
    end
    
    data_simulation;    
    [strata_1_1,strata_2_1,strata_3_1]=stratification(a_1,b_1,c_1);
    
     CAT_SH_1;               %first administration with SH
     CAT_SH_2;               %second administration with SH
    

     CAT_stratification_1;    %first administration
     CAT_stratification_2;    %second administration
    
%    SIBTEST;
%    ANALYZE_RESULTS;          %results for detection efficiency
    
 %% %now begin to calibrate flaged items using bayesian method
    flag_sib_stra=find(sample_size(1:36)>=1000);
    MEM;
end

%% printting the results
TYPEI_sib=sum(typeI_sib,1)./sum(typeI_sib~=0,1);
POWER_sib=sum(power_sib,1)./sum(power_sib~=0,1);
% TYPEI_chi=sum(typeI_chi,1)./sum(typeI_chi~=0,1);
% POWER_chi=sum(power_chi,1)./sum(power_chi~=0,1);
TYPEI_sib
POWER_sib
%TYPEI_chi
%POWER_chi