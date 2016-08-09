#!/bin/bash
show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
#Written by Michael Chelotti ExaGrid Systems 5/27/2015. For use with LSI MegaCli commands that would be useful to gather information on the RAID controller, the logical volumes and the physical disks.
    echo -e "${MENU}*****************MegaCLI Info Tool****************************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU}  Obtain information about the RAID controller including firmware version and FW Package Build and whether the Battery Backup Unit has been detected ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU}  Display information about the logical drives including whether they are in WriBack or WriteThrough mode ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU}  Display information about each physical disk connected to the RAID controller including size, state and serial number ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU}  Check the firmware state online, unconfigured, failed or hotspare of all the drives at a glance ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 5)${MENU}  Check whether drives are missing or undetected. This could happen after a drive swap. Missing drive typically requires a system reboot ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 6)${MENU}  Manually launch the BBU learn sequence (BBU will be disabled. Performance will be degraded ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 7)${MENU}  Clear a drive's foreign state flag  ${NORMAL}"                                                              
    echo -e "${MENU}**${NUMBER} 8)${MENU}  Change a drive from unconfigured Good to Hotspare ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 9)${MENU}  Check on the state of the BBU ${NORMAL}" 
    echo -e "${MENU}**${NUMBER} 10)${MENU} Silence an active alarm ${NORMAL}"                                                             
    echo -e "${MENU}**${NUMBER} 11)${MENU} Monitor a RAID rebuild get the enclosure slot from the -pdlist command above ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 12)${MENU} Display a continuous text-gui rebuild status ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 13)${MENU} Show the adapter's rebuild properties ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 14)${MENU} Change the adapter rebuild rate ${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    read opt
}
function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

clear
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
        option_picked "Option 1 Picked";
        MegaCli adpallinfo -a0 -nolog |more
       show_menu;
            ;;

2) clear;
            option_picked "Option 2 Picked";
            MegaCli -ldinfo -lall -a0 -nolog
        show_menu;
            ;;
3) clear;
            option_picked "Option 3 Picked";
            MegaCli -pdlist -a0 -nolog
        show_menu;
            ;;
4) clear;
            option_picked "Option 4 Picked";
            MegaCli -pdlist -a0 -nolog | grep Slot
        show_menu;
            ;;
5) clear;
            option_picked "Option 5 Picked";
            MegaCli -adpbbucmd -bbulearn -a0 -nolog
        show_menu;
            ;;
6) clear;
            option_picked "Option 6 Picked";
            #MegaCli -cfgforeign -clear -a0 -nolog
        show_menu;
            ;;
7) clear;
            option_picked "Option 7 Picked";
            MegaCli  -pdhsp -set -physdrv -a0 -nolog 
        show_menu;
            ;;
8) clear;
            option_picked "Option 8 Picked";
            MegaCli -adpbbucmd -getbbustatus -a0 -nolog
        show_menu;
            ;;
9) clear;
            option_picked "Option 9 Picked";
            MegaCli -adpsetprop AlarmSilence -a0 -nolog
        show_menu;
            ;;
10) clear;
            option_picked "Option 10 Picked";
            #MegaCli -pdrbld -showprog -physdrv -a0 -nolog
        show_menu;
            ;;
11) clear;
            option_picked "Option 11 Picked";
            while true; do MegaCli -pdrbld -showProg -physdrv "[253:1]" -a0 -nolog; echo "+++++++++++++++++++++++"; sleep 120; done
        show_menu;
            ;;
12) clear;
            option_picked "Option 12 Picked";
            #MegaCli -pdrbld -progdsply -physdrv "[enclosure:slot]" -a0 -nolog
        show_menu;
            ;;
13) clear;
            option_picked "Option 13 Picked";
            MegaCli -adpallinfo -a0 -nolog | grep -i rebuild
        show_menu;
            ;;
14) clear;
            option_picked "Option 14 Picked";
             #MegaCli -adpsetprop RebuildRate -value -a0
        show_menu;
            ;;


        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
done
 
