#!/bin/bash
#####function if file exit or not
function checkfile_ex {
   FILE=${1}
   [ ! -f ${FILE} ] && echo " file cannot found " && return 1
  return 0
}

###function if have read permiision
function checkfile_r {
  FILE=${1}
 [ ! -r ${FILE} ]   && return 1
   return 0
}
###function if have write permiision
function checkfile_w {
  FILE=${1}
 [ ! -w ${FILE} ]  && echo " file cannot write permission " && return 1
   return 0
}
## Function takes a parameter with username, and return 0 if the user requested is the same as current user
function checkuserR {
 RUSER=${1}
 [ ${RUSER} == ${USER} ]  && return 0
return 1
}
### Function takes a username, and password then check them in accs.db, and returns 0 if match otherwise returns 1
function checkuserA {
USERNAME=${1}
USERPASS=${2}
        ###1-Get the password hash from accs.db for this user if user found
        ###2-Extract the salt key from the hash
        ###3-Generate the hash for the userpass against the salt key
        ###4-Compare hash calculated, and hash comes from the file.
        ###5-IF match returns 0,otherwise returns 1
USERLINE=$( grep "${USERNAME}" accs.db)
[ -z ${USERLINE} ]  && return 0
PASSHASH=$(echo ${USERLINE} |awk ' BEGIN {FS=":"} { print $3 }')
SALTKEY=$(echo ${PASSHASH} | awk 'BEGIN {FS="$"} { print $3 }')
NEWHASH=$(openssl passwd -salt ${SALTKEY} -1 ${USERPASS})
if [ "${PASSHASH}" == "${NEWHASH}" ]
   then

        USERID=$(echo "${USERLINE}" | awk 'BEGIN  {FS=":"} {print $1}')
        return "${USERID}"
  else
  return 0
fi
}
 # check for id is valid integer

function id
{ ID=${1}
  ID_NEW=$(echo "${ID}" | grep -c '^[0-9]*:')
  [ ${ID_NEW}  -eq  0 ]  && return 1
  return 0
}
# check for customer name is only alphabet,-_
function customer_name
{
 NAME=${1}
 NAME_NEW=$(echo "${NAME}" | grep -c "^[a-zA-Z_-]*$" )
 [ ${NAME_NEW} -eq  0 ] && return 1
 return 0

}
# check for email format
function email_customer
{
    
 EMAIL=${1}
 NEWEMAIL=$(echo "${EMAIL}" | grep -c  "[[:alnum:]]*@[[:alnum:]]*.[[:alnum:]]*")
 [ ${NEWEMAIL} -eq  0 ] && return 1
  return 0
}
        
