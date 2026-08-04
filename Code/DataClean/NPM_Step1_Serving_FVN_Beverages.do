****************************************************
* BLOCK 1A: Beverage serving size + FVN
****************************************************

replace Nutrition = lower(Nutrition)
replace ServingMeasure = lower(trim(ServingMeasure))

*-------------------------------*
* A. Beverage FVN (juice %)
*-------------------------------*
* 1) Relevant beverage subcategories
gen byte fvn_relevant_bev = inlist(trim(SubCategory), ///
    "Juice", ///
    "Fruit/Flavoured Still Drinks", ///
    "Nutritional & Meal Replacement Drinks", ///
    "Flavoured Water")

gen strL pd_lower = lower(ProductDescription)
gen byte mention_juice = regexm(pd_lower, "juice") if fvn_relevant_bev==1
replace mention_juice = 0 if missing(mention_juice)
*tab SubCategory mention_juice, missing

* 2) Extract juice percentage where available
gen double juice_pct = .

** in product name: 100%
replace juice_pct = real(regexs(1)) if missing(juice_pct) & fvn_relevant_bev==1 & ///
    regexm(Product, "([0-9]+)[ ]*%")
		
* "10% lemon juice" / "10 % lemon juice" / "25% fruit juice"
replace juice_pct = real(regexs(1)) if missing(juice_pct) & fvn_relevant_bev==1 & ///
    regexm(pd_lower, "([0-9]+)[ ]*%[ ]*([a-z]+[ ]+)*juice")

* "10 % juice" / "25% fruit "
replace juice_pct = real(regexs(1)) if missing(juice_pct) & fvn_relevant_bev==1 & ///
    regexm(pd_lower, "([0-9]+)[ ]*%[ ]*([a-z]+[ ]+)*fruit")
	
* 100% juice
replace juice_pct = 100 if missing(juice_pct) & fvn_relevant_bev==1 & ///
    regexm(pd_lower, "100[ ]*%[ ]*([a-z-]+[ ]+)*juice")
	
replace juice_pct =100 if RecordID ==3883189 // blend juice with seperate juice %


* 3) Fallback rule
*    If still missing:
*    - Juice subcategory = 100%
*    - all other relevant beverage subcategories = 0%
replace juice_pct = 100 if missing(juice_pct) & trim(SubCategory)=="Juice"
replace juice_pct = 0   if missing(juice_pct) 
gen FVN = juice_pct
*-------------------------------*
* B. Serving size extraction
*	-use ServingMeasure when available
*	-fill missing serving from Nutrition
*-------------------------------*
drop if inlist(ServingMeasure, ///
    "unit", ///
    "fip/fccfip", ///
    "m (mol/l or molar)") 

* 1. Fill missing ServingSize/Measure from Nutrition text
* Pattern 1: per 240ml / per 12 oz / per 12 fl oz
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "per ([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "per ([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)")

* Pattern 2: serving size 28g / 1-oz / 1 fl oz
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "serving size ([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "serving size ([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)")

* Pattern 3: serving size ... (26g) / (1 oz) / (1 fl oz)
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "serving size [^()]*\(([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)\)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "serving size [^()]*\(([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)\)")

* Pattern 4: serving size (28g/1 oz) or (1 oz/28g) -> keep g value
gen str20 match_g = regexs(1) if regexm(Nutrition, ///
    "serving size .*?\(([0-9.]+)[ ]?g[/)]")
replace ServingSize = real(match_g) if !missing(match_g) & missing(ServingSize)
replace ServingMeasure = "g"        if !missing(match_g) & missing(ServingMeasure)

drop match_g

* Pattern 5: per serving (40g)
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "per serving *\(([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)\)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "per serving *\(([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)\)")

* Pattern 6: per serving 28g / per serving 12-fl oz
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "per serving ([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "per serving ([0-9.]+)[ -]?(g|ml|oz|fl[.]? ?oz)")

* Other patterns	
* (1) serving size: 8-fl oz. / serving size 18 fl.-oz. / serving size 500ml
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "servings?[ ]+size[:]?[ ]*([0-9.]+)[ ]*[-]?[ ]*(g|ml|oz|fl[.]?[ -]?oz)[.]?")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "servings?[ ]+size[:]?[ ]*([0-9.]+)[ ]*[-]?[ ]*(g|ml|oz|fl[.]?[ -]?oz)[.]?")

* (2) 12 fl-oz. serving / 8 fl oz serving / 20-fl.oz. serving size
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "([0-9.]+)[ ]*[-]?[ ]*(g|ml|oz|fl[.]?[ -]?oz)[.]?[ ]+serving")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "([0-9.]+)[ ]*[-]?[ ]*(g|ml|oz|fl[.]?[ -]?oz)[.]?[ ]+serving")

* 2. Standardize ServingMeasure
replace ServingMeasure = "fl oz" if inlist(ServingMeasure, ///
    "fl oz", "fl.-oz", "fl. oz", "fl.oz", "fl. oz (us)", "fl-oz")

* 3. Create serving_size_g
* For beverages: ml ~= g, fl oz -> ml -> g
* Serving sizes reported in ounces and fluid ounces are converted to grams using standard unit conversions (1 oz = 28.35 g; 1 fl oz = 29.57 ml), and for beverages, volume is treated as equivalent to weight (1 ml ≈ 1 g).
* Nutrient values for beverages are expressed per 100 g. Although the NPM guidance recommends conversion from volume using product-specific density factors, we assume a density of 1 g/ml. Given that density adjustments for most beverages are small (generally within 0–7%), this approximation is unlikely to meaningfully affect classification.

drop if missing(ServingSize)

gen serving_size_g = .

replace serving_size_g = ServingSize                if ServingMeasure == "g"
replace serving_size_g = ServingSize * 28.3495     if ServingMeasure == "oz" // 1 oz = 28.35 g
replace serving_size_g = ServingSize * 29.5735     if ServingMeasure == "fl oz" // 1 fl oz = 29.57 ml
replace serving_size_g = ServingSize               if ServingMeasure == "ml" 
drop if missing(serving_size_g)