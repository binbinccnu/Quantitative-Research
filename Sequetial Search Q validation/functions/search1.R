search1 <- function(eps,jj,Nn,patt1,Q,qvec0,response,Rr,var0) {
  
  N <- nrow(response)
  K <- ncol(Q)
  
  rr <- Rr[jj,]
  patt <- patt1
  pc <- sum(rr)/N
  
  v0 <- 0
  v1 <- 0
  qk <- 0
  
  for (k in 1:K) {
    nt <- c()
    rt <- c()
    tmp_a <- alpha[,k]
    
    for (p in 1:nrow(patt)) {
      ind <- which((rep(1,2^K)*patt[p,]==tmp_a)*1!=0)
      nt <- rbind(nt,sum(Nn[ind]))
      rt <- rbind(rt,sum(rr[ind]))
    }
    rt <- rt/nt
    nt <- nt/N
    
    v1 <- sum(nt*(rt-pc)^2)
    if (v0 < (v1-eps)) {
      v0 <- v1
      qk <- k - 1
    }
    qvec1 <- qk
    var1 <- v0
  }
  
  return(list(qvec1=qvec1,var1=var1))
}