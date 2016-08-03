Mining Student Response Data for Knowledge using Q-matrix Method

This code performs Cognitive Diagnostic Assessment for education which helps examine test takers’ mastery of specific sub-skills with greater specificity and allow teachers to apply their own teaching strategies in an existing computer-based training. 

The current folder employs knowledge discovery and data mining techniques to model student knowledge and direct knowledge remediation. See detailed information about [Q-matrix in educational data mining](http://webpages.uncc.edu/tbarnes2/papers/5-Barnes-AAAI-EDM-2005.pdf)

The R source codes include:

1. Main_Function_Simulation.R: Main function to simulate data using reject sampling

2. Main_Function_Estimation.R: Main function to estimate item parameters of DINA model, which is a diagnostic classification model for binary observed responses and binary latent variables.
  - Using Expectation-Maximization algorithm to estimate model parameters when both latent variables and model parameters are unknown

3. Main_Function_Validation.R: Main function to validate Q-matrix, a binary matrix showing the relationship between test items and latent or underlying attributes, or concepts. Students were assigned knowledge states based on their test answers and the constructed q-matrix.
  - Refine the Q-matrix by minimizing the residual sum of square (RSS) betweenn the real responses and ideal responses using sequential search
  
