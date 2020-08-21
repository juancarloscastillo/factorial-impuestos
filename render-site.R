
# Render site ------------------------------------------------------------

###### logic
# there are some limitations for rendering websites in Rmarkdown/Githubpages
# as all files should be in a same directory, which goes against the logic
# of a clean and organized folder structure. Therefore, this script:
# 1. bring all necessary files to the "docs" folder, where the site files are hosted  
# 2. renders the site from this location (docs folder)
# 3. delete the Rmd files that where brought in step 1, leaving only the html files


# INSTRUCTIONS-------------------------:
# 1. set your root dir at "desigualdad_recom"
# 2. Run this code.

production<- list.files(path = "production",pattern = "prod_")# a list with the names of the files to copy
css<- list.files(path = "input/css",pattern = "custom")        # a list with the names of the files to copy

file.copy(file.path("production",production), "docs",overwrite = TRUE)# copy data proc and analysis files
file.copy(file.path("input/css",css), "docs",overwrite = TRUE)       # copy css style files


rmarkdown::render_site("docs",quiet = F) # Render site

# before you run this line, check if your R Markdown files have a .rmd or .Rmd extension
# on this case we use both
ext <- c(grep("^prod_.*\\.rmd$",  x = dir(path = "docs"),value = T), # for .rmd
         grep("^prod_.*\\.Rmd$",  x = dir(path = "docs"),value = T), # for .Rmd
         # grep("_cache",x = dir(path = "docs"),value = T),            # for files within the "_cache" folder
         # grep("^prod_.*\\_cache$",  x = dir(path = "docs"),value = T), # 
         grep("^prod_.*\\.R$",    x = dir(path = "docs"),value = T), # for .R
         ".tex",".log",".RData",".Rhistory")                         # for .tex .log .RData .Rhistory

for (i in 1:length(ext)) {
  file.remove(paste0("docs/",dir(path="docs", pattern=ext[i]))) # delete files from /docs folder
  unlink(paste0("docs/",(ext[i])),recursive = TRUE)             # Remove the cache files (first)
}

for (i in 1:length(ext)) {
  unlink(paste0("docs/",(ext[i])),recursive = TRUE) # Remove the cache folders (second)
}


# [ALTERNATIVE:] delete files from /production folder (in case you previously rendered these files)
prod.files <- c(grep("^prod_.*\\_cache$",x = dir(path = "production"),value = T),
                grep("^prod_.*\\_files$",x = dir(path = "production"),value = T),
                grep("^prod_.*\\.html$" ,x = dir(path = "production"),value = T),
                ".RData",".Rhistory"
)  

for (i in 1:length(prod.files)) {
  file.remove(paste0("production/",dir(path="production", pattern=prod.files[i]))) # delete residual files /production folder
  unlink(paste0("production/",(prod.files[i])),recursive = TRUE)                   # delete files within the "_cache" and "_files" folders
}


# Display the site --------------------------------------------------------

browseURL(url = "docs/index.html")

# Keep only the original .rmd files (site), configuration (_site.yml and _config.yml)
# and prod_ folders (cache and files)
# rmarkdown::clean_site("docs")

