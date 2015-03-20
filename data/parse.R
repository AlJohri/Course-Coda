library("dplyr")
library("ggplot2")
library("stringr")

assignVec <- Vectorize("assign",c("x","value"))

remove_percent <- function(x) { return (gsub('%', '', as.character(x))) }

parse_breakdown <- function(dat, var, n = 6) { 
  breakdown <- str_split_fixed(remove_percent(dat[[var]]), ";", n)
  colnames(breakdown) <- paste(var, seq(1:n), sep="_")
  dat <- cbind(dat, breakdown)
  dat[[var]] <- NULL
  return(dat)
}

dat <- read.csv("sections.csv")
dat$feedback <- NULL

dat <- parse_breakdown(dat, var = "instruction_breakdown")
dat <- parse_breakdown(dat, var = "course_breakdown")
dat <- parse_breakdown(dat, var = "learned_breakdown")
dat <- parse_breakdown(dat, var = "challenged_breakdown")
dat <- parse_breakdown(dat, var = "stimulated_breakdown")
dat <- parse_breakdown(dat, var = "school_breakdown", 10)
dat <- parse_breakdown(dat, var = "class_breakdown")
dat <- parse_breakdown(dat, var = "reasons_breakdown")
dat <- parse_breakdown(dat, var = "interest_breakdown")

# time_breakdown has different format

subjects <- read.csv("subjects.csv") %>% rename(subject_id = id, subject = title)
dat <- merge(dat, subjects, by=c("subject_id"), all.x = TRUE)
dat$subject_id <- NULL

titles <- read.csv("titles.csv") %>% rename(title_id = id)
dat <- merge(dat, titles, by=c("title_id"), all.x = TRUE)
dat$title_id <- NULL

professors <- read.csv("professors.csv") %>% rename(professor_id = id, professor = title)
dat <- merge(dat, professors, by=c("professor_id"), all.x = TRUE)
dat$professor_id <- NULL

years <- read.csv("years.csv") %>% rename(year_id = id, year = title)
dat <- merge(dat, years, by=c("year_id"), all.x = TRUE)
dat$year_id <- NULL

quarters <- read.csv("quarters.csv") %>% rename(quarter_id = id, quarter = title)
dat <- merge(dat, quarters, by=c("quarter_id"), all.x = TRUE)
dat$quarter_id <- NULL

write.csv(dat, file="data.csv", row.names=FALSE)