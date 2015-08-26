###############################################################################
# Findpost:                                                                 #
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

Findpost <- function (est,eta,lprior,post_prior,response,Q) {
  
  K <- ncol(Q)
  N <- nrow(response)
  J <- nrow(Q)
  
  tmp0 <- matrix(0,2^K,J)
  for (j in 1:J) {
    for (cl in 1:2^K) {
      tmp0[cl,j] <- est[j,eta[cl,j]+1]
    }
  }
  
  tmp = log(tmp0)%*%t(response) + log(1-tmp0)%*%t(1-response) + lprior[,rep(1,N)]
  tmp = exp(tmp)
  tmp1 = t(colSums(tmp))
  post_prior = t(tmp / tmp1[rep(1,2^K),])
    
 
  post <- post_prior
  return(post)
}