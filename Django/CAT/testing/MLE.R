MLE=function
(response,selected_items,path)
{
	source(paste(path,'/loglike_3plm.R',sep=''))
	source(paste(path,'/p_3plm.R',sep=''))
	source(paste(path,'/MLE_theta.R',sep=''))
	parameter=read.table(paste(path,'/par.txt',sep=''))
	parameter=parameter[selected_items,2:4]
	theta = MLE_theta(parameter,1.7032,response,3,-3)
	theta = round(theta,digits=2)	
	return(theta)
}
	