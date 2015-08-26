clear; close all
a1 = 1; a2 = 1; b = 2; N = 100; replication = 1000; par = [a1 a2 b]
[x1,x2,x3,x4,y1,y2,y3,y4] = sitter(a1,a2,b);
[theta_21,theta_22,theta_41,theta_42] = find_target_theta(a1,a2,b);
logit_optimal = untitled(b);

%% method 1 currently best point
mse1 = 0; mse2 = 0; mse3 = 0; k = 2.0286;
theta1 = [[min(2,(k-b)*a1/(a1^2+a2^2)*ones(N/4,1)) min(2,(k-b)*a2/(a1^2+a2^2)*ones(N/4,1))];... % point 3
    [max(-2,-2*a2/a1*ones(N/4,1)) min( 2, 2*a1/a2*ones(N/4,1))];... % point 2
    [min( 2 ,2*a2/a1*ones(N/4,1)) max(-2,-2*a1/a2*ones(N/4,1))];... % point 4
    [max(-2,-(k+b)*a1/(a1^2+a2^2)*ones(N/4,1)) max(-2,-(k+b)*a2/(a1^2+a2^2)*ones(N/4,1))]];   % point 1
for rep = 1:replication 
    response_select = MIRT_response2D(theta1(:,1),theta1(:,2),a1,a2,b);    
    [a1_est,a2_est,b_est] = METHOD_A_MCAT2D(theta1(:,1),theta1(:,2),response_select);   
    mse1 = mse1 + (a1 - a1_est)^2; mse2 = mse2 + (a2 - a2_est)^2; mse3 = mse3 + (b - b_est)^2;
end
rmse1 = [sqrt(mse1/rep) sqrt(mse2/rep) sqrt(mse3/rep)]
k2 = a1*theta1(N/4+1,1) + a2*theta1(N/4+1,2) + b; k4 = a1*theta1(2*N/4+1,1) + a2*theta1(2*N/4+1,2) + b;
d1 = [exp(k2)/(1+exp(k2))^2 * (a1/(a1^2+a2^2)*(k2-b) - theta1(N/4+1,1))^2 ...
    exp(k4)/(1+exp(k4))^2 * (a1/(a1^2+a2^2)*(k4-b) - theta1(2*N/4+1,1))^2];

%% method 1 currently best point
mse1 = 0; mse2 = 0; mse3 = 0; 
theta1 = [[min(2,logit_optimal*a1/(a1^2+a2^2)*ones(N/4,1)) min(2,logit_optimal*a2/(a1^2+a2^2)*ones(N/4,1))];... % point 3
    [max(-2,-2*a2/a1*ones(N/4,1)) min( 2, 2*a1/a2*ones(N/4,1))];... % point 2
    [min( 2 ,2*a2/a1*ones(N/4,1)) max(-2,-2*a1/a2*ones(N/4,1))];... % point 4
    [max(-2,-logit_optimal*a1/(a1^2+a2^2)*ones(N/4,1)) max(-2,-logit_optimal*a2/(a1^2+a2^2)*ones(N/4,1))]];   % point 1

for rep = 1:replication 
    response_select = MIRT_response2D(theta1(:,1),theta1(:,2),a1,a2,b);    
    [a1_est,a2_est,b_est] = METHOD_A_MCAT2D(theta1(:,1),theta1(:,2),response_select);   
    mse1 = mse1 + (a1 - a1_est)^2; mse2 = mse2 + (a2 - a2_est)^2; mse3 = mse3 + (b - b_est)^2;
end
rmse1 = [sqrt(mse1/rep) sqrt(mse2/rep) sqrt(mse3/rep)]
k2 = a1*theta1(N/4+1,1) + a2*theta1(N/4+1,2) + b; k4 = a1*theta1(2*N/4+1,1) + a2*theta1(2*N/4+1,2) + b;
d1 = [exp(k2)/(1+exp(k2))^2 * (a1/(a1^2+a2^2)*(k2-b) - theta1(N/4+1,1))^2 ...
    exp(k4)/(1+exp(k4))^2 * (a1/(a1^2+a2^2)*(k4-b) - theta1(2*N/4+1,1))^2];

