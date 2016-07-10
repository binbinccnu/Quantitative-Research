% typeI_sib(y,1)=typeIrate_sh_sib;
% power_sib(y,1)=power_sh_sib;

typeI_sib(y,2)=typeIrate_stra_sib;
power_sib(y,2)=power_stra_sib;

% get the final results for this replication
%plot the results
if figure_switch==1
    figure (3)
    plot(1:repli,typeI_sib(:,1),'color','red');
    hold on
    plot(1:repli,0.1*ones(repli,1),'color','black') ;
    plot(1:repli,typeI_sib(:,2),'color','blue');
    title 'Type I error rate for SH CAT and Stratified CAT' 
    hold off

    figure (4)
    plot(1:repli,power_sib(:,1),'color','red');
    hold on
    plot(1:repli,power_sib(:,2),'color','blue');
    title 'Power rate for SH CAT and Stratified CAT' 
    hold off
end