###############################################################################
# Main_function_Estimation:                                                            #                                              #                                                                             #                                             
#                                                                             #
# This is the main function which computes the g and s by EM algorithm        #
#                                                                             #
###############################################################################

rm(list=ls(all=TRUE))

path  <- '/Users/Aurora/Dropbox/CD/Sequetial Search'
#path <- 'D:/dropbox/CD/Sequetial Search'

Q        <- read.table(file=paste(path,'/q_sample1.txt',sep='')) # original Q matrix
response <- read.table(file=paste(path,'/sample3.dat',sep=''))

source(paste(path,'//sourceDir.R',sep=''))
sourceDir(paste(path,'/functions',sep=''))

estimate <- EM(Q,response)

