%use theta estimate to match
%divide theta estimate into invervals
number_points=10;
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
    
    %compute sibtest values
    suminterval=sum(contingency(:,2:5),2);
    pk=suminterval./sum(suminterval); %may have 0 values
    %compute mean score for numerator
    total_number_rk=contingency(:,4)+contingency(:,5);
    total_score_rk=contingency(:,4);
    mean_rk=total_score_rk./total_number_rk;
    mean_rk(isnan(mean_rk))=0;
    total_number_fk=contingency(:,2)+contingency(:,3);
    total_score_fk=contingency(:,2);
    mean_fk=total_score_fk./total_number_fk;
    mean_fk(isnan(mean_fk))=0;
    %compute numerator
    beta_hat=sum(pk.*(mean_rk-mean_fk));
    
    %standard errors
    var_rk=zeros(size(intervals,1),1);
    var_fk=zeros(size(intervals,1),1);
    for group=1:size(intervals,1)
        vector_rk=[ones(contingency(group,4),1)' zeros(contingency(group,5),1)']; %display all the scores for rk
        vector_fk=[ones(contingency(group,2),1)' zeros(contingency(group,3),1)']; %display all the scores for fk
        %compute sample variances
        var_rk(group)=var(vector_rk);
        var_fk(group)=var(vector_fk);
    end
    ratioed_var_rk=var_rk./total_number_rk;
    ratioed_var_rk(isnan(ratioed_var_rk))=0;
    ratioed_var_fk=var_fk./total_number_fk;
    ratioed_var_fk(isnan(ratioed_var_fk))=0;
    %compute denominator
    beta_se=(sum(pk.*pk.*(ratioed_var_rk+ratioed_var_fk)))^(1/2);
    
    statistic(j1)=beta_hat/beta_se;
end

%%
flag_sib_stra=[];
for jj=1:n
    if statistic(jj)>1.64
        flag_sib_stra=[flag_sib_stra jj];
    end
end