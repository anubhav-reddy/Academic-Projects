
LIBNAME Project 'E:\Study\Predictive Analytics - SAS\SAS\Project'; RUN;
run;

/*converting SAS file Excel File*/
proc export 
  data=utd.general_retail
  dbms=xlsx 
  outfile="E:\Study\Predictive Analytics - SAS\SAS\general_retail.xlsx" 
  replace;
run;

/*Importing file into SAS*/

PROC IMPORT DATAFILE= "E:\Study\Predictive Analytics - SAS\SAS\Project\general_retail.xlsx" DBMS=xlsx OUT= project.general_retail REPLACE;
  SHEET="general_retail"; 
  GETNAMES=YES;
  *MIXED=NO;
RUN;

/*Sorting data by segments*/
proc sort data = project.general_retail_jorge;
by kmeans_4_;run;
 
/*looking at descriptive stats to undrstand the clusters/segments*/
proc means data = project.general_retail;
class segment;run;


proc means data = project.general_retail_jorge;
class kmeans_4_; run;



proc sort data=project.general_retail;
by customer_id;
run;
*Influential Observations;

/*Developing a REG model to indentify relation ship of UNITS withs other variables*/

*Cluster 1;
Data GR_cluster1;
set project.general_retail;
where segments = 1; run;

/*Regression Model for cluster 1*/
proc reg data = GR_cluster1;
model item_num = email_send_num
email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate
distinct_store_visit_num
trans_num
item_distinct_num
item_amt_sum
net_amt_per_trans
item_per_trans
net_amt_per_item
percent_uniqu_item
loyalty_member_flag
tenure_months
avg_days_btwn_trans;
output out = resid p = PUNITS r = RUNITS student = student;
run;quit;

/*Deleting influencial observations*/
data GR_Cluster1_1;
set resid;
pos =0; neg = 0;
if student > 3.0 then delete;
if student < -3.0 then delete;
run;


* Collinearity Diagnostics /Correction(s);
proc corr data = GR_Cluster1; 
var item_num email_send_num
email_open_rate
email_click_rate
/*email_forward_rate*/
email_unsub_rate
email_engage_rate
distinct_store_visit_num
trans_num
item_distinct_num
item_amt_sum
net_amt_per_trans
item_per_trans
net_amt_per_item
percent_uniqu_item
/*loyalty_member_flag*/
tenure_months
avg_days_btwn_trans; run;


proc reg data = GR_cluster1_1;
model item_per_trans = email_send_num
/*email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate*/
net_amt_per_item
/VIF COLLIN;
output out = resid p = PUNITS r = RUNITS student = student;
run;quit;

proc means data = gr_cluster1_1;
var item_per_trans net_amt_per_item;
run;

*Cluster 2;
Data GR_cluster2;
set project.general_retail_jorge;
where kmeans_4_ = 2; run;

/*Regression Model for cluster 2*/
proc reg data = GR_cluster2;
model item_num = email_send_num
email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate
distinct_store_visit_num
trans_num
item_distinct_num
item_amt_sum
net_amt_per_trans
item_per_trans
net_amt_per_item
percent_uniqu_item
loyalty_member_flag
tenure_months
avg_days_btwn_trans;
output out = resid2 p = PUNITS r = RUNITS student = student;
run;quit;


/*Deleting influencial observations*/
data GR_Cluster2_1;
set resid2;
pos =0; neg = 0;
if student > 3.0 then delete;
if student < -3.0 then delete;
run;


proc reg data = GR_cluster2_1;
model item_per_trans =
/*email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate*/
net_amt_per_item
 /VIF COLLIN;
output out = resid2 p = PUNITS r = RUNITS student = student;
run;quit;

proc means data = gr_cluster2_1;
var item_per_trans net_amt_per_item;
run;




*Cluster 3;
Data GR_cluster3;
set project.general_retail_jorge;
where kmeans_4_ = 3; run;

/*Regression Model for cluster 3*/
proc reg data = GR_cluster3;
model item_num = email_send_num
email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate
distinct_store_visit_num
trans_num
item_distinct_num
item_amt_sum
net_amt_per_trans
item_per_trans
net_amt_per_item
percent_uniqu_item
loyalty_member_flag
tenure_months
avg_days_btwn_trans;
output out = resid3 p = PUNITS r = RUNITS student = student;
run;quit;

/*Deleting influencial observations*/
data GR_Cluster3_1;
set resid3;
pos =0; neg = 0;
if student > 3.0 then delete;
if student < -3.0 then delete;
run;

