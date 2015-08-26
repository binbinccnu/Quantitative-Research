function [theta_mle]=mle_theta(a,b,c,D,u)
%compute the mle estimation for a single examinee
%input u is a vector containing responses of an examinee for several items 
%input a b c is a vector containig parameters 


epsilo=1;
jtheta=-3:epsilo:3;

f_max=-9999999;
for j1=1:length(jtheta)
    f=0;            
    for j=1:length(u)             
        pp=P_Computation(jtheta(j1),a(j),b(j),c(j),D);             
        f=f+u(j)*log(pp)+(1-u(j))*log(1-pp);          
    end
    if f>f_max        
        f_max=f;                  
        theta_mle=jtheta(j1);
    end
end   

epsilo=.5;
jtheta=max(-3,theta_mle-1):epsilo:min(3,theta_mle+1);

f_max=-length(u);
for j1=1:length(jtheta)
    f=0;            
    for j=1:length(u)             
        pp=P_Computation(jtheta(j1),a(j),b(j),c(j),D);             
        f=f+u(j)*log(pp)+(1-u(j))*log(1-pp);          
    end
    if f>f_max        
        f_max=f;                  
        theta_mle=jtheta(j1);
    end
end   

epsilo=.1;
jtheta=max(-3,theta_mle-.5):epsilo:min(3,theta_mle+.5);

f_max=-length(u);
for j1=1:length(jtheta)
    f=0;            
    for j=1:length(u)             
        pp=P_Computation(jtheta(j1),a(j),b(j),c(j),D);             
        f=f+u(j)*log(pp)+(1-u(j))*log(1-pp);          
    end
    if f>f_max        
        f_max=f;                  
        theta_mle=jtheta(j1);
    end
end   

epsilo=.05;
jtheta=max(-3,theta_mle-.1):epsilo:min(3,theta_mle+.1);

f_max=-length(u);
for j1=1:length(jtheta)
    f=0;            
    for j=1:length(u)             
        pp=P_Computation(jtheta(j1),a(j),b(j),c(j),D);             
        f=f+u(j)*log(pp)+(1-u(j))*log(1-pp);          
    end
    if f>f_max        
        f_max=f;                  
        theta_mle=jtheta(j1);
    end
end   

epsilo=.01;
jtheta=max(-3,theta_mle-.05):epsilo:min(3,theta_mle+.05);

f_max=-length(u);
for j1=1:length(jtheta)
    f=0;            
    for j=1:length(u)             
        pp=P_Computation(jtheta(j1),a(j),b(j),c(j),D);             
        f=f+u(j)*log(pp)+(1-u(j))*log(1-pp);          
    end
    if f>f_max        
        f_max=f;                  
        theta_mle=jtheta(j1);
    end
end  


epsilo=.005;
jtheta=max(-3,theta_mle-.01):epsilo:min(3,theta_mle+.01);

f_max=-length(u);
for j1=1:length(jtheta)
    f=0;            
    for j=1:length(u)             
        pp=P_Computation(jtheta(j1),a(j),b(j),c(j),D);             
        f=f+u(j)*log(pp)+(1-u(j))*log(1-pp);          
    end
    if f>f_max        
        f_max=f;                  
        theta_mle=jtheta(j1);
    end
end  