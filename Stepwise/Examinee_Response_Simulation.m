function U=Examinee_Response_Simulation(Theta,a,b,c,D)
% The function is used to simulate the examinee response
% Vector Theta stores the ability true values of all examinees
% Vector A is used to store the discrimination parameters of all items
% Vector B is used to store the difficulty parameters of all items
% Vector C is used to store the guessing parameters of all items
% D is the scale constant
% Matrix U stores the responses of all examinees on all items

N=length(Theta);                %Obtain the number of examinee
m=length(a);                    %Obtain the number of item

P=P_Computation(Theta,a,b,c,D); %compute probabilities for each ability point, each item
r=unifrnd(0,1,N,m);             %generate a matrix in which every entry is uniformly distributed
U=(r<=P);                       %use monte carlo to decide which entry should 1, and which entry should be0
                                %note: this uses reject sampling methods
