gs_det <- read_csv("~/Desktop/TRUE FINAL EVENNESS PROJECT/CSVs/Length Adjusted CSVs/Final_Green_Sturgeon.csv", 
                   col_types = cols(DetectDate = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

ws_det <- read_csv("~/Desktop/TRUE FINAL EVENNESS PROJECT/CSVs/Length Adjusted CSVs/Final_White_Sturgeon.csv", 
                   col_types = cols(DetectDate = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

pike_det <- read_csv("~/Desktop/TRUE FINAL EVENNESS PROJECT/CSVs/Length Adjusted CSVs/Final_Pikeminnow.csv", 
                     col_types = cols(DetectDate = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

sth_det <- read_csv("~/Desktop/TRUE FINAL EVENNESS PROJECT/CSVs/Length Adjusted CSVs/Final_Steelhead.csv", 
                    col_types = cols(DetectDate = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

sb_det <- read_csv("~/Desktop/TRUE FINAL EVENNESS PROJECT/CSVs/Length Adjusted CSVs/Final_Striped_Bass.csv", 
                   col_types = cols(DetectDate = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

# Write a function that calculates 1) total number of tagged individuals, 
# 2) # of years the species has been tracked, and 
# 3) # Total number of detections of that species

all_detections <- c(gs_det, ws_det, pike_det, sth_det, sb_det)

#ind_tag <- ind_tag[order(ind_tag$DetectDate), ]

calculate_table_one <- function(df_det, species_name) {
 table_det <- df_det
 table_det <- table_det[order(table_det$DetectDate), ]
 print(species_name)
 #Number of Detections
 print(nrow(table_det))
 #Number of Tagged Individuals
 print(length(unique(table_det$TagID)))
 #Length of Time
 time <- as.integer(difftime(table_det$DetectDate[nrow(table_det)], table_det$DetectDate[1]))
 print(time/365)
}

calculate_table_one(gs_det, "Green_Sturgeon")
calculate_table_one(ws_det, "White Sturgeon")
calculate_table_one(pike_det, "Sacramento Pikeminnow")
calculate_table_one(sb_det, "Striped Bass")
calculate_table_one(sth_det, "Steelhead")


