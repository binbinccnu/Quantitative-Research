close all
a1 = 1; a2 = 1; b = -2;

X_1 = -2:.1:2;
X_2 = X_1;

z_1 = ( 1.22 - b - a1*X_1)/a2;
z_2 = (-1.22 - b - a1*X_1)/a2;

plot(X_1,z_1,'black')
hold on 
plot(X_1,z_2,'black')
xlabel('\theta_1')
ylabel('\theta_2')
ylim([-2,2])
plot(X_1,X_1+2,'black')
plot(X_1,X_1-2,'black')
plot(X_1,0*X_1,'.black')
plot(X_1*0,X_1,'.black')
% 
% plot(-.39,-.39+2,'oblack')
% text(-.35,-.39+2.1,'d_3^*')
% 
% plot( .39, .39-2,'oblack')
% text( .35, .31-2.1,'d_2^*')
% 
% plot(1.61,1.61-2,'oblack')
% text(1.55,1.55-2.1,'d_1^*')
% 
% plot(-1.61,-1.61+2,'oblack')
% text(-1.61,-1.55+2.1,'d_4^*')
% 

text(0.05,1.25,'z=1.22')
text(-0.4,-.8,'z=-1.22')

text(-.9,1,'diff(x_1,x_2)=-2')
text( 1,-1,'diff(x_1,x_2)= 2')