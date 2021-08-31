library(dplyr)
library(RODBCDBI)
library(tidyr)

source("https://github.com/nz-mbie/mbie-r-package/blob/master/pkg/R/Creds.R")

url <- "http://archive.stats.govt.nz/~/media/Statistics/services/microdata-access/nzis11-cart-surf/nzis11-cart-surf.csv1"
nzis <- read.csv(url)

#-----------------fact tables------------------
# Create a main table with a primary key

f_mainheader <- nzis %>%
  mutate(survey_id = 1:nrow(nzis))

# we need to normalise the multiple ethnicities, currently concatenated into a single variable
cat("max number of ethnicities is", max(nchar(nzis$ethnicity)), "\n")

f_ethnicity <- f_mainheader %>%
  select(ethnicity, survey_id) %>%
  mutate(First = substring(ethnicity, 1, 1),
         Second = substring(ethnicity, 2, 2)) %>%
  select(-ethnicity) %>%
  gather(ethnicity_type, ethnicity_id, -survey_id) %>%
  filter(ethnicity_id != "") 

# drop the original messy ethnicity variable and tidy up names on main header
f_mainheader <- f_mainheader %>%
  select(-ethnicity) %>%
  rename(region_id = lgr,
         sex_id = sex,
         agegrp_id = agegrp,
         qualification_id = qualification,
         occupation_id = occupation)

#-----------------dimension tables------------------
# all drawn from the data dictionary available at the first link given above
d_sex <- tibble(sex_id = 1:2, sex = c("male", "female"))

d_agegrp <- tibble(
  agegrp_id = seq(from = 15, to = 65)) %>%
  mutate(agegrp = ifelse(agegrp_id == 65, "65+", paste0(agegrp_id, "-", agegrp_id + 4)))

d_ethnicity <- tibble(ethnicity_id = c(1,2,3,4,5,6,9),
                          ethnicity = c(
                            "European",
                            "Maori",
                            "Pacific Peoples",
                            "Asian",
                            "Middle Eastern/Latin American/African",
                            "Other Ethnicity",
                            "Residual Categories"))


d_occupation <- tibble(occupation_id = 1:10,
                           occupation = c(
                             "Managers",
                             "Professionals",
                             "Technicians and Trades Workers",
                             "Community and Personal Service Workers",
                             "Clerical and Adminsitrative Workers",
                             "Sales Workers",
                             "Machinery Operators and Drivers",
                             "Labourers",
                             "Residual Categories",
                             "No occupation"                          
                           ))


d_qualification <- tibble(qualification_id = 1:5,
                              qualification = c(
                                "None",
                                "School",
                                "Vocational/Trade",
                                "Bachelor or Higher",
                                "Other"
                              ))

d_region <- tibble(region_id =1:12,
                       region = c("Northland", "Auckland", "Waikato", "Bay of Plenty", "Gisborne / Hawke's Bay",
                                  "Taranaki", "Manawatu-Wanganui", "Wellington", 
                                  "Nelson/Tasman/Marlborough/West Coast", "Canterbury", "Otago", "Southland"))

#---------------save to database---------------
library(DBI)


PlayPen <- dbConnect(RSQLite::SQLite(), "PlayPen.sqlite")
dbWriteTable(PlayPen, "f_mainheader", f_mainheader)
dbWriteTable(PlayPen, "f_ethnicity", f_ethnicity)


dbWriteTable(PlayPen, "d_sex", d_sex, )
dbWriteTable(PlayPen, "d_agegrp", d_agegrp)
dbWriteTable(PlayPen, "d_ethnicity", d_ethnicity)
dbWriteTable(PlayPen, "d_occupation", d_occupation)
dbWriteTable(PlayPen, "d_qualification", d_qualification)
dbWriteTable(PlayPen, "d_region", d_region)

dbListTables(PlayPen)

# fact tables.  These take a long time to load up with sqlSave (which adds one row at a time)
# but it's easier (quick and dirty) than creating a table and doing a bulk upload from a temp 
# file.  Any bigger than this you'd want to bulk upload though - took 20 minutes or more.
sqlSave(PlayPen, f_mainheader, addPK = FALSE, rownames = FALSE)
sqlSave(PlayPen, f_ethnicity, addPK = TRUE, rownames = FALSE) 
# add a primary key on the fly in this case.  All other tables
# have their own already created by R.

# dimension tables
sqlSave(PlayPen, d_sex, addPK = FALSE, rownames = FALSE)
sqlSave(PlayPen, d_agegrp, addPK = FALSE, rownames = FALSE)
sqlSave(PlayPen, d_ethnicity, addPK = FALSE, rownames = FALSE)
sqlSave(PlayPen, d_occupation, addPK = FALSE, rownames = FALSE)
sqlSave(PlayPen, d_qualification, addPK = FALSE, rownames = FALSE)
sqlSave(PlayPen, d_region, addPK = FALSE, rownames = FALSE)

#----------------indexing----------------------

sqlQuery(PlayPen, "ALTER TABLE f_mainheader ADD PRIMARY KEY(survey_id)")

sqlQuery(PlayPen, "ALTER TABLE d_sex ADD PRIMARY KEY(sex_id)")
sqlQuery(PlayPen, "ALTER TABLE d_agegrp ADD PRIMARY KEY(agegrp_id)")
sqlQuery(PlayPen, "ALTER TABLE d_ethnicity ADD PRIMARY KEY(ethnicity_id)")
sqlQuery(PlayPen, "ALTER TABLE d_occupation ADD PRIMARY KEY(occupation_id)")
sqlQuery(PlayPen, "ALTER TABLE d_qualification ADD PRIMARY KEY(qualification_id)")
sqlQuery(PlayPen, "ALTER TABLE d_region ADD PRIMARY KEY(region_id)")

#---------------create an analysis-ready view-------------------
# In Oracle we'd use a materialized view, which MySQL can't do.  But
# the below is fast enough anyway:

sql1 <-
  "CREATE VIEW vw_mainheader AS SELECT sex, agegrp, occupation, qualification, region, hours, income FROM
      f_mainheader a   JOIN
      d_sex b          on a.sex_id = b.sex_id JOIN
      d_agegrp c       on a.agegrp_id = c.agegrp_id JOIN
      d_occupation e   on a.occupation_id = e.occupation_id JOIN
      d_qualification f on a.qualification_id = f.qualification_id JOIN
      d_region g       on a.region_id = g.region_id"

dbGetQuery(PlayPen, "")
