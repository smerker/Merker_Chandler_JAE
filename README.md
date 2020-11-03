# Merker_Chandler_JAE

Data and code for a N-mixture model in JAGS used in paper:

Merker, S.A and Chandler, R.B. In Press. An experimental test of the Allee effects range limitation hypothesis. Journal of Animal Ecology.

The file [JAE-data.gzip](JAE-data.gzip) contains the data required to run the model, including:
1) scaled and center covariates of detection
2) a 3 dimensional array containing counts of Canada warbler (*Cardellina canadensis*) at 71 point count locations over 4 years
3) A climate PCA derived from PRISM data. 

From R, you can load the data with the command `load("JAE-data.gzip")`.

The JAGS code is in the file [Abundance_EN_clim-trt-D.jag](Abundance_EN_clim-trt-D.jag)

[Merker_Chandler_Appendices.Rmd](Merker_Chandler_Appendices.Rmd) is an Rmarkdown file for the appendices of the article


## DOI

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4238700.svg)](https://doi.org/10.5281/zenodo.4238700)
