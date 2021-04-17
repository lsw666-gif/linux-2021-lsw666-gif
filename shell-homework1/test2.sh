#!/usr/bin/env bash
function help {

    echo "-r                 Count the number and percentage of worldcupplayerinfo in different age ranges (under 20 years of age, 20-30 years of age, over 30 years of age)"
    echo "-p                 Count the number and percentage of worldcupplayerinfo in different field positions"
    echo "-m                 Who is the player with the longest name? Who is the player with the shortest name? "
    echo "-y                 Who is the oldest player? Who is the youngest player? "
    echo "-h                 show this Help Document"
    echo "=================================================================="
    echo "You can use this shel like this: bash test2.sh -h"
    echo "And before use it,you should put the tsv file with this bash"

}
# "$6"不要加引号，会导致奇怪的错误
function comRange {
    awk -F "\t" 'BEGIN{
        young=0;middle=0;old=0;total=0;} $1!="Group"{    
        if($6<20) young++;
        else if($6<=30 && $6>=20) middle++;
        else old++;
        total = total + 1;
    }END{
        
        printf("under 20 years of age: %d %f%%\n",young,young*100.0/total);
        printf("20-30 years of age: %d %f%%\n",middle,middle*100.0/total);
        printf("over 30 years of age: %d %f%%\n",old,old*100.0/total);
    }' worldcupplayerinfo.tsv
}

function comPercent {
    awk -F "\t" 'BEGIN{
        Goalie=0;Defender=0;Midfielder=0;Forward=0;total=0;} $5!="Position"{    
        if($5=="Goalie") {Goalie++;}
        else if($5=="Midfielder"){Midfielder++;}
        else if($5=="Defender"){Defender++;}
        else if($5=="Forward"){Forward++;}
        total = total+1;
    }END{       
        printf("Goalie: %d %f%%\n",Goalie,Goalie*100.0/total);
        printf("Defender: %d %f%%\n",Defender,Defender*100.0/total);
        printf("Midfielder: %d %f%%\n",Midfielder,Midfielder*100.0/total);
        printf("Forward: %d %f\n%%",Forward,Forward*100.0/total);
    }' worldcupplayerinfo.tsv
}
# 类似图的思想，由对应的名字指向对应的长度
function mostName {
    awk -F "\t" 'BEGIN{
        short=10000;long=0} $1!="Group"{
        l=length($9);
        name[$9]=l;
        if(l>long) long = l;
        if(l<short) short=l;
    }END{
        for(i in name) {
                if(name[i]==long) printf("The longest name is %s\n", i);
                if(name[i]==short) printf("The shortest name is %s\n", i);               
    }
    }' worldcupplayerinfo.tsv
}

function mostYear {
    awk -F "\t" 'BEGIN{
        short=10000;long=0} $1!="Group"{
        name[$9]=$6;
        if($6>long) long=$6;
        if($6<short) short=$6;
    }END{
        for(i in name) {
                if(name[i]==long) printf("The oldest man is %s,his old is %d\n", i ,name[i]);
                if(name[i]==short) printf("The youngest man is %s,his old is %d\n",i ,name[i]);               
    }
    }' worldcupplayerinfo.tsv
}


if [ "$1" != "" ];then #判断是什么操作
    case "$1" in
        "-r")
            comRange 
            exit 0
            ;;
        "-p")
            comPercent 
            exit 0
            ;;    
        "-m")
            mostName
            exit 0
            ;;
        "-y")
            mostYear
            exit 0
            ;;
        "-h")
            help
            exit 0
            ;;
    esac
fi