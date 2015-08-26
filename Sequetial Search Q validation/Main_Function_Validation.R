###############################################################################
# Main_function_Validation:                                                   #                                                                                                                           
#                                                                             #
# This is the main function which refins Q matrix using Jimmy's sequential    # 
# search                                                                      # 
#                                                                             #
###############################################################################

rm(list=ls(all=TRUE))

path  <- '/Users/Aurora/Dropbox/CD/Sequetial Search'
#path <- 'D:/dropbox/CD/Sequetial Search'

Q        <- read.table(file=paste(path,'/Q_matrix_5.txt',sep='')) # original Q matrix
response <- read.table(file=paste(path,'/examinee_data.dat',sep=''))
eps <- .002  # criterion whether to update a q vector

source(paste(path,'//sourceDir.R',sep=''))
sourceDir(paste(path,'/functions',sep=''))


alpha <- AlphaPermute(ncol(Q))
eta   <- Alphaeta(alpha,Q)

prior  <- matrix(1,2^ncol(Q),1)/2^ncol(Q)
lprior <- log(prior/sum(prior))
lprior[lprior==-Inf] <- -2.14748e+09

cat('\014')
post_prior <- matrix(1,nrow(response),2^ncol(Q))
post <- Iterate(est,eta,lprior,post_prior,response,Q)
cat('\n')
Qrefine <- Sequential(eps,post,Q,response)

cat('\n')
cat('Refined Q Matrix','\n')
print(Qrefine)


