#!/bin/bash
#####################################################################
# The purpose of this script is
# to generate a mixed media html report.
#
# This script does the following:
# 1. Downloads Consumer Complaint
#    data from the CFPB website.
#
# 2. Download income data from ACS
#
# 3. Download geography information
#
# 4. Loads the data into a SQLite database, and then
#
# 5. Performs a variety of analytical processing to
#    associate and identify relationship among the data.
#
# 6. The output of the processing is summarized in report.html
####################################################################
# By: Oswald Constable   Date: 9/25/2016
####################################################################

####################################################################
# START CONFIGURATION
#    Specify the following values to meet your system configuration
#    before running the script.
####################################################################
# Indicate Script Run Mode (TEST or PROD)
# set to PROD for real-world execution of script
MODE="PROD"

# Specify the path to the sqlite binary
SQLBIN="/home/oconstab/Downloads/sqlite/bin/sqlite3"

# Specify the path to the data storage directory where the complaints
# and income data will be stored.
DATADIR="/home/oconstab/Downloads/sqlite/data"

# Specify download URLs for data
DATAURL1="https://data.consumerfinance.gov/views/s6ew-h6mp/rows.csv"

DATAURL2="http://www2.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/All_Geographies_Not_Tracts_Block_Groups/20135us0015000.zip"

DATAURL3="http://www2.census.gov/acs2013_5yr/summaryfile/2009-2013_ACSSF_By_State_By_Sequence_Table_Subset/UnitedStates/All_Geographies_Not_Tracts_Block_Groups/g20135us.csv"

#####################################################################
# END CONFIGURATION
#####################################################################

#####################################################################
# DO NOT MODIFY ANYTHING BELOW THIS POINT
#####################################################################

############
# FUNCTIONS
###########
function downloadFile {
 url=$1
 filename=$(basename "$url")
 cd $DATADIR

 if [ "$MODE" = "PROD" ];
 then
   wget $url

   if [[ $filename =~ .*zip.* ]];
   then
     unzip $filename
   fi
 fi

}


###################
# MAIN SCRIPT BODY
###################
WORKDIR=$(pwd)


# GET DATA
echo "Deleting previous downloaded files..."

cd $DATADIR
if [ "$MODE" = "PROD" ];
 then
   rm -f *.csv* *.zip* *.txt* reportdb*
 fi

echo "Initiating download of data sets..."


for datafile in $DATAURL1 $DATAURL2 $DATAURL3;
 do
   downloadFile $datafile
 done


# LOAD DATA

echo "Adding missing headings..."

