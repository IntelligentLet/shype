FILE=words.txt
IFS=''

words=()
currentletter=1

green="\e[0;92m"
reset="\e[0m"
bold="\e[1m"
blue="\e[0;94m"
expand_bg="\e[K"
green_bg="\e[0;102m${expand_bg}"
red="\e[0;91m"
uline="\e[4m"

while read CMD; do
    words+=($CMD)
done < "$FILE"

sentence2="${words[$(shuf -i 1-999 -n 1)]}"
sentence1=""
for i in {1..10}
do
    sentence2+=" ${words[$(shuf -i 1-999 -n 1)]}"
done

read -n 1 -s -r -p "Press ENTER to begin..."

clear
printf $sentence2

starttime=$(date +%s)

while true; do
    read -rsn1 INPUT
    if  [ "$INPUT" = "$(echo "$sentence2" | head -c $currentletter)" ]; then
        clear
        sentence1+=${sentence2:0:($currentletter)}
        sentence2=${sentence2:($currentletter)}

        
        printf "${blue}"${sentence1}"${reset}"
        printf "${green}${uline}${bold}"${sentence2:0:1}"${reset}"
        printf "${sentence2:1}"
    elif [ "$INPUT" != "$(echo "$sentence2" | head -c $currentletter)" ]; then
        clear
        
        printf "${blue}"${sentence1}"${reset}"
        printf "${red}${uline}${bold}"${sentence2:0:1}"${reset}"
        printf "${sentence2:1}"
    fi
    if [ ${#sentence2} = 0 ]; then
        clear

        endtime=$(date +%s)
        let wpm="600 / ($endtime - $starttime)"


        printf "${blue}Your speed was ${reset}${green}${bold}"$wpm" wpm"
        echo
        exit 1
    fi
done