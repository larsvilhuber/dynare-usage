# Download ONET and BLS OES data
# Data is about 50MB - depending on your connection, this might take a while.

source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")),"pathconfig.R"),echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)
source(file.path(programs,"libraries.R"), echo=FALSE)

# exclusions to not consider

exclusions.ext <- c("eps","pdf","doc","docx","ps","csv","dta","tex")
inclusions.ext <- c("mod")

files_db <- dbConnect(RSQLite::SQLite(), kranz.sql)
articles_db <- dbConnect(RSQLite::SQLite(), kranz.sql2)

# ingest the files db
# files only, filter out directories
dbGetQuery(files_db,"SELECt * FROM files WHERE file_type != '' ;") %>%
	filter(!file_type %in% exclusions.ext) %>%
  mutate(present_dynare=file_type %in% inclusions.ext) -> files_dynare
names(files_dynare)
head(files_dynare)
nrow(distinct(files_dynare,id))

head(files_dynare %>% filter(present_dynare))

# get the articles
articles <- dbGetQuery(articles_db,"SELECt id,year,date,journ FROM article;")
# number of articles
nrow(distinct(articles,id))

# merge to article db to get journals
# id|year|date|journ|title|vol|issue|artnum|article_url|

	left_join(articles,files_dynare,
		 by="id") -> analysis_dynare
	
# number of articles in the merged db
nrow(distinct(analysis_dynare,id))
	

analysis_dynare %>%
	group_by(id) %>%
	summarize( present_dynare=max(present_dynare,na.rm = FALSE)) %>%
  mutate(present_dynare = replace_na(present_dynare,0)) %>%
	ungroup() %>%
	 summarize(n=n(),
            dynare_n=sum(present_dynare)) %>%
       mutate(dynare_pct = 100 * dynare_n/n)

# by journal
analysis_dynare %>% 
        group_by(journ,id) %>%
        summarize( present_dynare=max(present_dynare,na.rm = FALSE)) %>%
        mutate(present_dynare = replace_na(present_dynare,0)) %>%
        ungroup() %>%
        group_by(journ) %>%
	summarize(n=n(),
                         dynare_n=sum(present_dynare)) %>%
       mutate(dynare_pct = 100 * dynare_n/n)