/*Recalculating the REg Model for Cluster2*/
proc reg data = GR_cluster3_1;
model item_per_trans = email_send_num
/*email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate*/
net_amt_per_item
/VIF COLLIN;
output out = resid3 p = PUNITS r = RUNITS student = student;
run;quit;

proc means data = gr_cluster3_1;
var item_per_trans net_amt_per_item;
run;


/*factor Analysis*/
proc factor data = GR_cluster3_1 out = factors3 nfactors = 16;
var email_send_num
email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate
distinct_store_visit_num
trans_num
item_distinct_num
item_amt_sum
net_amt_per_trans
item_per_trans
percent_uniqu_item
loyalty_member_flag
tenure_months
avg_days_btwn_trans; run;

proc corr data = factors3; 
var factor1 - factor8 ; run;

proc reg data = factors3;
model item_num = factor1-factor8 net_amt_per_item/VIF COLLIN;
run;quit;

*Cluster 4;
Data GR_cluster4;
set project.general_retail_jorge;
where kmeans_4_ = 4; run;




/*Regression Model for cluster 3*/
proc reg data = GR_cluster4;
model item_num = email_send_num
email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate
distinct_store_visit_num
trans_num
item_distinct_num
item_amt_sum
net_amt_per_trans
item_per_trans
net_amt_per_item
percent_uniqu_item
loyalty_member_flag
tenure_months
avg_days_btwn_trans;
output out = resid4 p = PUNITS r = RUNITS student = student;
run;quit;

/*Deleting influencial observations*/
data GR_Cluster4_1;
set resid4;
if student > 3.0 then delete;
if student < -3.0 then delete;
run;


/*Regression Model for cluster 3 checking for collinearity*/
proc reg data = GR_cluster4_1;
model item_per_trans = email_send_num
/*email_open_rate
email_click_rate
email_forward_rate
email_unsub_rate
email_engage_rate*/
net_amt_per_item
/VIF COLLIN;
output out = resid4 p = PUNITS r = RUNITS student = student;
run;quit;

proc means data = gr_cluster4_1;
var item_num item_per_trans net_amt_per_item;
run;



/*Elasticity segment vs product*/
/*Importing file into SAS*/

PROC IMPORT DATAFILE= "E:\Study\Predictive Analytics - SAS\SAS\Project\general_retail.xlsx" DBMS=xlsx OUT= project.general_retail REPLACE;
  SHEET="sheet2"; 
  GETNAMES=YES;
  *MIXED=NO;
RUN;

*Cluster 1;

/*Elasticity Cluster 1*/
proc reg data = GR_cluster_PE1;	Model active_shoe=active_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model baby_personal_care=baby_personal_care_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model baby_furn_basics=baby_furn_basics_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model beauty_aids=beauty_aids_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model boys_apparel=boys_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model cards_books_mag=cards_books_mag_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model consumer_electron=consumer_electron_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model electronic_service=electronic_service_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model food_beverage=food_beverage_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model furniture=furniture_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model girls_apparel=girls_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model health_aid_otc=health_aid_otc_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model home_decor=home_decor_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model home_improvement=home_improvement_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model home_organization=home_organization_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model household_supplies=household_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model intimate_apparel=intimate_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model jewelry_watches=jewelry_watches_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model junior_apparel=junior_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model kitchen_tabletop=kitchen_tabletop_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model lawn_garden=lawn_garden_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model leased_shoe=leased_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model licensed_sports=licensed_sports_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model linens_domestics=linens_domestics_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model mens_apparel=mens_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model missy_apparel=missy_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model nit=nit_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model non_merchandise=non_merchandise_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model optical=optical_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model patio_furniture=patio_furniture_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model pet_supplies=pet_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model pharmacy=pharmacy_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model plus_apparel=plus_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model school_office_sup=school_office_sup_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model small_electronics=small_electronics_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model sports_rec=sports_rec_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model toys=toys_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model trim_a_tree=trim_a_tree_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model unallocated=unallocated_PU;	run:quit;
proc reg data = GR_cluster_PE1;	Model womens_accessories=womens_accessories_PU;	run:quit;

/*Cluster2*/

