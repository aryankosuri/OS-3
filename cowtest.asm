
_cowtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "[prnt] v4 = %d\n", v4);
    printf(1, "=====> v1 = v4 ? %s\n", v1 == v4 ? "YES" : "NO");
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);
}

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
    printf(1, ">>>>>>>>>>>>>>>>> WITHOUT COW <<<<<<<<<<<<<<<<<<<<<<\n");
  11:	68 64 0e 00 00       	push   $0xe64
  16:	6a 01                	push   $0x1
  18:	e8 23 08 00 00       	call   840 <printf>
    enable_cow(0);
  1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  24:	e8 5a 07 00 00       	call   783 <enable_cow>
    testcase1();
  29:	e8 62 03 00 00       	call   390 <testcase1>
    testcase2();
  2e:	e8 fd 01 00 00       	call   230 <testcase2>
    testcase3();
  33:	e8 38 00 00 00       	call   70 <testcase3>

    printf(1, "\n\n>>>>>>>>>>>>>>>>> WITH COW <<<<<<<<<<<<<<<<<<<<<<\n");    enable_cow(1);
  38:	58                   	pop    %eax
  39:	5a                   	pop    %edx
  3a:	68 9c 0e 00 00       	push   $0xe9c
  3f:	6a 01                	push   $0x1
  41:	e8 fa 07 00 00       	call   840 <printf>
  46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4d:	e8 31 07 00 00       	call   783 <enable_cow>
    testcase1();
  52:	e8 39 03 00 00       	call   390 <testcase1>
    testcase2();
  57:	e8 d4 01 00 00       	call   230 <testcase2>
    testcase3();
  5c:	e8 0f 00 00 00       	call   70 <testcase3>
    exit();
  61:	e8 6d 06 00 00       	call   6d3 <exit>
  66:	66 90                	xchg   %ax,%ax
  68:	66 90                	xchg   %ax,%ax
  6a:	66 90                	xchg   %ax,%ax
  6c:	66 90                	xchg   %ax,%ax
  6e:	66 90                	xchg   %ax,%ax

