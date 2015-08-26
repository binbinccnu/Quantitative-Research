function [theta,a,b,U] = MIRT_data_simulation(N,n)

theta = mvnrnd([0;0],[.5,0;0,.5],N);
theta(theta>2)  = 2;
theta(theta<-2) = -2;
a = mvnrnd([0;0],[.5,0; 0,.5],n);
a = exp(a);
a(a>2) = 2; 
b = normrnd(0,.5,n,1);
b(b>2)  = 2;
b(b<-2) = -2;
U = MIRT_response2D(theta(:,1),theta(:,2),a(:,1),a(:,2),b);