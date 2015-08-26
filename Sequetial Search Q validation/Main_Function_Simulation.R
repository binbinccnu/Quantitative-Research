rm(list=ls(all=TRUE))

path <- '/Users/Aurora/Dropbox/Sequetial Search'

Q <- read.table(file=paste(path,'/q_sample1.txt',sep='')) # original Q matrix

source(paste(path,'//sourceDir.R',sep=''))
sourceDir(paste(path,'/functions',sep=''))

n <- nrow(Q)

s_real <- c(0.1789485061, 0.0809115279, 0.1762193612, 0.0007707111, 0.0478684745,
            0.1132877033, 0.0846351734, 0.1983161496, 0.1924034934, 0.0002773555,
            0.1020040464, 0.1083908013, 0.1443174784, 0.0788345427, 0.0260505296,
            0.0424735243, 0.0195076386, 0.1343605996, 0.0570817573, 0.1887113184,
            0.0702919960, 0.1642697453, 0.0456945249, 0.1024877646, 0.0589791444,
            0.1346767871, 0.1696040425, 0.1012321734, 0.0621451393, 0.0343534913)
g_real <- c(0.123913312, 0.067020764, 0.078402437, 0.009090333, 0.046506471, 0.170211251,
            0.100693328, 0.047328087, 0.106656510, 0.024893354, 0.176013408, 0.113561260,
            0.199302706, 0.034445307, 0.133502223, 0.161112824, 0.136145311, 0.180134266,
            0.111757347, 0.028129687, 0.083417346, 0.091818762, 0.064656762, 0.096699009,
            0.075216656, 0.185954271, 0.074207966, 0.036801153, 0.088011313, 0.030936001)

alpha <- AlphaPermute(ncol(Q))
response=read.table(file=file=paste(path,'/response.txt',sep=''))

estimate_EM <- EM(Q,response)
estimate_ML <- ParMLE(response, Q, alpha, model="DINA")

bias_s_EM <- sum(abs(s_real-estimate_EM$s_estimate))/length(s_real)
bias_g_EM <- sum(abs(g_real-estimate_EM$g_estimate))/length(g_real)
rmse_s_EM <- sqrt(sum((s_real-estimate_EM$s_estimate)^2)/length(s_real))
rmse_g_EM <- sqrt(sum((g_real-estimate_EM$g_estimate)^2)/length(g_real))

bias_s_ML <- sum(abs(s_real-estimate_ML$slip))/length(s_real)
bias_g_ML <- sum(abs(g_real-estimate_ML$guess))/length(g_real)
rmse_s_ML <- sqrt(sum((s_real-estimate_ML$slip)^2)/length(s_real))
rmse_g_ML <- sqrt(sum((g_real-estimate_ML$guess)^2)/length(g_real))



print(rmse_s_EM)
print(rmse_g_EM)


print(rmse_s_ML)
print(rmse_g_ML)