00000070 <testcase3>:
void testcase3(){
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	57                   	push   %edi
  74:	56                   	push   %esi
  75:	53                   	push   %ebx
  76:	83 ec 24             	sub    $0x24,%esp
    printf(1,"\n----- Test case 3 -----\n");
  79:	68 af 0b 00 00       	push   $0xbaf
  7e:	6a 01                	push   $0x1
  80:	e8 bb 07 00 00       	call   840 <printf>
    v1 = get_free_frame_cnt();
  85:	e8 f1 06 00 00       	call   77b <get_free_frame_cnt>
    printf(1,"[prnt] v1 = %d\n", v1);
  8a:	83 c4 0c             	add    $0xc,%esp
  8d:	50                   	push   %eax
    v1 = get_free_frame_cnt();
  8e:	89 c3                	mov    %eax,%ebx
    printf(1,"[prnt] v1 = %d\n", v1);
  90:	68 c9 0b 00 00       	push   $0xbc9
  95:	6a 01                	push   $0x1
  97:	e8 a4 07 00 00       	call   840 <printf>
    if((pid = fork()) == 0)
  9c:	e8 2a 06 00 00       	call   6cb <fork>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	85 c0                	test   %eax,%eax
  a6:	0f 84 c8 00 00 00    	je     174 <testcase3+0x104>
  ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        v2 = get_free_frame_cnt();
  af:	e8 c7 06 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[prnt] v2 = %d\n", v2);
  b4:	83 ec 04             	sub    $0x4,%esp
  b7:	50                   	push   %eax
        v2 = get_free_frame_cnt();
  b8:	89 c6                	mov    %eax,%esi
        printf(1,"[prnt] v2 = %d\n", v2);
  ba:	68 1e 0c 00 00       	push   $0xc1e
  bf:	6a 01                	push   $0x1
  c1:	e8 7a 07 00 00       	call   840 <printf>
        printf(1,"[prnt] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
  c6:	83 c4 0c             	add    $0xc,%esp
        global_array[0] = 111;     
  c9:	c7 05 40 12 00 00 6f 	movl   $0x6f,0x1240
  d0:	00 00 00 
        printf(1,"[prnt] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
  d3:	6a 6f                	push   $0x6f
  d5:	68 cc 0d 00 00       	push   $0xdcc
  da:	6a 01                	push   $0x1
  dc:	e8 5f 07 00 00       	call   840 <printf>
        v3 = get_free_frame_cnt();
  e1:	e8 95 06 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[prnt] v3 = %d\n", v3);
  e6:	83 c4 0c             	add    $0xc,%esp
  e9:	50                   	push   %eax
        v3 = get_free_frame_cnt();
  ea:	89 c7                	mov    %eax,%edi
        printf(1,"[prnt] v3 = %d\n", v3);
  ec:	68 2e 0c 00 00       	push   $0xc2e
  f1:	6a 01                	push   $0x1
  f3:	e8 48 07 00 00       	call   840 <printf>
    if (wait() != pid)
  f8:	e8 de 05 00 00       	call   6db <wait>
  fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 100:	83 c4 10             	add    $0x10,%esp
 103:	39 d0                	cmp    %edx,%eax
 105:	0f 85 09 01 00 00    	jne    214 <testcase3+0x1a4>
    v7 = get_free_frame_cnt();
 10b:	e8 6b 06 00 00       	call   77b <get_free_frame_cnt>
    printf(1, "[prnt] v7 = %d\n", v7);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	50                   	push   %eax
 114:	68 4c 0c 00 00       	push   $0xc4c
 119:	6a 01                	push   $0x1
 11b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 11e:	e8 1d 07 00 00       	call   840 <printf>
    printf(1, "=====> v1 = v7 ? %s\n", v1 == v7 ? "YES" : "NO");
 123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 126:	83 c4 0c             	add    $0xc,%esp
 129:	ba ac 0b 00 00       	mov    $0xbac,%edx
 12e:	39 c3                	cmp    %eax,%ebx
 130:	b8 a8 0b 00 00       	mov    $0xba8,%eax
 135:	0f 45 c2             	cmovne %edx,%eax
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 138:	29 f3                	sub    %esi,%ebx
    printf(1, "=====> v2 - v3 = %d\n", v2 - v3);    
 13a:	29 fe                	sub    %edi,%esi
    printf(1, "=====> v1 = v7 ? %s\n", v1 == v7 ? "YES" : "NO");
 13c:	50                   	push   %eax
 13d:	68 5c 0c 00 00       	push   $0xc5c
 142:	6a 01                	push   $0x1
 144:	e8 f7 06 00 00       	call   840 <printf>
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 149:	83 c4 0c             	add    $0xc,%esp
 14c:	53                   	push   %ebx
 14d:	68 71 0c 00 00       	push   $0xc71
 152:	6a 01                	push   $0x1
 154:	e8 e7 06 00 00       	call   840 <printf>
    printf(1, "=====> v2 - v3 = %d\n", v2 - v3);    
 159:	83 c4 0c             	add    $0xc,%esp
 15c:	56                   	push   %esi
 15d:	68 86 0c 00 00       	push   $0xc86
 162:	6a 01                	push   $0x1
 164:	e8 d7 06 00 00       	call   840 <printf>
}
 169:	83 c4 10             	add    $0x10,%esp
 16c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16f:	5b                   	pop    %ebx
 170:	5e                   	pop    %esi
 171:	5f                   	pop    %edi
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
        sleep(100);
 174:	83 ec 0c             	sub    $0xc,%esp
 177:	6a 64                	push   $0x64
 179:	e8 e5 05 00 00       	call   763 <sleep>
        v4 = get_free_frame_cnt();
 17e:	e8 f8 05 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[chld] v4 = %d\n", v4);
 183:	83 c4 0c             	add    $0xc,%esp
 186:	50                   	push   %eax
 187:	68 d9 0b 00 00       	push   $0xbd9
 18c:	6a 01                	push   $0x1
 18e:	e8 ad 06 00 00       	call   840 <printf>
        printf(1,"[chld] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 193:	83 c4 0c             	add    $0xc,%esp
        global_array[0] = 222;
 196:	c7 05 40 12 00 00 de 	movl   $0xde,0x1240
 19d:	00 00 00 
        printf(1,"[chld] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 1a0:	68 de 00 00 00       	push   $0xde
 1a5:	68 40 0d 00 00       	push   $0xd40
 1aa:	6a 01                	push   $0x1
 1ac:	e8 8f 06 00 00       	call   840 <printf>
        v5 = get_free_frame_cnt();
 1b1:	e8 c5 05 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[chld] v5 = %d\n", v5);
 1b6:	83 c4 0c             	add    $0xc,%esp
 1b9:	50                   	push   %eax
        v5 = get_free_frame_cnt();
 1ba:	89 c3                	mov    %eax,%ebx
        printf(1,"[chld] v5 = %d\n", v5);
 1bc:	68 e9 0b 00 00       	push   $0xbe9
 1c1:	6a 01                	push   $0x1
 1c3:	e8 78 06 00 00       	call   840 <printf>
        printf(1,"[chld] modified two elements in the 2nd page, global_array[2047]=%d\n", global_array[2047]);
 1c8:	83 c4 0c             	add    $0xc,%esp
        global_array[2047] = 333;           
 1cb:	c7 05 3c 32 00 00 4d 	movl   $0x14d,0x323c
 1d2:	01 00 00 
        printf(1,"[chld] modified two elements in the 2nd page, global_array[2047]=%d\n", global_array[2047]);
 1d5:	68 4d 01 00 00       	push   $0x14d
 1da:	68 84 0d 00 00       	push   $0xd84
 1df:	6a 01                	push   $0x1
 1e1:	e8 5a 06 00 00       	call   840 <printf>
        v6 = get_free_frame_cnt();
 1e6:	e8 90 05 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[chld] v6 = %d\n", v6);
 1eb:	83 c4 0c             	add    $0xc,%esp
 1ee:	50                   	push   %eax
        v6 = get_free_frame_cnt();
 1ef:	89 c6                	mov    %eax,%esi
        printf(1,"[chld] v6 = %d\n", v6);
 1f1:	68 f9 0b 00 00       	push   $0xbf9
        printf(1, "=====> v5 - v6 = %d\n", v5 - v6);    
 1f6:	29 f3                	sub    %esi,%ebx
        printf(1,"[chld] v6 = %d\n", v6);
 1f8:	6a 01                	push   $0x1
 1fa:	e8 41 06 00 00       	call   840 <printf>
        printf(1, "=====> v5 - v6 = %d\n", v5 - v6);    
 1ff:	83 c4 0c             	add    $0xc,%esp
 202:	53                   	push   %ebx
 203:	68 09 0c 00 00       	push   $0xc09
 208:	6a 01                	push   $0x1
 20a:	e8 31 06 00 00       	call   840 <printf>
        exit();
 20f:	e8 bf 04 00 00       	call   6d3 <exit>
        printf(1,"wait() error!");
 214:	50                   	push   %eax
 215:	50                   	push   %eax
 216:	68 3e 0c 00 00       	push   $0xc3e
 21b:	6a 01                	push   $0x1
 21d:	e8 1e 06 00 00       	call   840 <printf>
        exit();
 222:	e8 ac 04 00 00       	call   6d3 <exit>
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax

00000230 <testcase2>:
void testcase2(){
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	53                   	push   %ebx
 236:	83 ec 14             	sub    $0x14,%esp
    printf(1,"\n----- Test case 2 -----\n");
 239:	68 9b 0c 00 00       	push   $0xc9b
 23e:	6a 01                	push   $0x1
 240:	e8 fb 05 00 00       	call   840 <printf>
    v1 = get_free_frame_cnt();
 245:	e8 31 05 00 00       	call   77b <get_free_frame_cnt>
    printf(1,"[prnt] v1 = %d\n", v1);
 24a:	83 c4 0c             	add    $0xc,%esp
 24d:	50                   	push   %eax
    v1 = get_free_frame_cnt();
 24e:	89 c3                	mov    %eax,%ebx
    printf(1,"[prnt] v1 = %d\n", v1);
 250:	68 c9 0b 00 00       	push   $0xbc9
 255:	6a 01                	push   $0x1
 257:	e8 e4 05 00 00       	call   840 <printf>
    if((pid = fork()) == 0)
 25c:	e8 6a 04 00 00       	call   6cb <fork>
 261:	83 c4 10             	add    $0x10,%esp
 264:	85 c0                	test   %eax,%eax
 266:	0f 84 b7 00 00 00    	je     323 <testcase2+0xf3>
 26c:	89 c7                	mov    %eax,%edi
        v2 = get_free_frame_cnt();
 26e:	e8 08 05 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[prnt] v2 = %d\n", v2);
 273:	83 ec 04             	sub    $0x4,%esp
 276:	50                   	push   %eax
        v2 = get_free_frame_cnt();
 277:	89 c6                	mov    %eax,%esi
        printf(1,"[prnt] v2 = %d\n", v2);
 279:	68 1e 0c 00 00       	push   $0xc1e
 27e:	6a 01                	push   $0x1
 280:	e8 bb 05 00 00       	call   840 <printf>
        printf(1,"[prnt] read global_var, global_var=%d\n", global_var);
 285:	83 c4 0c             	add    $0xc,%esp
 288:	ff 35 20 12 00 00    	pushl  0x1220
 28e:	68 3c 0e 00 00       	push   $0xe3c
 293:	6a 01                	push   $0x1
 295:	e8 a6 05 00 00       	call   840 <printf>
        v3 = get_free_frame_cnt();
 29a:	e8 dc 04 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[prnt] v3 = %d\n", v3);
 29f:	83 c4 0c             	add    $0xc,%esp
 2a2:	50                   	push   %eax
 2a3:	68 2e 0c 00 00       	push   $0xc2e
 2a8:	6a 01                	push   $0x1
 2aa:	e8 91 05 00 00       	call   840 <printf>
    if (wait() != pid)
 2af:	e8 27 04 00 00       	call   6db <wait>
 2b4:	83 c4 10             	add    $0x10,%esp
 2b7:	39 f8                	cmp    %edi,%eax
 2b9:	0f 85 b8 00 00 00    	jne    377 <testcase2+0x147>
    v6 = get_free_frame_cnt();
 2bf:	e8 b7 04 00 00       	call   77b <get_free_frame_cnt>
    printf(1, "[prnt] v6 = %d\n", v6);
 2c4:	83 ec 04             	sub    $0x4,%esp
 2c7:	50                   	push   %eax
    v6 = get_free_frame_cnt();
 2c8:	89 c7                	mov    %eax,%edi
    printf(1, "[prnt] v6 = %d\n", v6);
 2ca:	68 b5 0c 00 00       	push   $0xcb5
 2cf:	6a 01                	push   $0x1
 2d1:	e8 6a 05 00 00       	call   840 <printf>
    printf(1, "=====> v1 = v6 ? %s\n", v1 == v6 ? "YES" : "NO");
 2d6:	83 c4 0c             	add    $0xc,%esp
 2d9:	ba ac 0b 00 00       	mov    $0xbac,%edx
 2de:	39 fb                	cmp    %edi,%ebx
 2e0:	b8 a8 0b 00 00       	mov    $0xba8,%eax
 2e5:	0f 45 c2             	cmovne %edx,%eax
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 2e8:	29 f3                	sub    %esi,%ebx
    printf(1, "=====> v1 = v6 ? %s\n", v1 == v6 ? "YES" : "NO");
 2ea:	50                   	push   %eax
 2eb:	68 c5 0c 00 00       	push   $0xcc5
 2f0:	6a 01                	push   $0x1
 2f2:	e8 49 05 00 00       	call   840 <printf>
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 2f7:	83 c4 0c             	add    $0xc,%esp
 2fa:	53                   	push   %ebx
 2fb:	68 71 0c 00 00       	push   $0xc71
 300:	6a 01                	push   $0x1
 302:	e8 39 05 00 00       	call   840 <printf>
    printf(1, "=====> v4 - v5 = %d\n", v4 - v5);
 307:	83 c4 0c             	add    $0xc,%esp
 30a:	6a 00                	push   $0x0
 30c:	68 da 0c 00 00       	push   $0xcda
 311:	6a 01                	push   $0x1
 313:	e8 28 05 00 00       	call   840 <printf>
}
 318:	83 c4 10             	add    $0x10,%esp
 31b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31e:	5b                   	pop    %ebx
 31f:	5e                   	pop    %esi
 320:	5f                   	pop    %edi
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    
        sleep(100);
 323:	83 ec 0c             	sub    $0xc,%esp
 326:	6a 64                	push   $0x64
 328:	e8 36 04 00 00       	call   763 <sleep>
        v4 = get_free_frame_cnt();
 32d:	e8 49 04 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[chld] v4 = %d\n", v4);
 332:	83 c4 0c             	add    $0xc,%esp
 335:	50                   	push   %eax
 336:	68 d9 0b 00 00       	push   $0xbd9
 33b:	6a 01                	push   $0x1
 33d:	e8 fe 04 00 00       	call   840 <printf>
        printf(1,"[chld] modified global_var, global_var=%d\n", global_var);
 342:	83 c4 0c             	add    $0xc,%esp
        global_var = 100;
 345:	c7 05 20 12 00 00 64 	movl   $0x64,0x1220
 34c:	00 00 00 
        printf(1,"[chld] modified global_var, global_var=%d\n", global_var);
 34f:	6a 64                	push   $0x64
 351:	68 10 0e 00 00       	push   $0xe10
 356:	6a 01                	push   $0x1
 358:	e8 e3 04 00 00       	call   840 <printf>
        v5 = get_free_frame_cnt();
 35d:	e8 19 04 00 00       	call   77b <get_free_frame_cnt>
        printf(1,"[chld] v5 = %d\n", v5);        
 362:	83 c4 0c             	add    $0xc,%esp
 365:	50                   	push   %eax
 366:	68 e9 0b 00 00       	push   $0xbe9
 36b:	6a 01                	push   $0x1
 36d:	e8 ce 04 00 00       	call   840 <printf>
        exit();
 372:	e8 5c 03 00 00       	call   6d3 <exit>
        printf(1,"wait() error!");
 377:	50                   	push   %eax
 378:	50                   	push   %eax
 379:	68 3e 0c 00 00       	push   $0xc3e
 37e:	6a 01                	push   $0x1
 380:	e8 bb 04 00 00       	call   840 <printf>
        exit();
 385:	e8 49 03 00 00       	call   6d3 <exit>
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <testcase1>:
void testcase1(){
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 14             	sub    $0x14,%esp
    printf(1,"\n----- Test case 1 -----\n");
 399:	68 ef 0c 00 00       	push   $0xcef
 39e:	6a 01                	push   $0x1
 3a0:	e8 9b 04 00 00       	call   840 <printf>
    v1 = get_free_frame_cnt();
 3a5:	e8 d1 03 00 00       	call   77b <get_free_frame_cnt>
    printf(1,"[prnt] v1 = %d\n", v1);
 3aa:	83 c4 0c             	add    $0xc,%esp
 3ad:	50                   	push   %eax
    v1 = get_free_frame_cnt();
 3ae:	89 c3                	mov    %eax,%ebx
    printf(1,"[prnt] v1 = %d\n", v1);
 3b0:	68 c9 0b 00 00       	push   $0xbc9
 3b5:	6a 01                	push   $0x1
 3b7:	e8 84 04 00 00       	call   840 <printf>
    if((pid = fork()) == 0)
 3bc:	e8 0a 03 00 00       	call   6cb <fork>
 3c1:	83 c4 10             	add    $0x10,%esp
 3c4:	85 c0                	test   %eax,%eax
 3c6:	74 78                	je     440 <testcase1+0xb0>
 3c8:	89 c7                	mov    %eax,%edi
        v2 = get_free_frame_cnt();
 3ca:	e8 ac 03 00 00       	call   77b <get_free_frame_cnt>
        printf(1, "[prnt] v2 = %d\n", v2);
 3cf:	83 ec 04             	sub    $0x4,%esp
 3d2:	50                   	push   %eax
        v2 = get_free_frame_cnt();
 3d3:	89 c6                	mov    %eax,%esi
        printf(1, "[prnt] v2 = %d\n", v2);
 3d5:	68 1e 0c 00 00       	push   $0xc1e
 3da:	6a 01                	push   $0x1
 3dc:	e8 5f 04 00 00       	call   840 <printf>
    if (wait() != pid)
 3e1:	e8 f5 02 00 00       	call   6db <wait>
 3e6:	83 c4 10             	add    $0x10,%esp
 3e9:	39 f8                	cmp    %edi,%eax
 3eb:	75 77                	jne    464 <testcase1+0xd4>
    v4 = get_free_frame_cnt();    
 3ed:	e8 89 03 00 00       	call   77b <get_free_frame_cnt>
    printf(1, "[prnt] v4 = %d\n", v4);
 3f2:	83 ec 04             	sub    $0x4,%esp
 3f5:	50                   	push   %eax
    v4 = get_free_frame_cnt();    
 3f6:	89 c7                	mov    %eax,%edi
    printf(1, "[prnt] v4 = %d\n", v4);
 3f8:	68 19 0d 00 00       	push   $0xd19
 3fd:	6a 01                	push   $0x1
 3ff:	e8 3c 04 00 00       	call   840 <printf>
    printf(1, "=====> v1 = v4 ? %s\n", v1 == v4 ? "YES" : "NO");
 404:	83 c4 0c             	add    $0xc,%esp
 407:	ba ac 0b 00 00       	mov    $0xbac,%edx
 40c:	39 fb                	cmp    %edi,%ebx
 40e:	b8 a8 0b 00 00       	mov    $0xba8,%eax
 413:	0f 45 c2             	cmovne %edx,%eax
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);
 416:	29 f3                	sub    %esi,%ebx
    printf(1, "=====> v1 = v4 ? %s\n", v1 == v4 ? "YES" : "NO");
 418:	50                   	push   %eax
 419:	68 29 0d 00 00       	push   $0xd29
 41e:	6a 01                	push   $0x1
 420:	e8 1b 04 00 00       	call   840 <printf>
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);
 425:	83 c4 0c             	add    $0xc,%esp
 428:	53                   	push   %ebx
 429:	68 71 0c 00 00       	push   $0xc71
 42e:	6a 01                	push   $0x1
 430:	e8 0b 04 00 00       	call   840 <printf>
}
 435:	83 c4 10             	add    $0x10,%esp
 438:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43b:	5b                   	pop    %ebx
 43c:	5e                   	pop    %esi
 43d:	5f                   	pop    %edi
 43e:	5d                   	pop    %ebp
 43f:	c3                   	ret    
        sleep(100);        
 440:	83 ec 0c             	sub    $0xc,%esp
 443:	6a 64                	push   $0x64
 445:	e8 19 03 00 00       	call   763 <sleep>
        v3 = get_free_frame_cnt();
 44a:	e8 2c 03 00 00       	call   77b <get_free_frame_cnt>
        printf(1, "[chld] v3 = %d\n", v3);
 44f:	83 c4 0c             	add    $0xc,%esp
 452:	50                   	push   %eax
 453:	68 09 0d 00 00       	push   $0xd09
 458:	6a 01                	push   $0x1
 45a:	e8 e1 03 00 00       	call   840 <printf>
        exit();
 45f:	e8 6f 02 00 00       	call   6d3 <exit>
        printf(1, "wait() error!");
 464:	50                   	push   %eax
 465:	50                   	push   %eax
 466:	68 3e 0c 00 00       	push   $0xc3e
 46b:	6a 01                	push   $0x1
 46d:	e8 ce 03 00 00       	call   840 <printf>
        exit();
 472:	e8 5c 02 00 00       	call   6d3 <exit>
 477:	66 90                	xchg   %ax,%ax
 479:	66 90                	xchg   %ax,%ax
 47b:	66 90                	xchg   %ax,%ax
 47d:	66 90                	xchg   %ax,%ax
 47f:	90                   	nop

00000480 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 480:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 481:	31 c0                	xor    %eax,%eax
{
 483:	89 e5                	mov    %esp,%ebp
 485:	53                   	push   %ebx
 486:	8b 4d 08             	mov    0x8(%ebp),%ecx
 489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 490:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 494:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 497:	83 c0 01             	add    $0x1,%eax
 49a:	84 d2                	test   %dl,%dl
 49c:	75 f2                	jne    490 <strcpy+0x10>
    ;
  return os;
}
 49e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a1:	89 c8                	mov    %ecx,%eax
 4a3:	c9                   	leave  
 4a4:	c3                   	ret    
 4a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	53                   	push   %ebx
 4b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 4ba:	0f b6 01             	movzbl (%ecx),%eax
 4bd:	0f b6 1a             	movzbl (%edx),%ebx
 4c0:	84 c0                	test   %al,%al
 4c2:	75 1d                	jne    4e1 <strcmp+0x31>
 4c4:	eb 2a                	jmp    4f0 <strcmp+0x40>
 4c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
 4d0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 4d4:	83 c1 01             	add    $0x1,%ecx
 4d7:	83 c2 01             	add    $0x1,%edx
  return (uchar)*p - (uchar)*q;
 4da:	0f b6 1a             	movzbl (%edx),%ebx
  while(*p && *p == *q)
 4dd:	84 c0                	test   %al,%al
 4df:	74 0f                	je     4f0 <strcmp+0x40>
 4e1:	38 d8                	cmp    %bl,%al
 4e3:	74 eb                	je     4d0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 4e5:	29 d8                	sub    %ebx,%eax
}
 4e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ea:	c9                   	leave  
 4eb:	c3                   	ret    
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 4f2:	29 d8                	sub    %ebx,%eax
}
 4f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f7:	c9                   	leave  
 4f8:	c3                   	ret    
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000500 <strlen>:

