#!/usr/bin/python

import os, time, subprocess
'''
LAB: Read Chapter 4 of Learning the Bash Shell and upload two exercises to github
'''

def cutStuff():
    file = open('albums','w')
    file.write("""Depeche Mode|Speak and Spell|Mute Records|1981\n
    Depeche Mode|Some Great Reward|Mute Records|1984\n
    Depeche Mode|101|Mute Records|1989\n
    Depeche Mode|Violator|Mute Records|1990\n
    Depeche Mode|Songs of Faith and Devotion|Mute Records|1991""")
    file.close()

    print("print the years from the albums file")
    os.system('cut -f4 -d\| albums')
    print("---------------")

    print("print the years from the albums file using a variable")
    var = "4"
    os.system('cut -f ' + var + ' -d\| albums')
    print("---------------")

    print("print the users currently logged in using the who and cut commands")
    os.system("who | cut -d' ' -f1")
    print("---------------")
#cutStuff()

def mailAll():
    #not called to ensure automation of script, since this requires user input
    print("third example, send mail to all users on system (install mail if necessary)")
    os.system('sudo yum -y install mailx')
    os.system('mail $(who | cut -d' ' -f1)')
#mailAll()

def lsd (date):
    #TODO: can pass in the current date via python (try it!)
    #functions correctly based on my system at the time of this writing... lol
    print("print the files in the current directory, based on the date passed in")
    os.system('ls -l | grep -i "^.\{37\}' + date + '" | cut -c51-')
#lsd()

def pushd(new_dir):
    stack.append(new_dir)
    print('PUSHD -> ' + new_dir)
    os.chdir(new_dir)
    
def popd():
    print('POPD -> ' + stack.pop())

#rewritten in python and working now :) thx developers!
#revertdir = os.getcwd()
#stack = [os.getcwd()]
#os.system('mkdir -p i/like/icecream')
#pushd('i')
#pushd('like')
#pushd('icecream')
#popd()
#popd()    
#popd()
#os.chdir(revertdir)
#os.

'''
LAB: Complete the Cron Assignment from Class
'''
def cronMailReminder():
    #create the cron script
    #for extensibility, write the script in python's cwd
    path = os.getcwd() + '/cron.sh'
    cron_script = open(path, 'w')
    cron_script.write('([[  -z  $(who)  ]] && [[ $(cat /proc/uptime | cut -f1 -d".") -ge 3600 ]] && echo "Your server is still on... do you want to shut it down?" | mail -s "shut down your server" -r yourserver cgagno01@seattlecentral.edu  ) || echo "cron server reminder command failed."')
    cron_script.close()
    #append this line to the crontab to determine when to run cron script
    os.system('(crontab -l ; echo "0 * * * * ' + path + '")| crontab -')
    print('Cron script added for' + path)
#cronMailReminder()
'''
Create a personal git script
'''

def gitstuff():
    os.system('sudo yum -y install git; git clone https://github.com/nic-instruction/NTI-300/; echo "a clone of the NTI-300 reposatory is now sitting in this dir"; git config --global user.name "codycodes"; echo "***username configured***"; git config --global user.email codygagnon@gmail.com; echo "***email configured***"; git config --global color.ui auto; echo "helpful colors enabled"; echo "creating my own repo to pull from"; git init ~/codylinuxcode; cd ~/codylinuxcode')
    #created for proof of concept, but commented out so it could be automated
    #os.system('git pull https://github.com/codycodes/Linux-Private-Code.git')
#gitstuff()
'''
Django & Apache
LAB: Catch Up & Extra Credit (but really just catch up because I will not try to automate django polling app ;)
'''

