%% generate first year item parameters and thetas
% generate first year student abilities

%generate intial item parameters 
a_1=zeros(1,n);b_1=zeros(1,n);c_1=.2*ones(1,n);
for j2=1:n
    flag=1;
    while (flag==1)
           temp=exp(normrnd(0,sqrt(.1225)));
           if (temp>=0.2) && (temp<=2.5)
               a_1(j2)=temp;
               flag=0;
           end
    end
end
for j3=1:n
    flag=1;
    while (flag==1)
           temp=randn;
           if (temp>=-3) && (temp<=3)
               b_1(j3)=temp;
               flag=0;
           end
    end
end

%% generate parameters and abilities for the second administraton
theta_1=normrnd(0,1,N,1);
theta_2=normrnd(0,1,N,1);
%proportions of shift
p1=0.0; p2=0.00; p3=0.1; p4=0.0; p5=0.0;
p=p1+p2+p3+p4+p5;
%simulate shift for the second administration
if single_switch==1
    drift_single;
else
    drift_multiple;
end

%% generate real resonse data
U_1=Examinee_Response_Simulation(theta_1,a_1,b_1,c_1,D);
U_2=Examinee_Response_Simulation(theta_2,a_2,b_2,c_2,D);