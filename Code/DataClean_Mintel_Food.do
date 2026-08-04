
// 1. Food
*************************************
* A. Select and recategorize
*	- Drop non-comparable items
*************************************
clear
import excel "$Data\GNPD-AllFood_2015_2024.xlsx", sheet("GNPD-AllFood_2015_2024") cellrange(A7:FI162638) firstrow clear // //data downloaded from GNPD

drop if Nutrition == "Not indicated on pack" | Nutrition == ""
gen SuperCategory = "Food"
gen NewCategory = Category
gen NewSubCategory = SubCategory

// 1) Baby Food
tab SubCategory if Category == "Baby Food"
drop if inlist( SubCategory, "Baby Formula (0-6 months)","Baby Formula (6-12 months)","Growing Up Milk (1-4 years)","Growing Up Milk (4+ years)", "Baby Juices & Drinks")
replace NewSubCategory = Category if Category == "Baby Food" 
drop if Category == "Baby Food" // drop since it has different regulations, target population; not comparable 

// 2) Bakery
tab SubCategory if Category == "Bakery"
drop if SubCategory == "Baking Ingredients & Mixes" 

// 3) Breakfast Cereals
* keep as it is
tab SubCategory if Category == "Breakfast Cereals"

// 4) Candy
replace NewCategory = "Candy" if Category == "Chocolate Confectionery" | Category == "Sugar & Gum Confectionery"
replace NewSubCategory = Category if NewCategory == "Candy"

// 5) Condiments
drop if inlist(SubCategory, "Oils", "Stocks", "Seasonings") //  "Sauces & Seasonings"

* Use FormatType to remove concentrated/dry outliers
drop if inlist(FormatType, "Dry", "Powder", "Concentrate", "Dehydrated", "Cube")
drop if inlist(FormatType, "Cubed", "Granules") & Category== "Sauces & Seasonings"
drop if inlist(SubCategory, "Honey", "Syrups")

replace NewCategory = "Condiments" if inlist(Category, ///
    "Sauces & Seasonings", ///
    "Sweet Spreads", ///
    "Savoury Spreads")
replace NewSubCategory = Category if NewCategory == "Condiments"

// 6) Dairy & Eggs
replace NewCategory = "Dairy & Eggs" if Category == "Dairy" | SubCategory == "Eggs & Egg Products"
replace NewSubCategory = "Eggs & Egg Products" if SubCategory == "Eggs & Egg Products"
replace NewSubCategory = "Dairy" if Category == "Dairy"

// 7) Desserts & Ice Cream
replace NewSubCategory = "Desserts & Ice Cream" if Category == "Desserts & Ice Cream" 

// 8) Fruit & Vegetables
*tab NewSubCategory if Category == "Fruit & Vegetables"
replace NewSubCategory = "Fresh Fruit & Vegetables" if Category == "Fruit & Vegetables"

local prod_pat "smoothie|sauce|seasoned|prepared|ready|puffs|fries|refried|roasted|soup|snack|marinated|grilled|dip|kit|cooked|steamed|canned|frozen|dried|dehydrated|puree|purée|juice|syrup|in oil|in water|in tomato juice|flavored|flavour|flavor|salted|sodium|salt|sugar|in brine|chili"
local ing_pat  "oil|salt|sugar|roasted|flavor|flavour|sauce|paste|season|syrup|sodium"

replace NewSubCategory = "Processed Fruit & Vegetables" if ///
    Category == "Fruit & Vegetables" & ///
    regexm(lower(Product), "`prod_pat'")

replace NewSubCategory = "Processed Fruit & Vegetables" if ///
    Category == "Fruit & Vegetables" & ///
    (regexm(lower(Ingredient1), "`ing_pat'") | ///
     regexm(lower(Ingredient2), "`ing_pat'") | ///
     regexm(lower(Ingredient3), "`ing_pat'") | ///
     regexm(lower(Ingredient4), "`ing_pat'") | ///
     regexm(lower(Ingredient5), "`ing_pat'") | ///
     regexm(lower(Ingredient6), "`ing_pat'") | ///
     regexm(lower(Ingredient7), "`ing_pat'") | ///
     regexm(lower(Ingredient8), "`ing_pat'") | ///
     regexm(lower(Ingredient9), "`ing_pat'") | ///
     regexm(lower(RemainingIngredients), "`ing_pat'"))

drop if NewSubCategory == "Fresh Fruit & Vegetables"
replace NewCategory = "Processed Fruit & Vegetables" if NewSubCategory == "Processed Fruit & Vegetables"

// 9) Meals & Side Dishes
drop if SubCategory == "Dry Soup"
replace NewCategory = "Meals & Side Dishes" if inlist(Category, "Meals & Meal Centers", "Side Dishes","Soup")
replace NewSubCategory = Category if NewCategory == "Meals & Side Dishes"

// 10) Processed Meat & Seafood
replace NewCategory = "Processed Meat & Seafood" if inlist(SubCategory, "Meat Products", "Poultry Products", "Fish Products", "Meat Substitutes")

// 11) Snacks
replace NewSubCategory = Category if NewCategory== "Snacks"

**
drop if Category == "Sweeteners & Sugar"

gen Year = year(DatePublished)
gen Month = month(DatePublished)

*tab NewCategory
save "$Data\GNPD-AllFood2015_2024.dta", replace



***************************************
* B. Calculate NPM Scores, and Clean Claims
* References: https://www.gov.uk/government/publications/the-nutrient-profiling-model 
*       		and https://npmcalculator.cdrc.ac.uk/
********************************************************************************************************

use "$Data\GNPD-AllFood2015_2024.dta",clear
  
do "$Code\DataClean\NPM_Step1_Serving_FVN_Food.do" // Clean fvn% and serving size for beverages

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
	 
save "$Data\GNPD-AllFood_Claim_NPMScore_2015_2024.dta",replace 
export excel using "$Data\GNPD-AllFood_Claim_NPMScore_2015_2024.xlsx", sheetreplace firstrow(variables)



