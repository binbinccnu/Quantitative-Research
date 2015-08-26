search <- function(esp,jj,Nn,patt3,Q,qvec0,response,Rr,var0) {
  
  N <- nrow(response)
  K <- ncol(Q) 
  
  rr <- Rr[jj,]
  patt <- patt3
  pc <- sum(rr)/N
  
  var1 <- var0
  qvec1 <- qvec0
  v0 <- var0
  v1 <- 0
  qk <- 0
  
  for (k in 1:K) {
    if (prod((k==qvec0)*1)<1) {
      nt <- c()
      rt <- c()
      sel <- c(qvec0,k-1)
      tmp_a <- alpha[,sort(sel)+1]
      for (p in 1:nrow(patt)) {
        ind <- which(apply((matrix(1,2^K,1)%*%patt[p,]==tmp_a)*1,1,prod)!=0)
        #cat(ind,'\n')
        if (length(ind)>0) {
          nt <- rbind(nt,sum(Nn[ind]))
          rt <- rbind(rt,sum(rr[ind]))
        }
      }
      rt <- rt/nt
      nt <- nt/N
      v1 <- sum(nt*(rt-pc)^2)
      if (v0 < (v1 - eps)) {
        v0 <- v1
        qk <- k - 1
      }
    }
    if (var0 < v0 - eps) {
      qvec1 <- c(qvec0,qk)
      var1 <- v0
    }
  }
  
  return(list(qvec1=qvec1,var1=var1))
}
