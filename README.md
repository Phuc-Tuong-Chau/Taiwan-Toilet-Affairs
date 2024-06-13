# Project Title
Taiwan-Toilet-Affairs

## Project Description
[Enter a brief description of your project, including the data you used and the analytical methods you applied. Be sure to provide context for your project and explain why it is important.]
## Getting Started
[Provide instructions on how to get started with your project, including any necessary software or data. Include installation instructions and any prerequisites or dependencies that are required.]
## File Structure
[Describe the file structure of your project, including how the files are organized and what each file contains. Be sure to explain the purpose of each file and how they are related to one another.]
## Analysis
[Describe your analysis methods and include any visualizations or graphics that you used to present your findings. Explain the insights that you gained from your analysis and how they relate to your research question or problem statement.]

### Haversine Formula

Given two points on the earth's surface, with their latitudes and longitudes represented as follows:
- Point 1: $(\phi_A, \lambda_A)$
- Point 2: $(\phi_B, \lambda_B)$

The Haversine Formula is:

![a = \sin^2\left(\frac{\phi_B - \phi_A}{2}\right) + \cos(\phi_A) \cdot \cos(\phi_B) \cdot \sin^2\left(\frac{\lambda_B - \lambda_A}{2}\right)](https://latex.codecogs.com/png.latex?\color{blue}a%20%3D%20%5Csin%5E2%5Cleft(%5Cfrac%7B%5Cphi_B%20-%20%5Cphi_A%7D%7B2%7D%5Cright)%20%2B%20%5Ccos(%5Cphi_A)%20%5Ccdot%20%5Ccos(%5Cphi_B)%20%5Ccdot%20%5Csin%5E2%5Cleft(%5Cfrac%7B%5Clambda_B%20-%20%5Clambda_A%7D%7B2%7D%5Cright))

![c = 2 \cdot \text{atan2}\left( \sqrt{a}, \sqrt{1-a} \right)](https://latex.codecogs.com/png.latex?\color{blue}c%20%3D%202%20%5Ccdot%20%5Ctext%7Batan2%7D%5Cleft(%20%5Csqrt%7Ba%7D%2C%20%5Csqrt%7B1-a%7D%20%5Cright))

![d = R \cdot c](https://latex.codecogs.com/png.latex?\color{blue}d%20%3D%20R%20%5Ccdot%20c)

Where:
- $R$ is the earth's radius (mean radius = 6,371 km).



## Results
[Provide a summary of your findings and conclusions, including any recommendations or implications for future research. Be sure to explain how your results address your research question or problem statement.]
## Contributors
[List the contributors to your project and describe their roles and responsibilities.]
## Acknowledgments
[Thank any individuals or organizations who provided support or assistance during your project, including funding sources or data providers.]
## References
[List any references or resources that you used during your project, including data sources, analytical methods, and tools.]
