#!/bin/bash

# CONFIGURATION
OPTION_ALERT_EMAIL="your@personal.email"  #where to send the warning mail
OPTION_ALERT_LOAD_IF_EXCEEDS=75           #percent, decimal
OPTION_CALC_DECIMALS_VIA="python"         #arbitrary precision calculator, possible values: {python,php,bc}
OPTION_CRONTAB_SCHEDULE="*/1 */1 * * *"

# evaluates expression
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

# proceeds the disk space usage check
process() {
	sendMail="no"
    summaryLoadData=""
    
	# returns: Filesystem  Size  Used  Avail  Use%  Mounted on
    diskUsage=`df -h | sed 1,1d`
    
    while read -r line; do
    	usagePercent=$(echo "$line" | awk '{print $5}' | cut -d '%' -f 1)
		
		if [ $(evalExpression "$usagePercent>=$OPTION_ALERT_LOAD_IF_EXCEEDS") -ge 1 ]
		then
			sendMail="yes"
			summaryLoadData+=$line+"\n"
		fi
		
	done <<< "$diskUsage"
    
    if [ "$sendMail" == "yes" ]
    then
    	echo -e "\n----------------- OVERLOAD DISK USAGE -----------------"
    	
        hostname=$(uname -n)
        
        message=$(echo -e "Filesystem  Size  Used  Avail  Use%  Mounted on\n${summaryLoadData}\n")
        
        echo -e "$message\n"
        
        echo $(echo -e "$message" | mail -s "$hostname >> WARNING: DISK USAGE LOAD" "$OPTION_ALERT_EMAIL")
    else
    	echo -e "\nseems there are enough space\n"
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
    process
fi


