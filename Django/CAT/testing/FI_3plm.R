##################
#FI_3plm.R       #
##################
#----------------------------FI_3plm---------------------------#
#     This function computes Fisher Information at the given   #
# theta location for 3PLM.                                     #
# Expected Fisher Information: p'^2/(p*q)                      #
#--------------------------------------------------------------#

FI_3plm <- function
(
    item_par,          # a vector or matrix of 3plm a-,b-,c-parameters
    d,                 # the scaling parameter, usually 1 or 1.702
    theta              # a scaler of examinee proficiency
)

{ 
    FI_3plm <- (pder1_3plm(item_par,d,theta))^2/(p_3plm(item_par,d,theta)*(1-p_3plm(item_par,d,theta)))
    return(FI_3plm)
}
