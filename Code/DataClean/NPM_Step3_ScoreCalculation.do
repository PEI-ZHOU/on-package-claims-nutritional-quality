***********************************
* Calculate NPM Score
***********************************
	
* --- Step 1: Calculate A Points (Negative Nutrients)
gen energy_points = .
replace energy_points = 0 if Energy_KJper100g <= 335
replace energy_points = 1 if Energy_KJper100g > 335 & Energy_KJper100g <= 670
replace energy_points = 2 if Energy_KJper100g > 670 & Energy_KJper100g <= 1005
replace energy_points = 3 if Energy_KJper100g > 1005 & Energy_KJper100g <= 1340
replace energy_points = 4 if Energy_KJper100g > 1340 & Energy_KJper100g <= 1675
replace energy_points = 5 if Energy_KJper100g > 1675 & Energy_KJper100g <= 2010
replace energy_points = 6 if Energy_KJper100g > 2010 & Energy_KJper100g <= 2345
replace energy_points = 7 if Energy_KJper100g > 2345 & Energy_KJper100g <= 2680
replace energy_points = 8 if Energy_KJper100g > 2680 & Energy_KJper100g <= 3015
replace energy_points = 9 if Energy_KJper100g > 3015 & Energy_KJper100g <= 3350
replace energy_points = 10 if Energy_KJper100g > 3350 & Energy_KJper100g<.

* Saturated Fat - Negative Points
gen sat_fat_points = .
replace sat_fat_points = 0 if sat_fat_gper100g <= 1
replace sat_fat_points = 1 if sat_fat_gper100g > 1 & sat_fat_gper100g <= 2
replace sat_fat_points = 2 if sat_fat_gper100g > 2 & sat_fat_gper100g <= 3
replace sat_fat_points = 3 if sat_fat_gper100g > 3 & sat_fat_gper100g <= 4
replace sat_fat_points = 4 if sat_fat_gper100g > 4 & sat_fat_gper100g <= 5
replace sat_fat_points = 5 if sat_fat_gper100g > 5 & sat_fat_gper100g <= 6
replace sat_fat_points = 6 if sat_fat_gper100g > 6 & sat_fat_gper100g <= 7
replace sat_fat_points = 7 if sat_fat_gper100g > 7 & sat_fat_gper100g <= 8
replace sat_fat_points = 8 if sat_fat_gper100g > 8 & sat_fat_gper100g <= 9
replace sat_fat_points = 9 if sat_fat_gper100g > 9 & sat_fat_gper100g <= 10
replace sat_fat_points = 10 if sat_fat_gper100g > 10 &  sat_fat_gper100g <.

* Total Sugar - Negative Points
gen total_sugar_points = .
replace total_sugar_points = 0 if total_sugar_gper100g <= 4.5
replace total_sugar_points = 1 if total_sugar_gper100g > 4.5 & total_sugar_gper100g <= 9
replace total_sugar_points = 2 if total_sugar_gper100g > 9 & total_sugar_gper100g <= 13.5
replace total_sugar_points = 3 if total_sugar_gper100g > 13.5 & total_sugar_gper100g <= 18
replace total_sugar_points = 4 if total_sugar_gper100g > 18 & total_sugar_gper100g <= 22.5
replace total_sugar_points = 5 if total_sugar_gper100g > 22.5 & total_sugar_gper100g <= 27
replace total_sugar_points = 6 if total_sugar_gper100g > 27 & total_sugar_gper100g <= 31
replace total_sugar_points = 7 if total_sugar_gper100g > 31 & total_sugar_gper100g <= 36
replace total_sugar_points = 8 if total_sugar_gper100g > 36 & total_sugar_gper100g <= 40
replace total_sugar_points = 9 if total_sugar_gper100g > 40 & total_sugar_gper100g <= 45
replace total_sugar_points = 10 if total_sugar_gper100g > 45 & total_sugar_gper100g<.
 