proc reg data = GR_cluster_PE2;	Model active_shoe=active_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model baby_personal_care=baby_personal_care_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model baby_furn_basics=baby_furn_basics_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model beauty_aids=beauty_aids_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model boys_apparel=boys_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model cards_books_mag=cards_books_mag_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model consumer_electron=consumer_electron_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model electronic_service=electronic_service_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model food_beverage=food_beverage_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model furniture=furniture_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model girls_apparel=girls_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model health_aid_otc=health_aid_otc_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model home_decor=home_decor_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model home_improvement=home_improvement_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model home_organization=home_organization_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model household_supplies=household_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model intimate_apparel=intimate_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model jewelry_watches=jewelry_watches_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model junior_apparel=junior_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model kitchen_tabletop=kitchen_tabletop_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model lawn_garden=lawn_garden_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model leased_shoe=leased_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model licensed_sports=licensed_sports_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model linens_domestics=linens_domestics_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model mens_apparel=mens_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model missy_apparel=missy_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model nit=nit_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model non_merchandise=non_merchandise_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model optical=optical_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model patio_furniture=patio_furniture_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model pet_supplies=pet_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model pharmacy=pharmacy_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model plus_apparel=plus_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model school_office_sup=school_office_sup_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model small_electronics=small_electronics_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model sports_rec=sports_rec_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model toys=toys_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model trim_a_tree=trim_a_tree_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model unallocated=unallocated_PU;	run:quit;
proc reg data = GR_cluster_PE2;	Model womens_accessories=womens_accessories_PU;	run:quit;


/*cluster3*/
proc reg data = GR_cluster_PE3;	Model active_shoe=active_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model baby_personal_care=baby_personal_care_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model baby_furn_basics=baby_furn_basics_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model beauty_aids=beauty_aids_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model boys_apparel=boys_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model cards_books_mag=cards_books_mag_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model consumer_electron=consumer_electron_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model electronic_service=electronic_service_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model food_beverage=food_beverage_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model furniture=furniture_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model girls_apparel=girls_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model health_aid_otc=health_aid_otc_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model home_decor=home_decor_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model home_improvement=home_improvement_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model home_organization=home_organization_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model household_supplies=household_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model intimate_apparel=intimate_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model jewelry_watches=jewelry_watches_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model junior_apparel=junior_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model kitchen_tabletop=kitchen_tabletop_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model lawn_garden=lawn_garden_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model leased_shoe=leased_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model licensed_sports=licensed_sports_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model linens_domestics=linens_domestics_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model mens_apparel=mens_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model missy_apparel=missy_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model nit=nit_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model non_merchandise=non_merchandise_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model optical=optical_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model patio_furniture=patio_furniture_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model pet_supplies=pet_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model pharmacy=pharmacy_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model plus_apparel=plus_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model school_office_sup=school_office_sup_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model small_electronics=small_electronics_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model sports_rec=sports_rec_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model toys=toys_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model trim_a_tree=trim_a_tree_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model unallocated=unallocated_PU;	run:quit;
proc reg data = GR_cluster_PE3;	Model womens_accessories=womens_accessories_PU;	run:quit;

/*cluster4*/
proc reg data = GR_cluster_PE4;	Model active_shoe=active_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model baby_personal_care=baby_personal_care_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model baby_furn_basics=baby_furn_basics_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model beauty_aids=beauty_aids_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model boys_apparel=boys_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model cards_books_mag=cards_books_mag_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model consumer_electron=consumer_electron_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model electronic_service=electronic_service_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model food_beverage=food_beverage_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model furniture=furniture_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model girls_apparel=girls_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model health_aid_otc=health_aid_otc_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model home_decor=home_decor_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model home_improvement=home_improvement_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model home_organization=home_organization_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model household_supplies=household_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model intimate_apparel=intimate_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model jewelry_watches=jewelry_watches_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model junior_apparel=junior_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model kitchen_tabletop=kitchen_tabletop_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model lawn_garden=lawn_garden_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model leased_shoe=leased_shoe_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model licensed_sports=licensed_sports_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model linens_domestics=linens_domestics_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model mens_apparel=mens_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model missy_apparel=missy_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model nit=nit_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model non_merchandise=non_merchandise_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model optical=optical_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model patio_furniture=patio_furniture_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model pet_supplies=pet_supplies_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model pharmacy=pharmacy_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model plus_apparel=plus_apparel_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model school_office_sup=school_office_sup_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model small_electronics=small_electronics_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model sports_rec=sports_rec_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model toys=toys_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model trim_a_tree=trim_a_tree_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model unallocated=unallocated_PU;	run:quit;
proc reg data = GR_cluster_PE4;	Model womens_accessories=womens_accessories_PU;	run:quit;


proc reg data = GR_cluster_PE1;	Model item_amt_sum=email_send_num;	run:quit;
proc reg data = GR_cluster_PE2;	Model item_amt_sum=email_send_num;	run:quit;
proc reg data = GR_cluster_PE3;	Model item_amt_sum=email_send_num;	run:quit;
proc reg data = GR_cluster_PE4;	Model item_amt_sum=email_send_num;	run:quit;

