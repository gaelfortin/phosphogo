# __phosphogo__
`phosphogo` is a set of tools to analyze phosphoproteomic data from
mouse and human experiments. Kinase-substrate predictions can
be performed using [NetworKIN](http://kinomexplorer.info) and 
IV-KEA (in vitro kinase enrichment analysis).


### __Installation__
`phosphogo` can be installed with:

```
devtools::install_github('wleepang/shiny-directory-input') #dependency for Shiny app
devtools::install_github('gaelfortin/phosphogo')
devtools::install_github('gaelfortin/phosphogodb') #databases required for phosphogo
```
That's it! You can now use phosphogo in application mode or in command-line mode.


Then, on RStudio, run the following commands:

```
library(phosphogo)
dir.create('myexperiment/', showWarnings = FALSE) 
networkin_setup()
```

You are ready to perform all analyses included in `phosphogo`!

### User-friendly application

Phosphogo comes with a intuitive user interface that offers the same functions
than the command-line version of the package. To launch the app, run:

```
library(phosphogo)
launchApp()
```

You can find demonstration files in the [GitHub repository](https://github.com/gaelfortin/phosphogo) of phosphogo.

### __Command-line version of phosphogo__

#### Pipeline example

An example of a pipeline can be found in the vignette with the command
`utils::browseVignettes('phosphogo')`.


### __How does phosphogo make kinase-substrate predictions?__
Phosphogo relies on the following prediction strategies. Please cite their corresponding authors.

### NetworKIN
[Horn et al., KinomeXplorer: an integrated platform for kinome biology studies. Nature Methods 2014 Jun;11(6):603–4.](http://www.nature.com/nmeth/journal/v11/n6/full/nmeth.2968.html)

### IV-KEA
Phosphogo uses the *in vitro* database published in:
[Sugiyama et al., Large-scale Discovery of Substrates of the Human Kinome. Scientific Reports 2019](https://www.nature.com/articles/s41598-019-46385-4)

## Issues
If you have an issue or find a bug, please open an issue
in the Issues section of the [Github repository](https://github.com/gaelfortin/phosphogo/issues).

## Licence
`phosphogo` is distributed under the CC BY-NC-SA licence.

## Other informations
This package is maintained by Gael Fortin (fortin.gael@outlook.fr) and was written
on R 3.6.3
