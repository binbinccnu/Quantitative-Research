
%% the goal of this study is to compare different methods in item parameter drift detection
%  in paper-pencil based educational testing
%  three methods are: Stepwise TCC Method, d square Method, and Mantel
%  Haenszel method.

%% preparation
cd('C:\Users\auror_000\Desktop\TCC_revise_2\simulation');
clear
close all
clc

%% initialize some fixed variables
repli=50;        %number of replications

N=3000;          %number of examinees
alpha=[.05 .1 .15 .2 .25 .3 .35 .4 .45 .5 .55 .6 .65 .7 .75 .8 .85 .9 .95 1];

single_switch=1; %single direction drift or multiple direction
figure_switch=0; %whether to draw figures

n=15;            %number of common items
test=30;         %unique test length
D=1.703;         %constant

%define drift scale
a_scale=.5;
b_scale=.4;
c_scale=.2;

%% compute csem
y=0;
Main_Function1_datasimulation; 
Main_Function2_estimation_linking;
CSEM;

%% this begins 100 replications
%%
for alpha_index=1:length(alpha)
for y=1:repli;
    y
    % draw figure at the last replication
    if y==repli;
        figure_switch=1;
    end
    
    Main_Function1_datasimulation; 
    Main_Function2_estimation_linking;
    Main_Function3_stepwise;
    Main_Function4_dsquare;
    Main_Function5_mantel_lord;
    Main_Function6_result;
end
clc
%%
area_compare(alpha_index,:)   =sum(areas) ./sum(areas~=0);
% bias_compare   =sum(biases)./sum(biases~=0)
% rmse_compare   =sum(rmses) ./sum(rmses~=0)
conversion_diff(alpha_index,:)=sum(conversion_diffs)./sum(conversion_diffs~=0);
sensitivity(alpha_index,:)=sum(sensitivities)./sum(sensitivities~=0);
specificity(alpha_index,:)=sum(specificities)./sum(specificities~=0);
end
%%
spec_sens=[specificity sensitivity];
clc
[area_compare conversion_diff spec_sens]
N
%% plot ROC curve
% figure(alpha_index+100)
% plot([0:.1:1],[0:.1:1],'--','color','black');
% annotation('textarrow',[.5 0.15],[.5 .9]);
% axis([0 1 0 1]);
% xlabel('1-Specificity');
% ylabel('Sensitivity');
% hold on
% text(1-specificity(1),sensitivity(1),'Tcc');
% hold on
% text(1-specificity(2),sensitivity(2),'d Square');
% hold on
% text(1-specificity(3),sensitivity(3),'Mantel-Haenszel');
% hold off
close all