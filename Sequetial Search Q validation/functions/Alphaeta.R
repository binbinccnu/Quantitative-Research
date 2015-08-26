###############################################################################
# AlphaEta:                                                                        #
#                                                                             #
# Compute eta values for each examinee, each item                             #
#                                                                             #
# Input:                                                                      #
# (1) alpha  : alpha for N examinee, N by k                                   #
# (2) Q      : Q matrix                                                       #
#                                                                             #
# Output:                                                                     #
# (1) eta    : whether this examinee has mastered all the required attributes # 
###############################################################################


Alphaeta <- function(alpha,Q) {
  eta <- matrix(0,nrow=2^ncol(Q),nrow(Q))
  for (i in 1:2^ncol(Q)) {
    for (j in 1:nrow(Q)) {
      Kj <- rowSums(Q)[j]
      Lj <- which(Q[j,]==1)
      Qj <- c()
      for (kj in 1:Kj) {
        tmp <- c()
        base <- rbind(matrix(0,2^(Kj-kj),1),matrix(1,2^(Kj-kj),1))
        for (lj in 1:2^(kj-1)) {
          tmp <- rbind(tmp,base)
        }
        Qj <- cbind(Qj,tmp)
      }
      Qj <- cbind(Qj,rowSums(Qj))
      tmpq <- matrix(0,2^Kj,1)
      for (k in 1:Kj) {
        tmpq <- tmpq-10^(Kj-k)*Qj[,k]
      }
      Qj <- cbind(Qj,tmpq)
      Qj <- Qj[order(Qj[,Kj+1],Qj[,Kj+2]),]
      Qj <- Qj[,1:Kj]
      tmp_alpha <- alpha[i,Lj]
      if (length(tmp_alpha)>1) {
        tmp_alpha <- t(tmp_alpha)
        tmp_alpha <- tmp_alpha[rep(1,nrow(Qj)),]
        tmp_loc   <- which(apply((tmp_alpha==Qj)*1,1,prod)==1)} else {
        tmp_loc <- which(((tmp_alpha==Qj*1)==1)*1==1)
        }     
      eta[i,j] <- tmp_loc-1
    }
  }
  
  return(eta)
}

