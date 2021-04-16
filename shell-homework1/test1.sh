#!/usr/bin/env bash
function help {

    echo "-q Q               compress jepg(Q is the quality)"
    echo "-r R               resize jpeg/png/svg(R is the rate)"
    echo "-w font_size text  add your water mark"
    echo "-p text            add prefix for png/jpeg/jpg/svg/bmp"
    echo "-s text            add subfix for png/jpeg/jpg/svg/bmp"
    echo "-t                 convert png/svg to jpg"
    echo "-h                 give this help"
    echo "=================================================================="
    echo "You can use this shell like this: bash test1.sh -q 50"
    echo "And before use it,you should put the image with this bash"

}
#在循环中逐一遍历文件的语法是：首先声明一个变量（例如使用 f 代表文件），然后定义一个你希望用变量循环的数据集。在这种情况下，使用 * 通配符来遍历当前文件夹下的所有文件（通配符 * 匹配所有文件）。然后使用一个分号（;）来结束这个语句。
#模式*/匹配目录部分，所以只返回文件名 ,##为匹配最长序列
function compress {
    for image in *;do
        class=${image##*.} # 删除最后一个.及左边全部字符
        #echo "$class"
        if [[ ${class} == "jpeg" ]]; then 
            convert "${image}" -quality "$1" "${image}"
            echo "${image} is compressed successfully!"
        fi
    done
}

function resize {
    for image in *;do
        class=${image##*.}
        if [[ ${class} == "jpeg" || ${class} == "png" || ${class} == "svg" ]]; then 
            convert "${image}" -resize "$1" "${image}"
            echo "${image} is resized successfully!"
        fi
    done
}

function addWatermark {
    for image in *;do
        class=${image##*.}
        if [[ ${class} == "jpeg" || ${class} == "png" || ${class} == "svg" ]]; then 
            convert "${image}" -pointsize "$1" -fill yellow -gravity center -draw "text 10,10 '$2'" "${image}"
            echo "${image} is watermarked with $2 successfully!"
        fi    
    done
}

function addPrefix {
    for i in *;do
        class=${i##*.}
        if [[ ${class} == "jpeg" || ${class} == "png" || ${class} == "svg" ]]; then 
            mv "${i}" "$1""${i}"
            echo "${i} is renamed to $1${i} successfully!"
        fi    
    done
}
function addSuffix {
    for i in *;do
        class=${i##*.}
        if [[ ${class} == "jpeg" || ${class} == "png" || ${class} == "svg" ]]; then 
            newname=${i%.*}$1"."${class}
            mv "${i}" "${newname}"
            echo "${i} is renamed to ${newname} successfully!"
        fi
    done
}

function tras2jpg {
    for image in *;do
        class=${i##*.}
        if [[ ${class} == "png" || ${class} == "svg" ]]; then 
            newname=${image%.*}".jpg"
            convert "${i}" "${newname}"
   	        echo "${i} is changged to jpg successfully!"
        fi
    done
}

if [ "$1" != "" ];then #判断是什么操作
    case "$1" in
        "-q")
            compress "$2"
            exit 0
            ;;
        "-r")
            resize "$2"
            exit 0
            ;;
        "-w")
            addWatermark "$2" "$3"
            exit 0
            ;;
        "-p")
            addPrefix "$2"
            exit 0
            ;;
        "-s")
            addSuffix "$2"
            exit 0
            ;;
        "-t")
            tras2jpg
            exit 0
            ;;
        "-h")
            help
            exit 0
            ;;
    esac
fi