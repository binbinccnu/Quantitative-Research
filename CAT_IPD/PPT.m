%run paper and pencial test to see the sample size requirement
sample_size=[100 200 250 300 350 400];
typeIrate_ppt=zeros(length(sample_size),1);
power_ppt=typeIrate_ppt;

for sample_index=1:length(sample_size);
    for ppt_repli=1:100
        %simulate 200 examinees from a normal distribution
        theta_ppt_1=normrnd(0,1,sample_size(sample_index),1);
        theta_ppt_2=normrnd(0,1,sample_size(sample_index),1);
        %generate the response matrix
        U_ppt_1=Examinee_Response_Simulation(theta_ppt_1,a_1,b_1,c_1,D);
        U_ppt_2=Examinee_Response_Simulation(theta_ppt_2,a_2,b_2,c_2,D);
        %apply the sibtest 
        number_points=5;
        for point_index=number_points  
            %%this is the modified sibtest  
            intervals=linspace(-3,2.5,point_index)';  
            intervals=[intervals,[intervals(2:size(intervals,1));3]];  %divide the whole theta span into intervals    
            intervals(1,1)=-10; 
            intervals(size(intervals,1),2)=10;
            weights_1=zeros(n,size(intervals,1));   %how many examinees are there for a interval for an item  
            totalscore_1=zeros(n,size(intervals,1)); %mean total score for a interval for an ite
            weights_2=zeros(n,size(intervals,1));   %how many examinees are there for a interval for an item 
            totalscore_2=zeros(n,size(intervals,1)); %mean total score for a interval for an item 
            interval_1=zeros(N,1);
            interval_2=zeros(N,1);  
            %for each item, get the examinees who have selected it  
            for jj=1:length(theta_ppt_1)  
                for jjj=1:size(intervals,1)
                    %which interval does this examinee falls into     
                    if (theta_ppt_1(jj)>=intervals(jjj,1) && theta_ppt_1(jj)<intervals(jjj,2))          
                        interval_1(jj)=jjj;          
                    end                    
                    if (theta_ppt_2(jj)>=intervals(jjj,1) && theta_ppt_2(jj)<intervals(jjj,2))
                        interval_2(jj)=jjj;              
                    end                    
                end                
                for j=1:n        
                    %for all items this examinees took                  
                    current_item_1=j;            
                    totalscore_1(current_item_1,interval_1(jj))=totalscore_1(current_item_1,interval_1(jj))+U_ppt_1(jj,current_item_1);
                    weights_1(current_item_1,interval_1(jj))=weights_1(current_item_1,interval_1(jj))+1;                  
                    current_item_2=j;                
                    totalscore_2(current_item_2,interval_2(jj))=totalscore_2(current_item_2,interval_2(jj))+U_ppt_2(jj,current_item_2);   
                    weights_2(current_item_2,interval_2(jj))=weights_2(current_item_2,interval_2(jj))+1;      
                end                
            end            
            weights=weights_1+weights_2;   
            p_=weights./(sum(weights,2)*ones(1,size(intervals,1)));   
            %the mean score for a interval for an item, may have NA values    
            meanscore_1=totalscore_1./weights_1;    
            meanscore_2=totalscore_2./weights_2;   
            %revise the NaN;   
            [cord1_1,cord2_1]=find(weights_1==0);   
            [cord1_2,cord2_2]=find(weights_2==0);   
            for j=1:length(cord1_1)     
                meanscore_1(cord1_1(j),cord2_1(j))=0;    
            end            
            for j=1:length(cord1_2)   
                meanscore_2(cord1_2(j),cord2_2(j))=0;   
            end            
            %the variance for a interval for an item, may have NA values   
            variance_1=(totalscore_1+weights_1.*meanscore_1.*meanscore_1-2.*meanscore_1.*totalscore_1)./(weights_1-1);    
            variance_2=(totalscore_2+weights_2.*meanscore_2.*meanscore_2-2.*meanscore_2.*totalscore_2)./(weights_2-1);  
            %revise the NaN;    
            [cord1_1,cord2_1]=find((weights_1-1)<=0);    
            [cord1_2,cord2_2]=find((weights_2-1)<=0);    
            for j=1:length(cord1_1)    
                variance_1(cord1_1(j),cord2_1(j))=0;    
            end            
            for j=1:length(cord1_2)    
                variance_2(cord1_2(j),cord2_2(j))=0;    
            end
            meanscore_hat=zeros(n,1);   
            variance_hat=zeros(n,1);   
            for j=1:n      
                for jj=1:size(intervals,1)        
                    meanscore_hat(j)=meanscore_hat(j)+p_(j,jj)*(meanscore_1(j,jj)-meanscore_2(j,jj));            
                    if weights_1(j,jj)~=0 && weights_2(j,jj)~=0           
                        variance_hat(j)=variance_hat(j)+p_(j,jj)*p_(j,jj)*(variance_1(j,jj)/weights_1(j,jj)+variance_2(j,jj)/weights_2(j,jj));                 
                    elseif weights_1(j,jj)~=0 && weights_2(j,jj)==0                            
                        variance_hat(j)=variance_hat(j)+weights_1(j,jj)*variance_1(j,jj);                  
                    elseif weights_1(j,jj)==0 && weights_2(j,jj)~=0         
                        variance_hat(j)=variance_hat(j)+weights_2(j,jj)*variance_2(j,jj);                  
                    end                    
                end
            end            
            
            %compute test statistic, which follows a normal (0,1) distribution     
            b_hat_ppt=meanscore_hat./variance_hat.^(1/2);
            %gathering the results   
            flag_sib_ppt=abs(b_hat_ppt)>1.96;
            flag_sib_ppt=find(flag_sib_ppt==1);  
            typeIrate_ppt(sample_index)=typeIrate_ppt(sample_index)+length(flag_sib_ppt(flag_sib_ppt>round(n*p)))/(n-round(n*p));
            power_ppt(sample_index)=power_ppt(sample_index)+length(flag_sib_ppt(flag_sib_ppt<=round(n*p)))/round(n*p);
        end
    end
    typeIrate_ppt(sample_index)=typeIrate_ppt(sample_index)/ppt_repli;
    power_ppt(sample_index)=power_ppt(sample_index)/ppt_repli;
end
typeIrate_ppt
power_ppt