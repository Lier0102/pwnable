from pwn import *
s = ssh(user='root', host='198.19.249.228', port=1804, password='1804')
p = s.process('/root/pwn//')
