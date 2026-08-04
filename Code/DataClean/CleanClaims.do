// 1. Minus: Nutrient Reduction Claims
/*
Minus
- Diet/Light
- Low/No/Reduced Calorie
- Low/No/Reduced Carb
- Low/No/Reduced Cholesterol
- Low/No/Reduced Fat
- Low/No/Reduced Glycemic
- Low/No/Reduced Saturated Fat
- Low/No/Reduced Sodium
- Low/No/Reduced Transfat
- Low/Reduced Sugar
- No Added Sugar
- Sugar Free
*/

gen LessCalorie= 0
replace LessCalorie = 1 if strpos(Minus, "Low/No/Reduced Calorie") > 0

gen NoAddedSugar= 0
replace NoAddedSugar = 1 if strpos(Minus, "No Added Sugar") > 0 

gen SugarFree= 0
replace SugarFree = 1 if strpos(Minus, "Sugar Free") > 0

gen LowSugar= 0
replace LowSugar = 1 if strpos(Minus, "Low/Reduced Sugar") > 0

gen Diet= 0
replace Diet = 1 if strpos(Minus, "Diet/Light") > 0

gen LessSodium= 0
replace LessSodium = 1 if strpos(Minus, "Low/No/Reduced Sodium") > 0

gen LessCarb= 0
replace LessCarb = 1 if strpos(Minus, "Low/No/Reduced Carb") > 0

gen LessFat= 0
replace LessFat = 1 if strpos(Minus, "Low/No/Reduced Fat") > 0

gen LessTransFat =0
replace LessTransFat = 1 if strpos(Minus, "Low/No/Reduced Transfat") > 0

gen LessSatFat =0
replace LessSatFat = 1 if strpos(Minus, "Low/No/Reduced Saturated Fat") > 0

gen LessChol= 0
replace LessChol = 1 if strpos(Minus, "Low/No/Reduced Cholesterol") > 0

gen LessGlycemic =0 
replace LessGlycemic=1 if strpos(Minus, "Low/No/Reduced Glycemic") > 0

// gen another variable 
gen LessSugar= 0
replace LessSugar = 1 if strpos(Minus, "Low/Reduced Sugar") > 0 |strpos(Minus, "Sugar Free") > 0

// 2. Plus: Nutrient Enhancement Claims
/*
Plus
- Added Calcium
- High/Added Fibre
- High/Added Protein
- Vitamin/Mineral Fortified
*/

gen PlusVitamin= 0
replace PlusVitamin = 1 if strpos(Plus, "Vitamin/Mineral Fortified") > 0 

gen HighProtein= 0
replace HighProtein = 1 if strpos(Plus, "High/Added Protein") > 0 

gen AddedCalcium= 0
replace AddedCalcium = 1 if strpos(Plus, "Added Calcium") > 0 

gen HighFiber= 0
replace HighFiber = 1 if strpos(Plus, "High/Added Fibre") > 0 

// 3. Natural Claims
/*
Natural
- All Natural Product
- Free from Added/Artificial Additives
- Free from Added/Artificial Colourings
- Free from Added/Artificial Flavourings
- Free from Added/Artificial Preservatives
- GMO Free
- No Additives/Preservatives
- Organic
- Wholegrain

*/
gen  AllNatural= 0
replace AllNatural = 1 if strpos(Natural, "All Natural Product") > 0 

gen  NoArtAdditives= 0
replace NoArtAdditives = 1 if strpos(Natural, "Free from Added/Artificial Additives") > 0 

gen  NoArtColourings= 0
replace NoArtColourings = 1 if strpos(Natural, "Free from Added/Artificial Colourings") > 0 

gen  NoArtFlavourings= 0
replace NoArtFlavourings = 1 if strpos(Natural, "Free from Added/Artificial Flavourings") > 0 

gen  NoArtPreservatives= 0
replace NoArtPreservatives = 1 if strpos(Natural, "Free from Added/Artificial Preservatives") > 0 

gen  NoAdditivesPreservatives= 0
replace NoAdditivesPreservatives = 1 if strpos(Natural, "No Additives/Preservatives") > 0 

