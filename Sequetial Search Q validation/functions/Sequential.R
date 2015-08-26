Sequential <- function(eps,post,Q,response) {
  
  in_ <- colSums(post)
  J <- ncol(response)
  K <- ncol(Q)
  Qrefine <- Q
  
  for (j in 1:J) {
    tmp_X <- as.matrix(response[,j]) %*% matrix(1,1,2^K)
    in_ <- rbind(in_,colSums(tmp_X * post))
  }
  
  Nn <- in_[1,]
  Rr <- in_[1:J+1,]
  
  patt1 <- AlphaPermute(1)
  patt2 <- AlphaPermute(2)
 
  count <- 0
  for (j in 1:J) {
    var0 <- 0
    var1 <- 0
    qvec0 <- c()
    qvec1 <- c()
    search_1 <- search1(eps,j,Nn,patt1,Q,qvec0,response,Rr,var0)
    var1 <- search_1$var1
    qvec1 <- sort(search_1$qvec1)
    
    search_2 <- search2(eps,j,Nn,patt2,Q,search_1$qvec1,response,Rr,search_1$var1) 
    var0 <- search_2$var1
    qvec0 <- sort(search_2$qvec1)
    
    index <- 2
    while (length(qvec1) < length(qvec0)) {
      index <- index + 1
      patt <- AlphaPermute(index)
      qvec1 <- qvec0
      var1 <- var0
      search_result <- search(eps,j,Nn,patt,Q,qvec0,response,Rr,var0)
      var0 <- search_result$var1
      qvec0 <- sort(search_result$qvec1)
    }
   
    out <- matrix(0,1,K)
    out[,qvec0+1] <- 1
    if (prod(out == Q[j,]) == 0) {
      Qrefine[j,] <- out
      out <- rbind(Q[j,],out)
      cat('Item ',j,'\n')
      Original <- out[1,1]
      for (o in 2:K) {
        Original <- c(Original,out[1,o])
      }
      cat('Original  ',Original,'\n')
      Suggested <- out[2,1]
      for (o in 2:K) {
        Suggested <- c(Suggested,out[2,o])
      }
      cat('Suggested ',Suggested,'\n')
      count <- count + 1
    }
  }
  
  return(Qrefine)
}