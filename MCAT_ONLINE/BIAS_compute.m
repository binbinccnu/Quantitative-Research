function bias = BIAS_compute(true,est)

bias = sum(abs(true - est)) / length(true);