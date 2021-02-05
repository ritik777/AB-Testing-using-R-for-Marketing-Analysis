# AB-Testing-using-R-for-Marketing-Analysis
Project to determine effectiveness of retargeting campaign using AB Testing Approach in R

# I. The Business Problem

Abandoned dataset is the data for all the customers in the dataset that were already pursued (advertised) but ended up not buying a vacation package.
Reservation Dataset is the dataset of customers who purchased after the retargeting campaign

Business Problem: Should we retarget those customers?

In light of the project, why this is a sensible business question?

Marketing is typically made up of 4P's (Price, Promotion, Product, Place). For a business strategy to be viable, this 4p's go hand in hand. 
These 4p's helps to figure out what a customer really wants.
This Projects Aims at one of the p i.e promotion of a holiday tour package. Typically a business unit carry out Research & Development to come up with a plan that profits the company by bolstering the need of the customers. In light of the business, it is important to determine why customers still churned. This real life data comes from team leada( California based startup) who were attempting to solve the similar problem.  
This Project Helps the business to determine the preference of the customers at the same time to ascertain if the retargeting on them would still work but with a different campaign. Losing the customer loyalty is damaging and this project adds value by saving a lot of fortune by finding out if retargeting will help retain the customers, bringing profitability to the business. 

An experiment is run, where customers in the abandoned dataset are randomly placed in a treatment or in a control group (see column L in both files).Those marked as “test” are retargeted (treated), the others marked as control are part of the control group.

# Project Approach
1) Descriptive Statistics Based on States
2) Data Matching to figure out who purchased after retargeting from abandoned dataset and who did not
3) Data Cleaning & Feature Selection
4) Statistical Analysis 
5) Statistical Analysis Based on Response Time

# Statistical Analysis
Selected Features including Customer_id, Test Variable, Outcome, Days in Between(when the new offer was bought), State

The Linear Model  : Outcome = alpha + beta*Test_variable + error

Model Result (can be seen in the document) : Outcome = 0.9815 - 0.05 * Test

Conclusively, The Model Suggests that negative coefficient on Test (Treatment) determines that campaign was not effective on making customers buy again



