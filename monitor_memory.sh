#!/bin/bash

# CONFIGURATION
OPTION_ALERT_EMAIL="your@personal.email"   #where to send the warning mail
OPTION_ALERT_ON_MEMORY_LOAD_IF_EXCEEDS=1.5 #percent, decimal
OPTION_CHECK_n_TIMES=1                     #how many times to check the load of memory, integer
OPTION_CHECK_DELAY=1                       #delay between checks, decimal
OPTION_CALC_DECIMALS_VIA="python"          #arbitrary precision calculator, possible values: {python,php,bc}
OPTION_CRONTAB_SCHEDULE="*/5 * * * *"

# gets the last top MEMORY loaded process from distinct `ps` command
# returns: USER PID %CPU %MEM TIME COMMAND
getCurrentMemoryLoad() {
    echo `ps -auxe | awk '{print $1, $2, $3, $4, $10, $11}' | sort -k3rn | head -n 10 | sed -n '1,1p'`
}

# evaluates math expression
evalExpression() {
    case $OPTION_CALC_DECIMALS_VIA in
        "python")
            echo $(python -c "print int($1)")
            ;;
        "bc")
            echo $(echo "$1" | bc)
            ;;
        "php")
            echo $(php -r "echo intval($1);");
            ;;
    esac
}

# proceeds the MEMORY check
processMemoryCheck() {
    summaryMemoryLoad=0
    summaryMemoryLoadData=""

    for (( i=0; i<$OPTION_CHECK_n_TIMES; i++ ))
    do
        currentMemoryLoadData=$(getCurrentMemoryLoad)
        summaryMemoryLoadData+=$currentMemoryLoadData+"\n"

        currentMemoryLoad=$(echo "$currentMemoryLoadData" | awk '{print $4}')
        echo -e "MEMORY LOAD:\t$currentMemoryLoad%"

        summaryMemoryLoad=$(evalExpression "$summaryMemoryLoad+$currentMemoryLoad" "float")
        #echo -e "$summaryMemoryLoad"

        sleep "$OPTION_CHECK_DELAY"
    done

    momoryAvgLoad=$(evalExpression "$summaryMemoryLoad/$OPTION_CHECK_n_TIMES" "int")

    echo "-------------------"

    echo -e "AVG MEMORY LOAD:\t$momoryAvgLoad%"

    echo -e "\n"

    # v1
    #if [ $momoryAvgLoad -ge $OPTION_ALERT_ON_MEMORY_LOAD_IF_EXCEEDS ]

        # v2
    if [ $(evalExpression "$momoryAvgLoad>=$OPTION_ALERT_ON_MEMORY_LOAD_IF_EXCEEDS") -ge 1 ]
    then
        # http://www.tecmint.com/commands-to-collect-system-and-hardware-information-in-linux/
        hostname=$(uname -n)

        #echo "$serverIp"
        #echo -e "USER PID %CPU %MEM TIME COMMAND\r\n${momoryLoadData_1}"
        #echo -e "USER PID %CPU %MEM TIME COMMAND\r\n${momoryLoadData_1}" | mail -r "root@$serverIp" -s "WARNING: MEMORY LOAD - ${momoryAvgLoad}%" "$OPTION_ALERT_EMAIL"

        message=$(echo -e "USER PID %CPU %MEM TIME COMMAND\n${summaryMemoryLoadData}\n")
        
        message=$(sed "s/ /\\t/g" <<<"$message")

        echo "$message"

        echo $(echo -e "$message" | mail -s "$hostname >> WARNING: MEMORY LOAD - ${momoryAvgLoad}%" "$OPTION_ALERT_EMAIL")
    fi
}

# install/uninstall/run
if [ "$1" == "install" ] || [ "$1" == "uninstall" ]
then
    #get current path
    currentFilePath=$(realpath "${BASH_SOURCE[0]}")

    echo "$currentFilePath"

    # build crontab string
    croncmd="$currentFilePath < /dev/null"
    cronjob="$OPTION_CRONTAB_SCHEDULE $croncmd"

    if [ "$1" == "install" ]
    then
        echo "Installing.."
        echo "$cronjob"

        # add it to the crontab:
        ( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
    elif [ "$1" == "uninstall" ]
    then
        echo "Uninstalling.."
        echo "$cronjob"

        # remove it from the crontab:
        ( crontab -l | grep -v -F "$croncmd" ) | crontab -
    fi
else
    # run check
    processMemoryCheck
fi
