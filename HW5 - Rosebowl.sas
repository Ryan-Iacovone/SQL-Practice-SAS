********************************************************;
** Rosebowl
** Ryan Iacovone
********************************************************;

** Define macro variables ROOT and OUTPATH;
%let root =/home/u49757561/my_shared_file_links/data;
%let outpath = /home/u49757561/Output;

PROC IMPORT DATAFILE="&root/MoreData/RoseBowl.csv" 
		DBMS=csv OUT=rose_raw REPLACE;
RUN;

data rosebowl MIschools 
		blowouts(keep= year winteam MOV) ;
	set rose_raw;
	Year= year(Date);
	MOV=winpts-losepts;
	label winteam = "Winning Team"
		winpts = "Winning Score"
		loseteam = "Losing Team"
		losepts = "Losing Score"
		MOV = "Margin of Victory";
	output rosebowl;
	if MOV >= 21 then output blowouts;
	if find(winteam,'Michigan') or find(loseteam,'Michigan') 
		then output MIschools;
	drop date;
run;


ods excel file="&outpath/HW5 - Rose Bowl Report.xlsx" 
          options(sheet_name='1980s');
title "Rose Bowl Games in the 1980s";
proc sql outobs = 10;
	select year, winteam, loseteam, winpts, losepts, MOV
	from rosebowl
	where year between 1980 and 1989
	order by year;
quit;

ods text =" Report Created by Ryan Iacovone";


ods excel options(sheet_name='MI Schools');
title "Rose Bowl Games Involving Michigan Schools";
proc sql;
	select year, winteam, loseteam, winpts, losepts, MOV
	from MIschools
	order by year;
quit;					


ods excel options(sheet_name='Blowouts');
title "Blowout Rose Bowl Victories";
proc sql;
	select year, winteam, MOV
	from blowouts
	order by MOV desc;
quit;



proc sort data=rosebowl out=rosebowlsort;
	by winteam ;
run;

data WinsBySchool;
	set rosebowlsort;
	by winteam; 
	if first.winteam=1 then NumWin=0;
	NumWin+1;

	label NumWin = "Number of Wins"
		AvgMOV = "Average Margin of Victory";
	
	if first.winteam=1 then AvgMOV1=0;
	AvgMOV1 + MOV;
	if last.winteam=1 then 
		AvgMOV= AvgMOV1/NumWin;
	if last.winteam=1;
	
	
	format AvgMOV 4.1;
run;
	
ods excel options(sheet_name='Wins By School');
title "Rose Bowl Wins by School";
Proc print data = WinsBySchool noobs label;
	var winteam NumWin AvgMOV;
run;
	
proc sort data=WinsBySchool out=WinsBySchoolS;
	by descending numwin descending AvgMOV;
	where numwin>=2;
run;

ods excel options(sheet_name='Multiple Wins');
title "Schools With Multiple Rose Bowl Victories";
proc print data = WinsBySchoolS noobs label;
	var winteam NumWin AvgMOV;
run;

ods excel close;
