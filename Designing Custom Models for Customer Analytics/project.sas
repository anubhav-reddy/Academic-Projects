
*PART - I;

libname project "E:\Study\Adv BI with SAS\Project";

/*Data calc;
set project.billboard;
Retain l;
  alpha=0.5;
  r = 0.5;
  IF exposures=0 THEN 
    DO;
      l = (alpha/(alpha+1))**r;
	 
    END;
	else do;
	l = l*((r+exposures-1)/(exposures*(alpha+1)));
	
	end;
	ll = log(l)*peoplecount;
RUN;*/

PROC NLMIXED DATA=project.billboard;
  RETAIN l;
  PARMS alpha=0.5, r = 0.5; /*Initiating Parameters to be optimized*/
 IF exposures=0 THEN 
    DO;
      l = (alpha/(alpha+1))**r; /*probability of zero exposures*/
	 
    END;
	else do;
	l = l*((r+exposures-1)/(exposures*(alpha+1))); /*probability of exposures >= 1*/
	
	end;
	ll = log(l)*peoplecount; /*calculating values for log likelihood fucntion*/
  MODEL peoplecount ~ general(ll); /*optimizing values of alpha and r to get minimum log liklihood or maximum -2log likelihood*/
RUN;


/* Code 01 */
* The Poisson Regression Model; 
* for Khaki Chinos;

proc nlmixed data=project.kc;
  /* m stands for lambda */
  parms m0=1 b1=0 b2=0 b3=0 b4=0;/*Initiating Parameters to be optimized*/
  m=m0*exp(b1*income+b2*sex+b3*age+b4*HHSize); /*inidividual's mean(Poisson disttribution) related to observable characteristics*/
  ll = total*log(m)-m-log(fact(total)); /*calculating values for log likelihood fucntion*/
  model total ~ general(ll); /*optimizing PARAMS to get minimum log liklihood or maximum -2log likelihood*/
run;

/*data calc; 
set project.kc;
  /* m stands for lambda */
  m0=0.1; b1=0.1; b2=0.1; b3=0.1; b4=0.1;
  m=m0*exp(b1*income+b2*sex+b3*age+b4*HHSize);
  l2 = total*log(m)-m-log(fact(total));
  *model total ~ general(ll);
run;*/


/* Code 04 */
* The NBD Regression Model 
* for Khaki Chinos;

proc nlmixed data=project.kc;
  parms r=1 a=1 b1=0 b2=0 b3=0 b4=0; /*Initiating Parameters to be optimized*/
  expBX=exp(b1*income+b2*sex+b3*age+b4*HHSize);
  ll = log(gamma(r+total))-log(gamma(r))-log(fact(total))+r*log(a/(a+expBX))+total*log(expBX/(a+expBX)); /*calculating values for log likelihood fucntion*/
  model total ~ general(ll);
run;


*PART - II;


proc import datafile="E:\Study\Adv BI with SAS\Project\books.txt" out=project.books dbms=tab replace;
   getnames=yes;
run;


Data Books;
set project.books;
Amazon = 0;
BN = 0;
if domain = "amazon.com" then amazon = qty;/*creating flag for Amazon.com*/
else BN = qty;/*creating flag for B&N*/
if region = '*' or age = 99 then delete;/*Replacing * in region with numeric value 5*/
drop education;
regions = region*1;/*creating numeric column for region*/
drop region;
run;

proc means data = books; /*exploring the dataset*/
run;

/*SQL statment to count the number of books purchased from B&N website while retaing all demographic variables for each user*/
PROC SQL;
create table freqcount as
SELECT userid,avg(regions) as region,avg(hhsz) as hhsze,avg(age) as age,avg(income) as income,avg(child) as child,avg(race) as race,avg(country) as country,sum(BN) as BNbookspurch 
FROM books
GROUP BY userid;
QUIT;

proc print data = freqcount(OBS = 10);
run;


/*Creating dataset similar to Billboard exposures for fitting NBD model*/

Proc SQL;
create table purchasecount as
select BNbookspurch, count(userid)as usercount
from freqcount
group by BNbookspurch;
quit;

/*BUilding an NBD model for number of books purchased at B&N*/
PROC NLMIXED DATA=purchasecount;
  RETAIN l;
  PARMS alpha=0.5, r = 0.5; /*Initiating Parameters to be optimized*/
 IF BNbookspurch=0 THEN 
    DO;
      l = (alpha/(alpha+1))**r; /*probability of zero purchases*/
	 
    END;
	else do;
	l = l*((r+BNbookspurch-1)/(BNbookspurch*(alpha+1))); /*probability of every purchase >= 1*/
	
	end;
	ll = log(l)*usercount; /*calculating values for log likelihood fucntion*/
  MODEL usercount ~ general(ll); /*optimizing values of alpha and r to get minimum log liklihood or maximum -2log likelihood*/
RUN;


* The Poisson Regression Model; 
* for Books;

proc nlmixed data=freqcount;
  /* m stands for lambda */
  parms m0=0.5 b2=0 b3=0 b4=0 b5=0 b6=0 b7=0 b8=0;/*Initiating Parameters to be optimized*/
  m=m0*exp(b2*region + b3*hhsze + b4*age + b5*income + b6*child + b7*race + b8*country); /*inidividual's mean(Poisson disttribution) related to observable characteristics*/
  ll = bnbookspurch*log(m)-m-log(fact(bnbookspurch)); /*calculating values for log likelihood function*/
  model bnbookspurch ~ general(ll); /*optimizing PARAMS to get minimum log liklihood or maximum -2log likelihood*/
run;

/*Data calc;
set freqcount;
  r=1; a=0; b1=0; b2=0; b3=0; b4=0; b5=0; b6=0; b7=0; b8=0;
     expBX=exp(b1*education + b2*region + b3*hhsze + b4*age + b5*income + b6*child + b7*race + b8*country);
  ll = log(gamma(r+bnbookspurch))-log(gamma(r))-log(fact(bnbookspurch))+r*log(a/(a+expBX))+bnbookspurch*log(expBX/(a+expBX)); /*calculating values for log likelihood function*/
RUN;
quit;*/

* The NBD Regression Model 
* for Books;

proc nlmixed data=freqcount;
  parms r=1 a=1 b2=0.5 b3=0.5 b4=0.5 b5=0.5 b6=0.5 b7=0.5 b8=0.5; /*Initiating Parameters to be optimized*/
  expBX=exp(b2*region + b3*hhsze + b4*age + b5*income + b6*child + b7*race + b8*country);
  ll = log(gamma(r+bnbookspurch))-log(gamma(r))-log(fact(bnbookspurch))+r*log(a/(a+expBX))+bnbookspurch*log(expBX/(a+expBX)); /*calculating values for log likelihood fucntion*/
  model bnbookspurch ~ general(ll);
run;


