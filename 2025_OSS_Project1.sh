#! /bin/bash

echo "************OSS1 - Project1************"
echo "*      StudentID : 12214179       *    "
echo "*      Name : JaeWook Seung       *    "
echo "***********************************    "  

#if [ $# -ne 1 ]
#then 
#    echo "usage: ./2025_OSS_Project1.sh file"
#    exit 1
#fi

file_name=$1
stop="N"

until [ "$stop" = "Y" ]
do
    
    echo "[MENU]"
    echo "1. Search player stats by name in MLB data"
    echo "2. List top 5 players by SLG value"
    echo "3. Analyze the team stats - average age and total home runs"
    echo "4. Compare players in different age groups"
    echo "5. Search the players who meet specific statistical conditions"
    echo "6. Generate a performance report(formatted data)"
    echo "7. Quit"

    read -p "Enter your COMMAND (1~7): " choice

    case "$choice" in 
    1)
        read -p "Enter a player name to search: " player_name

        echo "Player stats for "$player_name": ";;

    2)
        read -p "Do you want to see the top 5 players by SLG? (y/n)" see_top5_SLG

        if [ "$see_top5_SLG" = "y" ]
        then 
            echo "***Top 5 Players by SLG***"
            echo
            echo
            echo
            echo
            echo
        fi

    ;;
    3)
        read -p "Enter team abbreviation (e.g., NYY, LAD, BOS): " team

        echo "Team stats for $team: "
        echo
        echo
        echo
    ;;

    4)
        echo "Compare players by age groups: "
        echo "1. Group A (Age < 25)"
        echo "2. Group B (Age 25-30)"
        echo "3. Group C (Age > 30)"
        
        read -p "Select age group (1-3): " age

    ;;
    5)
    ;;
    6)
    ;;

    7)
        echo "Have a good day!"
        stop="Y";;
    esac

done
