function [areadiff]=areadiff(parameter1,parameter2,D)

% This function calculates the area difference between two TCCs
% Input parameter1 is the item parameters of 1st year items we wanna compare
% Input parameter2 is the item parameters of 2nd year items
% Output is the are difference of two TCC functions
% If a1 b1 c1 are scalars, the function reduces to are difference between
% two ICCs

%get ability points between [-4,4] with equal space
m=[1:181]';
d=8/(181-1);
ability=-4+d*(m-1);

%compute desity of each ability point under normal distribution assumption
weight=normpdf(ability);

%Calculate the TCC function of the two sets of items (1st year and 2nd year)
tcc1=tcc(ability,parameter1(:,2),parameter1(:,3),parameter1(:,4),D);
tcc2=tcc(ability,parameter2(:,2),parameter2(:,3),parameter2(:,4),D);

%Compute weighted area difference
areadiff=sum(d*abs(tcc1-tcc2));