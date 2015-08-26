
#--------------------------P_3plm------------------------------#
# This function computes probability correct for a 3PLM item.  #
#--------------------------------------------------------------#

p_3plm <- function
(
    item_par,          # a vector or matrix of 3plm a-,b-,c-parameters
    d,                 # the scaling parameter, usually 1 or 1.702
    theta              # a scaler of examinee proficiency
)

{
    if(is.null(dim(item_par)))
    {
        a <- item_par[1] ; b <- item_par[2] ; c <- item_par[3]
    }
    else
    {
        a <- item_par[,1]; b <- item_par[,2]; c <- item_par[,3]
    }

    p <- c+(1-c)/(1+exp(-d*a*(theta-b)))

    return(p)
}