gen  GMOFree= 0
replace GMOFree = 1 if strpos(Natural, "GMO Free") > 0 

gen  Organic= 0
replace Organic = 1 if strpos(Natural, "Organic") > 0 

gen  Wholegrain= 0
replace Wholegrain = 1 if strpos(Natural, "Wholegrain") > 0 

**
gen  NoArtificials= 0
replace NoArtificials = 1 if strpos(Natural, "Free from Added/Artificial Additives") > 0 |strpos(Natural, "Free from Added/Artificial Colourings") > 0 | strpos(Natural, "Free from Added/Artificial Flavourings") > 0 | strpos(Natural, "Free from Added/Artificial Preservatives") > 0 


* 4. Functional for health: Functional Claims
/*
Functional
- Anti-Bacterial  // not function for health
- Antioxidant
- Breath-Freshening // not function for health
- Functional - Beauty Benefits  // not function for health
- Functional - Bone Health
- Functional - Brain & Nervous System
- Functional - Cardiovascular
- Functional - Digestive
- Functional - Energy // not function for health
- Functional - Eye Health
- Functional - Immune System
- Functional - Other // not function for health
- Functional - Skin, Nails & Hair
- Functional - Slimming // not function for health
- Functional - Stress & Sleep // not function for health
- Functional - Weight & Muscle Gain
- High Satiety
- Homeopathic // not function for health
- Prebiotic
- Probiotic
*/

gen BrainNervSystem= 0
replace BrainNervSystem = 1 if strpos(Functional, "Brain & Nervous System") > 0 

gen ImmuneSystem= 0
replace ImmuneSystem = 1 if strpos(Functional, "Immune System") > 0 

gen Digestive = 0
replace Digestive = 1 if strpos(Functional, "Digestive") > 0 

gen Probiotic = 0
replace Probiotic = 1 if strpos(Functional, "Probiotic") > 0 |strpos(Functional, "Prebiotic") > 0 

gen Antioxidant= 0
replace Antioxidant = 1 if strpos(Functional, "Antioxidant") > 0 

gen WgtMuscle= 0
replace WgtMuscle = 1 if strpos(Functional, "Weight & Muscle Gain") > 0 

gen Cardiovascular= 0
replace Cardiovascular = 1 if strpos(Functional, "Cardiovascular") > 0 

gen BoneSkinHairEyeHealth = 0
replace BoneSkinHairEyeHealth = 1 if strpos(Functional, "Bone Health") > 0 |strpos(Functional, "Skin, Nails & Hair") > 0 |strpos(Functional, "Eye Health") > 0

***
gen BoneHealth = 0
replace BoneHealth = 1 if strpos(Functional, "Bone Health") > 0

gen EyeHealth = 0
replace EyeHealth = 1 if strpos(Functional, "Eye Health") > 0

gen SkinNailsHairHealth = 0
replace SkinNailsHairHealth = 1 if strpos(Functional, "Skin, Nails & Hair") > 0

gen Prebiotic2 = 0
replace Prebiotic2 = 1 if strpos(Functional, "Prebiotic") > 0

gen Probiotic2 = 0
replace Probiotic2 = 1 if strpos(Functional, "Probiotic") > 0


// Get number of coded claims
egen Num_Minus= rowtotal(LessCalorie NoAddedSugar SugarFree LowSugar Diet LessSodium LessCarb LessFat LessTransFat LessSatFat LessChol LessGlycemic) // minus
egen Num_Plus= rowtotal(PlusVitamin HighProtein AddedCalcium HighFiber) // Plus
egen Num_Natural = rowtotal(AllNatural NoArtAdditives NoArtColourings NoArtFlavourings NoArtPreservatives NoAdditivesPreservatives GMOFree Organic Wholegrain) // Natural
egen Num_Functional = rowtotal(BrainNervSystem ImmuneSystem Digestive Probiotic Antioxidant WgtMuscle Cardiovascular BoneSkinHairEyeHealth)  // Functional

egen Num_AllHealth= rowtotal(Num_Minus Num_Plus Num_Natural Num_Functional) // total number of coded claim indicators across Minus, Plus, Natural, and Functional claim groups