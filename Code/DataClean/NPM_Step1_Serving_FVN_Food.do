****************************************************
* BLOCK 1A: Beverage serving size + FVN
****************************************************

replace Nutrition = lower(Nutrition)
replace ServingMeasure = lower(trim(ServingMeasure))

*-------------------------------*
* A. Food FVN (juice, Veg, Nut %)
*-------------------------------*
gen FVN = 0
replace FVN = 100 if NewCategory == "Processed Fruit & Vegetables" 
*-------------------------------*
* B. Serving size extraction
*	-use ServingMeasure when available
*	-fill missing serving from Nutrition
*-------------------------------*
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

* (3) Additional food patterns: cup / tbsp / tsp / pint / dl / lb / kg / mg
replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "per ([0-9.]+)[ -]?(cup|cup \(us\)|tbsp|tsp|pint \(us\)|dl|dl \(decilitre\)|lb|kg|mg)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "per ([0-9.]+)[ -]?(cup|cup \(us\)|tbsp|tsp|pint \(us\)|dl|dl \(decilitre\)|lb|kg|mg)")

replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "serving size ([0-9.]+)[ -]?(cup|cup \(us\)|tbsp|tsp|pint \(us\)|dl|dl \(decilitre\)|lb|kg|mg)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "serving size ([0-9.]+)[ -]?(cup|cup \(us\)|tbsp|tsp|pint \(us\)|dl|dl \(decilitre\)|lb|kg|mg)")

replace ServingSize = real(regexs(1)) if missing(ServingSize) & ///
    regexm(Nutrition, "per serving ([0-9.]+)[ -]?(cup|cup \(us\)|tbsp|tsp|pint \(us\)|dl|dl \(decilitre\)|lb|kg|mg)")
replace ServingMeasure = lower(regexs(2)) if missing(ServingMeasure) & ///
    regexm(Nutrition, "per serving ([0-9.]+)[ -]?(cup|cup \(us\)|tbsp|tsp|pint \(us\)|dl|dl \(decilitre\)|lb|kg|mg)")

tab ServingMeasure, missing

drop if inlist(ServingMeasure, "%", "kcal", "unit", "orac", "c", "fu", "gallu", "galu")
drop if inlist(ServingMeasure, "orac", "pc (bacterial protease unit)")
drop if inlist(ServingMeasure, ///
    "cup", "cup (us)", "tbsp", "tsp")
* 2. Standardize ServingMeasure
replace ServingMeasure = "fl oz" if inlist(ServingMeasure, ///
    "fl oz", "fl.-oz", "fl. oz", "fl.oz", "fl. oz (us)", "fl-oz", "fl oz")

* 3. Create serving_size_g
* For food: weight-based units are directly converted; volume-based units are approximated using ml ≈ g; 
* Serving sizes reported in ounces and related weight units are converted to grams using standard unit conversions 
* (1 oz = 28.35 g; 1 lb = 453.59 g; 1 kg = 1000 g). 
* For volume-based units (e.g., ml, fl oz), we assume volume is equivalent to weight (1 ml ≈ 1 g), 
* consistent with common practice when product-specific density information is unavailable.
* Nutrient values for foods are expressed per 100 g. Although the NPM guidance recommends conversion using product-specific 
* density factors for certain products, we apply a uniform approximation (1 g/ml) to ensure consistency and transparency 
* across a wide range of food categories. Given that most products are reported in weight units and density variation is 
* generally modest, this approximation is unlikely to materially affect classification.
* Drop observations without serving size
drop if missing(ServingSize)

* Initialize serving size in grams
gen serving_size_g = .

* Convert weight-based units
replace serving_size_g = ServingSize                if ServingMeasure == "g"
replace serving_size_g = ServingSize * 28.3495      if ServingMeasure == "oz"   // 1 oz = 28.35 g
replace serving_size_g = ServingSize * 453.592      if ServingMeasure == "lb"   // 1 lb = 453.59 g
replace serving_size_g = ServingSize * 1000         if ServingMeasure == "kg"   // 1 kg = 1000 g
replace serving_size_g = ServingSize / 1000         if ServingMeasure == "mg"   // 1000 mg = 1 g

* Convert volume-based units (assuming density ≈ 1 g/ml)
replace serving_size_g = ServingSize                if ServingMeasure == "ml" 
replace serving_size_g = ServingSize * 29.5735      if ServingMeasure == "fl oz" // 1 fl oz = 29.57 ml
replace serving_size_g = ServingSize * 473.176      if ServingMeasure == "pint (us)" // 1 pint ≈ 473 ml
replace serving_size_g = ServingSize * 100          if ServingMeasure == "dl (decilitre)" // 1 dl = 100 ml

* Drop observations that cannot be converted
drop if missing(serving_size_g)
* Drop obvious errors only
drop if serving_size_g == 0 // 1 obs dropped
drop if serving_size_g > 1000 // 13 dropped