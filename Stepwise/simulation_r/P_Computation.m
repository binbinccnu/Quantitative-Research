function P_Value=P_Computation(theta,a,b,c,D)
%P_value is a N by n vector

thetatheta=theta*ones(1,length(a));
bb=ones(length(theta),1)*b';
aa=ones(length(theta),1)*a';
cc=ones(length(theta),1)*c';
temp=-D*(thetatheta-bb).*(aa);

P_Value=cc+(1-cc)./(1+exp(temp));
