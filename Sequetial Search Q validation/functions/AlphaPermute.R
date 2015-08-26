###############################################################################
# AlphaPermute:                                                               #
#                                                                             #
# Given the number of attributes, generate all the possible ability patterns. #
#                                                                             #
# Input:                                                                      #
# (1) dim: number of attributes                                               #
#                                                                             #
# Output:                                                                     #
# (1) alpha: a matrix of all the possible ability patterns with rows are      #
#            different patterns and columns are attributes.                   #
###############################################################################

AlphaPermute <- function(dim) {
  
  alpha = rep(0,dim)
  for (j in 1:dim) {
    permute <- t(as.matrix(combn(dim,j)))
    alpha0  <- matrix(0,nrow=nrow(permute),ncol=dim)
    for (l in 1:nrow(alpha0)) {
      alpha0[l,permute[l,]]=1
    }   
    alpha <- rbind(alpha,alpha0)
  }
  
  return(alpha)
}