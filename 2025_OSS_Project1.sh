#! /bin/bash

if [ $# -ne 1 ]
then 
    echo "usage: ./2025_OSS_Project1.sh file"
    exit 1
fi

echo "************OSS1 - Project1************"
echo "*        StudentID : 12214179         *"
echo "*        Name : JaeWook Seung         *"
echo "***************************************"
echo
echo


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

        echo 
        echo
        echo "Player stats for "$player_name": "
        awk -F"," -v name="$player_name" '$2~name {print "Player: "name", Team: "$4", Age: "$3", WAR: "$6", HR: "$14", BA: "$20""}' "$file_name"
        echo
        echo
        ;;

    2)
        read -p "Do you want to see the top 5 players by SLG? (y/n) " see_top5_SLG

        if [ "$see_top5_SLG" = "y" ] # SLG $22 / PA $8
        then 
            echo
            echo
            echo "***Top 5 Players by SLG***"
            sort -t, -k 22 -nr "$file_name" | awk -F"," -v num=1 '$8 > 502 && num <= 5 {print ""num". "$2" (Team: "$4") - SLG: "$22", HR: "$14", RBI: "$15""; num++}' # for , while 쓰면 속도 더 오를지도
            echo
            echo
        else
            echo
            echo
        fi
    ;;
    3)
        read -p "Enter team abbreviation (e.g., NYY, LAD, BOS): " team
        
        echo
        echo
        awk -F"," -v team="$team" '$4~team {total_age += $3; total_hr += $14; total_RBI += $15; team_num++} 
        END {
            if (team_num > 0){
                print "Team stats for "team": "
                print "Average age: " ,total_age/team_num
                print "ToTal home runs: ", total_hr 
                print "Total RBI: ", total_RBI}

            else {print "Error: non-existent team is entered!"}
            }' "$file_name"
        echo
        echo
    ;;

    4)
        echo
        echo "Compare players by age groups: "
        echo "1. Group A (Age < 25)"
        echo "2. Group B (Age 25-30)"
        echo "3. Group C (Age > 30)"
        
        read -p "Select age group (1-3): " age
        echo

        case "$age" in
        1)
            echo "Top 5 by SLG in Group A (Age < 25): "
            tail -n +2 "$file_name" | sort -t, -k 22,22 -nr | awk -F"," -v num=1 '$8 > 502 && num <= 5 && $3 < 25 {print ""$2" ("$4") - Age: "$3", SLG: "$22", BA: "$20", HR: "$14""; num++}' 
            echo
            echo
            ;;
        2)
            echo "Top 5 by SLG in Group B (Age 25-30): "
            tail -n +2 "$file_name" | sort -t, -k 22,22 -nr | awk -F"," -v num=1 '$8 > 502 && num <= 5 && $3 >= 25 && $3 <= 30 {print ""$2" ("$4") - Age: "$3", SLG: "$22", BA: "$20", HR: "$14""; num++}' 
            echo
            echo
            ;;
        3)
            echo "Top 5 by SLG in Group C (Age > 30): "
            tail -n +2 "$file_name" | sort -t, -k 22,22 -nr | awk -F"," -v num=1 '$8 > 502 && num <= 5 && $3 > 30 {print ""$2" ("$4") - Age: "$3", SLG: "$22", BA: "$20", HR: "$14""; num++}' 
            echo
            echo
            ;;
        esac

    ;;
    5) 
        echo
        echo "Find players with specific criteria"
        read -p "Minimum home runs: " min_HR
        read -p "Minimum batting average (e.g., 0.280): " min_BA
        
        echo
        echo "Players with HR >= "$min_HR" and BA >= "$min_BA": "

        #홈런 기준 내림차순
        tail -n +2 "$file_name" | sort -t, -k 14,14 -nr | awk -F"," -v min_HR="$min_HR" -v min_BA="$min_BA" '$8 > 502 && $14 >= min_HR && $20 >= min_BA {print ""$2" ("$4") - HR: "$14", BA: "$20", RBI: "$15", SLG: "$22""}'
        echo
        echo
    ;;
    6)
        echo "Generate a formatted player report for which team?"
        read -p "Enter team abbreviation (e.g., NYY, LAD, BOS): " team_for_report

        echo
        echo "========================= "$team_for_report" PLAYER REPORT =========================="
        echo Date : $(date +%Y/%m/%d) 

        echo "---------------------------------------------------------------------------"
        echo "PLAYER                            HR     RBI      BA       OBP      OPS    "
        echo "---------------------------------------------------------------------------"

        tail -n +2 "$file_name" | sort -t, -k14,14nr | awk -F"," -v team="$team_for_report" '$4~team {printf "%-30s %5d %7d %8.3f %8.3f %8.3f\n", $2, $14, $15, $20, $21, $23; team_num++;}
                                                        END {print "---------------------------------------------------------------------------"; print "TEAM TOTALS:", team_num, "players"}'
        echo
        echo

    ;;

    7)
        echo "Have a good day!"
        stop="Y";;
    esac

done
