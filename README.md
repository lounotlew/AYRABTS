# All Your Restaurant Are Belong To Us - Simple and Intuitive App for Downloading Yelp API Data
> App. written by Lewis Kim; Yelp API fetch/request functions borrowed from online sources (see files for authors).

### Description

All Your Restaurant Are Belong To Us (AYRABTS) is a small-scale ``shiny`` web app with a simple, intuitive interface that allows you to filter and write the data from Yelp Business Search, Business Lookup, Business Hours, and Business Reviews into .csv and .txt files (writes locally into /output folder). Currently, AYRABTS is not published onto any web domain, and requires the same file/directory structure to function properly; but, this can easily be changed in the code to work in other situations. Additionally, the richness of business reviews data (and to a degree, business search) is limited due to Yelp's API restrictions (returns a maximum of 3 reviews for business reviews).

For a GUI sample and app walkthrough, click this [link](gui_sample/README.md).

### Installation

AYRABTS is available at https://lounotlew.shinyapps.io/ayrabts/.

If you want to run it on your own machine:

Required packages:
- ``shiny`` (install: ``install.packages('shiny')``)
- ``dplyr`` (install: ``install.packages('dplyr')``)
- ``tidyverse`` (install: ``install.packages('tidyverse')``)
- ``httr`` (install: ``install.packages('httr')``)
- ``tibble`` (install: ``install.packages('tibble')``)
- ``assertive.types`` (install: ``install.packages('assertive.types')``)

After installing all required packages, to run this app locally on RStudio, first set your working directory to the directory AYRABTS is contained in using ``setwd('directory')``, and then click "Run App."
### References

References to the libraries and packages used in AYRABTS:

1) ``shiny``: https://shiny.rstudio.com/articles/basics.html
2) ``dplyr``: https://dplyr.tidyverse.org/
3) ``tidyverse``: https://www.tidyverse.org/
4) ``httr``: https://cran.r-project.org/web/packages/httr/index.html
5) ``tibble``: https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html
