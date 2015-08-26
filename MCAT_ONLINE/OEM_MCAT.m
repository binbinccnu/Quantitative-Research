function [a1_est,a2_est,b_est]=OEM_MCAT2D(sparse,index_cali,examinee_record,test_operational,cali_item,a,b,person_select)
%%% this function proceeds online calibration method using M-OEM for MCAT
%%% person_select indicates person id who answers this item to be estimated
%%% a and b are vectors, i.e., parameter estimates for an item, but a(:,(test_operational+1):(test_operational+test_cali)) should be unkown

%%
n = length(b);
% quadrature points
step_size = .2;
quadrature1 = -2 : step_size : 2;
quadrature2 = -2 : step_size : 2;

% prior probability
mu = [0 0];
sigma = [.5,.25 ; .25,.5];
[X1,X2] = meshgrid(quadrature1,quadrature2);
X = [X1(:) X2(:)];
f = mvnpdf(X,mu,sigma);

tempo=-50000000000000000000000000;

%% begin grid search
epsilo = .1;
a1 =  0 : epsilo : 2;
a2 =  0 : epsilo : 2;
b0 = -2 : epsilo : 2;

[q1,q2,q3] = meshgrid(a1,a2,b0);
q = [q1(:) q2(:) q3(:)];
lnL = zeros(1,size(q,1));
P = MIRT_prob2D_matrix(X(:,1),X(:,2),q(:,1),q(:,2),q(:,3));
Q = 1 - P;

%
response1 = sparse(person_select,:);
response1(response1==9) = 0;
response2 = sparse(person_select,:);
response2(response2==9) = 1;
P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(setdiff(1:n,index_cali),1),a(setdiff(1:n,index_cali),2),b(setdiff(1:n,index_cali)));
Q_q = 1 - P_q;
L_f = log(P_q)*response1(:,setdiff(1:n,index_cali))' + log(Q_q)*(1-response2(:,setdiff(1:n,index_cali))') + repmat(log(f),1,length(person_select));
L_f = exp(L_f);
denominator = sum(L_f) * step_size * step_size;
posterior = L_f ./ repmat(denominator,size(X,1),1);

u = sparse(person_select,cali_item); 
person_correct = find(u==1);
person_wrong = find(u==0);
number_correct = length(person_correct);
number_wrong = length(person_wrong);

temp_correct = posterior(:,person_correct)' * P * step_size * step_size;  % person_select by X*q
temp_wrong = posterior(:,person_wrong)' * Q * step_size * step_size;
L = prod(temp_correct,1) .* prod(temp_wrong,1);
lnL = log(L);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = q(index,1);             
    a2_est = q(index,2);               
    b_est  = q(index,3);   
    tempo = max_value;    
end

%% 
epsilo = epsilo/2;
a1 = max( 0,a1_est-epsilo*3) : epsilo : min(2,a1_est-epsilo*3);
a2 = max( 0,a2_est-epsilo*3) : epsilo : min(2,a2_est-epsilo*3);
b0 = max(-2,b_est -epsilo*3) : epsilo : min(2,b_est -epsilo*3);

[q1,q2,q3] = meshgrid(a1,a2,b0);
q = [q1(:) q2(:) q3(:)];
lnL = zeros(1,size(q,1));
P = MIRT_prob2D_matrix(X(:,1),X(:,2),q(:,1),q(:,2),q(:,3));
Q = 1 - P;

%
response1 = sparse(person_select,:);
response1(response1==9) = 0;
response2 = sparse(person_select,:);
response2(response2==9) = 1;
P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(setdiff(1:n,index_cali),1),a(setdiff(1:n,index_cali),2),b(setdiff(1:n,index_cali)));
Q_q = 1 - P_q;
L_f = log(P_q)*response1(:,setdiff(1:n,index_cali))' + log(Q_q)*(1-response2(:,setdiff(1:n,index_cali))') + repmat(log(f),1,length(person_select));
L_f = exp(L_f);
denominator = sum(L_f) * step_size * step_size;
posterior = L_f ./ repmat(denominator,size(X,1),1);

