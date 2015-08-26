%this function stratifies the item pool according to a parameters and
%matined b distribution
function [strata_1,strata_2,strata_3]=stratification(a,b,c)

%first divide into four blocks according to b-parameter
n=length(a);
item_par=[[1:n]' a' b' c'];
strata_1=[];
strata_2=[];
strata_3=[];
strata_4=[];
number_stra_a=3;
number_stra_b=4;
number_b=round(n/number_stra_b);
[sort_b,index]=sort(item_par(:,3));
sort_b=item_par(index,:);                               %item parameters according to b ascending
for j=1:number_stra_b
    if j~=number_stra_b
        current_b_index=index(number_b*(j-1)+1:number_b*j); %first 1/4 item index
    else
        current_b_index=index(number_b*(j-1)+1:length(index));
    end
    current_b=sort_b(current_b_index,:);                %first 1/4 item parameters
    [sort_a,indexa]=sort(current_b(:,2));               
    sort_a=current_b(indexa,:);                         %item parameters according to a ascending within each b block
    number_a=round(number_b/number_stra_a);
    for jj=1:number_stra_a
        if jj~=number_stra_a
            current_a_index=indexa(number_a*(jj-1)+1:number_a*jj); %first 1/4 item index
        else
            current_a_index=indexa(number_a*(jj-1)+1:length(indexa));
        end
        current_a=sort_a(current_a_index,:);                   %first 1/4 item parameters
        if jj==1
            strata_1=[strata_1; current_a(:,1)];
        elseif jj==2
            strata_2=[strata_2; current_a(:,1)];
        elseif jj==3
            strata_3=[strata_3; current_a(:,1)];
        end
    end
end

    
    