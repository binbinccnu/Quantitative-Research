%% this subroutine simulates item parameter shift

a_2=a_1;
b_2=b_1;
c_2=c_1;
%% number of drifted items in each category
n1=round(n*p1);
n2=round(n*p2);
n3=round(n*p3);
n4=round(n*p4);
n5=round(n*p5);
k=n1+n2+n3+n4+n5;

%% generate shift for each category
for i=1:n1 % c-shift
    seed=1;
    c_2(i)=c_1(i)+seed*c_scale;
end
for i=1:n2 % bc-shift
    seed1=1;
    c_2(i+n1)=c_1(i+n1)+seed1*c_scale;
    seed2=-1;
    b_2(i+n1)=b_1(i+n1)-seed2*b_scale;
end
for i=1:n3 % b-shift
    seed=1;
    b_2(i+n1+n2)=b_1(i+n1+n2)-seed*b_scale;
end
for i=1:n4 % a-shift
    seed=-1;
    a_2(i+n1+n2+n3)=a_1(i+n1+n2+n3)+a_scale*seed;
end
for i=1:n5 % extrem-shift
    seed1=-1;seed2=-1;seed3=1;
    a_2(i+n1+n2+n3+n4)=a_1(i+n1+n2+n3+n4)+a_scale*seed1;
    b_2(i+n1+n2+n3+n4)=b_1(i+n1+n2+n3+n4)-b_scale*seed2;
    c_2(i+n1+n2+n3+n4)=c_1(i+n1+n2+n3+n4)+c_scale*seed3;
end

%% real first adminisration items and real second administered items
% if figure_switch==1
%     figure(1)
%     Draw_DIF(a_1,b_1,c_1,a_2,b_2,c_2,D);
%     hold off
% end