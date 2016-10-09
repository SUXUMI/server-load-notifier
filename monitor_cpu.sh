#!/bin/bash

# CONFIGURATION
OPTION_ALERT_EMAIL="your@personal.email"  #where to send the warning mail
OPTION_ALERT_ON_CPU_LOAD_IF_EXCEEDS=72.5  #percent, decimal
OPTION_CHECK_n_TIMES=5                    #how many times to check the load of cpu, integer
OPTION_CHECK_DELAY=6                      #delay between checks, decimal
OPTION_CALC_DECIMALS_VIA="python"         #arbitrary precision calculator, possible values: {python,php,bc}
OPTION_CRONTAB_SCHEDULE="*/5 * * * *"

# gets the last top CPU loaded process from distinct `ps` command
# returns: USER PID %CPU %MEM TIME COMMAND
getCurrentCpuLoad() {
    echo `ps -auxe | awk '{print $1, $2, $3, $4, $10, $11}' | sort -k3rn | head -n 10 | sed -n '1,1p'`
}

# evaluates math/logical expression
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

# proceeds the cpu check
processCpuCheck() {
    summaryCpuLoad=0
    summaryCpuLoadData=""
    
    for (( i=0; i<$OPTION_CHECK_n_TIMES; i++ ))
    do
        currentCpuLoadData=$(getCurrentCpuLoad)
        summaryCpuLoadData+=$currentCpuLoadData+"\n"
        
        currentCpuLoad=$(echo "$currentCpuLoadData" | awk '{print $3}')
        echo -e "CPU LOAD:\t$currentCpuLoad%"
        
        summaryCpuLoad=$(evalExpression "$summaryCpuLoad+$currentCpuLoad" "float")
        #echo -e "$summaryCpuLoad"
        
        sleep "$OPTION_CHECK_DELAY"
    done
    
    cpuAvgLoad=$(evalExpression "$summaryCpuLoad/$OPTION_CHECK_n_TIMES" "int")
    
    echo "-------------------"
    
    echo -e "AVG CPU LOAD:\t$cpuAvgLoad%"
    
    echo -e "\n"

    if [ $(evalExpression "$cpuAvgLoad>$OPTION_ALERT_ON_CPU_LOAD_IF_EXCEEDS") -ge 1 ]
    then
        hostname=$(uname -n)
        
        message=$(echo -e "USER PID %CPU %MEM TIME COMMAND\n${summaryCpuLoadData}\n")
        message=$(sed "s/ /\\t/g" <<<"$message")
        
        echo "$message"
        
        echo $(echo -e "$message" | mail -s "$hostname >> WARNING: CPU LOAD - ${cpuAvgLoad}%" "$OPTION_ALERT_EMAIL")
    fi
    
    #return
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
    processCpuCheck
fi


