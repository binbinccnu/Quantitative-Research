function d=dsquare(parameter1,parameter2,D)

%This function calucates dsquare values with the following algorithms
% 1)generate 181 quadrature points and corresponding weights from the theta
% distribution of the old year
% 2)for each linking item, calculate a weighted sum of squared deviation
% between the old year ICC and new year ICC
% 3)find the 95th percentile value among d-square values of all linking items
% on all grades and subjects, which is regarded as the cut-off criterion
% for drift

%get quadrature points
n=size(parameter1,1);
m=[1:181]';
d=8/(181-1);
ability=-4+d*(m-1);

%calculate corresponding weights
w=normpdf(ability);

%calculate probabilities for all items
P1=P_Computation(ability,parameter1(:,2),parameter1(:,3),parameter1(:,4),D);
P2=P_Computation(ability,parameter2(:,2),parameter2(:,3),parameter2(:,4),D);

%compute d square values for all items
d=zeros(1,n);
for i=1:n
    for j=1:length(m)
        d(i)=d(i)+(P1(j,i)-P2(j,i)).^2*w(j);
    end
end