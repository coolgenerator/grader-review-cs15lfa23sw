#!/bin/bash
set -e

# Directory names
# GradeDir = "grading-area"
# SubmissionDir = "student-submission"

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# student-submission
#  - ListExamples.java


if [[ ! -e "student-submission/ListExamples.java" ]]
then
    echo "Grade file does not exist" 2> test-results.txt
    exit 1
fi

# Then, add here code to compile and run, and do any post-processing of the
# tests

cp student-submission/* grading-area
cp TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area
set +e
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
    echo "Compilation failed" 2> test-results.txt
    exit 1
else
    java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-results.txt 2>&1
fi

set -e

if grep -q "OK" test-results.txt;
then 
    echo -e "All tests passed \nTest Score = 100"
    exit 0;
fi

if grep -q "Compilation failed" test-results.txt;
then
    echo -e "Compilation failed \n"
fi

test_score=0
if grep -q "class ListExamples" ListExamples.java;
then
    (( test_score=test_score+10 ))
elif grep -q "static List<String> filter(List<String> s, StringChecker sc)" ListExamples.java;
then
    (( test_score=test_score+10 ))
elif grep -q "static List<String> merge(List<String> list1, List<String> list2)" ListExamples.java;
then
    (( test_score=test_score+10 ))
fi


echo "Test Score: $test_score";