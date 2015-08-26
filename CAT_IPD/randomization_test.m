%null hypothesis is that two samples have the same distribution
%alternative is that one is stochastically larger than the other one
%consider R=(rank(x1),rank(x2),...,rank(xn),rank(y1),rank(y2),...,rank(ym))

flag_rad=9*ones(n,1);
for j=1:n  %for each item
    %get all the students from this item
    x=sparse_matrix_cat_1(:,j);%examinee id of sample 1
    y=sparse_matrix_cat_2(:,j);
    theta_x=theta_1(x~=9);
    theta_y=theta_2(y~=9);  
    Z=[theta_x;theta_y];
    R=ordered(Z);
    T_stat=sum(R(1:length(theta_x)))/length(theta_x)-sum(R(1+length(theta_x):length(R)))/length(theta_y);
    var=length(R)*(length(R)+1)/12*(1/length(theta_x)+1/length(theta_y));
    standard_T=T_stat/sqrt(var);
    flag_rad(j)=abs(standard_T)>1.96;
end
flag_rad=find(flag_rad==1);
typeIrate=length(flag_rad(flag_rad>round(n*p)))/(n-round(n*p))
power=length(flag_rad(flag_rad<=round(n*p)))/round(n*p)