# Servers Load Notifier
Shell scripts which send email alert if CPU/Memory usage continuously goes above a certain amount.

*[Portfolio](http://www.admin.ge/portfolio)*<br>
*[GR8cms.com](http://www.GR8cms.com)*

*Copyright (c) 2016 GR*<br>
*licensed under the MIT licenses*<br>
*http://www.opensource.org/licenses/mit-license.html*

##USAGE

These scripts are kind of System Activity Reporter [SAR] on Linux.
By these scripts user can get email alert on cpu/memory overload and also get detailed information for overloaded processes

Put the script file in an appropriate folder and run the installation command. Than will be created a cronjob for that file, which will monitor the server load.

##### Requirements
```shell
Required one of the following to have on the server: python OR bc OR php
It is used for floating point values calculation

##### Configuration
```

// Where to send the warning mail
OPTION_ALERT_EMAIL="admin@admin.ge"     #where to send the warning mail

// If the high CPU load exceeds this value, then will be sent an email alert
OPTION_ALERT_ON_CPU_LOAD_IF_EXCEEDS=75  #percent, integer!

// How many times check the top loaded process
OPTION_CHECK_n_TIMES=5                  #integer

// Delay between checks
OPTION_CHECK_DELAY=6                    #decimal

// Arbitrary precision calculator
OPTION_CALC_DECIMALS_VIA="python"       #possible values: {python,php,bc}

// Crontab schedule
OPTION_CRONTAB_SCHEDULE="*/5 * * * *"
```

##### Installation
```shell
// will be created a cron job
monitor_cpu.sh install
```

##### De-installation
```shell
// will be removed the cron job created after installation
monitor_cpu.sh uninstall
```
