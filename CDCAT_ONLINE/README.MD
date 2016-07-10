Online calibration for [Cognitive Diagnostic Model](http://webpages.uncc.edu/tbarnes2/papers/5-Barnes-AAAI-EDM-2005.pdf) in [computerized adaptive testing](https://en.wikipedia.org/wiki/Computerized_adaptive_testing).

The most important Matlab source codes include:

1. Online_Calibration_CDCAT.m:
  - Main function to perform DINA model (a diagnostic classification model for binary observed responses and binary latent variables) based computerized adaptive testing
  - Perform online calibration (calibrate model parameters on-the-fly as adaptive testing continues)

2. Operational adaptive testing process:
  - MLE_CD.m: Maximum likelihood estimation of attribute matrix
  - Shannon_CD.m: Item selection using Shannon entropy
  - posterior_alpha.m: Compute posterior distribution of attribute matrix given response data
  - CD_prob_matrix.m: Compute probability of success (getting an correct answer)

3. Online calibration process:
  - METHOD_A_CDCAT.m: Calibrate model parameters using conditional maximum likelihood estimation
  - OEM_CDCAT.m: Calibrate model parameters using one cycle Expectation-Maximization algorithm
  - MEM_CDCAT.m: Calibrate model parameters using multiple cycle Expectation-Maximization algorithm
