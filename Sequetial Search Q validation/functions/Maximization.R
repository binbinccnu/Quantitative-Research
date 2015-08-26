###############################################################################
# Maximization:                                                               #
#                                                                             #
# Estimate the guessing and slipping parameters for an item                   #
#                                                                             #
# Input:                                                                      #
# (1) g        : guessing parameter for all items (n by 1)                    #
# (2) item     : the item to be estimated                                     #
# (3) s        : slipping parameter for all items (n by 1)                    #
# (4) Q        : Q matrix                                                     #
# (5) response : response matrix                                              #
#                                                                             #
# Output:                                                                     #
# (1) g_est  : estimated g value                                              # 
# (2) s_est  : estimated s value                                              # 
###############################################################################

Maximization <- function(g,item,s,Q,response) {
  
  alpha <- AlphaPermute(ncol(Q))
  post  <- Post_alpha(g,Q,response,s)  # posterior probability for each examinee, each pattern
  eta   <- Eta(alpha,Q)[,item]
  L     <- rowSums(post*rep(1,nrow(response)) %*% t(eta))
  
  n0 <- nrow(response)-sum(L)
  r0 <- sum(response[,item]*(1-L))
  n1 <- sum(L)
  r1 <- sum(response[,item]*L)
    
  g_est <- r0 / n0
  s_est <- (n1-r1) / n1
   
  return(list(g_est=g_est,s_est=s_est))
}
