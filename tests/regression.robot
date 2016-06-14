# Copyright (c) 2016 Joe Gorse
# Copyright (c) 2015 Sine Nomine Associates
# Copyright (c) 2001 Kungliga Tekniska Högskolan
# See LICENSE

*** Settings ***
Documentation     Regression
Resource          openafs.robot
Suite Setup       Setup
Suite Teardown    Teardown

*** Variables ***
${VOLUME}      test.regression
${PARTITION}   a
${SERVER}      ${HOSTNAME}
${TESTPATH}    /afs/.${AFS_CELL}/test/${VOLUME}

*** Keywords ***
Setup
    Login  ${AFS_ADMIN}
    Create Volume  ${VOLUME}  server=${SERVER}  part=${PARTITION}  path=${TESTPATH}  acl=system:anyuser,read

Teardown
    Remove Volume  ${VOLUME}  path=${TESTPATH}
    Logout

*** Test Cases ***
Write a File Larger than the Cache
    [Tags]  arla  #(fcachesize-write-file)
    ${file}=  Set Variable  ${TESTPATH}/file
    Should Not Exist        ${file}
    Command Should Succeed  /bin/dd if=/dev/urandom of=${file} bs=2048 count=5000
    Should Be File          ${file}
    Should Not Be Symlink   ${file}
    Remove File             ${file}
    Should Not Exist        ${file}

Read a File Larger than the Cache
    [Tags]  todo  arla  #(fcachesize-read-file)
    TODO

Restore Volume with a Bad Uniquifier in it, salvage, check
    [Tags]  todo  arla  #(baduniq)
    TODO
