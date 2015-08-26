FI=function
(theta,selected_items,path)
{
	source(paste(path,'/FI_3plm.R',sep=''))
	source(paste(path,'/p_3plm.R',sep=''))
	source(paste(path,'/pder1_3plm.R',sep=''))
	parameter=read.table(paste(path,'/par.txt',sep=''))
	parameter=parameter[,2:4]
	FIs=FI_3plm(parameter,1.7032,theta)
	for (index in 1:length(FIs)){
		candidate=order(FIs,decreasing=TRUE)[index]
		if (!is.element(candidate,selected_items)){
			break
			}
		}
	return(candidate)
}
