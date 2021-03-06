# Copyright (c) 2015 Sine Nomine Associates
# Copyright (c) 2001 Kungliga Tekniska Högskolan
# See LICENSE

*** Settings ***
Documentation     Volserver/vlserver tests
Resource          openafs.robot
Suite Setup       Login  ${AFS_ADMIN}
Suite Teardown    Logout

*** Variables ***
${SERVER}      ${HOSTNAME}
${VOLID}       0

*** Test Cases ***
Create a Volume
    [Teardown]  Remove Volume  xyzzy
    Volume Should Not Exist  xyzzy
    Command Should Succeed   ${VOS} create ${SERVER} a xyzzy
    Volume Should Exist      xyzzy
    Volume Location Matches  xyzzy  server=${SERVER}  part=a

Move a Volume
    [Setup]     Create Volume  xyzzy
    [Teardown]  Remove Volume  xyzzy
    Command Should Succeed   ${VOS} move xyzzy ${SERVER} a ${SERVER} b
    Volume Should Exist      xyzzy
    Volume Location Matches  xyzzy  server=${SERVER}  part=b

Add a Replication Site
    [Setup]     Create Volume  xyzzy
    [Teardown]  Remove Volume  xyzzy
    Command Should Succeed    ${VOS} addsite ${SERVER} a xyzzy
    Command Should Succeed    ${VOS} remsite ${SERVER} a xyzzy

Release a Volume
    [Setup]     Create Volume  xyzzy
    [Teardown]  Remove Volume  xyzzy
    Command Should Succeed    ${VOS} addsite ${SERVER} a xyzzy
    Command Should Succeed    ${VOS} release xyzzy
    Volume Should Exist       xyzzy.readonly
    Volume Location Matches   xyzzy  server=${SERVER}  part=a  vtype=ro

Remove a Replication Site
    [Setup]     Create Volume  xyzzy
    [Teardown]  Run Keywords   Command Should Succeed  ${VOS} remove ${SERVER} a xyzzy.readonly
    ...         AND            Remove Volume  xyzzy
    Command Should Succeed    ${VOS} addsite ${SERVER} a xyzzy
    Command Should Succeed    ${VOS} release xyzzy
    Command Should Succeed    ${VOS} remsite ${SERVER} a xyzzy
    Volume Should Exist       xyzzy.readonly

Remove a Replicated Volume
    [Setup]     Create Volume   xyzzy
    [Teardown]  Remove Volume   xyzzy
    Command Should Succeed    ${VOS} addsite ${SERVER} a xyzzy
    Command Should Succeed    ${VOS} release xyzzy
    Command Should Succeed    ${VOS} remove ${SERVER} a -id xyzzy.readonly
    Command Should Succeed    ${VOS} remove -id xyzzy
    Volume Should Not Exist   xyzzy.readonly
    Volume Should Not Exist   xyzzy

