Invented a non-parametric hypothesis testing to detect parameter shift among groups in computerized adaptive testing with sparse response matrix

The most important Matlab source codes include:

1. drift_cat.m:
  - Main function to perform item pool stratification with exposure control, modified SIBTEST and compute false positive and false negative

2. Operational computerized adaptive testing with exposure control for the first and second administration
  - stratification.m: Stratification of the item bank 
  - CAT_SH_1.m
  - CAT_SH_2.m
  - CAT_stratification_1.m 
  - CAT_stratification_2.m

3. SIBTEST.m: A modified SIBTEST derived from Central Limit Theory to detect parameter shift

4. MEM.m: Expectation-Maximization algorithm to estimate model parameters

5. ANALYZE_RESULTS.m: false positive and false negative to evaluate classification accuracy
