#!/bin/bash
	
echo "User Name: leeminje "
echo "Student Number: 12223768"
echo "-----------------------------------------------"
echo "[ Menu ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "-----------------------------------------------"

stop="n"

until [ $stop = "y" ]
do
	read -p "Enter your choice [ 1-9 ] " choice
	
	case $choice in
	1) mid=0
	   while true; do
	     if [ $mid -le 0 ] || [ $mid -gt 1682 ]; 
	     then read -p "Please enter 'movie id' (1 ~ 1682): " mid
	     else break
	     fi
	   done
	   cat u.item | awk -F\| -v m=$mid '$1==m {print $0}'
	   ;;

        2) read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n): " ans
	   if [ $ans = "Y" ] || [ $ans = "y" ];
	   then    
		   
		   cat u.item | awk -F\| '$7==1{print $1, $2}' | head 
	           
           fi
	   ;; 
	
	3) mid=0
	   while true; do
	     if [ $mid -le 0 ] || [ $mid -gt 1682 ]; 
	     then read -p "Please enter 'movie id' (1 ~ 1682): " mid
	     else break
	     fi
	   done
	   
	   cat u.data | awk -v m=$mid '$2==m Begin{sum=0; i=0}{((sum+=$3)); ((i+=1))}END{printf "average rating of '$mid' : %.5f\n", ((sum/i))}' | sed 's/[^1-9]*$//'
	   ;;
	   
	4) read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n): " ans
	   if [ $ans = "Y" ] || [ $ans = "y" ];
	       then cat u.item | sed 's/http[^|]*\|//g' | head
	   fi
	   ;;  
	     
	5) read -p "Do you want to get the data about users from 'u.user'? (y/n): " ans
	   if [ $ans = "y" ] || [ $ans = "Y" ];
           then 
               cat u.user | head | awk -F\| '{printf "user %d is %d years old %s %s\n",$1,$2,$3,$4} ' | cat > tmp
               while read line;
               do 
                   case $line in
                   *F*) line=$( echo "$line" | sed 's/F/female/');;
                   *M*) line=$( echo "$line" | sed 's/M/male/');; 
                   esac
               echo "$line"
               done < tmp
               
    
           fi
	   ;;
	   
	6) read -p "Do you want to Modify the format of 'release data' in 'u.item'? (y/n): " ans
	   if [ $ans = "y" ] || [ $ans = "Y" ];
           then 
               cat u.item | tail | sed -r 's/([0-9]{2})-([a-zA-Z]{3})-([0-9]{4})/\3\2\1/' | cat >tmp
               while read line;
               do
               case $line in
               *Jan*) line=$( echo "$line" | sed 's/Jan/01/');;
               *Feb*) line=$( echo "$line" | sed 's/Feb/02/');;
               *Mar*) line=$( echo "$line" | sed 's/Mar/03/');;
               *Apr*) line=$( echo "$line" | sed 's/Apr/04/');;
               *May*) line=$( echo "$line" | sed 's/May/05/');;
               *Jun*) line=$( echo "$line" | sed 's/Jun/06/');; 
               *Jul*) line=$( echo "$line" | sed 's/Jul/07/');;
               *Aug*) line=$( echo "$line" | sed 's/Aug/08/');;
               *Sep*) line=$( echo "$line" | sed 's/Sep/09/');;
               *Oct*) line=$( echo "$line" | sed 's/Oct/10/');;
               *Nov*) line=$( echo "$line" | sed 's/Nov/11/');;
               *Dec*) line=$( echo "$line" | sed 's/Dec/12/');;
               esac
               echo "$line"
               done < tmp 
	   fi
	   ;;
	   
	7) uid=0
	   while true; do
	   if [ $uid -le 0 ]||[ $uid -gt 943 ];
	   then
               read -p "Please enter the 'user id' (1~943): " uid
           else 
               break
           fi
	   done
	   cat u.data | awk -v u=$uid '$1==u{print $2}' | sort -n | tr '\n' '|' | sed 's/.$//' | cat > tmp
	   cat tmp
	   echo -e "\n"
	   sed 's/|/\n/g' tmp > tmp2
	   while read line;
	   do 
	   cat u.item | awk -F\| -v id=$line '$1==id{printf "%d | %s\n", $1,$2}' 
	   done < tmp2 | head
	   ;;
	   
	8) read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n): " ans
	   if [ $ans = "y" ] || [ $ans = "Y" ];
           then  
                programmer="programmer"
                cat u.user | awk -F\| -v p=$programmer '$2>=20&&$2<=29&&$4==p{print $1}' | cat > tmp
                while read line;
                do
                cat u.data | awk -v l=$line '$1==l {printf "%d %d\n",$2,$3}'
                done < tmp > tmp2
                
                awk '{ sum[$1]+=$2; i[$1]+=1;}END{for(j in sum){printf "%d %.5f\n",j,sum[j]/i[j]}}' tmp2 | sort -n |cat > tmp
               cat tmp | sed 's/[^1-9]*$//'
                
           fi
           ;;
	   
	   
	
	9) echo "Bye!"
	   stop="y"
	   ;;
	   
	*) echo "Error: Invalid option"
	   read -p "Press [Enter]" readEnterKey
	   ;; 
	esac
	echo -e "\n"
done
