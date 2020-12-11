#!/bin/bash
case "$(ps ax | grep lolMiner | grep -v grep | wc -l)" in 
0) echo "\n lolMiner Not Running. Starting it now!"
   cd /opt/miners/lolminer/1.16a/
   ./mine_eth.sh
   ;;
1) echo "\n ALREADY RUNNING! NOTHING TO DO."
   ;;
esac
