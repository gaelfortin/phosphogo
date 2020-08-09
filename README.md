# __phosphogo__
`phosphogo` is a set of tools to analyze phosphoproteomic data from
mouse and human experiments. Kinase-substrate predictions can
be performed using [NetworKIN](http://kinomexplorer.info) and 
IV-KEA (in vitro kinase enrichment analysis).

### __Easy installation__
`phosphogo` can be installed with:

```
devtools::install_github('gaelfortin/phosphogo')
```

Then, download the complete `phosphogo` R project 
by cloning `https://github.com/gaelfortin/phosphogo.git` with git
or hitting the `Code` button and selecting `Download Zip` on the 
[GitHub repository](https://github.com/gaelfortin/phosphogo). Open the 
R project file `phosphogo.Rproj` and execute the following commands:

```
library(phosphogo)
networkin_setup()
```

You are ready to perform all analyses included in `phosphogo`!

_For custom installation, see the detailed instructions below._




### __Pipeline example__

An example of a pipeline can be found in the vignette 
`utils::browseVignettes('phosphogo')` or open the .Rmd file in 
`vignettes/how_to_use_phosphogo.Rmd`



### __Detailed instructions for custom installation (not recommended)__
### NetworKIN installation
__Dependencies__


_Predictions based on NetworKIN can be generated only when using a linux-based
OS._


NetworKIN relies on the following dependencies:

- BLAST version 2.2.17 or __older__ (BLAST+ is not supported). BLAST 2.2.17 can
be downloaded [here](https://ftp.ncbi.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.17/).

- Python 2. Python 3 is currently __not__ supported. 


__Installation__


Download NetworKIN as an archive from `phosphogo` [GitHub repository](https://github.com/gaelfortin/phosphogo/blob/master/networkin.zip).
Remark: this archive is a modified version of NetworKIN 3 available 
[here](http://networkin.info/download.shtml).

It is recommended to download this archive in your R working directory.


Once downloaded, run
```
networkin_setup(networkin_zip = 'networkin.zip', networkin_folder = 'networkin')
```

NetworKIN setup can be customized by changing `networkin_setup()` parameters
(see `?networkin_setup` for details).




### IV-KEA
__Installation__


IV-KEA relies on the in vitro kinase-substrate interaction database produced
by [Sugiyama __et al.__](https://www.nature.com/articles/s41598-019-46385-4).
UniprotKB accession numbers have been added to this database.


## Issues
If you have an issue or find a bug, please open an issue
in the Issues section of the [Github repository](https://github.com/gaelfortin/phosphogo/issues).


## Other informations
This package is maintained by Gael Fortin (fortin.gael@outlook.fr) and was designed
on R 3.6.3
