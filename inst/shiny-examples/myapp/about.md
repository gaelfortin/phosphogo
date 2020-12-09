### About Phosphogo
Phosphogo is a set of tools to analyze phosphoproteomic data from mouse and human experiments. Kinase-substrate predictions can be performed using NetworKIN and IV-KEA (in vitro kinase enrichment analysis) in a user-friendly interface. Analyzing phosphoproteomic data without knowing how to code is now possible thanks to phosphogo!

Phosphogo is written in [R](https://www.r-project.org/) 4.0.

Please cite **our paper** when using Phosphogo.

Get the latest updates of phosphogo on the [GitHub repository](https://github.com/gaelfortin/phosphogo) of the project.

**Find more on the [package website](https://gaelfortin.github.io/phosphogo/)**

### Facing an issue?
Feel free to use the package documentation:
- `Tutorial` in the section `More` of this app
- If you use the command-line version of phosphogo check out the vignette with `utils::browseVignettes('phosphogo')`
- the wbesite of the package at **URL**

If your problem is not fixed, please open an issue on our [GitHub issues page](https://github.com/gaelfortin/phosphogo/issues)!

### Phosphogo predictions softwares
Phosphogo relies on the following prediction strategies. Please cite their corresponding authors.
#### NetworKIN
[Horn et al., KinomeXplorer: an integrated platform for kinome biology studies. Nature Methods 2014 Jun;11(6):603–4.](http://www.nature.com/nmeth/journal/v11/n6/full/nmeth.2968.html)

#### IV-KEA
Phosphogo uses the *in vitro* database published in:
[Sugiyama et al., Large-scale Discovery of Substrates of the Human Kinome. Scientific Reports 2019](https://www.nature.com/articles/s41598-019-46385-4)

### Dependency analysis
The dependency analysis provided by phosphogo relies on the [DepMap project](https://depmap.org/portal/) 
and on the R package depmap (Laurent Gatto and Theo Killian (2020). depmap: Cancer Dependency Map Data Package. R package version 1.5.1.)