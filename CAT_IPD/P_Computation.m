function P_Value=P_Computation(theta,a,b,c,D)

temp=-D*a*(theta-b);
if     (temp>250)
        P_Value=c;
elseif (temp<-100)
        P_Value=0.9999;
else    P_Value=c+(1-c)/(1+exp(-D*a*(theta-b)));
end