
#----------------------------MLE_theta-------------------------#
#     This function computes MLE of theta given the item       #
# parameters and responses.                                    #
#--------------------------------------------------------------#

MLE_theta <- function
(
    item_par,   # a-, b-, c-parameters, a vector or a matrix with rows indicating different items
    d,   				# scaling parameter, usually 1 or 1.702
    response,   # a scaler or a vector of dichotomous response
    max_est,    # maximum estimate given to all-correct response
    min_est     # minimum estimate given to all-incorrect response
)
{
    if (sum(response)==length(response))
    {
        estimate <- max_est
    }
    else if (sum(response)==0)
    {
        estimate <- min_est
    }
    else
    {
        estimate <- optimize(loglike_3plm,interval=c(min_est,max_est),maximum=TRUE,item_par=item_par,d=d,response=response,tol=.0000000000000002)$max
    }
    return(estimate)
}