uint
strlen(char *s)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 506:	80 3a 00             	cmpb   $0x0,(%edx)
 509:	74 15                	je     520 <strlen+0x20>
 50b:	31 c0                	xor    %eax,%eax
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	83 c0 01             	add    $0x1,%eax
 513:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 517:	89 c1                	mov    %eax,%ecx
 519:	75 f5                	jne    510 <strlen+0x10>
    ;
  return n;
}
 51b:	89 c8                	mov    %ecx,%eax
 51d:	5d                   	pop    %ebp
 51e:	c3                   	ret    
 51f:	90                   	nop
  for(n = 0; s[n]; n++)
 520:	31 c9                	xor    %ecx,%ecx
}
 522:	5d                   	pop    %ebp
 523:	89 c8                	mov    %ecx,%eax
 525:	c3                   	ret    
 526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi

00000530 <memset>:

void*
memset(void *dst, int c, uint n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 537:	8b 4d 10             	mov    0x10(%ebp),%ecx
 53a:	8b 45 0c             	mov    0xc(%ebp),%eax
 53d:	89 d7                	mov    %edx,%edi
 53f:	fc                   	cld    
 540:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 542:	8b 7d fc             	mov    -0x4(%ebp),%edi
 545:	89 d0                	mov    %edx,%eax
 547:	c9                   	leave  
 548:	c3                   	ret    
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000550 <strchr>:

char*
strchr(const char *s, char c)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 55a:	0f b6 10             	movzbl (%eax),%edx
 55d:	84 d2                	test   %dl,%dl
 55f:	75 12                	jne    573 <strchr+0x23>
 561:	eb 1d                	jmp    580 <strchr+0x30>
 563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 567:	90                   	nop
 568:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 56c:	83 c0 01             	add    $0x1,%eax
 56f:	84 d2                	test   %dl,%dl
 571:	74 0d                	je     580 <strchr+0x30>
    if(*s == c)
 573:	38 d1                	cmp    %dl,%cl
 575:	75 f1                	jne    568 <strchr+0x18>
      return (char*)s;
  return 0;
}
 577:	5d                   	pop    %ebp
 578:	c3                   	ret    
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 580:	31 c0                	xor    %eax,%eax
}
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    
 584:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop

