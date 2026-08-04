****************************************************
* BLOCK 2: Nutrition cleaning + fallback + 100g
****************************************************

*replace Nutrition = lower(Nutrition)

***********************************
* 2A. Structured variable cleaning
***********************************
local rawvars ///
    Energykcalkcalserving ///
    EnergykJkJserving ///
    Fatgserving ///
    SaturatedFatgserving ///
    TransFatgserving ///
    Saltgserving ///
    Sodiummgserving ///
    Fibregserving ///
    Sugarsgserving ///
    Proteingserving ///
    Carbohydratesgserving ///
    Carbohydratesg100gml

foreach v of local rawvars {
    capture confirm variable `v'
    if !_rc {
        capture confirm string variable `v'
        if !_rc {
            replace `v' = lower(trim(`v'))
            replace `v' = subinstr(`v', ",", "", .)
            replace `v' = subinstr(`v', "kcal", "", .)
            replace `v' = subinstr(`v', "kj", "", .)
            replace `v' = subinstr(`v', "mg", "", .)
            replace `v' = subinstr(`v', "g", "", .)
            replace `v' = trim(`v')

            replace `v' = "0" if inlist(`v', "", "nil", "none", "nill", "na", "n/a")
            replace `v' = "0.5" if regexm(`v', "^<")
            destring `v', replace force
        }
    }
}

***********************************
* 2B. Create unified serving-level vars
***********************************
gen energy_kcal_serv = Energykcalkcalserving
gen energy_kj_serv   = EnergykJkJserving
gen total_fat_serv   = Fatgserving
gen sat_fat_serv     = SaturatedFatgserving
gen sodium_mg_serv   = Sodiummgserving
gen salt_g_serv      = Saltgserving
gen fiber_g_serv     = Fibregserving
gen total_sugar_serv = Sugarsgserving
gen protein_g_serv   = Proteingserving
gen carb_g_serv      = Carbohydratesgserving

***********************************
* 2C. Fill from Nutrition text
***********************************

* Energy
replace energy_kcal_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(energy_kcal_serv) & ///
    regexm(Nutrition, "[Cc]alories?[^0-9<]*([0-9.]+)[ ]*k?cal?")

replace energy_kcal_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(energy_kcal_serv) & ///
    regexm(Nutrition, "[Ee]nergy[^0-9<]*([0-9.]+)[ ]*k?cal")

replace energy_kj_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(energy_kj_serv) & ///
    regexm(Nutrition, "[Ee]nergy[^0-9<]*([0-9.]+)[ ]*kj")

replace energy_kj_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(energy_kj_serv) & ///
    regexm(Nutrition, "[Ee]nergy[^0-9<]*([0-9.]+)[ ]*kj[^0-9]*([0-9.]+)[ ]*k?cal")

replace energy_kcal_serv = real(subinstr(regexs(2), ",", "", .)) ///
    if missing(energy_kcal_serv) & ///
    regexm(Nutrition, "[Ee]nergy[^0-9<]*([0-9.]+)[ ]*kj[^0-9]*([0-9.]+)[ ]*k?cal")

replace energy_kj_serv = energy_kcal_serv * 4.184 ///
    if missing(energy_kj_serv) & !missing(energy_kcal_serv)

* Total fat
replace total_fat_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(total_fat_serv) & ///
    regexm(Nutrition, "[Tt]otal[ ]?[Ff]at[^0-9<]*([0-9.]+)[ ]*g")

replace total_fat_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(total_fat_serv) & ///
    regexm(Nutrition, "[Tt]otal[ ]?[Ff]at[^0-9<]*<\s*([0-9.]+)[ ]*g")

* Saturated fat
replace sat_fat_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(sat_fat_serv) & ///
    regexm(Nutrition, "[Ss]aturated[ ]?[Ff]at[^0-9<]*([0-9.]+)[ ]*g")

replace sat_fat_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(sat_fat_serv) & ///
    regexm(Nutrition, "[Ss]aturated[ ]?[Ff]at[^0-9<]*<\s*([0-9.]+)[ ]*g")

* Sugar
replace total_sugar_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(total_sugar_serv) & ///
    regexm(Nutrition, "[Tt]otal[ ]?[Ss]ugars?[^0-9<]*([0-9.]+)[ ]*g")

replace total_sugar_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(total_sugar_serv) & ///
    regexm(Nutrition, "[Tt]otal[ ]?[Ss]ugars?[^0-9<]*<\s*([0-9.]+)[ ]*g")

replace total_sugar_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(total_sugar_serv) & ///
    regexm(Nutrition, "[Ss]ugars?[^0-9<]*([0-9.]+)[ ]*g")

replace total_sugar_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(total_sugar_serv) & ///
    regexm(Nutrition, "[Ss]ugars?[^0-9<]*<\s*([0-9.]+)[ ]*g")

* Sodium
replace sodium_mg_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(sodium_mg_serv) & ///
    regexm(Nutrition, "[Ss]odium[^0-9<]*([0-9.]+)[ ]*mg")

replace sodium_mg_serv = real(subinstr(regexs(1), ",", "", .)) * 1000 ///
    if missing(sodium_mg_serv) & ///
    regexm(Nutrition, "[Ss]odium[^0-9<]*([0-9.]+)[ ]*g")

* Salt
replace salt_g_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(salt_g_serv) & ///
    regexm(Nutrition, "[Ss]alt[^0-9<]*([0-9.]+)[ ]*g")

* Fiber
replace fiber_g_serv = real(subinstr(regexs(3), ",", "", .)) ///
    if missing(fiber_g_serv) & ///
    regexm(Nutrition, "(dietary[ ]+)?[Ff]ib(er|re)[^0-9<]*([0-9.]+)[ ]*g")

replace fiber_g_serv = real(subinstr(regexs(3), ",", "", .)) ///
    if missing(fiber_g_serv) & ///
    regexm(Nutrition, "(dietary[ ]+)?[Ff]ib(er|re)[^0-9<]*<\s*([0-9.]+)[ ]*g")

* Protein
replace protein_g_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(protein_g_serv) & ///
    regexm(Nutrition, "[Pp]rotein[^0-9<]*([0-9.]+)[ ]*g")

replace protein_g_serv = real(subinstr(regexs(1), ",", "", .)) ///
    if missing(protein_g_serv) & ///
    regexm(Nutrition, "[Pp]rotein[^0-9<]*<\s*([0-9.]+)[ ]*g")

replace protein_g_serv = 0 if missing(protein_g_serv) & strpos(Nutrition, "protein nil") > 0
replace protein_g_serv = 1 if missing(protein_g_serv) & strpos(Nutrition, "ptotein 1g") > 0

***********************************
* 2D. Additional fallback rules
*	-nothing changed
***********************************
replace sat_fat_serv = 0 if missing(sat_fat_serv) & total_fat_serv==0
replace total_sugar_serv = 0 if missing(total_sugar_serv) & strpos(lower(Minus),"sugar free")
replace total_sugar_serv = 0 if missing(total_sugar_serv) & carb_g_serv==0
replace sodium_mg_serv = salt_g_serv*1000/2.5 if missing(sodium_mg_serv)
replace fiber_g_serv = 0 if missing(fiber_g_serv) & carb_g_serv==0

***********************************
* 2E. Standardize to 100g base
***********************************
misstable summarize energy_kj_serv sat_fat_serv total_sugar_serv ///
    sodium_mg_serv fiber_g_serv protein_g_serv // check if missing values


drop if missing(energy_kj_serv, sat_fat_serv, total_sugar_serv, ///
                 sodium_mg_serv, fiber_g_serv, protein_g_serv)

 /*
count if missing(energy_kj_serv, sat_fat_serv, total_sugar_serv, ///
                 sodium_mg_serv, fiber_g_serv, protein_g_serv)


if r(N) > 0 {
    di as error "ERROR: Missing nutrient values detected. Check data before continuing."
    exit 1
}
*/
gen Energy_KJper100g     = energy_kj_serv/serving_size_g*100
gen sat_fat_gper100g     = sat_fat_serv/serving_size_g*100
gen total_sugar_gper100g = total_sugar_serv/serving_size_g*100
gen sodium_mgper100g     = sodium_mg_serv/serving_size_g*100
gen fiber_gper100g       = fiber_g_serv/serving_size_g*100
gen protein_gper100g     = protein_g_serv/serving_size_g*100