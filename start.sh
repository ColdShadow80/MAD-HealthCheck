#!/bin/bash
source config.ini

MAXerrors=5
currentDate=$(date +'%Y-%m-%d %T')
##echo $currentDate

##script full path does not work as expected when on cron
script_name=$0
script_full_path=$(dirname "$0")

##echo "script_name: $script_name"
##echo "full path: $script_full_path"

 function my_used_disk_space()
 {
 	du -sh ~ | cut -f1
 }

 function my_used_disk_space_percentage()
 {
  ##hardcoded path, to be reviewed later
 	df --output=pcent /dev/vda3 | tr -dc '0-9'
 }

 function most_recent_file()
 {
  ls $MAD_path/logs -Art | tail -1
 }

## ignore stuff before here for now

##MADlog="$(ls $MADpath -Art | tail -1)"
##echo $MADlog

 function check_errors()
 {
##check for error
MADlog="$(ls $MADpath -Art | tail -1)"
errors="$(cat $MADpath/$MADlog | grep 'Cannot gracefully terminate connection' | wc -l)"
echo $errors

 }


##check_errors

if (( $(check_errors) > $MAXerrors )); then
    echo "$currentDate - Restarting scanner, found $(check_errors) errors of a maximum of $MAXerrors allowed"

    $script_full_path/tools/discord.sh --webhook-url $Webhook_Warning --username "HealthCheck" --avatar $Icon_Warning --description "$currentDate - Restarting scanner, found $(check_errors) errors of a maximum of $MAXerrors allowed"

    $RebootScript
else
    echo "$currentDate - $(check_errors) errors found, nothing to do"

    $script_full_path/tools/discord.sh  --webhook-url $Webhook_Info --username "HealthCheck" --avatar $Icon_Info --description "$currentDate - $(check_errors) errors found, nothing to do"

fi
