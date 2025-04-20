#!/bin/bash

directory_path="$1"
Ubuntu_version="$2"
debug_your_binary="$3"

directory_name=$(basename "$directory_path")

host=198.19.249.228
username=bankai

sshpass -p "$(cat ~/Documents/GitHub/pwnable/testplace_juwon/password.txt)" scp -r -o StrictHostKeyChecking=no "$directory_path" "$username"@"$host":~/pwn
echo "Success: Files copied to remote server"

sshpass -p "$(cat ~/Documents/GitHub/pwnable/testplace_juwon/password.txt)" ssh -o StrictHostKeyChecking=no "$username"@"$host" "docker cp ~/pwn/$directory_name pwn$Ubuntu_version:/root/pwn"
echo "Success: Files copied to Docker container"

sshpass -p "$(cat ~/Documents/GitHub/pwnable/testplace_juwon/password.txt)" ssh -o StrictHostKeyChecking=no "$username"@"$host" "docker start pwn$Ubuntu_version"
echo "Success: Docker container started"

sshpass -p "$Ubuntu_version" ssh -o StrictHostKeyChecking=no "root"@"$host" -p "$Ubuntu_version" "echo '$Ubuntu_version' | sudo -S sudo"
echo "Success: Password entered"

sshpass -p "$Ubuntu_version" ssh -t -o StrictHostKeyChecking=no "root"@"$host" -p "$Ubuntu_version" "
    cd '/root/pwn/$directory_name' &&
    chmod +x $debug_your_binary &&
    export LANG=C.UTF-8 &&
    gdb ./$debug_your_binary;
"

echo "from pwn import *" > ./ex.py
echo "s = ssh(user='root', host='$host', port=$Ubuntu_version, password='$Ubuntu_version')" >> ./ex.py
echo "p = s.process('/root/pwn/$directory_name/$debug_your_binary')" >> ./ex.py

echo "Success: Debugging session ended, zsh started"

sshpass -p "$Ubuntu_version" ssh -t -o StrictHostKeyChecking=no "root"@"$host" -p "$Ubuntu_version" "zsh"

exit 0