00000590 <gets>:

char*
gets(char *buf, int max)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 595:	31 f6                	xor    %esi,%esi
{
 597:	53                   	push   %ebx
 598:	89 f3                	mov    %esi,%ebx
 59a:	83 ec 1c             	sub    $0x1c,%esp
 59d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 5a0:	eb 2f                	jmp    5d1 <gets+0x41>
 5a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 5a8:	83 ec 04             	sub    $0x4,%esp
 5ab:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5ae:	6a 01                	push   $0x1
 5b0:	50                   	push   %eax
 5b1:	6a 00                	push   $0x0
 5b3:	e8 33 01 00 00       	call   6eb <read>
    if(cc < 1)
 5b8:	83 c4 10             	add    $0x10,%esp
 5bb:	85 c0                	test   %eax,%eax
 5bd:	7e 1c                	jle    5db <gets+0x4b>
      break;
    buf[i++] = c;
 5bf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    if(c == '\n' || c == '\r')
 5c3:	83 c7 01             	add    $0x1,%edi
    buf[i++] = c;
 5c6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 5c9:	3c 0a                	cmp    $0xa,%al
 5cb:	74 23                	je     5f0 <gets+0x60>
 5cd:	3c 0d                	cmp    $0xd,%al
 5cf:	74 1f                	je     5f0 <gets+0x60>
  for(i=0; i+1 < max; ){
 5d1:	83 c3 01             	add    $0x1,%ebx
    buf[i++] = c;
 5d4:	89 fe                	mov    %edi,%esi
  for(i=0; i+1 < max; ){
 5d6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 5d9:	7c cd                	jl     5a8 <gets+0x18>
 5db:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 5e0:	c6 03 00             	movb   $0x0,(%ebx)
}
 5e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e6:	5b                   	pop    %ebx
 5e7:	5e                   	pop    %esi
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop
  buf[i] = '\0';
 5f0:	8b 75 08             	mov    0x8(%ebp),%esi
}
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 5f6:	01 de                	add    %ebx,%esi
 5f8:	89 f3                	mov    %esi,%ebx
 5fa:	c6 03 00             	movb   $0x0,(%ebx)
}
 5fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 600:	5b                   	pop    %ebx
 601:	5e                   	pop    %esi
 602:	5f                   	pop    %edi
 603:	5d                   	pop    %ebp
 604:	c3                   	ret    
 605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000610 <stat>:

