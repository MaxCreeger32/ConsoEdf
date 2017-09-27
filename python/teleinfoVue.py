#!/usr/bin/env python

#from elasticsearch import Elasticsearch
import  serial, sys, os, datetime, json

os.system('sudo stty -F /dev/ttyS0 1200 sane evenp parenb cs7 -crtscts')

SERIAL = '/dev/ttyS0'
try:
  ser = serial.Serial(
    port=SERIAL,
    baudrate = 1200,
    parity=serial.PARITY_EVEN,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.SEVENBITS,
    timeout=1)

except:
  print "Impossible d'ouvrir le port serie" + SERIAL
  print sys.exc_info()
  sys.exit(1)

# 2. Lecture d'une trame complete
compteur=0
data = {} 
ADCO ='ADCO'
while True :
	trame=ser.readline().strip()
	listeTrame = trame.split(' ')
	if len(listeTrame)>1 :
		key, value = listeTrame[0], listeTrame[1]
		print key + ":" + value
		if key == "ADCO" : 
	      		if 'ADCO' not in ADCO : break
	      		ADCO = value
			# la periode pour moi est 'HC' ou 'HP', seul les 2 1ers char sont utiles
#		elif key == "PTEC" : data['Periode'] = value[:2]
#		elif key == "HCHC" : data['IndexHCreuses'] = value
#		elif key == "HCHP" : data['IndexHPleines'] = value
#		elif key == "IINST1" : data['InstantI1'] = value
#		elif key == "IINST2" : data['InstantI2'] = value
#		elif key == "IINST3" : data['InstantI3'] = value
#		elif key == "IMAX1" : data['IMaxi1'] = value
#		elif key == "IMAX2" : data['IMaxi2'] = value
#		elif key == "IMAX3" : data['IMaxi3'] = value
#		elif key == "PAPP" : data['PuissanceApp'] = value
#		elif key == "PMAX" : data['PuissanceMax'] = value

#dateDeMesure = datetime.datetime.now()
#"dd/MM/yyyy-HH:mm"
#data['dateMesure'] = dateDeMesure.strftime("%d/%m/%Y-%H:%M")

#document = json.dumps(data)
#es = Elasticsearch('http://elastic:Cab32b79@nounours:9200')
#es.index(index='teleinfo', doc_type='conso', body=document) 

#print document

ser.close()
