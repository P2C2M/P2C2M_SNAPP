
<!-- README.md is generated from README.Rmd. Please edit that file -->
P2C2M.SNAPP
===========

P2C2M.SNAPP uses posterior predictive checks to identify violations to the multispecies coalescent model as implemented in the 'SNAPP' phylogeny estimation program. It was designed to be as accurate and user-friendly as possible.

Installation
------------

To install P2C2M.SNAPP, first download the gunzipped tarball and then install from source in R with:

``` r
install.packages("path/to/P2C2M.SNAPP_1.0.0.tar.gz", repos = NULL, type = "source")
```

Use
---

The P2C2M.SNAPP package contains a single function, *run.p2c2m.snapp*. It requires as input the tree, log, and .xml files from a 'SNAPP' analysis as well as a simple metadata text file. With *run\_mode = 1*, P2C2M.SNAPP will extract parameter values from the input files and simulate posterior predictive datasets. Users must then analyze these posterior predictive datasets with 'SNAPP'. We recommend performing these analyses with a computer cluster, as 'SNAPP' is quite computationally demanding. After analyzing the posterior predictive datasets with 'SNAPP', using *run\_mode = 2* will calculate and compare summary statistics between the empirical and the posterior predictive datasets to identify possible model violations in the empirical dataset. A full tutorial is available from the P2C2M GitHub page \[<https://github.com/P2C2M>\].

Citation
--------

Please cite P2C2M.SNAPP as: Duckett, D.J., Pelletier, T.A., and Carstens, B.C. Submitted. Identifying model violations under the Multispecies Coalescent model with P2C2M.SNAPP.
