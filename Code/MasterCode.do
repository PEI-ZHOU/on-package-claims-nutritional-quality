
* 0. Set up path
global Project "Your/Replication/Folder"   // change to your own path
global Data   "$Project/Data"
global Code   "$Project/Code"
global Result "$Project/Result"

* Create folders if they do not exist
capture mkdir "$Project"
capture mkdir "$Data"
capture mkdir "$Code"
capture mkdir "$Result"

display "Project Path: $Project"
display "Data Path: $Data"
display "Code Path: $Code"
display "Result Path: $Result"

* 1. Run code to create Beverages and Food data, with information of NP Score and Claims
* 	- per RecordID
do "$Code\DataClean_Mintel_Drink.do" // beverages

do "$Code\DataClean_Mintel_Food.do" // Food 

* 2. Append Data
use "$Data\GNPD-AllFood_Claim_NPMScore_2015_2024.dta",clear //135,037 obs
append using "$Data\GNPD-AllDrink_Claim_NPMScore_2015_2024.dta" // 10,572 obs
tab NewSubCategory
save "$Data\GNPD-AllFoodDrink_Claim_NPMScore_2015_2024.dta", replace
label values  healthfulness
export excel using "$Data\GNPD-AllFoodDrink_Claim_NPMScore_2015_2024.xlsx", sheetreplace firstrow(variables) // 145,609

* 3. An quick overview of claims data
* Claims prevelence
use "$Data\GNPD-AllFoodDrink_Claim_NPMScore_2015_2024.dta",clear
sum Num_Minus Num_Plus Num_Natural Num_Functional Num_AllHealth
sum Num_Minus Num_Plus Num_Natural Num_Functional Num_AllHealth if Num_AllHealth>0
tab NewCategory if Num_AllHealth>0, sum( Num_AllHealth)
tab NewCategory if Num_AllHealth>0, sum( Num_Minus)
tab NewCategory if Num_AllHealth>0, sum( Num_Plus)
tab NewCategory if Num_AllHealth>0, sum( Num_Natural)
tab NewCategory if Num_AllHealth>0, sum( Num_Functional)

gen haveclaim= (Num_AllHealth>0)
sum haveclaim
tab NewCategory , sum( haveclaim)

   