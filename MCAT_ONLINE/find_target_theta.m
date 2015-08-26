function [theta_11,theta_12,theta_21,theta_22,theta_31,theta_32,theta_41,theta_42] = find_target_theta(a1,a2,b)
k = 2.399;
theta_11 = min(2,(k-b)*a1/(a1^2+a2^2));
theta_12 = min(2,(k-b)*a2/(a1^2+a2^2));
theta_31 = max(-2,-(k+b)*a1/(a1^2+a2^2));
theta_32 = max(-2,-(k+b)*a2/(a1^2+a2^2));
%%
number_point = 10e+02;
k2 = linspace(-20,20,number_point); k4 = k2;
d2 = linspace(.01,2,number_point); d4 = d2;

%% find points 2 
theta21_lower = (k2-b-2*a2)./a1;

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

%%
% for j = 1:length(d2)
%     xlim([-5,5]);ylim([-2,0]);xlabel('k_2');ylabel('\theta_{21}');title('Find \theta_{21}')
%     
% %     plot(k2,theta21_upper,'black');
%     hold on;
%     plot(k2,theta21_lower,'black')
%     
%     theta21_1 = part1 + part2.*sqrt(d2(j)./part4) - part5;
%     plot(k2,theta21_1,'r')
%     theta21_2 = part1 - part2.*sqrt(d2(j)./part4) - part5;
%     plot(k2,theta21_2,'b')
%     if a1 >= a2
%         distance = theta21_2 - theta21_lower;
%     else
%         distance = theta21_2 - (-2);
%     end
%     if sum(distance > 0) == 0
%         break
%     end
% end


%%
[~, sort_index] = sort(abs(distance));
theta21_max = temp_theta21(sort_index(1));
k2_max = k2(sort_index(1));
if theta21_max <= -2 && k2_max > -2*a1+b+2*a2
    k2_max = min(k2_max,-2*a1+b+2*a2);
    theta21_max = -2;
end

theta_21 = max(-2,theta21_max);
theta_21 = min(0,theta_21);
theta_22 = min( 2,(k2_max - b - a1*theta21_max)/a2);
    

%% find points 4
theta41_upper = (k4-b+2*a2)./a1;
theta41_lower = (k4-b)./a1;


part1 = a1/(a1^2+a2^2).*k4;       part1_ = repmat(part1,length(d4),1);
part2 = (1+exp(k4));            part2_ = repmat(part2,length(d4),1);
part3_ = repmat(d4',1,length(k4));
part4 = exp(k4);                part4_ = repmat(part4,length(d4),1);
part5 = a1/(a1^2+a2^2)*b;   

theta41_1 = part1_ + part2_.*sqrt(part3_./part4_) - part5;

if a1 >= a2
    Distance = theta41_1 - repmat(theta41_upper,length(d4),1);
else
    Distance = theta41_1 - (2);
end
d_max_index = sum(sum(Distance < 0 ,2) > 0) + 1;
if d_max_index == number_point+1
    d_max_index = number_point;
end
distance = Distance(d_max_index,:);
temp_theta41 = theta41_1(d_max_index,:);

%%
% for j = 1:length(d4)
%     xlim([-4,4]); ylim([-2,2]); xlabel('k_4'); ylabel('\theta_{41}'); title('Find \theta_{41}')    
%     plot(k4,theta41_upper,'black'); hold on; 
%     plot(k4,theta41_lower,'black')
%     
%     theta41_1 = a1/(a1^2+a2^2).*k4 + (1+exp(k4+b)).*sqrt(d4(j)./exp(k4+b)) - a1/(a1^2+a2^2)*b;
%     plot(k4,theta41_1,'r')
%     theta41_2 = a1/(a1^2+a2^2).*k4 - (1+exp(k4+b)).*sqrt(d4(j)./exp(k4+b)) - a1/(a1^2+a2^2)*b;
%     plot(k4,theta41_2,'b')
%     if a1 >= a2
%         distance = theta41_1 - theta41_upper;
%     else
%         distance = theta41_1 - (2);
%     end
%     if sum(distance < 0) == 0
%         break
%     end
% end

%%
[~, sort_index] = sort(abs(distance));
theta41_max = temp_theta41(sort_index(1));
k4_max = k4(sort_index(1));
if theta41_max >= 2 && k4_max > 2*a1+b
    k4_max = min(k4_max,2*a1+b);
    theta41_max = 2;
end
theta_41 = min( 2,theta41_max);
theta_42 = max(-2,(k4_max - b - a1*theta41_max)/a2);
theta_42 = min(0,theta_42);