function [theta_mle]=MLE_MIRT2D(a1,a2,b,item_select,response)
% a1 a2 b are column vectors
% response is a row vector
% item_selecton is row vector indicating selected items

%%%%%%%%%%% Instead of using N-R algorithm as introduced above, we use a
%%%%%%%%%%% grid search instead%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempo = -5000000000000000000000000000000;

epsilo=.2;
theta1=-2:epsilo:2;
theta2=-2:epsilo:2;
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2);               
    tempo=max_value;           
end

epsilo=.1;
theta1 = max(-2,theta_mle(1)-epsilo*2):epsilo:min(2,theta_mle(1)+epsilo*2);
theta2 = max(-2,theta_mle(2)-epsilo*2):epsilo:min(2,theta_mle(2)+epsilo*2);
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2);               
    tempo=max_value;           
end

epsilo=.05;
theta1 = max(-2,theta_mle(1)-epsilo*2):epsilo:min(2,theta_mle(1)+epsilo*2);
theta2 = max(-2,theta_mle(2)-epsilo*2):epsilo:min(2,theta_mle(2)+epsilo*2);
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2);               
    tempo=max_value;           
end

epsilo=.025;
theta1 = max(-2,theta_mle(1)-epsilo*2):epsilo:min(2,theta_mle(1)+epsilo*2);
theta2 = max(-2,theta_mle(2)-epsilo*2):epsilo:min(2,theta_mle(2)+epsilo*2);
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2);               
    tempo=max_value;           
end

epsilo=.0125;
theta1 = max(-2,theta_mle(1)-epsilo*2):epsilo:min(2,theta_mle(1)+epsilo*2);
theta2 = max(-2,theta_mle(2)-epsilo*2):epsilo:min(2,theta_mle(2)+epsilo*2);
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2);               
    tempo=max_value;           
end

epsilo=.00625;
theta1 = max(-2,theta_mle(1)-epsilo*2):epsilo:min(2,theta_mle(1)+epsilo*2);
theta2 = max(-2,theta_mle(2)-epsilo*2):epsilo:min(2,theta_mle(2)+epsilo*2);
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2);               
    tempo=max_value;           
end

epsilo=.003125;
theta1 = max(-2,theta_mle(1)-epsilo*2):epsilo:min(2,theta_mle(1)+epsilo*2);
theta2 = max(-2,theta_mle(2)-epsilo*2):epsilo:min(2,theta_mle(2)+epsilo*2);
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2); 
    tempo=max_value;  
end

epsilo=.0015625;
theta1 = max(-2,theta_mle(1)-epsilo*2):epsilo:min(2,theta_mle(1)+epsilo*2);
theta2 = max(-2,theta_mle(2)-epsilo*2):epsilo:min(2,theta_mle(2)+epsilo*2);
[quadrature1,quadrature2] = meshgrid(theta1,theta2);
quadrature = [quadrature1(:) quadrature2(:)];
p = MIRT_prob2D_matrix(quadrature(:,1),quadrature(:,2),a1(item_select),a2(item_select),b(item_select));
lnL = log(p) * response' + log(1-p) * (1-response');
[max_value,index] = max(lnL);
if(max_value>tempo) 
    theta_mle(1)=quadrature(index,1);             
    theta_mle(2)=quadrature(index,2); 
end