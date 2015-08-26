
#--------------------------Pder1_3plm---------------------------#
#     This function computes the first order derivative of the  #
# probability correct function for 3PLM.                        #
#---------------------------------------------------------------#

pder1_3plm <- function
(
    item_par,          # a vector or matrix of 3plm a-,b-,c-parameters
    d,                 # the scaling parameter, usually 1 or 1.702
    theta              # a scaler of examinee proficiency
)

{
    if(is.null(dim(item_par)))
    {
        a <- item_par[1]; b <- item_par[2]; c <- item_par[3]
    }
    else
    {
        a <- item_par[,1]; b <- item_par[,2]; c <- item_par[,3]
    }

    ex <- exp(d*a*(theta-b))
    pder1 <- (1-c)*d*a*ex/(1+ex)^2 

    return(pder1)
}
