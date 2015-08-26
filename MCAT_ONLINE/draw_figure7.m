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
for b = 0
    plot(linspace(-2,2,10), -b -a_1*linspace(-2,2,10)/a_2,'black')
end

text(-.9,1,'b=0')

plot(linspace(-2,2,100),a_2/a_1*linspace(-2,2,100),'.black')

plot(-1,-1,'oblack'); text(-.9,-1,'(\theta_{11},\theta_{12})')
plot(0,0,'oblack'); text(.1,0,'S')
plot(1,1,'oblack'); text(1.1,1,'(\theta_{31},\theta_{32})')
plot(1,1,'oblack'); text(-.9,-1,'(\theta_{21},\theta_{22})')
plot(1.5,-1.5,'oblack'); text(.1,0,'S')
plot(-1.5,1.5,'oblack'); text(1.1,1,'(\theta_{41},\theta_{42})')