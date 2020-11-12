import redis
from datetime import date
r = redis.Redis(
host='localhost',
port=6379)
print("Sistema de registro de celulares")
nombre = "celular"
date=str(date.today())

while True:
    celular = input("Ingrese el celular que adquirio mas recientemente o presione enter para salir ")
    if celular == "":
        break
    else:
        r.lpush(nombre, celular+" fecha:"+date)

print('Los celulares que adquirio fueron:')
for a in r.lrange(nombre, 0, -1):
    print(str(a.decode('utf-8')))