#!/bin/bash
show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
#Written by Michael Chelotti  
    echo -e "${MENU}*****************MegaCLI Info Tool****************************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU}   Amsterdam 01 The Netherlands 8,000+ ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU}   Chennai India ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU}   Dallas USA ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU}   Frankfurt Germany ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 5)${MENU}   Hong Kong China ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 6)${MENU}   Houston USA ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 7)${MENU}   London England ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 8)${MENU}   Melbourne Australia ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 9)${MENU}   Milan Italy ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 10)${MENU}  Montreal Canada ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 11)${MENU}  Paris France ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 12)${MENU}  Querétaro Mexico ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 13)${MENU}  San Jose USA${NORMAL}"
    echo -e "${MENU}**${NUMBER} 14)${MENU}  Sao Paulo Brazil ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 15)${MENU}  Seattle USA ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 16)${MENU}  Singapore Singapore ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 17)${MENU}  Sydney Australia ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 18)${MENU}  Tokyo Japan${NORMAL}"
    echo -e "${MENU}**${NUMBER} 19)${MENU}  Toroto Canada ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 20)${MENU}  Washington D.C. USA ${NORMAL}"
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
        option_picked "Option 1 Amsterdam 01 The Netherlands Picked";
         wget --output-document=/dev/null http://speedtest.ams01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com

       show_menu;
            ;;

2) clear;
            option_picked "Option 2 Chennai India Picked";
             wget --output-document=/dev/null http://speedtest.che01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.che01.softlayer.com
        show_menu;
            ;;
3) clear;
            option_picked "Option 3 Dallas USA Picked";
             wget --output-document=/dev/null http://speedtest.dal01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
4) clear;
            option_picked "Option 4 Frankfurt Germany Picked";
             wget --output-document=/dev/null http://speedtest.fra02.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
5) clear;
            option_picked "Option 5 Picked";
             wget --output-document=/dev/null http://speedtest.hkg02.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
6) clear;
            option_picked "Option 6 Picked";
             wget --output-document=/dev/null http://speedtest.hou02.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
7) clear;
            option_picked "Option 7 Picked";
             wget --output-document=/dev/null http://speedtest.lon02.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
8) clear;
            option_picked "Option 8 Picked";
             wget --output-document=/dev/null http://speedtest.mil01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
9) clear;
            option_picked "Option 9 Picked";
            wget --output-document=/dev/null http://speedtest.lon02.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
10) clear;
            option_picked "Option 10 Picked";
             wget --output-document=/dev/null http://speedtest.lon02.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
11) clear;
            option_picked "Option 11 Picked";
             wget --output-document=/dev/null http://speedtest.mil01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
12) clear;
            option_picked "Option 12 Picked";
            get --output-document=/dev/null http://speedtest.mon01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
13) clear;
            option_picked "Option 13 Picked";
             wget --output-document=/dev/null http://speedtest.par01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
        show_menu;
            ;;
14) clear;
            option_picked "Option 14 Picked";
            wget --output-document=/dev/null http://speedtest.syd01.softlayer.com/downloadstest100.zip && echo "Measuring Packet Loss and Jitter"; mtr --report --report-cycles 10 -s 1472  -oLDRSWNBAWVJMXI speedtest.ams01.softlayer.com
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

