import subprocess
import os
import logging
logging.basicConfig(format='%(asctime)s %(message)s', 
                    datefmt='%d/%m/%Y %I:%M:%S %p',
                    filename='/data/init.log',
                    level=logging.INFO)

logging.info('Initializing mumble container')

# retrieve settings

# welcome message
try:
    SERVER_TEXT = os.environ["SERVER_TEXT"]
    logging.info('SERVER_TEXT : using user provided value')
except KeyError:
    SERVER_TEXT = "Docker container"
    logging.info('SERVER_TEXT : using default value')

# root channel name
try:
    REGISTER_NAME = os.environ['REGISTER_NAME']
    logging.info('REGISTER_NAME : using user provided value')
except KeyError:    
    REGISTER_NAME = "Roooot"
    logging.info('REGISTER_NAME : using default value')

# server access password
try:
    SERVER_PASSWORD = os.environ['SERVER_PASSWORD']
    logging.info('SERVER_PASSWORD : using user provided value')
except KeyError:
    SERVER_PASSWORD = ""
    logging.info('SERVER_PASSWORD : no password required to connect to the server')

# max connected users allowed at the same time
try:
    MAX_USERS = os.environ['MAX_USERS']
    logging.info('MAX_USERS : using user provided value')
except KeyError:
    MAX_USERS = 10
    logging.info('MAX_USERS : using default value')

# max bandwith 
try:
    BANDWIDTH = os.environ["BANDWIDTH"]
    logging.info('BANDWIDTH : using user provided value')
except KeyError:
    BANDWIDTH = 72000
    logging.info('BANDWIDTH : using default value')

params = {"BANDWIDTH" : BANDWIDTH,
          "MAX_USERS" : MAX_USERS,
          "SERVER_TEXT" : SERVER_TEXT,
          "SERVER_PASSWORD" : SERVER_PASSWORD,
          "REGISTER_NAME" : REGISTER_NAME}

# ini file generation
tmpl = """
database=/data/mumble-server.sqlite
icesecretwrite=
logfile=/data/mumble-server.log
pidfile=/data/mumble-server.pid
welcometext={SERVER_TEXT}
host=0.0.0.0
port=64738
serverpassword={SERVER_PASSWORD}
bandwidth={BANDWIDTH}
users={MAX_USERS}
uname=mumble
registerName={REGISTER_NAME}
[Ice]
Ice.Warn.UnknownProperties=1
Ice.Meecho ssageSizeMax=65536

"""

# generate file content
ini = tmpl.format(SERVER_TEXT=params["SERVER_TEXT"], 
                  SERVER_PASSWORD=params["SERVER_PASSWORD"],
                  MAX_USERS=params["MAX_USERS"],
                  BANDWIDTH=params["BANDWIDTH"],
                  REGISTER_NAME=params["REGISTER_NAME"])

#Write content to the ini file
with open("/data/mumble-server.ini",'w') as f:
    f.write(ini)


#Set password if new one is provided 
try:
    supw = os.environ['SUPW']
except KeyError:
    pass
finally:
    if len(supw) > 7:
        subprocess.call(["/usr/sbin/murmurd","-ini","/data/mumble-server.ini",
                         "-supw", supw]) 

#Start mumble
subprocess.call(["supervisorctl", 
                 "-u", "mumble", 
                 "-p", "elbmum", 
                 "-c", "/data/supervisord.conf", 
                 "start", "mumble"])

