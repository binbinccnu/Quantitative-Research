MLE=function
(response,path)
{
	source(paste(path,'/loglike_3plm.R',sep=''))
	source(paste(path,'/p_3plm.R',sep=''))
	source(paste(path,'/MLE_theta.R',sep=''))
	parameter=read.table(paste(path,'/par.txt',sep=''))
	theta = MLE_theta(parameter,1.7032,response,3,-3)
	theta = round(theta,digits=2)	
	return(theta)
}
	