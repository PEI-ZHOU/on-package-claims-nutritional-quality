
// 2. Drink

*************************************
* A. Select and recategorize
*************************************

clear
import excel "$Data\GNPD-AllDrink_2015_2024.xlsx", sheet("GNPD-AllDrink_2015_2024") cellrange(A7:FI36232) firstrow clear //data downloaded from GNPD

keep if inlist(trim(Category), "Carbonated Soft Drinks", "RTDs", "Sports & Energy Drinks") ///
	| inlist(trim(SubCategory), "Nutritional & Meal Replacement Drinks", "Flavoured Water", "Fruit/Flavoured Still Drinks", "Juice" )
								
drop if Nutrition== "Not indicated on pack" | Nutrition== ""
tab FormatType, missing
keep if FormatType == "Liquid" | missing(FormatType)

gen SuperCategory = "Beverages"
gen NewCategory = "Beverages"
gen NewSubCategory = SubCategory

* 1. Carbonated Soft Drinks
tab SubCategory if Category == "Carbonated Soft Drinks"
* 2. Juice Drinks
tab SubCategory if Category == "Juice Drinks" 

* 3. Nutritional Drinks & Other Beverages
tab SubCategory if Category == "Nutritional Drinks & Other Beverages" // only "Nutritional & Meal Replacement Drinks", DROPPED MIX
replace NewSubCategory = "Nutritional Drinks" if Category == "Nutritional Drinks & Other Beverages"

* 4. RTDs
tab SubCategory if Category == "RTDs" //  RTD (Iced) Coffee and RTD (Iced) Tea
replace NewSubCategory = "RTD Coffee & Tea" if Category == "RTDs" // SubCategory== "RTD (Iced) Tea" |SubCategory== "RTD (Iced) Coffee" 

* 5. Sports & Energy Drinks
tab SubCategory if Category == "Sports & Energy Drinks" // Energy Drinks and Energy Drinks
replace NewSubCategory= "Sports & Energy Drinks" if SubCategory== "Energy Drinks" |SubCategory== "Sports Drinks" 

* 6. Water
tab SubCategory if Category == "Water" // only Flavoured Water; dropped water

tab NewSubCategory

gen Year =year(DatePublished)
gen Month =month(DatePublished)
save "$Data\GNPD-AllDrink_2015_2024.dta",replace

********************************************************************************************************
* B. Calculate NPM Scores, and Clean Claims
* References: https://www.gov.uk/government/publications/the-nutrient-profiling-model 
*       		and https://npmcalculator.cdrc.ac.uk/
********************************************************************************************************

use "$Data\GNPD-AllDrink_2015_2024.dta",clear
  
do "$Code\DataClean\NPM_Step1_Serving_FVN_Beverages.do" // Clean fvn% and serving size for beverages

do "$Code\DataClean\NPM_Step2_NutritionCleaning.do" // Clean Nutrition for NPM component

do "$Code\DataClean\NPM_Step3_ScoreCalculation.do" // calculate NPM Score

do "$Code\DataClean\CleanClaims.do" // get claim variables
	
compress	

keep RecordID SuperCategory Category SubCategory NewCategory NewSubCategory Year Month DatePublished ///
	 serving_size_g Energy_KJper100g sat_fat_gper100g total_sugar_gper100g sodium_mgper100g fiber_gper100g protein_gper100g FVN  ///
	 np_score *points* healthfulness  ///
	 Num_Minus Num_Plus Num_Natural Num_Functional Num_AllHealth /// Number of claims per product
	 LessCalorie NoAddedSugar SugarFree LowSugar Diet LessSodium LessCarb LessFat LessTransFat LessSatFat LessChol LessGlycemic /// Minus: 12
	 PlusVitamin HighProtein AddedCalcium HighFiber  /// Plus: 4
	 AllNatural NoArtAdditives NoArtColourings NoArtFlavourings NoArtPreservatives NoAdditivesPreservatives GMOFree Organic Wholegrain /// Natural: 9
	 BrainNervSystem ImmuneSystem Digestive Probiotic Antioxidant WgtMuscle Cardiovascular BoneSkinHairEyeHealth  // Functional: 8

order RecordID SuperCategory Category SubCategory NewCategory NewSubCategory Year Month DatePublished ///
	serving_size_g Energy_KJper100g sat_fat_gper100g total_sugar_gper100g sodium_mgper100g fiber_gper100g protein_gper100g FVN  ///
	np_score *points* healthfulness  ///
	 Num_Minus Num_Plus Num_Natural Num_Functional Num_AllHealth /// Number of claims per product
	 LessCalorie NoAddedSugar SugarFree LowSugar Diet LessSodium LessCarb LessFat LessTransFat LessSatFat LessChol LessGlycemic /// Minus: 12
	 PlusVitamin HighProtein AddedCalcium HighFiber  /// Plus: 4
	 AllNatural NoArtAdditives NoArtColourings NoArtFlavourings NoArtPreservatives NoAdditivesPreservatives GMOFree Organic Wholegrain /// Natural: 9
	 BrainNervSystem ImmuneSystem Digestive Probiotic Antioxidant WgtMuscle Cardiovascular BoneSkinHairEyeHealth  // Functional: 8
	 
save "$Data\GNPD-AllDrink_Claim_NPMScore_2015_2024.dta",replace 
export excel using "$Data\GNPD-AllDrink_Claim_NPMScore_2015_2024.xlsx", sheetreplace firstrow(variables)



