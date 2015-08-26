
#-------------------------Loglike_3plm-------------------------#
#     This function computes 3PLM log-likelihood of a set of   #
# items for a specific theta given the response vector.        #
#--------------------------------------------------------------#

loglike_3plm <- function
(
    item_par,  # a-, b-, c-parameters, a vector or a matrix with rows indicating different items
    d,         # scaling parameter, usually 1 or 1.702
    theta,     # a scaler of theta
    response   # a scaler or a vector of dichotomous response
)

{
    p <- p_3plm(item_par,d,theta)
    loglike <- sum(log(p)*response+log(1-p)*(1-response))
    return(loglike)
}

