### If running while this in on a folder, adjust the path i.e:
```q1.asm -> 'Lista 03/q1.asm' (for all files)``` or ```cd 'Lista 03'```

### Quistion 1:
```nasm -f elf64 q1.asm && gcc -o q1 q1.o -no-pie -z execstack -lm && ./q1```
---