%% method 2
mse1 = 0; mse2 = 0; mse3 = 0; 
theta2 = [[x1*ones(N/4,1) y1*ones(N/4,1)];...
    [x2*ones(N/4,1) y2*ones(N/4,1)];...
    [x3*ones(N/4,1) y3*ones(N/4,1)];...
    [x4*ones(N/4,1) y4*ones(N/4,1)]];
for rep = 1:replication 
    response_select = MIRT_response2D(theta2(:,1),theta2(:,2),a1,a2,b);    
    [a1_est,a2_est,b_est] = METHOD_A_MCAT2D(theta2(:,1),theta2(:,2),response_select);   
    mse1 = mse1 + (a1 - a1_est)^2; mse2 = mse2 + (a2 - a2_est)^2; mse3 = mse3 + (b - b_est)^2;
end
rmse2 = [sqrt(mse1/rep) sqrt(mse2/rep) sqrt(mse3/rep)]
k2 = a1*theta2(N/4+1,1) + a2*theta2(N/4+1,2); k4 = a1*theta2(2*N/4+1,1) + a2*theta2(2*N/4+1,2);
d2 = [exp(k2+b)/(1+exp(k2+b))^2 * (a1/(a1^2+a2^2)*(k2-b) - theta2(N/4+1,1))^2 ...
    exp(k4+b)/(1+exp(k4+b))^2 * (a1/(a1^2+a2^2)*(k4-b) - theta2(2*N/4+1,1))^2];

%% method 3
mse1 = 0; mse2 = 0; mse3 = 0; 
theta3 = [[min(2,(k-b)*a1/(a1^2+a2^2)*ones(N/4,1)) min(2,(k-b)*a2/(a1^2+a2^2)*ones(N/4,1))];... % point 3
    [theta_21*ones(N/4,1) theta_22*ones(N/4,1)];...
    [theta_41*ones(N/4,1) theta_42*ones(N/4,1)];...
    [max(-2,-(k+b)*a1/(a1^2+a2^2)*ones(N/4,1)) max(-2,-(k+b)*a2/(a1^2+a2^2)*ones(N/4,1))]];   % point 1
for rep = 1:replication 
    response_select = MIRT_response2D(theta3(:,1),theta3(:,2),a1,a2,b);    
    [a1_est,a2_est,b_est] = METHOD_A_MCAT2D(theta3(:,1),theta3(:,2),response_select);   
    mse1 = mse1 + (a1 - a1_est)^2; mse2 = mse2 + (a2 - a2_est)^2; mse3 = mse3 + (b - b_est)^2;
end
rmse3 = [sqrt(mse1/rep) sqrt(mse2/rep) sqrt(mse3/rep)]
k2 = a1*theta3(N/4+1,1) + a2*theta3(N/4+1,2) +b; k4 = a1*theta3(2*N/4+1,1) + a2*theta3(2*N/4+1,2) +b;
d3 = [exp(k2)/(1+exp(k2))^2 * (a1/(a1^2+a2^2)*(k2-b) - theta3(N/4+1,1))^2 ...
    exp(k4)/(1+exp(k4))^2 * (a1/(a1^2+a2^2)*(k4-b) - theta3(2*N/4+1,1))^2];

%% method 4 estimate b
mse1 = 0; mse2 = 0; mse3 = 0; 
theta_1 = normrnd(0,.8,N,1);
theta_2 = ( -a1*theta_1)/a2;
theta3 = [theta_1 theta_2];   
for rep = 1:replication 
    response_select = MIRT_response2D(theta3(:,1),theta3(:,2),a1,a2,b);    
    [a1_est,a2_est,b_est] = METHOD_A_MCAT2D(theta3(:,1),theta3(:,2),response_select);   
    mse1 = mse1 + (a1 - a1_est)^2; mse2 = mse2 + (a2 - a2_est)^2; mse3 = mse3 + (b - b_est)^2;
