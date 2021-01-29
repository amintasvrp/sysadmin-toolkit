#!/bin/bash
# Amintas Victor - @amintasvrp
# André Matos - @andrerosamatos

args=$@
current_date=$(date "+%d-%m-%Y %H:%M:%S")

show_syntax(){
    echo "Syntax:"
    echo "userblock -block dias [-remove dias] [-out filename]"
    exit
}

get_date() {
    for term in $last_login; do
        if [[ *"$term"* =~ "-0" ||  *"$term"* =~ "-1" ]]; then
            last_login_date=$term
            return
        fi
    done
}

get_param_value() {
    has_value=false
    for arg in ${args[@]}; do
        if [[ $arg == $1 ]]; then
            has_value=true
        elif [[ $has_value == true ]]; then
            value=$arg
            return
        fi         
    done
    show_syntax
}


log_remove_user(){
	if [[ *"$args"* =~ "-out" ]]; then
        get_param_value "-out"
		output=$value
		echo "${current_date}: Usuário ${username} removido" >> $output
		echo "${current_date}: Diretório ${home} compactado em ${file_path}" >> $output
    else
		echo "Usuário ${username} removido"
		echo "Diretório ${home} compactado em ${file_path}"
    fi
}


log_block_user(){
	if [[ *"$args"* =~ "-out" ]]; then
        get_param_value "-out"
		output=$value
		echo "${current_date}: Usuário ${username} bloqueado" >> $output
    else
		echo "Usuário ${username} bloqueado"
    fi
}


remove_user(){
    home=${line[5]}
	file_date=$(date +%Y%m%d)
    file_path="/backup_usuarios/${username}_${file_date}.tar.gz"
    if [[ ! -d "/backup_usuarios" ]]; then
        mkdir /backup_usuarios
    fi
    tar -czf $file_path $home 2>/dev/null
    rm -rf $home
    userdel $username 2>/dev/null
	log_remove_user
}


check_user(){
    get_date    
    last_login_timestamp=$(date -d "$last_login_date" +%s)
    
    get_param_value "-block"
    block_timestamp=$(date -d"-$value days" +%s)
    if [[ $last_login_timestamp -le $block_timestamp ]]; then
        usermod -L $username 2>/dev/null
		log_block_user
    fi

    if [[ *"$args"* =~ "-remove" ]]; then
        get_param_value "-remove"
        remove_timestamp=$(date -d"-$value days" +%s)
        if [[ $last_login_timestamp -le $remove_timestamp ]]; then
            remove_user
        fi
    fi    
}

file_users="/etc/passwd"
while read file_line; do
    IFS=":" read -r -a line <<< "${file_line}"
    username=${line[0]}
    last_login=`last --nohostname --time-format=iso $username | head -n 1`
    if [[ ! -z "$last_login" ]]; then
        check_user
    fi

done < "$file_users"

