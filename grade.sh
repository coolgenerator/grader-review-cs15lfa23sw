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

if grep -q "Compilation failed" test-results.txt;
then
    echo -e "Compilation failed.\nTest Score = 0"
    exit 0
elif grep -q "OK" test-results.txt;
then
    echo "Test Score = 100"
    exit 0
else
    echo -e "Compilation success, but test failed.\nTest Score = 50"
    exit 0
fi