u = sparse(person_select,cali_item); 
person_correct = find(u==1);
person_wrong = find(u==0);
number_correct = length(person_correct);
number_wrong = length(person_wrong);

temp_correct = posterior(:,person_correct)' * P * step_size * step_size;  % person_select by X*q
temp_wrong = posterior(:,person_wrong)' * Q * step_size * step_size;
L = prod(temp_correct,1) .* prod(temp_wrong,1);
lnL = log(L);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = q(index,1);             
    a2_est = q(index,2);               
    b_est  = q(index,3);   
    tempo = max_value;    
end

%% 
epsilo = epsilo/2;
a1 = max( 0,a1_est-epsilo*3) : epsilo : min(2,a1_est-epsilo*3);
a2 = max( 0,a2_est-epsilo*3) : epsilo : min(2,a2_est-epsilo*3);
b0 = max(-2,b_est -epsilo*3) : epsilo : min(2,b_est -epsilo*3);

[q1,q2,q3] = meshgrid(a1,a2,b0);
q = [q1(:) q2(:) q3(:)];
lnL = zeros(1,size(q,1));
P = MIRT_prob2D_matrix(X(:,1),X(:,2),q(:,1),q(:,2),q(:,3));
Q = 1 - P;

%
response1 = sparse(person_select,:);
response1(response1==9) = 0;
response2 = sparse(person_select,:);
response2(response2==9) = 1;
P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(setdiff(1:n,index_cali),1),a(setdiff(1:n,index_cali),2),b(setdiff(1:n,index_cali)));
Q_q = 1 - P_q;
L_f = log(P_q)*response1(:,setdiff(1:n,index_cali))' + log(Q_q)*(1-response2(:,setdiff(1:n,index_cali))') + repmat(log(f),1,length(person_select));
L_f = exp(L_f);
denominator = sum(L_f) * step_size * step_size;
posterior = L_f ./ repmat(denominator,size(X,1),1);

u = sparse(person_select,cali_item); 
person_correct = find(u==1);
person_wrong = find(u==0);
number_correct = length(person_correct);
number_wrong = length(person_wrong);

temp_correct = posterior(:,person_correct)' * P * step_size * step_size;  % person_select by X*q
temp_wrong = posterior(:,person_wrong)' * Q * step_size * step_size;
L = prod(temp_correct,1) .* prod(temp_wrong,1);
lnL = log(L);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = q(index,1);             
    a2_est = q(index,2);               
    b_est  = q(index,3);   
    tempo = max_value;    
end

%% 
epsilo = epsilo/2;
a1 = max( 0,a1_est-epsilo*3) : epsilo : min(2,a1_est-epsilo*3);
a2 = max( 0,a2_est-epsilo*3) : epsilo : min(2,a2_est-epsilo*3);
b0 = max(-2,b_est -epsilo*3) : epsilo : min(2,b_est -epsilo*3);

[q1,q2,q3] = meshgrid(a1,a2,b0);
q = [q1(:) q2(:) q3(:)];
lnL = zeros(1,size(q,1));
P = MIRT_prob2D_matrix(X(:,1),X(:,2),q(:,1),q(:,2),q(:,3));
Q = 1 - P;

%
response1 = sparse(person_select,:);
response1(response1==9) = 0;
response2 = sparse(person_select,:);
response2(response2==9) = 1;
P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(setdiff(1:n,index_cali),1),a(setdiff(1:n,index_cali),2),b(setdiff(1:n,index_cali)));
Q_q = 1 - P_q;
L_f = log(P_q)*response1(:,setdiff(1:n,index_cali))' + log(Q_q)*(1-response2(:,setdiff(1:n,index_cali))') + repmat(log(f),1,length(person_select));
L_f = exp(L_f);
denominator = sum(L_f) * step_size * step_size;
posterior = L_f ./ repmat(denominator,size(X,1),1);

u = sparse(person_select,cali_item); 
person_correct = find(u==1);
person_wrong = find(u==0);
number_correct = length(person_correct);
number_wrong = length(person_wrong);

