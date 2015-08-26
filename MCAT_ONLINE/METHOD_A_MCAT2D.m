function [a1_est,a2_est,b_est]=METHOD_A_MCAT2D(theta1,theta2,response_select)
% this function proceeds online calibration method using M-METHOD A for MIRT
% theta1 and theta2 are column vectors for "all examinees" theta estimates
% person_select indicates person id who answers this item to be estimated
% response is column vector for "all examinees", i.e. responses to the item to be estimated
% a1 a2 and b are scalars, i.e., parameter estimates for an item


tempo=-500000000000000000000000000000000000;

epsilo = .2;
a1 =  0 : epsilo : 2;
a2 =  0 : epsilo : 2;
b  = -2 : epsilo : 2;
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end


epsilo = .1;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end


epsilo = .05;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end


epsilo = .025;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end


epsilo = .0125;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end


epsilo = .00625;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end



epsilo = .003125;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end



epsilo = .0016625;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3);   
    tempo=max_value;    
end

epsilo = .00083125;
a1 = max( 0,a1_est-epsilo*2) : epsilo : min(2,a1_est-epsilo*2);
a2 = max( 0,a2_est-epsilo*2) : epsilo : min(2,a2_est-epsilo*2);
b  = max(-2,b_est -epsilo*2) : epsilo : min(2,b_est -epsilo*2);
[quadrature1,quadrature2,quadrature3] = meshgrid(a1,a2,b);
quadrature = [quadrature1(:) quadrature2(:) quadrature3(:)];
p = MIRT_prob2D_matrix(theta1,theta2,quadrature(:,1),quadrature(:,2),quadrature(:,3));
q = 1 - p;
lnL = response_select' * log(p) + (1-response_select') * log(q);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = quadrature(index,1);             
    a2_est = quadrature(index,2);               
    b_est  = quadrature(index,3); 
end