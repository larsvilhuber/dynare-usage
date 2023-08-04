---
title: "Dynare usage in major Econ journals"
author: "Lars Vilhuber"
date: "2023-08-04"
output: 
  html_document: 
    keep_md: yes
---



# Download Sebastian Kranz' data

Not shown here.


```r
programs
```

```
## [1] "/project"
```

```r
source(file.path(programs,"01_download_sqlite.R"), echo=FALSE)
```

```
## File from http://econ.mathematik.uni-ulm.de/ejd/files.zip was successfully downloaded and extracted
```

```
## File from http://econ.mathematik.uni-ulm.de/ejd/articles.zip was successfully downloaded and extracted
```

Data citation:

> Sebastian Kranz. 2023. "Economic Articles with Data". https://ejd.econ.mathematik.uni-ulm.de/, accessed on 2023-08-04

# Process data



```r
source(file.path(programs,"02_process_sqlite.R"), echo=TRUE)
```

```
## 
## > source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")), 
## +     "pathconfig.R"), echo = FALSE)
## 
## > source(file.path(programs, "config.R"), echo = FALSE)
## 
## > source(file.path(programs, "libraries.R"), echo = FALSE)
## 
## > exclusions.ext <- c("eps", "pdf", "doc", "docx", "ps", 
## +     "csv", "dta", "tex")
## 
## > inclusions.ext <- c("mod")
## 
## > files_db <- dbConnect(RSQLite::SQLite(), kranz.sql)
## 
## > articles_db <- dbConnect(RSQLite::SQLite(), kranz.sql2)
## 
## > files_dynare <- dbGetQuery(files_db, "SELECt * FROM files WHERE file_type != '' ;") %>% 
## +     filter(!file_type %in% exclusions.ext) %>% mutate(pre .... [TRUNCATED] 
## 
## > names(files_dynare)
## [1] "id"             "file"           "file_type"      "kb"            
## [5] "nested"         "present_dynare"
## 
## > head(files_dynare)
##             id                                             file file_type
## 1 aer_108_12_2         Codes and Data/AER-2015-1510R2_Shapley.m         m
## 2 aer_108_12_2                      Codes and Data/obfn_other.m         m
## 3 aer_108_12_2               Codes and Data/data_est_01212015.m         m
## 4 aer_108_12_2          Codes and Data/AER-2015-1510R2_pspp.mod       mod
## 5 aer_108_12_2 Codes and Data/AER-2015-1510R2_counterfactuals.m         m
## 6 aer_108_12_2         Codes and Data/AER-2015-1510R2_results.m         m
##       kb nested present_dynare
## 1 28.733      0          FALSE
## 2  0.264      0          FALSE
## 3  2.513      0          FALSE
## 4 12.900      0           TRUE
## 5 36.860      0          FALSE
## 6 25.275      0          FALSE
## 
## > nrow(distinct(files_dynare, id))
## [1] 8031
## 
## > head(files_dynare %>% filter(present_dynare))
##              id                                                 file file_type
## 1  aer_108_12_2              Codes and Data/AER-2015-1510R2_pspp.mod       mod
## 2  aer_108_12_2         Codes and Data/pspp_experiments_07262016.mod       mod
## 3 aer_108_11_10              publiccode++/CCHH_Code++/CCHH_EZBKK.mod       mod
## 4 aer_108_11_10 publiccode++/CCHH_Code++/CCHH_EZBKK_withDividend.mod       mod
## 5 aejmac_10_4_2               data/general_bond_labor_estimation.mod       mod
## 6 aejmac_10_4_2                                    data/baseline.mod       mod
##       kb nested present_dynare
## 1 12.900      0           TRUE
## 2 11.389      0           TRUE
## 3  9.133      0           TRUE
## 4  9.742      0           TRUE
## 5  8.676      0           TRUE
## 6  7.285      0           TRUE
## 
## > articles <- dbGetQuery(articles_db, "SELECt id,year,date,journ FROM article;")
## 
## > nrow(distinct(articles, id))
## [1] 11051
## 
## > analysis_dynare <- left_join(articles, files_dynare, 
## +     by = "id")
## 
## > nrow(distinct(analysis_dynare, id))
## [1] 11051
## 
## > analysis_dynare %>% group_by(id) %>% summarize(present_dynare = max(present_dynare, 
## +     na.rm = FALSE)) %>% mutate(present_dynare = replace_na(pr .... [TRUNCATED] 
## # A tibble: 1 × 3
##       n dynare_n dynare_pct
##   <int>    <int>      <dbl>
## 1 11051      190       1.72
## 
## > analysis_dynare %>% group_by(journ, id) %>% summarize(present_dynare = max(present_dynare, 
## +     na.rm = FALSE)) %>% mutate(present_dynare = replac .... [TRUNCATED]
```

```
## `summarise()` has grouped output by 'journ'. You can override using the
## `.groups` argument.
```

```
## # A tibble: 17 × 4
##    journ      n dynare_n dynare_pct
##    <chr>  <int>    <int>      <dbl>
##  1 aejapp   611        0      0    
##  2 aejmac   510       61     12.0  
##  3 aejmic   491        5      1.02 
##  4 aejpol   637        3      0.471
##  5 aer     3613       45      1.25 
##  6 aeri     102        1      0.980
##  7 ecta     317       16      5.05 
##  8 jaere    171        0      0    
##  9 jeea     300        9      3    
## 10 jep      569        1      0.176
## 11 jole     210        0      0    
## 12 jpe      308        9      2.92 
## 13 ms       435        2      0.460
## 14 pandp    467        6      1.28 
## 15 qje      259        1      0.386
## 16 restat  1246       11      0.883
## 17 restud   805       20      2.48 
## 
## > max(articles$year)
## [1] 2023
## 
## > min(articles$year)
## [1] 2005
```