temp_correct = posterior(:,person_correct)' * P * step_size * step_size;  % person_select by X*q
temp_wrong = posterior(:,person_wrong)' * Q * step_size * step_size;
L = prod(temp_correct,1) .* prod(temp_wrong,1);
lnL = log(L);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = q(index,1);             
    a2_est = q(index,2);               
    b_est  = q(index,3);   
    tempo = max_value;    
end

%% 
epsilo = epsilo/2;
a1 = max( 0,a1_est-epsilo*3) : epsilo : min(2,a1_est-epsilo*3);
a2 = max( 0,a2_est-epsilo*3) : epsilo : min(2,a2_est-epsilo*3);
b0 = max(-2,b_est -epsilo*3) : epsilo : min(2,b_est -epsilo*3);

[q1,q2,q3] = meshgrid(a1,a2,b0);
q = [q1(:) q2(:) q3(:)];
lnL = zeros(1,size(q,1));
P = MIRT_prob2D_matrix(X(:,1),X(:,2),q(:,1),q(:,2),q(:,3));
Q = 1 - P;

%
response1 = sparse(person_select,:);
response1(response1==9) = 0;
response2 = sparse(person_select,:);
response2(response2==9) = 1;
P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(setdiff(1:n,index_cali),1),a(setdiff(1:n,index_cali),2),b(setdiff(1:n,index_cali)));
Q_q = 1 - P_q;
L_f = log(P_q)*response1(:,setdiff(1:n,index_cali))' + log(Q_q)*(1-response2(:,setdiff(1:n,index_cali))') + repmat(log(f),1,length(person_select));
L_f = exp(L_f);
denominator = sum(L_f) * step_size * step_size;
posterior = L_f ./ repmat(denominator,size(X,1),1);

u = sparse(person_select,cali_item); 
person_correct = find(u==1);
person_wrong = find(u==0);
number_correct = length(person_correct);
number_wrong = length(person_wrong);

temp_correct = posterior(:,person_correct)' * P * step_size * step_size;  % person_select by X*q
temp_wrong = posterior(:,person_wrong)' * Q * step_size * step_size;
L = prod(temp_correct,1) .* prod(temp_wrong,1);
lnL = log(L);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = q(index,1);             
    a2_est = q(index,2);               
    b_est  = q(index,3);   
    tempo = max_value;    
end

%% 
epsilo = epsilo/2;
a1 = max( 0,a1_est-epsilo*3) : epsilo : min(2,a1_est-epsilo*3);
a2 = max( 0,a2_est-epsilo*3) : epsilo : min(2,a2_est-epsilo*3);
b0 = max(-2,b_est -epsilo*3) : epsilo : min(2,b_est -epsilo*3);

[q1,q2,q3] = meshgrid(a1,a2,b0);
q = [q1(:) q2(:) q3(:)];
lnL = zeros(1,size(q,1));
P = MIRT_prob2D_matrix(X(:,1),X(:,2),q(:,1),q(:,2),q(:,3));
Q = 1 - P;

%
response1 = sparse(person_select,:);
response1(response1==9) = 0;
response2 = sparse(person_select,:);
response2(response2==9) = 1;
P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(setdiff(1:n,index_cali),1),a(setdiff(1:n,index_cali),2),b(setdiff(1:n,index_cali)));
Q_q = 1 - P_q;
L_f = log(P_q)*response1(:,setdiff(1:n,index_cali))' + log(Q_q)*(1-response2(:,setdiff(1:n,index_cali))') + repmat(log(f),1,length(person_select));
L_f = exp(L_f);
denominator = sum(L_f) * step_size * step_size;
posterior = L_f ./ repmat(denominator,size(X,1),1);

u = sparse(person_select,cali_item); 
person_correct = find(u==1);
person_wrong = find(u==0);
number_correct = length(person_correct);
number_wrong = length(person_wrong);

temp_correct = posterior(:,person_correct)' * P * step_size * step_size;  % person_select by X*q
temp_wrong = posterior(:,person_wrong)' * Q * step_size * step_size;
L = prod(temp_correct,1) .* prod(temp_wrong,1);
lnL = log(L);
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = q(index,1);             
    a2_est = q(index,2);               
    b_est  = q(index,3);   
    tempo = max_value;    
end