# Adding header to files that lack appropriate headers
echo "FILEID,FILETYPE,STUSAB,CHARITER,SEQUENCE,LOGRECNO,B06010_001,B06010_002,B06010_003,B06010_004,B06010_005,B06010_006,B06010_007,B06010_008,B06010_009,B06010_010,B06010_011,B06010_012,B06010_013,B06010_014,B06010_015,B06010_016,B06010_017,B06010_018,B06010_019,B06010_020,B06010_021,B06010_022,B06010_023,B06010_024,B06010_025,B06010_026,B06010_027,B06010_028,B06010_029,B06010_030,B06010_031,B06010_032,B06010_033,B06010_034,B06010_035,B06010_036,B06010_037,B06010_038,B06010_039,B06010_040,B06010_041,B06010_042,B06010_043,B06010_044,B06010_045,B06010_046,B06010_047,B06010_048,B06010_049,B06010_050,B06010_051,B06010_052,B06010_053,B06010_054,B06010_055,B06010PR_001,B06010PR_002,B06010PR_003,B06010PR_004,B06010PR_005,B06010PR_006,B06010PR_007,B06010PR_008,B06010PR_009,B06010PR_010,B06010PR_011,B06010PR_012,B06010PR_013,B06010PR_014,B06010PR_015,B06010PR_016,B06010PR_017,B06010PR_018,B06010PR_019,B06010PR_020,B06010PR_021,B06010PR_022,B06010PR_023,B06010PR_024,B06010PR_025,B06010PR_026,B06010PR_027,B06010PR_028,B06010PR_029,B06010PR_030,B06010PR_031,B06010PR_032,B06010PR_033,B06010PR_034,B06010PR_035,B06010PR_036,B06010PR_037,B06010PR_038,B06010PR_039,B06010PR_040,B06010PR_041,B06010PR_042,B06010PR_043,B06010PR_044,B06010PR_045,B06010PR_046,B06010PR_047,B06010PR_048,B06010PR_049,B06010PR_050,B06010PR_051,B06010PR_052,B06010PR_053,B06010PR_054,B06010PR_055,B06011_001,B06011_002,B06011_003,B06011_004,B06011_005,B06011PR_001,B06011PR_002,B06011PR_003,B06011PR_004,B06011PR_005,B06012_001,B06012_002,B06012_003,B06012_004,B06012_005,B06012_006,B06012_007,B06012_008,B06012_009,B06012_010,B06012_011,B06012_012,B06012_013,B06012_014,B06012_015,B06012_016,B06012_017,B06012_018,B06012_019,B06012_020,B06012PR_001,B06012PR_002,B06012PR_003,B06012PR_004,B06012PR_005,B06012PR_006,B06012PR_007,B06012PR_008,B06012PR_009,B06012PR_010,B06012PR_011,B06012PR_012,B06012PR_013,B06012PR_014,B06012PR_015,B06012PR_016,B06012PR_017,B06012PR_018,B06012PR_019,B06012PR_020" > e_header.csv

echo "FILEID,FILETYPE,STUSAB,CHARITER,SEQUENCE,LOGRECNO,B06010_001,B06010_002,B06010_003,B06010_004,B06010_005,B06010_006,B06010_007,B06010_008,B06010_009,B06010_010,B06010_011,B06010_012,B06010_013,B06010_014,B06010_015,B06010_016,B06010_017,B06010_018,B06010_019,B06010_020,B06010_021,B06010_022,B06010_023,B06010_024,B06010_025,B06010_026,B06010_027,B06010_028,B06010_029,B06010_030,B06010_031,B06010_032,B06010_033,B06010_034,B06010_035,B06010_036,B06010_037,B06010_038,B06010_039,B06010_040,B06010_041,B06010_042,B06010_043,B06010_044,B06010_045,B06010_046,B06010_047,B06010_048,B06010_049,B06010_050,B06010_051,B06010_052,B06010_053,B06010_054,B06010_055,B06010PR_001,B06010PR_002,B06010PR_003,B06010PR_004,B06010PR_005,B06010PR_006,B06010PR_007,B06010PR_008,B06010PR_009,B06010PR_010,B06010PR_011,B06010PR_012,B06010PR_013,B06010PR_014,B06010PR_015,B06010PR_016,B06010PR_017,B06010PR_018,B06010PR_019,B06010PR_020,B06010PR_021,B06010PR_022,B06010PR_023,B06010PR_024,B06010PR_025,B06010PR_026,B06010PR_027,B06010PR_028,B06010PR_029,B06010PR_030,B06010PR_031,B06010PR_032,B06010PR_033,B06010PR_034,B06010PR_035,B06010PR_036,B06010PR_037,B06010PR_038,B06010PR_039,B06010PR_040,B06010PR_041,B06010PR_042,B06010PR_043,B06010PR_044,B06010PR_045,B06010PR_046,B06010PR_047,B06010PR_048,B06010PR_049,B06010PR_050,B06010PR_051,B06010PR_052,B06010PR_053,B06010PR_054,B06010PR_055,B06011_001,B06011_002,B06011_003,B06011_004,B06011_005,B06011PR_001,B06011PR_002,B06011PR_003,B06011PR_004,B06011PR_005,B06012_001,B06012_002,B06012_003,B06012_004,B06012_005,B06012_006,B06012_007,B06012_008,B06012_009,B06012_010,B06012_011,B06012_012,B06012_013,B06012_014,B06012_015,B06012_016,B06012_017,B06012_018,B06012_019,B06012_020,B06012PR_001,B06012PR_002,B06012PR_003,B06012PR_004,B06012PR_005,B06012PR_006,B06012PR_007,B06012PR_008,B06012PR_009,B06012PR_010,B06012PR_011,B06012PR_012,B06012PR_013,B06012PR_014,B06012PR_015,B06012PR_016,B06012PR_017,B06012PR_018,B06012PR_019,B06012PR_020" > m_header.csv


