#!/bin/bash
source ./config.ini

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
