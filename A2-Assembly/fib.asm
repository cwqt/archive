foriv:
nop

checki:
movrw 0xd0
andw 0x01
jpz write1

movrw 0xd1
andw 0x01
jpz write2
jmp elsewrite

write1:
movw 0x01
movwr 0xd0
jmp foriv

write2:
movw 0x01
movwr 0xd1
jmp foriv

elsewrite:


