
function U=Examinee_Response_Simulation(Theta,A,B,C,D)

% The function is used to simulate the examinee response
% Vector Theta stores the ability true values of all examinees
% Vector A is used to store the discrimination parameters of all items
% Vector B is used to store the difficulty parameters of all items
% Vector C is used to store the guessing parameters of all items
% D is the scale constant
% Matrix U stores the responses of all examinees on all items

N=length(Theta);          % Obtain the number of examinee
m=length(A);              % Obtain the number of item

U=zeros(N,m);             % Preallocating the structure

for j4=1:N
    for j5=1:m
        P=P_Computation(Theta(j4),A(j5),B(j5),C(j5),D);   
        r=unifrnd(0,1);           % Generate a random number from U(0,1)
        if (r<=P)
            U(j4,j5)=1;
        else
            U(j4,j5)=0;
        end
    end
end