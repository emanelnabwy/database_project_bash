###variable for database 
USER_BD="ema"
PASS_BD="123"



## Function, takes customer name, and prints out the id, name, and email. Returns 0 if found, otherwise return 1
function queryCustomer {
        local CUSTNAME=${1}
        LINE=$(grep  "${CUSTNAME}" customer.db)
        [ -z  "${LINE}" ] && echo "Sorry, ${CUSTNAME} is not found" && return 7
        echo "Information for the customer"
        echo -e "\t ${LINE}"
        return 0
}

###function update email
function update_email
{
   ID=${1}
   EMAIL=${2}
   OLDDATA=$(grep "${ID}" customer.db )
   OLDMAIL=$(echo "${OLDDATA}" | awk 'BEGIN {FS=":"} {print $3}')
   sed -i 's/${OLDMAIL}/${EMAIL}/' customer.db
}

####function delete record
function delete_record
{
  ID=${1}
  DATA=$(grep "${ID}" customer.db)
  sed -i 's/${DATA}//g' customer.db
}
#########insert data in data dase
function insert
{
   # check for id is valid integer
    CONT1=1
                                while [ ${CONT1} -eq 1 ]
                                do
                                      echo -n "Enter customer ID : "
                                      read CUSTID
                                      id "${CUSTID}"
                                      if [ ${?}  -eq  0 ]
                                         then
                                                ID_FIND=$(grep -c  "${CUSTID}"  customer.db)
                                                if [  ${ID_FIND} -ne 0  ]
                                                     then
                                                           echo " ERROR: this id already exit "
                                                else
                                                            CONT1=0
                                                fi
                                       else
                                               echo "ERROR: this number not interger"

                                       fi

                                done


                                CONT2=1
                                while [ ${CONT2} -eq 1 ]
                                do
                                      echo -n "Enter customer name : "
                                           # check for customer name is only alphabet,-_
                                           read CUSTNAME
                                           customer_name "${CUSTNAME}"
                                           if [ ${?} -eq 1 ]
                                           then
                                                echo " please enter name has { character  or underscore  } "
                                           else
                                                  CONT2=0
                                           fi
                                done
                                 CONT3=1
                                while [ ${CONT3} -eq 1 ]
                                do
                                        echo -n "Enter customer email : "
                                        read CUSTEMAIL
                                        # check for email format
                                        email_customer "${CUSTEMAIL}"
                                        if [ ${?} -eq 0 ]
                                           then
                                                 # Check for email exist or not
                                                 EMAIL_FIND=$(grep -c  "${CUSTEMAIL}"  customer.db)
                                                 if [ ${EMAIL_FIND} -ne 0 ]
                                                    then
                                                       echo " this email another one has  please enter another "
                                                 else
                                                              CONT3=0
                                                 fi
                                        else
                                               echo " please enter email like { example@example.example  } "
                                        fi
                                 done
                                 #####saving data in file customer

                                echo "${CUSTID}:${CUSTNAME}:${CUSTEMAIL}" >> customer.db
                                echo "customer ${CUSTID} saved.."
                                mysql -u ${USER_BD} -p${PASS_BD} -e "insert into BD.customer (id,username,email) values (${CUSTID},'${CUSTNAME}','${CUSTEMAIL}');"


}

#############update email of user in data
function update
{
   #       Read required id to update
                                 CONT4=1
                                 while [ ${CONT4} -eq 1 ]
                                  do
                                      echo -n "Enter customer ID : "
                                      read CUSTID
                                      id "${CUSTID}"
                                      if [ ${?}  -eq  0 ]
                                         then
                                                ID_FIND=$(grep -c  "${CUSTID}"  customer.db)
                                                if [  ${ID_FIND} -gt 0  ]
                                                    then
                                                           echo " this id already exit "
                                                           echo " your data "
                                                              ####### print details
                                                           echo "$(grep ${CUSTID} customer.db | awk 'BEGIN {FS=":"} {print "this your data ""   " "your id " $1 "   "  "your name""  " $2 "   "  "your email""  "$3  }')"
                                                           CONT4=0
                                                    else
                                                          echo " your id is not defind"
                                                          echo " try again"

                                                fi
                                         else
                                                       echo " this number not interger"
                                     fi
                                 done
                                #       ask for confirmation
                                echo " confirm this your data right if ok enter yes  "
                                read YES
                                # yes,
                                if [ "${YES}" == "yes" ]
                                    then
                                        # ask for new email
                                         CONT5=1
                                         while [ ${CONT5} -eq 1 ]
                                         do
                                              echo "your new email "
                                              read CUSTEMAIL
                                               # check email is valid
                                              email_customer "${CUSTEMAIL}"
                                              if [ ${?} -eq 0 ]
                                                  then
                                                       ##check email exists
                                                       EMAIL_FIND=$(grep -c  "${CUSTEMAIL}"  customer.db)
                                                       if [ ${EMAIL_FIND} -eq  0 ]
                                                           then
                                                                CONT5=0
                                                           else
                                                              echo " this email already find  please enter another "
                                                       fi
                                                  else
                                                       echo " please enter email like { example@example.example  } "
                                              fi

                                        done
                                        # confirm
                                        echo " are you sure "
                                        read YES
                                        # yes: update the email in the file

                                        if [ "${YES}" == "yes" ]
                                            then
                                               update_email "${CUSTID}" "${CUSTEMAIL}"
                                               mysql -u ${USER_BD} -p${PASS_BD} -e "update BD.customer  set email='${CUSTEMAIL}' where id=${CUSTID};"

                                               echo " your data update and save"

                                        fi
                                 fi

}
##############function delete record from data
function delete
{
                                 CONT6=1
                                 while [ ${CONT6} -eq 1 ]
                                 do
                                      echo -n "Enter customer ID : "
                                      read CUSTID
                                      id "${CUSTID}"
                                      if [ ${?}  -eq  0 ]
                                         then
                                                ID_FIND=$(grep -c  "${CUSTID}"  customer.db)
                                                if [  ${ID_FIND} -gt 0  ]
                                                    then
                                                           echo " this id already exit "
                                                           echo " your data "
                                                              ####### print details
                                                           echo "$(grep ${CUSTID} customer.db | awk 'BEGIN {FS=":"} {print "this your data ""   " "your id " $1 "   "  "your name""  " $2 "   "  "your email""  "$3 }')"
                                                           CONT6=0
                                                    else
                                                          echo " your id is not defind"
                                                          echo " try again"

                                                fi
                                        else
                                                       echo " this number not interger"
                                     fi
                                 done

                                 # ask for confirmation
                                echo " confirm this your data right  if ok enter yes "
                                read YES
                                # yes,
                                if [ "${YES}"  == "yes" ]
                                    then
                                        # yes: Delete permanently
                                        delete_record "${CUSTID}"
                                        mysql -u ${USER_BD} -p${PASS_BD} -e "delete from BD.customer where id=${CUSTID};"
                                        echo " your recored delete"
                                fi

}


                                                                                       
   
                                   