echo "FILEID,STUSAB,SUMLEVEL,COMPONENT,LOGRECNO,US,REGION,DIVISION,STATECE,STATE,COUNTY,COUSUB,PLACE,TRACT,BLKGRP,CONCIT,AIANHH,AIANHHFP,AIHHTLI,AITSCE,AITS,ANRC,CBSA,CSA,METDIV,MACC,MEMI,NECTA,CNECTA,NECTADIV,UA,BLANK1,CDCURR,SLDU,SLDL,BLANK2,BLANK3,ZCTA5,SUBMCD,SDELM,SDSEC,SDUNI,UR,PCI,BLANK4,BLANK5,PUMA5,BLANK6,GEOID,NAME,BTTR,BTBG,BLANK7" > g_header.csv

cat e_header.csv e20135us0015000.txt > e20135us0015000WithHDR.csv
cat m_header.csv m20135us0015000.txt > m20135us0015000WithHDR.csv
cat g_header.csv g20135us.csv > g20135usWithHDR.csv

echo "Added headers..."
echo "Resetting SQLite database. Errors can be ignored..."

echo -e 'DROP TABLE complaint;' | $SQLBIN "reportdb"
echo -e 'DROP TABLE geo;' | $SQLBIN "reportdb"
echo -e 'DROP TABLE mincome;' | $SQLBIN "reportdb"
echo -e 'DROP TABLE eincome;' | $SQLBIN "reportdb"
echo -e 'DROP TABLE complaint_blend;' | $SQLBIN "reportdb"

echo "Starting SQLite data import..."

echo "importing rows.csv..."
echo -e '.mode csv \n.import rows.csv complaint' | $SQLBIN "reportdb"

echo "importing m20135us0015000WithHDR.csv..."
echo -e '.mode csv \n.import m20135us0015000WithHDR.csv mincome' | $SQLBIN "reportdb"

echo "importing e20135us0015000WithHDR.csv..."
echo -e '.mode csv \n.import e20135us0015000WithHDR.csv eincome' | $SQLBIN "reportdb"

echo "importing g20135usWithHDR.csv..."
echo -e '.mode csv \n.import g20135usWithHDR.csv geo' | $SQLBIN "reportdb"

echo "Completed SQLite data import..."

echo "Blending data..."

echo -e 'CREATE TABLE complaint_blend as select C.*, I.B06010_004, I.B06010_005, I.B06010_006, I.B06010_007, I.B06010_008  from complaint C left outer join geo G on C.[ZIP Code] = G.ZCTA5 left outer join mincome I on G.LOGRECNO = I.LOGRECNO limit 10000;' | $SQLBIN "reportdb"

echo -e 'select count(*), [ZIP code] || "<hr>" from complaint_blend group by [ZIP code] order by 1 desc;' | $SQLBIN "reportdb" > report_body.txt

echo "<html><body><h1>Frequency of Complaints by Zip Code</h1><br>" > report_header.txt
echo "</body></html>" > report_footer.txt

cat report_header.txt report_body.txt report_footer.txt > report.html


echo "Report Completed. See $DATADIR/report.html for output"

######################
# END MAIN SCRIPT BODY
######################


cd $WORKDIR

exit 0
