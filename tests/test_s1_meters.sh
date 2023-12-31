#!/bin/sh

PROG="$1"

mkdir -p testoutput
TEST=testoutput

TESTNAME="Test S1 meters"
TESTRESULT="ERROR"

METERS="HCA  auto 91835132 NOKEY \
        HCA2 auto 04998541 NOKEY \
        QW   auto 13346376 NOKEY \
        QWW  auto 11121314 NOKEY \
        QWWW auto 12417708 NOKEY"

cat simulations/simulation_s1.txt | grep '^{' | jq --sort-keys . > $TEST/test_expected.txt
$PROG --format=json simulations/simulation_s1.txt $METERS  2> $TEST/test_stderr.txt | jq --sort-keys . > $TEST/test_output.txt
if [ "$?" = "0" ]
then
    cat $TEST/test_output.txt | sed 's/"timestamp": "....-..-..T..:..:..Z"/"timestamp": "1111-11-11T11:11:11Z"/' > $TEST/test_responses.txt
    diff $TEST/test_expected.txt $TEST/test_responses.txt
    if [ "$?" = "0" ]
    then
        echo OK json: $TESTNAME
        TESTRESULT="OK"
    else
        TESTRESULT="ERROR"
    fi
else
    echo "wmbusmeters returned error code: $?"
    cat $TEST/test_output.txt
    cat $TEST/test_stderr.txt
fi

cat simulations/simulation_s1.txt | grep '^|' | sed 's/^|//' > $TEST/test_expected.txt
$PROG --format=fields simulations/simulation_s1.txt $METERS  > $TEST/test_output.txt 2> $TEST/test_stderr.txt
if [ "$?" = "0" ]
then
    cat $TEST/test_output.txt | sed 's/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9].[0-9][0-9]$/1111-11-11 11:11.11/' > $TEST/test_responses.txt
    diff $TEST/test_expected.txt $TEST/test_responses.txt
    if [ "$?" = "0" ]
    then
        echo OK fields: $TESTNAME
        TESTRESULT="OK"
    else
        TESTRESULT="ERROR"
    fi
else
    echo "wmbusmeters returned error code: $?"
    cat $TEST/test_output.txt
    cat $TEST/test_stderr.txt
fi


if [ "$TESTRESULT" = "ERROR" ]
then
    echo ERROR: $TESTNAME
    exit 1
fi
