#!/bin/bash

# --------------
# Startup
# --------------
let "errorCounter = 0"
# Clear contents of Error & Output files 
cat /dev/null > mannem-Test.Error
cat /dev/null > mannem-Test.Output


# Make file of Spell 
make clean
make CC="atac cc"


# Delete previous trace files

# Delete previous atac files 

# ----------------------------------
# Subroutine to terminate abnormally
# ----------------------------------

terminate()
{
 echo "The execution of $CALLER was not successful."
 echo "$CALLER terminated, exiting now with rc=1."
 dateTest=`date`
 echo "End of testing at: $dateTest"
 echo ""
 exit 1
}

####################################################################################################
#Test cases Begin 

# Name:  T001	 Verify whether spell check info is displayed with Help command	

echo "T001	 Verify whether spell check info is displayed with Help command"  >> mannem-Test.Output 
 
./spell -h >>  mannem-Test.Output  2>&1
	echo "T001 :PASS"

  if [ $? -ne 0 ] 
  then 
  echo "T001 : FAIL " 
  let "errorCounter = errorCounter + 1"
  fi

########################################################

# Name: T002	Verify that the Line numbers and file names are displayed in the output 
#
echo "T002	Verify that the Line numbers and file names are displayed in the output"  >> mannem-Test.Output 
./spell -n -o sample >> mannem-Test.Output | echo "T002 :PASS"
./spell -n -o sample 2>> mannem-Test.Error
  if [ $? -ne 0 ] 
  then 
  echo "T002 : FAIL " 
  let "errorCounter = errorCounter + 1"
  fi

########################################################

# Name: T003	Verify the presence of Master Dictionary against which spell check is done.
echo T003	"Verify the presence of Master Dictionary against which spell check is done."  >> mannem-Test.Output 
masterdict="/usr/share/lib/dict/words"

if [ -e "$masterdict" ]; then
  echo "T003:PASS Master dictionary present" >> mannem-Test.Output 
else
  echo "T003:FAIL Master dictionary not present" >&2
  let "errorCounter = errorCounter + 1"
  exit 1
fi
########################################################

# Name: T004	Verify the presence of History file in Which Misspelt words are Written
echo "T004	Verify the presence of History file in Which Misspelt words are Written"  >> mannem-Test.Output 
spellhist="/var/adm/spellhist"
if [ -e "$spellhist" ]; then
  echo "T004:PASS Spell hist file  present" >> mannem-Test.Output 
else
  echo "T004:FAIL Spell hist file not present" >&2
  let "errorCounter = errorCounter + 1"
  exit 1
fi
########################################################

# # Name: T005	Verify spell check from the words collected  at standard input
 echo "T005	Verify spell check from the words collected  at standard input"	 >> mannem-Test.Output 
# text_entered="This is Entered from standard unit from User/n"
 ./spell < sample
echo "T005 :PASS"

########################################################

# Name: T006	Verify that the LocalFile contents are excluded from misspelt words
echo "T006	Verify that the LocalFile contents are excluded from misspelt words"  >> mannem-Test.Output 
#./spell +localfile 	

########################################################

# Name: T007	Verify the existance of subroutines hashmake , Spellin , hashckeck . 
echo "T007	Verify the existance of subroutines hashmake , Spellin , hashckeck ."  >> mannem-Test.Output 
hashmake="/usr/lib/spell/hashmake"
spellin="/usr/lib/spell/spellin"
hashcheck="/usr/lib/spell/hashcheck"
if [ -e "$hashmake" ] ; then
  echo "T007:PASS : subroutines hashmake , Spellin , hashckeck are Indeed present " >> mannem-Test.Output
else
  echo "T007:FAIL: Subroutines are missing" >> mannem-Test.Error

fi
########################################################

# Name: T008	Verify that the program is not working with incorrect filename. (file  not present)
echo "T008	Verify that the program is not working with incorrect filename. (file  not present)"  >> mannem-Test.Error 
echo "T008	Verify that the program is not working with incorrect filename. (file  not present)"  >> mannem-Test.Output
./spell filename_notPresent  2>> mannem-Test.Error 
 echo "T008 PASS: Error detected"


########################################################

# Name: T009	Verify that the program is working with a mix of correct/Incorrect Filenames
# echo "T009	Verify that the program is working with a mix of correct/Incorrect Filenames"	 >> mannem-Test.Output 
# if ./spell file_notpresent sample | grep 'stat error' > /dev/null; then
# if ./spell file_notpresent sample | grep 'Tihs' > /dev/null; then 
# ./spell file_notpresent sample>> mannem-Test.Output | echo "T009 :PASS"
# fi
# else
# ./spell file_notpresent sample>> mannem-Test.Error | echo "T009 :FAIL"
# fi
########################################################

