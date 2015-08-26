###############################################################################
# Post_alpha:                                                                 #
#                                                                             #
# This function computes posterior for all possible alpha_l's                 #
# for each examinee                                                           #
#                                                                             #
# Input:                                                                      #
# (1) g        : guessing parameter for all items                             #
# (2) Q        : Q matrix                                                     #
# (3) response : response matrix                                              #
# (4) s        : slipping parameter for all items                             #
#                                                                             #
# Output:                                                                     #
# (1) post     : The expected proportion of examinees who have alpha_l        #   
#                given data                                                   #
###############################################################################

Post_alpha <- function(g,Q,response,s) {
  
  ln_prior <- -ncol(Q) * log(2)              # uniform distribution
  alpha    <- AlphaPermute(ncol(Q))
  P        <- Prob(alpha,g,Q,s)              # probability of each pattern answering all the items  
  P[P>.999] <- .999
  P[P<.001] <- .001
  
  L_p  <- as.matrix(response)%*%t(as.matrix(log(P))) + as.matrix(1-response)%*%t(as.matrix(log(1-P))) + ln_prior
  L_p  <- exp(L_p)
  
  post <- L_p /rowSums(L_p)
  
  return(post)
}