pkgname <- "Bundesliga"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('Bundesliga')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("filter_data")
### * filter_data

flush(stderr()); flush(stdout())

### Name: filter_data
### Title: filter_data
### Aliases: filter_data

### ** Examples

this is not an example



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
