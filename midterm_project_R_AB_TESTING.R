# RETRIEVE THE ORIGINAL DATA FILES
library(readxl)
abd <- read.csv(file.choose())
res <- read.csv(file.choose())
#MATCHING THEM BY EMAIL
# removing missing email data from both tables
# I created 2 variables abd_nonull_email and res_nonull_email which contains data from original dataset excluding missing data
abd_nonull_email <- abd[-which(abd$Email == ""), ]
res_nonull_email <- res[-which(res$Email == ""), ]
#merging abd and res no null data by email
# I merged abd_nonull with res_nonull on matching emails to find matching data items. Got output as inner_email
mergeColsEmail <- c("Email")
inner_email <- merge(abd_nonull_email, res_nonull_email, by = mergeColsEmail)
#Creating a dataframe that only contains Email and Session.y from inner_email
#from Inner_email I created a dataframe that only contains email and session.y information. So after matching email I could get session.y information as well on the matched abandoned data set.
e= data.frame(inner_email$Email,inner_email$Session.y)
#Changing column names to Email and Session.y
#changed column names so that i could match e with abd_no_null with Email.
colnames(e)[colnames(e)=="inner_email.Email"] <- "Email"
colnames(e)[colnames(e)=="inner_email.Session.y"] <- "Session.y"
#Merging the e dataset(EMAIL And Session.y) and abandoned no null data
# final_df_1 contains data on email matching
final_df_1 = merge(e, abd_nonull_email, by = mergeColsEmail)
#Eliminating duplicate values.
final_df_1=distinct(final_df_1)
# Found 90 Observations after removing duplicates


# MATCH BY INCOMING_PHONE
# removing missing email data from both tables
# I created 2 variables abd_nonull_incoming and res_nonull_incoming which contains data from original dataset excluding missing data

abd_nonull_incoming <- abd[-which(abd$Incoming_Phone == ""), ]
res_nonull_incoming <- res[-which(res$Incoming_Phone == ""), ]
#merging abd and res no null data by incoming phone
# I merged abd_nonull with res_nonull on matching Incoming_Phone to find matching data items. Got output as inner_phone

mergeColsIncoming <- c("Incoming_Phone")
inner_phone <- merge(abd_nonull_incoming, res_nonull_incoming, by = mergeColsIncoming)
#Creating a dataframe that only contains Incoming_phone and Session.y from inner_phone
#from Inner_phone I created a dataframe that only contains email and session.y information. So after matching Incoming_Phone I could get session.y information as well on the matched abandoned data set.

p= data.frame(inner_phone$Incoming_Phone,inner_phone$Session.y)
#Changing column names to Incoming_Phone and Session.y
#changed column names so that i could match p with abd_no_null with Incoming_Phone.

colnames(p)[colnames(p)=="inner_phone.Incoming_Phone"] <- "Incoming_Phone"
colnames(p)[colnames(p)=="inner_phone.Session.y"] <- "Session.y"
#Merging the p dataset(Incoming_Phone And Session.y) and abandoned no null data
# final_df_2 contains data on Incoming_Phone matching.i.e those customers mathced on incoming_phone who purchased on retargeting

final_df_2 = unique(merge(p, abd_nonull_incoming, by = mergeColsIncoming))
#Found 368 observations by matching on incoming_phone

# MATCH BY CONTACT_PHONE
#Followed the same Procedure as for matching email and incoming_phone
abd_nonull_contact <- abd[-which(abd$Contact_Phone == ""), ]
res_nonull_contact <- res[-which(res$Contact_Phone == ""), ]
mergeColsContact <- c("Contact_Phone")
inner_contact <- merge(abd_nonull_contact, res_nonull_contact, by = mergeColsContact)
c= data.frame(inner_contact$Contact_Phone,inner_contact$Session.y)