# Software citations



```r
source(file.path(programs,"03_citations.R"), echo=TRUE)
```

```
## 
## > citation()
## 
## To cite R in publications use:
## 
##   R Core Team (2022). R: A language and environment for statistical
##   computing. R Foundation for Statistical Computing, Vienna, Austria.
##   URL https://www.R-project.org/.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {R: A Language and Environment for Statistical Computing},
##     author = {{R Core Team}},
##     organization = {R Foundation for Statistical Computing},
##     address = {Vienna, Austria},
##     year = {2022},
##     url = {https://www.R-project.org/},
##   }
## 
## We have invested a lot of time and effort in creating R, please cite it
## when using it for data analysis. See also 'citation("pkgname")' for
## citing R packages.
## 
## 
## > lapply(global.libraries, citation)
## [[1]]
## 
## To cite package 'dplyr' in publications use:
## 
##   Wickham H, François R, Henry L, Müller K (2022). _dplyr: A Grammar of
##   Data Manipulation_. https://dplyr.tidyverse.org,
##   https://github.com/tidyverse/dplyr.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {dplyr: A Grammar of Data Manipulation},
##     author = {Hadley Wickham and Romain François and Lionel Henry and Kirill Müller},
##     year = {2022},
##     note = {https://dplyr.tidyverse.org, https://github.com/tidyverse/dplyr},
##   }
## 
## 
## 
## 
## [[2]]
## 
## To cite package 'stringr' in publications use:
## 
##   Wickham H (2019). _stringr: Simple, Consistent Wrappers for Common
##   String Operations_. http://stringr.tidyverse.org,
##   https://github.com/tidyverse/stringr.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {stringr: Simple, Consistent Wrappers for Common String Operations},
##     author = {Hadley Wickham},
##     year = {2019},
##     note = {http://stringr.tidyverse.org, https://github.com/tidyverse/stringr},
##   }
## 
## 
## 
## 
## [[3]]
## 
## To cite package 'devtools' in publications use:
## 
##   Wickham H, Hester J, Chang W, Bryan J (2021). _devtools: Tools to
##   Make Developing R Packages Easier_. https://devtools.r-lib.org/,
##   https://github.com/r-lib/devtools.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {devtools: Tools to Make Developing R Packages Easier},
##     author = {Hadley Wickham and Jim Hester and Winston Chang and Jennifer Bryan},
##     year = {2021},
##     note = {https://devtools.r-lib.org/, https://github.com/r-lib/devtools},
##   }
## 
## 
## 
## 
## [[4]]
## 
## To cite package 'rprojroot' in publications use:
## 
##   Müller K (2022). _rprojroot: Finding Files in Project
##   Subdirectories_. https://rprojroot.r-lib.org/,
##   https://github.com/r-lib/rprojroot.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {rprojroot: Finding Files in Project Subdirectories},
##     author = {Kirill Müller},
##     year = {2022},
##     note = {https://rprojroot.r-lib.org/, https://github.com/r-lib/rprojroot},
##   }
## 
## 
## 
## 
## [[5]]
## 
## To cite package 'tictoc' in publications use:
## 
##   Izrailev S (2021). _tictoc: Functions for Timing R Scripts, as Well
##   as Implementations of Stack and List Structures_. R package version
##   1.0.1, <https://github.com/collectivemedia/tictoc>.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {tictoc: Functions for Timing R Scripts, as Well as Implementations of
## Stack and List Structures},
##     author = {Sergei Izrailev},
##     year = {2021},
##     note = {R package version 1.0.1},
##     url = {https://github.com/collectivemedia/tictoc},
##   }
## 
## ATTENTION: This citation information has been auto-generated from the
## package DESCRIPTION file and may need manual editing, see
## 'help("citation")'.
## 
## 
## 
## 
## [[6]]
## 
## To cite package 'DBI' in publications use:
## 
##   R Special Interest Group on Databases (R-SIG-DB), Wickham H, Müller K
##   (2022). _DBI: R Database Interface_. https://dbi.r-dbi.org,
##   https://github.com/r-dbi/DBI.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {DBI: R Database Interface},
##     author = {{R Special Interest Group on Databases (R-SIG-DB)} and Hadley Wickham and Kirill Müller},
##     year = {2022},
##     note = {https://dbi.r-dbi.org, https://github.com/r-dbi/DBI},
##   }
## 
## 
## 
## 
## [[7]]
## 
## To cite package 'RSQLite' in publications use:
## 
##   Müller K, Wickham H, James DA, Falcon S (2022). _RSQLite: SQLite
##   Interface for R_. https://rsqlite.r-dbi.org,
##   https://github.com/r-dbi/RSQLite.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {RSQLite: SQLite Interface for R},
##     author = {Kirill Müller and Hadley Wickham and David A. James and Seth Falcon},
##     year = {2022},
##     note = {https://rsqlite.r-dbi.org, https://github.com/r-dbi/RSQLite},
##   }
## 
## 
## 
## 
## [[8]]
## 
## To cite package 'tidyr' in publications use:
## 
##   Wickham H, Girlich M (2022). _tidyr: Tidy Messy Data_.
##   https://tidyr.tidyverse.org, https://github.com/tidyverse/tidyr.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {tidyr: Tidy Messy Data},
##     author = {Hadley Wickham and Maximilian Girlich},
##     year = {2022},
##     note = {https://tidyr.tidyverse.org, https://github.com/tidyverse/tidyr},
##   }
```




