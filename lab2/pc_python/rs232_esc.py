#!/usr/bin/env python
from serial import Serial, EIGHTBITS, PARITY_NONE, STOPBITS_ONE
from sys import argv
from string import rjust

assert len(argv) == 3
s = Serial(
    port=argv[1],
    baudrate=115200,
    bytesize=EIGHTBITS,
    parity=PARITY_NONE,
    stopbits=STOPBITS_ONE,
    xonxoff=False,
    rtscts=False
)

RSA_BIT = int(argv[2])
RSA_PACKAGE = int(RSA_BIT)/8; #every package is 8 bits 

fp_key = open('key{}.bin'.format(RSA_BIT), 'rb')
fp_enc = open('enc{}.bin'.format(RSA_BIT), 'rb')
fp_dec = open('dec{}.txt'.format(RSA_BIT), 'wb')
assert fp_key and fp_enc and fp_dec

key = fp_key.read(RSA_BIT/4) # two PACKAGE length
enc = fp_enc.read()
assert len(enc) % RSA_PACKAGE == 0

# ESC := 00000..00000 (total RSA_PACKAGE bytes)
# END := 00000..00001
RSA_ESC = rjust('\x00', RSA_PACKAGE, '\x00')
RSA_END = rjust('\x01', RSA_PACKAGE, '\x00')

s.write(key)
for i in range(0, len(enc), RSA_PACKAGE):
    if enc[i:i+RSA_PACKAGE] == RSA_ESC:
        s.write(RSA_ESC)
        s.write(RSA_ESC)
    else:
        s.write(enc[i:i+RSA_PACKAGE])
    dec = s.read(RSA_PACKAGE-1)
    fp_dec.write(dec)

s.write(RSA_ESC)
s.write(RSA_END)

fp_key.close()
fp_enc.close()
fp_dec.close()