colnames(c)[colnames(c)=="inner_contact.Contact_Phone"] <- "Contact_Phone"
colnames(c)[colnames(c)=="inner_contact.Session.y"] <- "Session.y"
final_df_3 = merge(c, abd_nonull_contact, by = mergeColsContact)
final_df_3=distinct(final_df_3)
#Found 232 observation matched on contact_phone


# Generating data to analyse
#the final variable contains all the data from email, contact_phone and incoming phone matching. It contains information of all matching reservation and abandoned data of the users who purchased after retargeting
final = rbind(final_df_1,final_df_2,final_df_3)
#we get 690 observations and a lot of matching attributes are duplicated like email, incoming_phone and contact_phone and we need to seperate key duplicated data. 
#Used duplicated function to remove duplicates that contain same email,phone and contact_phone as this are our problematic cases and we would then have trouble finding predictions so it is better to remove them from analysis.
duplicates = duplicated(final[,c("Email","Incoming_Phone", "Contact_Phone")])
final =final[!duplicates,] 
# finally merging the data with abd to find list of customers who purchased after retargeting and who did not.
data= merge(abd,final,all.x = TRUE)
#408 observations are recorded.
#Creating Outcome column depicting if person has purchased or not.
#Binary Outcome variable is created. Is.na(data$Session.y) denotes if there is null, Outcome would be TRUE or if there is no null there is some value, the Outcome would be FALSE. 

Outcome = is.na(data$Session.y)
#if Outcome is true we label is as No Buy. If Outcome is False we label it as  Buy
Outcome[Outcome == TRUE] <- "No Buy" 
Outcome[Outcome == FALSE] <- "Buy"
data = cbind(data, Outcome)







data$Session = as.POSIXlt(as.character(data$Session), tz="GMT",format="%Y.%m.%d %H:%M:%S")
data$Session.y = as.POSIXlt(as.character(data$Session.y), tz="GMT",format="%Y.%m.%d %H:%M:%S")
data$Difference <- round(data$Session.y - data$Session, digits = 0)

#Created new data frame reg_data which contains all the important data for analysis also includes if Days_In_Between is null then value is 200

reg_data = data.frame(Customer_ID = data$Caller_ID, Test_Variable = data$Test_Control, Outcome = data$Outcome, Days_in_Between = data$Difference, State = data$Address, Email = data$Email)
reg_data$Days_in_Between[is.na(reg_data$Days_in_Between)] = 200
reg_data$Days_in_Between=as.numeric(reg_data$Days_in_Between)

#Produced to excel file
library("xlsx")

write.xlsx(x = reg_data, file = "midterm_data_analysis.xlsx",
           sheetName = "Customer_Data", row.names = FALSE)

reg_data$Outcome = as.numeric(as.factor(reg_data$Outcome)) -1

 reg.out=lm(Outcome~Test_Variable,data=reg_data)
 summary(reg.out)
 
 has_state = as.numeric(as.factor(reg_data$State)) -1
has_state[has_state!=0]<-1 

has_email = as.numeric(as.factor(reg_data$Email)) -1
has_email[has_email!=0]<-1 
reg_data$has_state = has_state
reg_data$has_email = has_email
#Email and dummy state
reg.out=lm(Outcome~Test_Variable +has_state,data=reg_data)
summary(reg.out)
# 
reg.out2=lm(Outcome~Test_Variable +has_email,data=reg_data)
summary(reg.out2)

reg.out3=lm(Outcome~Test_Variable +has_email+has_state,data=reg_data)
summary(reg.out3)

reg.out4=lm(Outcome~Test_Variable +has_email*Test_Variable,data=reg_data)
summary(reg.out4)

response_time = reg_data[-which(reg_data$Days_in_Between==200),]

reg_response=lm(Days_in_Between~Test_Variable,data=response_time)
summary(reg_response)

reg_response1=lm(Days_in_Between ~ has_email+Test_Variable,data=response_time)
summary(reg_response1)

reg_response2=lm(Days_in_Between ~ has_state*Test_Variable,data=response_time)
summary(reg_response2)
