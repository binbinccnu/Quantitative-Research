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

%%
% typeI_chi(y,1)=typeIrate_sh_chi;
% power_chi(y,1)=power_sh_chi;
% 
% typeI_chi(y,2)=typeIrate_stra_chi;
% power_chi(y,2)=power_stra_chi;
% 
% %get the final results for this replication
% %plot the results
% if figure_switch==1
%     figure (5)
%     plot(1:repli,typeI_chi(:,1),'color','red');
%     hold on
%     plot(1:repli,0.1*ones(repli,1),'color','black') ;
%     plot(1:repli,typeI_chi(:,2),'color','blue');
%     title 'Type I error rate for SH CAT and Stratified CAT' 
%     hold off
% 
%     figure (6)
%     plot(1:repli,power_chi(:,1),'color','red');
%     hold on
%     plot(1:repli,power_chi(:,2),'color','blue');
%     title 'Power rate for SH CAT and Stratified CAT' 
%     hold off
% end

% %%
% %check distribution of examinees for each item 
% item_number=294;
% 
% theta_interval_sh=[];
% %get examinees who responded this item
% for j=1:N
%     if sparse_matrix_sh_1(j,item_number)~=9
%         theta_interval_sh=[theta_interval_sh theta_estimate_cat_1(j)];
%     end
% end
% theta_interval_stra=[];
% %get examinees who responded this item
% for j=1:N
%     if sparse_matrix_stra_1(j,item_number)~=9
%         theta_interval_stra=[theta_interval_stra theta_stra_1(j)];
%     end
% end
% figure(1)
% hist(theta_interval_sh)
% title 'normal CAT';
% hold on 
% plot(b_1(item_number),0,'x','color','red')
% hold off
% 
% figure(2)
% hist(theta_interval_stra)
% title 'Stratified CAT';
% hold on 
% plot(b_1(item_number),0,'x','color','red')
% hold off