function [U1,U2,n1,n2,n3,n4,n5,parameter1,parameter2,parameter_test1,parameter_test2,k,Theta2]=datageneratesingle(n,test,N,p1,p2,p3,p4,p5,D,a_scale,b_scale,c_scale)
% This function generates true item parameters in the 1st year and
% artifically generates some drifted items in the 2nd year
% N is the number of examinees
% n is the number of items
% P1-p5 is the proportion of different types of drifts
%  p1 is c-parameter shift
%  p2 is bc-parameter shift
%  p3 is b-parameter shift
%  p4 is a-parameter shift
%  p5 is extreme shift

%% simulate common item parameters
Theta1=normrnd(0,1,N,1);
Theta2=normrnd(0,1,N,1);
ab=mvnrnd([0,0],[0.1,0.2;0.2,0.5],n+test);
a=exp(ab(:,1));
b=ab(:,2);
c=[.2*ones(1,n+test)]';

%simulate unique item parameters for test 1
ab_test1=ab(n+1:n+test,:);   %ab values are following multivariate normal distribution 
a_test1 =exp(ab_test1(:,1)); %extract a parameters
b_test1 =ab_test1(:,2);      %extract b parameters
c_test1 =c(n+1:n+test);      %fix c parameters to be .2

%simulate unique item parameters for test 2
ab_test2=mvnrnd([0,0],[0.1,0.2;0.2,0.5],test);
a_test2 =exp(ab_test2(:,1));
b_test2 =ab_test2(:,2);
c_test2 =[.2*ones(1,test)]';

%union those parameters
parameter1=[(1:n)',a(1:n),b(1:n),c(1:n)];
parameter2=parameter1;
parameter_test1=[(1:test)',a_test1,b_test1,c_test1];
parameter_test2=[(1:test)',a_test2,b_test2,c_test2];

%% simulate item parameter drift for the second administration
%first get the number of drifted items for each type
n1=round(n*p1);
n2=round(n*p2);
n3=round(n*p3);
n4=round(n*p4);
n5=round(n*p5);
k=n1+n2+n3+n4+n5;  %this is the total number of drifted items

%simulate drift for each type
for i=1:n1 % c-shift
    seed=1;
    parameter2(i,4)=parameter2(i,4)+seed*c_scale;
end
for i=1:n2 % bc-shift
    seed1= 1;
    parameter2(i+n1,4)=parameter2(i+n1,4)+seed1*c_scale;
    seed2= -1 ;
    parameter2(i+n1,3)=parameter2(i+n1,3)-seed2*b_scale;
end
for i=1:n3 % b-shift
    seed= -1 ;
    parameter2(i+n1+n2,3)=parameter2(i+n1+n2,3)+seed*b_scale;
end
for i=1:n4 % a-shift
    seed= -1 ;
    parameter2(i+n1+n2+n3,2)=parameter2(i+n1+n2+n3,2)+a_scale*seed;
end
for i=1:n5 % extreme-shift
    seed1=-1;seed2=-1;seed3=1;
    parameter2(i+n1+n2+n3+n4,2)=parameter2(i+n1+n2+n3+n4,2)+a_scale*seed1;
    parameter2(i+n1+n2+n3+n4,3)=parameter2(i+n1+n2+n3+n4,3)+b_scale*seed2;
    parameter2(i+n1+n2+n3+n4,4)=parameter2(i+n1+n2+n3+n4,4)+c_scale*seed3;
end

%% generate resonse data
U1=Examinee_Response_Simulation(Theta1,[parameter1(:,2);parameter_test1(:,2)],[parameter1(:,3);parameter_test2(:,3)],[parameter1(:,4);parameter_test2(:,4)],D);
U2=Examinee_Response_Simulation(Theta2,[parameter2(:,2);parameter_test2(:,2)],[parameter2(:,3);parameter_test2(:,3)],[parameter2(:,4);parameter_test2(:,4)],D);
%note:This U2 contains response both common items(true drifted items) and second year unique items
