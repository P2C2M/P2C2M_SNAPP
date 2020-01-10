
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

### Dependencies:

#### R:

R (&gt;= 3.5.0),
ape (&gt;= 5.3),
ggplot2 (&gt;= 3.2.0),
graphics (&lt;= 3.5.0),
grDevices (&gt;= 3.5.0),
gsubfn (&gt;= 0.7),
ggtree (&gt;= 1.14.6) - not on CRAN (see below),
KRIS (&gt;= 1.1.1),
stats (&gt;= 3.5.0),
utils (&gt;= 3.5.0)

The easiest way to install ggtree is with code from the Bioconductor website:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ggtree")
```

#### Additional:

fastsimcoal2 (Excoffier et al., 2013: available at \[<http://cmpg.unibe.ch/software/fastsimcoal2/>\]) See fastsimcoal2 website if you encounter errors - they may be due to the version of gcc on your computer. If you see a dyld error, it can be fixed by using the code at https://gist.github.com/jonchang/46f24dd460bab840ba69a24190fe11f8. Thanks to Jonathan Chang and Tara Pelletier for figuring out how to fix this issue.

#### System:

Mac users need to have XQuartz installed for fastsimcoal2 to run: available at \[<https://www.xquartz.org>\]

More installation information can be found in the tutorial or vignette.

Use
---

The P2C2M.SNAPP package contains a single function, *run.p2c2m.snapp*. It requires as input the tree, log, and .xml files from a 'SNAPP' analysis as well as a simple metadata text file. With *run\_mode = 1*, P2C2M.SNAPP will extract parameter values from the input files and simulate posterior predictive datasets. Users must then analyze these posterior predictive datasets with 'SNAPP'. We recommend performing these analyses with a computer cluster, as 'SNAPP' is quite computationally demanding. After analyzing the posterior predictive datasets with 'SNAPP', using *run\_mode = 2* will calculate and compare summary statistics between the empirical and the posterior predictive datasets to identify possible model violations in the empirical dataset. A full tutorial is available from the P2C2M GitHub page \[<https://github.com/P2C2M>\].

Citation
--------

Please cite P2C2M.SNAPP as: Duckett, D.J., Pelletier, T.A., and Carstens, B.C. 2020. Identifying model violations under the Multispecies Coalescent model with P2C2M.SNAPP. PeerJ 8:e8271 https://doi.org/10.7717/peerj.8271.
