###############################################################################
# Prob:                                                                       #
#                                                                             #
# The probability of answering correctly for N examinee, n items              #
#                                                                             #
# Input:                                                                      #
# (1) alpha  : alpha for N examinee, N by k                                   #
# (2) g      : guessing parameter for all items vector (1 by n)               #
# (3) Q      : Q matrix                                                       #
# (4) s      : slipping parameter for all items                               #
#                                                                             #
# Output:                                                                     #
# (1) P      : probability, which is an N by n matrix                         # 
###############################################################################


Prob <- function(alpha,g,Q,s) {
  
  eta <- Eta(alpha,Q)
  P   <- t(apply(eta,1,function(x) x*(1-s)+(1-x)*g))
  
  return(P)
}
