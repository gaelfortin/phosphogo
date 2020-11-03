# __phosphogo__
`phosphogo` is a set of tools to analyze phosphoproteomic data from
mouse and human experiments. Kinase-substrate predictions can
be performed using [NetworKIN](http://kinomexplorer.info) and 
IV-KEA (in vitro kinase enrichment analysis).

### Easy installation
`phosphogo` can be installed with:

```
devtools::install_github('wleepang/shiny-directory-input') #dependency for Shiny app
devtools::install_github('gaelfortin/phosphogo')
```
That's it! You can now use phosphogo in application mode or in command-line mode.

### __Phosphogo user-friendly application (recommended)__
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



### __Detailed instructions for command-line installation__
_Follow the following instructions if you want to use phosphogo in command-line version._
#### NetworKIN installation
`phosphogo` uses a modified version of NetworKIN 3.

Install NetworKIN by running:
```
networkin_setup()
```


__Dependencies__


_Predictions based on NetworKIN can be generated only when using a linux-based
OS._


NetworKIN relies on the following dependencies:

- BLAST version 2.2.17 or __older__ (BLAST+ is not supported). BLAST 2.2.17 can
be downloaded [here](https://ftp.ncbi.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.17/).

- Python 2. Python 3 is currently __not__ supported. 
Python 2 can be installed with `sudo apt install python2` (on a bash terminal).

#### IV-KEA
__Installation__


IV-KEA relies on the in vitro kinase-substrate interaction database produced
by [Sugiyama _et al._](https://www.nature.com/articles/s41598-019-46385-4).
UniprotKB accession numbers have been added to this database. The database 
is contained in a ready-to-use file (`data/imported/invitrodb.csv').
To download the IV-KEA database (for custom installation), run:
```
ivkea_setup()
```

## Issues
If you have an issue or find a bug, please open an issue
in the Issues section of the [Github repository](https://github.com/gaelfortin/phosphogo/issues).

## Licence
`phosphogo` is distributed under the CC BY-NC-SA licence.

## Other informations
This package is maintained by Gael Fortin (fortin.gael@outlook.fr) and was designed
on R 3.6.3