int
stat(char *n, struct stat *st)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	56                   	push   %esi
 614:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 615:	83 ec 08             	sub    $0x8,%esp
 618:	6a 00                	push   $0x0
 61a:	ff 75 08             	pushl  0x8(%ebp)
 61d:	e8 f1 00 00 00       	call   713 <open>
  if(fd < 0)
 622:	83 c4 10             	add    $0x10,%esp
 625:	85 c0                	test   %eax,%eax
 627:	78 27                	js     650 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 629:	83 ec 08             	sub    $0x8,%esp
 62c:	ff 75 0c             	pushl  0xc(%ebp)
 62f:	89 c3                	mov    %eax,%ebx
 631:	50                   	push   %eax
 632:	e8 f4 00 00 00       	call   72b <fstat>
  close(fd);
 637:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 63a:	89 c6                	mov    %eax,%esi
  close(fd);
 63c:	e8 ba 00 00 00       	call   6fb <close>
  return r;
 641:	83 c4 10             	add    $0x10,%esp
}
 644:	8d 65 f8             	lea    -0x8(%ebp),%esp
 647:	89 f0                	mov    %esi,%eax
 649:	5b                   	pop    %ebx
 64a:	5e                   	pop    %esi
 64b:	5d                   	pop    %ebp
 64c:	c3                   	ret    
 64d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 650:	be ff ff ff ff       	mov    $0xffffffff,%esi
 655:	eb ed                	jmp    644 <stat+0x34>
 657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65e:	66 90                	xchg   %ax,%ax

00000660 <atoi>:

int
atoi(const char *s)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	53                   	push   %ebx
 664:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 667:	0f be 02             	movsbl (%edx),%eax
 66a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 66d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 670:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 675:	77 1e                	ja     695 <atoi+0x35>
 677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 680:	83 c2 01             	add    $0x1,%edx
 683:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 686:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 68a:	0f be 02             	movsbl (%edx),%eax
 68d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 690:	80 fb 09             	cmp    $0x9,%bl
 693:	76 eb                	jbe    680 <atoi+0x20>
  return n;
}
 695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 698:	89 c8                	mov    %ecx,%eax
 69a:	c9                   	leave  
 69b:	c3                   	ret    
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	8b 45 10             	mov    0x10(%ebp),%eax
 6a7:	8b 55 08             	mov    0x8(%ebp),%edx
 6aa:	56                   	push   %esi
 6ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6ae:	85 c0                	test   %eax,%eax
 6b0:	7e 13                	jle    6c5 <memmove+0x25>
 6b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 6b4:	89 d7                	mov    %edx,%edi
 6b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 6c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 6c1:	39 f8                	cmp    %edi,%eax
 6c3:	75 fb                	jne    6c0 <memmove+0x20>
  return vdst;
}
 6c5:	5e                   	pop    %esi
 6c6:	89 d0                	mov    %edx,%eax
 6c8:	5f                   	pop    %edi
 6c9:	5d                   	pop    %ebp
 6ca:	c3                   	ret    

