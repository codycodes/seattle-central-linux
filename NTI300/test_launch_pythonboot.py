#!/usr/bin/python

import boto3, base64, pprint, time

ec2 = boto3.resource('ec2')
client = boto3.client('ec2')

amazon_image = 'ami-6f68cf0f'                                       # This will launch a red hat instance
amazon_instance = 't2.micro'                                        # we've been working with micro's, if you use Amizon Linux, you could launch a nono
amazon_pem_key = 'login home'                    # the name of the key/pem file you would like to use to access this machine
firewall_profiles = ['School/Home Access']                             # the security group name(s) you would like to use, remember, this is your firewall, make sure the ports you want open are open

print(amazon_image)
print(amazon_instance)
print(amazon_pem_key)

def launch_test_instance():

   instances = ec2.create_instances(
      ImageId = amazon_image,
      InstanceType = amazon_instance,
      MinCount=1,
      MaxCount=1,
      KeyName = amazon_pem_key,
      SecurityGroupIds = firewall_profiles,
      UserData="""#!/usr/bin/python
import os, time, subprocess
def django():
    os.system('echo "Current python version:"; python -V')
    print("installing virtualenv so we can give django its own version of python")
    os.system('rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm; yum -y install python-pip; pip install virtualenv')
    os.system('cd /opt; mkdir /opt/django; chown -R ec2-user /django')
    time.sleep(2)
    print('activating virtualenv')
    os.system('cd django; virtualenv django-env')
    os.system('source /opt/django/django-env/bin/activate')
    print('to switch out of virtualenv, type deactivate')
    print('now using:')
    os.system('which python')
    print('installing django')
    os.system('pip install Django')
    print('django admin is version:')
    os.system('django-admin --version')
    os.system('django-admin startproject project1')
    os.system('mv ' + os.getcwd() + '/project1 /opt/django')
    os.system('mv ' + os.getcwd() + '/django-env /opt/django')
    os.system('yum -y install tree')
    print('Our new django project dir:')
    os.system('tree project1')
    time.sleep(1)

    ip = subprocess.check_output("curl http://checkip.amazonaws.com", shell=True)

    f = open('/opt/django/project1/project1/settings.py','r')
    filedata = f.read()
    f.close()

    ipaddr = "ALLOWED_HOSTS = ['" + ip.rstrip() + "',]"

    newdata = filedata.replace('ALLOWED_HOSTS = []', ipaddr)

    f = open('/opt/django/project1/project1/settings.py','w')
    f.write(newdata)
    f.close()
    print('Please be aware that you can only successfully access the django server by going to the IP address of your server in the browser, due to the ALLOWED_HOSTS string in the project1.settings configuration')
    os.system('python /opt/django/project1/manage.py runserver 0.0.0.0:8000&')
    time.sleep(5)
    #use screen for persistence
    #os.system('yum -y install screen')
    #os.system('screen')
    print('Your IP Address to connect to the Django web server is: ' + ip + ':8000')
django()
"""
    )


def list_ips():
  instances = ec2.instances.filter(
      Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
  for instance in instances:
      print(instance.id, instance.public_ip_address)


def main():
    launch_test_instance()
    print('Please be aware that you can only successfully access the django server by going to the IP address of the now launching serer in the browser, due to the ALLOWED_HOSTS string in the project1.settings configuration')
    print("You will need to use the ip address of the instance that was just spun up to successfully connect to the django web server in the notation this.is.your.ip:8000. It may take a few minutes to come online!")
main()
