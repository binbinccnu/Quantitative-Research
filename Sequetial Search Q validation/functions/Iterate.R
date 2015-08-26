##
#iterate#
#
Iterate <- function(est,eta,lprior,post_prior,response,Q) {
  J <- nrow(Q)
  K <- ncol(Q)  
  it <- 0;
  diff <- 1;
  maxit <- 999
  crit <- .001
  
  est <- -1*matrix(1,nrow(Q),2^max(rowSums(Q)))
  for (j in 1:J) {
    Kj <- rowSums(Q[j,])
    est[j,1:2^Kj] <- .2
    est[j,2^Kj] <- .8
  } 
 
  post <- Findpost(est,eta,lprior,post_prior,response,Q)
  
  while (it < maxit && diff > crit) {

    est0 <- est
    for (j in 1:J) {
      Kj <- sum(Q[j,])
      Lj <- which(Q[j,]==1)
      Qj <- c()
      for (kj in 1:Kj) {
        tmpQ <- c()
        base <- rbind(matrix(0,2^(Kj-kj),1),matrix(1,2^(Kj-kj),1))
        for (lj in 1:2^(kj-1)) {
          tmpQ <- rbind(tmpQ,base)
        }
        Qj <- cbind(Qj,tmpQ)
      }
      Qj <- cbind(Qj,rowSums(Qj))
      tmpq <- matrix(0,2^Kj,1)
      for (k in 1:Kj) {
        tmpq <- tmpq - 10^(Kj-k)*Qj[,k]
      }
      Qj <- cbind(Qj,tmpq)
      Qj <- Qj[order(Qj[,Kj+1],Qj[,Kj+2]),]
      Qj <- Qj[,1:Kj]
      Qj <- as.matrix(Qj)
      tmp_alpha <- alpha[,Lj]
      for (kj in 1:2^Kj) {
        tmp <- (matrix(1,2^K,1)%*%Qj[kj,] == tmp_alpha)*1
        tmp_loc <- which(apply(tmp,1,prod)==1)
        if (length(tmp_loc) == 1) {
          tmp <- post[,tmp_loc] 
        } else {
          tmp <- rowSums(post[,tmp_loc])
        }
        n1 <- sum(tmp)
        r1 <- sum(response[,j]*tmp)        
        if (log(n1) < -2.14748e+09) {
          n1 <- .0001
        }
        tmp_est <- r1/n1
        if (tmp_est < 10^(-4)) {
          tmp_est <- 10^(-4)
        }
        if (tmp_est > 1-10^(-4)) {
          tmp_est <- 1-10^(-4)
        }
        est[j,kj] <- tmp_est
      }
    }
    diff <- max(sqrt((est0-est)^2))
    it <- it + 1
    if (it < maxit && diff > crit) {      
      post0 <- Findpost(est,eta,lprior,post,response,Q) ###
      post <- post0
      lprior <- as.matrix(log(apply(post,2,mean)))
      lprior[lprior==-Inf] <- -2.14748e+09
      lprior[lprior==NaN] <- -2.14748e+09
    }
  }
  cat('Total Iteration = ',it,'\n')
  return(post=post)
}
