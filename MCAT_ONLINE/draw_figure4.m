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
for b = [0,1]
    plot(linspace(-2,2,10), -b -a_1*linspace(-2,2,10)/a_2,'black')
end

%text(-1.9,.1,'b=2')
text(-1.4,.5,'b=1')
text(-.9,1,'b=0')
text(0,0,'(0,0)')
eqtext = '($$ba_1 \over a_1^2+a_2^2$$,$$ba_2 \over a_1^2+a_2^2$$)';
text(-1,-1,eqtext, 'Interpreter', 'Latex', 'FontSize', 12)
%text(-.4,1.5,'b=-1')
%text(0.2,1.9,'b=-2')

annotation('arrow',[.52 .445],[.52 .385])
plot(0,0,'oblack')
plot(-.5,-.5,'oblack')