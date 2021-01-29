#!/bin/bash
# Amintas Victor - @amintasvrp
# André Matos - @andrerosamatos

args=$@
file=""

show_syntax(){
    echo "Syntax:"
    echo "userlist -all [-active | -nonactive] [-order] [-groups] [-dir] [-out filename]"
    echo "userlist -human [-active | -nonactive] [-order] [-groups] [-dir] [-out filename]"
    echo "userlist -user [-groups] [-dir] [-out filename]"
    exit
}

write_details(){
    is_file=false
    for arg in ${args[@]}; do
        if [[ $arg == "-out" ]]; then
            is_file=true
        elif [[ $is_file == true ]]; then
            echo $details >> $arg
            return 
        fi         
    done
    show_syntax
}

get_dir_and_size() {
    dir=${line[5]}
    if [[ *"$args"* =~ "-dir" && -d $dir ]]; then
        size_line=$(du -sh $dir 2>/dev/null)
        IFS="/" read -r -a size <<<"$size_line"
        details="${details} ${dir} ${size[0]}"
    fi
}

get_groups() {
    groups=$(id -Gn $username)
    groups_list=$(echo $groups | tr ' ' ',')
    details="${details} ${groups_list}"
}

get_details() {
    for file_line in $file; do
        IFS=":" read -r -a line <<<"${file_line}"
        IFS="," read -r -a description <<<"${line[4]}"

        username=${line[0]}
        id=${line[2]}
        name=$(echo ${description[0]} | tr ';' ' ')

        details="$id $username \"$name\""

        if [[ *"$args"* =~ "-human" && $id -lt 1000 ]]; then
            continue
        fi

        if [[ *"$args"* =~ "-active" && $(passwd $username -S | grep L) != "" ]]; then
            continue
        fi

        if [[ *"$args"* =~ "-nonactive" && $(passwd $username -S | grep L) == "" ]]; then
            continue
        fi

        get_dir_and_size

        if [[ *"$args"* =~ "-groups" ]]; then
            get_groups
        fi

        if [[ *"$args"* =~ "-out" ]]; then
            write_details
        else 
            echo $details
        fi
    done
}

get_details_by_user() {
    IFS=":" read -r -a line <<<"${file}"
    IFS="," read -r -a description <<<"${line[4]}"

    username=${line[0]}
    id=${line[2]}
    name=$(echo ${description[0]} | tr ';' ' ')

    details="$id $username \"$name\""

    if [[ $(passwd $username -S | grep L) == "" ]]; then
        details="${details} ACTIVE"
    else
        details="${details} NONACTIVE"
    fi

    get_dir_and_size

    get_groups

    if [[ *"$args"* =~ "-out" ]]; then
            write_details
        else 
            echo $details
    fi
}

# Quebra de linha são espaços e espaços são ';'
if [[ *"$args"* =~ "-all" || *"$args"* =~ "-human" ]]; then
    if [[ *"$args"* =~ "-order" ]]; then
        file=$(sort -t: -k1,1 /etc/passwd | tr ' ' ';')
    else
        file=$(cat /etc/passwd | tr ' ' ';')
    fi
    get_details
elif [[ *"$args"* =~ "-user" ]]; then
    file=$(cat /etc/passwd | grep $2)
    get_details_by_user
else
    show_syntax
fi

