
/*Flagging each occurance of product purhcase*/
data project.GR_products;
set project.general_retail;
logit_active_shoe=0;	logit_baby_personal_care=0;	logit_baby_furn_basics=0;	logit_beauty_aids=0;	logit_boys_apparel=0;	logit_cards_books_mag=0;	logit_consumer_electron=0;	logit_electronic_service=0;	logit_food_beverage=0;	logit_furniture=0;	logit_girls_apparel=0;	logit_health_aid_otc=0;	logit_home_decor=0;	logit_home_improvement=0;	logit_home_organization=0;	logit_household_supplies=0;	logit_housewares=0;	logit_intimate_apparel=0;	logit_jewelry_watches=0;	logit_junior_apparel=0;	logit_kitchen_tabletop=0;	logit_lawn_garden=0;	logit_leased_shoe=0;	logit_licensed_sports=0;	logit_linens_domestics=0;	logit_mens_apparel=0;	logit_missy_apparel=0;	logit_nit=0;	logit_non_merchandise=0;	logit_optical=0;	logit_patio_furniture=0;	logit_pet_supplies=0;	logit_pharmacy=0;	logit_plus_apparel=0;	logit_school_office_sup=0;	logit_small_electronics=0;	logit_sports_rec=0;	logit_toys=0;	logit_trim_a_tree=0;	logit_unallocated=0;	logit_womens_accessories=0;
if active_shoe >0 then logit_active_shoe=1;
if baby_personal_care >0 then logit_baby_personal_care=1;
if baby_furn_basics >0 then logit_baby_furn_basics=1;
if beauty_aids >0 then logit_beauty_aids=1;
if boys_apparel >0 then logit_boys_apparel=1;
if cards_books_mag >0 then logit_cards_books_mag=1;
if consumer_electron >0 then logit_consumer_electron=1;
if electronic_service >0 then logit_electronic_service=1;
if food_beverage >0 then logit_food_beverage=1;
if furniture >0 then logit_furniture=1;
if girls_apparel >0 then logit_girls_apparel=1;
if health_aid_otc >0 then logit_health_aid_otc=1;
if home_decor >0 then logit_home_decor=1;
if home_improvement >0 then logit_home_improvement=1;
if home_organization >0 then logit_home_organization=1;
if household_supplies >0 then logit_household_supplies=1;
if housewares >0 then logit_housewares=1;
if intimate_apparel >0 then logit_intimate_apparel=1;
if jewelry_watches >0 then logit_jewelry_watches=1;
if junior_apparel >0 then logit_junior_apparel=1;
if kitchen_tabletop >0 then logit_kitchen_tabletop=1;
if lawn_garden >0 then logit_lawn_garden=1;
if leased_shoe >0 then logit_leased_shoe=1;
if licensed_sports >0 then logit_licensed_sports=1;
if linens_domestics >0 then logit_linens_domestics=1;
if mens_apparel >0 then logit_mens_apparel=1;
if missy_apparel >0 then logit_missy_apparel=1;
if nit >0 then logit_nit=1;
if non_merchandise >0 then logit_non_merchandise=1;
if optical >0 then logit_optical=1;
if patio_furniture >0 then logit_patio_furniture=1;
if pet_supplies >0 then logit_pet_supplies=1;
if pharmacy >0 then logit_pharmacy=1;
if plus_apparel >0 then logit_plus_apparel=1;
if school_office_sup >0 then logit_school_office_sup=1;
if small_electronics >0 then logit_small_electronics=1;
if sports_rec >0 then logit_sports_rec=1;
if toys >0 then logit_toys=1;
if trim_a_tree >0 then logit_trim_a_tree=1;
if unallocated >0 then logit_unallocated=1;
if womens_accessories >0 then logit_womens_accessories=1;
run;

/*subsetting data into individual clusters*/
Data MBA_cluster1;
set project.GR_products;
where segments = 1; run;

Data MBA_cluster2;
set project.GR_products;
where segments = 2; run;
Data MBA_cluster3;
set project.GR_products;
where segments = 3; run;

Data MBA_cluster4;
set project.GR_products;
where segments = 4; run;

/*Executing logistic regression to develop Predective MBA*/

proc logistic descending data =  MBA_cluster2;
model   logit_missy_apparel =
 logit_active_shoe
logit_baby_personal_care
logit_baby_furn_basics
logit_beauty_aids
logit_boys_apparel
logit_consumer_electron
logit_cards_books_mag

logit_electronic_service
logit_food_beverage
logit_furniture
logit_girls_apparel
logit_health_aid_otc
logit_home_decor
logit_home_improvement
logit_home_organization
logit_household_supplies
logit_housewares
logit_intimate_apparel
logit_jewelry_watches
logit_junior_apparel
logit_kitchen_tabletop
logit_lawn_garden
logit_leased_shoe
logit_licensed_sports
logit_linens_domestics
logit_mens_apparel

logit_nit
logit_non_merchandise
logit_pharmacy
logit_optical
logit_patio_furniture
logit_pet_supplies
logit_plus_apparel
logit_school_office_sup
logit_small_electronics
logit_sports_rec
logit_toys
logit_trim_a_tree
logit_unallocated
logit_womens_accessories

email_send_num
email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate
distinct_store_visit_num
trans_num
item_num
item_distinct_num
item_amt_sum
net_amt_per_trans
item_per_trans
net_amt_per_item
percent_uniqu_item
loyalty_member_flag
tenure_months
avg_days_btwn_trans
;
run;

proc corr data = mba_cluster2;
var logit_consumer_electron logit_pharmacy logit_active_shoe
logit_baby_personal_care
logit_baby_furn_basics
logit_beauty_aids
logit_boys_apparel
logit_cards_books_mag

logit_electronic_service
logit_food_beverage
logit_furniture
logit_girls_apparel
logit_health_aid_otc
logit_home_decor
logit_home_improvement
logit_home_organization
logit_household_supplies
logit_housewares
logit_intimate_apparel
logit_jewelry_watches
logit_junior_apparel
logit_kitchen_tabletop
logit_lawn_garden
logit_leased_shoe
logit_licensed_sports
logit_linens_domestics
logit_mens_apparel
logit_missy_apparel
logit_nit
logit_non_merchandise
logit_optical
logit_patio_furniture
logit_pet_supplies
logit_plus_apparel
logit_school_office_sup
logit_small_electronics
logit_sports_rec
logit_toys
logit_trim_a_tree
logit_unallocated
logit_womens_accessories; run;