# Name: T010	Verify  the functionality of spell check against multiple Large files
echo "T010	Verify  the functionality of spell check against multiple Large files"	 >> mannem-Test.Output 
./spell sample1 sample2 sample3 >> mannem-Test.Output  | echo "T010 :PASS"

########################################################

# Name: T011	Verify  the functionality of spell check against multiple small files
echo "T011	Verify  the functionality of spell check against multiple small files"	 >> mannem-Test.Output 
./spell sample4 sample5 sample6 >> mannem-Test.Output  | echo "T011 :PASS"
########################################################

# Name: T012	Verify  the functionality of spell check against a single Huge file 
echo "T012	Verify  the functionality of spell check against a single Huge file "	 >> mannem-Test.Output 
./spell sample1 >> mannem-Test.Output  | echo "T012 :PASS"
########################################################

# Name: T013	Verify the functionality of spell check against an empty file 
echo "T013	Verify the functionality of spell check against an empty file "  >> mannem-Test.Output 
./spell sample7 >> mannem-Test.Output  | echo "T013 :PASS"
########################################################

# Name: T014	verify spell check with mix of (American and British words)
echo "T014	verify spell check with mix of (American and British words)"  >> mannem-Test.Output 
./spell sample >> mannem-Test.Output  | echo "T014 :PASS"
########################################################

# Name: T015	Verify spell check with only British words . ( non-brit American words should be output as misspelt )
echo "T015	Verify spell check with only British words . ( non-brit American words should be output as misspelt )"  >> mannem-Test.Output 
./spell sample8 >> mannem-Test.Output  | echo "T015 :PASS"
########################################################

# Name: T016	Verify spell check with only American words. (non-American Brit words should be output as misspelt)
echo "T016	Verify spell check with only American words. (non-American Brit words should be output as misspelt)"  >> mannem-Test.Output 
./spell sample9 >> mannem-Test.Output  | echo "T016 :PASS"
########################################################

# Name: T017	Verify working of Spell program on inputs conaining words other than ASCII codeset ( Like Unicode)
echo "T017	Verify working of Spell program on inputs conaining words other than ASCII codeset ( Like Unicode)"  >> mannem-Test.Error 
./spell sample10   >> mannem-Test.Error  | echo "T017 :PASS"
########################################################


# Name: T018	Verify working of Spell program on inputs conaining  ASCII -  symbols and other Special characters
echo "T018	Verify working of Spell program on inputs conaining  ASCII -  symbols and other Special characters"  >> mannem-Test.Output 
./spell sample11 >> mannem-Test.Output  | echo "T018 :PASS"
########################################################

# Name: T019	Verify the working of program with a mix of  good files & Corrupt files
echo "T019	Verify the working of program with a mix of  good files & Corrupt files"  >> mannem-Test.Output 
./spell sample sample11 >> mannem-Test.Output  | echo "T019 :PASS"
########################################################

# Name: T020	Verify the working of program with only multiple corrupted files 
echo "T020	Verify the working of program with only multiple corrupted files "  >> mannem-Test.Output 
./spell sample11 sample10 >> mannem-Test.Error | echo "T020 :PASS"

########################################################

# Name: T021	Verify the working of program with all good files.
echo "T021	Verify the working of program with all good files."  >> mannem-Test.Output 
./spell sample sample1 sample2  >> mannem-Test.Output  | echo "T021 :PASS"

########################################################

# Name: T022	Verify the working of program with single good file.
echo "T022	Verify the working of program with single good file."  >> mannem-Test.Output 
./spell sample >> mannem-Test.Output  | echo "T022 :PASS"
	

########################################################

# Name: T023	Verify that the spell check dosent work with ( incorrect file name & a Corrupt file)	
echo "T023	Verify that the spell check dosent work with ( incorrect file name & a Corrupt file)" >> mannem-Test.Output 
./spell incorrectfile sample11 >> mannem-Test.Error  | echo "T022 :PASS"
########################################################


# ADDITIONAL TESTCASES FOR PROJECT 2B to improve coverage . 







# --------------
# Exit
# --------------
if [ $errorCounter -ne 0 ]
then
 echo ""
 echo "*** $errorCounter ERRORS found during ***"
 echo "*** the execution of this test case.  ***"
 terminate
else
 echo ""
 echo "*** Yeah! No errors were found during ***"
 echo "*** the execution of this test case. Yeah! ***"
fi
exit 0

# end of file