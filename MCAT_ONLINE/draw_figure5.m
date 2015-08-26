clc; 
close all;
a1 = 1; a2 = 1; b = 0; 

k = 2.399;
theta_11 = min(2,(k-b)*a1/(a1^2+a2^2));
theta_12 = min(2,(k-b)*a2/(a1^2+a2^2));
theta_31 = max(-2,-(k+b)*a1/(a1^2+a2^2));
theta_32 = max(-2,-(k+b)*a2/(a1^2+a2^2));
%%
number_point = 50;
k2 = linspace(-20,20,1000); k4 = k2;
d2 = linspace(.01,2,number_point); d4 = d2;
theta21_lower = (k2-b-2*a2)./a1;
theta21_upper = (k2-b+2*a2)./a1;

part1 = a1/(a1^2+a2^2).*k2;       part1_ = repmat(part1,length(d2),1);
part2 = (1+exp(k2));            part2_ = repmat(part2,length(d2),1);
part3_ = repmat(d2',1,length(k2));
part4 = exp(k2);                part4_ = repmat(part4,length(d2),1);
part5 = a1/(a1^2+a2^2)*b;   

theta21_2 = part1_ - part2_.*sqrt(part3_./part4_) - part5;

if a1 >= a2
    Distance = theta21_2 - repmat(theta21_lower,length(d2),1);
else
    Distance = theta21_2 - (-2);
end
d_max_index = sum(sum(Distance > 0 ,2) > 0) + 1;
if d_max_index == number_point+1
    d_max_index = number_point;
end
distance = Distance(d_max_index,:);
temp_theta21 = theta21_2(d_max_index,:);

%
for j = 1:length(d2)
    xlim([-5,5]);ylim([-2,2]);xlabel('k_2');ylabel('\theta_{21}');title('Find \theta_{21}')
    
%     plot(k2,theta21_upper,'black');
    hold on;
    plot(k2,theta21_lower,'black')
    plot(k2,theta21_upper,'black')
    
    theta21_1 = part1 + part2.*sqrt(d2(j)./part4) - part5;
    plot(k2,theta21_1,'r')
    theta21_2 = part1 - part2.*sqrt(d2(j)./part4) - part5;
    plot(k2,theta21_2,'b')
    if a1 >= a2
        distance = theta21_2 - theta21_lower;
    else
        distance = theta21_2 - (-2);
    end
    if sum(distance > 0) == 0
        break
    end
end
