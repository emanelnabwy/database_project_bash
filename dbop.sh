#!/bin/bash
### Script that handles customer info in file customers.db
#BASH script manages user data
#       Data files:
#               customers.db:
#                       id:name:email
#               accs.db:
#                       id,username,pass
#       Operations:
#               Add a customer
#               Delete a customer
#               Update a customer email
#               Query a customer
#       Notes:
#               Add,Delete, update need authentication
#               Query can be anonymous
#       Must be root to access the script
###################### 
#################################
### Exit codes:
##      0: Success
##      1: No customers.db file exists
##      2: No accs.db file exists
##      3: no read perm on customers.db
##      4: no read perm on accs.db
##      5: must be root to run the script
##      6: Can not write to customers.db
##      7: Customer name is not found

source ./checker.sh
source ./fun.sh
source ./printmsg.sh
##1: No customers.db file exists
##FILENAME=${1}
checkfile_ex "customer.db"
[ ${?} -eq  1 ] && echo " file customer not found" && exit 1
##2: No accs.db file exists
checkfile_ex "accs.db"
[ ${?} -eq  1 ] && echo " file assc not found" && exit 2
##      3: no read perm on customer.db
checkfile_r "customer.db"
[ ${?} -eq  1 ] && echo " file customer has not read per " && exit 3

##      4: no read perm on accs.db
checkfile_r "accs.db"
[ ${?} -eq  1 ] && echo " file assc has not read permission" && exit 4
##      5: must be root to run the script
checkuserR "root"
[ ${?} -eq 1 ] && exit 5
##      6: Can not write to customer.db
checkfile_w "customer.db"
[ ${?} -eq  1 ] && echo " file assc has not write permission" && exit 5

##      7: Customer name is not found
CONT=1
USERID=0
while [ ${CONT} -eq 1 ]
do
    PrintMainMenu
    read OP
    case "${OP}" in
        "a")
             echo "  Authentcation "
             echo "-----------------"
             echo -n " username: "
             read ADMUSER
             echo -n " password: "
             read  -s ADMPASS
             checkuserA "${ADMUSER}" "${ADMPASS}"
             if [ ${USERID} -eq 0 ]
                then
                  echo " invaild username and password"
                else
                  echo " welcome to our system"
              fi
             ;;

        "1")
             if [ ${USERID} -eq 0 ]
                then
                  echo " please authenticate your user"
                else
  echo "Adding a new customer"

                                        # Check for userid exist or not
                                        # Check for email exist or not
                                        echo "---------------------"
                                        insert


             fi
             ;;

        "2")
              if [ ${USERID} -eq 0 ]
                       then
                                echo "You are not authenticated, please authenticate 1st"
                        else
                                echo " update exiting email  in file "
                                echo "--------------------------"
                                #       Read required id to update
                                update

               fi
               ;;
        "3")
               if [ ${USERID} -eq 0 ]
                  then
                     echo "You are not authenticated, please authenticate 1st"
                  else
                                echo "Deleting existing user"
                                #Read required ID to delete
                                delete


                fi
                ;;
      "4")
                echo -n "Enter name :"
                read CUSTNAME
                queryCustomer "${CUSTNAME}"
                ;;
      "5")
echo "Thank you, see you later Bye"
                CONT=0
                ;;
        *)
                echo "not invaild ,please try again"
    esac
done

exit 0