end
rmse3 = [sqrt(mse1/rep) sqrt(mse2/rep) sqrt(mse3/rep)]
k2 = a1*theta3(N/4+1,1) + a2*theta3(N/4+1,2) +b; k4 = a1*theta3(2*N/4+1,1) + a2*theta3(2*N/4+1,2) +b;
d3 = [exp(k2)/(1+exp(k2))^2 * (a1/(a1^2+a2^2)*(k2-b) - theta3(N/4+1,1))^2 ...
    exp(k4)/(1+exp(k4))^2 * (a1/(a1^2+a2^2)*(k4-b) - theta3(2*N/4+1,1))^2];


%% method 5 random
mse1 = 0; mse2 = 0; mse3 = 0; 
theta3 = mvnrnd([0; 0],[.5,0;0,.5],N);
for rep = 1:replication 
    response_select = MIRT_response2D(theta3(:,1),theta3(:,2),a1,a2,b);    
    [a1_est,a2_est,b_est] = METHOD_A_MCAT2D(theta3(:,1),theta3(:,2),response_select);   
    mse1 = mse1 + (a1 - a1_est)^2; mse2 = mse2 + (a2 - a2_est)^2; mse3 = mse3 + (b - b_est)^2;
end
rmse3 = [sqrt(mse1/rep) sqrt(mse2/rep) sqrt(mse3/rep)]
k2 = a1*theta3(N/4+1,1) + a2*theta3(N/4+1,2) +b; k4 = a1*theta3(2*N/4+1,1) + a2*theta3(2*N/4+1,2) +b;
d3 = [exp(k2)/(1+exp(k2))^2 * (a1/(a1^2+a2^2)*(k2-b) - theta3(N/4+1,1))^2 ...
    exp(k4)/(1+exp(k4))^2 * (a1/(a1^2+a2^2)*(k4-b) - theta3(2*N/4+1,1))^2];


%% method 6 combine
mse1 = 0; mse2 = 0; mse3 = 0;
x1 = a1/(a1^2+a2^2) * 1.8153;     y1 = a2/(a1^2+a2^2) * 1.8153;
x2 = a1/(a1^2+a2^2) * (-1.8153);  y2 = a2/(a1^2+a2^2) * 1.8153;
x3 = -x1; y3 = -y1;
x4 = -x2; y4 = -y2;

theta3 = [[x1*ones(N/4,1) y1*ones(N/4,1)];...
    [x2*ones(N/4,1) y2*ones(N/4,1)];...
    [x3*ones(N/4,1) y3*ones(N/4,1)];...
    [x4*ones(N/4,1) y4*ones(N/4,1)]];
for rep = 1:replication 
    response_select = MIRT_response2D(theta3(:,1),theta3(:,2),a1,a2,b);    
    [a1_est,a2_est,b_est] = METHOD_A_MCAT2D(theta3(:,1),theta3(:,2),response_select);   
    mse1 = mse1 + (a1 - a1_est)^2; mse2 = mse2 + (a2 - a2_est)^2; mse3 = mse3 + (b - b_est)^2;
end
rmse3 = [sqrt(mse1/rep) sqrt(mse2/rep) sqrt(mse3/rep)]
k2 = a1*theta3(N/4+1,1) + a2*theta3(N/4+1,2) +b; k4 = a1*theta3(2*N/4+1,1) + a2*theta3(2*N/4+1,2) +b;
d3 = [exp(k2)/(1+exp(k2))^2 * (a1/(a1^2+a2^2)*(k2-b) - theta3(N/4+1,1))^2 ...
    exp(k4)/(1+exp(k4))^2 * (a1/(a1^2+a2^2)*(k4-b) - theta3(2*N/4+1,1))^2];

%%
close all
plot(theta_1,theta_2,'.black')
hold on
plot(theta_1,(-b-a1*theta_1)/a2,'-black')
xlim([-2,2])
ylim([-2,2])