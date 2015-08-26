%use theta estimate to match
%divide theta estimate into invervals
number_points=20;
intervals=linspace(-3,2.5,number_points)'; 
intervals=[intervals,[intervals(2:size(intervals,1));3]];  %divide the whole theta span into intervals
intervals(1,1)=-10;
intervals(size(intervals,1),2)=10;

interval_1=zeros(N,1);
interval_2=zeros(N,1);
sums=zeros(size(intervals,1),5);

for jj=1:N
    for jjj=1:size(intervals,1)
        %which interval does this examinee falls into
        if (theta_stra_1(jj)>=intervals(jjj,1) && theta_stra_1(jj)<intervals(jjj,2))
           interval_1(jj)=jjj;
        end
        if (theta_stra_2(jj)>=intervals(jjj,1) && theta_stra_2(jj)<intervals(jjj,2))           
           interval_2(jj)=jjj;          
        end
    end
end
 
statistic=zeros(n,1);
%%
for j1=1:n                    %for each item
    item_index=j1
    contingency=zeros(size(intervals,1),6); %first column: possible intervals
                              %second column:correct answers in focal group
                              %third column:incorrect answer in focal group    
                              %fourth column:correct answers in reference
                              %group
                              %fifth column:incorrect answers in reference
                              %group                             
    contingency(:,1)=1:size(intervals,1); %all possible intervals
    for j2=1:N %for each simulee   
        examinee_index=j2;
        %first year group
        %check which interval this simulee falls in
        current_interval=interval_1(j2);
        %check whether this person has answered item j1 correctly
        if sparse_matrix_stra_1(j2,j1)==1
            contingency(current_interval,2)=contingency(current_interval,2)+1;
        elseif sparse_matrix_stra_1(j2,j1)==0
            contingency(current_interval,3)=contingency(current_interval,3)+1;
        end
       
        
        %second year group 
        %check which interval this simulee falss in
        current_interval=interval_2(j2);
        %check whether this person has answered item j1 correctly
        if sparse_matrix_stra_2(j2,j1)==1
            contingency(current_interval,4)=contingency(current_interval,4)+1;
        elseif sparse_matrix_stra_2(j2,j1)==0
            contingency(current_interval,5)=contingency(current_interval,5)+1;
        end
    end
    
    %compute pooled oldds-ratio
    suminterval=sum(contingency(:,2:5),2);
    ad=contingency(:,4).*contingency(:,3);
    pool_sumad=sum(ad(suminterval~=0)./suminterval(suminterval~=0));
    bc=contingency(:,2).*contingency(:,5);
    pool_sumbc=sum(bc(suminterval~=0)./suminterval(suminterval~=0));
    pooled_oddsratio=pool_sumad/pool_sumbc;
    
    u=ad+pooled_oddsratio.*bc;
    v=(contingency(:,4)+contingency(:,3))+pooled_oddsratio.*(contingency(:,2).*contingency(:,5));
    pool_sumuv=sum(u(suminterval~=0).*v(suminterval~=0)./suminterval(suminterval~=0)./suminterval(suminterval~=0));
    pool_sumad_se=2*(sum(ad(suminterval~=0)./suminterval(suminterval~=0)))^2;
    
    mhddif=-2.35*log(pooled_oddsratio);
    se=2.35*sqrt(pool_sumuv/pool_sumad_se);
    statistic(j1)=mhddif/se;
end
%%
Iman1=[];
for jj=1:n
    if statistic(jj)>norminv(0.90,1)
        Iman1=[Iman1 jj];
    end
end

Iman2=[];
for jj=1:n
    if abs(chis(jj)-1)>.2
        Iman2=[Iman2 jj];
    end
end
Iman1=setdiff(1:n,Iman1);
Iman2=setdiff(1:n,Iman2);