* Sodium - Negative Points
gen sodium_points = .
replace sodium_points = 0 if sodium_mgper100g <= 90
replace sodium_points = 1 if sodium_mgper100g > 90 & sodium_mgper100g <= 180
replace sodium_points = 2 if sodium_mgper100g > 180 & sodium_mgper100g <= 270
replace sodium_points = 3 if sodium_mgper100g > 270 & sodium_mgper100g <= 360
replace sodium_points = 4 if sodium_mgper100g > 360 & sodium_mgper100g <= 450
replace sodium_points = 5 if sodium_mgper100g > 450 & sodium_mgper100g <= 540
replace sodium_points = 6 if sodium_mgper100g > 540 & sodium_mgper100g <= 630
replace sodium_points = 7 if sodium_mgper100g > 630 & sodium_mgper100g <= 720
replace sodium_points = 8 if sodium_mgper100g > 720 & sodium_mgper100g <= 810
replace sodium_points = 9 if sodium_mgper100g > 810 & sodium_mgper100g <= 900
replace sodium_points = 10 if sodium_mgper100g > 900 & sodium_mgper100g<.

* --- Step 2: Calculate C Points (Positive Nutrients)

* Fruits, Vegetables & Nuts (FVN)
gen fvn_percent =FVN
gen fvn_points = .
replace fvn_points = 0 if fvn_percent <= 40
replace fvn_points = 1 if fvn_percent > 40 & fvn_percent <= 60
replace fvn_points = 2 if fvn_percent > 60 & fvn_percent <= 80
replace fvn_points = 5 if fvn_percent > 80 & fvn_percent <=100

* Fiber (NSP or AOAC method)
gen fiber_points = .
replace fiber_points = 0 if fiber_gper100g <= 0.9
replace fiber_points = 1 if fiber_gper100g > 0.9 & fiber_gper100g <= 1.9
replace fiber_points = 2 if fiber_gper100g > 1.9 & fiber_gper100g <= 2.8
replace fiber_points = 3 if fiber_gper100g > 2.8 & fiber_gper100g <= 3.7
replace fiber_points = 4 if fiber_gper100g > 3.7 & fiber_gper100g <= 4.7
replace fiber_points = 5 if fiber_gper100g > 4.7 & fiber_gper100g <.

* Protein
gen protein_points = .
replace protein_points = 0 if protein_gper100g <= 1.6
replace protein_points = 1 if protein_gper100g > 1.6 & protein_gper100g <= 3.2
replace protein_points = 2 if protein_gper100g > 3.2 & protein_gper100g <= 4.8
replace protein_points = 3 if protein_gper100g > 4.8 & protein_gper100g <= 6.4
replace protein_points = 4 if protein_gper100g > 6.4 & protein_gper100g <= 8.0
replace protein_points = 5 if protein_gper100g > 8.0 & protein_gper100g <.

* --- Step 3: Compute Total NP Score

* Step 3.1: Calculate total A and C points
gen total_a_points = energy_points + sat_fat_points + total_sugar_points + sodium_points
gen total_c_points = fvn_points + fiber_points + protein_points

* Step 3.2: Adjust C points based on A points and FVN score
gen adjusted_c_points = total_c_points

* Rule 1: If A points >= 11 and FVN points < 5, exclude protein from C
replace adjusted_c_points = fvn_points + fiber_points if total_a_points >= 11 & fvn_points < 5

* Rule 2: If A points >= 11 and FVN points >= 5, keep full C points (no change needed)

* Step 3.3: Final NP score
gen np_score = total_a_points - adjusted_c_points 
drop if missing(np_score)

* Step 3.4: Classify product
gen healthfulness = (np_score < 4) if SuperCategory == "Food" // for Food
replace healthfulness = (np_score < 1) if SuperCategory == "Beverages" // for drink
label define healthfulness 0 "less healthy" 1 "healthier"
label value healthfulness healthfulness


* energy_points sat_fat_points total_sugar_points sodium_points fvn_points fiber_points protein_points total_a_points  total_c_points adjusted_c_points

