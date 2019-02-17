/***********************************************
* Name: Salary_Information.sas                 *
* Date: February 16, 2019                      *
*                                              *
* Purpose: Sorting people by defferent metrics *
*                                              *
* Output: Catagorized Employee and Diet Info.  *
***********************************************/

DATA DietData;
	INFILE "/folders/myfolders/DietData.txt";
	INPUT Subject 1-3 Height 4-5 Wt_init 6-8 Wt_final 9-11 ;
	
	Height_M = (Height * .0245);
	
	BMI_init = ((Wt_init * 0.453592) / (Height_M**2));
	BMI_final = ((Wt_final * 0.453592) / (Height_M**2));
	BMI_diff = Bmi_init - Bmi_final;
RUN;

PROC PRINT DATA = DietData;
RUN;




/** FOR CSV Files uploaded from Windows **/

FILENAME CSV "/folders/myfolders/FolsteinData.csv" TERMSTR=CRLF;


/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=MARSHAL.FolsteinData
		    DBMS=CSV
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=MARSHAL.FolsteinData; RUN;

/** Unassign the file reference.  **/

FILENAME CSV;

DATA Folstein;
set MARSHAL.FolsteinData;

ParentLocation = index(Folstein_MMSE_score_on_admit , '/');


MME_admit = substr(Folstein_MMSE_score_on_admit, 1, ParentLocation -1);
MMSE_discharge = substr(Folstein_MMSE_score_on_discharge,1,2);

MSE_Diff = MME_admit - MMSE_discharge;
drop ParentLocation;

RUN;

PROC PRINT DATA = Folstein;
var Subject MME_admit MMSE_discharge MSE_Diff;
RUN;


/* Employees CSV */


/** FOR CSV Files uploaded from Windows **/

FILENAME CSV "/folders/myfolders/Employees.csv" TERMSTR=CRLF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=MARSHAL.Employees
		    DBMS=CSV
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=MARSHAL.Employees; RUN;

/** Unassign the file reference.  **/

FILENAME CSV;

DATA Employees_revised;
set MARSHAL.EMPLOYEES;

ParentLocation = index(Name, ',');
LastName = substr(Name, 1,ParentLocation -1);


if Salary <= 50000 then Salary_Level = 1;
else if Salary > 50000 and Salary < 100000 then Salary_Level = 2;
else if Salary >= 100000 then Salary_Level = 3;

Years_of_Service = (2019 - year(Hire_Date));

drop ParentLocation;
format Salary dollarx12.2;
put Salary dollarx12.2;

run;
proc print data = Employees_revised;
var LastName Job_Code Years_of_Service Salary_Level Salary;
run;