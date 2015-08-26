function [a1_est,a2_est,b_est]=OEM_MCAT2D(sparse,examinee_record,test_operational,cali_item,a,b,person_select)
%%% this function proceeds online calibration method using M-OEM for MCAT
%%% person_select indicates person id who answers this item to be estimated
%%% a and b are vectors, i.e., parameter estimates for an item, but a(:,(test_operational+1):(test_operational+test_cali)) should be unkown

%% quadrature points
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
for p = 1:length(person_select) % each person who answered this item
    items = examinee_record(person_select(p),1:test_operational); % the operational items this person has been answered
    response = sparse(person_select(p),items);
    P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(items,1),a(items,2),b(items));
    Q_q = 1 - P_q; % (q1*q2) by length(item)
    L_f = log(P_q)*response' + log(Q_q)*(1-response') + log(f); %(q1*q2) by 1
    L_f = exp(L_f);
    denominator = sum(L_f)* step_size * step_size ;
    posterior = L_f / denominator; % posterior distribution for each quadrature point (q1*q2 by 1)
    
    u = sparse(person_select(p),cali_item); % a scalar
    lnL_tempo = log(P)*u + log(Q)*(1-u) + repmat(log(posterior),1,size(P,2));
    lnL_tempo = exp(lnL_tempo);
    lnL_tempo = 2 * log(step_size) + log(sum(lnL_tempo,1));
    lnL = lnL + lnL_tempo;
end
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
for p = 1:length(person_select) % each person who answered this item
    items = examinee_record(person_select(p),1:test_operational); % the operational items this person has been answered
    response = sparse(person_select(p),items);
    P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(items,1),a(items,2),b(items));
    Q_q = 1 - P_q; % (q1*q2) by length(item)
    L_f = log(P_q)*response' + log(Q_q)*(1-response') + log(f); %(q1*q2) by 1
    L_f = exp(L_f);
    denominator = sum(L_f)* step_size * step_size ;
    posterior = L_f / denominator; % posterior distribution for each quadrature point (q1*q2 by 1)
    
    u = sparse(person_select(p),cali_item); % a scalar
    lnL_tempo = log(P)*u + log(Q)*(1-u) + repmat(log(posterior),1,size(P,2));
    lnL_tempo = exp(lnL_tempo);
    lnL_tempo = 2 * log(step_size) + log(sum(lnL_tempo,1));
    lnL = lnL + lnL_tempo;
end
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
for p = 1:length(person_select) % each person who answered this item
    items = examinee_record(person_select(p),1:test_operational); % the operational items this person has been answered
    response = sparse(person_select(p),items);
    P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(items,1),a(items,2),b(items));
    Q_q = 1 - P_q; % (q1*q2) by length(item)
    L_f = log(P_q)*response' + log(Q_q)*(1-response') + log(f); %(q1*q2) by 1
    L_f = exp(L_f);
    denominator = sum(L_f)* step_size * step_size ;
    posterior = L_f / denominator; % posterior distribution for each quadrature point (q1*q2 by 1)
    
    u = sparse(person_select(p),cali_item); % a scalar
    lnL_tempo = log(P)*u + log(Q)*(1-u) + repmat(log(posterior),1,size(P,2));
    lnL_tempo = exp(lnL_tempo);
    lnL_tempo = 2 * log(step_size) + log(sum(lnL_tempo,1));
    lnL = lnL + lnL_tempo;
end
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
for p = 1:length(person_select) % each person who answered this item
    items = examinee_record(person_select(p),1:test_operational); % the operational items this person has been answered
    response = sparse(person_select(p),items);
    P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(items,1),a(items,2),b(items));
    Q_q = 1 - P_q; % (q1*q2) by length(item)
    L_f = log(P_q)*response' + log(Q_q)*(1-response') + log(f); %(q1*q2) by 1
    L_f = exp(L_f);
    denominator = sum(L_f)* step_size * step_size ;
    posterior = L_f / denominator; % posterior distribution for each quadrature point (q1*q2 by 1)
    
    u = sparse(person_select(p),cali_item); % a scalar
    lnL_tempo = log(P)*u + log(Q)*(1-u) + repmat(log(posterior),1,size(P,2));
    lnL_tempo = exp(lnL_tempo);
    lnL_tempo = 2 * log(step_size) + log(sum(lnL_tempo,1));
    lnL = lnL + lnL_tempo;
end
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
for p = 1:length(person_select) % each person who answered this item
    items = examinee_record(person_select(p),1:test_operational); % the operational items this person has been answered
    response = sparse(person_select(p),items);
    P_q = MIRT_prob2D_matrix(X(:,1),X(:,2),a(items,1),a(items,2),b(items));
    Q_q = 1 - P_q; % (q1*q2) by length(item)
    L_f = log(P_q)*response' + log(Q_q)*(1-response') + log(f); %(q1*q2) by 1
    L_f = exp(L_f);
    denominator = sum(L_f)* step_size * step_size ;
    posterior = L_f / denominator; % posterior distribution for each quadrature point (q1*q2 by 1)
    
    u = sparse(person_select(p),cali_item); % a scalar
    lnL_tempo = log(P)*u + log(Q)*(1-u) + repmat(log(posterior),1,size(P,2));
    lnL_tempo = exp(lnL_tempo);
    lnL_tempo = 2 * log(step_size) + log(sum(lnL_tempo,1));
    lnL = lnL + lnL_tempo;
end
[max_value,index] = max(lnL);
if(max_value > tempo) 
    a1_est = q(index,1);             
    a2_est = q(index,2);               
    b_est  = q(index,3);   
end
