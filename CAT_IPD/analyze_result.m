%get the best separation of quadrature points for normal CAT
index1=find(typeIrate_cat<=0.2);
index2=find(power_cat==max(power_cat(index1)));
best_number_interval_cat=index2(ismember(index2,index1));
typeIerrorrate_cat=min(typeIrate_cat(index2));
powerrate_cat=max(power_cat(index2));
typeI(y,1)=typeIerrorrate_cat;
power(y,1)=powerrate_cat;
best_number_points(y,1)=best_number_interval_cat(1);

%get the best separation of quadrature points for stratified CAT
index1=find(typeIrate_stra<=0.2);
index2=find(power_stra==max(power_stra(index1)));
best_number_interval_stra=index2(ismember(index2,index1));
typeIerrorrate_stra=min(typeIrate_stra(index2));
powerrate_stra=max(power_stra(index2));
typeI(y,2)=typeIerrorrate_stra;
power(y,2)=powerrate_stra;
best_number_points(y,2)=best_number_interval_stra(1);

% get the final results for this replication
%plot the results
if figure_switch==1
    figure (1)
    plot(1:number_points,typeIrate_cat,'color','red');
    hold on
    plot(1:number_points,0.1*ones(number_points,1),'color','black') ;
    plot(1:number_points,typeIrate_stra,'color','blue');
    title 'Type I error rate for normal CAT and stratified CAT' 
    hold off

    figure (2)
    plot(1:number_points,power_cat,'color','red');
    hold on
    plot(1:number_points,power_stra,'color','blue');
    title 'Power rate for normal CAT and stratified CAT' 
    hold off
end