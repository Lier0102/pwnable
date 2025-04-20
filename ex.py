from pwn import *
s = ssh(user='root', host='198.19.249.228', port=, password='')
p = s.process('/root/pwn//')