def django():
    os.system('echo "Current python version:"; python -V')
    print("installing virtualenv so we can give django its own version of python")
    os.system('sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-r\
elease-7-8.noarch.rpm; sudo yum -y install python-pip; sudo pip install virtualenv')
    os.system('cd /opt; sudo mkdir /opt/django; sudo chown -R ec2-user /django')
    time.sleep(2)
    print('activating virtualenv')
    os.system('cd django; sudo virtualenv django-env')
    os.system('source /opt/django/django-env/bin/activate')
    print('to switch out of virtualenv, type deactivate\n now using:')
    os.system('which python')
    os.system('sudo chown -R ec2-user /opt/django')
    print('installing django')
    os.system('sudo pip install Django')
    print('django admin is version:')
    os.system('django-admin --version')
    os.system('django-admin startproject project1')
    os.system('sudo mv ' + os.getcwd() + '/project1 /opt/django')
    os.system('sudo mv ' + os.getcwd() + '/django-env /opt/django')
    os.system('sudo yum -y install tree')
    print('here\'s our new django project dir')
    os.system('tree project1')
    time.sleep(1)

    ip = subprocess.check_output("curl http://checkip.amazonaws.com", shell=True)

    f = open('/opt/django/project1/project1/settings.py','r')
    filedata = f.read()
    f.close()

    ipaddr = "ALLOWED_HOSTS = [\'" + ip.strip('\n') + "\',]"

    newdata = filedata.replace('ALLOWED_HOSTS = []', ipaddr)

    f = open('/opt/django/project1/project1/settings.py','w')
    f.write(newdata)
    f.close()
    print('Please be aware that you can only successfully access the django server by going to the IP address of your server in the browser, due to the ALLOWED_HOSTS stringin the project1.settings configuration\n Your IP Address to connect to Django web server is: ' + ip + ':8000')
    os.system('python /opt/django/project1/manage.py runserver 0.0.0.0:8000')
    time.sleep(5)
    #make it persistent (if you want)
    #os.system('sudo yum -y install screen')
    #os.system('screen')
#django()


def apache():
  print('installing apache')

  ##Usernames & passwords:
  ### user1
  ### linux

  ### user2
  ### superlinux

  os.system('sudo yum -y install httpd')

  print('enabling apache server')
  os.system('sudo systemctl enable httpd.service')
  os.system('sudo echo "test" >> /var/www/html/index.html; sudo chmod 777 /var/www/html/index.html')
  pageone = open('/var/www/html/index.html', 'w')
  pageone.write("""<html>\n<body>\n<span style="font-size: 268px; top: 1px; font-family: bam_futuraCnXBdOb; color: rgb(0, 0,\0);">HELLO, WORLD</span>\n</body>\n</html>""")
  pageone.close()
  os.system('sudo mkdir /var/www/html/pagetwo')
  # got lazy and didn't want to rewrite all the sed commands in python :P
  os.system('sudo sed -i "151s/None/AuthConfig/1" /etc/httpd/conf/httpd.conf')
  os.system('sudo sed -i \'159i <Directory "/var/www/html/pagetwo">\' /etc/httpd/conf/httpd.conf')
  os.system('sudo sed -i \'160i AllowOverride AuthConfig\' /etc/httpd/conf/httpd.conf')
  os.system('sudo sed -i \'161i </Directory>\' /etc/httpd/conf/httpd.conf')
  os.system('sudo htpasswd -ci /var/www/html/pagetwo/.htpasswd user1 <<< linux')
  os.system('sudo htpasswd -i /var/www/html/pagetwo/.htpasswd user2 <<< superlinux')
  #do this to allow python to write to the file...
  os.system('sudo echo "test" >> /var/www/html/pagetwo/.htaccess; sudo chmod 777 /var/www/html/pagetwo/.htaccess')
  htaccess = open('/var/www/html/pagetwo/.htaccess', 'w')
  htaccess.write('Authtype Basic\nAuthName "Cool teachers only! hint: users: user1, user2 passwords: linux, superlinux"\nAuthUserFile /var/www/html/pagetwo/.htpasswd\nRequire valid-user')
  htaccess.close()
  os.system('sudo chmod 644 /var/www/html/pagetwo/.htaccess')
  os.system('sudo chmod 644 /var/www/html/pagetwo/.htpasswd')

  os.system('sudo echo "test" >> /var/www/html/pagetwo/index.html; sudo chmod 777 /var/www/html/pagetwo/index.html')

  pagetwo =open('/var/www/html/pagetwo/index.html', 'w')
  pagetwo.write('<html>\n<body>\n<img src="http://i.imgur.com/WqVFA2M.png" alt="You\'ve gotta have heart!">\n</body>\n</html>')
  pagetwo.close()

  os.system('sudo service httpd restart')

  print('starting apache server')
  os.system('sudo systemctl start httpd.service')

  print('Please open a security setting for port 80 on your server')
#apache()
'''
 LAB: Critical Patches
'''

def patch():
    os.system('[ sudo yum clean all && sudo yum -y update kernel && sudo reboot ] || echo ">:O"')
#patch()
def searchpatch(CVE):
    os.system('sudo rpm -q --changelog kernel | grep ' +  CVE)
#searchpatch('CVE-2016-5195')
