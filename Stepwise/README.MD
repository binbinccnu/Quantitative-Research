Using stepwise method to detect parameter shift in test items.

Three methods are: Stepwise TCC Method, Pearson’s d square Method, and Mantel Haenszel Chi-square testing method.

The most important Matlab source codes include:

1. Main_Function.m:
  - Main function to compare different methods in item parameter drift detection
in linear-testing based educational testing 

2. Main_Function1_datasimulation.m: Data simulation
  - datageneratesingle.m
  - Examinee_Response_Simulation.m
  - P_Computation.m

3. Main_Function2_estimation_linking.m 
  - Draw_DIF.m
  - mle_theta.m 
  - conversion.m

4. Main_Function3_stepwise.m
  - areadiff.m
  - stepwisetcc.m
  - tcc.m
  - backward.m
  - CSEM.m

5. Main_Function4_dsquare.m
  - dsquare.m

6. Main_Function5_mantel_lord.m
  - difR package

7. Main_Function6_result.m
  - BIAS.m
  - RMSE.m

8. real_data.m: Real data analysis 
  - realdata_d_square.m
  - realdata_estimation.m
  - realdata_mantel.m
  - realdata_result.m
  - realdata_stepwise.m