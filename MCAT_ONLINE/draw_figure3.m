close all;
hold on 
xlim([-2,2])
ylim([-2,2])

plot(linspace(-2,2,10),2*ones(10,1),'black','LineWidth',.004)
plot(linspace(-2,2,10),-2*ones(10,1),'black','LineWidth',.004)
plot(2*ones(10,1),linspace(-2,2,10),'black','LineWidth',.004)
plot(-2*ones(10,1),linspace(-2,2,10),'black','LineWidth',.004)

plot(0*ones(10,1),linspace(-2,2,10),'--black')
plot(linspace(-2,2,10),0*ones(10,1),'--black')

a_1 = 1; a_2 = 1; 
% a1x + a2y + b =0; y = (-b -a1x)/a2
% orthogonal y = a2/a1 * x
for b = linspace(-2,2,5)
    plot(linspace(-2,2,10), -b -a_1*linspace(-2,2,10)/a_2,'black')
end

text(-1.9,.1,'b=2')
text(-1.4,.5,'b=1')
text(-.9,1,'b=0')
text(-.4,1.5,'b=-1')
text(0.2,1.9,'b=-2')

plot(linspace(-2,2,100),a_2/a_1*linspace(-2,2,100),'.black')

plot(-1,-1,'oblack'); text(-.9,-1,'S1')
plot(-.5,-.5,'oblack'); text(-.4,-.5,'S2')
plot(0,0,'oblack'); text(.1,0,'S3')
plot(.5,.5,'oblack'); text(.6,.5,'S4')
plot(1,1,'oblack'); text(1.1,1,'S5')