000006cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6cb:	b8 01 00 00 00       	mov    $0x1,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <exit>:
SYSCALL(exit)
 6d3:	b8 02 00 00 00       	mov    $0x2,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <wait>:
SYSCALL(wait)
 6db:	b8 03 00 00 00       	mov    $0x3,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <pipe>:
SYSCALL(pipe)
 6e3:	b8 04 00 00 00       	mov    $0x4,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <read>:
SYSCALL(read)
 6eb:	b8 05 00 00 00       	mov    $0x5,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret    

000006f3 <write>:
SYSCALL(write)
 6f3:	b8 10 00 00 00       	mov    $0x10,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret    

000006fb <close>:
SYSCALL(close)
 6fb:	b8 15 00 00 00       	mov    $0x15,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret    

00000703 <kill>:
SYSCALL(kill)
 703:	b8 06 00 00 00       	mov    $0x6,%eax
 708:	cd 40                	int    $0x40
 70a:	c3                   	ret    

0000070b <exec>:
SYSCALL(exec)
 70b:	b8 07 00 00 00       	mov    $0x7,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret    

00000713 <open>:
SYSCALL(open)
 713:	b8 0f 00 00 00       	mov    $0xf,%eax
 718:	cd 40                	int    $0x40
 71a:	c3                   	ret    

0000071b <mknod>:
SYSCALL(mknod)
 71b:	b8 11 00 00 00       	mov    $0x11,%eax
 720:	cd 40                	int    $0x40
 722:	c3                   	ret    

00000723 <unlink>:
SYSCALL(unlink)
 723:	b8 12 00 00 00       	mov    $0x12,%eax
 728:	cd 40                	int    $0x40
 72a:	c3                   	ret    

0000072b <fstat>:
SYSCALL(fstat)
 72b:	b8 08 00 00 00       	mov    $0x8,%eax
 730:	cd 40                	int    $0x40
 732:	c3                   	ret    

00000733 <link>:
SYSCALL(link)
 733:	b8 13 00 00 00       	mov    $0x13,%eax
 738:	cd 40                	int    $0x40
 73a:	c3                   	ret    

0000073b <mkdir>:
SYSCALL(mkdir)
 73b:	b8 14 00 00 00       	mov    $0x14,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret    

00000743 <chdir>:
SYSCALL(chdir)
 743:	b8 09 00 00 00       	mov    $0x9,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret    

0000074b <dup>:
SYSCALL(dup)
 74b:	b8 0a 00 00 00       	mov    $0xa,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret    

00000753 <getpid>:
SYSCALL(getpid)
 753:	b8 0b 00 00 00       	mov    $0xb,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret    

0000075b <sbrk>:
SYSCALL(sbrk)
 75b:	b8 0c 00 00 00       	mov    $0xc,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret    

00000763 <sleep>:
SYSCALL(sleep)
 763:	b8 0d 00 00 00       	mov    $0xd,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret    

0000076b <uptime>:
SYSCALL(uptime)
 76b:	b8 0e 00 00 00       	mov    $0xe,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <shutdown>:
SYSCALL(shutdown)
 773:	b8 16 00 00 00       	mov    $0x16,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <get_free_frame_cnt>:
SYSCALL(get_free_frame_cnt)
 77b:	b8 17 00 00 00       	mov    $0x17,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <enable_cow>:
 783:	b8 18 00 00 00       	mov    $0x18,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    
 78b:	66 90                	xchg   %ax,%ax
 78d:	66 90                	xchg   %ax,%ax
 78f:	90                   	nop

00000790 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 3c             	sub    $0x3c,%esp
 799:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 79c:	89 d1                	mov    %edx,%ecx
{
 79e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 7a1:	85 d2                	test   %edx,%edx
 7a3:	0f 89 7f 00 00 00    	jns    828 <printint+0x98>
 7a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 7ad:	74 79                	je     828 <printint+0x98>
    neg = 1;
 7af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 7b6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 7b8:	31 db                	xor    %ebx,%ebx
 7ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 7bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 7c0:	89 c8                	mov    %ecx,%eax
 7c2:	31 d2                	xor    %edx,%edx
 7c4:	89 cf                	mov    %ecx,%edi
 7c6:	f7 75 c4             	divl   -0x3c(%ebp)
 7c9:	0f b6 92 d8 0e 00 00 	movzbl 0xed8(%edx),%edx
 7d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 7d3:	89 d8                	mov    %ebx,%eax
 7d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 7d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 7db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 7de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 7e1:	76 dd                	jbe    7c0 <printint+0x30>
  if(neg)
 7e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 7e6:	85 c9                	test   %ecx,%ecx
 7e8:	74 0c                	je     7f6 <printint+0x66>
    buf[i++] = '-';
 7ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 7ef:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 7f1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 7f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 7f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 7fd:	eb 07                	jmp    806 <printint+0x76>
 7ff:	90                   	nop
    putc(fd, buf[i]);
 800:	0f b6 13             	movzbl (%ebx),%edx
 803:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 806:	83 ec 04             	sub    $0x4,%esp
 809:	88 55 d7             	mov    %dl,-0x29(%ebp)
 80c:	6a 01                	push   $0x1
 80e:	56                   	push   %esi
 80f:	57                   	push   %edi
 810:	e8 de fe ff ff       	call   6f3 <write>
  while(--i >= 0)
 815:	83 c4 10             	add    $0x10,%esp
 818:	39 de                	cmp    %ebx,%esi
 81a:	75 e4                	jne    800 <printint+0x70>
}
 81c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 81f:	5b                   	pop    %ebx
 820:	5e                   	pop    %esi
 821:	5f                   	pop    %edi
 822:	5d                   	pop    %ebp
 823:	c3                   	ret    
 824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 828:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 82f:	eb 87                	jmp    7b8 <printint+0x28>
 831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop

