#!/usr/bin/env bash

function help {
    echo "doc"
    echo "-o       Count the TOP 100 of the source hosts and the total number of appearances respectively."
    echo "-i       Count the TOP 100 IPs of the source host and the total number of occurrences respectively"
    echo "-v       Count the most frequently visited URLs TOP 100"
    echo "-p       count the number of occurrences and corresponding percentages of different response status codes"
    echo "-c       respectively count the TOP 10 URLs corresponding to different 4XX status codes and the total number of corresponding appearances"
    echo "-u xxx     URL output TOP 100 visit source host for a given URL"
    echo "-h       show this Help Document"
    echo "=================================================================="
    echo "You can use this shel like this: bash test3.sh -h"
    echo "And before use it,you should put the tsv file with this bash" 
}

function findHost {
    awk -F "\t" '
    $1!="host" {
        host[$1]++;
        }
    END { 
        for(i in host) {
            printf("%s %d\n",i,host[i])| "sort -g -k 2 -r" ;
            } 
        }' web_log.tsv | head -n 100 | tail -n +0
}

#match匹配正则表达式：【0-9】表示数字，*指不定量的数字
function findIP {
    awk -F "\t" '
    $1!="host" {
        if(match($1, /^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$/)) {
            host[$1]++;
            }
        }
    END {
         for(i in host) {
             printf("%s %d\n",i,host[i])| "sort -g -k 2 -r" ;
            } 
        }' web_log.tsv | head -n 100 | tail -n +0
}

function findURL {
    awk -F "\t" '
    $1!="host" {
        url[$5]++;
        }
    END { 
        for(i in url) {
            printf("%s %d\n",i,url[i])| "sort -g -k 2 -r" ;
            } 
        }' web_log.tsv | head -n 100 | tail -n +0
}

function findbytes {
    awk -F "\t" 'BEGIN{
        total=0;
    }
    $1!="host" {
        bytes[$6]++;
        total=total+1;
        }
    END { 
        for(i in bytes) {
            printf("%s %d %f\n",i,bytes[i],bytes[i]*100.0/total)| "sort -g -k 2 -r" ;
            } 
        }' web_log.tsv | head -n 100 | tail -n +0
}

function findbytes4XX {
    awk -F "\t" '
    $1!="host" {
        if($6==403){
            times[$5]++;
        }
    }
    END { 
        printf("403:\n");
        for(i in times) {
            printf("%s %d \n",i,times[i])| "sort -g -k 2 -r" ;
            } 
        printf("========================");
        }' web_log.tsv | head -n 10 | tail -n +0
    
    awk -F "\t" '
    $1!="host" {
        if($6==404){
            times[$5]++;
        }
    }
    END { 
        printf("404:\n");
        for(i in times) {
            printf("%s %d \n",i,times[i])| "sort -g -k 2 -r" ;
            } 
        printf("========================");
        }' web_log.tsv | head -n 10 | tail -n +0
}

function findUrlHost {
    awk -F "\t" '
    $1!="host" {
        if($5=="'"$1"'")
            host[$1]++;
        }
    END { 
        for(i in host) {
            printf("%s %d\n",i,host[i])| "sort -g -k 2 -r" ;
            } 
        }' web_log.tsv | head -n 100 | tail -n +0
}


if [ "$1" != "" ];then #判断是什么操作
    case "$1" in
        "-o")
            findHost
            exit 0
            ;;
        
        "-i")
            findIP
            exit 0
            ;;

        "-v")
            findURL
            exit 0
            ;; 

        "-p")
            findbytes
            exit 0
            ;;  
        
        "-c")
            findbytes4XX
            exit 0
            ;;  

        "-u")
            findUrlHost "$2"
            exit 0
            ;;  

        "-h")
            help
            exit 0
            ;;
    esac
fi