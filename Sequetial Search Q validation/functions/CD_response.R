# s and g are column vectors
# alpha is a person by item matrix
# Q is the Q matrix


CD_response <- function(s,g,alpha,Q) {
  U <- matrix(0,nrow=dim(alpha)[1],ncol=dim(Q)[1])
  P <- Prob(alpha,g,Q,s)
  R <- matrix(runif(dim(alpha)[1]*dim(Q)[1]),dim(alpha)[1],dim(Q)[1])
  U[P>R] = 1;
  return(U)
}



