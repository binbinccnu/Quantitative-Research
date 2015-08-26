close all

hold on 
xlim([-2,2])
ylim([-2,2])

plot(1,1,'oblack')
text(1,1.2,'d_1^*=(\theta_{11},\theta_{12})')

plot(1,-1,'oblack')
text(1,-.8,'d_2^*=(\theta_{21},\theta_{22})')

plot(-1,-1,'oblack')
text(-1,-.8,'d_3^*=(\theta_{31},\theta_{32})')

plot(-1,1,'oblack')
text(-1,1.2,'d_4^*=(\theta_{41},\theta_{42})')

plot(linspace(-2,2,10),2*ones(10,1),'black','LineWidth',.004)
plot(linspace(-2,2,10),-2*ones(10,1),'black','LineWidth',.004)
plot(2*ones(10,1),linspace(-2,2,10),'black','LineWidth',.004)
plot(-2*ones(10,1),linspace(-2,2,10),'black','LineWidth',.004)

plot(0*ones(10,1),linspace(-2,2,10),'--black')
plot(linspace(-2,2,10),0*ones(10,1),'--black')
