###############################################################################
# EM:                                                                         #
#                                                                             #
# Estimate the guessing and slipping parameters for an item                   #
#                                                                             #
# Input:                                                                      #
# (1) Q           : Q matrix                                                  #
# (2) response    : response matrix                                           #
#                                                                             #
# Output:                                                                     #
# (1) g_estimate  : estimated g value                                         # 
# (2) s_estimate  : estimated s value                                         # 
###############################################################################

EM <- function(Q,response) {
  
  ite <- 0
  diff <- 1
  epsilon <- .0000001  
  # initialize g and s
  g   <- .12*runif(nrow(Q))
  s   <- .12*runif(nrow(Q))
  
  while (diff > epsilon && ite <= 20) {
    ite <- ite + 1
    g_estimate <- c()
    s_estimate <- c()
    
    # estimate parameters for all items
    for (item in 1:ncol(response)) {
      estimate   <- Maximization(g,item,s,Q,response)
      g_estimate <- c(g_estimate,estimate$g_est)
      s_estimate <- c(s_estimate,estimate$s_est)
    }
    
    # check the difference
    g_diff <- sum((g-g_estimate)*(g-g_estimate))
    s_diff <- sum((s-s_estimate)*(s-s_estimate))
    diff   <- g_diff + s_diff
    
    # update values
    g <- g_estimate
    s <- s_estimate
  }
  
  return(list(g_estimate=g_estimate,s_estimate=s_estimate,iteration=ite))
}