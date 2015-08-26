function Draw_DIF(a1,b1,c1,a2,b2,c2,D,n)
%% this function draws two TCC curves used to compare their differences
%a1,b1,c1 are a,b,c parameters of items in the first administration
%a2,b2,c2 are a,b,c parameters of items in the second administration

%get 181 quadrature points in [-4,4] by equal step
m=[1:181]';
d=8/(181-1);        %compute steps
ability=-4+d*(m-1); %get the quadrature points

%compute corresponding TCC points for both administrations
P1=tcc(ability,a1,b1,c1,D);
P2=tcc(ability,a2,b2,c2,D);

%plot the curvesc
hold on 
plot(ability,P1,'linewidth',1.5)
plot(ability,P2,'--','linewidth',1.5)
xlabel('Theta')
ylabel('True Score')
axis([-4 4 0 n])
hold off