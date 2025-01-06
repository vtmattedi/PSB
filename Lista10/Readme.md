### If running while this inside a folder, adjust the path i.e:
```q1.asm -> 'Lista10/q1.asm' (for each file)``` or ```cd 'Lista10'```

## Replit sucks now:
Basically, I can not use replit anymore since they made their hours cutdown on the free tier, even for leaving a tab open. So im no longer using replit. I am simply using WSL and vscode. (Which is way better) so I will no longer use ;# since just the ; highlights as a comment on my enviroment.

### GCC
This uses scanf and pritnf as externals, for this, we declare them as external in the .asm and after genereting the object with NASM, we compile it with gcc.

### Scanf Limitations
As every code, specially in assembly, there are limitations and user misusage is possibly. C's scanf has
a lot of limitations and not adhering to them will lead to undesired behaviour.

### Question 1:
compile and run the question 1 by the following command:
```nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1```
---

### Question 2:
compile and run the question 1 by the following command:
```nasm -f elf64 q2.asm && gcc -o q2 q2.o -no-pie -z execstack -lm && ./q2```
---


### Question 2:
compile and run the question 1 by the following command:
```nasm -f elf64 q3.asm && gcc -o q3 q3.o -no-pie -z execstack -lm && ./q3```
---