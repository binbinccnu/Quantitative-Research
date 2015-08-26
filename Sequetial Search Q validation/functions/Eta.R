###############################################################################
# Eta:                                                                        #
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



Eta <- function(alpha,Q) {
  
  eta0 <- alpha %*% t(Q)
  sumQ <- rowSums(Q)
  eta  <- t(apply(eta0,1, function(x) (x==sumQ)*1))
 
  return(eta)
}