00000840 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 849:	8b 75 0c             	mov    0xc(%ebp),%esi
 84c:	0f b6 1e             	movzbl (%esi),%ebx
 84f:	84 db                	test   %bl,%bl
 851:	0f 84 b8 00 00 00    	je     90f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 857:	8d 45 10             	lea    0x10(%ebp),%eax
 85a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 85d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 860:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 862:	89 45 d0             	mov    %eax,-0x30(%ebp)
 865:	eb 37                	jmp    89e <printf+0x5e>
 867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 86e:	66 90                	xchg   %ax,%ax
 870:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 873:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 878:	83 f8 25             	cmp    $0x25,%eax
 87b:	74 17                	je     894 <printf+0x54>
  write(fd, &c, 1);
 87d:	83 ec 04             	sub    $0x4,%esp
 880:	88 5d e7             	mov    %bl,-0x19(%ebp)
 883:	6a 01                	push   $0x1
 885:	57                   	push   %edi
 886:	ff 75 08             	pushl  0x8(%ebp)
 889:	e8 65 fe ff ff       	call   6f3 <write>
 88e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 891:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 894:	0f b6 1e             	movzbl (%esi),%ebx
 897:	83 c6 01             	add    $0x1,%esi
 89a:	84 db                	test   %bl,%bl
 89c:	74 71                	je     90f <printf+0xcf>
    c = fmt[i] & 0xff;
 89e:	0f be cb             	movsbl %bl,%ecx
 8a1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 8a4:	85 d2                	test   %edx,%edx
 8a6:	74 c8                	je     870 <printf+0x30>
      }
    } else if(state == '%'){
 8a8:	83 fa 25             	cmp    $0x25,%edx
 8ab:	75 e7                	jne    894 <printf+0x54>
      if(c == 'd'){
 8ad:	83 f8 64             	cmp    $0x64,%eax
 8b0:	0f 84 9a 00 00 00    	je     950 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 8b6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 8bc:	83 f9 70             	cmp    $0x70,%ecx
 8bf:	74 5f                	je     920 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 8c1:	83 f8 73             	cmp    $0x73,%eax
 8c4:	0f 84 d6 00 00 00    	je     9a0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8ca:	83 f8 63             	cmp    $0x63,%eax
 8cd:	0f 84 8d 00 00 00    	je     960 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 8d3:	83 f8 25             	cmp    $0x25,%eax
 8d6:	0f 84 b4 00 00 00    	je     990 <printf+0x150>
  write(fd, &c, 1);
 8dc:	83 ec 04             	sub    $0x4,%esp
 8df:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 8e3:	6a 01                	push   $0x1
 8e5:	57                   	push   %edi
 8e6:	ff 75 08             	pushl  0x8(%ebp)
 8e9:	e8 05 fe ff ff       	call   6f3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 8ee:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 8f1:	83 c4 0c             	add    $0xc,%esp
 8f4:	6a 01                	push   $0x1
  for(i = 0; fmt[i]; i++){
 8f6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 8f9:	57                   	push   %edi
 8fa:	ff 75 08             	pushl  0x8(%ebp)
 8fd:	e8 f1 fd ff ff       	call   6f3 <write>
  for(i = 0; fmt[i]; i++){
 902:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 906:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 909:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 90b:	84 db                	test   %bl,%bl
 90d:	75 8f                	jne    89e <printf+0x5e>
    }
  }
}
 90f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 912:	5b                   	pop    %ebx
 913:	5e                   	pop    %esi
 914:	5f                   	pop    %edi
 915:	5d                   	pop    %ebp
 916:	c3                   	ret    
 917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 920:	83 ec 0c             	sub    $0xc,%esp
 923:	b9 10 00 00 00       	mov    $0x10,%ecx
 928:	6a 00                	push   $0x0
 92a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 92d:	8b 45 08             	mov    0x8(%ebp),%eax
 930:	8b 13                	mov    (%ebx),%edx
 932:	e8 59 fe ff ff       	call   790 <printint>
        ap++;
 937:	89 d8                	mov    %ebx,%eax
 939:	83 c4 10             	add    $0x10,%esp
      state = 0;
 93c:	31 d2                	xor    %edx,%edx
        ap++;
 93e:	83 c0 04             	add    $0x4,%eax
 941:	89 45 d0             	mov    %eax,-0x30(%ebp)
 944:	e9 4b ff ff ff       	jmp    894 <printf+0x54>
 949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 950:	83 ec 0c             	sub    $0xc,%esp
 953:	b9 0a 00 00 00       	mov    $0xa,%ecx
 958:	6a 01                	push   $0x1
 95a:	eb ce                	jmp    92a <printf+0xea>
 95c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 960:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 963:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 966:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 968:	6a 01                	push   $0x1
        ap++;
 96a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 96d:	57                   	push   %edi
 96e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 971:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 974:	e8 7a fd ff ff       	call   6f3 <write>
        ap++;
 979:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 97c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 97f:	31 d2                	xor    %edx,%edx
 981:	e9 0e ff ff ff       	jmp    894 <printf+0x54>
 986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 98d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 990:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 993:	83 ec 04             	sub    $0x4,%esp
 996:	e9 59 ff ff ff       	jmp    8f4 <printf+0xb4>
 99b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 99f:	90                   	nop
        s = (char*)*ap;
 9a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 9a3:	8b 18                	mov    (%eax),%ebx
        ap++;
 9a5:	83 c0 04             	add    $0x4,%eax
 9a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 9ab:	85 db                	test   %ebx,%ebx
 9ad:	74 17                	je     9c6 <printf+0x186>
        while(*s != 0){
 9af:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 9b2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 9b4:	84 c0                	test   %al,%al
 9b6:	0f 84 d8 fe ff ff    	je     894 <printf+0x54>
 9bc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 9bf:	89 de                	mov    %ebx,%esi
 9c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 9c4:	eb 1a                	jmp    9e0 <printf+0x1a0>
          s = "(null)";
 9c6:	bb d1 0e 00 00       	mov    $0xed1,%ebx
        while(*s != 0){
 9cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 9ce:	b8 28 00 00 00       	mov    $0x28,%eax
 9d3:	89 de                	mov    %ebx,%esi
 9d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 9d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9df:	90                   	nop
  write(fd, &c, 1);
 9e0:	83 ec 04             	sub    $0x4,%esp
          s++;
 9e3:	83 c6 01             	add    $0x1,%esi
 9e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 9e9:	6a 01                	push   $0x1
 9eb:	57                   	push   %edi
 9ec:	53                   	push   %ebx
 9ed:	e8 01 fd ff ff       	call   6f3 <write>
        while(*s != 0){
 9f2:	0f b6 06             	movzbl (%esi),%eax
 9f5:	83 c4 10             	add    $0x10,%esp
 9f8:	84 c0                	test   %al,%al
 9fa:	75 e4                	jne    9e0 <printf+0x1a0>
      state = 0;
 9fc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 9ff:	31 d2                	xor    %edx,%edx
 a01:	e9 8e fe ff ff       	jmp    894 <printf+0x54>
 a06:	66 90                	xchg   %ax,%ax
 a08:	66 90                	xchg   %ax,%ax
 a0a:	66 90                	xchg   %ax,%ax
 a0c:	66 90                	xchg   %ax,%ax
 a0e:	66 90                	xchg   %ax,%ax

00000a10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a10:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a11:	a1 40 32 00 00       	mov    0x3240,%eax
{
 a16:	89 e5                	mov    %esp,%ebp
 a18:	57                   	push   %edi
 a19:	56                   	push   %esi
 a1a:	53                   	push   %ebx
 a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 a1e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a28:	89 c2                	mov    %eax,%edx
 a2a:	8b 00                	mov    (%eax),%eax
 a2c:	39 ca                	cmp    %ecx,%edx
 a2e:	73 30                	jae    a60 <free+0x50>
 a30:	39 c1                	cmp    %eax,%ecx
 a32:	72 04                	jb     a38 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a34:	39 c2                	cmp    %eax,%edx
 a36:	72 f0                	jb     a28 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a38:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a3b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a3e:	39 f8                	cmp    %edi,%eax
 a40:	74 30                	je     a72 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 a42:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 a45:	8b 42 04             	mov    0x4(%edx),%eax
 a48:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 a4b:	39 f1                	cmp    %esi,%ecx
 a4d:	74 3a                	je     a89 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 a4f:	89 0a                	mov    %ecx,(%edx)
  freep = p;
}
 a51:	5b                   	pop    %ebx
  freep = p;
 a52:	89 15 40 32 00 00    	mov    %edx,0x3240
}
 a58:	5e                   	pop    %esi
 a59:	5f                   	pop    %edi
 a5a:	5d                   	pop    %ebp
 a5b:	c3                   	ret    
 a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a60:	39 c2                	cmp    %eax,%edx
 a62:	72 c4                	jb     a28 <free+0x18>
 a64:	39 c1                	cmp    %eax,%ecx
 a66:	73 c0                	jae    a28 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 a68:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a6b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a6e:	39 f8                	cmp    %edi,%eax
 a70:	75 d0                	jne    a42 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 a72:	03 70 04             	add    0x4(%eax),%esi
 a75:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a78:	8b 02                	mov    (%edx),%eax
 a7a:	8b 00                	mov    (%eax),%eax
 a7c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 a7f:	8b 42 04             	mov    0x4(%edx),%eax
 a82:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 a85:	39 f1                	cmp    %esi,%ecx
 a87:	75 c6                	jne    a4f <free+0x3f>
    p->s.size += bp->s.size;
 a89:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 a8c:	89 15 40 32 00 00    	mov    %edx,0x3240
    p->s.size += bp->s.size;
 a92:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 a95:	8b 43 f8             	mov    -0x8(%ebx),%eax
 a98:	89 02                	mov    %eax,(%edx)
}
 a9a:	5b                   	pop    %ebx
 a9b:	5e                   	pop    %esi
 a9c:	5f                   	pop    %edi
 a9d:	5d                   	pop    %ebp
 a9e:	c3                   	ret    
 a9f:	90                   	nop

00000aa0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	57                   	push   %edi
 aa4:	56                   	push   %esi
 aa5:	53                   	push   %ebx
 aa6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 aac:	8b 3d 40 32 00 00    	mov    0x3240,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab2:	8d 70 07             	lea    0x7(%eax),%esi
 ab5:	c1 ee 03             	shr    $0x3,%esi
 ab8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 abb:	85 ff                	test   %edi,%edi
 abd:	0f 84 ad 00 00 00    	je     b70 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac3:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 ac5:	8b 48 04             	mov    0x4(%eax),%ecx
 ac8:	39 f1                	cmp    %esi,%ecx
 aca:	73 71                	jae    b3d <malloc+0x9d>
 acc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 ad2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 ad7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 ada:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 ae1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 ae4:	eb 1b                	jmp    b01 <malloc+0x61>
 ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aed:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 af2:	8b 4a 04             	mov    0x4(%edx),%ecx
 af5:	39 f1                	cmp    %esi,%ecx
 af7:	73 4f                	jae    b48 <malloc+0xa8>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 af9:	8b 3d 40 32 00 00    	mov    0x3240,%edi
 aff:	89 d0                	mov    %edx,%eax
 b01:	39 c7                	cmp    %eax,%edi
 b03:	75 eb                	jne    af0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 b05:	83 ec 0c             	sub    $0xc,%esp
 b08:	ff 75 e4             	pushl  -0x1c(%ebp)
 b0b:	e8 4b fc ff ff       	call   75b <sbrk>
  if(p == (char*)-1)
 b10:	83 c4 10             	add    $0x10,%esp
 b13:	83 f8 ff             	cmp    $0xffffffff,%eax
 b16:	74 1b                	je     b33 <malloc+0x93>
  hp->s.size = nu;
 b18:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 b1b:	83 ec 0c             	sub    $0xc,%esp
 b1e:	83 c0 08             	add    $0x8,%eax
 b21:	50                   	push   %eax
 b22:	e8 e9 fe ff ff       	call   a10 <free>
  return freep;
 b27:	a1 40 32 00 00       	mov    0x3240,%eax
      if((p = morecore(nunits)) == 0)
 b2c:	83 c4 10             	add    $0x10,%esp
 b2f:	85 c0                	test   %eax,%eax
 b31:	75 bd                	jne    af0 <malloc+0x50>
        return 0;
  }
}
 b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 b36:	31 c0                	xor    %eax,%eax
}
 b38:	5b                   	pop    %ebx
 b39:	5e                   	pop    %esi
 b3a:	5f                   	pop    %edi
 b3b:	5d                   	pop    %ebp
 b3c:	c3                   	ret    
    if(p->s.size >= nunits){
 b3d:	89 c2                	mov    %eax,%edx
 b3f:	89 f8                	mov    %edi,%eax
 b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 b48:	39 ce                	cmp    %ecx,%esi
 b4a:	74 54                	je     ba0 <malloc+0x100>
        p->s.size -= nunits;
 b4c:	29 f1                	sub    %esi,%ecx
 b4e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 b51:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 b54:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 b57:	a3 40 32 00 00       	mov    %eax,0x3240
}
 b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 b5f:	8d 42 08             	lea    0x8(%edx),%eax
}
 b62:	5b                   	pop    %ebx
 b63:	5e                   	pop    %esi
 b64:	5f                   	pop    %edi
 b65:	5d                   	pop    %ebp
 b66:	c3                   	ret    
 b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b6e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 b70:	c7 05 40 32 00 00 44 	movl   $0x3244,0x3240
 b77:	32 00 00 
    base.s.size = 0;
 b7a:	bf 44 32 00 00       	mov    $0x3244,%edi
    base.s.ptr = freep = prevp = &base;
 b7f:	c7 05 44 32 00 00 44 	movl   $0x3244,0x3244
 b86:	32 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b89:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 b8b:	c7 05 48 32 00 00 00 	movl   $0x0,0x3248
 b92:	00 00 00 
    if(p->s.size >= nunits){
 b95:	e9 32 ff ff ff       	jmp    acc <malloc+0x2c>
 b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ba0:	8b 0a                	mov    (%edx),%ecx
 ba2:	89 08                	mov    %ecx,(%eax)
 ba4:	eb b1                	jmp    b57 <malloc+0xb7>
