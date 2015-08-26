theta = linspace(-2,2,50);
[theta1,theta2] = meshgrid(theta);
p = mvnpdf([theta1(:) theta2(:)],[0 0],[.5 0;0 .5]);
p = reshape(p,length(theta2),length(theta1));
mesh(theta1,theta2,p)
xlabel('\theta_1')
ylabel('\theta_2')
zlabel('Density')


%%
a1 = 1.2; a2 = .7;
b = 0;
thetas = [theta1(:) theta2(:)];
f = MIRT_prob2D_matrix(thetas(:,1),thetas(:,2),a1,a2,b);
f = reshape(f,length(theta2),length(theta1));
mesh(theta1,theta2,f)
xlabel('\theta_1')
ylabel('\theta_2')
zlabel('Probability')

%%
contour(theta1,theta2,f)
xlabel('\theta_1')
ylabel('\theta_2')


%%
close all
theta = linspace(-2,2,60);
[theta1,theta2] = meshgrid(theta);
p = mvnpdf([theta1(:) theta2(:)],[0 0],[.5 0;0 .5]);
p = reshape(p,length(theta2),length(theta1));
hold on 

n = 50;
r = .25;
angle = linspace(0,2*pi,n);
x = r*sin(angle);
y = r*cos(angle);
f = mvnpdf([x(1),y(1)],[0 0],[.5 0;0 .5]);
h = linspace(0,f,n);

for j = 1:length(theta1)
    hold on 
    for j1 = 1:length(theta2)
        plot3(theta1(j,j1),theta2(j,j1),p(j,j1),'marker','.')
    end
end
for j = 1:length(x)
    for j1 = 1:length(x)
        plot3(x(j1),y(j1),h(j),'marker','.','color','black')
    end
end
xlabel('\theta_1')
ylabel('\theta_2')
zlabel('Density')

%%
close all
theta = linspace(-3,3,50);
f = normpdf(theta,0,1);
hold on 
plot(theta,f,'-b')
plot(zeros(50,1),linspace(0,normpdf(0,0,1),50),'--b')
xlabel('\theta')
ylabel('Density')
r = linspace(-1.5,1.5,20);
for j = 1:length(r)
    h = normpdf(r(j),0,1);
    plot(r(j)*ones(50,1),linspace(0,h,50),'-black')
end
annotation('arrow',[.52  .71],[0.11 0.11])
annotation('arrow',[.71  .52],[0.11 0.11])
annotation('arrow',[.32  .52],[0.11 0.11])
annotation('arrow',[.52  .32],[0.11 0.11])
text( .6,-.01,'r')
text(-.6,-.01,'r')