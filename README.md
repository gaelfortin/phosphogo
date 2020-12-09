<!-- badges: start -->
  [![Travis build status](https://travis-ci.com/gaelfortin/phosphogo.svg?branch=master)](https://travis-ci.com/gaelfortin/phosphogo)
  <!-- badges: end -->
  
# __phosphogo__
`phosphogo` is a set of tools to analyze phosphoproteomic data from
mouse and human experiments. Kinase-substrate predictions can
be performed using [NetworKIN](http://kinomexplorer.info) and 
IV-KEA (in vitro kinase enrichment analysis). Databases used by `phosphogo`
are located in the `phosphogodb` package.

The following processes can be done with phosphogo:

- Generate predictions of kinase-substrate relationships with NetworKIN
- Generate predictions of kinase-substrate relationships with IV-KEA 
(in vitro kinase enrichment analysis)
- Visualise more and less active kinases in your case vs control condition
- Compare active kinases predicted by NetworKIN and IV-KEA
- Investigate phosphosites functionality in cancers with the DepMap database


__This version of phosphogo supports R > 4.0__

**Find more on the [package website](https://gaelfortin.github.io/phosphogo/)**

### __Installation__
`phosphogo` can be installed with:

```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
if (!requireNamespace("remotes", quietly = TRUE))
    install.packages("remotes")
BiocManager::install("uclouvain-cbio/depmap") #DepMap dependency

if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")
devtools::install_github('gaelfortin/phosphogo')
```
That's it! You can now use phosphogo in application mode or in command-line mode.


Then, on RStudio, run the following commands:

```
library(phosphogo)
dir.create('myexperiment/', showWarnings = FALSE) 
```

You are ready to perform all analyses included in `phosphogo`!

### User-friendly application

Phosphogo comes with a intuitive user interface that offers the same functions
than the command-line version of the package. To launch the app, run:

```
library(phosphogo)
phosphogoApp()
```

You can find demonstration files in the [data folder of the project](https://github.com/gaelfortin/phosphogo/tree/master/data).

### __Command-line version of phosphogo__

#### Pipeline example

An example of a pipeline can be found in the vignette with the command
`utils::browseVignettes('phosphogo')`.


### __How does phosphogo make kinase-substrate predictions?__
Phosphogo relies on the following prediction strategies. Please cite their corresponding authors.

__NetworKIN__
[Horn et al., KinomeXplorer: an integrated platform for kinome biology studies. Nature Methods 2014 Jun;11(6):603–4.](http://www.nature.com/nmeth/journal/v11/n6/full/nmeth.2968.html)

__IV-KEA__
Phosphogo uses the *in vitro* database published in:
[Sugiyama et al., Large-scale Discovery of Substrates of the Human Kinome. Scientific Reports 2019](https://www.nature.com/articles/s41598-019-46385-4)

### __Using DepMap to investigate kinases role in cancer__
[DepMap](https://depmap.org/portal/) is a set of databases that aggregates dependency data for many cancer cell lineages. Phosphogo takes advantage of DepMap to identify deregulated kinases and there substrates that are important for cancer survival.

## Issues
If you have an issue or find a bug, please open an issue
in the Issues section of the [Github repository](https://github.com/gaelfortin/phosphogo/issues).

## Licence
`phosphogo` is distributed under the CC BY-NC-SA licence.

## Other informations
This package is maintained by Gael Fortin (fortin.gael@outlook.fr) and was written
on R 4.0
