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

# Haversine Formula

The Haversine Formula is used to calculate the great-circle distance between two points on the surface of a sphere given their longitudes and latitudes. This formula is particularly useful in navigation and geospatial analysis.

## Formula

Given two points on the earth's surface, with their latitudes and longitudes represented as follows:

- Point 1: \((\phi_1, \lambda_1)\)
- Point 2: \((\phi_2, \lambda_2)\)

Where:
- \(\phi_1, \phi_2\) are the latitudes of point 1 and point 2 in radians.
- \(\lambda_1, \lambda_2\) are the longitudes of point 1 and point 2 in radians.

The Haversine Formula is:

\[
a = \sin^2\left(\frac{\Delta\phi}{2}\right) + \cos(\phi_1) \cdot \cos(\phi_2) \cdot \sin^2\left(\frac{\Delta\lambda}{2}\right)
\]

Where:
- \(\Delta\phi = \phi_2 - \phi_1\)
- \(\Delta\lambda = \lambda_2 - \lambda_1\)

Then the distance \(d\) between the two points is:

\[
d = 2 \cdot R \cdot \arcsin\left(\sqrt{a}\right)
\]

Where:
- \(R\) is the earth's radius (mean radius = 6,371 km).

## Example Calculation

Let's calculate the distance between two points:

- Point 1: (52.2296756, 21.0122287) (Warsaw, Poland)
- Point 2: (41.8919300, 12.5113300) (Rome, Italy)

Convert degrees to radians:

\[
\phi_1 = 52.2296756 \times \frac{\pi}{180}
\]
\[
\lambda_1 = 21.0122287 \times \frac{\pi}{180}
\]
\[
\phi_2 = 41.8919300 \times \frac{\pi}{180}
\]
\[
\lambda_2 = 12.5113300 \times \frac{\pi}{180}
\]

Compute \(\Delta\phi\) and \(\Delta\lambda\):

\[
\Delta\phi = \phi_2 - \phi_1
\]
\[
\Delta\lambda = \lambda_2 - \lambda_1
\]

Calculate \(a\):

\[
a = \sin^2\left(\frac{\Delta\phi}{2}\right) + \cos(\phi_1) \cdot \cos(\phi_2) \cdot \sin^2\left(\frac{\Delta\lambda}{2}\right)
\]

Finally, calculate \(d\):

\[
d = 2 \cdot 6371 \cdot \arcsin\left(\sqrt{a}\right)
\]

Using the above formula, you can determine the great-circle distance between the two points.

## Results
[Provide a summary of your findings and conclusions, including any recommendations or implications for future research. Be sure to explain how your results address your research question or problem statement.]
## Contributors
[List the contributors to your project and describe their roles and responsibilities.]
## Acknowledgments
[Thank any individuals or organizations who provided support or assistance during your project, including funding sources or data providers.]
## References
[List any references or resources that you used during your project, including data sources, analytical methods, and tools.]
