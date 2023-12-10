
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	add	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	add	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	sll	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bec080e7          	jalr	-1044(ra) # 5bfc <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bda080e7          	jalr	-1062(ra) # 5bfc <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	add	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	sll	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	09250513          	add	a0,a0,146 # 60d0 <malloc+0xf4>
      46:	00006097          	auipc	ra,0x6
      4a:	ede080e7          	jalr	-290(ra) # 5f24 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b6c080e7          	jalr	-1172(ra) # 5bbc <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	add	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	add	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	add	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	add	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	07050513          	add	a0,a0,112 # 60f0 <malloc+0x114>
      88:	00006097          	auipc	ra,0x6
      8c:	e9c080e7          	jalr	-356(ra) # 5f24 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b2a080e7          	jalr	-1238(ra) # 5bbc <exit>

000000000000009a <opentest>:
{
      9a:	1101                	add	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	add	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	06050513          	add	a0,a0,96 # 6108 <malloc+0x12c>
      b0:	00006097          	auipc	ra,0x6
      b4:	b4c080e7          	jalr	-1204(ra) # 5bfc <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b28080e7          	jalr	-1240(ra) # 5be4 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	06250513          	add	a0,a0,98 # 6128 <malloc+0x14c>
      ce:	00006097          	auipc	ra,0x6
      d2:	b2e080e7          	jalr	-1234(ra) # 5bfc <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	add	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	02a50513          	add	a0,a0,42 # 6110 <malloc+0x134>
      ee:	00006097          	auipc	ra,0x6
      f2:	e36080e7          	jalr	-458(ra) # 5f24 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	ac4080e7          	jalr	-1340(ra) # 5bbc <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	03650513          	add	a0,a0,54 # 6138 <malloc+0x15c>
     10a:	00006097          	auipc	ra,0x6
     10e:	e1a080e7          	jalr	-486(ra) # 5f24 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	aa8080e7          	jalr	-1368(ra) # 5bbc <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	add	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	add	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	03450513          	add	a0,a0,52 # 6160 <malloc+0x184>
     134:	00006097          	auipc	ra,0x6
     138:	ad8080e7          	jalr	-1320(ra) # 5c0c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	02050513          	add	a0,a0,32 # 6160 <malloc+0x184>
     148:	00006097          	auipc	ra,0x6
     14c:	ab4080e7          	jalr	-1356(ra) # 5bfc <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	01c58593          	add	a1,a1,28 # 6170 <malloc+0x194>
     15c:	00006097          	auipc	ra,0x6
     160:	a80080e7          	jalr	-1408(ra) # 5bdc <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	ff850513          	add	a0,a0,-8 # 6160 <malloc+0x184>
     170:	00006097          	auipc	ra,0x6
     174:	a8c080e7          	jalr	-1396(ra) # 5bfc <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	ffc58593          	add	a1,a1,-4 # 6178 <malloc+0x19c>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a56080e7          	jalr	-1450(ra) # 5bdc <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fcc50513          	add	a0,a0,-52 # 6160 <malloc+0x184>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a70080e7          	jalr	-1424(ra) # 5c0c <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a3e080e7          	jalr	-1474(ra) # 5be4 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a34080e7          	jalr	-1484(ra) # 5be4 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	add	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	fb650513          	add	a0,a0,-74 # 6180 <malloc+0x1a4>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d52080e7          	jalr	-686(ra) # 5f24 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9e0080e7          	jalr	-1568(ra) # 5bbc <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	add	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	add	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	add	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9ec080e7          	jalr	-1556(ra) # 5bfc <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9cc080e7          	jalr	-1588(ra) # 5be4 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	add	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9c6080e7          	jalr	-1594(ra) # 5c0c <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	add	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	add	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	add	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f2c50513          	add	a0,a0,-212 # 61a8 <malloc+0x1cc>
     284:	00006097          	auipc	ra,0x6
     288:	988080e7          	jalr	-1656(ra) # 5c0c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f18a8a93          	add	s5,s5,-232 # 61a8 <malloc+0x1cc>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	add	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	add	s6,s6,457 # 31c9 <fourteen+0x1a3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	950080e7          	jalr	-1712(ra) # 5bfc <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	91e080e7          	jalr	-1762(ra) # 5bdc <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	90a080e7          	jalr	-1782(ra) # 5bdc <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	904080e7          	jalr	-1788(ra) # 5be4 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	922080e7          	jalr	-1758(ra) # 5c0c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	add	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	ea650513          	add	a0,a0,-346 # 61b8 <malloc+0x1dc>
     31a:	00006097          	auipc	ra,0x6
     31e:	c0a080e7          	jalr	-1014(ra) # 5f24 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	898080e7          	jalr	-1896(ra) # 5bbc <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	ea450513          	add	a0,a0,-348 # 61d8 <malloc+0x1fc>
     33c:	00006097          	auipc	ra,0x6
     340:	be8080e7          	jalr	-1048(ra) # 5f24 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	876080e7          	jalr	-1930(ra) # 5bbc <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	add	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	e9250513          	add	a0,a0,-366 # 61f0 <malloc+0x214>
     366:	00006097          	auipc	ra,0x6
     36a:	8a6080e7          	jalr	-1882(ra) # 5c0c <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	e7e98993          	add	s3,s3,-386 # 61f0 <malloc+0x214>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	876080e7          	jalr	-1930(ra) # 5bfc <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	844080e7          	jalr	-1980(ra) # 5bdc <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	842080e7          	jalr	-1982(ra) # 5be4 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	860080e7          	jalr	-1952(ra) # 5c0c <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e3250513          	add	a0,a0,-462 # 61f0 <malloc+0x214>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	836080e7          	jalr	-1994(ra) # 5bfc <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	da258593          	add	a1,a1,-606 # 6178 <malloc+0x19c>
     3de:	00005097          	auipc	ra,0x5
     3e2:	7fe080e7          	jalr	2046(ra) # 5bdc <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e2450513          	add	a0,a0,-476 # 6210 <malloc+0x234>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b30080e7          	jalr	-1232(ra) # 5f24 <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	7be080e7          	jalr	1982(ra) # 5bbc <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	df250513          	add	a0,a0,-526 # 61f8 <malloc+0x21c>
     40e:	00006097          	auipc	ra,0x6
     412:	b16080e7          	jalr	-1258(ra) # 5f24 <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	7a4080e7          	jalr	1956(ra) # 5bbc <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	dd850513          	add	a0,a0,-552 # 61f8 <malloc+0x21c>
     428:	00006097          	auipc	ra,0x6
     42c:	afc080e7          	jalr	-1284(ra) # 5f24 <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	78a080e7          	jalr	1930(ra) # 5bbc <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	7a8080e7          	jalr	1960(ra) # 5be4 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	dac50513          	add	a0,a0,-596 # 61f0 <malloc+0x214>
     44c:	00005097          	auipc	ra,0x5
     450:	7c0080e7          	jalr	1984(ra) # 5c0c <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	766080e7          	jalr	1894(ra) # 5bbc <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	add	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraw	a4,s1,0x1f
     482:	01b7571b          	srlw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraw	a3,a5,0x5
     48e:	0306869b          	addw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	and	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	add	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	762080e7          	jalr	1890(ra) # 5c0c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	add	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	742080e7          	jalr	1858(ra) # 5bfc <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	71e080e7          	jalr	1822(ra) # 5be4 <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraw	a4,s1,0x1f
     4ea:	01b7571b          	srlw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraw	a3,a5,0x5
     4f6:	0306869b          	addw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	and	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	add	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	6fa080e7          	jalr	1786(ra) # 5c0c <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	add	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	add	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	sll	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	cd0a0a13          	add	s4,s4,-816 # 6220 <malloc+0x244>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	69a080e7          	jalr	1690(ra) # 5bfc <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	668080e7          	jalr	1640(ra) # 5bdc <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	662080e7          	jalr	1634(ra) # 5be4 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	680080e7          	jalr	1664(ra) # 5c0c <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	642080e7          	jalr	1602(ra) # 5bdc <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	add	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	622080e7          	jalr	1570(ra) # 5bcc <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	61e080e7          	jalr	1566(ra) # 5bdc <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	616080e7          	jalr	1558(ra) # 5be4 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	60a080e7          	jalr	1546(ra) # 5be4 <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	add	s2,s2,8
     5e4:	fd040793          	add	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	add	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c2c50513          	add	a0,a0,-980 # 6228 <malloc+0x24c>
     604:	00006097          	auipc	ra,0x6
     608:	920080e7          	jalr	-1760(ra) # 5f24 <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	5ae080e7          	jalr	1454(ra) # 5bbc <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c2650513          	add	a0,a0,-986 # 6240 <malloc+0x264>
     622:	00006097          	auipc	ra,0x6
     626:	902080e7          	jalr	-1790(ra) # 5f24 <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	590080e7          	jalr	1424(ra) # 5bbc <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	c3850513          	add	a0,a0,-968 # 6270 <malloc+0x294>
     640:	00006097          	auipc	ra,0x6
     644:	8e4080e7          	jalr	-1820(ra) # 5f24 <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	572080e7          	jalr	1394(ra) # 5bbc <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	c4e50513          	add	a0,a0,-946 # 62a0 <malloc+0x2c4>
     65a:	00006097          	auipc	ra,0x6
     65e:	8ca080e7          	jalr	-1846(ra) # 5f24 <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	558080e7          	jalr	1368(ra) # 5bbc <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	c4050513          	add	a0,a0,-960 # 62b0 <malloc+0x2d4>
     678:	00006097          	auipc	ra,0x6
     67c:	8ac080e7          	jalr	-1876(ra) # 5f24 <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	53a080e7          	jalr	1338(ra) # 5bbc <exit>

000000000000068a <copyout>:
{
     68a:	711d                	add	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	f05a                	sd	s6,32(sp)
     69c:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0LL, 0x80000000LL, 0xffffffffffffffff };
     69e:	fa043423          	sd	zero,-88(s0)
     6a2:	4785                	li	a5,1
     6a4:	07fe                	sll	a5,a5,0x1f
     6a6:	faf43823          	sd	a5,-80(s0)
     6aa:	57fd                	li	a5,-1
     6ac:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6b0:	fa840913          	add	s2,s0,-88
     6b4:	fb840b13          	add	s6,s0,-72
    int fd = open("README", 0);
     6b8:	00006a17          	auipc	s4,0x6
     6bc:	c28a0a13          	add	s4,s4,-984 # 62e0 <malloc+0x304>
    n = write(fds[1], "x", 1);
     6c0:	00006a97          	auipc	s5,0x6
     6c4:	ab8a8a93          	add	s5,s5,-1352 # 6178 <malloc+0x19c>
    uint64 addr = addrs[ai];
     6c8:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6cc:	4581                	li	a1,0
     6ce:	8552                	mv	a0,s4
     6d0:	00005097          	auipc	ra,0x5
     6d4:	52c080e7          	jalr	1324(ra) # 5bfc <open>
     6d8:	84aa                	mv	s1,a0
    if(fd < 0){
     6da:	08054563          	bltz	a0,764 <copyout+0xda>
    int n = read(fd, (void*)addr, 8192);
     6de:	6609                	lui	a2,0x2
     6e0:	85ce                	mv	a1,s3
     6e2:	00005097          	auipc	ra,0x5
     6e6:	4f2080e7          	jalr	1266(ra) # 5bd4 <read>
    if(n > 0){
     6ea:	08a04a63          	bgtz	a0,77e <copyout+0xf4>
    close(fd);
     6ee:	8526                	mv	a0,s1
     6f0:	00005097          	auipc	ra,0x5
     6f4:	4f4080e7          	jalr	1268(ra) # 5be4 <close>
    if(pipe(fds) < 0){
     6f8:	fa040513          	add	a0,s0,-96
     6fc:	00005097          	auipc	ra,0x5
     700:	4d0080e7          	jalr	1232(ra) # 5bcc <pipe>
     704:	08054c63          	bltz	a0,79c <copyout+0x112>
    n = write(fds[1], "x", 1);
     708:	4605                	li	a2,1
     70a:	85d6                	mv	a1,s5
     70c:	fa442503          	lw	a0,-92(s0)
     710:	00005097          	auipc	ra,0x5
     714:	4cc080e7          	jalr	1228(ra) # 5bdc <write>
    if(n != 1){
     718:	4785                	li	a5,1
     71a:	08f51e63          	bne	a0,a5,7b6 <copyout+0x12c>
    n = read(fds[0], (void*)addr, 8192);
     71e:	6609                	lui	a2,0x2
     720:	85ce                	mv	a1,s3
     722:	fa042503          	lw	a0,-96(s0)
     726:	00005097          	auipc	ra,0x5
     72a:	4ae080e7          	jalr	1198(ra) # 5bd4 <read>
    if(n > 0){
     72e:	0aa04163          	bgtz	a0,7d0 <copyout+0x146>
    close(fds[0]);
     732:	fa042503          	lw	a0,-96(s0)
     736:	00005097          	auipc	ra,0x5
     73a:	4ae080e7          	jalr	1198(ra) # 5be4 <close>
    close(fds[1]);
     73e:	fa442503          	lw	a0,-92(s0)
     742:	00005097          	auipc	ra,0x5
     746:	4a2080e7          	jalr	1186(ra) # 5be4 <close>
  for(int ai = 0; ai < 2; ai++){
     74a:	0921                	add	s2,s2,8
     74c:	f7691ee3          	bne	s2,s6,6c8 <copyout+0x3e>
}
     750:	60e6                	ld	ra,88(sp)
     752:	6446                	ld	s0,80(sp)
     754:	64a6                	ld	s1,72(sp)
     756:	6906                	ld	s2,64(sp)
     758:	79e2                	ld	s3,56(sp)
     75a:	7a42                	ld	s4,48(sp)
     75c:	7aa2                	ld	s5,40(sp)
     75e:	7b02                	ld	s6,32(sp)
     760:	6125                	add	sp,sp,96
     762:	8082                	ret
      printf("open(README) failed\n");
     764:	00006517          	auipc	a0,0x6
     768:	b8450513          	add	a0,a0,-1148 # 62e8 <malloc+0x30c>
     76c:	00005097          	auipc	ra,0x5
     770:	7b8080e7          	jalr	1976(ra) # 5f24 <printf>
      exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	446080e7          	jalr	1094(ra) # 5bbc <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     77e:	862a                	mv	a2,a0
     780:	85ce                	mv	a1,s3
     782:	00006517          	auipc	a0,0x6
     786:	b7e50513          	add	a0,a0,-1154 # 6300 <malloc+0x324>
     78a:	00005097          	auipc	ra,0x5
     78e:	79a080e7          	jalr	1946(ra) # 5f24 <printf>
      exit(1);
     792:	4505                	li	a0,1
     794:	00005097          	auipc	ra,0x5
     798:	428080e7          	jalr	1064(ra) # 5bbc <exit>
      printf("pipe() failed\n");
     79c:	00006517          	auipc	a0,0x6
     7a0:	b0450513          	add	a0,a0,-1276 # 62a0 <malloc+0x2c4>
     7a4:	00005097          	auipc	ra,0x5
     7a8:	780080e7          	jalr	1920(ra) # 5f24 <printf>
      exit(1);
     7ac:	4505                	li	a0,1
     7ae:	00005097          	auipc	ra,0x5
     7b2:	40e080e7          	jalr	1038(ra) # 5bbc <exit>
      printf("pipe write failed\n");
     7b6:	00006517          	auipc	a0,0x6
     7ba:	b7a50513          	add	a0,a0,-1158 # 6330 <malloc+0x354>
     7be:	00005097          	auipc	ra,0x5
     7c2:	766080e7          	jalr	1894(ra) # 5f24 <printf>
      exit(1);
     7c6:	4505                	li	a0,1
     7c8:	00005097          	auipc	ra,0x5
     7cc:	3f4080e7          	jalr	1012(ra) # 5bbc <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7d0:	862a                	mv	a2,a0
     7d2:	85ce                	mv	a1,s3
     7d4:	00006517          	auipc	a0,0x6
     7d8:	b7450513          	add	a0,a0,-1164 # 6348 <malloc+0x36c>
     7dc:	00005097          	auipc	ra,0x5
     7e0:	748080e7          	jalr	1864(ra) # 5f24 <printf>
      exit(1);
     7e4:	4505                	li	a0,1
     7e6:	00005097          	auipc	ra,0x5
     7ea:	3d6080e7          	jalr	982(ra) # 5bbc <exit>

00000000000007ee <truncate1>:
{
     7ee:	711d                	add	sp,sp,-96
     7f0:	ec86                	sd	ra,88(sp)
     7f2:	e8a2                	sd	s0,80(sp)
     7f4:	e4a6                	sd	s1,72(sp)
     7f6:	e0ca                	sd	s2,64(sp)
     7f8:	fc4e                	sd	s3,56(sp)
     7fa:	f852                	sd	s4,48(sp)
     7fc:	f456                	sd	s5,40(sp)
     7fe:	1080                	add	s0,sp,96
     800:	8aaa                	mv	s5,a0
  unlink("truncfile");
     802:	00006517          	auipc	a0,0x6
     806:	95e50513          	add	a0,a0,-1698 # 6160 <malloc+0x184>
     80a:	00005097          	auipc	ra,0x5
     80e:	402080e7          	jalr	1026(ra) # 5c0c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     812:	60100593          	li	a1,1537
     816:	00006517          	auipc	a0,0x6
     81a:	94a50513          	add	a0,a0,-1718 # 6160 <malloc+0x184>
     81e:	00005097          	auipc	ra,0x5
     822:	3de080e7          	jalr	990(ra) # 5bfc <open>
     826:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     828:	4611                	li	a2,4
     82a:	00006597          	auipc	a1,0x6
     82e:	94658593          	add	a1,a1,-1722 # 6170 <malloc+0x194>
     832:	00005097          	auipc	ra,0x5
     836:	3aa080e7          	jalr	938(ra) # 5bdc <write>
  close(fd1);
     83a:	8526                	mv	a0,s1
     83c:	00005097          	auipc	ra,0x5
     840:	3a8080e7          	jalr	936(ra) # 5be4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     844:	4581                	li	a1,0
     846:	00006517          	auipc	a0,0x6
     84a:	91a50513          	add	a0,a0,-1766 # 6160 <malloc+0x184>
     84e:	00005097          	auipc	ra,0x5
     852:	3ae080e7          	jalr	942(ra) # 5bfc <open>
     856:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     858:	02000613          	li	a2,32
     85c:	fa040593          	add	a1,s0,-96
     860:	00005097          	auipc	ra,0x5
     864:	374080e7          	jalr	884(ra) # 5bd4 <read>
  if(n != 4){
     868:	4791                	li	a5,4
     86a:	0cf51e63          	bne	a0,a5,946 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     86e:	40100593          	li	a1,1025
     872:	00006517          	auipc	a0,0x6
     876:	8ee50513          	add	a0,a0,-1810 # 6160 <malloc+0x184>
     87a:	00005097          	auipc	ra,0x5
     87e:	382080e7          	jalr	898(ra) # 5bfc <open>
     882:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     884:	4581                	li	a1,0
     886:	00006517          	auipc	a0,0x6
     88a:	8da50513          	add	a0,a0,-1830 # 6160 <malloc+0x184>
     88e:	00005097          	auipc	ra,0x5
     892:	36e080e7          	jalr	878(ra) # 5bfc <open>
     896:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     898:	02000613          	li	a2,32
     89c:	fa040593          	add	a1,s0,-96
     8a0:	00005097          	auipc	ra,0x5
     8a4:	334080e7          	jalr	820(ra) # 5bd4 <read>
     8a8:	8a2a                	mv	s4,a0
  if(n != 0){
     8aa:	ed4d                	bnez	a0,964 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8ac:	02000613          	li	a2,32
     8b0:	fa040593          	add	a1,s0,-96
     8b4:	8526                	mv	a0,s1
     8b6:	00005097          	auipc	ra,0x5
     8ba:	31e080e7          	jalr	798(ra) # 5bd4 <read>
     8be:	8a2a                	mv	s4,a0
  if(n != 0){
     8c0:	e971                	bnez	a0,994 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8c2:	4619                	li	a2,6
     8c4:	00006597          	auipc	a1,0x6
     8c8:	b1458593          	add	a1,a1,-1260 # 63d8 <malloc+0x3fc>
     8cc:	854e                	mv	a0,s3
     8ce:	00005097          	auipc	ra,0x5
     8d2:	30e080e7          	jalr	782(ra) # 5bdc <write>
  n = read(fd3, buf, sizeof(buf));
     8d6:	02000613          	li	a2,32
     8da:	fa040593          	add	a1,s0,-96
     8de:	854a                	mv	a0,s2
     8e0:	00005097          	auipc	ra,0x5
     8e4:	2f4080e7          	jalr	756(ra) # 5bd4 <read>
  if(n != 6){
     8e8:	4799                	li	a5,6
     8ea:	0cf51d63          	bne	a0,a5,9c4 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8ee:	02000613          	li	a2,32
     8f2:	fa040593          	add	a1,s0,-96
     8f6:	8526                	mv	a0,s1
     8f8:	00005097          	auipc	ra,0x5
     8fc:	2dc080e7          	jalr	732(ra) # 5bd4 <read>
  if(n != 2){
     900:	4789                	li	a5,2
     902:	0ef51063          	bne	a0,a5,9e2 <truncate1+0x1f4>
  unlink("truncfile");
     906:	00006517          	auipc	a0,0x6
     90a:	85a50513          	add	a0,a0,-1958 # 6160 <malloc+0x184>
     90e:	00005097          	auipc	ra,0x5
     912:	2fe080e7          	jalr	766(ra) # 5c0c <unlink>
  close(fd1);
     916:	854e                	mv	a0,s3
     918:	00005097          	auipc	ra,0x5
     91c:	2cc080e7          	jalr	716(ra) # 5be4 <close>
  close(fd2);
     920:	8526                	mv	a0,s1
     922:	00005097          	auipc	ra,0x5
     926:	2c2080e7          	jalr	706(ra) # 5be4 <close>
  close(fd3);
     92a:	854a                	mv	a0,s2
     92c:	00005097          	auipc	ra,0x5
     930:	2b8080e7          	jalr	696(ra) # 5be4 <close>
}
     934:	60e6                	ld	ra,88(sp)
     936:	6446                	ld	s0,80(sp)
     938:	64a6                	ld	s1,72(sp)
     93a:	6906                	ld	s2,64(sp)
     93c:	79e2                	ld	s3,56(sp)
     93e:	7a42                	ld	s4,48(sp)
     940:	7aa2                	ld	s5,40(sp)
     942:	6125                	add	sp,sp,96
     944:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     946:	862a                	mv	a2,a0
     948:	85d6                	mv	a1,s5
     94a:	00006517          	auipc	a0,0x6
     94e:	a2e50513          	add	a0,a0,-1490 # 6378 <malloc+0x39c>
     952:	00005097          	auipc	ra,0x5
     956:	5d2080e7          	jalr	1490(ra) # 5f24 <printf>
    exit(1);
     95a:	4505                	li	a0,1
     95c:	00005097          	auipc	ra,0x5
     960:	260080e7          	jalr	608(ra) # 5bbc <exit>
    printf("aaa fd3=%d\n", fd3);
     964:	85ca                	mv	a1,s2
     966:	00006517          	auipc	a0,0x6
     96a:	a3250513          	add	a0,a0,-1486 # 6398 <malloc+0x3bc>
     96e:	00005097          	auipc	ra,0x5
     972:	5b6080e7          	jalr	1462(ra) # 5f24 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     976:	8652                	mv	a2,s4
     978:	85d6                	mv	a1,s5
     97a:	00006517          	auipc	a0,0x6
     97e:	a2e50513          	add	a0,a0,-1490 # 63a8 <malloc+0x3cc>
     982:	00005097          	auipc	ra,0x5
     986:	5a2080e7          	jalr	1442(ra) # 5f24 <printf>
    exit(1);
     98a:	4505                	li	a0,1
     98c:	00005097          	auipc	ra,0x5
     990:	230080e7          	jalr	560(ra) # 5bbc <exit>
    printf("bbb fd2=%d\n", fd2);
     994:	85a6                	mv	a1,s1
     996:	00006517          	auipc	a0,0x6
     99a:	a3250513          	add	a0,a0,-1486 # 63c8 <malloc+0x3ec>
     99e:	00005097          	auipc	ra,0x5
     9a2:	586080e7          	jalr	1414(ra) # 5f24 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a6:	8652                	mv	a2,s4
     9a8:	85d6                	mv	a1,s5
     9aa:	00006517          	auipc	a0,0x6
     9ae:	9fe50513          	add	a0,a0,-1538 # 63a8 <malloc+0x3cc>
     9b2:	00005097          	auipc	ra,0x5
     9b6:	572080e7          	jalr	1394(ra) # 5f24 <printf>
    exit(1);
     9ba:	4505                	li	a0,1
     9bc:	00005097          	auipc	ra,0x5
     9c0:	200080e7          	jalr	512(ra) # 5bbc <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9c4:	862a                	mv	a2,a0
     9c6:	85d6                	mv	a1,s5
     9c8:	00006517          	auipc	a0,0x6
     9cc:	a1850513          	add	a0,a0,-1512 # 63e0 <malloc+0x404>
     9d0:	00005097          	auipc	ra,0x5
     9d4:	554080e7          	jalr	1364(ra) # 5f24 <printf>
    exit(1);
     9d8:	4505                	li	a0,1
     9da:	00005097          	auipc	ra,0x5
     9de:	1e2080e7          	jalr	482(ra) # 5bbc <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9e2:	862a                	mv	a2,a0
     9e4:	85d6                	mv	a1,s5
     9e6:	00006517          	auipc	a0,0x6
     9ea:	a1a50513          	add	a0,a0,-1510 # 6400 <malloc+0x424>
     9ee:	00005097          	auipc	ra,0x5
     9f2:	536080e7          	jalr	1334(ra) # 5f24 <printf>
    exit(1);
     9f6:	4505                	li	a0,1
     9f8:	00005097          	auipc	ra,0x5
     9fc:	1c4080e7          	jalr	452(ra) # 5bbc <exit>

0000000000000a00 <writetest>:
{
     a00:	7139                	add	sp,sp,-64
     a02:	fc06                	sd	ra,56(sp)
     a04:	f822                	sd	s0,48(sp)
     a06:	f426                	sd	s1,40(sp)
     a08:	f04a                	sd	s2,32(sp)
     a0a:	ec4e                	sd	s3,24(sp)
     a0c:	e852                	sd	s4,16(sp)
     a0e:	e456                	sd	s5,8(sp)
     a10:	e05a                	sd	s6,0(sp)
     a12:	0080                	add	s0,sp,64
     a14:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a16:	20200593          	li	a1,514
     a1a:	00006517          	auipc	a0,0x6
     a1e:	a0650513          	add	a0,a0,-1530 # 6420 <malloc+0x444>
     a22:	00005097          	auipc	ra,0x5
     a26:	1da080e7          	jalr	474(ra) # 5bfc <open>
  if(fd < 0){
     a2a:	0a054d63          	bltz	a0,ae4 <writetest+0xe4>
     a2e:	892a                	mv	s2,a0
     a30:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a32:	00006997          	auipc	s3,0x6
     a36:	a1698993          	add	s3,s3,-1514 # 6448 <malloc+0x46c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a3a:	00006a97          	auipc	s5,0x6
     a3e:	a46a8a93          	add	s5,s5,-1466 # 6480 <malloc+0x4a4>
  for(i = 0; i < N; i++){
     a42:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a46:	4629                	li	a2,10
     a48:	85ce                	mv	a1,s3
     a4a:	854a                	mv	a0,s2
     a4c:	00005097          	auipc	ra,0x5
     a50:	190080e7          	jalr	400(ra) # 5bdc <write>
     a54:	47a9                	li	a5,10
     a56:	0af51563          	bne	a0,a5,b00 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a5a:	4629                	li	a2,10
     a5c:	85d6                	mv	a1,s5
     a5e:	854a                	mv	a0,s2
     a60:	00005097          	auipc	ra,0x5
     a64:	17c080e7          	jalr	380(ra) # 5bdc <write>
     a68:	47a9                	li	a5,10
     a6a:	0af51a63          	bne	a0,a5,b1e <writetest+0x11e>
  for(i = 0; i < N; i++){
     a6e:	2485                	addw	s1,s1,1
     a70:	fd449be3          	bne	s1,s4,a46 <writetest+0x46>
  close(fd);
     a74:	854a                	mv	a0,s2
     a76:	00005097          	auipc	ra,0x5
     a7a:	16e080e7          	jalr	366(ra) # 5be4 <close>
  fd = open("small", O_RDONLY);
     a7e:	4581                	li	a1,0
     a80:	00006517          	auipc	a0,0x6
     a84:	9a050513          	add	a0,a0,-1632 # 6420 <malloc+0x444>
     a88:	00005097          	auipc	ra,0x5
     a8c:	174080e7          	jalr	372(ra) # 5bfc <open>
     a90:	84aa                	mv	s1,a0
  if(fd < 0){
     a92:	0a054563          	bltz	a0,b3c <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a96:	7d000613          	li	a2,2000
     a9a:	0000c597          	auipc	a1,0xc
     a9e:	1de58593          	add	a1,a1,478 # cc78 <buf>
     aa2:	00005097          	auipc	ra,0x5
     aa6:	132080e7          	jalr	306(ra) # 5bd4 <read>
  if(i != N*SZ*2){
     aaa:	7d000793          	li	a5,2000
     aae:	0af51563          	bne	a0,a5,b58 <writetest+0x158>
  close(fd);
     ab2:	8526                	mv	a0,s1
     ab4:	00005097          	auipc	ra,0x5
     ab8:	130080e7          	jalr	304(ra) # 5be4 <close>
  if(unlink("small") < 0){
     abc:	00006517          	auipc	a0,0x6
     ac0:	96450513          	add	a0,a0,-1692 # 6420 <malloc+0x444>
     ac4:	00005097          	auipc	ra,0x5
     ac8:	148080e7          	jalr	328(ra) # 5c0c <unlink>
     acc:	0a054463          	bltz	a0,b74 <writetest+0x174>
}
     ad0:	70e2                	ld	ra,56(sp)
     ad2:	7442                	ld	s0,48(sp)
     ad4:	74a2                	ld	s1,40(sp)
     ad6:	7902                	ld	s2,32(sp)
     ad8:	69e2                	ld	s3,24(sp)
     ada:	6a42                	ld	s4,16(sp)
     adc:	6aa2                	ld	s5,8(sp)
     ade:	6b02                	ld	s6,0(sp)
     ae0:	6121                	add	sp,sp,64
     ae2:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ae4:	85da                	mv	a1,s6
     ae6:	00006517          	auipc	a0,0x6
     aea:	94250513          	add	a0,a0,-1726 # 6428 <malloc+0x44c>
     aee:	00005097          	auipc	ra,0x5
     af2:	436080e7          	jalr	1078(ra) # 5f24 <printf>
    exit(1);
     af6:	4505                	li	a0,1
     af8:	00005097          	auipc	ra,0x5
     afc:	0c4080e7          	jalr	196(ra) # 5bbc <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b00:	8626                	mv	a2,s1
     b02:	85da                	mv	a1,s6
     b04:	00006517          	auipc	a0,0x6
     b08:	95450513          	add	a0,a0,-1708 # 6458 <malloc+0x47c>
     b0c:	00005097          	auipc	ra,0x5
     b10:	418080e7          	jalr	1048(ra) # 5f24 <printf>
      exit(1);
     b14:	4505                	li	a0,1
     b16:	00005097          	auipc	ra,0x5
     b1a:	0a6080e7          	jalr	166(ra) # 5bbc <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00006517          	auipc	a0,0x6
     b26:	96e50513          	add	a0,a0,-1682 # 6490 <malloc+0x4b4>
     b2a:	00005097          	auipc	ra,0x5
     b2e:	3fa080e7          	jalr	1018(ra) # 5f24 <printf>
      exit(1);
     b32:	4505                	li	a0,1
     b34:	00005097          	auipc	ra,0x5
     b38:	088080e7          	jalr	136(ra) # 5bbc <exit>
    printf("%s: error: open small failed!\n", s);
     b3c:	85da                	mv	a1,s6
     b3e:	00006517          	auipc	a0,0x6
     b42:	97a50513          	add	a0,a0,-1670 # 64b8 <malloc+0x4dc>
     b46:	00005097          	auipc	ra,0x5
     b4a:	3de080e7          	jalr	990(ra) # 5f24 <printf>
    exit(1);
     b4e:	4505                	li	a0,1
     b50:	00005097          	auipc	ra,0x5
     b54:	06c080e7          	jalr	108(ra) # 5bbc <exit>
    printf("%s: read failed\n", s);
     b58:	85da                	mv	a1,s6
     b5a:	00006517          	auipc	a0,0x6
     b5e:	97e50513          	add	a0,a0,-1666 # 64d8 <malloc+0x4fc>
     b62:	00005097          	auipc	ra,0x5
     b66:	3c2080e7          	jalr	962(ra) # 5f24 <printf>
    exit(1);
     b6a:	4505                	li	a0,1
     b6c:	00005097          	auipc	ra,0x5
     b70:	050080e7          	jalr	80(ra) # 5bbc <exit>
    printf("%s: unlink small failed\n", s);
     b74:	85da                	mv	a1,s6
     b76:	00006517          	auipc	a0,0x6
     b7a:	97a50513          	add	a0,a0,-1670 # 64f0 <malloc+0x514>
     b7e:	00005097          	auipc	ra,0x5
     b82:	3a6080e7          	jalr	934(ra) # 5f24 <printf>
    exit(1);
     b86:	4505                	li	a0,1
     b88:	00005097          	auipc	ra,0x5
     b8c:	034080e7          	jalr	52(ra) # 5bbc <exit>

0000000000000b90 <writebig>:
{
     b90:	7139                	add	sp,sp,-64
     b92:	fc06                	sd	ra,56(sp)
     b94:	f822                	sd	s0,48(sp)
     b96:	f426                	sd	s1,40(sp)
     b98:	f04a                	sd	s2,32(sp)
     b9a:	ec4e                	sd	s3,24(sp)
     b9c:	e852                	sd	s4,16(sp)
     b9e:	e456                	sd	s5,8(sp)
     ba0:	0080                	add	s0,sp,64
     ba2:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     ba4:	20200593          	li	a1,514
     ba8:	00006517          	auipc	a0,0x6
     bac:	96850513          	add	a0,a0,-1688 # 6510 <malloc+0x534>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	04c080e7          	jalr	76(ra) # 5bfc <open>
     bb8:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bba:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bbc:	0000c917          	auipc	s2,0xc
     bc0:	0bc90913          	add	s2,s2,188 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bc4:	10c00a13          	li	s4,268
  if(fd < 0){
     bc8:	06054c63          	bltz	a0,c40 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bcc:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bd0:	40000613          	li	a2,1024
     bd4:	85ca                	mv	a1,s2
     bd6:	854e                	mv	a0,s3
     bd8:	00005097          	auipc	ra,0x5
     bdc:	004080e7          	jalr	4(ra) # 5bdc <write>
     be0:	40000793          	li	a5,1024
     be4:	06f51c63          	bne	a0,a5,c5c <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be8:	2485                	addw	s1,s1,1
     bea:	ff4491e3          	bne	s1,s4,bcc <writebig+0x3c>
  close(fd);
     bee:	854e                	mv	a0,s3
     bf0:	00005097          	auipc	ra,0x5
     bf4:	ff4080e7          	jalr	-12(ra) # 5be4 <close>
  fd = open("big", O_RDONLY);
     bf8:	4581                	li	a1,0
     bfa:	00006517          	auipc	a0,0x6
     bfe:	91650513          	add	a0,a0,-1770 # 6510 <malloc+0x534>
     c02:	00005097          	auipc	ra,0x5
     c06:	ffa080e7          	jalr	-6(ra) # 5bfc <open>
     c0a:	89aa                	mv	s3,a0
  n = 0;
     c0c:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c0e:	0000c917          	auipc	s2,0xc
     c12:	06a90913          	add	s2,s2,106 # cc78 <buf>
  if(fd < 0){
     c16:	06054263          	bltz	a0,c7a <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c1a:	40000613          	li	a2,1024
     c1e:	85ca                	mv	a1,s2
     c20:	854e                	mv	a0,s3
     c22:	00005097          	auipc	ra,0x5
     c26:	fb2080e7          	jalr	-78(ra) # 5bd4 <read>
    if(i == 0){
     c2a:	c535                	beqz	a0,c96 <writebig+0x106>
    } else if(i != BSIZE){
     c2c:	40000793          	li	a5,1024
     c30:	0af51f63          	bne	a0,a5,cee <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c34:	00092683          	lw	a3,0(s2)
     c38:	0c969a63          	bne	a3,s1,d0c <writebig+0x17c>
    n++;
     c3c:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c3e:	bff1                	j	c1a <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c40:	85d6                	mv	a1,s5
     c42:	00006517          	auipc	a0,0x6
     c46:	8d650513          	add	a0,a0,-1834 # 6518 <malloc+0x53c>
     c4a:	00005097          	auipc	ra,0x5
     c4e:	2da080e7          	jalr	730(ra) # 5f24 <printf>
    exit(1);
     c52:	4505                	li	a0,1
     c54:	00005097          	auipc	ra,0x5
     c58:	f68080e7          	jalr	-152(ra) # 5bbc <exit>
      printf("%s: error: write big file failed\n", s, i);
     c5c:	8626                	mv	a2,s1
     c5e:	85d6                	mv	a1,s5
     c60:	00006517          	auipc	a0,0x6
     c64:	8d850513          	add	a0,a0,-1832 # 6538 <malloc+0x55c>
     c68:	00005097          	auipc	ra,0x5
     c6c:	2bc080e7          	jalr	700(ra) # 5f24 <printf>
      exit(1);
     c70:	4505                	li	a0,1
     c72:	00005097          	auipc	ra,0x5
     c76:	f4a080e7          	jalr	-182(ra) # 5bbc <exit>
    printf("%s: error: open big failed!\n", s);
     c7a:	85d6                	mv	a1,s5
     c7c:	00006517          	auipc	a0,0x6
     c80:	8e450513          	add	a0,a0,-1820 # 6560 <malloc+0x584>
     c84:	00005097          	auipc	ra,0x5
     c88:	2a0080e7          	jalr	672(ra) # 5f24 <printf>
    exit(1);
     c8c:	4505                	li	a0,1
     c8e:	00005097          	auipc	ra,0x5
     c92:	f2e080e7          	jalr	-210(ra) # 5bbc <exit>
      if(n == MAXFILE - 1){
     c96:	10b00793          	li	a5,267
     c9a:	02f48a63          	beq	s1,a5,cce <writebig+0x13e>
  close(fd);
     c9e:	854e                	mv	a0,s3
     ca0:	00005097          	auipc	ra,0x5
     ca4:	f44080e7          	jalr	-188(ra) # 5be4 <close>
  if(unlink("big") < 0){
     ca8:	00006517          	auipc	a0,0x6
     cac:	86850513          	add	a0,a0,-1944 # 6510 <malloc+0x534>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	f5c080e7          	jalr	-164(ra) # 5c0c <unlink>
     cb8:	06054963          	bltz	a0,d2a <writebig+0x19a>
}
     cbc:	70e2                	ld	ra,56(sp)
     cbe:	7442                	ld	s0,48(sp)
     cc0:	74a2                	ld	s1,40(sp)
     cc2:	7902                	ld	s2,32(sp)
     cc4:	69e2                	ld	s3,24(sp)
     cc6:	6a42                	ld	s4,16(sp)
     cc8:	6aa2                	ld	s5,8(sp)
     cca:	6121                	add	sp,sp,64
     ccc:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cce:	10b00613          	li	a2,267
     cd2:	85d6                	mv	a1,s5
     cd4:	00006517          	auipc	a0,0x6
     cd8:	8ac50513          	add	a0,a0,-1876 # 6580 <malloc+0x5a4>
     cdc:	00005097          	auipc	ra,0x5
     ce0:	248080e7          	jalr	584(ra) # 5f24 <printf>
        exit(1);
     ce4:	4505                	li	a0,1
     ce6:	00005097          	auipc	ra,0x5
     cea:	ed6080e7          	jalr	-298(ra) # 5bbc <exit>
      printf("%s: read failed %d\n", s, i);
     cee:	862a                	mv	a2,a0
     cf0:	85d6                	mv	a1,s5
     cf2:	00006517          	auipc	a0,0x6
     cf6:	8b650513          	add	a0,a0,-1866 # 65a8 <malloc+0x5cc>
     cfa:	00005097          	auipc	ra,0x5
     cfe:	22a080e7          	jalr	554(ra) # 5f24 <printf>
      exit(1);
     d02:	4505                	li	a0,1
     d04:	00005097          	auipc	ra,0x5
     d08:	eb8080e7          	jalr	-328(ra) # 5bbc <exit>
      printf("%s: read content of block %d is %d\n", s,
     d0c:	8626                	mv	a2,s1
     d0e:	85d6                	mv	a1,s5
     d10:	00006517          	auipc	a0,0x6
     d14:	8b050513          	add	a0,a0,-1872 # 65c0 <malloc+0x5e4>
     d18:	00005097          	auipc	ra,0x5
     d1c:	20c080e7          	jalr	524(ra) # 5f24 <printf>
      exit(1);
     d20:	4505                	li	a0,1
     d22:	00005097          	auipc	ra,0x5
     d26:	e9a080e7          	jalr	-358(ra) # 5bbc <exit>
    printf("%s: unlink big failed\n", s);
     d2a:	85d6                	mv	a1,s5
     d2c:	00006517          	auipc	a0,0x6
     d30:	8bc50513          	add	a0,a0,-1860 # 65e8 <malloc+0x60c>
     d34:	00005097          	auipc	ra,0x5
     d38:	1f0080e7          	jalr	496(ra) # 5f24 <printf>
    exit(1);
     d3c:	4505                	li	a0,1
     d3e:	00005097          	auipc	ra,0x5
     d42:	e7e080e7          	jalr	-386(ra) # 5bbc <exit>

0000000000000d46 <unlinkread>:
{
     d46:	7179                	add	sp,sp,-48
     d48:	f406                	sd	ra,40(sp)
     d4a:	f022                	sd	s0,32(sp)
     d4c:	ec26                	sd	s1,24(sp)
     d4e:	e84a                	sd	s2,16(sp)
     d50:	e44e                	sd	s3,8(sp)
     d52:	1800                	add	s0,sp,48
     d54:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d56:	20200593          	li	a1,514
     d5a:	00006517          	auipc	a0,0x6
     d5e:	8a650513          	add	a0,a0,-1882 # 6600 <malloc+0x624>
     d62:	00005097          	auipc	ra,0x5
     d66:	e9a080e7          	jalr	-358(ra) # 5bfc <open>
  if(fd < 0){
     d6a:	0e054563          	bltz	a0,e54 <unlinkread+0x10e>
     d6e:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d70:	4615                	li	a2,5
     d72:	00006597          	auipc	a1,0x6
     d76:	8be58593          	add	a1,a1,-1858 # 6630 <malloc+0x654>
     d7a:	00005097          	auipc	ra,0x5
     d7e:	e62080e7          	jalr	-414(ra) # 5bdc <write>
  close(fd);
     d82:	8526                	mv	a0,s1
     d84:	00005097          	auipc	ra,0x5
     d88:	e60080e7          	jalr	-416(ra) # 5be4 <close>
  fd = open("unlinkread", O_RDWR);
     d8c:	4589                	li	a1,2
     d8e:	00006517          	auipc	a0,0x6
     d92:	87250513          	add	a0,a0,-1934 # 6600 <malloc+0x624>
     d96:	00005097          	auipc	ra,0x5
     d9a:	e66080e7          	jalr	-410(ra) # 5bfc <open>
     d9e:	84aa                	mv	s1,a0
  if(fd < 0){
     da0:	0c054863          	bltz	a0,e70 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     da4:	00006517          	auipc	a0,0x6
     da8:	85c50513          	add	a0,a0,-1956 # 6600 <malloc+0x624>
     dac:	00005097          	auipc	ra,0x5
     db0:	e60080e7          	jalr	-416(ra) # 5c0c <unlink>
     db4:	ed61                	bnez	a0,e8c <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db6:	20200593          	li	a1,514
     dba:	00006517          	auipc	a0,0x6
     dbe:	84650513          	add	a0,a0,-1978 # 6600 <malloc+0x624>
     dc2:	00005097          	auipc	ra,0x5
     dc6:	e3a080e7          	jalr	-454(ra) # 5bfc <open>
     dca:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dcc:	460d                	li	a2,3
     dce:	00006597          	auipc	a1,0x6
     dd2:	8aa58593          	add	a1,a1,-1878 # 6678 <malloc+0x69c>
     dd6:	00005097          	auipc	ra,0x5
     dda:	e06080e7          	jalr	-506(ra) # 5bdc <write>
  close(fd1);
     dde:	854a                	mv	a0,s2
     de0:	00005097          	auipc	ra,0x5
     de4:	e04080e7          	jalr	-508(ra) # 5be4 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de8:	660d                	lui	a2,0x3
     dea:	0000c597          	auipc	a1,0xc
     dee:	e8e58593          	add	a1,a1,-370 # cc78 <buf>
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	de0080e7          	jalr	-544(ra) # 5bd4 <read>
     dfc:	4795                	li	a5,5
     dfe:	0af51563          	bne	a0,a5,ea8 <unlinkread+0x162>
  if(buf[0] != 'h'){
     e02:	0000c717          	auipc	a4,0xc
     e06:	e7674703          	lbu	a4,-394(a4) # cc78 <buf>
     e0a:	06800793          	li	a5,104
     e0e:	0af71b63          	bne	a4,a5,ec4 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e12:	4629                	li	a2,10
     e14:	0000c597          	auipc	a1,0xc
     e18:	e6458593          	add	a1,a1,-412 # cc78 <buf>
     e1c:	8526                	mv	a0,s1
     e1e:	00005097          	auipc	ra,0x5
     e22:	dbe080e7          	jalr	-578(ra) # 5bdc <write>
     e26:	47a9                	li	a5,10
     e28:	0af51c63          	bne	a0,a5,ee0 <unlinkread+0x19a>
  close(fd);
     e2c:	8526                	mv	a0,s1
     e2e:	00005097          	auipc	ra,0x5
     e32:	db6080e7          	jalr	-586(ra) # 5be4 <close>
  unlink("unlinkread");
     e36:	00005517          	auipc	a0,0x5
     e3a:	7ca50513          	add	a0,a0,1994 # 6600 <malloc+0x624>
     e3e:	00005097          	auipc	ra,0x5
     e42:	dce080e7          	jalr	-562(ra) # 5c0c <unlink>
}
     e46:	70a2                	ld	ra,40(sp)
     e48:	7402                	ld	s0,32(sp)
     e4a:	64e2                	ld	s1,24(sp)
     e4c:	6942                	ld	s2,16(sp)
     e4e:	69a2                	ld	s3,8(sp)
     e50:	6145                	add	sp,sp,48
     e52:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e54:	85ce                	mv	a1,s3
     e56:	00005517          	auipc	a0,0x5
     e5a:	7ba50513          	add	a0,a0,1978 # 6610 <malloc+0x634>
     e5e:	00005097          	auipc	ra,0x5
     e62:	0c6080e7          	jalr	198(ra) # 5f24 <printf>
    exit(1);
     e66:	4505                	li	a0,1
     e68:	00005097          	auipc	ra,0x5
     e6c:	d54080e7          	jalr	-684(ra) # 5bbc <exit>
    printf("%s: open unlinkread failed\n", s);
     e70:	85ce                	mv	a1,s3
     e72:	00005517          	auipc	a0,0x5
     e76:	7c650513          	add	a0,a0,1990 # 6638 <malloc+0x65c>
     e7a:	00005097          	auipc	ra,0x5
     e7e:	0aa080e7          	jalr	170(ra) # 5f24 <printf>
    exit(1);
     e82:	4505                	li	a0,1
     e84:	00005097          	auipc	ra,0x5
     e88:	d38080e7          	jalr	-712(ra) # 5bbc <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e8c:	85ce                	mv	a1,s3
     e8e:	00005517          	auipc	a0,0x5
     e92:	7ca50513          	add	a0,a0,1994 # 6658 <malloc+0x67c>
     e96:	00005097          	auipc	ra,0x5
     e9a:	08e080e7          	jalr	142(ra) # 5f24 <printf>
    exit(1);
     e9e:	4505                	li	a0,1
     ea0:	00005097          	auipc	ra,0x5
     ea4:	d1c080e7          	jalr	-740(ra) # 5bbc <exit>
    printf("%s: unlinkread read failed", s);
     ea8:	85ce                	mv	a1,s3
     eaa:	00005517          	auipc	a0,0x5
     eae:	7d650513          	add	a0,a0,2006 # 6680 <malloc+0x6a4>
     eb2:	00005097          	auipc	ra,0x5
     eb6:	072080e7          	jalr	114(ra) # 5f24 <printf>
    exit(1);
     eba:	4505                	li	a0,1
     ebc:	00005097          	auipc	ra,0x5
     ec0:	d00080e7          	jalr	-768(ra) # 5bbc <exit>
    printf("%s: unlinkread wrong data\n", s);
     ec4:	85ce                	mv	a1,s3
     ec6:	00005517          	auipc	a0,0x5
     eca:	7da50513          	add	a0,a0,2010 # 66a0 <malloc+0x6c4>
     ece:	00005097          	auipc	ra,0x5
     ed2:	056080e7          	jalr	86(ra) # 5f24 <printf>
    exit(1);
     ed6:	4505                	li	a0,1
     ed8:	00005097          	auipc	ra,0x5
     edc:	ce4080e7          	jalr	-796(ra) # 5bbc <exit>
    printf("%s: unlinkread write failed\n", s);
     ee0:	85ce                	mv	a1,s3
     ee2:	00005517          	auipc	a0,0x5
     ee6:	7de50513          	add	a0,a0,2014 # 66c0 <malloc+0x6e4>
     eea:	00005097          	auipc	ra,0x5
     eee:	03a080e7          	jalr	58(ra) # 5f24 <printf>
    exit(1);
     ef2:	4505                	li	a0,1
     ef4:	00005097          	auipc	ra,0x5
     ef8:	cc8080e7          	jalr	-824(ra) # 5bbc <exit>

0000000000000efc <linktest>:
{
     efc:	1101                	add	sp,sp,-32
     efe:	ec06                	sd	ra,24(sp)
     f00:	e822                	sd	s0,16(sp)
     f02:	e426                	sd	s1,8(sp)
     f04:	e04a                	sd	s2,0(sp)
     f06:	1000                	add	s0,sp,32
     f08:	892a                	mv	s2,a0
  unlink("lf1");
     f0a:	00005517          	auipc	a0,0x5
     f0e:	7d650513          	add	a0,a0,2006 # 66e0 <malloc+0x704>
     f12:	00005097          	auipc	ra,0x5
     f16:	cfa080e7          	jalr	-774(ra) # 5c0c <unlink>
  unlink("lf2");
     f1a:	00005517          	auipc	a0,0x5
     f1e:	7ce50513          	add	a0,a0,1998 # 66e8 <malloc+0x70c>
     f22:	00005097          	auipc	ra,0x5
     f26:	cea080e7          	jalr	-790(ra) # 5c0c <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f2a:	20200593          	li	a1,514
     f2e:	00005517          	auipc	a0,0x5
     f32:	7b250513          	add	a0,a0,1970 # 66e0 <malloc+0x704>
     f36:	00005097          	auipc	ra,0x5
     f3a:	cc6080e7          	jalr	-826(ra) # 5bfc <open>
  if(fd < 0){
     f3e:	10054763          	bltz	a0,104c <linktest+0x150>
     f42:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f44:	4615                	li	a2,5
     f46:	00005597          	auipc	a1,0x5
     f4a:	6ea58593          	add	a1,a1,1770 # 6630 <malloc+0x654>
     f4e:	00005097          	auipc	ra,0x5
     f52:	c8e080e7          	jalr	-882(ra) # 5bdc <write>
     f56:	4795                	li	a5,5
     f58:	10f51863          	bne	a0,a5,1068 <linktest+0x16c>
  close(fd);
     f5c:	8526                	mv	a0,s1
     f5e:	00005097          	auipc	ra,0x5
     f62:	c86080e7          	jalr	-890(ra) # 5be4 <close>
  if(link("lf1", "lf2") < 0){
     f66:	00005597          	auipc	a1,0x5
     f6a:	78258593          	add	a1,a1,1922 # 66e8 <malloc+0x70c>
     f6e:	00005517          	auipc	a0,0x5
     f72:	77250513          	add	a0,a0,1906 # 66e0 <malloc+0x704>
     f76:	00005097          	auipc	ra,0x5
     f7a:	ca6080e7          	jalr	-858(ra) # 5c1c <link>
     f7e:	10054363          	bltz	a0,1084 <linktest+0x188>
  unlink("lf1");
     f82:	00005517          	auipc	a0,0x5
     f86:	75e50513          	add	a0,a0,1886 # 66e0 <malloc+0x704>
     f8a:	00005097          	auipc	ra,0x5
     f8e:	c82080e7          	jalr	-894(ra) # 5c0c <unlink>
  if(open("lf1", 0) >= 0){
     f92:	4581                	li	a1,0
     f94:	00005517          	auipc	a0,0x5
     f98:	74c50513          	add	a0,a0,1868 # 66e0 <malloc+0x704>
     f9c:	00005097          	auipc	ra,0x5
     fa0:	c60080e7          	jalr	-928(ra) # 5bfc <open>
     fa4:	0e055e63          	bgez	a0,10a0 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa8:	4581                	li	a1,0
     faa:	00005517          	auipc	a0,0x5
     fae:	73e50513          	add	a0,a0,1854 # 66e8 <malloc+0x70c>
     fb2:	00005097          	auipc	ra,0x5
     fb6:	c4a080e7          	jalr	-950(ra) # 5bfc <open>
     fba:	84aa                	mv	s1,a0
  if(fd < 0){
     fbc:	10054063          	bltz	a0,10bc <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fc0:	660d                	lui	a2,0x3
     fc2:	0000c597          	auipc	a1,0xc
     fc6:	cb658593          	add	a1,a1,-842 # cc78 <buf>
     fca:	00005097          	auipc	ra,0x5
     fce:	c0a080e7          	jalr	-1014(ra) # 5bd4 <read>
     fd2:	4795                	li	a5,5
     fd4:	10f51263          	bne	a0,a5,10d8 <linktest+0x1dc>
  close(fd);
     fd8:	8526                	mv	a0,s1
     fda:	00005097          	auipc	ra,0x5
     fde:	c0a080e7          	jalr	-1014(ra) # 5be4 <close>
  if(link("lf2", "lf2") >= 0){
     fe2:	00005597          	auipc	a1,0x5
     fe6:	70658593          	add	a1,a1,1798 # 66e8 <malloc+0x70c>
     fea:	852e                	mv	a0,a1
     fec:	00005097          	auipc	ra,0x5
     ff0:	c30080e7          	jalr	-976(ra) # 5c1c <link>
     ff4:	10055063          	bgez	a0,10f4 <linktest+0x1f8>
  unlink("lf2");
     ff8:	00005517          	auipc	a0,0x5
     ffc:	6f050513          	add	a0,a0,1776 # 66e8 <malloc+0x70c>
    1000:	00005097          	auipc	ra,0x5
    1004:	c0c080e7          	jalr	-1012(ra) # 5c0c <unlink>
  if(link("lf2", "lf1") >= 0){
    1008:	00005597          	auipc	a1,0x5
    100c:	6d858593          	add	a1,a1,1752 # 66e0 <malloc+0x704>
    1010:	00005517          	auipc	a0,0x5
    1014:	6d850513          	add	a0,a0,1752 # 66e8 <malloc+0x70c>
    1018:	00005097          	auipc	ra,0x5
    101c:	c04080e7          	jalr	-1020(ra) # 5c1c <link>
    1020:	0e055863          	bgez	a0,1110 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    1024:	00005597          	auipc	a1,0x5
    1028:	6bc58593          	add	a1,a1,1724 # 66e0 <malloc+0x704>
    102c:	00005517          	auipc	a0,0x5
    1030:	7c450513          	add	a0,a0,1988 # 67f0 <malloc+0x814>
    1034:	00005097          	auipc	ra,0x5
    1038:	be8080e7          	jalr	-1048(ra) # 5c1c <link>
    103c:	0e055863          	bgez	a0,112c <linktest+0x230>
}
    1040:	60e2                	ld	ra,24(sp)
    1042:	6442                	ld	s0,16(sp)
    1044:	64a2                	ld	s1,8(sp)
    1046:	6902                	ld	s2,0(sp)
    1048:	6105                	add	sp,sp,32
    104a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    104c:	85ca                	mv	a1,s2
    104e:	00005517          	auipc	a0,0x5
    1052:	6a250513          	add	a0,a0,1698 # 66f0 <malloc+0x714>
    1056:	00005097          	auipc	ra,0x5
    105a:	ece080e7          	jalr	-306(ra) # 5f24 <printf>
    exit(1);
    105e:	4505                	li	a0,1
    1060:	00005097          	auipc	ra,0x5
    1064:	b5c080e7          	jalr	-1188(ra) # 5bbc <exit>
    printf("%s: write lf1 failed\n", s);
    1068:	85ca                	mv	a1,s2
    106a:	00005517          	auipc	a0,0x5
    106e:	69e50513          	add	a0,a0,1694 # 6708 <malloc+0x72c>
    1072:	00005097          	auipc	ra,0x5
    1076:	eb2080e7          	jalr	-334(ra) # 5f24 <printf>
    exit(1);
    107a:	4505                	li	a0,1
    107c:	00005097          	auipc	ra,0x5
    1080:	b40080e7          	jalr	-1216(ra) # 5bbc <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1084:	85ca                	mv	a1,s2
    1086:	00005517          	auipc	a0,0x5
    108a:	69a50513          	add	a0,a0,1690 # 6720 <malloc+0x744>
    108e:	00005097          	auipc	ra,0x5
    1092:	e96080e7          	jalr	-362(ra) # 5f24 <printf>
    exit(1);
    1096:	4505                	li	a0,1
    1098:	00005097          	auipc	ra,0x5
    109c:	b24080e7          	jalr	-1244(ra) # 5bbc <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10a0:	85ca                	mv	a1,s2
    10a2:	00005517          	auipc	a0,0x5
    10a6:	69e50513          	add	a0,a0,1694 # 6740 <malloc+0x764>
    10aa:	00005097          	auipc	ra,0x5
    10ae:	e7a080e7          	jalr	-390(ra) # 5f24 <printf>
    exit(1);
    10b2:	4505                	li	a0,1
    10b4:	00005097          	auipc	ra,0x5
    10b8:	b08080e7          	jalr	-1272(ra) # 5bbc <exit>
    printf("%s: open lf2 failed\n", s);
    10bc:	85ca                	mv	a1,s2
    10be:	00005517          	auipc	a0,0x5
    10c2:	6b250513          	add	a0,a0,1714 # 6770 <malloc+0x794>
    10c6:	00005097          	auipc	ra,0x5
    10ca:	e5e080e7          	jalr	-418(ra) # 5f24 <printf>
    exit(1);
    10ce:	4505                	li	a0,1
    10d0:	00005097          	auipc	ra,0x5
    10d4:	aec080e7          	jalr	-1300(ra) # 5bbc <exit>
    printf("%s: read lf2 failed\n", s);
    10d8:	85ca                	mv	a1,s2
    10da:	00005517          	auipc	a0,0x5
    10de:	6ae50513          	add	a0,a0,1710 # 6788 <malloc+0x7ac>
    10e2:	00005097          	auipc	ra,0x5
    10e6:	e42080e7          	jalr	-446(ra) # 5f24 <printf>
    exit(1);
    10ea:	4505                	li	a0,1
    10ec:	00005097          	auipc	ra,0x5
    10f0:	ad0080e7          	jalr	-1328(ra) # 5bbc <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10f4:	85ca                	mv	a1,s2
    10f6:	00005517          	auipc	a0,0x5
    10fa:	6aa50513          	add	a0,a0,1706 # 67a0 <malloc+0x7c4>
    10fe:	00005097          	auipc	ra,0x5
    1102:	e26080e7          	jalr	-474(ra) # 5f24 <printf>
    exit(1);
    1106:	4505                	li	a0,1
    1108:	00005097          	auipc	ra,0x5
    110c:	ab4080e7          	jalr	-1356(ra) # 5bbc <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1110:	85ca                	mv	a1,s2
    1112:	00005517          	auipc	a0,0x5
    1116:	6b650513          	add	a0,a0,1718 # 67c8 <malloc+0x7ec>
    111a:	00005097          	auipc	ra,0x5
    111e:	e0a080e7          	jalr	-502(ra) # 5f24 <printf>
    exit(1);
    1122:	4505                	li	a0,1
    1124:	00005097          	auipc	ra,0x5
    1128:	a98080e7          	jalr	-1384(ra) # 5bbc <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    112c:	85ca                	mv	a1,s2
    112e:	00005517          	auipc	a0,0x5
    1132:	6ca50513          	add	a0,a0,1738 # 67f8 <malloc+0x81c>
    1136:	00005097          	auipc	ra,0x5
    113a:	dee080e7          	jalr	-530(ra) # 5f24 <printf>
    exit(1);
    113e:	4505                	li	a0,1
    1140:	00005097          	auipc	ra,0x5
    1144:	a7c080e7          	jalr	-1412(ra) # 5bbc <exit>

0000000000001148 <validatetest>:
{
    1148:	7139                	add	sp,sp,-64
    114a:	fc06                	sd	ra,56(sp)
    114c:	f822                	sd	s0,48(sp)
    114e:	f426                	sd	s1,40(sp)
    1150:	f04a                	sd	s2,32(sp)
    1152:	ec4e                	sd	s3,24(sp)
    1154:	e852                	sd	s4,16(sp)
    1156:	e456                	sd	s5,8(sp)
    1158:	e05a                	sd	s6,0(sp)
    115a:	0080                	add	s0,sp,64
    115c:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    115e:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1160:	00005997          	auipc	s3,0x5
    1164:	6b898993          	add	s3,s3,1720 # 6818 <malloc+0x83c>
    1168:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    116a:	6a85                	lui	s5,0x1
    116c:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1170:	85a6                	mv	a1,s1
    1172:	854e                	mv	a0,s3
    1174:	00005097          	auipc	ra,0x5
    1178:	aa8080e7          	jalr	-1368(ra) # 5c1c <link>
    117c:	01251f63          	bne	a0,s2,119a <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1180:	94d6                	add	s1,s1,s5
    1182:	ff4497e3          	bne	s1,s4,1170 <validatetest+0x28>
}
    1186:	70e2                	ld	ra,56(sp)
    1188:	7442                	ld	s0,48(sp)
    118a:	74a2                	ld	s1,40(sp)
    118c:	7902                	ld	s2,32(sp)
    118e:	69e2                	ld	s3,24(sp)
    1190:	6a42                	ld	s4,16(sp)
    1192:	6aa2                	ld	s5,8(sp)
    1194:	6b02                	ld	s6,0(sp)
    1196:	6121                	add	sp,sp,64
    1198:	8082                	ret
      printf("%s: link should not succeed\n", s);
    119a:	85da                	mv	a1,s6
    119c:	00005517          	auipc	a0,0x5
    11a0:	68c50513          	add	a0,a0,1676 # 6828 <malloc+0x84c>
    11a4:	00005097          	auipc	ra,0x5
    11a8:	d80080e7          	jalr	-640(ra) # 5f24 <printf>
      exit(1);
    11ac:	4505                	li	a0,1
    11ae:	00005097          	auipc	ra,0x5
    11b2:	a0e080e7          	jalr	-1522(ra) # 5bbc <exit>

00000000000011b6 <bigdir>:
{
    11b6:	715d                	add	sp,sp,-80
    11b8:	e486                	sd	ra,72(sp)
    11ba:	e0a2                	sd	s0,64(sp)
    11bc:	fc26                	sd	s1,56(sp)
    11be:	f84a                	sd	s2,48(sp)
    11c0:	f44e                	sd	s3,40(sp)
    11c2:	f052                	sd	s4,32(sp)
    11c4:	ec56                	sd	s5,24(sp)
    11c6:	e85a                	sd	s6,16(sp)
    11c8:	0880                	add	s0,sp,80
    11ca:	89aa                	mv	s3,a0
  unlink("bd");
    11cc:	00005517          	auipc	a0,0x5
    11d0:	67c50513          	add	a0,a0,1660 # 6848 <malloc+0x86c>
    11d4:	00005097          	auipc	ra,0x5
    11d8:	a38080e7          	jalr	-1480(ra) # 5c0c <unlink>
  fd = open("bd", O_CREATE);
    11dc:	20000593          	li	a1,512
    11e0:	00005517          	auipc	a0,0x5
    11e4:	66850513          	add	a0,a0,1640 # 6848 <malloc+0x86c>
    11e8:	00005097          	auipc	ra,0x5
    11ec:	a14080e7          	jalr	-1516(ra) # 5bfc <open>
  if(fd < 0){
    11f0:	0c054963          	bltz	a0,12c2 <bigdir+0x10c>
  close(fd);
    11f4:	00005097          	auipc	ra,0x5
    11f8:	9f0080e7          	jalr	-1552(ra) # 5be4 <close>
  for(i = 0; i < N; i++){
    11fc:	4901                	li	s2,0
    name[0] = 'x';
    11fe:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1202:	00005a17          	auipc	s4,0x5
    1206:	646a0a13          	add	s4,s4,1606 # 6848 <malloc+0x86c>
  for(i = 0; i < N; i++){
    120a:	1f400b13          	li	s6,500
    name[0] = 'x';
    120e:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1212:	41f9571b          	sraw	a4,s2,0x1f
    1216:	01a7571b          	srlw	a4,a4,0x1a
    121a:	012707bb          	addw	a5,a4,s2
    121e:	4067d69b          	sraw	a3,a5,0x6
    1222:	0306869b          	addw	a3,a3,48
    1226:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    122a:	03f7f793          	and	a5,a5,63
    122e:	9f99                	subw	a5,a5,a4
    1230:	0307879b          	addw	a5,a5,48
    1234:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1238:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    123c:	fb040593          	add	a1,s0,-80
    1240:	8552                	mv	a0,s4
    1242:	00005097          	auipc	ra,0x5
    1246:	9da080e7          	jalr	-1574(ra) # 5c1c <link>
    124a:	84aa                	mv	s1,a0
    124c:	e949                	bnez	a0,12de <bigdir+0x128>
  for(i = 0; i < N; i++){
    124e:	2905                	addw	s2,s2,1
    1250:	fb691fe3          	bne	s2,s6,120e <bigdir+0x58>
  unlink("bd");
    1254:	00005517          	auipc	a0,0x5
    1258:	5f450513          	add	a0,a0,1524 # 6848 <malloc+0x86c>
    125c:	00005097          	auipc	ra,0x5
    1260:	9b0080e7          	jalr	-1616(ra) # 5c0c <unlink>
    name[0] = 'x';
    1264:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1268:	1f400a13          	li	s4,500
    name[0] = 'x';
    126c:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1270:	41f4d71b          	sraw	a4,s1,0x1f
    1274:	01a7571b          	srlw	a4,a4,0x1a
    1278:	009707bb          	addw	a5,a4,s1
    127c:	4067d69b          	sraw	a3,a5,0x6
    1280:	0306869b          	addw	a3,a3,48
    1284:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1288:	03f7f793          	and	a5,a5,63
    128c:	9f99                	subw	a5,a5,a4
    128e:	0307879b          	addw	a5,a5,48
    1292:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1296:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    129a:	fb040513          	add	a0,s0,-80
    129e:	00005097          	auipc	ra,0x5
    12a2:	96e080e7          	jalr	-1682(ra) # 5c0c <unlink>
    12a6:	ed21                	bnez	a0,12fe <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a8:	2485                	addw	s1,s1,1
    12aa:	fd4491e3          	bne	s1,s4,126c <bigdir+0xb6>
}
    12ae:	60a6                	ld	ra,72(sp)
    12b0:	6406                	ld	s0,64(sp)
    12b2:	74e2                	ld	s1,56(sp)
    12b4:	7942                	ld	s2,48(sp)
    12b6:	79a2                	ld	s3,40(sp)
    12b8:	7a02                	ld	s4,32(sp)
    12ba:	6ae2                	ld	s5,24(sp)
    12bc:	6b42                	ld	s6,16(sp)
    12be:	6161                	add	sp,sp,80
    12c0:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12c2:	85ce                	mv	a1,s3
    12c4:	00005517          	auipc	a0,0x5
    12c8:	58c50513          	add	a0,a0,1420 # 6850 <malloc+0x874>
    12cc:	00005097          	auipc	ra,0x5
    12d0:	c58080e7          	jalr	-936(ra) # 5f24 <printf>
    exit(1);
    12d4:	4505                	li	a0,1
    12d6:	00005097          	auipc	ra,0x5
    12da:	8e6080e7          	jalr	-1818(ra) # 5bbc <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12de:	fb040613          	add	a2,s0,-80
    12e2:	85ce                	mv	a1,s3
    12e4:	00005517          	auipc	a0,0x5
    12e8:	58c50513          	add	a0,a0,1420 # 6870 <malloc+0x894>
    12ec:	00005097          	auipc	ra,0x5
    12f0:	c38080e7          	jalr	-968(ra) # 5f24 <printf>
      exit(1);
    12f4:	4505                	li	a0,1
    12f6:	00005097          	auipc	ra,0x5
    12fa:	8c6080e7          	jalr	-1850(ra) # 5bbc <exit>
      printf("%s: bigdir unlink failed", s);
    12fe:	85ce                	mv	a1,s3
    1300:	00005517          	auipc	a0,0x5
    1304:	59050513          	add	a0,a0,1424 # 6890 <malloc+0x8b4>
    1308:	00005097          	auipc	ra,0x5
    130c:	c1c080e7          	jalr	-996(ra) # 5f24 <printf>
      exit(1);
    1310:	4505                	li	a0,1
    1312:	00005097          	auipc	ra,0x5
    1316:	8aa080e7          	jalr	-1878(ra) # 5bbc <exit>

000000000000131a <pgbug>:
{
    131a:	7179                	add	sp,sp,-48
    131c:	f406                	sd	ra,40(sp)
    131e:	f022                	sd	s0,32(sp)
    1320:	ec26                	sd	s1,24(sp)
    1322:	1800                	add	s0,sp,48
  argv[0] = 0;
    1324:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1328:	00008497          	auipc	s1,0x8
    132c:	cd848493          	add	s1,s1,-808 # 9000 <big>
    1330:	fd840593          	add	a1,s0,-40
    1334:	6088                	ld	a0,0(s1)
    1336:	00005097          	auipc	ra,0x5
    133a:	8be080e7          	jalr	-1858(ra) # 5bf4 <exec>
  pipe(big);
    133e:	6088                	ld	a0,0(s1)
    1340:	00005097          	auipc	ra,0x5
    1344:	88c080e7          	jalr	-1908(ra) # 5bcc <pipe>
  exit(0);
    1348:	4501                	li	a0,0
    134a:	00005097          	auipc	ra,0x5
    134e:	872080e7          	jalr	-1934(ra) # 5bbc <exit>

0000000000001352 <badarg>:
{
    1352:	7139                	add	sp,sp,-64
    1354:	fc06                	sd	ra,56(sp)
    1356:	f822                	sd	s0,48(sp)
    1358:	f426                	sd	s1,40(sp)
    135a:	f04a                	sd	s2,32(sp)
    135c:	ec4e                	sd	s3,24(sp)
    135e:	0080                	add	s0,sp,64
    1360:	64b1                	lui	s1,0xc
    1362:	35048493          	add	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1366:	597d                	li	s2,-1
    1368:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    136c:	00005997          	auipc	s3,0x5
    1370:	d9c98993          	add	s3,s3,-612 # 6108 <malloc+0x12c>
    argv[0] = (char*)0xffffffff;
    1374:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1378:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    137c:	fc040593          	add	a1,s0,-64
    1380:	854e                	mv	a0,s3
    1382:	00005097          	auipc	ra,0x5
    1386:	872080e7          	jalr	-1934(ra) # 5bf4 <exec>
  for(int i = 0; i < 50000; i++){
    138a:	34fd                	addw	s1,s1,-1
    138c:	f4e5                	bnez	s1,1374 <badarg+0x22>
  exit(0);
    138e:	4501                	li	a0,0
    1390:	00005097          	auipc	ra,0x5
    1394:	82c080e7          	jalr	-2004(ra) # 5bbc <exit>

0000000000001398 <copyinstr2>:
{
    1398:	7155                	add	sp,sp,-208
    139a:	e586                	sd	ra,200(sp)
    139c:	e1a2                	sd	s0,192(sp)
    139e:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    13a0:	f6840793          	add	a5,s0,-152
    13a4:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    13a8:	07800713          	li	a4,120
    13ac:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13b0:	0785                	add	a5,a5,1
    13b2:	fed79de3          	bne	a5,a3,13ac <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b6:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13ba:	f6840513          	add	a0,s0,-152
    13be:	00005097          	auipc	ra,0x5
    13c2:	84e080e7          	jalr	-1970(ra) # 5c0c <unlink>
  if(ret != -1){
    13c6:	57fd                	li	a5,-1
    13c8:	0ef51063          	bne	a0,a5,14a8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13cc:	20100593          	li	a1,513
    13d0:	f6840513          	add	a0,s0,-152
    13d4:	00005097          	auipc	ra,0x5
    13d8:	828080e7          	jalr	-2008(ra) # 5bfc <open>
  if(fd != -1){
    13dc:	57fd                	li	a5,-1
    13de:	0ef51563          	bne	a0,a5,14c8 <copyinstr2+0x130>
  ret = link(b, b);
    13e2:	f6840593          	add	a1,s0,-152
    13e6:	852e                	mv	a0,a1
    13e8:	00005097          	auipc	ra,0x5
    13ec:	834080e7          	jalr	-1996(ra) # 5c1c <link>
  if(ret != -1){
    13f0:	57fd                	li	a5,-1
    13f2:	0ef51b63          	bne	a0,a5,14e8 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f6:	00006797          	auipc	a5,0x6
    13fa:	6f278793          	add	a5,a5,1778 # 7ae8 <malloc+0x1b0c>
    13fe:	f4f43c23          	sd	a5,-168(s0)
    1402:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1406:	f5840593          	add	a1,s0,-168
    140a:	f6840513          	add	a0,s0,-152
    140e:	00004097          	auipc	ra,0x4
    1412:	7e6080e7          	jalr	2022(ra) # 5bf4 <exec>
  if(ret != -1){
    1416:	57fd                	li	a5,-1
    1418:	0ef51963          	bne	a0,a5,150a <copyinstr2+0x172>
  int pid = fork();
    141c:	00004097          	auipc	ra,0x4
    1420:	798080e7          	jalr	1944(ra) # 5bb4 <fork>
  if(pid < 0){
    1424:	10054363          	bltz	a0,152a <copyinstr2+0x192>
  if(pid == 0){
    1428:	12051463          	bnez	a0,1550 <copyinstr2+0x1b8>
    142c:	00008797          	auipc	a5,0x8
    1430:	13478793          	add	a5,a5,308 # 9560 <big.0>
    1434:	00009697          	auipc	a3,0x9
    1438:	12c68693          	add	a3,a3,300 # a560 <big.0+0x1000>
      big[i] = 'x';
    143c:	07800713          	li	a4,120
    1440:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1444:	0785                	add	a5,a5,1
    1446:	fed79de3          	bne	a5,a3,1440 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    144a:	00009797          	auipc	a5,0x9
    144e:	10078b23          	sb	zero,278(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1452:	00007797          	auipc	a5,0x7
    1456:	0d678793          	add	a5,a5,214 # 8528 <malloc+0x254c>
    145a:	6390                	ld	a2,0(a5)
    145c:	6794                	ld	a3,8(a5)
    145e:	6b98                	ld	a4,16(a5)
    1460:	6f9c                	ld	a5,24(a5)
    1462:	f2c43823          	sd	a2,-208(s0)
    1466:	f2d43c23          	sd	a3,-200(s0)
    146a:	f4e43023          	sd	a4,-192(s0)
    146e:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1472:	f3040593          	add	a1,s0,-208
    1476:	00005517          	auipc	a0,0x5
    147a:	c9250513          	add	a0,a0,-878 # 6108 <malloc+0x12c>
    147e:	00004097          	auipc	ra,0x4
    1482:	776080e7          	jalr	1910(ra) # 5bf4 <exec>
    if(ret != -1){
    1486:	57fd                	li	a5,-1
    1488:	0af50e63          	beq	a0,a5,1544 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    148c:	55fd                	li	a1,-1
    148e:	00005517          	auipc	a0,0x5
    1492:	4aa50513          	add	a0,a0,1194 # 6938 <malloc+0x95c>
    1496:	00005097          	auipc	ra,0x5
    149a:	a8e080e7          	jalr	-1394(ra) # 5f24 <printf>
      exit(1);
    149e:	4505                	li	a0,1
    14a0:	00004097          	auipc	ra,0x4
    14a4:	71c080e7          	jalr	1820(ra) # 5bbc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a8:	862a                	mv	a2,a0
    14aa:	f6840593          	add	a1,s0,-152
    14ae:	00005517          	auipc	a0,0x5
    14b2:	40250513          	add	a0,a0,1026 # 68b0 <malloc+0x8d4>
    14b6:	00005097          	auipc	ra,0x5
    14ba:	a6e080e7          	jalr	-1426(ra) # 5f24 <printf>
    exit(1);
    14be:	4505                	li	a0,1
    14c0:	00004097          	auipc	ra,0x4
    14c4:	6fc080e7          	jalr	1788(ra) # 5bbc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c8:	862a                	mv	a2,a0
    14ca:	f6840593          	add	a1,s0,-152
    14ce:	00005517          	auipc	a0,0x5
    14d2:	40250513          	add	a0,a0,1026 # 68d0 <malloc+0x8f4>
    14d6:	00005097          	auipc	ra,0x5
    14da:	a4e080e7          	jalr	-1458(ra) # 5f24 <printf>
    exit(1);
    14de:	4505                	li	a0,1
    14e0:	00004097          	auipc	ra,0x4
    14e4:	6dc080e7          	jalr	1756(ra) # 5bbc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e8:	86aa                	mv	a3,a0
    14ea:	f6840613          	add	a2,s0,-152
    14ee:	85b2                	mv	a1,a2
    14f0:	00005517          	auipc	a0,0x5
    14f4:	40050513          	add	a0,a0,1024 # 68f0 <malloc+0x914>
    14f8:	00005097          	auipc	ra,0x5
    14fc:	a2c080e7          	jalr	-1492(ra) # 5f24 <printf>
    exit(1);
    1500:	4505                	li	a0,1
    1502:	00004097          	auipc	ra,0x4
    1506:	6ba080e7          	jalr	1722(ra) # 5bbc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    150a:	567d                	li	a2,-1
    150c:	f6840593          	add	a1,s0,-152
    1510:	00005517          	auipc	a0,0x5
    1514:	40850513          	add	a0,a0,1032 # 6918 <malloc+0x93c>
    1518:	00005097          	auipc	ra,0x5
    151c:	a0c080e7          	jalr	-1524(ra) # 5f24 <printf>
    exit(1);
    1520:	4505                	li	a0,1
    1522:	00004097          	auipc	ra,0x4
    1526:	69a080e7          	jalr	1690(ra) # 5bbc <exit>
    printf("fork failed\n");
    152a:	00006517          	auipc	a0,0x6
    152e:	86e50513          	add	a0,a0,-1938 # 6d98 <malloc+0xdbc>
    1532:	00005097          	auipc	ra,0x5
    1536:	9f2080e7          	jalr	-1550(ra) # 5f24 <printf>
    exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	680080e7          	jalr	1664(ra) # 5bbc <exit>
    exit(747); // OK
    1544:	2eb00513          	li	a0,747
    1548:	00004097          	auipc	ra,0x4
    154c:	674080e7          	jalr	1652(ra) # 5bbc <exit>
  int st = 0;
    1550:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1554:	f5440513          	add	a0,s0,-172
    1558:	00004097          	auipc	ra,0x4
    155c:	66c080e7          	jalr	1644(ra) # 5bc4 <wait>
  if(st != 747){
    1560:	f5442703          	lw	a4,-172(s0)
    1564:	2eb00793          	li	a5,747
    1568:	00f71663          	bne	a4,a5,1574 <copyinstr2+0x1dc>
}
    156c:	60ae                	ld	ra,200(sp)
    156e:	640e                	ld	s0,192(sp)
    1570:	6169                	add	sp,sp,208
    1572:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1574:	00005517          	auipc	a0,0x5
    1578:	3ec50513          	add	a0,a0,1004 # 6960 <malloc+0x984>
    157c:	00005097          	auipc	ra,0x5
    1580:	9a8080e7          	jalr	-1624(ra) # 5f24 <printf>
    exit(1);
    1584:	4505                	li	a0,1
    1586:	00004097          	auipc	ra,0x4
    158a:	636080e7          	jalr	1590(ra) # 5bbc <exit>

000000000000158e <truncate3>:
{
    158e:	7159                	add	sp,sp,-112
    1590:	f486                	sd	ra,104(sp)
    1592:	f0a2                	sd	s0,96(sp)
    1594:	eca6                	sd	s1,88(sp)
    1596:	e8ca                	sd	s2,80(sp)
    1598:	e4ce                	sd	s3,72(sp)
    159a:	e0d2                	sd	s4,64(sp)
    159c:	fc56                	sd	s5,56(sp)
    159e:	1880                	add	s0,sp,112
    15a0:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    15a2:	60100593          	li	a1,1537
    15a6:	00005517          	auipc	a0,0x5
    15aa:	bba50513          	add	a0,a0,-1094 # 6160 <malloc+0x184>
    15ae:	00004097          	auipc	ra,0x4
    15b2:	64e080e7          	jalr	1614(ra) # 5bfc <open>
    15b6:	00004097          	auipc	ra,0x4
    15ba:	62e080e7          	jalr	1582(ra) # 5be4 <close>
  pid = fork();
    15be:	00004097          	auipc	ra,0x4
    15c2:	5f6080e7          	jalr	1526(ra) # 5bb4 <fork>
  if(pid < 0){
    15c6:	08054063          	bltz	a0,1646 <truncate3+0xb8>
  if(pid == 0){
    15ca:	e969                	bnez	a0,169c <truncate3+0x10e>
    15cc:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15d0:	00005a17          	auipc	s4,0x5
    15d4:	b90a0a13          	add	s4,s4,-1136 # 6160 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    15d8:	00005a97          	auipc	s5,0x5
    15dc:	3e8a8a93          	add	s5,s5,1000 # 69c0 <malloc+0x9e4>
      int fd = open("truncfile", O_WRONLY);
    15e0:	4585                	li	a1,1
    15e2:	8552                	mv	a0,s4
    15e4:	00004097          	auipc	ra,0x4
    15e8:	618080e7          	jalr	1560(ra) # 5bfc <open>
    15ec:	84aa                	mv	s1,a0
      if(fd < 0){
    15ee:	06054a63          	bltz	a0,1662 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15f2:	4629                	li	a2,10
    15f4:	85d6                	mv	a1,s5
    15f6:	00004097          	auipc	ra,0x4
    15fa:	5e6080e7          	jalr	1510(ra) # 5bdc <write>
      if(n != 10){
    15fe:	47a9                	li	a5,10
    1600:	06f51f63          	bne	a0,a5,167e <truncate3+0xf0>
      close(fd);
    1604:	8526                	mv	a0,s1
    1606:	00004097          	auipc	ra,0x4
    160a:	5de080e7          	jalr	1502(ra) # 5be4 <close>
      fd = open("truncfile", O_RDONLY);
    160e:	4581                	li	a1,0
    1610:	8552                	mv	a0,s4
    1612:	00004097          	auipc	ra,0x4
    1616:	5ea080e7          	jalr	1514(ra) # 5bfc <open>
    161a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    161c:	02000613          	li	a2,32
    1620:	f9840593          	add	a1,s0,-104
    1624:	00004097          	auipc	ra,0x4
    1628:	5b0080e7          	jalr	1456(ra) # 5bd4 <read>
      close(fd);
    162c:	8526                	mv	a0,s1
    162e:	00004097          	auipc	ra,0x4
    1632:	5b6080e7          	jalr	1462(ra) # 5be4 <close>
    for(int i = 0; i < 100; i++){
    1636:	39fd                	addw	s3,s3,-1
    1638:	fa0994e3          	bnez	s3,15e0 <truncate3+0x52>
    exit(0);
    163c:	4501                	li	a0,0
    163e:	00004097          	auipc	ra,0x4
    1642:	57e080e7          	jalr	1406(ra) # 5bbc <exit>
    printf("%s: fork failed\n", s);
    1646:	85ca                	mv	a1,s2
    1648:	00005517          	auipc	a0,0x5
    164c:	34850513          	add	a0,a0,840 # 6990 <malloc+0x9b4>
    1650:	00005097          	auipc	ra,0x5
    1654:	8d4080e7          	jalr	-1836(ra) # 5f24 <printf>
    exit(1);
    1658:	4505                	li	a0,1
    165a:	00004097          	auipc	ra,0x4
    165e:	562080e7          	jalr	1378(ra) # 5bbc <exit>
        printf("%s: open failed\n", s);
    1662:	85ca                	mv	a1,s2
    1664:	00005517          	auipc	a0,0x5
    1668:	34450513          	add	a0,a0,836 # 69a8 <malloc+0x9cc>
    166c:	00005097          	auipc	ra,0x5
    1670:	8b8080e7          	jalr	-1864(ra) # 5f24 <printf>
        exit(1);
    1674:	4505                	li	a0,1
    1676:	00004097          	auipc	ra,0x4
    167a:	546080e7          	jalr	1350(ra) # 5bbc <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    167e:	862a                	mv	a2,a0
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	34e50513          	add	a0,a0,846 # 69d0 <malloc+0x9f4>
    168a:	00005097          	auipc	ra,0x5
    168e:	89a080e7          	jalr	-1894(ra) # 5f24 <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	00004097          	auipc	ra,0x4
    1698:	528080e7          	jalr	1320(ra) # 5bbc <exit>
    169c:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a0:	00005a17          	auipc	s4,0x5
    16a4:	ac0a0a13          	add	s4,s4,-1344 # 6160 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    16a8:	00005a97          	auipc	s5,0x5
    16ac:	348a8a93          	add	s5,s5,840 # 69f0 <malloc+0xa14>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b0:	60100593          	li	a1,1537
    16b4:	8552                	mv	a0,s4
    16b6:	00004097          	auipc	ra,0x4
    16ba:	546080e7          	jalr	1350(ra) # 5bfc <open>
    16be:	84aa                	mv	s1,a0
    if(fd < 0){
    16c0:	04054763          	bltz	a0,170e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16c4:	460d                	li	a2,3
    16c6:	85d6                	mv	a1,s5
    16c8:	00004097          	auipc	ra,0x4
    16cc:	514080e7          	jalr	1300(ra) # 5bdc <write>
    if(n != 3){
    16d0:	478d                	li	a5,3
    16d2:	04f51c63          	bne	a0,a5,172a <truncate3+0x19c>
    close(fd);
    16d6:	8526                	mv	a0,s1
    16d8:	00004097          	auipc	ra,0x4
    16dc:	50c080e7          	jalr	1292(ra) # 5be4 <close>
  for(int i = 0; i < 150; i++){
    16e0:	39fd                	addw	s3,s3,-1
    16e2:	fc0997e3          	bnez	s3,16b0 <truncate3+0x122>
  wait(&xstatus);
    16e6:	fbc40513          	add	a0,s0,-68
    16ea:	00004097          	auipc	ra,0x4
    16ee:	4da080e7          	jalr	1242(ra) # 5bc4 <wait>
  unlink("truncfile");
    16f2:	00005517          	auipc	a0,0x5
    16f6:	a6e50513          	add	a0,a0,-1426 # 6160 <malloc+0x184>
    16fa:	00004097          	auipc	ra,0x4
    16fe:	512080e7          	jalr	1298(ra) # 5c0c <unlink>
  exit(xstatus);
    1702:	fbc42503          	lw	a0,-68(s0)
    1706:	00004097          	auipc	ra,0x4
    170a:	4b6080e7          	jalr	1206(ra) # 5bbc <exit>
      printf("%s: open failed\n", s);
    170e:	85ca                	mv	a1,s2
    1710:	00005517          	auipc	a0,0x5
    1714:	29850513          	add	a0,a0,664 # 69a8 <malloc+0x9cc>
    1718:	00005097          	auipc	ra,0x5
    171c:	80c080e7          	jalr	-2036(ra) # 5f24 <printf>
      exit(1);
    1720:	4505                	li	a0,1
    1722:	00004097          	auipc	ra,0x4
    1726:	49a080e7          	jalr	1178(ra) # 5bbc <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    172a:	862a                	mv	a2,a0
    172c:	85ca                	mv	a1,s2
    172e:	00005517          	auipc	a0,0x5
    1732:	2ca50513          	add	a0,a0,714 # 69f8 <malloc+0xa1c>
    1736:	00004097          	auipc	ra,0x4
    173a:	7ee080e7          	jalr	2030(ra) # 5f24 <printf>
      exit(1);
    173e:	4505                	li	a0,1
    1740:	00004097          	auipc	ra,0x4
    1744:	47c080e7          	jalr	1148(ra) # 5bbc <exit>

0000000000001748 <exectest>:
{
    1748:	715d                	add	sp,sp,-80
    174a:	e486                	sd	ra,72(sp)
    174c:	e0a2                	sd	s0,64(sp)
    174e:	fc26                	sd	s1,56(sp)
    1750:	f84a                	sd	s2,48(sp)
    1752:	0880                	add	s0,sp,80
    1754:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1756:	00005797          	auipc	a5,0x5
    175a:	9b278793          	add	a5,a5,-1614 # 6108 <malloc+0x12c>
    175e:	fcf43023          	sd	a5,-64(s0)
    1762:	00005797          	auipc	a5,0x5
    1766:	2b678793          	add	a5,a5,694 # 6a18 <malloc+0xa3c>
    176a:	fcf43423          	sd	a5,-56(s0)
    176e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1772:	00005517          	auipc	a0,0x5
    1776:	2ae50513          	add	a0,a0,686 # 6a20 <malloc+0xa44>
    177a:	00004097          	auipc	ra,0x4
    177e:	492080e7          	jalr	1170(ra) # 5c0c <unlink>
  pid = fork();
    1782:	00004097          	auipc	ra,0x4
    1786:	432080e7          	jalr	1074(ra) # 5bb4 <fork>
  if(pid < 0) {
    178a:	04054663          	bltz	a0,17d6 <exectest+0x8e>
    178e:	84aa                	mv	s1,a0
  if(pid == 0) {
    1790:	e959                	bnez	a0,1826 <exectest+0xde>
    close(1);
    1792:	4505                	li	a0,1
    1794:	00004097          	auipc	ra,0x4
    1798:	450080e7          	jalr	1104(ra) # 5be4 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    179c:	20100593          	li	a1,513
    17a0:	00005517          	auipc	a0,0x5
    17a4:	28050513          	add	a0,a0,640 # 6a20 <malloc+0xa44>
    17a8:	00004097          	auipc	ra,0x4
    17ac:	454080e7          	jalr	1108(ra) # 5bfc <open>
    if(fd < 0) {
    17b0:	04054163          	bltz	a0,17f2 <exectest+0xaa>
    if(fd != 1) {
    17b4:	4785                	li	a5,1
    17b6:	04f50c63          	beq	a0,a5,180e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17ba:	85ca                	mv	a1,s2
    17bc:	00005517          	auipc	a0,0x5
    17c0:	28450513          	add	a0,a0,644 # 6a40 <malloc+0xa64>
    17c4:	00004097          	auipc	ra,0x4
    17c8:	760080e7          	jalr	1888(ra) # 5f24 <printf>
      exit(1);
    17cc:	4505                	li	a0,1
    17ce:	00004097          	auipc	ra,0x4
    17d2:	3ee080e7          	jalr	1006(ra) # 5bbc <exit>
     printf("%s: fork failed\n", s);
    17d6:	85ca                	mv	a1,s2
    17d8:	00005517          	auipc	a0,0x5
    17dc:	1b850513          	add	a0,a0,440 # 6990 <malloc+0x9b4>
    17e0:	00004097          	auipc	ra,0x4
    17e4:	744080e7          	jalr	1860(ra) # 5f24 <printf>
     exit(1);
    17e8:	4505                	li	a0,1
    17ea:	00004097          	auipc	ra,0x4
    17ee:	3d2080e7          	jalr	978(ra) # 5bbc <exit>
      printf("%s: create failed\n", s);
    17f2:	85ca                	mv	a1,s2
    17f4:	00005517          	auipc	a0,0x5
    17f8:	23450513          	add	a0,a0,564 # 6a28 <malloc+0xa4c>
    17fc:	00004097          	auipc	ra,0x4
    1800:	728080e7          	jalr	1832(ra) # 5f24 <printf>
      exit(1);
    1804:	4505                	li	a0,1
    1806:	00004097          	auipc	ra,0x4
    180a:	3b6080e7          	jalr	950(ra) # 5bbc <exit>
    if(exec("echo", echoargv) < 0){
    180e:	fc040593          	add	a1,s0,-64
    1812:	00005517          	auipc	a0,0x5
    1816:	8f650513          	add	a0,a0,-1802 # 6108 <malloc+0x12c>
    181a:	00004097          	auipc	ra,0x4
    181e:	3da080e7          	jalr	986(ra) # 5bf4 <exec>
    1822:	02054163          	bltz	a0,1844 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1826:	fdc40513          	add	a0,s0,-36
    182a:	00004097          	auipc	ra,0x4
    182e:	39a080e7          	jalr	922(ra) # 5bc4 <wait>
    1832:	02951763          	bne	a0,s1,1860 <exectest+0x118>
  if(xstatus != 0)
    1836:	fdc42503          	lw	a0,-36(s0)
    183a:	cd0d                	beqz	a0,1874 <exectest+0x12c>
    exit(xstatus);
    183c:	00004097          	auipc	ra,0x4
    1840:	380080e7          	jalr	896(ra) # 5bbc <exit>
      printf("%s: exec echo failed\n", s);
    1844:	85ca                	mv	a1,s2
    1846:	00005517          	auipc	a0,0x5
    184a:	20a50513          	add	a0,a0,522 # 6a50 <malloc+0xa74>
    184e:	00004097          	auipc	ra,0x4
    1852:	6d6080e7          	jalr	1750(ra) # 5f24 <printf>
      exit(1);
    1856:	4505                	li	a0,1
    1858:	00004097          	auipc	ra,0x4
    185c:	364080e7          	jalr	868(ra) # 5bbc <exit>
    printf("%s: wait failed!\n", s);
    1860:	85ca                	mv	a1,s2
    1862:	00005517          	auipc	a0,0x5
    1866:	20650513          	add	a0,a0,518 # 6a68 <malloc+0xa8c>
    186a:	00004097          	auipc	ra,0x4
    186e:	6ba080e7          	jalr	1722(ra) # 5f24 <printf>
    1872:	b7d1                	j	1836 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1874:	4581                	li	a1,0
    1876:	00005517          	auipc	a0,0x5
    187a:	1aa50513          	add	a0,a0,426 # 6a20 <malloc+0xa44>
    187e:	00004097          	auipc	ra,0x4
    1882:	37e080e7          	jalr	894(ra) # 5bfc <open>
  if(fd < 0) {
    1886:	02054a63          	bltz	a0,18ba <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    188a:	4609                	li	a2,2
    188c:	fb840593          	add	a1,s0,-72
    1890:	00004097          	auipc	ra,0x4
    1894:	344080e7          	jalr	836(ra) # 5bd4 <read>
    1898:	4789                	li	a5,2
    189a:	02f50e63          	beq	a0,a5,18d6 <exectest+0x18e>
    printf("%s: read failed\n", s);
    189e:	85ca                	mv	a1,s2
    18a0:	00005517          	auipc	a0,0x5
    18a4:	c3850513          	add	a0,a0,-968 # 64d8 <malloc+0x4fc>
    18a8:	00004097          	auipc	ra,0x4
    18ac:	67c080e7          	jalr	1660(ra) # 5f24 <printf>
    exit(1);
    18b0:	4505                	li	a0,1
    18b2:	00004097          	auipc	ra,0x4
    18b6:	30a080e7          	jalr	778(ra) # 5bbc <exit>
    printf("%s: open failed\n", s);
    18ba:	85ca                	mv	a1,s2
    18bc:	00005517          	auipc	a0,0x5
    18c0:	0ec50513          	add	a0,a0,236 # 69a8 <malloc+0x9cc>
    18c4:	00004097          	auipc	ra,0x4
    18c8:	660080e7          	jalr	1632(ra) # 5f24 <printf>
    exit(1);
    18cc:	4505                	li	a0,1
    18ce:	00004097          	auipc	ra,0x4
    18d2:	2ee080e7          	jalr	750(ra) # 5bbc <exit>
  unlink("echo-ok");
    18d6:	00005517          	auipc	a0,0x5
    18da:	14a50513          	add	a0,a0,330 # 6a20 <malloc+0xa44>
    18de:	00004097          	auipc	ra,0x4
    18e2:	32e080e7          	jalr	814(ra) # 5c0c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e6:	fb844703          	lbu	a4,-72(s0)
    18ea:	04f00793          	li	a5,79
    18ee:	00f71863          	bne	a4,a5,18fe <exectest+0x1b6>
    18f2:	fb944703          	lbu	a4,-71(s0)
    18f6:	04b00793          	li	a5,75
    18fa:	02f70063          	beq	a4,a5,191a <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18fe:	85ca                	mv	a1,s2
    1900:	00005517          	auipc	a0,0x5
    1904:	18050513          	add	a0,a0,384 # 6a80 <malloc+0xaa4>
    1908:	00004097          	auipc	ra,0x4
    190c:	61c080e7          	jalr	1564(ra) # 5f24 <printf>
    exit(1);
    1910:	4505                	li	a0,1
    1912:	00004097          	auipc	ra,0x4
    1916:	2aa080e7          	jalr	682(ra) # 5bbc <exit>
    exit(0);
    191a:	4501                	li	a0,0
    191c:	00004097          	auipc	ra,0x4
    1920:	2a0080e7          	jalr	672(ra) # 5bbc <exit>

0000000000001924 <pipe1>:
{
    1924:	711d                	add	sp,sp,-96
    1926:	ec86                	sd	ra,88(sp)
    1928:	e8a2                	sd	s0,80(sp)
    192a:	e4a6                	sd	s1,72(sp)
    192c:	e0ca                	sd	s2,64(sp)
    192e:	fc4e                	sd	s3,56(sp)
    1930:	f852                	sd	s4,48(sp)
    1932:	f456                	sd	s5,40(sp)
    1934:	f05a                	sd	s6,32(sp)
    1936:	ec5e                	sd	s7,24(sp)
    1938:	1080                	add	s0,sp,96
    193a:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    193c:	fa840513          	add	a0,s0,-88
    1940:	00004097          	auipc	ra,0x4
    1944:	28c080e7          	jalr	652(ra) # 5bcc <pipe>
    1948:	e93d                	bnez	a0,19be <pipe1+0x9a>
    194a:	84aa                	mv	s1,a0
  pid = fork();
    194c:	00004097          	auipc	ra,0x4
    1950:	268080e7          	jalr	616(ra) # 5bb4 <fork>
    1954:	8a2a                	mv	s4,a0
  if(pid == 0){
    1956:	c151                	beqz	a0,19da <pipe1+0xb6>
  } else if(pid > 0){
    1958:	16a05d63          	blez	a0,1ad2 <pipe1+0x1ae>
    close(fds[1]);
    195c:	fac42503          	lw	a0,-84(s0)
    1960:	00004097          	auipc	ra,0x4
    1964:	284080e7          	jalr	644(ra) # 5be4 <close>
    total = 0;
    1968:	8a26                	mv	s4,s1
    cc = 1;
    196a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    196c:	0000ba97          	auipc	s5,0xb
    1970:	30ca8a93          	add	s5,s5,780 # cc78 <buf>
    1974:	864e                	mv	a2,s3
    1976:	85d6                	mv	a1,s5
    1978:	fa842503          	lw	a0,-88(s0)
    197c:	00004097          	auipc	ra,0x4
    1980:	258080e7          	jalr	600(ra) # 5bd4 <read>
    1984:	10a05263          	blez	a0,1a88 <pipe1+0x164>
      for(i = 0; i < n; i++){
    1988:	0000b717          	auipc	a4,0xb
    198c:	2f070713          	add	a4,a4,752 # cc78 <buf>
    1990:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1994:	00074683          	lbu	a3,0(a4)
    1998:	0ff4f793          	zext.b	a5,s1
    199c:	2485                	addw	s1,s1,1
    199e:	0cf69163          	bne	a3,a5,1a60 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    19a2:	0705                	add	a4,a4,1
    19a4:	fec498e3          	bne	s1,a2,1994 <pipe1+0x70>
      total += n;
    19a8:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19ac:	0019979b          	sllw	a5,s3,0x1
    19b0:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b4:	670d                	lui	a4,0x3
    19b6:	fb377fe3          	bgeu	a4,s3,1974 <pipe1+0x50>
        cc = sizeof(buf);
    19ba:	698d                	lui	s3,0x3
    19bc:	bf65                	j	1974 <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    19be:	85ca                	mv	a1,s2
    19c0:	00005517          	auipc	a0,0x5
    19c4:	0d850513          	add	a0,a0,216 # 6a98 <malloc+0xabc>
    19c8:	00004097          	auipc	ra,0x4
    19cc:	55c080e7          	jalr	1372(ra) # 5f24 <printf>
    exit(1);
    19d0:	4505                	li	a0,1
    19d2:	00004097          	auipc	ra,0x4
    19d6:	1ea080e7          	jalr	490(ra) # 5bbc <exit>
    close(fds[0]);
    19da:	fa842503          	lw	a0,-88(s0)
    19de:	00004097          	auipc	ra,0x4
    19e2:	206080e7          	jalr	518(ra) # 5be4 <close>
    for(n = 0; n < N; n++){
    19e6:	0000bb17          	auipc	s6,0xb
    19ea:	292b0b13          	add	s6,s6,658 # cc78 <buf>
    19ee:	416004bb          	negw	s1,s6
    19f2:	0ff4f493          	zext.b	s1,s1
    19f6:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19fa:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19fc:	6a85                	lui	s5,0x1
    19fe:	42da8a93          	add	s5,s5,1069 # 142d <copyinstr2+0x95>
{
    1a02:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a04:	0097873b          	addw	a4,a5,s1
    1a08:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a0c:	0785                	add	a5,a5,1
    1a0e:	fef99be3          	bne	s3,a5,1a04 <pipe1+0xe0>
        buf[i] = seq++;
    1a12:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a16:	40900613          	li	a2,1033
    1a1a:	85de                	mv	a1,s7
    1a1c:	fac42503          	lw	a0,-84(s0)
    1a20:	00004097          	auipc	ra,0x4
    1a24:	1bc080e7          	jalr	444(ra) # 5bdc <write>
    1a28:	40900793          	li	a5,1033
    1a2c:	00f51c63          	bne	a0,a5,1a44 <pipe1+0x120>
    for(n = 0; n < N; n++){
    1a30:	24a5                	addw	s1,s1,9
    1a32:	0ff4f493          	zext.b	s1,s1
    1a36:	fd5a16e3          	bne	s4,s5,1a02 <pipe1+0xde>
    exit(0);
    1a3a:	4501                	li	a0,0
    1a3c:	00004097          	auipc	ra,0x4
    1a40:	180080e7          	jalr	384(ra) # 5bbc <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a44:	85ca                	mv	a1,s2
    1a46:	00005517          	auipc	a0,0x5
    1a4a:	06a50513          	add	a0,a0,106 # 6ab0 <malloc+0xad4>
    1a4e:	00004097          	auipc	ra,0x4
    1a52:	4d6080e7          	jalr	1238(ra) # 5f24 <printf>
        exit(1);
    1a56:	4505                	li	a0,1
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	164080e7          	jalr	356(ra) # 5bbc <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a60:	85ca                	mv	a1,s2
    1a62:	00005517          	auipc	a0,0x5
    1a66:	06650513          	add	a0,a0,102 # 6ac8 <malloc+0xaec>
    1a6a:	00004097          	auipc	ra,0x4
    1a6e:	4ba080e7          	jalr	1210(ra) # 5f24 <printf>
}
    1a72:	60e6                	ld	ra,88(sp)
    1a74:	6446                	ld	s0,80(sp)
    1a76:	64a6                	ld	s1,72(sp)
    1a78:	6906                	ld	s2,64(sp)
    1a7a:	79e2                	ld	s3,56(sp)
    1a7c:	7a42                	ld	s4,48(sp)
    1a7e:	7aa2                	ld	s5,40(sp)
    1a80:	7b02                	ld	s6,32(sp)
    1a82:	6be2                	ld	s7,24(sp)
    1a84:	6125                	add	sp,sp,96
    1a86:	8082                	ret
    if(total != N * SZ){
    1a88:	6785                	lui	a5,0x1
    1a8a:	42d78793          	add	a5,a5,1069 # 142d <copyinstr2+0x95>
    1a8e:	02fa0063          	beq	s4,a5,1aae <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a92:	85d2                	mv	a1,s4
    1a94:	00005517          	auipc	a0,0x5
    1a98:	04c50513          	add	a0,a0,76 # 6ae0 <malloc+0xb04>
    1a9c:	00004097          	auipc	ra,0x4
    1aa0:	488080e7          	jalr	1160(ra) # 5f24 <printf>
      exit(1);
    1aa4:	4505                	li	a0,1
    1aa6:	00004097          	auipc	ra,0x4
    1aaa:	116080e7          	jalr	278(ra) # 5bbc <exit>
    close(fds[0]);
    1aae:	fa842503          	lw	a0,-88(s0)
    1ab2:	00004097          	auipc	ra,0x4
    1ab6:	132080e7          	jalr	306(ra) # 5be4 <close>
    wait(&xstatus);
    1aba:	fa440513          	add	a0,s0,-92
    1abe:	00004097          	auipc	ra,0x4
    1ac2:	106080e7          	jalr	262(ra) # 5bc4 <wait>
    exit(xstatus);
    1ac6:	fa442503          	lw	a0,-92(s0)
    1aca:	00004097          	auipc	ra,0x4
    1ace:	0f2080e7          	jalr	242(ra) # 5bbc <exit>
    printf("%s: fork() failed\n", s);
    1ad2:	85ca                	mv	a1,s2
    1ad4:	00005517          	auipc	a0,0x5
    1ad8:	02c50513          	add	a0,a0,44 # 6b00 <malloc+0xb24>
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	448080e7          	jalr	1096(ra) # 5f24 <printf>
    exit(1);
    1ae4:	4505                	li	a0,1
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	0d6080e7          	jalr	214(ra) # 5bbc <exit>

0000000000001aee <exitwait>:
{
    1aee:	7139                	add	sp,sp,-64
    1af0:	fc06                	sd	ra,56(sp)
    1af2:	f822                	sd	s0,48(sp)
    1af4:	f426                	sd	s1,40(sp)
    1af6:	f04a                	sd	s2,32(sp)
    1af8:	ec4e                	sd	s3,24(sp)
    1afa:	e852                	sd	s4,16(sp)
    1afc:	0080                	add	s0,sp,64
    1afe:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b00:	4901                	li	s2,0
    1b02:	06400993          	li	s3,100
    pid = fork();
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	0ae080e7          	jalr	174(ra) # 5bb4 <fork>
    1b0e:	84aa                	mv	s1,a0
    if(pid < 0){
    1b10:	02054a63          	bltz	a0,1b44 <exitwait+0x56>
    if(pid){
    1b14:	c151                	beqz	a0,1b98 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b16:	fcc40513          	add	a0,s0,-52
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	0aa080e7          	jalr	170(ra) # 5bc4 <wait>
    1b22:	02951f63          	bne	a0,s1,1b60 <exitwait+0x72>
      if(i != xstate) {
    1b26:	fcc42783          	lw	a5,-52(s0)
    1b2a:	05279963          	bne	a5,s2,1b7c <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b2e:	2905                	addw	s2,s2,1
    1b30:	fd391be3          	bne	s2,s3,1b06 <exitwait+0x18>
}
    1b34:	70e2                	ld	ra,56(sp)
    1b36:	7442                	ld	s0,48(sp)
    1b38:	74a2                	ld	s1,40(sp)
    1b3a:	7902                	ld	s2,32(sp)
    1b3c:	69e2                	ld	s3,24(sp)
    1b3e:	6a42                	ld	s4,16(sp)
    1b40:	6121                	add	sp,sp,64
    1b42:	8082                	ret
      printf("%s: fork failed\n", s);
    1b44:	85d2                	mv	a1,s4
    1b46:	00005517          	auipc	a0,0x5
    1b4a:	e4a50513          	add	a0,a0,-438 # 6990 <malloc+0x9b4>
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	3d6080e7          	jalr	982(ra) # 5f24 <printf>
      exit(1);
    1b56:	4505                	li	a0,1
    1b58:	00004097          	auipc	ra,0x4
    1b5c:	064080e7          	jalr	100(ra) # 5bbc <exit>
        printf("%s: wait wrong pid\n", s);
    1b60:	85d2                	mv	a1,s4
    1b62:	00005517          	auipc	a0,0x5
    1b66:	fb650513          	add	a0,a0,-74 # 6b18 <malloc+0xb3c>
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	3ba080e7          	jalr	954(ra) # 5f24 <printf>
        exit(1);
    1b72:	4505                	li	a0,1
    1b74:	00004097          	auipc	ra,0x4
    1b78:	048080e7          	jalr	72(ra) # 5bbc <exit>
        printf("%s: wait wrong exit status\n", s);
    1b7c:	85d2                	mv	a1,s4
    1b7e:	00005517          	auipc	a0,0x5
    1b82:	fb250513          	add	a0,a0,-78 # 6b30 <malloc+0xb54>
    1b86:	00004097          	auipc	ra,0x4
    1b8a:	39e080e7          	jalr	926(ra) # 5f24 <printf>
        exit(1);
    1b8e:	4505                	li	a0,1
    1b90:	00004097          	auipc	ra,0x4
    1b94:	02c080e7          	jalr	44(ra) # 5bbc <exit>
      exit(i);
    1b98:	854a                	mv	a0,s2
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	022080e7          	jalr	34(ra) # 5bbc <exit>

0000000000001ba2 <twochildren>:
{
    1ba2:	1101                	add	sp,sp,-32
    1ba4:	ec06                	sd	ra,24(sp)
    1ba6:	e822                	sd	s0,16(sp)
    1ba8:	e426                	sd	s1,8(sp)
    1baa:	e04a                	sd	s2,0(sp)
    1bac:	1000                	add	s0,sp,32
    1bae:	892a                	mv	s2,a0
    1bb0:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb4:	00004097          	auipc	ra,0x4
    1bb8:	000080e7          	jalr	ra # 5bb4 <fork>
    if(pid1 < 0){
    1bbc:	02054c63          	bltz	a0,1bf4 <twochildren+0x52>
    if(pid1 == 0){
    1bc0:	c921                	beqz	a0,1c10 <twochildren+0x6e>
      int pid2 = fork();
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	ff2080e7          	jalr	-14(ra) # 5bb4 <fork>
      if(pid2 < 0){
    1bca:	04054763          	bltz	a0,1c18 <twochildren+0x76>
      if(pid2 == 0){
    1bce:	c13d                	beqz	a0,1c34 <twochildren+0x92>
        wait(0);
    1bd0:	4501                	li	a0,0
    1bd2:	00004097          	auipc	ra,0x4
    1bd6:	ff2080e7          	jalr	-14(ra) # 5bc4 <wait>
        wait(0);
    1bda:	4501                	li	a0,0
    1bdc:	00004097          	auipc	ra,0x4
    1be0:	fe8080e7          	jalr	-24(ra) # 5bc4 <wait>
  for(int i = 0; i < 1000; i++){
    1be4:	34fd                	addw	s1,s1,-1
    1be6:	f4f9                	bnez	s1,1bb4 <twochildren+0x12>
}
    1be8:	60e2                	ld	ra,24(sp)
    1bea:	6442                	ld	s0,16(sp)
    1bec:	64a2                	ld	s1,8(sp)
    1bee:	6902                	ld	s2,0(sp)
    1bf0:	6105                	add	sp,sp,32
    1bf2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf4:	85ca                	mv	a1,s2
    1bf6:	00005517          	auipc	a0,0x5
    1bfa:	d9a50513          	add	a0,a0,-614 # 6990 <malloc+0x9b4>
    1bfe:	00004097          	auipc	ra,0x4
    1c02:	326080e7          	jalr	806(ra) # 5f24 <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	fb4080e7          	jalr	-76(ra) # 5bbc <exit>
      exit(0);
    1c10:	00004097          	auipc	ra,0x4
    1c14:	fac080e7          	jalr	-84(ra) # 5bbc <exit>
        printf("%s: fork failed\n", s);
    1c18:	85ca                	mv	a1,s2
    1c1a:	00005517          	auipc	a0,0x5
    1c1e:	d7650513          	add	a0,a0,-650 # 6990 <malloc+0x9b4>
    1c22:	00004097          	auipc	ra,0x4
    1c26:	302080e7          	jalr	770(ra) # 5f24 <printf>
        exit(1);
    1c2a:	4505                	li	a0,1
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	f90080e7          	jalr	-112(ra) # 5bbc <exit>
        exit(0);
    1c34:	00004097          	auipc	ra,0x4
    1c38:	f88080e7          	jalr	-120(ra) # 5bbc <exit>

0000000000001c3c <forkfork>:
{
    1c3c:	7179                	add	sp,sp,-48
    1c3e:	f406                	sd	ra,40(sp)
    1c40:	f022                	sd	s0,32(sp)
    1c42:	ec26                	sd	s1,24(sp)
    1c44:	1800                	add	s0,sp,48
    1c46:	84aa                	mv	s1,a0
    int pid = fork();
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	f6c080e7          	jalr	-148(ra) # 5bb4 <fork>
    if(pid < 0){
    1c50:	04054163          	bltz	a0,1c92 <forkfork+0x56>
    if(pid == 0){
    1c54:	cd29                	beqz	a0,1cae <forkfork+0x72>
    int pid = fork();
    1c56:	00004097          	auipc	ra,0x4
    1c5a:	f5e080e7          	jalr	-162(ra) # 5bb4 <fork>
    if(pid < 0){
    1c5e:	02054a63          	bltz	a0,1c92 <forkfork+0x56>
    if(pid == 0){
    1c62:	c531                	beqz	a0,1cae <forkfork+0x72>
    wait(&xstatus);
    1c64:	fdc40513          	add	a0,s0,-36
    1c68:	00004097          	auipc	ra,0x4
    1c6c:	f5c080e7          	jalr	-164(ra) # 5bc4 <wait>
    if(xstatus != 0) {
    1c70:	fdc42783          	lw	a5,-36(s0)
    1c74:	ebbd                	bnez	a5,1cea <forkfork+0xae>
    wait(&xstatus);
    1c76:	fdc40513          	add	a0,s0,-36
    1c7a:	00004097          	auipc	ra,0x4
    1c7e:	f4a080e7          	jalr	-182(ra) # 5bc4 <wait>
    if(xstatus != 0) {
    1c82:	fdc42783          	lw	a5,-36(s0)
    1c86:	e3b5                	bnez	a5,1cea <forkfork+0xae>
}
    1c88:	70a2                	ld	ra,40(sp)
    1c8a:	7402                	ld	s0,32(sp)
    1c8c:	64e2                	ld	s1,24(sp)
    1c8e:	6145                	add	sp,sp,48
    1c90:	8082                	ret
      printf("%s: fork failed", s);
    1c92:	85a6                	mv	a1,s1
    1c94:	00005517          	auipc	a0,0x5
    1c98:	ebc50513          	add	a0,a0,-324 # 6b50 <malloc+0xb74>
    1c9c:	00004097          	auipc	ra,0x4
    1ca0:	288080e7          	jalr	648(ra) # 5f24 <printf>
      exit(1);
    1ca4:	4505                	li	a0,1
    1ca6:	00004097          	auipc	ra,0x4
    1caa:	f16080e7          	jalr	-234(ra) # 5bbc <exit>
{
    1cae:	0c800493          	li	s1,200
        int pid1 = fork();
    1cb2:	00004097          	auipc	ra,0x4
    1cb6:	f02080e7          	jalr	-254(ra) # 5bb4 <fork>
        if(pid1 < 0){
    1cba:	00054f63          	bltz	a0,1cd8 <forkfork+0x9c>
        if(pid1 == 0){
    1cbe:	c115                	beqz	a0,1ce2 <forkfork+0xa6>
        wait(0);
    1cc0:	4501                	li	a0,0
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	f02080e7          	jalr	-254(ra) # 5bc4 <wait>
      for(int j = 0; j < 200; j++){
    1cca:	34fd                	addw	s1,s1,-1
    1ccc:	f0fd                	bnez	s1,1cb2 <forkfork+0x76>
      exit(0);
    1cce:	4501                	li	a0,0
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	eec080e7          	jalr	-276(ra) # 5bbc <exit>
          exit(1);
    1cd8:	4505                	li	a0,1
    1cda:	00004097          	auipc	ra,0x4
    1cde:	ee2080e7          	jalr	-286(ra) # 5bbc <exit>
          exit(0);
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	eda080e7          	jalr	-294(ra) # 5bbc <exit>
      printf("%s: fork in child failed", s);
    1cea:	85a6                	mv	a1,s1
    1cec:	00005517          	auipc	a0,0x5
    1cf0:	e7450513          	add	a0,a0,-396 # 6b60 <malloc+0xb84>
    1cf4:	00004097          	auipc	ra,0x4
    1cf8:	230080e7          	jalr	560(ra) # 5f24 <printf>
      exit(1);
    1cfc:	4505                	li	a0,1
    1cfe:	00004097          	auipc	ra,0x4
    1d02:	ebe080e7          	jalr	-322(ra) # 5bbc <exit>

0000000000001d06 <reparent2>:
{
    1d06:	1101                	add	sp,sp,-32
    1d08:	ec06                	sd	ra,24(sp)
    1d0a:	e822                	sd	s0,16(sp)
    1d0c:	e426                	sd	s1,8(sp)
    1d0e:	1000                	add	s0,sp,32
    1d10:	32000493          	li	s1,800
    int pid1 = fork();
    1d14:	00004097          	auipc	ra,0x4
    1d18:	ea0080e7          	jalr	-352(ra) # 5bb4 <fork>
    if(pid1 < 0){
    1d1c:	00054f63          	bltz	a0,1d3a <reparent2+0x34>
    if(pid1 == 0){
    1d20:	c915                	beqz	a0,1d54 <reparent2+0x4e>
    wait(0);
    1d22:	4501                	li	a0,0
    1d24:	00004097          	auipc	ra,0x4
    1d28:	ea0080e7          	jalr	-352(ra) # 5bc4 <wait>
  for(int i = 0; i < 800; i++){
    1d2c:	34fd                	addw	s1,s1,-1
    1d2e:	f0fd                	bnez	s1,1d14 <reparent2+0xe>
  exit(0);
    1d30:	4501                	li	a0,0
    1d32:	00004097          	auipc	ra,0x4
    1d36:	e8a080e7          	jalr	-374(ra) # 5bbc <exit>
      printf("fork failed\n");
    1d3a:	00005517          	auipc	a0,0x5
    1d3e:	05e50513          	add	a0,a0,94 # 6d98 <malloc+0xdbc>
    1d42:	00004097          	auipc	ra,0x4
    1d46:	1e2080e7          	jalr	482(ra) # 5f24 <printf>
      exit(1);
    1d4a:	4505                	li	a0,1
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	e70080e7          	jalr	-400(ra) # 5bbc <exit>
      fork();
    1d54:	00004097          	auipc	ra,0x4
    1d58:	e60080e7          	jalr	-416(ra) # 5bb4 <fork>
      fork();
    1d5c:	00004097          	auipc	ra,0x4
    1d60:	e58080e7          	jalr	-424(ra) # 5bb4 <fork>
      exit(0);
    1d64:	4501                	li	a0,0
    1d66:	00004097          	auipc	ra,0x4
    1d6a:	e56080e7          	jalr	-426(ra) # 5bbc <exit>

0000000000001d6e <createdelete>:
{
    1d6e:	7175                	add	sp,sp,-144
    1d70:	e506                	sd	ra,136(sp)
    1d72:	e122                	sd	s0,128(sp)
    1d74:	fca6                	sd	s1,120(sp)
    1d76:	f8ca                	sd	s2,112(sp)
    1d78:	f4ce                	sd	s3,104(sp)
    1d7a:	f0d2                	sd	s4,96(sp)
    1d7c:	ecd6                	sd	s5,88(sp)
    1d7e:	e8da                	sd	s6,80(sp)
    1d80:	e4de                	sd	s7,72(sp)
    1d82:	e0e2                	sd	s8,64(sp)
    1d84:	fc66                	sd	s9,56(sp)
    1d86:	0900                	add	s0,sp,144
    1d88:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d8a:	4901                	li	s2,0
    1d8c:	4991                	li	s3,4
    pid = fork();
    1d8e:	00004097          	auipc	ra,0x4
    1d92:	e26080e7          	jalr	-474(ra) # 5bb4 <fork>
    1d96:	84aa                	mv	s1,a0
    if(pid < 0){
    1d98:	02054f63          	bltz	a0,1dd6 <createdelete+0x68>
    if(pid == 0){
    1d9c:	c939                	beqz	a0,1df2 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d9e:	2905                	addw	s2,s2,1
    1da0:	ff3917e3          	bne	s2,s3,1d8e <createdelete+0x20>
    1da4:	4491                	li	s1,4
    wait(&xstatus);
    1da6:	f7c40513          	add	a0,s0,-132
    1daa:	00004097          	auipc	ra,0x4
    1dae:	e1a080e7          	jalr	-486(ra) # 5bc4 <wait>
    if(xstatus != 0)
    1db2:	f7c42903          	lw	s2,-132(s0)
    1db6:	0e091263          	bnez	s2,1e9a <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1dba:	34fd                	addw	s1,s1,-1
    1dbc:	f4ed                	bnez	s1,1da6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dbe:	f8040123          	sb	zero,-126(s0)
    1dc2:	03000993          	li	s3,48
    1dc6:	5a7d                	li	s4,-1
    1dc8:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dcc:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dce:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dd0:	07400a93          	li	s5,116
    1dd4:	a29d                	j	1f3a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd6:	85e6                	mv	a1,s9
    1dd8:	00005517          	auipc	a0,0x5
    1ddc:	fc050513          	add	a0,a0,-64 # 6d98 <malloc+0xdbc>
    1de0:	00004097          	auipc	ra,0x4
    1de4:	144080e7          	jalr	324(ra) # 5f24 <printf>
      exit(1);
    1de8:	4505                	li	a0,1
    1dea:	00004097          	auipc	ra,0x4
    1dee:	dd2080e7          	jalr	-558(ra) # 5bbc <exit>
      name[0] = 'p' + pi;
    1df2:	0709091b          	addw	s2,s2,112
    1df6:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1dfa:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1dfe:	4951                	li	s2,20
    1e00:	a015                	j	1e24 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e02:	85e6                	mv	a1,s9
    1e04:	00005517          	auipc	a0,0x5
    1e08:	c2450513          	add	a0,a0,-988 # 6a28 <malloc+0xa4c>
    1e0c:	00004097          	auipc	ra,0x4
    1e10:	118080e7          	jalr	280(ra) # 5f24 <printf>
          exit(1);
    1e14:	4505                	li	a0,1
    1e16:	00004097          	auipc	ra,0x4
    1e1a:	da6080e7          	jalr	-602(ra) # 5bbc <exit>
      for(i = 0; i < N; i++){
    1e1e:	2485                	addw	s1,s1,1
    1e20:	07248863          	beq	s1,s2,1e90 <createdelete+0x122>
        name[1] = '0' + i;
    1e24:	0304879b          	addw	a5,s1,48
    1e28:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e2c:	20200593          	li	a1,514
    1e30:	f8040513          	add	a0,s0,-128
    1e34:	00004097          	auipc	ra,0x4
    1e38:	dc8080e7          	jalr	-568(ra) # 5bfc <open>
        if(fd < 0){
    1e3c:	fc0543e3          	bltz	a0,1e02 <createdelete+0x94>
        close(fd);
    1e40:	00004097          	auipc	ra,0x4
    1e44:	da4080e7          	jalr	-604(ra) # 5be4 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e48:	fc905be3          	blez	s1,1e1e <createdelete+0xb0>
    1e4c:	0014f793          	and	a5,s1,1
    1e50:	f7f9                	bnez	a5,1e1e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e52:	01f4d79b          	srlw	a5,s1,0x1f
    1e56:	9fa5                	addw	a5,a5,s1
    1e58:	4017d79b          	sraw	a5,a5,0x1
    1e5c:	0307879b          	addw	a5,a5,48
    1e60:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e64:	f8040513          	add	a0,s0,-128
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	da4080e7          	jalr	-604(ra) # 5c0c <unlink>
    1e70:	fa0557e3          	bgez	a0,1e1e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e74:	85e6                	mv	a1,s9
    1e76:	00005517          	auipc	a0,0x5
    1e7a:	d0a50513          	add	a0,a0,-758 # 6b80 <malloc+0xba4>
    1e7e:	00004097          	auipc	ra,0x4
    1e82:	0a6080e7          	jalr	166(ra) # 5f24 <printf>
            exit(1);
    1e86:	4505                	li	a0,1
    1e88:	00004097          	auipc	ra,0x4
    1e8c:	d34080e7          	jalr	-716(ra) # 5bbc <exit>
      exit(0);
    1e90:	4501                	li	a0,0
    1e92:	00004097          	auipc	ra,0x4
    1e96:	d2a080e7          	jalr	-726(ra) # 5bbc <exit>
      exit(1);
    1e9a:	4505                	li	a0,1
    1e9c:	00004097          	auipc	ra,0x4
    1ea0:	d20080e7          	jalr	-736(ra) # 5bbc <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea4:	f8040613          	add	a2,s0,-128
    1ea8:	85e6                	mv	a1,s9
    1eaa:	00005517          	auipc	a0,0x5
    1eae:	cee50513          	add	a0,a0,-786 # 6b98 <malloc+0xbbc>
    1eb2:	00004097          	auipc	ra,0x4
    1eb6:	072080e7          	jalr	114(ra) # 5f24 <printf>
        exit(1);
    1eba:	4505                	li	a0,1
    1ebc:	00004097          	auipc	ra,0x4
    1ec0:	d00080e7          	jalr	-768(ra) # 5bbc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ec4:	054b7163          	bgeu	s6,s4,1f06 <createdelete+0x198>
      if(fd >= 0)
    1ec8:	02055a63          	bgez	a0,1efc <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ecc:	2485                	addw	s1,s1,1
    1ece:	0ff4f493          	zext.b	s1,s1
    1ed2:	05548c63          	beq	s1,s5,1f2a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1eda:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ede:	4581                	li	a1,0
    1ee0:	f8040513          	add	a0,s0,-128
    1ee4:	00004097          	auipc	ra,0x4
    1ee8:	d18080e7          	jalr	-744(ra) # 5bfc <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1eec:	00090463          	beqz	s2,1ef4 <createdelete+0x186>
    1ef0:	fd2bdae3          	bge	s7,s2,1ec4 <createdelete+0x156>
    1ef4:	fa0548e3          	bltz	a0,1ea4 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef8:	014b7963          	bgeu	s6,s4,1f0a <createdelete+0x19c>
        close(fd);
    1efc:	00004097          	auipc	ra,0x4
    1f00:	ce8080e7          	jalr	-792(ra) # 5be4 <close>
    1f04:	b7e1                	j	1ecc <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f06:	fc0543e3          	bltz	a0,1ecc <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f0a:	f8040613          	add	a2,s0,-128
    1f0e:	85e6                	mv	a1,s9
    1f10:	00005517          	auipc	a0,0x5
    1f14:	cb050513          	add	a0,a0,-848 # 6bc0 <malloc+0xbe4>
    1f18:	00004097          	auipc	ra,0x4
    1f1c:	00c080e7          	jalr	12(ra) # 5f24 <printf>
        exit(1);
    1f20:	4505                	li	a0,1
    1f22:	00004097          	auipc	ra,0x4
    1f26:	c9a080e7          	jalr	-870(ra) # 5bbc <exit>
  for(i = 0; i < N; i++){
    1f2a:	2905                	addw	s2,s2,1
    1f2c:	2a05                	addw	s4,s4,1
    1f2e:	2985                	addw	s3,s3,1 # 3001 <execout+0x9f>
    1f30:	0ff9f993          	zext.b	s3,s3
    1f34:	47d1                	li	a5,20
    1f36:	02f90a63          	beq	s2,a5,1f6a <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f3a:	84e2                	mv	s1,s8
    1f3c:	bf69                	j	1ed6 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f3e:	2905                	addw	s2,s2,1
    1f40:	0ff97913          	zext.b	s2,s2
    1f44:	2985                	addw	s3,s3,1
    1f46:	0ff9f993          	zext.b	s3,s3
    1f4a:	03490863          	beq	s2,s4,1f7a <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f4e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f50:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f54:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f58:	f8040513          	add	a0,s0,-128
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	cb0080e7          	jalr	-848(ra) # 5c0c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f64:	34fd                	addw	s1,s1,-1
    1f66:	f4ed                	bnez	s1,1f50 <createdelete+0x1e2>
    1f68:	bfd9                	j	1f3e <createdelete+0x1d0>
    1f6a:	03000993          	li	s3,48
    1f6e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f72:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f74:	08400a13          	li	s4,132
    1f78:	bfd9                	j	1f4e <createdelete+0x1e0>
}
    1f7a:	60aa                	ld	ra,136(sp)
    1f7c:	640a                	ld	s0,128(sp)
    1f7e:	74e6                	ld	s1,120(sp)
    1f80:	7946                	ld	s2,112(sp)
    1f82:	79a6                	ld	s3,104(sp)
    1f84:	7a06                	ld	s4,96(sp)
    1f86:	6ae6                	ld	s5,88(sp)
    1f88:	6b46                	ld	s6,80(sp)
    1f8a:	6ba6                	ld	s7,72(sp)
    1f8c:	6c06                	ld	s8,64(sp)
    1f8e:	7ce2                	ld	s9,56(sp)
    1f90:	6149                	add	sp,sp,144
    1f92:	8082                	ret

0000000000001f94 <linkunlink>:
{
    1f94:	711d                	add	sp,sp,-96
    1f96:	ec86                	sd	ra,88(sp)
    1f98:	e8a2                	sd	s0,80(sp)
    1f9a:	e4a6                	sd	s1,72(sp)
    1f9c:	e0ca                	sd	s2,64(sp)
    1f9e:	fc4e                	sd	s3,56(sp)
    1fa0:	f852                	sd	s4,48(sp)
    1fa2:	f456                	sd	s5,40(sp)
    1fa4:	f05a                	sd	s6,32(sp)
    1fa6:	ec5e                	sd	s7,24(sp)
    1fa8:	e862                	sd	s8,16(sp)
    1faa:	e466                	sd	s9,8(sp)
    1fac:	1080                	add	s0,sp,96
    1fae:	84aa                	mv	s1,a0
  unlink("x");
    1fb0:	00004517          	auipc	a0,0x4
    1fb4:	1c850513          	add	a0,a0,456 # 6178 <malloc+0x19c>
    1fb8:	00004097          	auipc	ra,0x4
    1fbc:	c54080e7          	jalr	-940(ra) # 5c0c <unlink>
  pid = fork();
    1fc0:	00004097          	auipc	ra,0x4
    1fc4:	bf4080e7          	jalr	-1036(ra) # 5bb4 <fork>
  if(pid < 0){
    1fc8:	02054b63          	bltz	a0,1ffe <linkunlink+0x6a>
    1fcc:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fce:	06100c93          	li	s9,97
    1fd2:	c111                	beqz	a0,1fd6 <linkunlink+0x42>
    1fd4:	4c85                	li	s9,1
    1fd6:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fda:	41c659b7          	lui	s3,0x41c65
    1fde:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1fe2:	690d                	lui	s2,0x3
    1fe4:	0399091b          	addw	s2,s2,57 # 3039 <fourteen+0x13>
    if((x % 3) == 0){
    1fe8:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fea:	4b05                	li	s6,1
      unlink("x");
    1fec:	00004a97          	auipc	s5,0x4
    1ff0:	18ca8a93          	add	s5,s5,396 # 6178 <malloc+0x19c>
      link("cat", "x");
    1ff4:	00005b97          	auipc	s7,0x5
    1ff8:	bf4b8b93          	add	s7,s7,-1036 # 6be8 <malloc+0xc0c>
    1ffc:	a825                	j	2034 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ffe:	85a6                	mv	a1,s1
    2000:	00005517          	auipc	a0,0x5
    2004:	99050513          	add	a0,a0,-1648 # 6990 <malloc+0x9b4>
    2008:	00004097          	auipc	ra,0x4
    200c:	f1c080e7          	jalr	-228(ra) # 5f24 <printf>
    exit(1);
    2010:	4505                	li	a0,1
    2012:	00004097          	auipc	ra,0x4
    2016:	baa080e7          	jalr	-1110(ra) # 5bbc <exit>
      close(open("x", O_RDWR | O_CREATE));
    201a:	20200593          	li	a1,514
    201e:	8556                	mv	a0,s5
    2020:	00004097          	auipc	ra,0x4
    2024:	bdc080e7          	jalr	-1060(ra) # 5bfc <open>
    2028:	00004097          	auipc	ra,0x4
    202c:	bbc080e7          	jalr	-1092(ra) # 5be4 <close>
  for(i = 0; i < 100; i++){
    2030:	34fd                	addw	s1,s1,-1
    2032:	c88d                	beqz	s1,2064 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2034:	033c87bb          	mulw	a5,s9,s3
    2038:	012787bb          	addw	a5,a5,s2
    203c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2040:	0347f7bb          	remuw	a5,a5,s4
    2044:	dbf9                	beqz	a5,201a <linkunlink+0x86>
    } else if((x % 3) == 1){
    2046:	01678863          	beq	a5,s6,2056 <linkunlink+0xc2>
      unlink("x");
    204a:	8556                	mv	a0,s5
    204c:	00004097          	auipc	ra,0x4
    2050:	bc0080e7          	jalr	-1088(ra) # 5c0c <unlink>
    2054:	bff1                	j	2030 <linkunlink+0x9c>
      link("cat", "x");
    2056:	85d6                	mv	a1,s5
    2058:	855e                	mv	a0,s7
    205a:	00004097          	auipc	ra,0x4
    205e:	bc2080e7          	jalr	-1086(ra) # 5c1c <link>
    2062:	b7f9                	j	2030 <linkunlink+0x9c>
  if(pid)
    2064:	020c0463          	beqz	s8,208c <linkunlink+0xf8>
    wait(0);
    2068:	4501                	li	a0,0
    206a:	00004097          	auipc	ra,0x4
    206e:	b5a080e7          	jalr	-1190(ra) # 5bc4 <wait>
}
    2072:	60e6                	ld	ra,88(sp)
    2074:	6446                	ld	s0,80(sp)
    2076:	64a6                	ld	s1,72(sp)
    2078:	6906                	ld	s2,64(sp)
    207a:	79e2                	ld	s3,56(sp)
    207c:	7a42                	ld	s4,48(sp)
    207e:	7aa2                	ld	s5,40(sp)
    2080:	7b02                	ld	s6,32(sp)
    2082:	6be2                	ld	s7,24(sp)
    2084:	6c42                	ld	s8,16(sp)
    2086:	6ca2                	ld	s9,8(sp)
    2088:	6125                	add	sp,sp,96
    208a:	8082                	ret
    exit(0);
    208c:	4501                	li	a0,0
    208e:	00004097          	auipc	ra,0x4
    2092:	b2e080e7          	jalr	-1234(ra) # 5bbc <exit>

0000000000002096 <forktest>:
{
    2096:	7179                	add	sp,sp,-48
    2098:	f406                	sd	ra,40(sp)
    209a:	f022                	sd	s0,32(sp)
    209c:	ec26                	sd	s1,24(sp)
    209e:	e84a                	sd	s2,16(sp)
    20a0:	e44e                	sd	s3,8(sp)
    20a2:	1800                	add	s0,sp,48
    20a4:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20a6:	4481                	li	s1,0
    20a8:	3e800913          	li	s2,1000
    pid = fork();
    20ac:	00004097          	auipc	ra,0x4
    20b0:	b08080e7          	jalr	-1272(ra) # 5bb4 <fork>
    if(pid < 0)
    20b4:	02054863          	bltz	a0,20e4 <forktest+0x4e>
    if(pid == 0)
    20b8:	c115                	beqz	a0,20dc <forktest+0x46>
  for(n=0; n<N; n++){
    20ba:	2485                	addw	s1,s1,1
    20bc:	ff2498e3          	bne	s1,s2,20ac <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20c0:	85ce                	mv	a1,s3
    20c2:	00005517          	auipc	a0,0x5
    20c6:	b4650513          	add	a0,a0,-1210 # 6c08 <malloc+0xc2c>
    20ca:	00004097          	auipc	ra,0x4
    20ce:	e5a080e7          	jalr	-422(ra) # 5f24 <printf>
    exit(1);
    20d2:	4505                	li	a0,1
    20d4:	00004097          	auipc	ra,0x4
    20d8:	ae8080e7          	jalr	-1304(ra) # 5bbc <exit>
      exit(0);
    20dc:	00004097          	auipc	ra,0x4
    20e0:	ae0080e7          	jalr	-1312(ra) # 5bbc <exit>
  if (n == 0) {
    20e4:	cc9d                	beqz	s1,2122 <forktest+0x8c>
  if(n == N){
    20e6:	3e800793          	li	a5,1000
    20ea:	fcf48be3          	beq	s1,a5,20c0 <forktest+0x2a>
  for(; n > 0; n--){
    20ee:	00905b63          	blez	s1,2104 <forktest+0x6e>
    if(wait(0) < 0){
    20f2:	4501                	li	a0,0
    20f4:	00004097          	auipc	ra,0x4
    20f8:	ad0080e7          	jalr	-1328(ra) # 5bc4 <wait>
    20fc:	04054163          	bltz	a0,213e <forktest+0xa8>
  for(; n > 0; n--){
    2100:	34fd                	addw	s1,s1,-1
    2102:	f8e5                	bnez	s1,20f2 <forktest+0x5c>
  if(wait(0) != -1){
    2104:	4501                	li	a0,0
    2106:	00004097          	auipc	ra,0x4
    210a:	abe080e7          	jalr	-1346(ra) # 5bc4 <wait>
    210e:	57fd                	li	a5,-1
    2110:	04f51563          	bne	a0,a5,215a <forktest+0xc4>
}
    2114:	70a2                	ld	ra,40(sp)
    2116:	7402                	ld	s0,32(sp)
    2118:	64e2                	ld	s1,24(sp)
    211a:	6942                	ld	s2,16(sp)
    211c:	69a2                	ld	s3,8(sp)
    211e:	6145                	add	sp,sp,48
    2120:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2122:	85ce                	mv	a1,s3
    2124:	00005517          	auipc	a0,0x5
    2128:	acc50513          	add	a0,a0,-1332 # 6bf0 <malloc+0xc14>
    212c:	00004097          	auipc	ra,0x4
    2130:	df8080e7          	jalr	-520(ra) # 5f24 <printf>
    exit(1);
    2134:	4505                	li	a0,1
    2136:	00004097          	auipc	ra,0x4
    213a:	a86080e7          	jalr	-1402(ra) # 5bbc <exit>
      printf("%s: wait stopped early\n", s);
    213e:	85ce                	mv	a1,s3
    2140:	00005517          	auipc	a0,0x5
    2144:	af050513          	add	a0,a0,-1296 # 6c30 <malloc+0xc54>
    2148:	00004097          	auipc	ra,0x4
    214c:	ddc080e7          	jalr	-548(ra) # 5f24 <printf>
      exit(1);
    2150:	4505                	li	a0,1
    2152:	00004097          	auipc	ra,0x4
    2156:	a6a080e7          	jalr	-1430(ra) # 5bbc <exit>
    printf("%s: wait got too many\n", s);
    215a:	85ce                	mv	a1,s3
    215c:	00005517          	auipc	a0,0x5
    2160:	aec50513          	add	a0,a0,-1300 # 6c48 <malloc+0xc6c>
    2164:	00004097          	auipc	ra,0x4
    2168:	dc0080e7          	jalr	-576(ra) # 5f24 <printf>
    exit(1);
    216c:	4505                	li	a0,1
    216e:	00004097          	auipc	ra,0x4
    2172:	a4e080e7          	jalr	-1458(ra) # 5bbc <exit>

0000000000002176 <kernmem>:
{
    2176:	715d                	add	sp,sp,-80
    2178:	e486                	sd	ra,72(sp)
    217a:	e0a2                	sd	s0,64(sp)
    217c:	fc26                	sd	s1,56(sp)
    217e:	f84a                	sd	s2,48(sp)
    2180:	f44e                	sd	s3,40(sp)
    2182:	f052                	sd	s4,32(sp)
    2184:	ec56                	sd	s5,24(sp)
    2186:	0880                	add	s0,sp,80
    2188:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218a:	4485                	li	s1,1
    218c:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    218e:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2190:	69b1                	lui	s3,0xc
    2192:	35098993          	add	s3,s3,848 # c350 <uninit+0x1de8>
    2196:	1003d937          	lui	s2,0x1003d
    219a:	090e                	sll	s2,s2,0x3
    219c:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21a0:	00004097          	auipc	ra,0x4
    21a4:	a14080e7          	jalr	-1516(ra) # 5bb4 <fork>
    if(pid < 0){
    21a8:	02054963          	bltz	a0,21da <kernmem+0x64>
    if(pid == 0){
    21ac:	c529                	beqz	a0,21f6 <kernmem+0x80>
    wait(&xstatus);
    21ae:	fbc40513          	add	a0,s0,-68
    21b2:	00004097          	auipc	ra,0x4
    21b6:	a12080e7          	jalr	-1518(ra) # 5bc4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21ba:	fbc42783          	lw	a5,-68(s0)
    21be:	05579d63          	bne	a5,s5,2218 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21c2:	94ce                	add	s1,s1,s3
    21c4:	fd249ee3          	bne	s1,s2,21a0 <kernmem+0x2a>
}
    21c8:	60a6                	ld	ra,72(sp)
    21ca:	6406                	ld	s0,64(sp)
    21cc:	74e2                	ld	s1,56(sp)
    21ce:	7942                	ld	s2,48(sp)
    21d0:	79a2                	ld	s3,40(sp)
    21d2:	7a02                	ld	s4,32(sp)
    21d4:	6ae2                	ld	s5,24(sp)
    21d6:	6161                	add	sp,sp,80
    21d8:	8082                	ret
      printf("%s: fork failed\n", s);
    21da:	85d2                	mv	a1,s4
    21dc:	00004517          	auipc	a0,0x4
    21e0:	7b450513          	add	a0,a0,1972 # 6990 <malloc+0x9b4>
    21e4:	00004097          	auipc	ra,0x4
    21e8:	d40080e7          	jalr	-704(ra) # 5f24 <printf>
      exit(1);
    21ec:	4505                	li	a0,1
    21ee:	00004097          	auipc	ra,0x4
    21f2:	9ce080e7          	jalr	-1586(ra) # 5bbc <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f6:	0004c683          	lbu	a3,0(s1)
    21fa:	8626                	mv	a2,s1
    21fc:	85d2                	mv	a1,s4
    21fe:	00005517          	auipc	a0,0x5
    2202:	a6250513          	add	a0,a0,-1438 # 6c60 <malloc+0xc84>
    2206:	00004097          	auipc	ra,0x4
    220a:	d1e080e7          	jalr	-738(ra) # 5f24 <printf>
      exit(1);
    220e:	4505                	li	a0,1
    2210:	00004097          	auipc	ra,0x4
    2214:	9ac080e7          	jalr	-1620(ra) # 5bbc <exit>
      exit(1);
    2218:	4505                	li	a0,1
    221a:	00004097          	auipc	ra,0x4
    221e:	9a2080e7          	jalr	-1630(ra) # 5bbc <exit>

0000000000002222 <MAXVAplus>:
{
    2222:	7179                	add	sp,sp,-48
    2224:	f406                	sd	ra,40(sp)
    2226:	f022                	sd	s0,32(sp)
    2228:	ec26                	sd	s1,24(sp)
    222a:	e84a                	sd	s2,16(sp)
    222c:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    222e:	4785                	li	a5,1
    2230:	179a                	sll	a5,a5,0x26
    2232:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2236:	fd843783          	ld	a5,-40(s0)
    223a:	cf85                	beqz	a5,2272 <MAXVAplus+0x50>
    223c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    223e:	54fd                	li	s1,-1
    pid = fork();
    2240:	00004097          	auipc	ra,0x4
    2244:	974080e7          	jalr	-1676(ra) # 5bb4 <fork>
    if(pid < 0){
    2248:	02054b63          	bltz	a0,227e <MAXVAplus+0x5c>
    if(pid == 0){
    224c:	c539                	beqz	a0,229a <MAXVAplus+0x78>
    wait(&xstatus);
    224e:	fd440513          	add	a0,s0,-44
    2252:	00004097          	auipc	ra,0x4
    2256:	972080e7          	jalr	-1678(ra) # 5bc4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    225a:	fd442783          	lw	a5,-44(s0)
    225e:	06979463          	bne	a5,s1,22c6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2262:	fd843783          	ld	a5,-40(s0)
    2266:	0786                	sll	a5,a5,0x1
    2268:	fcf43c23          	sd	a5,-40(s0)
    226c:	fd843783          	ld	a5,-40(s0)
    2270:	fbe1                	bnez	a5,2240 <MAXVAplus+0x1e>
}
    2272:	70a2                	ld	ra,40(sp)
    2274:	7402                	ld	s0,32(sp)
    2276:	64e2                	ld	s1,24(sp)
    2278:	6942                	ld	s2,16(sp)
    227a:	6145                	add	sp,sp,48
    227c:	8082                	ret
      printf("%s: fork failed\n", s);
    227e:	85ca                	mv	a1,s2
    2280:	00004517          	auipc	a0,0x4
    2284:	71050513          	add	a0,a0,1808 # 6990 <malloc+0x9b4>
    2288:	00004097          	auipc	ra,0x4
    228c:	c9c080e7          	jalr	-868(ra) # 5f24 <printf>
      exit(1);
    2290:	4505                	li	a0,1
    2292:	00004097          	auipc	ra,0x4
    2296:	92a080e7          	jalr	-1750(ra) # 5bbc <exit>
      *(char*)a = 99;
    229a:	fd843783          	ld	a5,-40(s0)
    229e:	06300713          	li	a4,99
    22a2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22a6:	fd843603          	ld	a2,-40(s0)
    22aa:	85ca                	mv	a1,s2
    22ac:	00005517          	auipc	a0,0x5
    22b0:	9d450513          	add	a0,a0,-1580 # 6c80 <malloc+0xca4>
    22b4:	00004097          	auipc	ra,0x4
    22b8:	c70080e7          	jalr	-912(ra) # 5f24 <printf>
      exit(1);
    22bc:	4505                	li	a0,1
    22be:	00004097          	auipc	ra,0x4
    22c2:	8fe080e7          	jalr	-1794(ra) # 5bbc <exit>
      exit(1);
    22c6:	4505                	li	a0,1
    22c8:	00004097          	auipc	ra,0x4
    22cc:	8f4080e7          	jalr	-1804(ra) # 5bbc <exit>

00000000000022d0 <bigargtest>:
{
    22d0:	7179                	add	sp,sp,-48
    22d2:	f406                	sd	ra,40(sp)
    22d4:	f022                	sd	s0,32(sp)
    22d6:	ec26                	sd	s1,24(sp)
    22d8:	1800                	add	s0,sp,48
    22da:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22dc:	00005517          	auipc	a0,0x5
    22e0:	9bc50513          	add	a0,a0,-1604 # 6c98 <malloc+0xcbc>
    22e4:	00004097          	auipc	ra,0x4
    22e8:	928080e7          	jalr	-1752(ra) # 5c0c <unlink>
  pid = fork();
    22ec:	00004097          	auipc	ra,0x4
    22f0:	8c8080e7          	jalr	-1848(ra) # 5bb4 <fork>
  if(pid == 0){
    22f4:	c121                	beqz	a0,2334 <bigargtest+0x64>
  } else if(pid < 0){
    22f6:	0a054063          	bltz	a0,2396 <bigargtest+0xc6>
  wait(&xstatus);
    22fa:	fdc40513          	add	a0,s0,-36
    22fe:	00004097          	auipc	ra,0x4
    2302:	8c6080e7          	jalr	-1850(ra) # 5bc4 <wait>
  if(xstatus != 0)
    2306:	fdc42503          	lw	a0,-36(s0)
    230a:	e545                	bnez	a0,23b2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    230c:	4581                	li	a1,0
    230e:	00005517          	auipc	a0,0x5
    2312:	98a50513          	add	a0,a0,-1654 # 6c98 <malloc+0xcbc>
    2316:	00004097          	auipc	ra,0x4
    231a:	8e6080e7          	jalr	-1818(ra) # 5bfc <open>
  if(fd < 0){
    231e:	08054e63          	bltz	a0,23ba <bigargtest+0xea>
  close(fd);
    2322:	00004097          	auipc	ra,0x4
    2326:	8c2080e7          	jalr	-1854(ra) # 5be4 <close>
}
    232a:	70a2                	ld	ra,40(sp)
    232c:	7402                	ld	s0,32(sp)
    232e:	64e2                	ld	s1,24(sp)
    2330:	6145                	add	sp,sp,48
    2332:	8082                	ret
    2334:	00007797          	auipc	a5,0x7
    2338:	12c78793          	add	a5,a5,300 # 9460 <args.1>
    233c:	00007697          	auipc	a3,0x7
    2340:	21c68693          	add	a3,a3,540 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2344:	00005717          	auipc	a4,0x5
    2348:	96470713          	add	a4,a4,-1692 # 6ca8 <malloc+0xccc>
    234c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    234e:	07a1                	add	a5,a5,8
    2350:	fed79ee3          	bne	a5,a3,234c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2354:	00007597          	auipc	a1,0x7
    2358:	10c58593          	add	a1,a1,268 # 9460 <args.1>
    235c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2360:	00004517          	auipc	a0,0x4
    2364:	da850513          	add	a0,a0,-600 # 6108 <malloc+0x12c>
    2368:	00004097          	auipc	ra,0x4
    236c:	88c080e7          	jalr	-1908(ra) # 5bf4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2370:	20000593          	li	a1,512
    2374:	00005517          	auipc	a0,0x5
    2378:	92450513          	add	a0,a0,-1756 # 6c98 <malloc+0xcbc>
    237c:	00004097          	auipc	ra,0x4
    2380:	880080e7          	jalr	-1920(ra) # 5bfc <open>
    close(fd);
    2384:	00004097          	auipc	ra,0x4
    2388:	860080e7          	jalr	-1952(ra) # 5be4 <close>
    exit(0);
    238c:	4501                	li	a0,0
    238e:	00004097          	auipc	ra,0x4
    2392:	82e080e7          	jalr	-2002(ra) # 5bbc <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2396:	85a6                	mv	a1,s1
    2398:	00005517          	auipc	a0,0x5
    239c:	9f050513          	add	a0,a0,-1552 # 6d88 <malloc+0xdac>
    23a0:	00004097          	auipc	ra,0x4
    23a4:	b84080e7          	jalr	-1148(ra) # 5f24 <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	00004097          	auipc	ra,0x4
    23ae:	812080e7          	jalr	-2030(ra) # 5bbc <exit>
    exit(xstatus);
    23b2:	00004097          	auipc	ra,0x4
    23b6:	80a080e7          	jalr	-2038(ra) # 5bbc <exit>
    printf("%s: bigarg test failed!\n", s);
    23ba:	85a6                	mv	a1,s1
    23bc:	00005517          	auipc	a0,0x5
    23c0:	9ec50513          	add	a0,a0,-1556 # 6da8 <malloc+0xdcc>
    23c4:	00004097          	auipc	ra,0x4
    23c8:	b60080e7          	jalr	-1184(ra) # 5f24 <printf>
    exit(1);
    23cc:	4505                	li	a0,1
    23ce:	00003097          	auipc	ra,0x3
    23d2:	7ee080e7          	jalr	2030(ra) # 5bbc <exit>

00000000000023d6 <stacktest>:
{
    23d6:	7179                	add	sp,sp,-48
    23d8:	f406                	sd	ra,40(sp)
    23da:	f022                	sd	s0,32(sp)
    23dc:	ec26                	sd	s1,24(sp)
    23de:	1800                	add	s0,sp,48
    23e0:	84aa                	mv	s1,a0
  pid = fork();
    23e2:	00003097          	auipc	ra,0x3
    23e6:	7d2080e7          	jalr	2002(ra) # 5bb4 <fork>
  if(pid == 0) {
    23ea:	c115                	beqz	a0,240e <stacktest+0x38>
  } else if(pid < 0){
    23ec:	04054463          	bltz	a0,2434 <stacktest+0x5e>
  wait(&xstatus);
    23f0:	fdc40513          	add	a0,s0,-36
    23f4:	00003097          	auipc	ra,0x3
    23f8:	7d0080e7          	jalr	2000(ra) # 5bc4 <wait>
  if(xstatus == -1)  // kernel killed child?
    23fc:	fdc42503          	lw	a0,-36(s0)
    2400:	57fd                	li	a5,-1
    2402:	04f50763          	beq	a0,a5,2450 <stacktest+0x7a>
    exit(xstatus);
    2406:	00003097          	auipc	ra,0x3
    240a:	7b6080e7          	jalr	1974(ra) # 5bbc <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    240e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2410:	77fd                	lui	a5,0xfffff
    2412:	97ba                	add	a5,a5,a4
    2414:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2418:	85a6                	mv	a1,s1
    241a:	00005517          	auipc	a0,0x5
    241e:	9ae50513          	add	a0,a0,-1618 # 6dc8 <malloc+0xdec>
    2422:	00004097          	auipc	ra,0x4
    2426:	b02080e7          	jalr	-1278(ra) # 5f24 <printf>
    exit(1);
    242a:	4505                	li	a0,1
    242c:	00003097          	auipc	ra,0x3
    2430:	790080e7          	jalr	1936(ra) # 5bbc <exit>
    printf("%s: fork failed\n", s);
    2434:	85a6                	mv	a1,s1
    2436:	00004517          	auipc	a0,0x4
    243a:	55a50513          	add	a0,a0,1370 # 6990 <malloc+0x9b4>
    243e:	00004097          	auipc	ra,0x4
    2442:	ae6080e7          	jalr	-1306(ra) # 5f24 <printf>
    exit(1);
    2446:	4505                	li	a0,1
    2448:	00003097          	auipc	ra,0x3
    244c:	774080e7          	jalr	1908(ra) # 5bbc <exit>
    exit(0);
    2450:	4501                	li	a0,0
    2452:	00003097          	auipc	ra,0x3
    2456:	76a080e7          	jalr	1898(ra) # 5bbc <exit>

000000000000245a <textwrite>:
{
    245a:	7179                	add	sp,sp,-48
    245c:	f406                	sd	ra,40(sp)
    245e:	f022                	sd	s0,32(sp)
    2460:	ec26                	sd	s1,24(sp)
    2462:	1800                	add	s0,sp,48
    2464:	84aa                	mv	s1,a0
  pid = fork();
    2466:	00003097          	auipc	ra,0x3
    246a:	74e080e7          	jalr	1870(ra) # 5bb4 <fork>
  if(pid == 0) {
    246e:	c115                	beqz	a0,2492 <textwrite+0x38>
  } else if(pid < 0){
    2470:	02054963          	bltz	a0,24a2 <textwrite+0x48>
  wait(&xstatus);
    2474:	fdc40513          	add	a0,s0,-36
    2478:	00003097          	auipc	ra,0x3
    247c:	74c080e7          	jalr	1868(ra) # 5bc4 <wait>
  if(xstatus == -1)  // kernel killed child?
    2480:	fdc42503          	lw	a0,-36(s0)
    2484:	57fd                	li	a5,-1
    2486:	02f50c63          	beq	a0,a5,24be <textwrite+0x64>
    exit(xstatus);
    248a:	00003097          	auipc	ra,0x3
    248e:	732080e7          	jalr	1842(ra) # 5bbc <exit>
    *addr = 10;
    2492:	47a9                	li	a5,10
    2494:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2498:	4505                	li	a0,1
    249a:	00003097          	auipc	ra,0x3
    249e:	722080e7          	jalr	1826(ra) # 5bbc <exit>
    printf("%s: fork failed\n", s);
    24a2:	85a6                	mv	a1,s1
    24a4:	00004517          	auipc	a0,0x4
    24a8:	4ec50513          	add	a0,a0,1260 # 6990 <malloc+0x9b4>
    24ac:	00004097          	auipc	ra,0x4
    24b0:	a78080e7          	jalr	-1416(ra) # 5f24 <printf>
    exit(1);
    24b4:	4505                	li	a0,1
    24b6:	00003097          	auipc	ra,0x3
    24ba:	706080e7          	jalr	1798(ra) # 5bbc <exit>
    exit(0);
    24be:	4501                	li	a0,0
    24c0:	00003097          	auipc	ra,0x3
    24c4:	6fc080e7          	jalr	1788(ra) # 5bbc <exit>

00000000000024c8 <manywrites>:
{
    24c8:	711d                	add	sp,sp,-96
    24ca:	ec86                	sd	ra,88(sp)
    24cc:	e8a2                	sd	s0,80(sp)
    24ce:	e4a6                	sd	s1,72(sp)
    24d0:	e0ca                	sd	s2,64(sp)
    24d2:	fc4e                	sd	s3,56(sp)
    24d4:	f852                	sd	s4,48(sp)
    24d6:	f456                	sd	s5,40(sp)
    24d8:	f05a                	sd	s6,32(sp)
    24da:	ec5e                	sd	s7,24(sp)
    24dc:	1080                	add	s0,sp,96
    24de:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24e0:	4981                	li	s3,0
    24e2:	4911                	li	s2,4
    int pid = fork();
    24e4:	00003097          	auipc	ra,0x3
    24e8:	6d0080e7          	jalr	1744(ra) # 5bb4 <fork>
    24ec:	84aa                	mv	s1,a0
    if(pid < 0){
    24ee:	02054963          	bltz	a0,2520 <manywrites+0x58>
    if(pid == 0){
    24f2:	c521                	beqz	a0,253a <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24f4:	2985                	addw	s3,s3,1
    24f6:	ff2997e3          	bne	s3,s2,24e4 <manywrites+0x1c>
    24fa:	4491                	li	s1,4
    int st = 0;
    24fc:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2500:	fa840513          	add	a0,s0,-88
    2504:	00003097          	auipc	ra,0x3
    2508:	6c0080e7          	jalr	1728(ra) # 5bc4 <wait>
    if(st != 0)
    250c:	fa842503          	lw	a0,-88(s0)
    2510:	ed6d                	bnez	a0,260a <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2512:	34fd                	addw	s1,s1,-1
    2514:	f4e5                	bnez	s1,24fc <manywrites+0x34>
  exit(0);
    2516:	4501                	li	a0,0
    2518:	00003097          	auipc	ra,0x3
    251c:	6a4080e7          	jalr	1700(ra) # 5bbc <exit>
      printf("fork failed\n");
    2520:	00005517          	auipc	a0,0x5
    2524:	87850513          	add	a0,a0,-1928 # 6d98 <malloc+0xdbc>
    2528:	00004097          	auipc	ra,0x4
    252c:	9fc080e7          	jalr	-1540(ra) # 5f24 <printf>
      exit(1);
    2530:	4505                	li	a0,1
    2532:	00003097          	auipc	ra,0x3
    2536:	68a080e7          	jalr	1674(ra) # 5bbc <exit>
      name[0] = 'b';
    253a:	06200793          	li	a5,98
    253e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2542:	0619879b          	addw	a5,s3,97
    2546:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    254a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    254e:	fa840513          	add	a0,s0,-88
    2552:	00003097          	auipc	ra,0x3
    2556:	6ba080e7          	jalr	1722(ra) # 5c0c <unlink>
    255a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    255c:	0000ab17          	auipc	s6,0xa
    2560:	71cb0b13          	add	s6,s6,1820 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2564:	8a26                	mv	s4,s1
    2566:	0209ce63          	bltz	s3,25a2 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    256a:	20200593          	li	a1,514
    256e:	fa840513          	add	a0,s0,-88
    2572:	00003097          	auipc	ra,0x3
    2576:	68a080e7          	jalr	1674(ra) # 5bfc <open>
    257a:	892a                	mv	s2,a0
          if(fd < 0){
    257c:	04054763          	bltz	a0,25ca <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2580:	660d                	lui	a2,0x3
    2582:	85da                	mv	a1,s6
    2584:	00003097          	auipc	ra,0x3
    2588:	658080e7          	jalr	1624(ra) # 5bdc <write>
          if(cc != sz){
    258c:	678d                	lui	a5,0x3
    258e:	04f51e63          	bne	a0,a5,25ea <manywrites+0x122>
          close(fd);
    2592:	854a                	mv	a0,s2
    2594:	00003097          	auipc	ra,0x3
    2598:	650080e7          	jalr	1616(ra) # 5be4 <close>
        for(int i = 0; i < ci+1; i++){
    259c:	2a05                	addw	s4,s4,1
    259e:	fd49d6e3          	bge	s3,s4,256a <manywrites+0xa2>
        unlink(name);
    25a2:	fa840513          	add	a0,s0,-88
    25a6:	00003097          	auipc	ra,0x3
    25aa:	666080e7          	jalr	1638(ra) # 5c0c <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25ae:	3bfd                	addw	s7,s7,-1
    25b0:	fa0b9ae3          	bnez	s7,2564 <manywrites+0x9c>
      unlink(name);
    25b4:	fa840513          	add	a0,s0,-88
    25b8:	00003097          	auipc	ra,0x3
    25bc:	654080e7          	jalr	1620(ra) # 5c0c <unlink>
      exit(0);
    25c0:	4501                	li	a0,0
    25c2:	00003097          	auipc	ra,0x3
    25c6:	5fa080e7          	jalr	1530(ra) # 5bbc <exit>
            printf("%s: cannot create %s\n", s, name);
    25ca:	fa840613          	add	a2,s0,-88
    25ce:	85d6                	mv	a1,s5
    25d0:	00005517          	auipc	a0,0x5
    25d4:	82050513          	add	a0,a0,-2016 # 6df0 <malloc+0xe14>
    25d8:	00004097          	auipc	ra,0x4
    25dc:	94c080e7          	jalr	-1716(ra) # 5f24 <printf>
            exit(1);
    25e0:	4505                	li	a0,1
    25e2:	00003097          	auipc	ra,0x3
    25e6:	5da080e7          	jalr	1498(ra) # 5bbc <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25ea:	86aa                	mv	a3,a0
    25ec:	660d                	lui	a2,0x3
    25ee:	85d6                	mv	a1,s5
    25f0:	00004517          	auipc	a0,0x4
    25f4:	be850513          	add	a0,a0,-1048 # 61d8 <malloc+0x1fc>
    25f8:	00004097          	auipc	ra,0x4
    25fc:	92c080e7          	jalr	-1748(ra) # 5f24 <printf>
            exit(1);
    2600:	4505                	li	a0,1
    2602:	00003097          	auipc	ra,0x3
    2606:	5ba080e7          	jalr	1466(ra) # 5bbc <exit>
      exit(st);
    260a:	00003097          	auipc	ra,0x3
    260e:	5b2080e7          	jalr	1458(ra) # 5bbc <exit>

0000000000002612 <copyinstr3>:
{
    2612:	7179                	add	sp,sp,-48
    2614:	f406                	sd	ra,40(sp)
    2616:	f022                	sd	s0,32(sp)
    2618:	ec26                	sd	s1,24(sp)
    261a:	1800                	add	s0,sp,48
  sbrk(8192);
    261c:	6509                	lui	a0,0x2
    261e:	00003097          	auipc	ra,0x3
    2622:	626080e7          	jalr	1574(ra) # 5c44 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2626:	4501                	li	a0,0
    2628:	00003097          	auipc	ra,0x3
    262c:	61c080e7          	jalr	1564(ra) # 5c44 <sbrk>
  if((top % PGSIZE) != 0){
    2630:	03451793          	sll	a5,a0,0x34
    2634:	e3c9                	bnez	a5,26b6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2636:	4501                	li	a0,0
    2638:	00003097          	auipc	ra,0x3
    263c:	60c080e7          	jalr	1548(ra) # 5c44 <sbrk>
  if(top % PGSIZE){
    2640:	03451793          	sll	a5,a0,0x34
    2644:	e3d9                	bnez	a5,26ca <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2646:	fff50493          	add	s1,a0,-1 # 1fff <linkunlink+0x6b>
  *b = 'x';
    264a:	07800793          	li	a5,120
    264e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2652:	8526                	mv	a0,s1
    2654:	00003097          	auipc	ra,0x3
    2658:	5b8080e7          	jalr	1464(ra) # 5c0c <unlink>
  if(ret != -1){
    265c:	57fd                	li	a5,-1
    265e:	08f51363          	bne	a0,a5,26e4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2662:	20100593          	li	a1,513
    2666:	8526                	mv	a0,s1
    2668:	00003097          	auipc	ra,0x3
    266c:	594080e7          	jalr	1428(ra) # 5bfc <open>
  if(fd != -1){
    2670:	57fd                	li	a5,-1
    2672:	08f51863          	bne	a0,a5,2702 <copyinstr3+0xf0>
  ret = link(b, b);
    2676:	85a6                	mv	a1,s1
    2678:	8526                	mv	a0,s1
    267a:	00003097          	auipc	ra,0x3
    267e:	5a2080e7          	jalr	1442(ra) # 5c1c <link>
  if(ret != -1){
    2682:	57fd                	li	a5,-1
    2684:	08f51e63          	bne	a0,a5,2720 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2688:	00005797          	auipc	a5,0x5
    268c:	46078793          	add	a5,a5,1120 # 7ae8 <malloc+0x1b0c>
    2690:	fcf43823          	sd	a5,-48(s0)
    2694:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2698:	fd040593          	add	a1,s0,-48
    269c:	8526                	mv	a0,s1
    269e:	00003097          	auipc	ra,0x3
    26a2:	556080e7          	jalr	1366(ra) # 5bf4 <exec>
  if(ret != -1){
    26a6:	57fd                	li	a5,-1
    26a8:	08f51c63          	bne	a0,a5,2740 <copyinstr3+0x12e>
}
    26ac:	70a2                	ld	ra,40(sp)
    26ae:	7402                	ld	s0,32(sp)
    26b0:	64e2                	ld	s1,24(sp)
    26b2:	6145                	add	sp,sp,48
    26b4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26b6:	0347d513          	srl	a0,a5,0x34
    26ba:	6785                	lui	a5,0x1
    26bc:	40a7853b          	subw	a0,a5,a0
    26c0:	00003097          	auipc	ra,0x3
    26c4:	584080e7          	jalr	1412(ra) # 5c44 <sbrk>
    26c8:	b7bd                	j	2636 <copyinstr3+0x24>
    printf("oops\n");
    26ca:	00004517          	auipc	a0,0x4
    26ce:	73e50513          	add	a0,a0,1854 # 6e08 <malloc+0xe2c>
    26d2:	00004097          	auipc	ra,0x4
    26d6:	852080e7          	jalr	-1966(ra) # 5f24 <printf>
    exit(1);
    26da:	4505                	li	a0,1
    26dc:	00003097          	auipc	ra,0x3
    26e0:	4e0080e7          	jalr	1248(ra) # 5bbc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26e4:	862a                	mv	a2,a0
    26e6:	85a6                	mv	a1,s1
    26e8:	00004517          	auipc	a0,0x4
    26ec:	1c850513          	add	a0,a0,456 # 68b0 <malloc+0x8d4>
    26f0:	00004097          	auipc	ra,0x4
    26f4:	834080e7          	jalr	-1996(ra) # 5f24 <printf>
    exit(1);
    26f8:	4505                	li	a0,1
    26fa:	00003097          	auipc	ra,0x3
    26fe:	4c2080e7          	jalr	1218(ra) # 5bbc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2702:	862a                	mv	a2,a0
    2704:	85a6                	mv	a1,s1
    2706:	00004517          	auipc	a0,0x4
    270a:	1ca50513          	add	a0,a0,458 # 68d0 <malloc+0x8f4>
    270e:	00004097          	auipc	ra,0x4
    2712:	816080e7          	jalr	-2026(ra) # 5f24 <printf>
    exit(1);
    2716:	4505                	li	a0,1
    2718:	00003097          	auipc	ra,0x3
    271c:	4a4080e7          	jalr	1188(ra) # 5bbc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2720:	86aa                	mv	a3,a0
    2722:	8626                	mv	a2,s1
    2724:	85a6                	mv	a1,s1
    2726:	00004517          	auipc	a0,0x4
    272a:	1ca50513          	add	a0,a0,458 # 68f0 <malloc+0x914>
    272e:	00003097          	auipc	ra,0x3
    2732:	7f6080e7          	jalr	2038(ra) # 5f24 <printf>
    exit(1);
    2736:	4505                	li	a0,1
    2738:	00003097          	auipc	ra,0x3
    273c:	484080e7          	jalr	1156(ra) # 5bbc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2740:	567d                	li	a2,-1
    2742:	85a6                	mv	a1,s1
    2744:	00004517          	auipc	a0,0x4
    2748:	1d450513          	add	a0,a0,468 # 6918 <malloc+0x93c>
    274c:	00003097          	auipc	ra,0x3
    2750:	7d8080e7          	jalr	2008(ra) # 5f24 <printf>
    exit(1);
    2754:	4505                	li	a0,1
    2756:	00003097          	auipc	ra,0x3
    275a:	466080e7          	jalr	1126(ra) # 5bbc <exit>

000000000000275e <rwsbrk>:
{
    275e:	1101                	add	sp,sp,-32
    2760:	ec06                	sd	ra,24(sp)
    2762:	e822                	sd	s0,16(sp)
    2764:	e426                	sd	s1,8(sp)
    2766:	e04a                	sd	s2,0(sp)
    2768:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    276a:	6509                	lui	a0,0x2
    276c:	00003097          	auipc	ra,0x3
    2770:	4d8080e7          	jalr	1240(ra) # 5c44 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2774:	57fd                	li	a5,-1
    2776:	06f50263          	beq	a0,a5,27da <rwsbrk+0x7c>
    277a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    277c:	7579                	lui	a0,0xffffe
    277e:	00003097          	auipc	ra,0x3
    2782:	4c6080e7          	jalr	1222(ra) # 5c44 <sbrk>
    2786:	57fd                	li	a5,-1
    2788:	06f50663          	beq	a0,a5,27f4 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    278c:	20100593          	li	a1,513
    2790:	00004517          	auipc	a0,0x4
    2794:	6b850513          	add	a0,a0,1720 # 6e48 <malloc+0xe6c>
    2798:	00003097          	auipc	ra,0x3
    279c:	464080e7          	jalr	1124(ra) # 5bfc <open>
    27a0:	892a                	mv	s2,a0
  if(fd < 0){
    27a2:	06054663          	bltz	a0,280e <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    27a6:	6785                	lui	a5,0x1
    27a8:	94be                	add	s1,s1,a5
    27aa:	40000613          	li	a2,1024
    27ae:	85a6                	mv	a1,s1
    27b0:	00003097          	auipc	ra,0x3
    27b4:	42c080e7          	jalr	1068(ra) # 5bdc <write>
    27b8:	862a                	mv	a2,a0
  if(n >= 0){
    27ba:	06054763          	bltz	a0,2828 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27be:	85a6                	mv	a1,s1
    27c0:	00004517          	auipc	a0,0x4
    27c4:	6a850513          	add	a0,a0,1704 # 6e68 <malloc+0xe8c>
    27c8:	00003097          	auipc	ra,0x3
    27cc:	75c080e7          	jalr	1884(ra) # 5f24 <printf>
    exit(1);
    27d0:	4505                	li	a0,1
    27d2:	00003097          	auipc	ra,0x3
    27d6:	3ea080e7          	jalr	1002(ra) # 5bbc <exit>
    printf("sbrk(rwsbrk) failed\n");
    27da:	00004517          	auipc	a0,0x4
    27de:	63650513          	add	a0,a0,1590 # 6e10 <malloc+0xe34>
    27e2:	00003097          	auipc	ra,0x3
    27e6:	742080e7          	jalr	1858(ra) # 5f24 <printf>
    exit(1);
    27ea:	4505                	li	a0,1
    27ec:	00003097          	auipc	ra,0x3
    27f0:	3d0080e7          	jalr	976(ra) # 5bbc <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27f4:	00004517          	auipc	a0,0x4
    27f8:	63450513          	add	a0,a0,1588 # 6e28 <malloc+0xe4c>
    27fc:	00003097          	auipc	ra,0x3
    2800:	728080e7          	jalr	1832(ra) # 5f24 <printf>
    exit(1);
    2804:	4505                	li	a0,1
    2806:	00003097          	auipc	ra,0x3
    280a:	3b6080e7          	jalr	950(ra) # 5bbc <exit>
    printf("open(rwsbrk) failed\n");
    280e:	00004517          	auipc	a0,0x4
    2812:	64250513          	add	a0,a0,1602 # 6e50 <malloc+0xe74>
    2816:	00003097          	auipc	ra,0x3
    281a:	70e080e7          	jalr	1806(ra) # 5f24 <printf>
    exit(1);
    281e:	4505                	li	a0,1
    2820:	00003097          	auipc	ra,0x3
    2824:	39c080e7          	jalr	924(ra) # 5bbc <exit>
  close(fd);
    2828:	854a                	mv	a0,s2
    282a:	00003097          	auipc	ra,0x3
    282e:	3ba080e7          	jalr	954(ra) # 5be4 <close>
  unlink("rwsbrk");
    2832:	00004517          	auipc	a0,0x4
    2836:	61650513          	add	a0,a0,1558 # 6e48 <malloc+0xe6c>
    283a:	00003097          	auipc	ra,0x3
    283e:	3d2080e7          	jalr	978(ra) # 5c0c <unlink>
  fd = open("README", O_RDONLY);
    2842:	4581                	li	a1,0
    2844:	00004517          	auipc	a0,0x4
    2848:	a9c50513          	add	a0,a0,-1380 # 62e0 <malloc+0x304>
    284c:	00003097          	auipc	ra,0x3
    2850:	3b0080e7          	jalr	944(ra) # 5bfc <open>
    2854:	892a                	mv	s2,a0
  if(fd < 0){
    2856:	02054963          	bltz	a0,2888 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    285a:	4629                	li	a2,10
    285c:	85a6                	mv	a1,s1
    285e:	00003097          	auipc	ra,0x3
    2862:	376080e7          	jalr	886(ra) # 5bd4 <read>
    2866:	862a                	mv	a2,a0
  if(n >= 0){
    2868:	02054d63          	bltz	a0,28a2 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    286c:	85a6                	mv	a1,s1
    286e:	00004517          	auipc	a0,0x4
    2872:	62a50513          	add	a0,a0,1578 # 6e98 <malloc+0xebc>
    2876:	00003097          	auipc	ra,0x3
    287a:	6ae080e7          	jalr	1710(ra) # 5f24 <printf>
    exit(1);
    287e:	4505                	li	a0,1
    2880:	00003097          	auipc	ra,0x3
    2884:	33c080e7          	jalr	828(ra) # 5bbc <exit>
    printf("open(rwsbrk) failed\n");
    2888:	00004517          	auipc	a0,0x4
    288c:	5c850513          	add	a0,a0,1480 # 6e50 <malloc+0xe74>
    2890:	00003097          	auipc	ra,0x3
    2894:	694080e7          	jalr	1684(ra) # 5f24 <printf>
    exit(1);
    2898:	4505                	li	a0,1
    289a:	00003097          	auipc	ra,0x3
    289e:	322080e7          	jalr	802(ra) # 5bbc <exit>
  close(fd);
    28a2:	854a                	mv	a0,s2
    28a4:	00003097          	auipc	ra,0x3
    28a8:	340080e7          	jalr	832(ra) # 5be4 <close>
  exit(0);
    28ac:	4501                	li	a0,0
    28ae:	00003097          	auipc	ra,0x3
    28b2:	30e080e7          	jalr	782(ra) # 5bbc <exit>

00000000000028b6 <sbrkbasic>:
{
    28b6:	7139                	add	sp,sp,-64
    28b8:	fc06                	sd	ra,56(sp)
    28ba:	f822                	sd	s0,48(sp)
    28bc:	f426                	sd	s1,40(sp)
    28be:	f04a                	sd	s2,32(sp)
    28c0:	ec4e                	sd	s3,24(sp)
    28c2:	e852                	sd	s4,16(sp)
    28c4:	0080                	add	s0,sp,64
    28c6:	8a2a                	mv	s4,a0
  pid = fork();
    28c8:	00003097          	auipc	ra,0x3
    28cc:	2ec080e7          	jalr	748(ra) # 5bb4 <fork>
  if(pid < 0){
    28d0:	02054c63          	bltz	a0,2908 <sbrkbasic+0x52>
  if(pid == 0){
    28d4:	ed21                	bnez	a0,292c <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28d6:	40000537          	lui	a0,0x40000
    28da:	00003097          	auipc	ra,0x3
    28de:	36a080e7          	jalr	874(ra) # 5c44 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28e2:	57fd                	li	a5,-1
    28e4:	02f50f63          	beq	a0,a5,2922 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28e8:	400007b7          	lui	a5,0x40000
    28ec:	97aa                	add	a5,a5,a0
      *b = 99;
    28ee:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f2:	6705                	lui	a4,0x1
      *b = 99;
    28f4:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f8:	953a                	add	a0,a0,a4
    28fa:	fef51de3          	bne	a0,a5,28f4 <sbrkbasic+0x3e>
    exit(1);
    28fe:	4505                	li	a0,1
    2900:	00003097          	auipc	ra,0x3
    2904:	2bc080e7          	jalr	700(ra) # 5bbc <exit>
    printf("fork failed in sbrkbasic\n");
    2908:	00004517          	auipc	a0,0x4
    290c:	5b850513          	add	a0,a0,1464 # 6ec0 <malloc+0xee4>
    2910:	00003097          	auipc	ra,0x3
    2914:	614080e7          	jalr	1556(ra) # 5f24 <printf>
    exit(1);
    2918:	4505                	li	a0,1
    291a:	00003097          	auipc	ra,0x3
    291e:	2a2080e7          	jalr	674(ra) # 5bbc <exit>
      exit(0);
    2922:	4501                	li	a0,0
    2924:	00003097          	auipc	ra,0x3
    2928:	298080e7          	jalr	664(ra) # 5bbc <exit>
  wait(&xstatus);
    292c:	fcc40513          	add	a0,s0,-52
    2930:	00003097          	auipc	ra,0x3
    2934:	294080e7          	jalr	660(ra) # 5bc4 <wait>
  if(xstatus == 1){
    2938:	fcc42703          	lw	a4,-52(s0)
    293c:	4785                	li	a5,1
    293e:	00f70d63          	beq	a4,a5,2958 <sbrkbasic+0xa2>
  a = sbrk(0);
    2942:	4501                	li	a0,0
    2944:	00003097          	auipc	ra,0x3
    2948:	300080e7          	jalr	768(ra) # 5c44 <sbrk>
    294c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    294e:	4901                	li	s2,0
    2950:	6985                	lui	s3,0x1
    2952:	38898993          	add	s3,s3,904 # 1388 <badarg+0x36>
    2956:	a005                	j	2976 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2958:	85d2                	mv	a1,s4
    295a:	00004517          	auipc	a0,0x4
    295e:	58650513          	add	a0,a0,1414 # 6ee0 <malloc+0xf04>
    2962:	00003097          	auipc	ra,0x3
    2966:	5c2080e7          	jalr	1474(ra) # 5f24 <printf>
    exit(1);
    296a:	4505                	li	a0,1
    296c:	00003097          	auipc	ra,0x3
    2970:	250080e7          	jalr	592(ra) # 5bbc <exit>
    a = b + 1;
    2974:	84be                	mv	s1,a5
    b = sbrk(1);
    2976:	4505                	li	a0,1
    2978:	00003097          	auipc	ra,0x3
    297c:	2cc080e7          	jalr	716(ra) # 5c44 <sbrk>
    if(b != a){
    2980:	04951c63          	bne	a0,s1,29d8 <sbrkbasic+0x122>
    *b = 1;
    2984:	4785                	li	a5,1
    2986:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    298a:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    298e:	2905                	addw	s2,s2,1
    2990:	ff3912e3          	bne	s2,s3,2974 <sbrkbasic+0xbe>
  pid = fork();
    2994:	00003097          	auipc	ra,0x3
    2998:	220080e7          	jalr	544(ra) # 5bb4 <fork>
    299c:	892a                	mv	s2,a0
  if(pid < 0){
    299e:	04054e63          	bltz	a0,29fa <sbrkbasic+0x144>
  c = sbrk(1);
    29a2:	4505                	li	a0,1
    29a4:	00003097          	auipc	ra,0x3
    29a8:	2a0080e7          	jalr	672(ra) # 5c44 <sbrk>
  c = sbrk(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	296080e7          	jalr	662(ra) # 5c44 <sbrk>
  if(c != a + 1){
    29b6:	0489                	add	s1,s1,2
    29b8:	04a48f63          	beq	s1,a0,2a16 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29bc:	85d2                	mv	a1,s4
    29be:	00004517          	auipc	a0,0x4
    29c2:	58250513          	add	a0,a0,1410 # 6f40 <malloc+0xf64>
    29c6:	00003097          	auipc	ra,0x3
    29ca:	55e080e7          	jalr	1374(ra) # 5f24 <printf>
    exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00003097          	auipc	ra,0x3
    29d4:	1ec080e7          	jalr	492(ra) # 5bbc <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29d8:	872a                	mv	a4,a0
    29da:	86a6                	mv	a3,s1
    29dc:	864a                	mv	a2,s2
    29de:	85d2                	mv	a1,s4
    29e0:	00004517          	auipc	a0,0x4
    29e4:	52050513          	add	a0,a0,1312 # 6f00 <malloc+0xf24>
    29e8:	00003097          	auipc	ra,0x3
    29ec:	53c080e7          	jalr	1340(ra) # 5f24 <printf>
      exit(1);
    29f0:	4505                	li	a0,1
    29f2:	00003097          	auipc	ra,0x3
    29f6:	1ca080e7          	jalr	458(ra) # 5bbc <exit>
    printf("%s: sbrk test fork failed\n", s);
    29fa:	85d2                	mv	a1,s4
    29fc:	00004517          	auipc	a0,0x4
    2a00:	52450513          	add	a0,a0,1316 # 6f20 <malloc+0xf44>
    2a04:	00003097          	auipc	ra,0x3
    2a08:	520080e7          	jalr	1312(ra) # 5f24 <printf>
    exit(1);
    2a0c:	4505                	li	a0,1
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	1ae080e7          	jalr	430(ra) # 5bbc <exit>
  if(pid == 0)
    2a16:	00091763          	bnez	s2,2a24 <sbrkbasic+0x16e>
    exit(0);
    2a1a:	4501                	li	a0,0
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	1a0080e7          	jalr	416(ra) # 5bbc <exit>
  wait(&xstatus);
    2a24:	fcc40513          	add	a0,s0,-52
    2a28:	00003097          	auipc	ra,0x3
    2a2c:	19c080e7          	jalr	412(ra) # 5bc4 <wait>
  exit(xstatus);
    2a30:	fcc42503          	lw	a0,-52(s0)
    2a34:	00003097          	auipc	ra,0x3
    2a38:	188080e7          	jalr	392(ra) # 5bbc <exit>

0000000000002a3c <sbrkmuch>:
{
    2a3c:	7179                	add	sp,sp,-48
    2a3e:	f406                	sd	ra,40(sp)
    2a40:	f022                	sd	s0,32(sp)
    2a42:	ec26                	sd	s1,24(sp)
    2a44:	e84a                	sd	s2,16(sp)
    2a46:	e44e                	sd	s3,8(sp)
    2a48:	e052                	sd	s4,0(sp)
    2a4a:	1800                	add	s0,sp,48
    2a4c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a4e:	4501                	li	a0,0
    2a50:	00003097          	auipc	ra,0x3
    2a54:	1f4080e7          	jalr	500(ra) # 5c44 <sbrk>
    2a58:	892a                	mv	s2,a0
  a = sbrk(0);
    2a5a:	4501                	li	a0,0
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	1e8080e7          	jalr	488(ra) # 5c44 <sbrk>
    2a64:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a66:	06400537          	lui	a0,0x6400
    2a6a:	9d05                	subw	a0,a0,s1
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	1d8080e7          	jalr	472(ra) # 5c44 <sbrk>
  if (p != a) {
    2a74:	0ca49863          	bne	s1,a0,2b44 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a78:	4501                	li	a0,0
    2a7a:	00003097          	auipc	ra,0x3
    2a7e:	1ca080e7          	jalr	458(ra) # 5c44 <sbrk>
    2a82:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a84:	00a4f963          	bgeu	s1,a0,2a96 <sbrkmuch+0x5a>
    *pp = 1;
    2a88:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a8a:	6705                	lui	a4,0x1
    *pp = 1;
    2a8c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a90:	94ba                	add	s1,s1,a4
    2a92:	fef4ede3          	bltu	s1,a5,2a8c <sbrkmuch+0x50>
  *lastaddr = 99;
    2a96:	064007b7          	lui	a5,0x6400
    2a9a:	06300713          	li	a4,99
    2a9e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aa2:	4501                	li	a0,0
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	1a0080e7          	jalr	416(ra) # 5c44 <sbrk>
    2aac:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2aae:	757d                	lui	a0,0xfffff
    2ab0:	00003097          	auipc	ra,0x3
    2ab4:	194080e7          	jalr	404(ra) # 5c44 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ab8:	57fd                	li	a5,-1
    2aba:	0af50363          	beq	a0,a5,2b60 <sbrkmuch+0x124>
  c = sbrk(0);
    2abe:	4501                	li	a0,0
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	184080e7          	jalr	388(ra) # 5c44 <sbrk>
  if(c != a - PGSIZE){
    2ac8:	77fd                	lui	a5,0xfffff
    2aca:	97a6                	add	a5,a5,s1
    2acc:	0af51863          	bne	a0,a5,2b7c <sbrkmuch+0x140>
  a = sbrk(0);
    2ad0:	4501                	li	a0,0
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	172080e7          	jalr	370(ra) # 5c44 <sbrk>
    2ada:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2adc:	6505                	lui	a0,0x1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	166080e7          	jalr	358(ra) # 5c44 <sbrk>
    2ae6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2ae8:	0aa49a63          	bne	s1,a0,2b9c <sbrkmuch+0x160>
    2aec:	4501                	li	a0,0
    2aee:	00003097          	auipc	ra,0x3
    2af2:	156080e7          	jalr	342(ra) # 5c44 <sbrk>
    2af6:	6785                	lui	a5,0x1
    2af8:	97a6                	add	a5,a5,s1
    2afa:	0af51163          	bne	a0,a5,2b9c <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2afe:	064007b7          	lui	a5,0x6400
    2b02:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b06:	06300793          	li	a5,99
    2b0a:	0af70963          	beq	a4,a5,2bbc <sbrkmuch+0x180>
  a = sbrk(0);
    2b0e:	4501                	li	a0,0
    2b10:	00003097          	auipc	ra,0x3
    2b14:	134080e7          	jalr	308(ra) # 5c44 <sbrk>
    2b18:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b1a:	4501                	li	a0,0
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	128080e7          	jalr	296(ra) # 5c44 <sbrk>
    2b24:	40a9053b          	subw	a0,s2,a0
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	11c080e7          	jalr	284(ra) # 5c44 <sbrk>
  if(c != a){
    2b30:	0aa49463          	bne	s1,a0,2bd8 <sbrkmuch+0x19c>
}
    2b34:	70a2                	ld	ra,40(sp)
    2b36:	7402                	ld	s0,32(sp)
    2b38:	64e2                	ld	s1,24(sp)
    2b3a:	6942                	ld	s2,16(sp)
    2b3c:	69a2                	ld	s3,8(sp)
    2b3e:	6a02                	ld	s4,0(sp)
    2b40:	6145                	add	sp,sp,48
    2b42:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b44:	85ce                	mv	a1,s3
    2b46:	00004517          	auipc	a0,0x4
    2b4a:	41a50513          	add	a0,a0,1050 # 6f60 <malloc+0xf84>
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	3d6080e7          	jalr	982(ra) # 5f24 <printf>
    exit(1);
    2b56:	4505                	li	a0,1
    2b58:	00003097          	auipc	ra,0x3
    2b5c:	064080e7          	jalr	100(ra) # 5bbc <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b60:	85ce                	mv	a1,s3
    2b62:	00004517          	auipc	a0,0x4
    2b66:	44650513          	add	a0,a0,1094 # 6fa8 <malloc+0xfcc>
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	3ba080e7          	jalr	954(ra) # 5f24 <printf>
    exit(1);
    2b72:	4505                	li	a0,1
    2b74:	00003097          	auipc	ra,0x3
    2b78:	048080e7          	jalr	72(ra) # 5bbc <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b7c:	86aa                	mv	a3,a0
    2b7e:	8626                	mv	a2,s1
    2b80:	85ce                	mv	a1,s3
    2b82:	00004517          	auipc	a0,0x4
    2b86:	44650513          	add	a0,a0,1094 # 6fc8 <malloc+0xfec>
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	39a080e7          	jalr	922(ra) # 5f24 <printf>
    exit(1);
    2b92:	4505                	li	a0,1
    2b94:	00003097          	auipc	ra,0x3
    2b98:	028080e7          	jalr	40(ra) # 5bbc <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b9c:	86d2                	mv	a3,s4
    2b9e:	8626                	mv	a2,s1
    2ba0:	85ce                	mv	a1,s3
    2ba2:	00004517          	auipc	a0,0x4
    2ba6:	46650513          	add	a0,a0,1126 # 7008 <malloc+0x102c>
    2baa:	00003097          	auipc	ra,0x3
    2bae:	37a080e7          	jalr	890(ra) # 5f24 <printf>
    exit(1);
    2bb2:	4505                	li	a0,1
    2bb4:	00003097          	auipc	ra,0x3
    2bb8:	008080e7          	jalr	8(ra) # 5bbc <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bbc:	85ce                	mv	a1,s3
    2bbe:	00004517          	auipc	a0,0x4
    2bc2:	47a50513          	add	a0,a0,1146 # 7038 <malloc+0x105c>
    2bc6:	00003097          	auipc	ra,0x3
    2bca:	35e080e7          	jalr	862(ra) # 5f24 <printf>
    exit(1);
    2bce:	4505                	li	a0,1
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	fec080e7          	jalr	-20(ra) # 5bbc <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bd8:	86aa                	mv	a3,a0
    2bda:	8626                	mv	a2,s1
    2bdc:	85ce                	mv	a1,s3
    2bde:	00004517          	auipc	a0,0x4
    2be2:	49250513          	add	a0,a0,1170 # 7070 <malloc+0x1094>
    2be6:	00003097          	auipc	ra,0x3
    2bea:	33e080e7          	jalr	830(ra) # 5f24 <printf>
    exit(1);
    2bee:	4505                	li	a0,1
    2bf0:	00003097          	auipc	ra,0x3
    2bf4:	fcc080e7          	jalr	-52(ra) # 5bbc <exit>

0000000000002bf8 <sbrkarg>:
{
    2bf8:	7179                	add	sp,sp,-48
    2bfa:	f406                	sd	ra,40(sp)
    2bfc:	f022                	sd	s0,32(sp)
    2bfe:	ec26                	sd	s1,24(sp)
    2c00:	e84a                	sd	s2,16(sp)
    2c02:	e44e                	sd	s3,8(sp)
    2c04:	1800                	add	s0,sp,48
    2c06:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c08:	6505                	lui	a0,0x1
    2c0a:	00003097          	auipc	ra,0x3
    2c0e:	03a080e7          	jalr	58(ra) # 5c44 <sbrk>
    2c12:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c14:	20100593          	li	a1,513
    2c18:	00004517          	auipc	a0,0x4
    2c1c:	48050513          	add	a0,a0,1152 # 7098 <malloc+0x10bc>
    2c20:	00003097          	auipc	ra,0x3
    2c24:	fdc080e7          	jalr	-36(ra) # 5bfc <open>
    2c28:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	46e50513          	add	a0,a0,1134 # 7098 <malloc+0x10bc>
    2c32:	00003097          	auipc	ra,0x3
    2c36:	fda080e7          	jalr	-38(ra) # 5c0c <unlink>
  if(fd < 0)  {
    2c3a:	0404c163          	bltz	s1,2c7c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c3e:	6605                	lui	a2,0x1
    2c40:	85ca                	mv	a1,s2
    2c42:	8526                	mv	a0,s1
    2c44:	00003097          	auipc	ra,0x3
    2c48:	f98080e7          	jalr	-104(ra) # 5bdc <write>
    2c4c:	04054663          	bltz	a0,2c98 <sbrkarg+0xa0>
  close(fd);
    2c50:	8526                	mv	a0,s1
    2c52:	00003097          	auipc	ra,0x3
    2c56:	f92080e7          	jalr	-110(ra) # 5be4 <close>
  a = sbrk(PGSIZE);
    2c5a:	6505                	lui	a0,0x1
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	fe8080e7          	jalr	-24(ra) # 5c44 <sbrk>
  if(pipe((int *) a) != 0){
    2c64:	00003097          	auipc	ra,0x3
    2c68:	f68080e7          	jalr	-152(ra) # 5bcc <pipe>
    2c6c:	e521                	bnez	a0,2cb4 <sbrkarg+0xbc>
}
    2c6e:	70a2                	ld	ra,40(sp)
    2c70:	7402                	ld	s0,32(sp)
    2c72:	64e2                	ld	s1,24(sp)
    2c74:	6942                	ld	s2,16(sp)
    2c76:	69a2                	ld	s3,8(sp)
    2c78:	6145                	add	sp,sp,48
    2c7a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c7c:	85ce                	mv	a1,s3
    2c7e:	00004517          	auipc	a0,0x4
    2c82:	42250513          	add	a0,a0,1058 # 70a0 <malloc+0x10c4>
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	29e080e7          	jalr	670(ra) # 5f24 <printf>
    exit(1);
    2c8e:	4505                	li	a0,1
    2c90:	00003097          	auipc	ra,0x3
    2c94:	f2c080e7          	jalr	-212(ra) # 5bbc <exit>
    printf("%s: write sbrk failed\n", s);
    2c98:	85ce                	mv	a1,s3
    2c9a:	00004517          	auipc	a0,0x4
    2c9e:	41e50513          	add	a0,a0,1054 # 70b8 <malloc+0x10dc>
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	282080e7          	jalr	642(ra) # 5f24 <printf>
    exit(1);
    2caa:	4505                	li	a0,1
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	f10080e7          	jalr	-240(ra) # 5bbc <exit>
    printf("%s: pipe() failed\n", s);
    2cb4:	85ce                	mv	a1,s3
    2cb6:	00004517          	auipc	a0,0x4
    2cba:	de250513          	add	a0,a0,-542 # 6a98 <malloc+0xabc>
    2cbe:	00003097          	auipc	ra,0x3
    2cc2:	266080e7          	jalr	614(ra) # 5f24 <printf>
    exit(1);
    2cc6:	4505                	li	a0,1
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	ef4080e7          	jalr	-268(ra) # 5bbc <exit>

0000000000002cd0 <argptest>:
{
    2cd0:	1101                	add	sp,sp,-32
    2cd2:	ec06                	sd	ra,24(sp)
    2cd4:	e822                	sd	s0,16(sp)
    2cd6:	e426                	sd	s1,8(sp)
    2cd8:	e04a                	sd	s2,0(sp)
    2cda:	1000                	add	s0,sp,32
    2cdc:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cde:	4581                	li	a1,0
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	3f050513          	add	a0,a0,1008 # 70d0 <malloc+0x10f4>
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	f14080e7          	jalr	-236(ra) # 5bfc <open>
  if (fd < 0) {
    2cf0:	02054b63          	bltz	a0,2d26 <argptest+0x56>
    2cf4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cf6:	4501                	li	a0,0
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	f4c080e7          	jalr	-180(ra) # 5c44 <sbrk>
    2d00:	567d                	li	a2,-1
    2d02:	fff50593          	add	a1,a0,-1
    2d06:	8526                	mv	a0,s1
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	ecc080e7          	jalr	-308(ra) # 5bd4 <read>
  close(fd);
    2d10:	8526                	mv	a0,s1
    2d12:	00003097          	auipc	ra,0x3
    2d16:	ed2080e7          	jalr	-302(ra) # 5be4 <close>
}
    2d1a:	60e2                	ld	ra,24(sp)
    2d1c:	6442                	ld	s0,16(sp)
    2d1e:	64a2                	ld	s1,8(sp)
    2d20:	6902                	ld	s2,0(sp)
    2d22:	6105                	add	sp,sp,32
    2d24:	8082                	ret
    printf("%s: open failed\n", s);
    2d26:	85ca                	mv	a1,s2
    2d28:	00004517          	auipc	a0,0x4
    2d2c:	c8050513          	add	a0,a0,-896 # 69a8 <malloc+0x9cc>
    2d30:	00003097          	auipc	ra,0x3
    2d34:	1f4080e7          	jalr	500(ra) # 5f24 <printf>
    exit(1);
    2d38:	4505                	li	a0,1
    2d3a:	00003097          	auipc	ra,0x3
    2d3e:	e82080e7          	jalr	-382(ra) # 5bbc <exit>

0000000000002d42 <sbrkbugs>:
{
    2d42:	1141                	add	sp,sp,-16
    2d44:	e406                	sd	ra,8(sp)
    2d46:	e022                	sd	s0,0(sp)
    2d48:	0800                	add	s0,sp,16
  int pid = fork();
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	e6a080e7          	jalr	-406(ra) # 5bb4 <fork>
  if(pid < 0){
    2d52:	02054263          	bltz	a0,2d76 <sbrkbugs+0x34>
  if(pid == 0){
    2d56:	ed0d                	bnez	a0,2d90 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d58:	00003097          	auipc	ra,0x3
    2d5c:	eec080e7          	jalr	-276(ra) # 5c44 <sbrk>
    sbrk(-sz);
    2d60:	40a0053b          	negw	a0,a0
    2d64:	00003097          	auipc	ra,0x3
    2d68:	ee0080e7          	jalr	-288(ra) # 5c44 <sbrk>
    exit(0);
    2d6c:	4501                	li	a0,0
    2d6e:	00003097          	auipc	ra,0x3
    2d72:	e4e080e7          	jalr	-434(ra) # 5bbc <exit>
    printf("fork failed\n");
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	02250513          	add	a0,a0,34 # 6d98 <malloc+0xdbc>
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	1a6080e7          	jalr	422(ra) # 5f24 <printf>
    exit(1);
    2d86:	4505                	li	a0,1
    2d88:	00003097          	auipc	ra,0x3
    2d8c:	e34080e7          	jalr	-460(ra) # 5bbc <exit>
  wait(0);
    2d90:	4501                	li	a0,0
    2d92:	00003097          	auipc	ra,0x3
    2d96:	e32080e7          	jalr	-462(ra) # 5bc4 <wait>
  pid = fork();
    2d9a:	00003097          	auipc	ra,0x3
    2d9e:	e1a080e7          	jalr	-486(ra) # 5bb4 <fork>
  if(pid < 0){
    2da2:	02054563          	bltz	a0,2dcc <sbrkbugs+0x8a>
  if(pid == 0){
    2da6:	e121                	bnez	a0,2de6 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2da8:	00003097          	auipc	ra,0x3
    2dac:	e9c080e7          	jalr	-356(ra) # 5c44 <sbrk>
    sbrk(-(sz - 3500));
    2db0:	6785                	lui	a5,0x1
    2db2:	dac7879b          	addw	a5,a5,-596 # dac <unlinkread+0x66>
    2db6:	40a7853b          	subw	a0,a5,a0
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	e8a080e7          	jalr	-374(ra) # 5c44 <sbrk>
    exit(0);
    2dc2:	4501                	li	a0,0
    2dc4:	00003097          	auipc	ra,0x3
    2dc8:	df8080e7          	jalr	-520(ra) # 5bbc <exit>
    printf("fork failed\n");
    2dcc:	00004517          	auipc	a0,0x4
    2dd0:	fcc50513          	add	a0,a0,-52 # 6d98 <malloc+0xdbc>
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	150080e7          	jalr	336(ra) # 5f24 <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00003097          	auipc	ra,0x3
    2de2:	dde080e7          	jalr	-546(ra) # 5bbc <exit>
  wait(0);
    2de6:	4501                	li	a0,0
    2de8:	00003097          	auipc	ra,0x3
    2dec:	ddc080e7          	jalr	-548(ra) # 5bc4 <wait>
  pid = fork();
    2df0:	00003097          	auipc	ra,0x3
    2df4:	dc4080e7          	jalr	-572(ra) # 5bb4 <fork>
  if(pid < 0){
    2df8:	02054a63          	bltz	a0,2e2c <sbrkbugs+0xea>
  if(pid == 0){
    2dfc:	e529                	bnez	a0,2e46 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	e46080e7          	jalr	-442(ra) # 5c44 <sbrk>
    2e06:	67ad                	lui	a5,0xb
    2e08:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x298>
    2e0c:	40a7853b          	subw	a0,a5,a0
    2e10:	00003097          	auipc	ra,0x3
    2e14:	e34080e7          	jalr	-460(ra) # 5c44 <sbrk>
    sbrk(-10);
    2e18:	5559                	li	a0,-10
    2e1a:	00003097          	auipc	ra,0x3
    2e1e:	e2a080e7          	jalr	-470(ra) # 5c44 <sbrk>
    exit(0);
    2e22:	4501                	li	a0,0
    2e24:	00003097          	auipc	ra,0x3
    2e28:	d98080e7          	jalr	-616(ra) # 5bbc <exit>
    printf("fork failed\n");
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	f6c50513          	add	a0,a0,-148 # 6d98 <malloc+0xdbc>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	0f0080e7          	jalr	240(ra) # 5f24 <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	d7e080e7          	jalr	-642(ra) # 5bbc <exit>
  wait(0);
    2e46:	4501                	li	a0,0
    2e48:	00003097          	auipc	ra,0x3
    2e4c:	d7c080e7          	jalr	-644(ra) # 5bc4 <wait>
  exit(0);
    2e50:	4501                	li	a0,0
    2e52:	00003097          	auipc	ra,0x3
    2e56:	d6a080e7          	jalr	-662(ra) # 5bbc <exit>

0000000000002e5a <sbrklast>:
{
    2e5a:	7179                	add	sp,sp,-48
    2e5c:	f406                	sd	ra,40(sp)
    2e5e:	f022                	sd	s0,32(sp)
    2e60:	ec26                	sd	s1,24(sp)
    2e62:	e84a                	sd	s2,16(sp)
    2e64:	e44e                	sd	s3,8(sp)
    2e66:	e052                	sd	s4,0(sp)
    2e68:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e6a:	4501                	li	a0,0
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	dd8080e7          	jalr	-552(ra) # 5c44 <sbrk>
  if((top % 4096) != 0)
    2e74:	03451793          	sll	a5,a0,0x34
    2e78:	ebd9                	bnez	a5,2f0e <sbrklast+0xb4>
  sbrk(4096);
    2e7a:	6505                	lui	a0,0x1
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	dc8080e7          	jalr	-568(ra) # 5c44 <sbrk>
  sbrk(10);
    2e84:	4529                	li	a0,10
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	dbe080e7          	jalr	-578(ra) # 5c44 <sbrk>
  sbrk(-20);
    2e8e:	5531                	li	a0,-20
    2e90:	00003097          	auipc	ra,0x3
    2e94:	db4080e7          	jalr	-588(ra) # 5c44 <sbrk>
  top = (uint64) sbrk(0);
    2e98:	4501                	li	a0,0
    2e9a:	00003097          	auipc	ra,0x3
    2e9e:	daa080e7          	jalr	-598(ra) # 5c44 <sbrk>
    2ea2:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2ea4:	fc050913          	add	s2,a0,-64 # fc0 <linktest+0xc4>
  p[0] = 'x';
    2ea8:	07800a13          	li	s4,120
    2eac:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2eb0:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eb4:	20200593          	li	a1,514
    2eb8:	854a                	mv	a0,s2
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	d42080e7          	jalr	-702(ra) # 5bfc <open>
    2ec2:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ec4:	4605                	li	a2,1
    2ec6:	85ca                	mv	a1,s2
    2ec8:	00003097          	auipc	ra,0x3
    2ecc:	d14080e7          	jalr	-748(ra) # 5bdc <write>
  close(fd);
    2ed0:	854e                	mv	a0,s3
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	d12080e7          	jalr	-750(ra) # 5be4 <close>
  fd = open(p, O_RDWR);
    2eda:	4589                	li	a1,2
    2edc:	854a                	mv	a0,s2
    2ede:	00003097          	auipc	ra,0x3
    2ee2:	d1e080e7          	jalr	-738(ra) # 5bfc <open>
  p[0] = '\0';
    2ee6:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2eea:	4605                	li	a2,1
    2eec:	85ca                	mv	a1,s2
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	ce6080e7          	jalr	-794(ra) # 5bd4 <read>
  if(p[0] != 'x')
    2ef6:	fc04c783          	lbu	a5,-64(s1)
    2efa:	03479463          	bne	a5,s4,2f22 <sbrklast+0xc8>
}
    2efe:	70a2                	ld	ra,40(sp)
    2f00:	7402                	ld	s0,32(sp)
    2f02:	64e2                	ld	s1,24(sp)
    2f04:	6942                	ld	s2,16(sp)
    2f06:	69a2                	ld	s3,8(sp)
    2f08:	6a02                	ld	s4,0(sp)
    2f0a:	6145                	add	sp,sp,48
    2f0c:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f0e:	0347d513          	srl	a0,a5,0x34
    2f12:	6785                	lui	a5,0x1
    2f14:	40a7853b          	subw	a0,a5,a0
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	d2c080e7          	jalr	-724(ra) # 5c44 <sbrk>
    2f20:	bfa9                	j	2e7a <sbrklast+0x20>
    exit(1);
    2f22:	4505                	li	a0,1
    2f24:	00003097          	auipc	ra,0x3
    2f28:	c98080e7          	jalr	-872(ra) # 5bbc <exit>

0000000000002f2c <sbrk8000>:
{
    2f2c:	1141                	add	sp,sp,-16
    2f2e:	e406                	sd	ra,8(sp)
    2f30:	e022                	sd	s0,0(sp)
    2f32:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2f34:	80000537          	lui	a0,0x80000
    2f38:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	d0a080e7          	jalr	-758(ra) # 5c44 <sbrk>
  volatile char *top = sbrk(0);
    2f42:	4501                	li	a0,0
    2f44:	00003097          	auipc	ra,0x3
    2f48:	d00080e7          	jalr	-768(ra) # 5c44 <sbrk>
  *(top-1) = *(top-1) + 1;
    2f4c:	fff54783          	lbu	a5,-1(a0)
    2f50:	2785                	addw	a5,a5,1 # 1001 <linktest+0x105>
    2f52:	0ff7f793          	zext.b	a5,a5
    2f56:	fef50fa3          	sb	a5,-1(a0)
}
    2f5a:	60a2                	ld	ra,8(sp)
    2f5c:	6402                	ld	s0,0(sp)
    2f5e:	0141                	add	sp,sp,16
    2f60:	8082                	ret

0000000000002f62 <execout>:
{
    2f62:	715d                	add	sp,sp,-80
    2f64:	e486                	sd	ra,72(sp)
    2f66:	e0a2                	sd	s0,64(sp)
    2f68:	fc26                	sd	s1,56(sp)
    2f6a:	f84a                	sd	s2,48(sp)
    2f6c:	f44e                	sd	s3,40(sp)
    2f6e:	f052                	sd	s4,32(sp)
    2f70:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f72:	4901                	li	s2,0
    2f74:	49bd                	li	s3,15
    int pid = fork();
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	c3e080e7          	jalr	-962(ra) # 5bb4 <fork>
    2f7e:	84aa                	mv	s1,a0
    if(pid < 0){
    2f80:	02054063          	bltz	a0,2fa0 <execout+0x3e>
    } else if(pid == 0){
    2f84:	c91d                	beqz	a0,2fba <execout+0x58>
      wait((int*)0);
    2f86:	4501                	li	a0,0
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	c3c080e7          	jalr	-964(ra) # 5bc4 <wait>
  for(int avail = 0; avail < 15; avail++){
    2f90:	2905                	addw	s2,s2,1
    2f92:	ff3912e3          	bne	s2,s3,2f76 <execout+0x14>
  exit(0);
    2f96:	4501                	li	a0,0
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	c24080e7          	jalr	-988(ra) # 5bbc <exit>
      printf("fork failed\n");
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	df850513          	add	a0,a0,-520 # 6d98 <malloc+0xdbc>
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	f7c080e7          	jalr	-132(ra) # 5f24 <printf>
      exit(1);
    2fb0:	4505                	li	a0,1
    2fb2:	00003097          	auipc	ra,0x3
    2fb6:	c0a080e7          	jalr	-1014(ra) # 5bbc <exit>
        if(a == 0xffffffffffffffffLL)
    2fba:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fbc:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fbe:	6505                	lui	a0,0x1
    2fc0:	00003097          	auipc	ra,0x3
    2fc4:	c84080e7          	jalr	-892(ra) # 5c44 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fc8:	01350763          	beq	a0,s3,2fd6 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fcc:	6785                	lui	a5,0x1
    2fce:	97aa                	add	a5,a5,a0
    2fd0:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x103>
      while(1){
    2fd4:	b7ed                	j	2fbe <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fd6:	01205a63          	blez	s2,2fea <execout+0x88>
        sbrk(-4096);
    2fda:	757d                	lui	a0,0xfffff
    2fdc:	00003097          	auipc	ra,0x3
    2fe0:	c68080e7          	jalr	-920(ra) # 5c44 <sbrk>
      for(int i = 0; i < avail; i++)
    2fe4:	2485                	addw	s1,s1,1
    2fe6:	ff249ae3          	bne	s1,s2,2fda <execout+0x78>
      close(1);
    2fea:	4505                	li	a0,1
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	bf8080e7          	jalr	-1032(ra) # 5be4 <close>
      char *args[] = { "echo", "x", 0 };
    2ff4:	00003517          	auipc	a0,0x3
    2ff8:	11450513          	add	a0,a0,276 # 6108 <malloc+0x12c>
    2ffc:	faa43c23          	sd	a0,-72(s0)
    3000:	00003797          	auipc	a5,0x3
    3004:	17878793          	add	a5,a5,376 # 6178 <malloc+0x19c>
    3008:	fcf43023          	sd	a5,-64(s0)
    300c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3010:	fb840593          	add	a1,s0,-72
    3014:	00003097          	auipc	ra,0x3
    3018:	be0080e7          	jalr	-1056(ra) # 5bf4 <exec>
      exit(0);
    301c:	4501                	li	a0,0
    301e:	00003097          	auipc	ra,0x3
    3022:	b9e080e7          	jalr	-1122(ra) # 5bbc <exit>

0000000000003026 <fourteen>:
{
    3026:	1101                	add	sp,sp,-32
    3028:	ec06                	sd	ra,24(sp)
    302a:	e822                	sd	s0,16(sp)
    302c:	e426                	sd	s1,8(sp)
    302e:	1000                	add	s0,sp,32
    3030:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3032:	00004517          	auipc	a0,0x4
    3036:	27650513          	add	a0,a0,630 # 72a8 <malloc+0x12cc>
    303a:	00003097          	auipc	ra,0x3
    303e:	bea080e7          	jalr	-1046(ra) # 5c24 <mkdir>
    3042:	e165                	bnez	a0,3122 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3044:	00004517          	auipc	a0,0x4
    3048:	0bc50513          	add	a0,a0,188 # 7100 <malloc+0x1124>
    304c:	00003097          	auipc	ra,0x3
    3050:	bd8080e7          	jalr	-1064(ra) # 5c24 <mkdir>
    3054:	e56d                	bnez	a0,313e <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3056:	20000593          	li	a1,512
    305a:	00004517          	auipc	a0,0x4
    305e:	0fe50513          	add	a0,a0,254 # 7158 <malloc+0x117c>
    3062:	00003097          	auipc	ra,0x3
    3066:	b9a080e7          	jalr	-1126(ra) # 5bfc <open>
  if(fd < 0){
    306a:	0e054863          	bltz	a0,315a <fourteen+0x134>
  close(fd);
    306e:	00003097          	auipc	ra,0x3
    3072:	b76080e7          	jalr	-1162(ra) # 5be4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3076:	4581                	li	a1,0
    3078:	00004517          	auipc	a0,0x4
    307c:	15850513          	add	a0,a0,344 # 71d0 <malloc+0x11f4>
    3080:	00003097          	auipc	ra,0x3
    3084:	b7c080e7          	jalr	-1156(ra) # 5bfc <open>
  if(fd < 0){
    3088:	0e054763          	bltz	a0,3176 <fourteen+0x150>
  close(fd);
    308c:	00003097          	auipc	ra,0x3
    3090:	b58080e7          	jalr	-1192(ra) # 5be4 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3094:	00004517          	auipc	a0,0x4
    3098:	1ac50513          	add	a0,a0,428 # 7240 <malloc+0x1264>
    309c:	00003097          	auipc	ra,0x3
    30a0:	b88080e7          	jalr	-1144(ra) # 5c24 <mkdir>
    30a4:	c57d                	beqz	a0,3192 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30a6:	00004517          	auipc	a0,0x4
    30aa:	1f250513          	add	a0,a0,498 # 7298 <malloc+0x12bc>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	b76080e7          	jalr	-1162(ra) # 5c24 <mkdir>
    30b6:	cd65                	beqz	a0,31ae <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30b8:	00004517          	auipc	a0,0x4
    30bc:	1e050513          	add	a0,a0,480 # 7298 <malloc+0x12bc>
    30c0:	00003097          	auipc	ra,0x3
    30c4:	b4c080e7          	jalr	-1204(ra) # 5c0c <unlink>
  unlink("12345678901234/12345678901234");
    30c8:	00004517          	auipc	a0,0x4
    30cc:	17850513          	add	a0,a0,376 # 7240 <malloc+0x1264>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	b3c080e7          	jalr	-1220(ra) # 5c0c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30d8:	00004517          	auipc	a0,0x4
    30dc:	0f850513          	add	a0,a0,248 # 71d0 <malloc+0x11f4>
    30e0:	00003097          	auipc	ra,0x3
    30e4:	b2c080e7          	jalr	-1236(ra) # 5c0c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30e8:	00004517          	auipc	a0,0x4
    30ec:	07050513          	add	a0,a0,112 # 7158 <malloc+0x117c>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	b1c080e7          	jalr	-1252(ra) # 5c0c <unlink>
  unlink("12345678901234/123456789012345");
    30f8:	00004517          	auipc	a0,0x4
    30fc:	00850513          	add	a0,a0,8 # 7100 <malloc+0x1124>
    3100:	00003097          	auipc	ra,0x3
    3104:	b0c080e7          	jalr	-1268(ra) # 5c0c <unlink>
  unlink("12345678901234");
    3108:	00004517          	auipc	a0,0x4
    310c:	1a050513          	add	a0,a0,416 # 72a8 <malloc+0x12cc>
    3110:	00003097          	auipc	ra,0x3
    3114:	afc080e7          	jalr	-1284(ra) # 5c0c <unlink>
}
    3118:	60e2                	ld	ra,24(sp)
    311a:	6442                	ld	s0,16(sp)
    311c:	64a2                	ld	s1,8(sp)
    311e:	6105                	add	sp,sp,32
    3120:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3122:	85a6                	mv	a1,s1
    3124:	00004517          	auipc	a0,0x4
    3128:	fb450513          	add	a0,a0,-76 # 70d8 <malloc+0x10fc>
    312c:	00003097          	auipc	ra,0x3
    3130:	df8080e7          	jalr	-520(ra) # 5f24 <printf>
    exit(1);
    3134:	4505                	li	a0,1
    3136:	00003097          	auipc	ra,0x3
    313a:	a86080e7          	jalr	-1402(ra) # 5bbc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    313e:	85a6                	mv	a1,s1
    3140:	00004517          	auipc	a0,0x4
    3144:	fe050513          	add	a0,a0,-32 # 7120 <malloc+0x1144>
    3148:	00003097          	auipc	ra,0x3
    314c:	ddc080e7          	jalr	-548(ra) # 5f24 <printf>
    exit(1);
    3150:	4505                	li	a0,1
    3152:	00003097          	auipc	ra,0x3
    3156:	a6a080e7          	jalr	-1430(ra) # 5bbc <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    315a:	85a6                	mv	a1,s1
    315c:	00004517          	auipc	a0,0x4
    3160:	02c50513          	add	a0,a0,44 # 7188 <malloc+0x11ac>
    3164:	00003097          	auipc	ra,0x3
    3168:	dc0080e7          	jalr	-576(ra) # 5f24 <printf>
    exit(1);
    316c:	4505                	li	a0,1
    316e:	00003097          	auipc	ra,0x3
    3172:	a4e080e7          	jalr	-1458(ra) # 5bbc <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3176:	85a6                	mv	a1,s1
    3178:	00004517          	auipc	a0,0x4
    317c:	08850513          	add	a0,a0,136 # 7200 <malloc+0x1224>
    3180:	00003097          	auipc	ra,0x3
    3184:	da4080e7          	jalr	-604(ra) # 5f24 <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	00003097          	auipc	ra,0x3
    318e:	a32080e7          	jalr	-1486(ra) # 5bbc <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3192:	85a6                	mv	a1,s1
    3194:	00004517          	auipc	a0,0x4
    3198:	0cc50513          	add	a0,a0,204 # 7260 <malloc+0x1284>
    319c:	00003097          	auipc	ra,0x3
    31a0:	d88080e7          	jalr	-632(ra) # 5f24 <printf>
    exit(1);
    31a4:	4505                	li	a0,1
    31a6:	00003097          	auipc	ra,0x3
    31aa:	a16080e7          	jalr	-1514(ra) # 5bbc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31ae:	85a6                	mv	a1,s1
    31b0:	00004517          	auipc	a0,0x4
    31b4:	10850513          	add	a0,a0,264 # 72b8 <malloc+0x12dc>
    31b8:	00003097          	auipc	ra,0x3
    31bc:	d6c080e7          	jalr	-660(ra) # 5f24 <printf>
    exit(1);
    31c0:	4505                	li	a0,1
    31c2:	00003097          	auipc	ra,0x3
    31c6:	9fa080e7          	jalr	-1542(ra) # 5bbc <exit>

00000000000031ca <diskfull>:
{
    31ca:	b8010113          	add	sp,sp,-1152
    31ce:	46113c23          	sd	ra,1144(sp)
    31d2:	46813823          	sd	s0,1136(sp)
    31d6:	46913423          	sd	s1,1128(sp)
    31da:	47213023          	sd	s2,1120(sp)
    31de:	45313c23          	sd	s3,1112(sp)
    31e2:	45413823          	sd	s4,1104(sp)
    31e6:	45513423          	sd	s5,1096(sp)
    31ea:	45613023          	sd	s6,1088(sp)
    31ee:	43713c23          	sd	s7,1080(sp)
    31f2:	43813823          	sd	s8,1072(sp)
    31f6:	43913423          	sd	s9,1064(sp)
    31fa:	48010413          	add	s0,sp,1152
    31fe:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    3200:	00004517          	auipc	a0,0x4
    3204:	0f050513          	add	a0,a0,240 # 72f0 <malloc+0x1314>
    3208:	00003097          	auipc	ra,0x3
    320c:	a04080e7          	jalr	-1532(ra) # 5c0c <unlink>
    3210:	03000993          	li	s3,48
    name[0] = 'b';
    3214:	06200b13          	li	s6,98
    name[1] = 'i';
    3218:	06900a93          	li	s5,105
    name[2] = 'g';
    321c:	06700a13          	li	s4,103
    3220:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    3224:	07f00c13          	li	s8,127
    3228:	a269                	j	33b2 <diskfull+0x1e8>
      printf("%s: could not create file %s\n", s, name);
    322a:	b8040613          	add	a2,s0,-1152
    322e:	85e6                	mv	a1,s9
    3230:	00004517          	auipc	a0,0x4
    3234:	0d050513          	add	a0,a0,208 # 7300 <malloc+0x1324>
    3238:	00003097          	auipc	ra,0x3
    323c:	cec080e7          	jalr	-788(ra) # 5f24 <printf>
      break;
    3240:	a819                	j	3256 <diskfull+0x8c>
        close(fd);
    3242:	854a                	mv	a0,s2
    3244:	00003097          	auipc	ra,0x3
    3248:	9a0080e7          	jalr	-1632(ra) # 5be4 <close>
    close(fd);
    324c:	854a                	mv	a0,s2
    324e:	00003097          	auipc	ra,0x3
    3252:	996080e7          	jalr	-1642(ra) # 5be4 <close>
  for(int i = 0; i < nzz; i++){
    3256:	4481                	li	s1,0
    name[0] = 'z';
    3258:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    325c:	08000993          	li	s3,128
    name[0] = 'z';
    3260:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    3264:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    3268:	41f4d71b          	sraw	a4,s1,0x1f
    326c:	01b7571b          	srlw	a4,a4,0x1b
    3270:	009707bb          	addw	a5,a4,s1
    3274:	4057d69b          	sraw	a3,a5,0x5
    3278:	0306869b          	addw	a3,a3,48
    327c:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3280:	8bfd                	and	a5,a5,31
    3282:	9f99                	subw	a5,a5,a4
    3284:	0307879b          	addw	a5,a5,48
    3288:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    328c:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3290:	ba040513          	add	a0,s0,-1120
    3294:	00003097          	auipc	ra,0x3
    3298:	978080e7          	jalr	-1672(ra) # 5c0c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    329c:	60200593          	li	a1,1538
    32a0:	ba040513          	add	a0,s0,-1120
    32a4:	00003097          	auipc	ra,0x3
    32a8:	958080e7          	jalr	-1704(ra) # 5bfc <open>
    if(fd < 0)
    32ac:	00054963          	bltz	a0,32be <diskfull+0xf4>
    close(fd);
    32b0:	00003097          	auipc	ra,0x3
    32b4:	934080e7          	jalr	-1740(ra) # 5be4 <close>
  for(int i = 0; i < nzz; i++){
    32b8:	2485                	addw	s1,s1,1
    32ba:	fb3493e3          	bne	s1,s3,3260 <diskfull+0x96>
  if(mkdir("diskfulldir") == 0)
    32be:	00004517          	auipc	a0,0x4
    32c2:	03250513          	add	a0,a0,50 # 72f0 <malloc+0x1314>
    32c6:	00003097          	auipc	ra,0x3
    32ca:	95e080e7          	jalr	-1698(ra) # 5c24 <mkdir>
    32ce:	12050e63          	beqz	a0,340a <diskfull+0x240>
  unlink("diskfulldir");
    32d2:	00004517          	auipc	a0,0x4
    32d6:	01e50513          	add	a0,a0,30 # 72f0 <malloc+0x1314>
    32da:	00003097          	auipc	ra,0x3
    32de:	932080e7          	jalr	-1742(ra) # 5c0c <unlink>
  for(int i = 0; i < nzz; i++){
    32e2:	4481                	li	s1,0
    name[0] = 'z';
    32e4:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32e8:	08000993          	li	s3,128
    name[0] = 'z';
    32ec:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    32f0:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    32f4:	41f4d71b          	sraw	a4,s1,0x1f
    32f8:	01b7571b          	srlw	a4,a4,0x1b
    32fc:	009707bb          	addw	a5,a4,s1
    3300:	4057d69b          	sraw	a3,a5,0x5
    3304:	0306869b          	addw	a3,a3,48
    3308:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    330c:	8bfd                	and	a5,a5,31
    330e:	9f99                	subw	a5,a5,a4
    3310:	0307879b          	addw	a5,a5,48
    3314:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3318:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    331c:	ba040513          	add	a0,s0,-1120
    3320:	00003097          	auipc	ra,0x3
    3324:	8ec080e7          	jalr	-1812(ra) # 5c0c <unlink>
  for(int i = 0; i < nzz; i++){
    3328:	2485                	addw	s1,s1,1
    332a:	fd3491e3          	bne	s1,s3,32ec <diskfull+0x122>
    332e:	03000493          	li	s1,48
    name[0] = 'b';
    3332:	06200a93          	li	s5,98
    name[1] = 'i';
    3336:	06900a13          	li	s4,105
    name[2] = 'g';
    333a:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    333e:	07f00913          	li	s2,127
    name[0] = 'b';
    3342:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    3346:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    334a:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    334e:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    3352:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3356:	ba040513          	add	a0,s0,-1120
    335a:	00003097          	auipc	ra,0x3
    335e:	8b2080e7          	jalr	-1870(ra) # 5c0c <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    3362:	2485                	addw	s1,s1,1
    3364:	0ff4f493          	zext.b	s1,s1
    3368:	fd249de3          	bne	s1,s2,3342 <diskfull+0x178>
}
    336c:	47813083          	ld	ra,1144(sp)
    3370:	47013403          	ld	s0,1136(sp)
    3374:	46813483          	ld	s1,1128(sp)
    3378:	46013903          	ld	s2,1120(sp)
    337c:	45813983          	ld	s3,1112(sp)
    3380:	45013a03          	ld	s4,1104(sp)
    3384:	44813a83          	ld	s5,1096(sp)
    3388:	44013b03          	ld	s6,1088(sp)
    338c:	43813b83          	ld	s7,1080(sp)
    3390:	43013c03          	ld	s8,1072(sp)
    3394:	42813c83          	ld	s9,1064(sp)
    3398:	48010113          	add	sp,sp,1152
    339c:	8082                	ret
    close(fd);
    339e:	854a                	mv	a0,s2
    33a0:	00003097          	auipc	ra,0x3
    33a4:	844080e7          	jalr	-1980(ra) # 5be4 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    33a8:	2985                	addw	s3,s3,1
    33aa:	0ff9f993          	zext.b	s3,s3
    33ae:	eb8984e3          	beq	s3,s8,3256 <diskfull+0x8c>
    name[0] = 'b';
    33b2:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    33b6:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    33ba:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    33be:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    33c2:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    33c6:	b8040513          	add	a0,s0,-1152
    33ca:	00003097          	auipc	ra,0x3
    33ce:	842080e7          	jalr	-1982(ra) # 5c0c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33d2:	60200593          	li	a1,1538
    33d6:	b8040513          	add	a0,s0,-1152
    33da:	00003097          	auipc	ra,0x3
    33de:	822080e7          	jalr	-2014(ra) # 5bfc <open>
    33e2:	892a                	mv	s2,a0
    if(fd < 0){
    33e4:	e40543e3          	bltz	a0,322a <diskfull+0x60>
    33e8:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33ea:	40000613          	li	a2,1024
    33ee:	ba040593          	add	a1,s0,-1120
    33f2:	854a                	mv	a0,s2
    33f4:	00002097          	auipc	ra,0x2
    33f8:	7e8080e7          	jalr	2024(ra) # 5bdc <write>
    33fc:	40000793          	li	a5,1024
    3400:	e4f511e3          	bne	a0,a5,3242 <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    3404:	34fd                	addw	s1,s1,-1
    3406:	f0f5                	bnez	s1,33ea <diskfull+0x220>
    3408:	bf59                	j	339e <diskfull+0x1d4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    340a:	00004517          	auipc	a0,0x4
    340e:	f1650513          	add	a0,a0,-234 # 7320 <malloc+0x1344>
    3412:	00003097          	auipc	ra,0x3
    3416:	b12080e7          	jalr	-1262(ra) # 5f24 <printf>
    341a:	bd65                	j	32d2 <diskfull+0x108>

000000000000341c <iputtest>:
{
    341c:	1101                	add	sp,sp,-32
    341e:	ec06                	sd	ra,24(sp)
    3420:	e822                	sd	s0,16(sp)
    3422:	e426                	sd	s1,8(sp)
    3424:	1000                	add	s0,sp,32
    3426:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3428:	00004517          	auipc	a0,0x4
    342c:	f2850513          	add	a0,a0,-216 # 7350 <malloc+0x1374>
    3430:	00002097          	auipc	ra,0x2
    3434:	7f4080e7          	jalr	2036(ra) # 5c24 <mkdir>
    3438:	04054563          	bltz	a0,3482 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    343c:	00004517          	auipc	a0,0x4
    3440:	f1450513          	add	a0,a0,-236 # 7350 <malloc+0x1374>
    3444:	00002097          	auipc	ra,0x2
    3448:	7e8080e7          	jalr	2024(ra) # 5c2c <chdir>
    344c:	04054963          	bltz	a0,349e <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3450:	00004517          	auipc	a0,0x4
    3454:	f4050513          	add	a0,a0,-192 # 7390 <malloc+0x13b4>
    3458:	00002097          	auipc	ra,0x2
    345c:	7b4080e7          	jalr	1972(ra) # 5c0c <unlink>
    3460:	04054d63          	bltz	a0,34ba <iputtest+0x9e>
  if(chdir("/") < 0){
    3464:	00004517          	auipc	a0,0x4
    3468:	f5c50513          	add	a0,a0,-164 # 73c0 <malloc+0x13e4>
    346c:	00002097          	auipc	ra,0x2
    3470:	7c0080e7          	jalr	1984(ra) # 5c2c <chdir>
    3474:	06054163          	bltz	a0,34d6 <iputtest+0xba>
}
    3478:	60e2                	ld	ra,24(sp)
    347a:	6442                	ld	s0,16(sp)
    347c:	64a2                	ld	s1,8(sp)
    347e:	6105                	add	sp,sp,32
    3480:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3482:	85a6                	mv	a1,s1
    3484:	00004517          	auipc	a0,0x4
    3488:	ed450513          	add	a0,a0,-300 # 7358 <malloc+0x137c>
    348c:	00003097          	auipc	ra,0x3
    3490:	a98080e7          	jalr	-1384(ra) # 5f24 <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00002097          	auipc	ra,0x2
    349a:	726080e7          	jalr	1830(ra) # 5bbc <exit>
    printf("%s: chdir iputdir failed\n", s);
    349e:	85a6                	mv	a1,s1
    34a0:	00004517          	auipc	a0,0x4
    34a4:	ed050513          	add	a0,a0,-304 # 7370 <malloc+0x1394>
    34a8:	00003097          	auipc	ra,0x3
    34ac:	a7c080e7          	jalr	-1412(ra) # 5f24 <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00002097          	auipc	ra,0x2
    34b6:	70a080e7          	jalr	1802(ra) # 5bbc <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34ba:	85a6                	mv	a1,s1
    34bc:	00004517          	auipc	a0,0x4
    34c0:	ee450513          	add	a0,a0,-284 # 73a0 <malloc+0x13c4>
    34c4:	00003097          	auipc	ra,0x3
    34c8:	a60080e7          	jalr	-1440(ra) # 5f24 <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	6ee080e7          	jalr	1774(ra) # 5bbc <exit>
    printf("%s: chdir / failed\n", s);
    34d6:	85a6                	mv	a1,s1
    34d8:	00004517          	auipc	a0,0x4
    34dc:	ef050513          	add	a0,a0,-272 # 73c8 <malloc+0x13ec>
    34e0:	00003097          	auipc	ra,0x3
    34e4:	a44080e7          	jalr	-1468(ra) # 5f24 <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	6d2080e7          	jalr	1746(ra) # 5bbc <exit>

00000000000034f2 <exitiputtest>:
{
    34f2:	7179                	add	sp,sp,-48
    34f4:	f406                	sd	ra,40(sp)
    34f6:	f022                	sd	s0,32(sp)
    34f8:	ec26                	sd	s1,24(sp)
    34fa:	1800                	add	s0,sp,48
    34fc:	84aa                	mv	s1,a0
  pid = fork();
    34fe:	00002097          	auipc	ra,0x2
    3502:	6b6080e7          	jalr	1718(ra) # 5bb4 <fork>
  if(pid < 0){
    3506:	04054663          	bltz	a0,3552 <exitiputtest+0x60>
  if(pid == 0){
    350a:	ed45                	bnez	a0,35c2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    350c:	00004517          	auipc	a0,0x4
    3510:	e4450513          	add	a0,a0,-444 # 7350 <malloc+0x1374>
    3514:	00002097          	auipc	ra,0x2
    3518:	710080e7          	jalr	1808(ra) # 5c24 <mkdir>
    351c:	04054963          	bltz	a0,356e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3520:	00004517          	auipc	a0,0x4
    3524:	e3050513          	add	a0,a0,-464 # 7350 <malloc+0x1374>
    3528:	00002097          	auipc	ra,0x2
    352c:	704080e7          	jalr	1796(ra) # 5c2c <chdir>
    3530:	04054d63          	bltz	a0,358a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3534:	00004517          	auipc	a0,0x4
    3538:	e5c50513          	add	a0,a0,-420 # 7390 <malloc+0x13b4>
    353c:	00002097          	auipc	ra,0x2
    3540:	6d0080e7          	jalr	1744(ra) # 5c0c <unlink>
    3544:	06054163          	bltz	a0,35a6 <exitiputtest+0xb4>
    exit(0);
    3548:	4501                	li	a0,0
    354a:	00002097          	auipc	ra,0x2
    354e:	672080e7          	jalr	1650(ra) # 5bbc <exit>
    printf("%s: fork failed\n", s);
    3552:	85a6                	mv	a1,s1
    3554:	00003517          	auipc	a0,0x3
    3558:	43c50513          	add	a0,a0,1084 # 6990 <malloc+0x9b4>
    355c:	00003097          	auipc	ra,0x3
    3560:	9c8080e7          	jalr	-1592(ra) # 5f24 <printf>
    exit(1);
    3564:	4505                	li	a0,1
    3566:	00002097          	auipc	ra,0x2
    356a:	656080e7          	jalr	1622(ra) # 5bbc <exit>
      printf("%s: mkdir failed\n", s);
    356e:	85a6                	mv	a1,s1
    3570:	00004517          	auipc	a0,0x4
    3574:	de850513          	add	a0,a0,-536 # 7358 <malloc+0x137c>
    3578:	00003097          	auipc	ra,0x3
    357c:	9ac080e7          	jalr	-1620(ra) # 5f24 <printf>
      exit(1);
    3580:	4505                	li	a0,1
    3582:	00002097          	auipc	ra,0x2
    3586:	63a080e7          	jalr	1594(ra) # 5bbc <exit>
      printf("%s: child chdir failed\n", s);
    358a:	85a6                	mv	a1,s1
    358c:	00004517          	auipc	a0,0x4
    3590:	e5450513          	add	a0,a0,-428 # 73e0 <malloc+0x1404>
    3594:	00003097          	auipc	ra,0x3
    3598:	990080e7          	jalr	-1648(ra) # 5f24 <printf>
      exit(1);
    359c:	4505                	li	a0,1
    359e:	00002097          	auipc	ra,0x2
    35a2:	61e080e7          	jalr	1566(ra) # 5bbc <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35a6:	85a6                	mv	a1,s1
    35a8:	00004517          	auipc	a0,0x4
    35ac:	df850513          	add	a0,a0,-520 # 73a0 <malloc+0x13c4>
    35b0:	00003097          	auipc	ra,0x3
    35b4:	974080e7          	jalr	-1676(ra) # 5f24 <printf>
      exit(1);
    35b8:	4505                	li	a0,1
    35ba:	00002097          	auipc	ra,0x2
    35be:	602080e7          	jalr	1538(ra) # 5bbc <exit>
  wait(&xstatus);
    35c2:	fdc40513          	add	a0,s0,-36
    35c6:	00002097          	auipc	ra,0x2
    35ca:	5fe080e7          	jalr	1534(ra) # 5bc4 <wait>
  exit(xstatus);
    35ce:	fdc42503          	lw	a0,-36(s0)
    35d2:	00002097          	auipc	ra,0x2
    35d6:	5ea080e7          	jalr	1514(ra) # 5bbc <exit>

00000000000035da <dirtest>:
{
    35da:	1101                	add	sp,sp,-32
    35dc:	ec06                	sd	ra,24(sp)
    35de:	e822                	sd	s0,16(sp)
    35e0:	e426                	sd	s1,8(sp)
    35e2:	1000                	add	s0,sp,32
    35e4:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35e6:	00004517          	auipc	a0,0x4
    35ea:	e1250513          	add	a0,a0,-494 # 73f8 <malloc+0x141c>
    35ee:	00002097          	auipc	ra,0x2
    35f2:	636080e7          	jalr	1590(ra) # 5c24 <mkdir>
    35f6:	04054563          	bltz	a0,3640 <dirtest+0x66>
  if(chdir("dir0") < 0){
    35fa:	00004517          	auipc	a0,0x4
    35fe:	dfe50513          	add	a0,a0,-514 # 73f8 <malloc+0x141c>
    3602:	00002097          	auipc	ra,0x2
    3606:	62a080e7          	jalr	1578(ra) # 5c2c <chdir>
    360a:	04054963          	bltz	a0,365c <dirtest+0x82>
  if(chdir("..") < 0){
    360e:	00004517          	auipc	a0,0x4
    3612:	e0a50513          	add	a0,a0,-502 # 7418 <malloc+0x143c>
    3616:	00002097          	auipc	ra,0x2
    361a:	616080e7          	jalr	1558(ra) # 5c2c <chdir>
    361e:	04054d63          	bltz	a0,3678 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3622:	00004517          	auipc	a0,0x4
    3626:	dd650513          	add	a0,a0,-554 # 73f8 <malloc+0x141c>
    362a:	00002097          	auipc	ra,0x2
    362e:	5e2080e7          	jalr	1506(ra) # 5c0c <unlink>
    3632:	06054163          	bltz	a0,3694 <dirtest+0xba>
}
    3636:	60e2                	ld	ra,24(sp)
    3638:	6442                	ld	s0,16(sp)
    363a:	64a2                	ld	s1,8(sp)
    363c:	6105                	add	sp,sp,32
    363e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3640:	85a6                	mv	a1,s1
    3642:	00004517          	auipc	a0,0x4
    3646:	d1650513          	add	a0,a0,-746 # 7358 <malloc+0x137c>
    364a:	00003097          	auipc	ra,0x3
    364e:	8da080e7          	jalr	-1830(ra) # 5f24 <printf>
    exit(1);
    3652:	4505                	li	a0,1
    3654:	00002097          	auipc	ra,0x2
    3658:	568080e7          	jalr	1384(ra) # 5bbc <exit>
    printf("%s: chdir dir0 failed\n", s);
    365c:	85a6                	mv	a1,s1
    365e:	00004517          	auipc	a0,0x4
    3662:	da250513          	add	a0,a0,-606 # 7400 <malloc+0x1424>
    3666:	00003097          	auipc	ra,0x3
    366a:	8be080e7          	jalr	-1858(ra) # 5f24 <printf>
    exit(1);
    366e:	4505                	li	a0,1
    3670:	00002097          	auipc	ra,0x2
    3674:	54c080e7          	jalr	1356(ra) # 5bbc <exit>
    printf("%s: chdir .. failed\n", s);
    3678:	85a6                	mv	a1,s1
    367a:	00004517          	auipc	a0,0x4
    367e:	da650513          	add	a0,a0,-602 # 7420 <malloc+0x1444>
    3682:	00003097          	auipc	ra,0x3
    3686:	8a2080e7          	jalr	-1886(ra) # 5f24 <printf>
    exit(1);
    368a:	4505                	li	a0,1
    368c:	00002097          	auipc	ra,0x2
    3690:	530080e7          	jalr	1328(ra) # 5bbc <exit>
    printf("%s: unlink dir0 failed\n", s);
    3694:	85a6                	mv	a1,s1
    3696:	00004517          	auipc	a0,0x4
    369a:	da250513          	add	a0,a0,-606 # 7438 <malloc+0x145c>
    369e:	00003097          	auipc	ra,0x3
    36a2:	886080e7          	jalr	-1914(ra) # 5f24 <printf>
    exit(1);
    36a6:	4505                	li	a0,1
    36a8:	00002097          	auipc	ra,0x2
    36ac:	514080e7          	jalr	1300(ra) # 5bbc <exit>

00000000000036b0 <subdir>:
{
    36b0:	1101                	add	sp,sp,-32
    36b2:	ec06                	sd	ra,24(sp)
    36b4:	e822                	sd	s0,16(sp)
    36b6:	e426                	sd	s1,8(sp)
    36b8:	e04a                	sd	s2,0(sp)
    36ba:	1000                	add	s0,sp,32
    36bc:	892a                	mv	s2,a0
  unlink("ff");
    36be:	00004517          	auipc	a0,0x4
    36c2:	ec250513          	add	a0,a0,-318 # 7580 <malloc+0x15a4>
    36c6:	00002097          	auipc	ra,0x2
    36ca:	546080e7          	jalr	1350(ra) # 5c0c <unlink>
  if(mkdir("dd") != 0){
    36ce:	00004517          	auipc	a0,0x4
    36d2:	d8250513          	add	a0,a0,-638 # 7450 <malloc+0x1474>
    36d6:	00002097          	auipc	ra,0x2
    36da:	54e080e7          	jalr	1358(ra) # 5c24 <mkdir>
    36de:	38051663          	bnez	a0,3a6a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36e2:	20200593          	li	a1,514
    36e6:	00004517          	auipc	a0,0x4
    36ea:	d8a50513          	add	a0,a0,-630 # 7470 <malloc+0x1494>
    36ee:	00002097          	auipc	ra,0x2
    36f2:	50e080e7          	jalr	1294(ra) # 5bfc <open>
    36f6:	84aa                	mv	s1,a0
  if(fd < 0){
    36f8:	38054763          	bltz	a0,3a86 <subdir+0x3d6>
  write(fd, "ff", 2);
    36fc:	4609                	li	a2,2
    36fe:	00004597          	auipc	a1,0x4
    3702:	e8258593          	add	a1,a1,-382 # 7580 <malloc+0x15a4>
    3706:	00002097          	auipc	ra,0x2
    370a:	4d6080e7          	jalr	1238(ra) # 5bdc <write>
  close(fd);
    370e:	8526                	mv	a0,s1
    3710:	00002097          	auipc	ra,0x2
    3714:	4d4080e7          	jalr	1236(ra) # 5be4 <close>
  if(unlink("dd") >= 0){
    3718:	00004517          	auipc	a0,0x4
    371c:	d3850513          	add	a0,a0,-712 # 7450 <malloc+0x1474>
    3720:	00002097          	auipc	ra,0x2
    3724:	4ec080e7          	jalr	1260(ra) # 5c0c <unlink>
    3728:	36055d63          	bgez	a0,3aa2 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    372c:	00004517          	auipc	a0,0x4
    3730:	d9c50513          	add	a0,a0,-612 # 74c8 <malloc+0x14ec>
    3734:	00002097          	auipc	ra,0x2
    3738:	4f0080e7          	jalr	1264(ra) # 5c24 <mkdir>
    373c:	38051163          	bnez	a0,3abe <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3740:	20200593          	li	a1,514
    3744:	00004517          	auipc	a0,0x4
    3748:	dac50513          	add	a0,a0,-596 # 74f0 <malloc+0x1514>
    374c:	00002097          	auipc	ra,0x2
    3750:	4b0080e7          	jalr	1200(ra) # 5bfc <open>
    3754:	84aa                	mv	s1,a0
  if(fd < 0){
    3756:	38054263          	bltz	a0,3ada <subdir+0x42a>
  write(fd, "FF", 2);
    375a:	4609                	li	a2,2
    375c:	00004597          	auipc	a1,0x4
    3760:	dc458593          	add	a1,a1,-572 # 7520 <malloc+0x1544>
    3764:	00002097          	auipc	ra,0x2
    3768:	478080e7          	jalr	1144(ra) # 5bdc <write>
  close(fd);
    376c:	8526                	mv	a0,s1
    376e:	00002097          	auipc	ra,0x2
    3772:	476080e7          	jalr	1142(ra) # 5be4 <close>
  fd = open("dd/dd/../ff", 0);
    3776:	4581                	li	a1,0
    3778:	00004517          	auipc	a0,0x4
    377c:	db050513          	add	a0,a0,-592 # 7528 <malloc+0x154c>
    3780:	00002097          	auipc	ra,0x2
    3784:	47c080e7          	jalr	1148(ra) # 5bfc <open>
    3788:	84aa                	mv	s1,a0
  if(fd < 0){
    378a:	36054663          	bltz	a0,3af6 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    378e:	660d                	lui	a2,0x3
    3790:	00009597          	auipc	a1,0x9
    3794:	4e858593          	add	a1,a1,1256 # cc78 <buf>
    3798:	00002097          	auipc	ra,0x2
    379c:	43c080e7          	jalr	1084(ra) # 5bd4 <read>
  if(cc != 2 || buf[0] != 'f'){
    37a0:	4789                	li	a5,2
    37a2:	36f51863          	bne	a0,a5,3b12 <subdir+0x462>
    37a6:	00009717          	auipc	a4,0x9
    37aa:	4d274703          	lbu	a4,1234(a4) # cc78 <buf>
    37ae:	06600793          	li	a5,102
    37b2:	36f71063          	bne	a4,a5,3b12 <subdir+0x462>
  close(fd);
    37b6:	8526                	mv	a0,s1
    37b8:	00002097          	auipc	ra,0x2
    37bc:	42c080e7          	jalr	1068(ra) # 5be4 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37c0:	00004597          	auipc	a1,0x4
    37c4:	db858593          	add	a1,a1,-584 # 7578 <malloc+0x159c>
    37c8:	00004517          	auipc	a0,0x4
    37cc:	d2850513          	add	a0,a0,-728 # 74f0 <malloc+0x1514>
    37d0:	00002097          	auipc	ra,0x2
    37d4:	44c080e7          	jalr	1100(ra) # 5c1c <link>
    37d8:	34051b63          	bnez	a0,3b2e <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37dc:	00004517          	auipc	a0,0x4
    37e0:	d1450513          	add	a0,a0,-748 # 74f0 <malloc+0x1514>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	428080e7          	jalr	1064(ra) # 5c0c <unlink>
    37ec:	34051f63          	bnez	a0,3b4a <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37f0:	4581                	li	a1,0
    37f2:	00004517          	auipc	a0,0x4
    37f6:	cfe50513          	add	a0,a0,-770 # 74f0 <malloc+0x1514>
    37fa:	00002097          	auipc	ra,0x2
    37fe:	402080e7          	jalr	1026(ra) # 5bfc <open>
    3802:	36055263          	bgez	a0,3b66 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3806:	00004517          	auipc	a0,0x4
    380a:	c4a50513          	add	a0,a0,-950 # 7450 <malloc+0x1474>
    380e:	00002097          	auipc	ra,0x2
    3812:	41e080e7          	jalr	1054(ra) # 5c2c <chdir>
    3816:	36051663          	bnez	a0,3b82 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    381a:	00004517          	auipc	a0,0x4
    381e:	df650513          	add	a0,a0,-522 # 7610 <malloc+0x1634>
    3822:	00002097          	auipc	ra,0x2
    3826:	40a080e7          	jalr	1034(ra) # 5c2c <chdir>
    382a:	36051a63          	bnez	a0,3b9e <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    382e:	00004517          	auipc	a0,0x4
    3832:	e1250513          	add	a0,a0,-494 # 7640 <malloc+0x1664>
    3836:	00002097          	auipc	ra,0x2
    383a:	3f6080e7          	jalr	1014(ra) # 5c2c <chdir>
    383e:	36051e63          	bnez	a0,3bba <subdir+0x50a>
  if(chdir("./..") != 0){
    3842:	00004517          	auipc	a0,0x4
    3846:	e2e50513          	add	a0,a0,-466 # 7670 <malloc+0x1694>
    384a:	00002097          	auipc	ra,0x2
    384e:	3e2080e7          	jalr	994(ra) # 5c2c <chdir>
    3852:	38051263          	bnez	a0,3bd6 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3856:	4581                	li	a1,0
    3858:	00004517          	auipc	a0,0x4
    385c:	d2050513          	add	a0,a0,-736 # 7578 <malloc+0x159c>
    3860:	00002097          	auipc	ra,0x2
    3864:	39c080e7          	jalr	924(ra) # 5bfc <open>
    3868:	84aa                	mv	s1,a0
  if(fd < 0){
    386a:	38054463          	bltz	a0,3bf2 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    386e:	660d                	lui	a2,0x3
    3870:	00009597          	auipc	a1,0x9
    3874:	40858593          	add	a1,a1,1032 # cc78 <buf>
    3878:	00002097          	auipc	ra,0x2
    387c:	35c080e7          	jalr	860(ra) # 5bd4 <read>
    3880:	4789                	li	a5,2
    3882:	38f51663          	bne	a0,a5,3c0e <subdir+0x55e>
  close(fd);
    3886:	8526                	mv	a0,s1
    3888:	00002097          	auipc	ra,0x2
    388c:	35c080e7          	jalr	860(ra) # 5be4 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3890:	4581                	li	a1,0
    3892:	00004517          	auipc	a0,0x4
    3896:	c5e50513          	add	a0,a0,-930 # 74f0 <malloc+0x1514>
    389a:	00002097          	auipc	ra,0x2
    389e:	362080e7          	jalr	866(ra) # 5bfc <open>
    38a2:	38055463          	bgez	a0,3c2a <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38a6:	20200593          	li	a1,514
    38aa:	00004517          	auipc	a0,0x4
    38ae:	e5650513          	add	a0,a0,-426 # 7700 <malloc+0x1724>
    38b2:	00002097          	auipc	ra,0x2
    38b6:	34a080e7          	jalr	842(ra) # 5bfc <open>
    38ba:	38055663          	bgez	a0,3c46 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38be:	20200593          	li	a1,514
    38c2:	00004517          	auipc	a0,0x4
    38c6:	e6e50513          	add	a0,a0,-402 # 7730 <malloc+0x1754>
    38ca:	00002097          	auipc	ra,0x2
    38ce:	332080e7          	jalr	818(ra) # 5bfc <open>
    38d2:	38055863          	bgez	a0,3c62 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38d6:	20000593          	li	a1,512
    38da:	00004517          	auipc	a0,0x4
    38de:	b7650513          	add	a0,a0,-1162 # 7450 <malloc+0x1474>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	31a080e7          	jalr	794(ra) # 5bfc <open>
    38ea:	38055a63          	bgez	a0,3c7e <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38ee:	4589                	li	a1,2
    38f0:	00004517          	auipc	a0,0x4
    38f4:	b6050513          	add	a0,a0,-1184 # 7450 <malloc+0x1474>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	304080e7          	jalr	772(ra) # 5bfc <open>
    3900:	38055d63          	bgez	a0,3c9a <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3904:	4585                	li	a1,1
    3906:	00004517          	auipc	a0,0x4
    390a:	b4a50513          	add	a0,a0,-1206 # 7450 <malloc+0x1474>
    390e:	00002097          	auipc	ra,0x2
    3912:	2ee080e7          	jalr	750(ra) # 5bfc <open>
    3916:	3a055063          	bgez	a0,3cb6 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    391a:	00004597          	auipc	a1,0x4
    391e:	ea658593          	add	a1,a1,-346 # 77c0 <malloc+0x17e4>
    3922:	00004517          	auipc	a0,0x4
    3926:	dde50513          	add	a0,a0,-546 # 7700 <malloc+0x1724>
    392a:	00002097          	auipc	ra,0x2
    392e:	2f2080e7          	jalr	754(ra) # 5c1c <link>
    3932:	3a050063          	beqz	a0,3cd2 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3936:	00004597          	auipc	a1,0x4
    393a:	e8a58593          	add	a1,a1,-374 # 77c0 <malloc+0x17e4>
    393e:	00004517          	auipc	a0,0x4
    3942:	df250513          	add	a0,a0,-526 # 7730 <malloc+0x1754>
    3946:	00002097          	auipc	ra,0x2
    394a:	2d6080e7          	jalr	726(ra) # 5c1c <link>
    394e:	3a050063          	beqz	a0,3cee <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3952:	00004597          	auipc	a1,0x4
    3956:	c2658593          	add	a1,a1,-986 # 7578 <malloc+0x159c>
    395a:	00004517          	auipc	a0,0x4
    395e:	b1650513          	add	a0,a0,-1258 # 7470 <malloc+0x1494>
    3962:	00002097          	auipc	ra,0x2
    3966:	2ba080e7          	jalr	698(ra) # 5c1c <link>
    396a:	3a050063          	beqz	a0,3d0a <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    396e:	00004517          	auipc	a0,0x4
    3972:	d9250513          	add	a0,a0,-622 # 7700 <malloc+0x1724>
    3976:	00002097          	auipc	ra,0x2
    397a:	2ae080e7          	jalr	686(ra) # 5c24 <mkdir>
    397e:	3a050463          	beqz	a0,3d26 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3982:	00004517          	auipc	a0,0x4
    3986:	dae50513          	add	a0,a0,-594 # 7730 <malloc+0x1754>
    398a:	00002097          	auipc	ra,0x2
    398e:	29a080e7          	jalr	666(ra) # 5c24 <mkdir>
    3992:	3a050863          	beqz	a0,3d42 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3996:	00004517          	auipc	a0,0x4
    399a:	be250513          	add	a0,a0,-1054 # 7578 <malloc+0x159c>
    399e:	00002097          	auipc	ra,0x2
    39a2:	286080e7          	jalr	646(ra) # 5c24 <mkdir>
    39a6:	3a050c63          	beqz	a0,3d5e <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39aa:	00004517          	auipc	a0,0x4
    39ae:	d8650513          	add	a0,a0,-634 # 7730 <malloc+0x1754>
    39b2:	00002097          	auipc	ra,0x2
    39b6:	25a080e7          	jalr	602(ra) # 5c0c <unlink>
    39ba:	3c050063          	beqz	a0,3d7a <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39be:	00004517          	auipc	a0,0x4
    39c2:	d4250513          	add	a0,a0,-702 # 7700 <malloc+0x1724>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	246080e7          	jalr	582(ra) # 5c0c <unlink>
    39ce:	3c050463          	beqz	a0,3d96 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39d2:	00004517          	auipc	a0,0x4
    39d6:	a9e50513          	add	a0,a0,-1378 # 7470 <malloc+0x1494>
    39da:	00002097          	auipc	ra,0x2
    39de:	252080e7          	jalr	594(ra) # 5c2c <chdir>
    39e2:	3c050863          	beqz	a0,3db2 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39e6:	00004517          	auipc	a0,0x4
    39ea:	f2a50513          	add	a0,a0,-214 # 7910 <malloc+0x1934>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	23e080e7          	jalr	574(ra) # 5c2c <chdir>
    39f6:	3c050c63          	beqz	a0,3dce <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39fa:	00004517          	auipc	a0,0x4
    39fe:	b7e50513          	add	a0,a0,-1154 # 7578 <malloc+0x159c>
    3a02:	00002097          	auipc	ra,0x2
    3a06:	20a080e7          	jalr	522(ra) # 5c0c <unlink>
    3a0a:	3e051063          	bnez	a0,3dea <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a0e:	00004517          	auipc	a0,0x4
    3a12:	a6250513          	add	a0,a0,-1438 # 7470 <malloc+0x1494>
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	1f6080e7          	jalr	502(ra) # 5c0c <unlink>
    3a1e:	3e051463          	bnez	a0,3e06 <subdir+0x756>
  if(unlink("dd") == 0){
    3a22:	00004517          	auipc	a0,0x4
    3a26:	a2e50513          	add	a0,a0,-1490 # 7450 <malloc+0x1474>
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	1e2080e7          	jalr	482(ra) # 5c0c <unlink>
    3a32:	3e050863          	beqz	a0,3e22 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a36:	00004517          	auipc	a0,0x4
    3a3a:	f4a50513          	add	a0,a0,-182 # 7980 <malloc+0x19a4>
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	1ce080e7          	jalr	462(ra) # 5c0c <unlink>
    3a46:	3e054c63          	bltz	a0,3e3e <subdir+0x78e>
  if(unlink("dd") < 0){
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	a0650513          	add	a0,a0,-1530 # 7450 <malloc+0x1474>
    3a52:	00002097          	auipc	ra,0x2
    3a56:	1ba080e7          	jalr	442(ra) # 5c0c <unlink>
    3a5a:	40054063          	bltz	a0,3e5a <subdir+0x7aa>
}
    3a5e:	60e2                	ld	ra,24(sp)
    3a60:	6442                	ld	s0,16(sp)
    3a62:	64a2                	ld	s1,8(sp)
    3a64:	6902                	ld	s2,0(sp)
    3a66:	6105                	add	sp,sp,32
    3a68:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a6a:	85ca                	mv	a1,s2
    3a6c:	00004517          	auipc	a0,0x4
    3a70:	9ec50513          	add	a0,a0,-1556 # 7458 <malloc+0x147c>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	4b0080e7          	jalr	1200(ra) # 5f24 <printf>
    exit(1);
    3a7c:	4505                	li	a0,1
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	13e080e7          	jalr	318(ra) # 5bbc <exit>
    printf("%s: create dd/ff failed\n", s);
    3a86:	85ca                	mv	a1,s2
    3a88:	00004517          	auipc	a0,0x4
    3a8c:	9f050513          	add	a0,a0,-1552 # 7478 <malloc+0x149c>
    3a90:	00002097          	auipc	ra,0x2
    3a94:	494080e7          	jalr	1172(ra) # 5f24 <printf>
    exit(1);
    3a98:	4505                	li	a0,1
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	122080e7          	jalr	290(ra) # 5bbc <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3aa2:	85ca                	mv	a1,s2
    3aa4:	00004517          	auipc	a0,0x4
    3aa8:	9f450513          	add	a0,a0,-1548 # 7498 <malloc+0x14bc>
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	478080e7          	jalr	1144(ra) # 5f24 <printf>
    exit(1);
    3ab4:	4505                	li	a0,1
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	106080e7          	jalr	262(ra) # 5bbc <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3abe:	85ca                	mv	a1,s2
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	a1050513          	add	a0,a0,-1520 # 74d0 <malloc+0x14f4>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	45c080e7          	jalr	1116(ra) # 5f24 <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	0ea080e7          	jalr	234(ra) # 5bbc <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ada:	85ca                	mv	a1,s2
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	a2450513          	add	a0,a0,-1500 # 7500 <malloc+0x1524>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	440080e7          	jalr	1088(ra) # 5f24 <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	0ce080e7          	jalr	206(ra) # 5bbc <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3af6:	85ca                	mv	a1,s2
    3af8:	00004517          	auipc	a0,0x4
    3afc:	a4050513          	add	a0,a0,-1472 # 7538 <malloc+0x155c>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	424080e7          	jalr	1060(ra) # 5f24 <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	0b2080e7          	jalr	178(ra) # 5bbc <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b12:	85ca                	mv	a1,s2
    3b14:	00004517          	auipc	a0,0x4
    3b18:	a4450513          	add	a0,a0,-1468 # 7558 <malloc+0x157c>
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	408080e7          	jalr	1032(ra) # 5f24 <printf>
    exit(1);
    3b24:	4505                	li	a0,1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	096080e7          	jalr	150(ra) # 5bbc <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b2e:	85ca                	mv	a1,s2
    3b30:	00004517          	auipc	a0,0x4
    3b34:	a5850513          	add	a0,a0,-1448 # 7588 <malloc+0x15ac>
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	3ec080e7          	jalr	1004(ra) # 5f24 <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	07a080e7          	jalr	122(ra) # 5bbc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b4a:	85ca                	mv	a1,s2
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	a6450513          	add	a0,a0,-1436 # 75b0 <malloc+0x15d4>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	3d0080e7          	jalr	976(ra) # 5f24 <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	05e080e7          	jalr	94(ra) # 5bbc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b66:	85ca                	mv	a1,s2
    3b68:	00004517          	auipc	a0,0x4
    3b6c:	a6850513          	add	a0,a0,-1432 # 75d0 <malloc+0x15f4>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	3b4080e7          	jalr	948(ra) # 5f24 <printf>
    exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	042080e7          	jalr	66(ra) # 5bbc <exit>
    printf("%s: chdir dd failed\n", s);
    3b82:	85ca                	mv	a1,s2
    3b84:	00004517          	auipc	a0,0x4
    3b88:	a7450513          	add	a0,a0,-1420 # 75f8 <malloc+0x161c>
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	398080e7          	jalr	920(ra) # 5f24 <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	026080e7          	jalr	38(ra) # 5bbc <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b9e:	85ca                	mv	a1,s2
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	a8050513          	add	a0,a0,-1408 # 7620 <malloc+0x1644>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	37c080e7          	jalr	892(ra) # 5f24 <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	00a080e7          	jalr	10(ra) # 5bbc <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bba:	85ca                	mv	a1,s2
    3bbc:	00004517          	auipc	a0,0x4
    3bc0:	a9450513          	add	a0,a0,-1388 # 7650 <malloc+0x1674>
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	360080e7          	jalr	864(ra) # 5f24 <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	fee080e7          	jalr	-18(ra) # 5bbc <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bd6:	85ca                	mv	a1,s2
    3bd8:	00004517          	auipc	a0,0x4
    3bdc:	aa050513          	add	a0,a0,-1376 # 7678 <malloc+0x169c>
    3be0:	00002097          	auipc	ra,0x2
    3be4:	344080e7          	jalr	836(ra) # 5f24 <printf>
    exit(1);
    3be8:	4505                	li	a0,1
    3bea:	00002097          	auipc	ra,0x2
    3bee:	fd2080e7          	jalr	-46(ra) # 5bbc <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bf2:	85ca                	mv	a1,s2
    3bf4:	00004517          	auipc	a0,0x4
    3bf8:	a9c50513          	add	a0,a0,-1380 # 7690 <malloc+0x16b4>
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	328080e7          	jalr	808(ra) # 5f24 <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	fb6080e7          	jalr	-74(ra) # 5bbc <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c0e:	85ca                	mv	a1,s2
    3c10:	00004517          	auipc	a0,0x4
    3c14:	aa050513          	add	a0,a0,-1376 # 76b0 <malloc+0x16d4>
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	30c080e7          	jalr	780(ra) # 5f24 <printf>
    exit(1);
    3c20:	4505                	li	a0,1
    3c22:	00002097          	auipc	ra,0x2
    3c26:	f9a080e7          	jalr	-102(ra) # 5bbc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c2a:	85ca                	mv	a1,s2
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	aa450513          	add	a0,a0,-1372 # 76d0 <malloc+0x16f4>
    3c34:	00002097          	auipc	ra,0x2
    3c38:	2f0080e7          	jalr	752(ra) # 5f24 <printf>
    exit(1);
    3c3c:	4505                	li	a0,1
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	f7e080e7          	jalr	-130(ra) # 5bbc <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c46:	85ca                	mv	a1,s2
    3c48:	00004517          	auipc	a0,0x4
    3c4c:	ac850513          	add	a0,a0,-1336 # 7710 <malloc+0x1734>
    3c50:	00002097          	auipc	ra,0x2
    3c54:	2d4080e7          	jalr	724(ra) # 5f24 <printf>
    exit(1);
    3c58:	4505                	li	a0,1
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	f62080e7          	jalr	-158(ra) # 5bbc <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c62:	85ca                	mv	a1,s2
    3c64:	00004517          	auipc	a0,0x4
    3c68:	adc50513          	add	a0,a0,-1316 # 7740 <malloc+0x1764>
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	2b8080e7          	jalr	696(ra) # 5f24 <printf>
    exit(1);
    3c74:	4505                	li	a0,1
    3c76:	00002097          	auipc	ra,0x2
    3c7a:	f46080e7          	jalr	-186(ra) # 5bbc <exit>
    printf("%s: create dd succeeded!\n", s);
    3c7e:	85ca                	mv	a1,s2
    3c80:	00004517          	auipc	a0,0x4
    3c84:	ae050513          	add	a0,a0,-1312 # 7760 <malloc+0x1784>
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	29c080e7          	jalr	668(ra) # 5f24 <printf>
    exit(1);
    3c90:	4505                	li	a0,1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	f2a080e7          	jalr	-214(ra) # 5bbc <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c9a:	85ca                	mv	a1,s2
    3c9c:	00004517          	auipc	a0,0x4
    3ca0:	ae450513          	add	a0,a0,-1308 # 7780 <malloc+0x17a4>
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	280080e7          	jalr	640(ra) # 5f24 <printf>
    exit(1);
    3cac:	4505                	li	a0,1
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	f0e080e7          	jalr	-242(ra) # 5bbc <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cb6:	85ca                	mv	a1,s2
    3cb8:	00004517          	auipc	a0,0x4
    3cbc:	ae850513          	add	a0,a0,-1304 # 77a0 <malloc+0x17c4>
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	264080e7          	jalr	612(ra) # 5f24 <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	00002097          	auipc	ra,0x2
    3cce:	ef2080e7          	jalr	-270(ra) # 5bbc <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cd2:	85ca                	mv	a1,s2
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	afc50513          	add	a0,a0,-1284 # 77d0 <malloc+0x17f4>
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	248080e7          	jalr	584(ra) # 5f24 <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	ed6080e7          	jalr	-298(ra) # 5bbc <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cee:	85ca                	mv	a1,s2
    3cf0:	00004517          	auipc	a0,0x4
    3cf4:	b0850513          	add	a0,a0,-1272 # 77f8 <malloc+0x181c>
    3cf8:	00002097          	auipc	ra,0x2
    3cfc:	22c080e7          	jalr	556(ra) # 5f24 <printf>
    exit(1);
    3d00:	4505                	li	a0,1
    3d02:	00002097          	auipc	ra,0x2
    3d06:	eba080e7          	jalr	-326(ra) # 5bbc <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d0a:	85ca                	mv	a1,s2
    3d0c:	00004517          	auipc	a0,0x4
    3d10:	b1450513          	add	a0,a0,-1260 # 7820 <malloc+0x1844>
    3d14:	00002097          	auipc	ra,0x2
    3d18:	210080e7          	jalr	528(ra) # 5f24 <printf>
    exit(1);
    3d1c:	4505                	li	a0,1
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	e9e080e7          	jalr	-354(ra) # 5bbc <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d26:	85ca                	mv	a1,s2
    3d28:	00004517          	auipc	a0,0x4
    3d2c:	b2050513          	add	a0,a0,-1248 # 7848 <malloc+0x186c>
    3d30:	00002097          	auipc	ra,0x2
    3d34:	1f4080e7          	jalr	500(ra) # 5f24 <printf>
    exit(1);
    3d38:	4505                	li	a0,1
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	e82080e7          	jalr	-382(ra) # 5bbc <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d42:	85ca                	mv	a1,s2
    3d44:	00004517          	auipc	a0,0x4
    3d48:	b2450513          	add	a0,a0,-1244 # 7868 <malloc+0x188c>
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	1d8080e7          	jalr	472(ra) # 5f24 <printf>
    exit(1);
    3d54:	4505                	li	a0,1
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	e66080e7          	jalr	-410(ra) # 5bbc <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d5e:	85ca                	mv	a1,s2
    3d60:	00004517          	auipc	a0,0x4
    3d64:	b2850513          	add	a0,a0,-1240 # 7888 <malloc+0x18ac>
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	1bc080e7          	jalr	444(ra) # 5f24 <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	00002097          	auipc	ra,0x2
    3d76:	e4a080e7          	jalr	-438(ra) # 5bbc <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d7a:	85ca                	mv	a1,s2
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	b3450513          	add	a0,a0,-1228 # 78b0 <malloc+0x18d4>
    3d84:	00002097          	auipc	ra,0x2
    3d88:	1a0080e7          	jalr	416(ra) # 5f24 <printf>
    exit(1);
    3d8c:	4505                	li	a0,1
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	e2e080e7          	jalr	-466(ra) # 5bbc <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d96:	85ca                	mv	a1,s2
    3d98:	00004517          	auipc	a0,0x4
    3d9c:	b3850513          	add	a0,a0,-1224 # 78d0 <malloc+0x18f4>
    3da0:	00002097          	auipc	ra,0x2
    3da4:	184080e7          	jalr	388(ra) # 5f24 <printf>
    exit(1);
    3da8:	4505                	li	a0,1
    3daa:	00002097          	auipc	ra,0x2
    3dae:	e12080e7          	jalr	-494(ra) # 5bbc <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3db2:	85ca                	mv	a1,s2
    3db4:	00004517          	auipc	a0,0x4
    3db8:	b3c50513          	add	a0,a0,-1220 # 78f0 <malloc+0x1914>
    3dbc:	00002097          	auipc	ra,0x2
    3dc0:	168080e7          	jalr	360(ra) # 5f24 <printf>
    exit(1);
    3dc4:	4505                	li	a0,1
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	df6080e7          	jalr	-522(ra) # 5bbc <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dce:	85ca                	mv	a1,s2
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	b4850513          	add	a0,a0,-1208 # 7918 <malloc+0x193c>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	14c080e7          	jalr	332(ra) # 5f24 <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	dda080e7          	jalr	-550(ra) # 5bbc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dea:	85ca                	mv	a1,s2
    3dec:	00003517          	auipc	a0,0x3
    3df0:	7c450513          	add	a0,a0,1988 # 75b0 <malloc+0x15d4>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	130080e7          	jalr	304(ra) # 5f24 <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	dbe080e7          	jalr	-578(ra) # 5bbc <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e06:	85ca                	mv	a1,s2
    3e08:	00004517          	auipc	a0,0x4
    3e0c:	b3050513          	add	a0,a0,-1232 # 7938 <malloc+0x195c>
    3e10:	00002097          	auipc	ra,0x2
    3e14:	114080e7          	jalr	276(ra) # 5f24 <printf>
    exit(1);
    3e18:	4505                	li	a0,1
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	da2080e7          	jalr	-606(ra) # 5bbc <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e22:	85ca                	mv	a1,s2
    3e24:	00004517          	auipc	a0,0x4
    3e28:	b3450513          	add	a0,a0,-1228 # 7958 <malloc+0x197c>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	0f8080e7          	jalr	248(ra) # 5f24 <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	d86080e7          	jalr	-634(ra) # 5bbc <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e3e:	85ca                	mv	a1,s2
    3e40:	00004517          	auipc	a0,0x4
    3e44:	b4850513          	add	a0,a0,-1208 # 7988 <malloc+0x19ac>
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	0dc080e7          	jalr	220(ra) # 5f24 <printf>
    exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00002097          	auipc	ra,0x2
    3e56:	d6a080e7          	jalr	-662(ra) # 5bbc <exit>
    printf("%s: unlink dd failed\n", s);
    3e5a:	85ca                	mv	a1,s2
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	b4c50513          	add	a0,a0,-1204 # 79a8 <malloc+0x19cc>
    3e64:	00002097          	auipc	ra,0x2
    3e68:	0c0080e7          	jalr	192(ra) # 5f24 <printf>
    exit(1);
    3e6c:	4505                	li	a0,1
    3e6e:	00002097          	auipc	ra,0x2
    3e72:	d4e080e7          	jalr	-690(ra) # 5bbc <exit>

0000000000003e76 <rmdot>:
{
    3e76:	1101                	add	sp,sp,-32
    3e78:	ec06                	sd	ra,24(sp)
    3e7a:	e822                	sd	s0,16(sp)
    3e7c:	e426                	sd	s1,8(sp)
    3e7e:	1000                	add	s0,sp,32
    3e80:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e82:	00004517          	auipc	a0,0x4
    3e86:	b3e50513          	add	a0,a0,-1218 # 79c0 <malloc+0x19e4>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	d9a080e7          	jalr	-614(ra) # 5c24 <mkdir>
    3e92:	e549                	bnez	a0,3f1c <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e94:	00004517          	auipc	a0,0x4
    3e98:	b2c50513          	add	a0,a0,-1236 # 79c0 <malloc+0x19e4>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	d90080e7          	jalr	-624(ra) # 5c2c <chdir>
    3ea4:	e951                	bnez	a0,3f38 <rmdot+0xc2>
  if(unlink(".") == 0){
    3ea6:	00003517          	auipc	a0,0x3
    3eaa:	94a50513          	add	a0,a0,-1718 # 67f0 <malloc+0x814>
    3eae:	00002097          	auipc	ra,0x2
    3eb2:	d5e080e7          	jalr	-674(ra) # 5c0c <unlink>
    3eb6:	cd59                	beqz	a0,3f54 <rmdot+0xde>
  if(unlink("..") == 0){
    3eb8:	00003517          	auipc	a0,0x3
    3ebc:	56050513          	add	a0,a0,1376 # 7418 <malloc+0x143c>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	d4c080e7          	jalr	-692(ra) # 5c0c <unlink>
    3ec8:	c545                	beqz	a0,3f70 <rmdot+0xfa>
  if(chdir("/") != 0){
    3eca:	00003517          	auipc	a0,0x3
    3ece:	4f650513          	add	a0,a0,1270 # 73c0 <malloc+0x13e4>
    3ed2:	00002097          	auipc	ra,0x2
    3ed6:	d5a080e7          	jalr	-678(ra) # 5c2c <chdir>
    3eda:	e94d                	bnez	a0,3f8c <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3edc:	00004517          	auipc	a0,0x4
    3ee0:	b4c50513          	add	a0,a0,-1204 # 7a28 <malloc+0x1a4c>
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	d28080e7          	jalr	-728(ra) # 5c0c <unlink>
    3eec:	cd55                	beqz	a0,3fa8 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3eee:	00004517          	auipc	a0,0x4
    3ef2:	b6250513          	add	a0,a0,-1182 # 7a50 <malloc+0x1a74>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	d16080e7          	jalr	-746(ra) # 5c0c <unlink>
    3efe:	c179                	beqz	a0,3fc4 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f00:	00004517          	auipc	a0,0x4
    3f04:	ac050513          	add	a0,a0,-1344 # 79c0 <malloc+0x19e4>
    3f08:	00002097          	auipc	ra,0x2
    3f0c:	d04080e7          	jalr	-764(ra) # 5c0c <unlink>
    3f10:	e961                	bnez	a0,3fe0 <rmdot+0x16a>
}
    3f12:	60e2                	ld	ra,24(sp)
    3f14:	6442                	ld	s0,16(sp)
    3f16:	64a2                	ld	s1,8(sp)
    3f18:	6105                	add	sp,sp,32
    3f1a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f1c:	85a6                	mv	a1,s1
    3f1e:	00004517          	auipc	a0,0x4
    3f22:	aaa50513          	add	a0,a0,-1366 # 79c8 <malloc+0x19ec>
    3f26:	00002097          	auipc	ra,0x2
    3f2a:	ffe080e7          	jalr	-2(ra) # 5f24 <printf>
    exit(1);
    3f2e:	4505                	li	a0,1
    3f30:	00002097          	auipc	ra,0x2
    3f34:	c8c080e7          	jalr	-884(ra) # 5bbc <exit>
    printf("%s: chdir dots failed\n", s);
    3f38:	85a6                	mv	a1,s1
    3f3a:	00004517          	auipc	a0,0x4
    3f3e:	aa650513          	add	a0,a0,-1370 # 79e0 <malloc+0x1a04>
    3f42:	00002097          	auipc	ra,0x2
    3f46:	fe2080e7          	jalr	-30(ra) # 5f24 <printf>
    exit(1);
    3f4a:	4505                	li	a0,1
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	c70080e7          	jalr	-912(ra) # 5bbc <exit>
    printf("%s: rm . worked!\n", s);
    3f54:	85a6                	mv	a1,s1
    3f56:	00004517          	auipc	a0,0x4
    3f5a:	aa250513          	add	a0,a0,-1374 # 79f8 <malloc+0x1a1c>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	fc6080e7          	jalr	-58(ra) # 5f24 <printf>
    exit(1);
    3f66:	4505                	li	a0,1
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	c54080e7          	jalr	-940(ra) # 5bbc <exit>
    printf("%s: rm .. worked!\n", s);
    3f70:	85a6                	mv	a1,s1
    3f72:	00004517          	auipc	a0,0x4
    3f76:	a9e50513          	add	a0,a0,-1378 # 7a10 <malloc+0x1a34>
    3f7a:	00002097          	auipc	ra,0x2
    3f7e:	faa080e7          	jalr	-86(ra) # 5f24 <printf>
    exit(1);
    3f82:	4505                	li	a0,1
    3f84:	00002097          	auipc	ra,0x2
    3f88:	c38080e7          	jalr	-968(ra) # 5bbc <exit>
    printf("%s: chdir / failed\n", s);
    3f8c:	85a6                	mv	a1,s1
    3f8e:	00003517          	auipc	a0,0x3
    3f92:	43a50513          	add	a0,a0,1082 # 73c8 <malloc+0x13ec>
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	f8e080e7          	jalr	-114(ra) # 5f24 <printf>
    exit(1);
    3f9e:	4505                	li	a0,1
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	c1c080e7          	jalr	-996(ra) # 5bbc <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fa8:	85a6                	mv	a1,s1
    3faa:	00004517          	auipc	a0,0x4
    3fae:	a8650513          	add	a0,a0,-1402 # 7a30 <malloc+0x1a54>
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	f72080e7          	jalr	-142(ra) # 5f24 <printf>
    exit(1);
    3fba:	4505                	li	a0,1
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	c00080e7          	jalr	-1024(ra) # 5bbc <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fc4:	85a6                	mv	a1,s1
    3fc6:	00004517          	auipc	a0,0x4
    3fca:	a9250513          	add	a0,a0,-1390 # 7a58 <malloc+0x1a7c>
    3fce:	00002097          	auipc	ra,0x2
    3fd2:	f56080e7          	jalr	-170(ra) # 5f24 <printf>
    exit(1);
    3fd6:	4505                	li	a0,1
    3fd8:	00002097          	auipc	ra,0x2
    3fdc:	be4080e7          	jalr	-1052(ra) # 5bbc <exit>
    printf("%s: unlink dots failed!\n", s);
    3fe0:	85a6                	mv	a1,s1
    3fe2:	00004517          	auipc	a0,0x4
    3fe6:	a9650513          	add	a0,a0,-1386 # 7a78 <malloc+0x1a9c>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	f3a080e7          	jalr	-198(ra) # 5f24 <printf>
    exit(1);
    3ff2:	4505                	li	a0,1
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	bc8080e7          	jalr	-1080(ra) # 5bbc <exit>

0000000000003ffc <dirfile>:
{
    3ffc:	1101                	add	sp,sp,-32
    3ffe:	ec06                	sd	ra,24(sp)
    4000:	e822                	sd	s0,16(sp)
    4002:	e426                	sd	s1,8(sp)
    4004:	e04a                	sd	s2,0(sp)
    4006:	1000                	add	s0,sp,32
    4008:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    400a:	20000593          	li	a1,512
    400e:	00004517          	auipc	a0,0x4
    4012:	a8a50513          	add	a0,a0,-1398 # 7a98 <malloc+0x1abc>
    4016:	00002097          	auipc	ra,0x2
    401a:	be6080e7          	jalr	-1050(ra) # 5bfc <open>
  if(fd < 0){
    401e:	0e054d63          	bltz	a0,4118 <dirfile+0x11c>
  close(fd);
    4022:	00002097          	auipc	ra,0x2
    4026:	bc2080e7          	jalr	-1086(ra) # 5be4 <close>
  if(chdir("dirfile") == 0){
    402a:	00004517          	auipc	a0,0x4
    402e:	a6e50513          	add	a0,a0,-1426 # 7a98 <malloc+0x1abc>
    4032:	00002097          	auipc	ra,0x2
    4036:	bfa080e7          	jalr	-1030(ra) # 5c2c <chdir>
    403a:	cd6d                	beqz	a0,4134 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    403c:	4581                	li	a1,0
    403e:	00004517          	auipc	a0,0x4
    4042:	aa250513          	add	a0,a0,-1374 # 7ae0 <malloc+0x1b04>
    4046:	00002097          	auipc	ra,0x2
    404a:	bb6080e7          	jalr	-1098(ra) # 5bfc <open>
  if(fd >= 0){
    404e:	10055163          	bgez	a0,4150 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4052:	20000593          	li	a1,512
    4056:	00004517          	auipc	a0,0x4
    405a:	a8a50513          	add	a0,a0,-1398 # 7ae0 <malloc+0x1b04>
    405e:	00002097          	auipc	ra,0x2
    4062:	b9e080e7          	jalr	-1122(ra) # 5bfc <open>
  if(fd >= 0){
    4066:	10055363          	bgez	a0,416c <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    406a:	00004517          	auipc	a0,0x4
    406e:	a7650513          	add	a0,a0,-1418 # 7ae0 <malloc+0x1b04>
    4072:	00002097          	auipc	ra,0x2
    4076:	bb2080e7          	jalr	-1102(ra) # 5c24 <mkdir>
    407a:	10050763          	beqz	a0,4188 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    407e:	00004517          	auipc	a0,0x4
    4082:	a6250513          	add	a0,a0,-1438 # 7ae0 <malloc+0x1b04>
    4086:	00002097          	auipc	ra,0x2
    408a:	b86080e7          	jalr	-1146(ra) # 5c0c <unlink>
    408e:	10050b63          	beqz	a0,41a4 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4092:	00004597          	auipc	a1,0x4
    4096:	a4e58593          	add	a1,a1,-1458 # 7ae0 <malloc+0x1b04>
    409a:	00002517          	auipc	a0,0x2
    409e:	24650513          	add	a0,a0,582 # 62e0 <malloc+0x304>
    40a2:	00002097          	auipc	ra,0x2
    40a6:	b7a080e7          	jalr	-1158(ra) # 5c1c <link>
    40aa:	10050b63          	beqz	a0,41c0 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40ae:	00004517          	auipc	a0,0x4
    40b2:	9ea50513          	add	a0,a0,-1558 # 7a98 <malloc+0x1abc>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	b56080e7          	jalr	-1194(ra) # 5c0c <unlink>
    40be:	10051f63          	bnez	a0,41dc <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40c2:	4589                	li	a1,2
    40c4:	00002517          	auipc	a0,0x2
    40c8:	72c50513          	add	a0,a0,1836 # 67f0 <malloc+0x814>
    40cc:	00002097          	auipc	ra,0x2
    40d0:	b30080e7          	jalr	-1232(ra) # 5bfc <open>
  if(fd >= 0){
    40d4:	12055263          	bgez	a0,41f8 <dirfile+0x1fc>
  fd = open(".", 0);
    40d8:	4581                	li	a1,0
    40da:	00002517          	auipc	a0,0x2
    40de:	71650513          	add	a0,a0,1814 # 67f0 <malloc+0x814>
    40e2:	00002097          	auipc	ra,0x2
    40e6:	b1a080e7          	jalr	-1254(ra) # 5bfc <open>
    40ea:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40ec:	4605                	li	a2,1
    40ee:	00002597          	auipc	a1,0x2
    40f2:	08a58593          	add	a1,a1,138 # 6178 <malloc+0x19c>
    40f6:	00002097          	auipc	ra,0x2
    40fa:	ae6080e7          	jalr	-1306(ra) # 5bdc <write>
    40fe:	10a04b63          	bgtz	a0,4214 <dirfile+0x218>
  close(fd);
    4102:	8526                	mv	a0,s1
    4104:	00002097          	auipc	ra,0x2
    4108:	ae0080e7          	jalr	-1312(ra) # 5be4 <close>
}
    410c:	60e2                	ld	ra,24(sp)
    410e:	6442                	ld	s0,16(sp)
    4110:	64a2                	ld	s1,8(sp)
    4112:	6902                	ld	s2,0(sp)
    4114:	6105                	add	sp,sp,32
    4116:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4118:	85ca                	mv	a1,s2
    411a:	00004517          	auipc	a0,0x4
    411e:	98650513          	add	a0,a0,-1658 # 7aa0 <malloc+0x1ac4>
    4122:	00002097          	auipc	ra,0x2
    4126:	e02080e7          	jalr	-510(ra) # 5f24 <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00002097          	auipc	ra,0x2
    4130:	a90080e7          	jalr	-1392(ra) # 5bbc <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4134:	85ca                	mv	a1,s2
    4136:	00004517          	auipc	a0,0x4
    413a:	98a50513          	add	a0,a0,-1654 # 7ac0 <malloc+0x1ae4>
    413e:	00002097          	auipc	ra,0x2
    4142:	de6080e7          	jalr	-538(ra) # 5f24 <printf>
    exit(1);
    4146:	4505                	li	a0,1
    4148:	00002097          	auipc	ra,0x2
    414c:	a74080e7          	jalr	-1420(ra) # 5bbc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4150:	85ca                	mv	a1,s2
    4152:	00004517          	auipc	a0,0x4
    4156:	99e50513          	add	a0,a0,-1634 # 7af0 <malloc+0x1b14>
    415a:	00002097          	auipc	ra,0x2
    415e:	dca080e7          	jalr	-566(ra) # 5f24 <printf>
    exit(1);
    4162:	4505                	li	a0,1
    4164:	00002097          	auipc	ra,0x2
    4168:	a58080e7          	jalr	-1448(ra) # 5bbc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    416c:	85ca                	mv	a1,s2
    416e:	00004517          	auipc	a0,0x4
    4172:	98250513          	add	a0,a0,-1662 # 7af0 <malloc+0x1b14>
    4176:	00002097          	auipc	ra,0x2
    417a:	dae080e7          	jalr	-594(ra) # 5f24 <printf>
    exit(1);
    417e:	4505                	li	a0,1
    4180:	00002097          	auipc	ra,0x2
    4184:	a3c080e7          	jalr	-1476(ra) # 5bbc <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4188:	85ca                	mv	a1,s2
    418a:	00004517          	auipc	a0,0x4
    418e:	98e50513          	add	a0,a0,-1650 # 7b18 <malloc+0x1b3c>
    4192:	00002097          	auipc	ra,0x2
    4196:	d92080e7          	jalr	-622(ra) # 5f24 <printf>
    exit(1);
    419a:	4505                	li	a0,1
    419c:	00002097          	auipc	ra,0x2
    41a0:	a20080e7          	jalr	-1504(ra) # 5bbc <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41a4:	85ca                	mv	a1,s2
    41a6:	00004517          	auipc	a0,0x4
    41aa:	99a50513          	add	a0,a0,-1638 # 7b40 <malloc+0x1b64>
    41ae:	00002097          	auipc	ra,0x2
    41b2:	d76080e7          	jalr	-650(ra) # 5f24 <printf>
    exit(1);
    41b6:	4505                	li	a0,1
    41b8:	00002097          	auipc	ra,0x2
    41bc:	a04080e7          	jalr	-1532(ra) # 5bbc <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41c0:	85ca                	mv	a1,s2
    41c2:	00004517          	auipc	a0,0x4
    41c6:	9a650513          	add	a0,a0,-1626 # 7b68 <malloc+0x1b8c>
    41ca:	00002097          	auipc	ra,0x2
    41ce:	d5a080e7          	jalr	-678(ra) # 5f24 <printf>
    exit(1);
    41d2:	4505                	li	a0,1
    41d4:	00002097          	auipc	ra,0x2
    41d8:	9e8080e7          	jalr	-1560(ra) # 5bbc <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41dc:	85ca                	mv	a1,s2
    41de:	00004517          	auipc	a0,0x4
    41e2:	9b250513          	add	a0,a0,-1614 # 7b90 <malloc+0x1bb4>
    41e6:	00002097          	auipc	ra,0x2
    41ea:	d3e080e7          	jalr	-706(ra) # 5f24 <printf>
    exit(1);
    41ee:	4505                	li	a0,1
    41f0:	00002097          	auipc	ra,0x2
    41f4:	9cc080e7          	jalr	-1588(ra) # 5bbc <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41f8:	85ca                	mv	a1,s2
    41fa:	00004517          	auipc	a0,0x4
    41fe:	9b650513          	add	a0,a0,-1610 # 7bb0 <malloc+0x1bd4>
    4202:	00002097          	auipc	ra,0x2
    4206:	d22080e7          	jalr	-734(ra) # 5f24 <printf>
    exit(1);
    420a:	4505                	li	a0,1
    420c:	00002097          	auipc	ra,0x2
    4210:	9b0080e7          	jalr	-1616(ra) # 5bbc <exit>
    printf("%s: write . succeeded!\n", s);
    4214:	85ca                	mv	a1,s2
    4216:	00004517          	auipc	a0,0x4
    421a:	9c250513          	add	a0,a0,-1598 # 7bd8 <malloc+0x1bfc>
    421e:	00002097          	auipc	ra,0x2
    4222:	d06080e7          	jalr	-762(ra) # 5f24 <printf>
    exit(1);
    4226:	4505                	li	a0,1
    4228:	00002097          	auipc	ra,0x2
    422c:	994080e7          	jalr	-1644(ra) # 5bbc <exit>

0000000000004230 <iref>:
{
    4230:	7139                	add	sp,sp,-64
    4232:	fc06                	sd	ra,56(sp)
    4234:	f822                	sd	s0,48(sp)
    4236:	f426                	sd	s1,40(sp)
    4238:	f04a                	sd	s2,32(sp)
    423a:	ec4e                	sd	s3,24(sp)
    423c:	e852                	sd	s4,16(sp)
    423e:	e456                	sd	s5,8(sp)
    4240:	e05a                	sd	s6,0(sp)
    4242:	0080                	add	s0,sp,64
    4244:	8b2a                	mv	s6,a0
    4246:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    424a:	00004a17          	auipc	s4,0x4
    424e:	9a6a0a13          	add	s4,s4,-1626 # 7bf0 <malloc+0x1c14>
    mkdir("");
    4252:	00003497          	auipc	s1,0x3
    4256:	4a648493          	add	s1,s1,1190 # 76f8 <malloc+0x171c>
    link("README", "");
    425a:	00002a97          	auipc	s5,0x2
    425e:	086a8a93          	add	s5,s5,134 # 62e0 <malloc+0x304>
    fd = open("xx", O_CREATE);
    4262:	00004997          	auipc	s3,0x4
    4266:	88698993          	add	s3,s3,-1914 # 7ae8 <malloc+0x1b0c>
    426a:	a891                	j	42be <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    426c:	85da                	mv	a1,s6
    426e:	00004517          	auipc	a0,0x4
    4272:	98a50513          	add	a0,a0,-1654 # 7bf8 <malloc+0x1c1c>
    4276:	00002097          	auipc	ra,0x2
    427a:	cae080e7          	jalr	-850(ra) # 5f24 <printf>
      exit(1);
    427e:	4505                	li	a0,1
    4280:	00002097          	auipc	ra,0x2
    4284:	93c080e7          	jalr	-1732(ra) # 5bbc <exit>
      printf("%s: chdir irefd failed\n", s);
    4288:	85da                	mv	a1,s6
    428a:	00004517          	auipc	a0,0x4
    428e:	98650513          	add	a0,a0,-1658 # 7c10 <malloc+0x1c34>
    4292:	00002097          	auipc	ra,0x2
    4296:	c92080e7          	jalr	-878(ra) # 5f24 <printf>
      exit(1);
    429a:	4505                	li	a0,1
    429c:	00002097          	auipc	ra,0x2
    42a0:	920080e7          	jalr	-1760(ra) # 5bbc <exit>
      close(fd);
    42a4:	00002097          	auipc	ra,0x2
    42a8:	940080e7          	jalr	-1728(ra) # 5be4 <close>
    42ac:	a889                	j	42fe <iref+0xce>
    unlink("xx");
    42ae:	854e                	mv	a0,s3
    42b0:	00002097          	auipc	ra,0x2
    42b4:	95c080e7          	jalr	-1700(ra) # 5c0c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42b8:	397d                	addw	s2,s2,-1
    42ba:	06090063          	beqz	s2,431a <iref+0xea>
    if(mkdir("irefd") != 0){
    42be:	8552                	mv	a0,s4
    42c0:	00002097          	auipc	ra,0x2
    42c4:	964080e7          	jalr	-1692(ra) # 5c24 <mkdir>
    42c8:	f155                	bnez	a0,426c <iref+0x3c>
    if(chdir("irefd") != 0){
    42ca:	8552                	mv	a0,s4
    42cc:	00002097          	auipc	ra,0x2
    42d0:	960080e7          	jalr	-1696(ra) # 5c2c <chdir>
    42d4:	f955                	bnez	a0,4288 <iref+0x58>
    mkdir("");
    42d6:	8526                	mv	a0,s1
    42d8:	00002097          	auipc	ra,0x2
    42dc:	94c080e7          	jalr	-1716(ra) # 5c24 <mkdir>
    link("README", "");
    42e0:	85a6                	mv	a1,s1
    42e2:	8556                	mv	a0,s5
    42e4:	00002097          	auipc	ra,0x2
    42e8:	938080e7          	jalr	-1736(ra) # 5c1c <link>
    fd = open("", O_CREATE);
    42ec:	20000593          	li	a1,512
    42f0:	8526                	mv	a0,s1
    42f2:	00002097          	auipc	ra,0x2
    42f6:	90a080e7          	jalr	-1782(ra) # 5bfc <open>
    if(fd >= 0)
    42fa:	fa0555e3          	bgez	a0,42a4 <iref+0x74>
    fd = open("xx", O_CREATE);
    42fe:	20000593          	li	a1,512
    4302:	854e                	mv	a0,s3
    4304:	00002097          	auipc	ra,0x2
    4308:	8f8080e7          	jalr	-1800(ra) # 5bfc <open>
    if(fd >= 0)
    430c:	fa0541e3          	bltz	a0,42ae <iref+0x7e>
      close(fd);
    4310:	00002097          	auipc	ra,0x2
    4314:	8d4080e7          	jalr	-1836(ra) # 5be4 <close>
    4318:	bf59                	j	42ae <iref+0x7e>
    431a:	03300493          	li	s1,51
    chdir("..");
    431e:	00003997          	auipc	s3,0x3
    4322:	0fa98993          	add	s3,s3,250 # 7418 <malloc+0x143c>
    unlink("irefd");
    4326:	00004917          	auipc	s2,0x4
    432a:	8ca90913          	add	s2,s2,-1846 # 7bf0 <malloc+0x1c14>
    chdir("..");
    432e:	854e                	mv	a0,s3
    4330:	00002097          	auipc	ra,0x2
    4334:	8fc080e7          	jalr	-1796(ra) # 5c2c <chdir>
    unlink("irefd");
    4338:	854a                	mv	a0,s2
    433a:	00002097          	auipc	ra,0x2
    433e:	8d2080e7          	jalr	-1838(ra) # 5c0c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4342:	34fd                	addw	s1,s1,-1
    4344:	f4ed                	bnez	s1,432e <iref+0xfe>
  chdir("/");
    4346:	00003517          	auipc	a0,0x3
    434a:	07a50513          	add	a0,a0,122 # 73c0 <malloc+0x13e4>
    434e:	00002097          	auipc	ra,0x2
    4352:	8de080e7          	jalr	-1826(ra) # 5c2c <chdir>
}
    4356:	70e2                	ld	ra,56(sp)
    4358:	7442                	ld	s0,48(sp)
    435a:	74a2                	ld	s1,40(sp)
    435c:	7902                	ld	s2,32(sp)
    435e:	69e2                	ld	s3,24(sp)
    4360:	6a42                	ld	s4,16(sp)
    4362:	6aa2                	ld	s5,8(sp)
    4364:	6b02                	ld	s6,0(sp)
    4366:	6121                	add	sp,sp,64
    4368:	8082                	ret

000000000000436a <openiputtest>:
{
    436a:	7179                	add	sp,sp,-48
    436c:	f406                	sd	ra,40(sp)
    436e:	f022                	sd	s0,32(sp)
    4370:	ec26                	sd	s1,24(sp)
    4372:	1800                	add	s0,sp,48
    4374:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4376:	00004517          	auipc	a0,0x4
    437a:	8b250513          	add	a0,a0,-1870 # 7c28 <malloc+0x1c4c>
    437e:	00002097          	auipc	ra,0x2
    4382:	8a6080e7          	jalr	-1882(ra) # 5c24 <mkdir>
    4386:	04054263          	bltz	a0,43ca <openiputtest+0x60>
  pid = fork();
    438a:	00002097          	auipc	ra,0x2
    438e:	82a080e7          	jalr	-2006(ra) # 5bb4 <fork>
  if(pid < 0){
    4392:	04054a63          	bltz	a0,43e6 <openiputtest+0x7c>
  if(pid == 0){
    4396:	e93d                	bnez	a0,440c <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4398:	4589                	li	a1,2
    439a:	00004517          	auipc	a0,0x4
    439e:	88e50513          	add	a0,a0,-1906 # 7c28 <malloc+0x1c4c>
    43a2:	00002097          	auipc	ra,0x2
    43a6:	85a080e7          	jalr	-1958(ra) # 5bfc <open>
    if(fd >= 0){
    43aa:	04054c63          	bltz	a0,4402 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43ae:	85a6                	mv	a1,s1
    43b0:	00004517          	auipc	a0,0x4
    43b4:	89850513          	add	a0,a0,-1896 # 7c48 <malloc+0x1c6c>
    43b8:	00002097          	auipc	ra,0x2
    43bc:	b6c080e7          	jalr	-1172(ra) # 5f24 <printf>
      exit(1);
    43c0:	4505                	li	a0,1
    43c2:	00001097          	auipc	ra,0x1
    43c6:	7fa080e7          	jalr	2042(ra) # 5bbc <exit>
    printf("%s: mkdir oidir failed\n", s);
    43ca:	85a6                	mv	a1,s1
    43cc:	00004517          	auipc	a0,0x4
    43d0:	86450513          	add	a0,a0,-1948 # 7c30 <malloc+0x1c54>
    43d4:	00002097          	auipc	ra,0x2
    43d8:	b50080e7          	jalr	-1200(ra) # 5f24 <printf>
    exit(1);
    43dc:	4505                	li	a0,1
    43de:	00001097          	auipc	ra,0x1
    43e2:	7de080e7          	jalr	2014(ra) # 5bbc <exit>
    printf("%s: fork failed\n", s);
    43e6:	85a6                	mv	a1,s1
    43e8:	00002517          	auipc	a0,0x2
    43ec:	5a850513          	add	a0,a0,1448 # 6990 <malloc+0x9b4>
    43f0:	00002097          	auipc	ra,0x2
    43f4:	b34080e7          	jalr	-1228(ra) # 5f24 <printf>
    exit(1);
    43f8:	4505                	li	a0,1
    43fa:	00001097          	auipc	ra,0x1
    43fe:	7c2080e7          	jalr	1986(ra) # 5bbc <exit>
    exit(0);
    4402:	4501                	li	a0,0
    4404:	00001097          	auipc	ra,0x1
    4408:	7b8080e7          	jalr	1976(ra) # 5bbc <exit>
  sleep(1);
    440c:	4505                	li	a0,1
    440e:	00002097          	auipc	ra,0x2
    4412:	83e080e7          	jalr	-1986(ra) # 5c4c <sleep>
  if(unlink("oidir") != 0){
    4416:	00004517          	auipc	a0,0x4
    441a:	81250513          	add	a0,a0,-2030 # 7c28 <malloc+0x1c4c>
    441e:	00001097          	auipc	ra,0x1
    4422:	7ee080e7          	jalr	2030(ra) # 5c0c <unlink>
    4426:	cd19                	beqz	a0,4444 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4428:	85a6                	mv	a1,s1
    442a:	00002517          	auipc	a0,0x2
    442e:	75650513          	add	a0,a0,1878 # 6b80 <malloc+0xba4>
    4432:	00002097          	auipc	ra,0x2
    4436:	af2080e7          	jalr	-1294(ra) # 5f24 <printf>
    exit(1);
    443a:	4505                	li	a0,1
    443c:	00001097          	auipc	ra,0x1
    4440:	780080e7          	jalr	1920(ra) # 5bbc <exit>
  wait(&xstatus);
    4444:	fdc40513          	add	a0,s0,-36
    4448:	00001097          	auipc	ra,0x1
    444c:	77c080e7          	jalr	1916(ra) # 5bc4 <wait>
  exit(xstatus);
    4450:	fdc42503          	lw	a0,-36(s0)
    4454:	00001097          	auipc	ra,0x1
    4458:	768080e7          	jalr	1896(ra) # 5bbc <exit>

000000000000445c <forkforkfork>:
{
    445c:	1101                	add	sp,sp,-32
    445e:	ec06                	sd	ra,24(sp)
    4460:	e822                	sd	s0,16(sp)
    4462:	e426                	sd	s1,8(sp)
    4464:	1000                	add	s0,sp,32
    4466:	84aa                	mv	s1,a0
  unlink("stopforking");
    4468:	00004517          	auipc	a0,0x4
    446c:	80850513          	add	a0,a0,-2040 # 7c70 <malloc+0x1c94>
    4470:	00001097          	auipc	ra,0x1
    4474:	79c080e7          	jalr	1948(ra) # 5c0c <unlink>
  int pid = fork();
    4478:	00001097          	auipc	ra,0x1
    447c:	73c080e7          	jalr	1852(ra) # 5bb4 <fork>
  if(pid < 0){
    4480:	04054563          	bltz	a0,44ca <forkforkfork+0x6e>
  if(pid == 0){
    4484:	c12d                	beqz	a0,44e6 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4486:	4551                	li	a0,20
    4488:	00001097          	auipc	ra,0x1
    448c:	7c4080e7          	jalr	1988(ra) # 5c4c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4490:	20200593          	li	a1,514
    4494:	00003517          	auipc	a0,0x3
    4498:	7dc50513          	add	a0,a0,2012 # 7c70 <malloc+0x1c94>
    449c:	00001097          	auipc	ra,0x1
    44a0:	760080e7          	jalr	1888(ra) # 5bfc <open>
    44a4:	00001097          	auipc	ra,0x1
    44a8:	740080e7          	jalr	1856(ra) # 5be4 <close>
  wait(0);
    44ac:	4501                	li	a0,0
    44ae:	00001097          	auipc	ra,0x1
    44b2:	716080e7          	jalr	1814(ra) # 5bc4 <wait>
  sleep(10); // one second
    44b6:	4529                	li	a0,10
    44b8:	00001097          	auipc	ra,0x1
    44bc:	794080e7          	jalr	1940(ra) # 5c4c <sleep>
}
    44c0:	60e2                	ld	ra,24(sp)
    44c2:	6442                	ld	s0,16(sp)
    44c4:	64a2                	ld	s1,8(sp)
    44c6:	6105                	add	sp,sp,32
    44c8:	8082                	ret
    printf("%s: fork failed", s);
    44ca:	85a6                	mv	a1,s1
    44cc:	00002517          	auipc	a0,0x2
    44d0:	68450513          	add	a0,a0,1668 # 6b50 <malloc+0xb74>
    44d4:	00002097          	auipc	ra,0x2
    44d8:	a50080e7          	jalr	-1456(ra) # 5f24 <printf>
    exit(1);
    44dc:	4505                	li	a0,1
    44de:	00001097          	auipc	ra,0x1
    44e2:	6de080e7          	jalr	1758(ra) # 5bbc <exit>
      int fd = open("stopforking", 0);
    44e6:	00003497          	auipc	s1,0x3
    44ea:	78a48493          	add	s1,s1,1930 # 7c70 <malloc+0x1c94>
    44ee:	4581                	li	a1,0
    44f0:	8526                	mv	a0,s1
    44f2:	00001097          	auipc	ra,0x1
    44f6:	70a080e7          	jalr	1802(ra) # 5bfc <open>
      if(fd >= 0){
    44fa:	02055763          	bgez	a0,4528 <forkforkfork+0xcc>
      if(fork() < 0){
    44fe:	00001097          	auipc	ra,0x1
    4502:	6b6080e7          	jalr	1718(ra) # 5bb4 <fork>
    4506:	fe0554e3          	bgez	a0,44ee <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    450a:	20200593          	li	a1,514
    450e:	00003517          	auipc	a0,0x3
    4512:	76250513          	add	a0,a0,1890 # 7c70 <malloc+0x1c94>
    4516:	00001097          	auipc	ra,0x1
    451a:	6e6080e7          	jalr	1766(ra) # 5bfc <open>
    451e:	00001097          	auipc	ra,0x1
    4522:	6c6080e7          	jalr	1734(ra) # 5be4 <close>
    4526:	b7e1                	j	44ee <forkforkfork+0x92>
        exit(0);
    4528:	4501                	li	a0,0
    452a:	00001097          	auipc	ra,0x1
    452e:	692080e7          	jalr	1682(ra) # 5bbc <exit>

0000000000004532 <killstatus>:
{
    4532:	7139                	add	sp,sp,-64
    4534:	fc06                	sd	ra,56(sp)
    4536:	f822                	sd	s0,48(sp)
    4538:	f426                	sd	s1,40(sp)
    453a:	f04a                	sd	s2,32(sp)
    453c:	ec4e                	sd	s3,24(sp)
    453e:	e852                	sd	s4,16(sp)
    4540:	0080                	add	s0,sp,64
    4542:	8a2a                	mv	s4,a0
    4544:	06400913          	li	s2,100
    if(xst != -1) {
    4548:	59fd                	li	s3,-1
    int pid1 = fork();
    454a:	00001097          	auipc	ra,0x1
    454e:	66a080e7          	jalr	1642(ra) # 5bb4 <fork>
    4552:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4554:	02054f63          	bltz	a0,4592 <killstatus+0x60>
    if(pid1 == 0){
    4558:	c939                	beqz	a0,45ae <killstatus+0x7c>
    sleep(1);
    455a:	4505                	li	a0,1
    455c:	00001097          	auipc	ra,0x1
    4560:	6f0080e7          	jalr	1776(ra) # 5c4c <sleep>
    kill(pid1);
    4564:	8526                	mv	a0,s1
    4566:	00001097          	auipc	ra,0x1
    456a:	686080e7          	jalr	1670(ra) # 5bec <kill>
    wait(&xst);
    456e:	fcc40513          	add	a0,s0,-52
    4572:	00001097          	auipc	ra,0x1
    4576:	652080e7          	jalr	1618(ra) # 5bc4 <wait>
    if(xst != -1) {
    457a:	fcc42783          	lw	a5,-52(s0)
    457e:	03379d63          	bne	a5,s3,45b8 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4582:	397d                	addw	s2,s2,-1
    4584:	fc0913e3          	bnez	s2,454a <killstatus+0x18>
  exit(0);
    4588:	4501                	li	a0,0
    458a:	00001097          	auipc	ra,0x1
    458e:	632080e7          	jalr	1586(ra) # 5bbc <exit>
      printf("%s: fork failed\n", s);
    4592:	85d2                	mv	a1,s4
    4594:	00002517          	auipc	a0,0x2
    4598:	3fc50513          	add	a0,a0,1020 # 6990 <malloc+0x9b4>
    459c:	00002097          	auipc	ra,0x2
    45a0:	988080e7          	jalr	-1656(ra) # 5f24 <printf>
      exit(1);
    45a4:	4505                	li	a0,1
    45a6:	00001097          	auipc	ra,0x1
    45aa:	616080e7          	jalr	1558(ra) # 5bbc <exit>
        getpid();
    45ae:	00001097          	auipc	ra,0x1
    45b2:	68e080e7          	jalr	1678(ra) # 5c3c <getpid>
      while(1) {
    45b6:	bfe5                	j	45ae <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45b8:	85d2                	mv	a1,s4
    45ba:	00003517          	auipc	a0,0x3
    45be:	6c650513          	add	a0,a0,1734 # 7c80 <malloc+0x1ca4>
    45c2:	00002097          	auipc	ra,0x2
    45c6:	962080e7          	jalr	-1694(ra) # 5f24 <printf>
       exit(1);
    45ca:	4505                	li	a0,1
    45cc:	00001097          	auipc	ra,0x1
    45d0:	5f0080e7          	jalr	1520(ra) # 5bbc <exit>

00000000000045d4 <preempt>:
{
    45d4:	7139                	add	sp,sp,-64
    45d6:	fc06                	sd	ra,56(sp)
    45d8:	f822                	sd	s0,48(sp)
    45da:	f426                	sd	s1,40(sp)
    45dc:	f04a                	sd	s2,32(sp)
    45de:	ec4e                	sd	s3,24(sp)
    45e0:	e852                	sd	s4,16(sp)
    45e2:	0080                	add	s0,sp,64
    45e4:	892a                	mv	s2,a0
  pid1 = fork();
    45e6:	00001097          	auipc	ra,0x1
    45ea:	5ce080e7          	jalr	1486(ra) # 5bb4 <fork>
  if(pid1 < 0) {
    45ee:	00054563          	bltz	a0,45f8 <preempt+0x24>
    45f2:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45f4:	e105                	bnez	a0,4614 <preempt+0x40>
    for(;;)
    45f6:	a001                	j	45f6 <preempt+0x22>
    printf("%s: fork failed", s);
    45f8:	85ca                	mv	a1,s2
    45fa:	00002517          	auipc	a0,0x2
    45fe:	55650513          	add	a0,a0,1366 # 6b50 <malloc+0xb74>
    4602:	00002097          	auipc	ra,0x2
    4606:	922080e7          	jalr	-1758(ra) # 5f24 <printf>
    exit(1);
    460a:	4505                	li	a0,1
    460c:	00001097          	auipc	ra,0x1
    4610:	5b0080e7          	jalr	1456(ra) # 5bbc <exit>
  pid2 = fork();
    4614:	00001097          	auipc	ra,0x1
    4618:	5a0080e7          	jalr	1440(ra) # 5bb4 <fork>
    461c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    461e:	00054463          	bltz	a0,4626 <preempt+0x52>
  if(pid2 == 0)
    4622:	e105                	bnez	a0,4642 <preempt+0x6e>
    for(;;)
    4624:	a001                	j	4624 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4626:	85ca                	mv	a1,s2
    4628:	00002517          	auipc	a0,0x2
    462c:	36850513          	add	a0,a0,872 # 6990 <malloc+0x9b4>
    4630:	00002097          	auipc	ra,0x2
    4634:	8f4080e7          	jalr	-1804(ra) # 5f24 <printf>
    exit(1);
    4638:	4505                	li	a0,1
    463a:	00001097          	auipc	ra,0x1
    463e:	582080e7          	jalr	1410(ra) # 5bbc <exit>
  pipe(pfds);
    4642:	fc840513          	add	a0,s0,-56
    4646:	00001097          	auipc	ra,0x1
    464a:	586080e7          	jalr	1414(ra) # 5bcc <pipe>
  pid3 = fork();
    464e:	00001097          	auipc	ra,0x1
    4652:	566080e7          	jalr	1382(ra) # 5bb4 <fork>
    4656:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4658:	02054e63          	bltz	a0,4694 <preempt+0xc0>
  if(pid3 == 0){
    465c:	e525                	bnez	a0,46c4 <preempt+0xf0>
    close(pfds[0]);
    465e:	fc842503          	lw	a0,-56(s0)
    4662:	00001097          	auipc	ra,0x1
    4666:	582080e7          	jalr	1410(ra) # 5be4 <close>
    if(write(pfds[1], "x", 1) != 1)
    466a:	4605                	li	a2,1
    466c:	00002597          	auipc	a1,0x2
    4670:	b0c58593          	add	a1,a1,-1268 # 6178 <malloc+0x19c>
    4674:	fcc42503          	lw	a0,-52(s0)
    4678:	00001097          	auipc	ra,0x1
    467c:	564080e7          	jalr	1380(ra) # 5bdc <write>
    4680:	4785                	li	a5,1
    4682:	02f51763          	bne	a0,a5,46b0 <preempt+0xdc>
    close(pfds[1]);
    4686:	fcc42503          	lw	a0,-52(s0)
    468a:	00001097          	auipc	ra,0x1
    468e:	55a080e7          	jalr	1370(ra) # 5be4 <close>
    for(;;)
    4692:	a001                	j	4692 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4694:	85ca                	mv	a1,s2
    4696:	00002517          	auipc	a0,0x2
    469a:	2fa50513          	add	a0,a0,762 # 6990 <malloc+0x9b4>
    469e:	00002097          	auipc	ra,0x2
    46a2:	886080e7          	jalr	-1914(ra) # 5f24 <printf>
     exit(1);
    46a6:	4505                	li	a0,1
    46a8:	00001097          	auipc	ra,0x1
    46ac:	514080e7          	jalr	1300(ra) # 5bbc <exit>
      printf("%s: preempt write error", s);
    46b0:	85ca                	mv	a1,s2
    46b2:	00003517          	auipc	a0,0x3
    46b6:	5ee50513          	add	a0,a0,1518 # 7ca0 <malloc+0x1cc4>
    46ba:	00002097          	auipc	ra,0x2
    46be:	86a080e7          	jalr	-1942(ra) # 5f24 <printf>
    46c2:	b7d1                	j	4686 <preempt+0xb2>
  close(pfds[1]);
    46c4:	fcc42503          	lw	a0,-52(s0)
    46c8:	00001097          	auipc	ra,0x1
    46cc:	51c080e7          	jalr	1308(ra) # 5be4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46d0:	660d                	lui	a2,0x3
    46d2:	00008597          	auipc	a1,0x8
    46d6:	5a658593          	add	a1,a1,1446 # cc78 <buf>
    46da:	fc842503          	lw	a0,-56(s0)
    46de:	00001097          	auipc	ra,0x1
    46e2:	4f6080e7          	jalr	1270(ra) # 5bd4 <read>
    46e6:	4785                	li	a5,1
    46e8:	02f50363          	beq	a0,a5,470e <preempt+0x13a>
    printf("%s: preempt read error", s);
    46ec:	85ca                	mv	a1,s2
    46ee:	00003517          	auipc	a0,0x3
    46f2:	5ca50513          	add	a0,a0,1482 # 7cb8 <malloc+0x1cdc>
    46f6:	00002097          	auipc	ra,0x2
    46fa:	82e080e7          	jalr	-2002(ra) # 5f24 <printf>
}
    46fe:	70e2                	ld	ra,56(sp)
    4700:	7442                	ld	s0,48(sp)
    4702:	74a2                	ld	s1,40(sp)
    4704:	7902                	ld	s2,32(sp)
    4706:	69e2                	ld	s3,24(sp)
    4708:	6a42                	ld	s4,16(sp)
    470a:	6121                	add	sp,sp,64
    470c:	8082                	ret
  close(pfds[0]);
    470e:	fc842503          	lw	a0,-56(s0)
    4712:	00001097          	auipc	ra,0x1
    4716:	4d2080e7          	jalr	1234(ra) # 5be4 <close>
  printf("kill... ");
    471a:	00003517          	auipc	a0,0x3
    471e:	5b650513          	add	a0,a0,1462 # 7cd0 <malloc+0x1cf4>
    4722:	00002097          	auipc	ra,0x2
    4726:	802080e7          	jalr	-2046(ra) # 5f24 <printf>
  kill(pid1);
    472a:	8526                	mv	a0,s1
    472c:	00001097          	auipc	ra,0x1
    4730:	4c0080e7          	jalr	1216(ra) # 5bec <kill>
  kill(pid2);
    4734:	854e                	mv	a0,s3
    4736:	00001097          	auipc	ra,0x1
    473a:	4b6080e7          	jalr	1206(ra) # 5bec <kill>
  kill(pid3);
    473e:	8552                	mv	a0,s4
    4740:	00001097          	auipc	ra,0x1
    4744:	4ac080e7          	jalr	1196(ra) # 5bec <kill>
  printf("wait... ");
    4748:	00003517          	auipc	a0,0x3
    474c:	59850513          	add	a0,a0,1432 # 7ce0 <malloc+0x1d04>
    4750:	00001097          	auipc	ra,0x1
    4754:	7d4080e7          	jalr	2004(ra) # 5f24 <printf>
  wait(0);
    4758:	4501                	li	a0,0
    475a:	00001097          	auipc	ra,0x1
    475e:	46a080e7          	jalr	1130(ra) # 5bc4 <wait>
  wait(0);
    4762:	4501                	li	a0,0
    4764:	00001097          	auipc	ra,0x1
    4768:	460080e7          	jalr	1120(ra) # 5bc4 <wait>
  wait(0);
    476c:	4501                	li	a0,0
    476e:	00001097          	auipc	ra,0x1
    4772:	456080e7          	jalr	1110(ra) # 5bc4 <wait>
    4776:	b761                	j	46fe <preempt+0x12a>

0000000000004778 <reparent>:
{
    4778:	7179                	add	sp,sp,-48
    477a:	f406                	sd	ra,40(sp)
    477c:	f022                	sd	s0,32(sp)
    477e:	ec26                	sd	s1,24(sp)
    4780:	e84a                	sd	s2,16(sp)
    4782:	e44e                	sd	s3,8(sp)
    4784:	e052                	sd	s4,0(sp)
    4786:	1800                	add	s0,sp,48
    4788:	89aa                	mv	s3,a0
  int master_pid = getpid();
    478a:	00001097          	auipc	ra,0x1
    478e:	4b2080e7          	jalr	1202(ra) # 5c3c <getpid>
    4792:	8a2a                	mv	s4,a0
    4794:	0c800913          	li	s2,200
    int pid = fork();
    4798:	00001097          	auipc	ra,0x1
    479c:	41c080e7          	jalr	1052(ra) # 5bb4 <fork>
    47a0:	84aa                	mv	s1,a0
    if(pid < 0){
    47a2:	02054263          	bltz	a0,47c6 <reparent+0x4e>
    if(pid){
    47a6:	cd21                	beqz	a0,47fe <reparent+0x86>
      if(wait(0) != pid){
    47a8:	4501                	li	a0,0
    47aa:	00001097          	auipc	ra,0x1
    47ae:	41a080e7          	jalr	1050(ra) # 5bc4 <wait>
    47b2:	02951863          	bne	a0,s1,47e2 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47b6:	397d                	addw	s2,s2,-1
    47b8:	fe0910e3          	bnez	s2,4798 <reparent+0x20>
  exit(0);
    47bc:	4501                	li	a0,0
    47be:	00001097          	auipc	ra,0x1
    47c2:	3fe080e7          	jalr	1022(ra) # 5bbc <exit>
      printf("%s: fork failed\n", s);
    47c6:	85ce                	mv	a1,s3
    47c8:	00002517          	auipc	a0,0x2
    47cc:	1c850513          	add	a0,a0,456 # 6990 <malloc+0x9b4>
    47d0:	00001097          	auipc	ra,0x1
    47d4:	754080e7          	jalr	1876(ra) # 5f24 <printf>
      exit(1);
    47d8:	4505                	li	a0,1
    47da:	00001097          	auipc	ra,0x1
    47de:	3e2080e7          	jalr	994(ra) # 5bbc <exit>
        printf("%s: wait wrong pid\n", s);
    47e2:	85ce                	mv	a1,s3
    47e4:	00002517          	auipc	a0,0x2
    47e8:	33450513          	add	a0,a0,820 # 6b18 <malloc+0xb3c>
    47ec:	00001097          	auipc	ra,0x1
    47f0:	738080e7          	jalr	1848(ra) # 5f24 <printf>
        exit(1);
    47f4:	4505                	li	a0,1
    47f6:	00001097          	auipc	ra,0x1
    47fa:	3c6080e7          	jalr	966(ra) # 5bbc <exit>
      int pid2 = fork();
    47fe:	00001097          	auipc	ra,0x1
    4802:	3b6080e7          	jalr	950(ra) # 5bb4 <fork>
      if(pid2 < 0){
    4806:	00054763          	bltz	a0,4814 <reparent+0x9c>
      exit(0);
    480a:	4501                	li	a0,0
    480c:	00001097          	auipc	ra,0x1
    4810:	3b0080e7          	jalr	944(ra) # 5bbc <exit>
        kill(master_pid);
    4814:	8552                	mv	a0,s4
    4816:	00001097          	auipc	ra,0x1
    481a:	3d6080e7          	jalr	982(ra) # 5bec <kill>
        exit(1);
    481e:	4505                	li	a0,1
    4820:	00001097          	auipc	ra,0x1
    4824:	39c080e7          	jalr	924(ra) # 5bbc <exit>

0000000000004828 <sbrkfail>:
{
    4828:	7119                	add	sp,sp,-128
    482a:	fc86                	sd	ra,120(sp)
    482c:	f8a2                	sd	s0,112(sp)
    482e:	f4a6                	sd	s1,104(sp)
    4830:	f0ca                	sd	s2,96(sp)
    4832:	ecce                	sd	s3,88(sp)
    4834:	e8d2                	sd	s4,80(sp)
    4836:	e4d6                	sd	s5,72(sp)
    4838:	0100                	add	s0,sp,128
    483a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    483c:	fb040513          	add	a0,s0,-80
    4840:	00001097          	auipc	ra,0x1
    4844:	38c080e7          	jalr	908(ra) # 5bcc <pipe>
    4848:	e901                	bnez	a0,4858 <sbrkfail+0x30>
    484a:	f8040493          	add	s1,s0,-128
    484e:	fa840993          	add	s3,s0,-88
    4852:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4854:	5a7d                	li	s4,-1
    4856:	a085                	j	48b6 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4858:	85d6                	mv	a1,s5
    485a:	00002517          	auipc	a0,0x2
    485e:	23e50513          	add	a0,a0,574 # 6a98 <malloc+0xabc>
    4862:	00001097          	auipc	ra,0x1
    4866:	6c2080e7          	jalr	1730(ra) # 5f24 <printf>
    exit(1);
    486a:	4505                	li	a0,1
    486c:	00001097          	auipc	ra,0x1
    4870:	350080e7          	jalr	848(ra) # 5bbc <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4874:	00001097          	auipc	ra,0x1
    4878:	3d0080e7          	jalr	976(ra) # 5c44 <sbrk>
    487c:	064007b7          	lui	a5,0x6400
    4880:	40a7853b          	subw	a0,a5,a0
    4884:	00001097          	auipc	ra,0x1
    4888:	3c0080e7          	jalr	960(ra) # 5c44 <sbrk>
      write(fds[1], "x", 1);
    488c:	4605                	li	a2,1
    488e:	00002597          	auipc	a1,0x2
    4892:	8ea58593          	add	a1,a1,-1814 # 6178 <malloc+0x19c>
    4896:	fb442503          	lw	a0,-76(s0)
    489a:	00001097          	auipc	ra,0x1
    489e:	342080e7          	jalr	834(ra) # 5bdc <write>
      for(;;) sleep(1000);
    48a2:	3e800513          	li	a0,1000
    48a6:	00001097          	auipc	ra,0x1
    48aa:	3a6080e7          	jalr	934(ra) # 5c4c <sleep>
    48ae:	bfd5                	j	48a2 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48b0:	0911                	add	s2,s2,4
    48b2:	03390563          	beq	s2,s3,48dc <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    48b6:	00001097          	auipc	ra,0x1
    48ba:	2fe080e7          	jalr	766(ra) # 5bb4 <fork>
    48be:	00a92023          	sw	a0,0(s2)
    48c2:	d94d                	beqz	a0,4874 <sbrkfail+0x4c>
    if(pids[i] != -1)
    48c4:	ff4506e3          	beq	a0,s4,48b0 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48c8:	4605                	li	a2,1
    48ca:	faf40593          	add	a1,s0,-81
    48ce:	fb042503          	lw	a0,-80(s0)
    48d2:	00001097          	auipc	ra,0x1
    48d6:	302080e7          	jalr	770(ra) # 5bd4 <read>
    48da:	bfd9                	j	48b0 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48dc:	6505                	lui	a0,0x1
    48de:	00001097          	auipc	ra,0x1
    48e2:	366080e7          	jalr	870(ra) # 5c44 <sbrk>
    48e6:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48e8:	597d                	li	s2,-1
    48ea:	a021                	j	48f2 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48ec:	0491                	add	s1,s1,4
    48ee:	01348f63          	beq	s1,s3,490c <sbrkfail+0xe4>
    if(pids[i] == -1)
    48f2:	4088                	lw	a0,0(s1)
    48f4:	ff250ce3          	beq	a0,s2,48ec <sbrkfail+0xc4>
    kill(pids[i]);
    48f8:	00001097          	auipc	ra,0x1
    48fc:	2f4080e7          	jalr	756(ra) # 5bec <kill>
    wait(0);
    4900:	4501                	li	a0,0
    4902:	00001097          	auipc	ra,0x1
    4906:	2c2080e7          	jalr	706(ra) # 5bc4 <wait>
    490a:	b7cd                	j	48ec <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    490c:	57fd                	li	a5,-1
    490e:	04fa0163          	beq	s4,a5,4950 <sbrkfail+0x128>
  pid = fork();
    4912:	00001097          	auipc	ra,0x1
    4916:	2a2080e7          	jalr	674(ra) # 5bb4 <fork>
    491a:	84aa                	mv	s1,a0
  if(pid < 0){
    491c:	04054863          	bltz	a0,496c <sbrkfail+0x144>
  if(pid == 0){
    4920:	c525                	beqz	a0,4988 <sbrkfail+0x160>
  wait(&xstatus);
    4922:	fbc40513          	add	a0,s0,-68
    4926:	00001097          	auipc	ra,0x1
    492a:	29e080e7          	jalr	670(ra) # 5bc4 <wait>
  if(xstatus != -1 && xstatus != 2)
    492e:	fbc42783          	lw	a5,-68(s0)
    4932:	577d                	li	a4,-1
    4934:	00e78563          	beq	a5,a4,493e <sbrkfail+0x116>
    4938:	4709                	li	a4,2
    493a:	08e79d63          	bne	a5,a4,49d4 <sbrkfail+0x1ac>
}
    493e:	70e6                	ld	ra,120(sp)
    4940:	7446                	ld	s0,112(sp)
    4942:	74a6                	ld	s1,104(sp)
    4944:	7906                	ld	s2,96(sp)
    4946:	69e6                	ld	s3,88(sp)
    4948:	6a46                	ld	s4,80(sp)
    494a:	6aa6                	ld	s5,72(sp)
    494c:	6109                	add	sp,sp,128
    494e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4950:	85d6                	mv	a1,s5
    4952:	00003517          	auipc	a0,0x3
    4956:	39e50513          	add	a0,a0,926 # 7cf0 <malloc+0x1d14>
    495a:	00001097          	auipc	ra,0x1
    495e:	5ca080e7          	jalr	1482(ra) # 5f24 <printf>
    exit(1);
    4962:	4505                	li	a0,1
    4964:	00001097          	auipc	ra,0x1
    4968:	258080e7          	jalr	600(ra) # 5bbc <exit>
    printf("%s: fork failed\n", s);
    496c:	85d6                	mv	a1,s5
    496e:	00002517          	auipc	a0,0x2
    4972:	02250513          	add	a0,a0,34 # 6990 <malloc+0x9b4>
    4976:	00001097          	auipc	ra,0x1
    497a:	5ae080e7          	jalr	1454(ra) # 5f24 <printf>
    exit(1);
    497e:	4505                	li	a0,1
    4980:	00001097          	auipc	ra,0x1
    4984:	23c080e7          	jalr	572(ra) # 5bbc <exit>
    a = sbrk(0);
    4988:	4501                	li	a0,0
    498a:	00001097          	auipc	ra,0x1
    498e:	2ba080e7          	jalr	698(ra) # 5c44 <sbrk>
    4992:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4994:	3e800537          	lui	a0,0x3e800
    4998:	00001097          	auipc	ra,0x1
    499c:	2ac080e7          	jalr	684(ra) # 5c44 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49a0:	87ca                	mv	a5,s2
    49a2:	3e800737          	lui	a4,0x3e800
    49a6:	993a                	add	s2,s2,a4
    49a8:	6705                	lui	a4,0x1
      n += *(a+i);
    49aa:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    49ae:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49b0:	97ba                	add	a5,a5,a4
    49b2:	ff279ce3          	bne	a5,s2,49aa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49b6:	8626                	mv	a2,s1
    49b8:	85d6                	mv	a1,s5
    49ba:	00003517          	auipc	a0,0x3
    49be:	35650513          	add	a0,a0,854 # 7d10 <malloc+0x1d34>
    49c2:	00001097          	auipc	ra,0x1
    49c6:	562080e7          	jalr	1378(ra) # 5f24 <printf>
    exit(1);
    49ca:	4505                	li	a0,1
    49cc:	00001097          	auipc	ra,0x1
    49d0:	1f0080e7          	jalr	496(ra) # 5bbc <exit>
    exit(1);
    49d4:	4505                	li	a0,1
    49d6:	00001097          	auipc	ra,0x1
    49da:	1e6080e7          	jalr	486(ra) # 5bbc <exit>

00000000000049de <mem>:
{
    49de:	7139                	add	sp,sp,-64
    49e0:	fc06                	sd	ra,56(sp)
    49e2:	f822                	sd	s0,48(sp)
    49e4:	f426                	sd	s1,40(sp)
    49e6:	f04a                	sd	s2,32(sp)
    49e8:	ec4e                	sd	s3,24(sp)
    49ea:	0080                	add	s0,sp,64
    49ec:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49ee:	00001097          	auipc	ra,0x1
    49f2:	1c6080e7          	jalr	454(ra) # 5bb4 <fork>
    m1 = 0;
    49f6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49f8:	6909                	lui	s2,0x2
    49fa:	71190913          	add	s2,s2,1809 # 2711 <copyinstr3+0xff>
  if((pid = fork()) == 0){
    49fe:	c115                	beqz	a0,4a22 <mem+0x44>
    wait(&xstatus);
    4a00:	fcc40513          	add	a0,s0,-52
    4a04:	00001097          	auipc	ra,0x1
    4a08:	1c0080e7          	jalr	448(ra) # 5bc4 <wait>
    if(xstatus == -1){
    4a0c:	fcc42503          	lw	a0,-52(s0)
    4a10:	57fd                	li	a5,-1
    4a12:	06f50363          	beq	a0,a5,4a78 <mem+0x9a>
    exit(xstatus);
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	1a6080e7          	jalr	422(ra) # 5bbc <exit>
      *(char**)m2 = m1;
    4a1e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a20:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a22:	854a                	mv	a0,s2
    4a24:	00001097          	auipc	ra,0x1
    4a28:	5b8080e7          	jalr	1464(ra) # 5fdc <malloc>
    4a2c:	f96d                	bnez	a0,4a1e <mem+0x40>
    while(m1){
    4a2e:	c881                	beqz	s1,4a3e <mem+0x60>
      m2 = *(char**)m1;
    4a30:	8526                	mv	a0,s1
    4a32:	6084                	ld	s1,0(s1)
      free(m1);
    4a34:	00001097          	auipc	ra,0x1
    4a38:	526080e7          	jalr	1318(ra) # 5f5a <free>
    while(m1){
    4a3c:	f8f5                	bnez	s1,4a30 <mem+0x52>
    m1 = malloc(1024*20);
    4a3e:	6515                	lui	a0,0x5
    4a40:	00001097          	auipc	ra,0x1
    4a44:	59c080e7          	jalr	1436(ra) # 5fdc <malloc>
    if(m1 == 0){
    4a48:	c911                	beqz	a0,4a5c <mem+0x7e>
    free(m1);
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	510080e7          	jalr	1296(ra) # 5f5a <free>
    exit(0);
    4a52:	4501                	li	a0,0
    4a54:	00001097          	auipc	ra,0x1
    4a58:	168080e7          	jalr	360(ra) # 5bbc <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a5c:	85ce                	mv	a1,s3
    4a5e:	00003517          	auipc	a0,0x3
    4a62:	2e250513          	add	a0,a0,738 # 7d40 <malloc+0x1d64>
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	4be080e7          	jalr	1214(ra) # 5f24 <printf>
      exit(1);
    4a6e:	4505                	li	a0,1
    4a70:	00001097          	auipc	ra,0x1
    4a74:	14c080e7          	jalr	332(ra) # 5bbc <exit>
      exit(0);
    4a78:	4501                	li	a0,0
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	142080e7          	jalr	322(ra) # 5bbc <exit>

0000000000004a82 <sharedfd>:
{
    4a82:	7159                	add	sp,sp,-112
    4a84:	f486                	sd	ra,104(sp)
    4a86:	f0a2                	sd	s0,96(sp)
    4a88:	eca6                	sd	s1,88(sp)
    4a8a:	e8ca                	sd	s2,80(sp)
    4a8c:	e4ce                	sd	s3,72(sp)
    4a8e:	e0d2                	sd	s4,64(sp)
    4a90:	fc56                	sd	s5,56(sp)
    4a92:	f85a                	sd	s6,48(sp)
    4a94:	f45e                	sd	s7,40(sp)
    4a96:	1880                	add	s0,sp,112
    4a98:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a9a:	00003517          	auipc	a0,0x3
    4a9e:	2c650513          	add	a0,a0,710 # 7d60 <malloc+0x1d84>
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	16a080e7          	jalr	362(ra) # 5c0c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4aaa:	20200593          	li	a1,514
    4aae:	00003517          	auipc	a0,0x3
    4ab2:	2b250513          	add	a0,a0,690 # 7d60 <malloc+0x1d84>
    4ab6:	00001097          	auipc	ra,0x1
    4aba:	146080e7          	jalr	326(ra) # 5bfc <open>
  if(fd < 0){
    4abe:	04054a63          	bltz	a0,4b12 <sharedfd+0x90>
    4ac2:	892a                	mv	s2,a0
  pid = fork();
    4ac4:	00001097          	auipc	ra,0x1
    4ac8:	0f0080e7          	jalr	240(ra) # 5bb4 <fork>
    4acc:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4ace:	07000593          	li	a1,112
    4ad2:	e119                	bnez	a0,4ad8 <sharedfd+0x56>
    4ad4:	06300593          	li	a1,99
    4ad8:	4629                	li	a2,10
    4ada:	fa040513          	add	a0,s0,-96
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	ee4080e7          	jalr	-284(ra) # 59c2 <memset>
    4ae6:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4aea:	4629                	li	a2,10
    4aec:	fa040593          	add	a1,s0,-96
    4af0:	854a                	mv	a0,s2
    4af2:	00001097          	auipc	ra,0x1
    4af6:	0ea080e7          	jalr	234(ra) # 5bdc <write>
    4afa:	47a9                	li	a5,10
    4afc:	02f51963          	bne	a0,a5,4b2e <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4b00:	34fd                	addw	s1,s1,-1
    4b02:	f4e5                	bnez	s1,4aea <sharedfd+0x68>
  if(pid == 0) {
    4b04:	04099363          	bnez	s3,4b4a <sharedfd+0xc8>
    exit(0);
    4b08:	4501                	li	a0,0
    4b0a:	00001097          	auipc	ra,0x1
    4b0e:	0b2080e7          	jalr	178(ra) # 5bbc <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b12:	85d2                	mv	a1,s4
    4b14:	00003517          	auipc	a0,0x3
    4b18:	25c50513          	add	a0,a0,604 # 7d70 <malloc+0x1d94>
    4b1c:	00001097          	auipc	ra,0x1
    4b20:	408080e7          	jalr	1032(ra) # 5f24 <printf>
    exit(1);
    4b24:	4505                	li	a0,1
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	096080e7          	jalr	150(ra) # 5bbc <exit>
      printf("%s: write sharedfd failed\n", s);
    4b2e:	85d2                	mv	a1,s4
    4b30:	00003517          	auipc	a0,0x3
    4b34:	26850513          	add	a0,a0,616 # 7d98 <malloc+0x1dbc>
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	3ec080e7          	jalr	1004(ra) # 5f24 <printf>
      exit(1);
    4b40:	4505                	li	a0,1
    4b42:	00001097          	auipc	ra,0x1
    4b46:	07a080e7          	jalr	122(ra) # 5bbc <exit>
    wait(&xstatus);
    4b4a:	f9c40513          	add	a0,s0,-100
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	076080e7          	jalr	118(ra) # 5bc4 <wait>
    if(xstatus != 0)
    4b56:	f9c42983          	lw	s3,-100(s0)
    4b5a:	00098763          	beqz	s3,4b68 <sharedfd+0xe6>
      exit(xstatus);
    4b5e:	854e                	mv	a0,s3
    4b60:	00001097          	auipc	ra,0x1
    4b64:	05c080e7          	jalr	92(ra) # 5bbc <exit>
  close(fd);
    4b68:	854a                	mv	a0,s2
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	07a080e7          	jalr	122(ra) # 5be4 <close>
  fd = open("sharedfd", 0);
    4b72:	4581                	li	a1,0
    4b74:	00003517          	auipc	a0,0x3
    4b78:	1ec50513          	add	a0,a0,492 # 7d60 <malloc+0x1d84>
    4b7c:	00001097          	auipc	ra,0x1
    4b80:	080080e7          	jalr	128(ra) # 5bfc <open>
    4b84:	8baa                	mv	s7,a0
  nc = np = 0;
    4b86:	8ace                	mv	s5,s3
  if(fd < 0){
    4b88:	02054563          	bltz	a0,4bb2 <sharedfd+0x130>
    4b8c:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4b90:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b94:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b98:	4629                	li	a2,10
    4b9a:	fa040593          	add	a1,s0,-96
    4b9e:	855e                	mv	a0,s7
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	034080e7          	jalr	52(ra) # 5bd4 <read>
    4ba8:	02a05f63          	blez	a0,4be6 <sharedfd+0x164>
    4bac:	fa040793          	add	a5,s0,-96
    4bb0:	a01d                	j	4bd6 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bb2:	85d2                	mv	a1,s4
    4bb4:	00003517          	auipc	a0,0x3
    4bb8:	20450513          	add	a0,a0,516 # 7db8 <malloc+0x1ddc>
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	368080e7          	jalr	872(ra) # 5f24 <printf>
    exit(1);
    4bc4:	4505                	li	a0,1
    4bc6:	00001097          	auipc	ra,0x1
    4bca:	ff6080e7          	jalr	-10(ra) # 5bbc <exit>
        nc++;
    4bce:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bd0:	0785                	add	a5,a5,1
    4bd2:	fd2783e3          	beq	a5,s2,4b98 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bd6:	0007c703          	lbu	a4,0(a5)
    4bda:	fe970ae3          	beq	a4,s1,4bce <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bde:	ff6719e3          	bne	a4,s6,4bd0 <sharedfd+0x14e>
        np++;
    4be2:	2a85                	addw	s5,s5,1
    4be4:	b7f5                	j	4bd0 <sharedfd+0x14e>
  close(fd);
    4be6:	855e                	mv	a0,s7
    4be8:	00001097          	auipc	ra,0x1
    4bec:	ffc080e7          	jalr	-4(ra) # 5be4 <close>
  unlink("sharedfd");
    4bf0:	00003517          	auipc	a0,0x3
    4bf4:	17050513          	add	a0,a0,368 # 7d60 <malloc+0x1d84>
    4bf8:	00001097          	auipc	ra,0x1
    4bfc:	014080e7          	jalr	20(ra) # 5c0c <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c00:	6789                	lui	a5,0x2
    4c02:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xfe>
    4c06:	00f99763          	bne	s3,a5,4c14 <sharedfd+0x192>
    4c0a:	6789                	lui	a5,0x2
    4c0c:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xfe>
    4c10:	02fa8063          	beq	s5,a5,4c30 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c14:	85d2                	mv	a1,s4
    4c16:	00003517          	auipc	a0,0x3
    4c1a:	1ca50513          	add	a0,a0,458 # 7de0 <malloc+0x1e04>
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	306080e7          	jalr	774(ra) # 5f24 <printf>
    exit(1);
    4c26:	4505                	li	a0,1
    4c28:	00001097          	auipc	ra,0x1
    4c2c:	f94080e7          	jalr	-108(ra) # 5bbc <exit>
    exit(0);
    4c30:	4501                	li	a0,0
    4c32:	00001097          	auipc	ra,0x1
    4c36:	f8a080e7          	jalr	-118(ra) # 5bbc <exit>

0000000000004c3a <fourfiles>:
{
    4c3a:	7135                	add	sp,sp,-160
    4c3c:	ed06                	sd	ra,152(sp)
    4c3e:	e922                	sd	s0,144(sp)
    4c40:	e526                	sd	s1,136(sp)
    4c42:	e14a                	sd	s2,128(sp)
    4c44:	fcce                	sd	s3,120(sp)
    4c46:	f8d2                	sd	s4,112(sp)
    4c48:	f4d6                	sd	s5,104(sp)
    4c4a:	f0da                	sd	s6,96(sp)
    4c4c:	ecde                	sd	s7,88(sp)
    4c4e:	e8e2                	sd	s8,80(sp)
    4c50:	e4e6                	sd	s9,72(sp)
    4c52:	e0ea                	sd	s10,64(sp)
    4c54:	fc6e                	sd	s11,56(sp)
    4c56:	1100                	add	s0,sp,160
    4c58:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c5a:	00003797          	auipc	a5,0x3
    4c5e:	19e78793          	add	a5,a5,414 # 7df8 <malloc+0x1e1c>
    4c62:	f6f43823          	sd	a5,-144(s0)
    4c66:	00003797          	auipc	a5,0x3
    4c6a:	19a78793          	add	a5,a5,410 # 7e00 <malloc+0x1e24>
    4c6e:	f6f43c23          	sd	a5,-136(s0)
    4c72:	00003797          	auipc	a5,0x3
    4c76:	19678793          	add	a5,a5,406 # 7e08 <malloc+0x1e2c>
    4c7a:	f8f43023          	sd	a5,-128(s0)
    4c7e:	00003797          	auipc	a5,0x3
    4c82:	19278793          	add	a5,a5,402 # 7e10 <malloc+0x1e34>
    4c86:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c8a:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c8e:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c90:	4481                	li	s1,0
    4c92:	4a11                	li	s4,4
    fname = names[pi];
    4c94:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c98:	854e                	mv	a0,s3
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	f72080e7          	jalr	-142(ra) # 5c0c <unlink>
    pid = fork();
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	f12080e7          	jalr	-238(ra) # 5bb4 <fork>
    if(pid < 0){
    4caa:	04054063          	bltz	a0,4cea <fourfiles+0xb0>
    if(pid == 0){
    4cae:	cd21                	beqz	a0,4d06 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4cb0:	2485                	addw	s1,s1,1
    4cb2:	0921                	add	s2,s2,8
    4cb4:	ff4490e3          	bne	s1,s4,4c94 <fourfiles+0x5a>
    4cb8:	4491                	li	s1,4
    wait(&xstatus);
    4cba:	f6c40513          	add	a0,s0,-148
    4cbe:	00001097          	auipc	ra,0x1
    4cc2:	f06080e7          	jalr	-250(ra) # 5bc4 <wait>
    if(xstatus != 0)
    4cc6:	f6c42a83          	lw	s5,-148(s0)
    4cca:	0c0a9863          	bnez	s5,4d9a <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4cce:	34fd                	addw	s1,s1,-1
    4cd0:	f4ed                	bnez	s1,4cba <fourfiles+0x80>
    4cd2:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cd6:	00008a17          	auipc	s4,0x8
    4cda:	fa2a0a13          	add	s4,s4,-94 # cc78 <buf>
    if(total != N*SZ){
    4cde:	6d05                	lui	s10,0x1
    4ce0:	770d0d13          	add	s10,s10,1904 # 1770 <exectest+0x28>
  for(i = 0; i < NCHILD; i++){
    4ce4:	03400d93          	li	s11,52
    4ce8:	a22d                	j	4e12 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4cea:	85e6                	mv	a1,s9
    4cec:	00002517          	auipc	a0,0x2
    4cf0:	0ac50513          	add	a0,a0,172 # 6d98 <malloc+0xdbc>
    4cf4:	00001097          	auipc	ra,0x1
    4cf8:	230080e7          	jalr	560(ra) # 5f24 <printf>
      exit(1);
    4cfc:	4505                	li	a0,1
    4cfe:	00001097          	auipc	ra,0x1
    4d02:	ebe080e7          	jalr	-322(ra) # 5bbc <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d06:	20200593          	li	a1,514
    4d0a:	854e                	mv	a0,s3
    4d0c:	00001097          	auipc	ra,0x1
    4d10:	ef0080e7          	jalr	-272(ra) # 5bfc <open>
    4d14:	892a                	mv	s2,a0
      if(fd < 0){
    4d16:	04054763          	bltz	a0,4d64 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4d1a:	1f400613          	li	a2,500
    4d1e:	0304859b          	addw	a1,s1,48
    4d22:	00008517          	auipc	a0,0x8
    4d26:	f5650513          	add	a0,a0,-170 # cc78 <buf>
    4d2a:	00001097          	auipc	ra,0x1
    4d2e:	c98080e7          	jalr	-872(ra) # 59c2 <memset>
    4d32:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d34:	00008997          	auipc	s3,0x8
    4d38:	f4498993          	add	s3,s3,-188 # cc78 <buf>
    4d3c:	1f400613          	li	a2,500
    4d40:	85ce                	mv	a1,s3
    4d42:	854a                	mv	a0,s2
    4d44:	00001097          	auipc	ra,0x1
    4d48:	e98080e7          	jalr	-360(ra) # 5bdc <write>
    4d4c:	85aa                	mv	a1,a0
    4d4e:	1f400793          	li	a5,500
    4d52:	02f51763          	bne	a0,a5,4d80 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4d56:	34fd                	addw	s1,s1,-1
    4d58:	f0f5                	bnez	s1,4d3c <fourfiles+0x102>
      exit(0);
    4d5a:	4501                	li	a0,0
    4d5c:	00001097          	auipc	ra,0x1
    4d60:	e60080e7          	jalr	-416(ra) # 5bbc <exit>
        printf("create failed\n", s);
    4d64:	85e6                	mv	a1,s9
    4d66:	00003517          	auipc	a0,0x3
    4d6a:	0b250513          	add	a0,a0,178 # 7e18 <malloc+0x1e3c>
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	1b6080e7          	jalr	438(ra) # 5f24 <printf>
        exit(1);
    4d76:	4505                	li	a0,1
    4d78:	00001097          	auipc	ra,0x1
    4d7c:	e44080e7          	jalr	-444(ra) # 5bbc <exit>
          printf("write failed %d\n", n);
    4d80:	00003517          	auipc	a0,0x3
    4d84:	0a850513          	add	a0,a0,168 # 7e28 <malloc+0x1e4c>
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	19c080e7          	jalr	412(ra) # 5f24 <printf>
          exit(1);
    4d90:	4505                	li	a0,1
    4d92:	00001097          	auipc	ra,0x1
    4d96:	e2a080e7          	jalr	-470(ra) # 5bbc <exit>
      exit(xstatus);
    4d9a:	8556                	mv	a0,s5
    4d9c:	00001097          	auipc	ra,0x1
    4da0:	e20080e7          	jalr	-480(ra) # 5bbc <exit>
          printf("wrong char\n", s);
    4da4:	85e6                	mv	a1,s9
    4da6:	00003517          	auipc	a0,0x3
    4daa:	09a50513          	add	a0,a0,154 # 7e40 <malloc+0x1e64>
    4dae:	00001097          	auipc	ra,0x1
    4db2:	176080e7          	jalr	374(ra) # 5f24 <printf>
          exit(1);
    4db6:	4505                	li	a0,1
    4db8:	00001097          	auipc	ra,0x1
    4dbc:	e04080e7          	jalr	-508(ra) # 5bbc <exit>
      total += n;
    4dc0:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dc4:	660d                	lui	a2,0x3
    4dc6:	85d2                	mv	a1,s4
    4dc8:	854e                	mv	a0,s3
    4dca:	00001097          	auipc	ra,0x1
    4dce:	e0a080e7          	jalr	-502(ra) # 5bd4 <read>
    4dd2:	02a05063          	blez	a0,4df2 <fourfiles+0x1b8>
    4dd6:	00008797          	auipc	a5,0x8
    4dda:	ea278793          	add	a5,a5,-350 # cc78 <buf>
    4dde:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4de2:	0007c703          	lbu	a4,0(a5)
    4de6:	fa971fe3          	bne	a4,s1,4da4 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4dea:	0785                	add	a5,a5,1
    4dec:	fed79be3          	bne	a5,a3,4de2 <fourfiles+0x1a8>
    4df0:	bfc1                	j	4dc0 <fourfiles+0x186>
    close(fd);
    4df2:	854e                	mv	a0,s3
    4df4:	00001097          	auipc	ra,0x1
    4df8:	df0080e7          	jalr	-528(ra) # 5be4 <close>
    if(total != N*SZ){
    4dfc:	03a91863          	bne	s2,s10,4e2c <fourfiles+0x1f2>
    unlink(fname);
    4e00:	8562                	mv	a0,s8
    4e02:	00001097          	auipc	ra,0x1
    4e06:	e0a080e7          	jalr	-502(ra) # 5c0c <unlink>
  for(i = 0; i < NCHILD; i++){
    4e0a:	0ba1                	add	s7,s7,8
    4e0c:	2b05                	addw	s6,s6,1
    4e0e:	03bb0d63          	beq	s6,s11,4e48 <fourfiles+0x20e>
    fname = names[i];
    4e12:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e16:	4581                	li	a1,0
    4e18:	8562                	mv	a0,s8
    4e1a:	00001097          	auipc	ra,0x1
    4e1e:	de2080e7          	jalr	-542(ra) # 5bfc <open>
    4e22:	89aa                	mv	s3,a0
    total = 0;
    4e24:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4e26:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e2a:	bf69                	j	4dc4 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e2c:	85ca                	mv	a1,s2
    4e2e:	00003517          	auipc	a0,0x3
    4e32:	02250513          	add	a0,a0,34 # 7e50 <malloc+0x1e74>
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	0ee080e7          	jalr	238(ra) # 5f24 <printf>
      exit(1);
    4e3e:	4505                	li	a0,1
    4e40:	00001097          	auipc	ra,0x1
    4e44:	d7c080e7          	jalr	-644(ra) # 5bbc <exit>
}
    4e48:	60ea                	ld	ra,152(sp)
    4e4a:	644a                	ld	s0,144(sp)
    4e4c:	64aa                	ld	s1,136(sp)
    4e4e:	690a                	ld	s2,128(sp)
    4e50:	79e6                	ld	s3,120(sp)
    4e52:	7a46                	ld	s4,112(sp)
    4e54:	7aa6                	ld	s5,104(sp)
    4e56:	7b06                	ld	s6,96(sp)
    4e58:	6be6                	ld	s7,88(sp)
    4e5a:	6c46                	ld	s8,80(sp)
    4e5c:	6ca6                	ld	s9,72(sp)
    4e5e:	6d06                	ld	s10,64(sp)
    4e60:	7de2                	ld	s11,56(sp)
    4e62:	610d                	add	sp,sp,160
    4e64:	8082                	ret

0000000000004e66 <concreate>:
{
    4e66:	7135                	add	sp,sp,-160
    4e68:	ed06                	sd	ra,152(sp)
    4e6a:	e922                	sd	s0,144(sp)
    4e6c:	e526                	sd	s1,136(sp)
    4e6e:	e14a                	sd	s2,128(sp)
    4e70:	fcce                	sd	s3,120(sp)
    4e72:	f8d2                	sd	s4,112(sp)
    4e74:	f4d6                	sd	s5,104(sp)
    4e76:	f0da                	sd	s6,96(sp)
    4e78:	ecde                	sd	s7,88(sp)
    4e7a:	1100                	add	s0,sp,160
    4e7c:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e7e:	04300793          	li	a5,67
    4e82:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e86:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e8a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e8c:	4b0d                	li	s6,3
    4e8e:	4a85                	li	s5,1
      link("C0", file);
    4e90:	00003b97          	auipc	s7,0x3
    4e94:	fd8b8b93          	add	s7,s7,-40 # 7e68 <malloc+0x1e8c>
  for(i = 0; i < N; i++){
    4e98:	02800a13          	li	s4,40
    4e9c:	acc9                	j	516e <concreate+0x308>
      link("C0", file);
    4e9e:	fa840593          	add	a1,s0,-88
    4ea2:	855e                	mv	a0,s7
    4ea4:	00001097          	auipc	ra,0x1
    4ea8:	d78080e7          	jalr	-648(ra) # 5c1c <link>
    if(pid == 0) {
    4eac:	a465                	j	5154 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4eae:	4795                	li	a5,5
    4eb0:	02f9693b          	remw	s2,s2,a5
    4eb4:	4785                	li	a5,1
    4eb6:	02f90b63          	beq	s2,a5,4eec <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eba:	20200593          	li	a1,514
    4ebe:	fa840513          	add	a0,s0,-88
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	d3a080e7          	jalr	-710(ra) # 5bfc <open>
      if(fd < 0){
    4eca:	26055c63          	bgez	a0,5142 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4ece:	fa840593          	add	a1,s0,-88
    4ed2:	00003517          	auipc	a0,0x3
    4ed6:	f9e50513          	add	a0,a0,-98 # 7e70 <malloc+0x1e94>
    4eda:	00001097          	auipc	ra,0x1
    4ede:	04a080e7          	jalr	74(ra) # 5f24 <printf>
        exit(1);
    4ee2:	4505                	li	a0,1
    4ee4:	00001097          	auipc	ra,0x1
    4ee8:	cd8080e7          	jalr	-808(ra) # 5bbc <exit>
      link("C0", file);
    4eec:	fa840593          	add	a1,s0,-88
    4ef0:	00003517          	auipc	a0,0x3
    4ef4:	f7850513          	add	a0,a0,-136 # 7e68 <malloc+0x1e8c>
    4ef8:	00001097          	auipc	ra,0x1
    4efc:	d24080e7          	jalr	-732(ra) # 5c1c <link>
      exit(0);
    4f00:	4501                	li	a0,0
    4f02:	00001097          	auipc	ra,0x1
    4f06:	cba080e7          	jalr	-838(ra) # 5bbc <exit>
        exit(1);
    4f0a:	4505                	li	a0,1
    4f0c:	00001097          	auipc	ra,0x1
    4f10:	cb0080e7          	jalr	-848(ra) # 5bbc <exit>
  memset(fa, 0, sizeof(fa));
    4f14:	02800613          	li	a2,40
    4f18:	4581                	li	a1,0
    4f1a:	f8040513          	add	a0,s0,-128
    4f1e:	00001097          	auipc	ra,0x1
    4f22:	aa4080e7          	jalr	-1372(ra) # 59c2 <memset>
  fd = open(".", 0);
    4f26:	4581                	li	a1,0
    4f28:	00002517          	auipc	a0,0x2
    4f2c:	8c850513          	add	a0,a0,-1848 # 67f0 <malloc+0x814>
    4f30:	00001097          	auipc	ra,0x1
    4f34:	ccc080e7          	jalr	-820(ra) # 5bfc <open>
    4f38:	892a                	mv	s2,a0
  n = 0;
    4f3a:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f3c:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f40:	02700b13          	li	s6,39
      fa[i] = 1;
    4f44:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f46:	4641                	li	a2,16
    4f48:	f7040593          	add	a1,s0,-144
    4f4c:	854a                	mv	a0,s2
    4f4e:	00001097          	auipc	ra,0x1
    4f52:	c86080e7          	jalr	-890(ra) # 5bd4 <read>
    4f56:	08a05263          	blez	a0,4fda <concreate+0x174>
    if(de.inum == 0)
    4f5a:	f7045783          	lhu	a5,-144(s0)
    4f5e:	d7e5                	beqz	a5,4f46 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f60:	f7244783          	lbu	a5,-142(s0)
    4f64:	ff4791e3          	bne	a5,s4,4f46 <concreate+0xe0>
    4f68:	f7444783          	lbu	a5,-140(s0)
    4f6c:	ffe9                	bnez	a5,4f46 <concreate+0xe0>
      i = de.name[1] - '0';
    4f6e:	f7344783          	lbu	a5,-141(s0)
    4f72:	fd07879b          	addw	a5,a5,-48
    4f76:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f7a:	02eb6063          	bltu	s6,a4,4f9a <concreate+0x134>
      if(fa[i]){
    4f7e:	fb070793          	add	a5,a4,-80 # fb0 <linktest+0xb4>
    4f82:	97a2                	add	a5,a5,s0
    4f84:	fd07c783          	lbu	a5,-48(a5)
    4f88:	eb8d                	bnez	a5,4fba <concreate+0x154>
      fa[i] = 1;
    4f8a:	fb070793          	add	a5,a4,-80
    4f8e:	00878733          	add	a4,a5,s0
    4f92:	fd770823          	sb	s7,-48(a4)
      n++;
    4f96:	2a85                	addw	s5,s5,1
    4f98:	b77d                	j	4f46 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f9a:	f7240613          	add	a2,s0,-142
    4f9e:	85ce                	mv	a1,s3
    4fa0:	00003517          	auipc	a0,0x3
    4fa4:	ef050513          	add	a0,a0,-272 # 7e90 <malloc+0x1eb4>
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	f7c080e7          	jalr	-132(ra) # 5f24 <printf>
        exit(1);
    4fb0:	4505                	li	a0,1
    4fb2:	00001097          	auipc	ra,0x1
    4fb6:	c0a080e7          	jalr	-1014(ra) # 5bbc <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fba:	f7240613          	add	a2,s0,-142
    4fbe:	85ce                	mv	a1,s3
    4fc0:	00003517          	auipc	a0,0x3
    4fc4:	ef050513          	add	a0,a0,-272 # 7eb0 <malloc+0x1ed4>
    4fc8:	00001097          	auipc	ra,0x1
    4fcc:	f5c080e7          	jalr	-164(ra) # 5f24 <printf>
        exit(1);
    4fd0:	4505                	li	a0,1
    4fd2:	00001097          	auipc	ra,0x1
    4fd6:	bea080e7          	jalr	-1046(ra) # 5bbc <exit>
  close(fd);
    4fda:	854a                	mv	a0,s2
    4fdc:	00001097          	auipc	ra,0x1
    4fe0:	c08080e7          	jalr	-1016(ra) # 5be4 <close>
  if(n != N){
    4fe4:	02800793          	li	a5,40
    4fe8:	00fa9763          	bne	s5,a5,4ff6 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4fec:	4a8d                	li	s5,3
    4fee:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4ff0:	02800a13          	li	s4,40
    4ff4:	a8c9                	j	50c6 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ff6:	85ce                	mv	a1,s3
    4ff8:	00003517          	auipc	a0,0x3
    4ffc:	ee050513          	add	a0,a0,-288 # 7ed8 <malloc+0x1efc>
    5000:	00001097          	auipc	ra,0x1
    5004:	f24080e7          	jalr	-220(ra) # 5f24 <printf>
    exit(1);
    5008:	4505                	li	a0,1
    500a:	00001097          	auipc	ra,0x1
    500e:	bb2080e7          	jalr	-1102(ra) # 5bbc <exit>
      printf("%s: fork failed\n", s);
    5012:	85ce                	mv	a1,s3
    5014:	00002517          	auipc	a0,0x2
    5018:	97c50513          	add	a0,a0,-1668 # 6990 <malloc+0x9b4>
    501c:	00001097          	auipc	ra,0x1
    5020:	f08080e7          	jalr	-248(ra) # 5f24 <printf>
      exit(1);
    5024:	4505                	li	a0,1
    5026:	00001097          	auipc	ra,0x1
    502a:	b96080e7          	jalr	-1130(ra) # 5bbc <exit>
      close(open(file, 0));
    502e:	4581                	li	a1,0
    5030:	fa840513          	add	a0,s0,-88
    5034:	00001097          	auipc	ra,0x1
    5038:	bc8080e7          	jalr	-1080(ra) # 5bfc <open>
    503c:	00001097          	auipc	ra,0x1
    5040:	ba8080e7          	jalr	-1112(ra) # 5be4 <close>
      close(open(file, 0));
    5044:	4581                	li	a1,0
    5046:	fa840513          	add	a0,s0,-88
    504a:	00001097          	auipc	ra,0x1
    504e:	bb2080e7          	jalr	-1102(ra) # 5bfc <open>
    5052:	00001097          	auipc	ra,0x1
    5056:	b92080e7          	jalr	-1134(ra) # 5be4 <close>
      close(open(file, 0));
    505a:	4581                	li	a1,0
    505c:	fa840513          	add	a0,s0,-88
    5060:	00001097          	auipc	ra,0x1
    5064:	b9c080e7          	jalr	-1124(ra) # 5bfc <open>
    5068:	00001097          	auipc	ra,0x1
    506c:	b7c080e7          	jalr	-1156(ra) # 5be4 <close>
      close(open(file, 0));
    5070:	4581                	li	a1,0
    5072:	fa840513          	add	a0,s0,-88
    5076:	00001097          	auipc	ra,0x1
    507a:	b86080e7          	jalr	-1146(ra) # 5bfc <open>
    507e:	00001097          	auipc	ra,0x1
    5082:	b66080e7          	jalr	-1178(ra) # 5be4 <close>
      close(open(file, 0));
    5086:	4581                	li	a1,0
    5088:	fa840513          	add	a0,s0,-88
    508c:	00001097          	auipc	ra,0x1
    5090:	b70080e7          	jalr	-1168(ra) # 5bfc <open>
    5094:	00001097          	auipc	ra,0x1
    5098:	b50080e7          	jalr	-1200(ra) # 5be4 <close>
      close(open(file, 0));
    509c:	4581                	li	a1,0
    509e:	fa840513          	add	a0,s0,-88
    50a2:	00001097          	auipc	ra,0x1
    50a6:	b5a080e7          	jalr	-1190(ra) # 5bfc <open>
    50aa:	00001097          	auipc	ra,0x1
    50ae:	b3a080e7          	jalr	-1222(ra) # 5be4 <close>
    if(pid == 0)
    50b2:	08090363          	beqz	s2,5138 <concreate+0x2d2>
      wait(0);
    50b6:	4501                	li	a0,0
    50b8:	00001097          	auipc	ra,0x1
    50bc:	b0c080e7          	jalr	-1268(ra) # 5bc4 <wait>
  for(i = 0; i < N; i++){
    50c0:	2485                	addw	s1,s1,1
    50c2:	0f448563          	beq	s1,s4,51ac <concreate+0x346>
    file[1] = '0' + i;
    50c6:	0304879b          	addw	a5,s1,48
    50ca:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50ce:	00001097          	auipc	ra,0x1
    50d2:	ae6080e7          	jalr	-1306(ra) # 5bb4 <fork>
    50d6:	892a                	mv	s2,a0
    if(pid < 0){
    50d8:	f2054de3          	bltz	a0,5012 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    50dc:	0354e73b          	remw	a4,s1,s5
    50e0:	00a767b3          	or	a5,a4,a0
    50e4:	2781                	sext.w	a5,a5
    50e6:	d7a1                	beqz	a5,502e <concreate+0x1c8>
    50e8:	01671363          	bne	a4,s6,50ee <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    50ec:	f129                	bnez	a0,502e <concreate+0x1c8>
      unlink(file);
    50ee:	fa840513          	add	a0,s0,-88
    50f2:	00001097          	auipc	ra,0x1
    50f6:	b1a080e7          	jalr	-1254(ra) # 5c0c <unlink>
      unlink(file);
    50fa:	fa840513          	add	a0,s0,-88
    50fe:	00001097          	auipc	ra,0x1
    5102:	b0e080e7          	jalr	-1266(ra) # 5c0c <unlink>
      unlink(file);
    5106:	fa840513          	add	a0,s0,-88
    510a:	00001097          	auipc	ra,0x1
    510e:	b02080e7          	jalr	-1278(ra) # 5c0c <unlink>
      unlink(file);
    5112:	fa840513          	add	a0,s0,-88
    5116:	00001097          	auipc	ra,0x1
    511a:	af6080e7          	jalr	-1290(ra) # 5c0c <unlink>
      unlink(file);
    511e:	fa840513          	add	a0,s0,-88
    5122:	00001097          	auipc	ra,0x1
    5126:	aea080e7          	jalr	-1302(ra) # 5c0c <unlink>
      unlink(file);
    512a:	fa840513          	add	a0,s0,-88
    512e:	00001097          	auipc	ra,0x1
    5132:	ade080e7          	jalr	-1314(ra) # 5c0c <unlink>
    5136:	bfb5                	j	50b2 <concreate+0x24c>
      exit(0);
    5138:	4501                	li	a0,0
    513a:	00001097          	auipc	ra,0x1
    513e:	a82080e7          	jalr	-1406(ra) # 5bbc <exit>
      close(fd);
    5142:	00001097          	auipc	ra,0x1
    5146:	aa2080e7          	jalr	-1374(ra) # 5be4 <close>
    if(pid == 0) {
    514a:	bb5d                	j	4f00 <concreate+0x9a>
      close(fd);
    514c:	00001097          	auipc	ra,0x1
    5150:	a98080e7          	jalr	-1384(ra) # 5be4 <close>
      wait(&xstatus);
    5154:	f6c40513          	add	a0,s0,-148
    5158:	00001097          	auipc	ra,0x1
    515c:	a6c080e7          	jalr	-1428(ra) # 5bc4 <wait>
      if(xstatus != 0)
    5160:	f6c42483          	lw	s1,-148(s0)
    5164:	da0493e3          	bnez	s1,4f0a <concreate+0xa4>
  for(i = 0; i < N; i++){
    5168:	2905                	addw	s2,s2,1
    516a:	db4905e3          	beq	s2,s4,4f14 <concreate+0xae>
    file[1] = '0' + i;
    516e:	0309079b          	addw	a5,s2,48
    5172:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5176:	fa840513          	add	a0,s0,-88
    517a:	00001097          	auipc	ra,0x1
    517e:	a92080e7          	jalr	-1390(ra) # 5c0c <unlink>
    pid = fork();
    5182:	00001097          	auipc	ra,0x1
    5186:	a32080e7          	jalr	-1486(ra) # 5bb4 <fork>
    if(pid && (i % 3) == 1){
    518a:	d20502e3          	beqz	a0,4eae <concreate+0x48>
    518e:	036967bb          	remw	a5,s2,s6
    5192:	d15786e3          	beq	a5,s5,4e9e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5196:	20200593          	li	a1,514
    519a:	fa840513          	add	a0,s0,-88
    519e:	00001097          	auipc	ra,0x1
    51a2:	a5e080e7          	jalr	-1442(ra) # 5bfc <open>
      if(fd < 0){
    51a6:	fa0553e3          	bgez	a0,514c <concreate+0x2e6>
    51aa:	b315                	j	4ece <concreate+0x68>
}
    51ac:	60ea                	ld	ra,152(sp)
    51ae:	644a                	ld	s0,144(sp)
    51b0:	64aa                	ld	s1,136(sp)
    51b2:	690a                	ld	s2,128(sp)
    51b4:	79e6                	ld	s3,120(sp)
    51b6:	7a46                	ld	s4,112(sp)
    51b8:	7aa6                	ld	s5,104(sp)
    51ba:	7b06                	ld	s6,96(sp)
    51bc:	6be6                	ld	s7,88(sp)
    51be:	610d                	add	sp,sp,160
    51c0:	8082                	ret

00000000000051c2 <bigfile>:
{
    51c2:	7139                	add	sp,sp,-64
    51c4:	fc06                	sd	ra,56(sp)
    51c6:	f822                	sd	s0,48(sp)
    51c8:	f426                	sd	s1,40(sp)
    51ca:	f04a                	sd	s2,32(sp)
    51cc:	ec4e                	sd	s3,24(sp)
    51ce:	e852                	sd	s4,16(sp)
    51d0:	e456                	sd	s5,8(sp)
    51d2:	0080                	add	s0,sp,64
    51d4:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51d6:	00003517          	auipc	a0,0x3
    51da:	d3a50513          	add	a0,a0,-710 # 7f10 <malloc+0x1f34>
    51de:	00001097          	auipc	ra,0x1
    51e2:	a2e080e7          	jalr	-1490(ra) # 5c0c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51e6:	20200593          	li	a1,514
    51ea:	00003517          	auipc	a0,0x3
    51ee:	d2650513          	add	a0,a0,-730 # 7f10 <malloc+0x1f34>
    51f2:	00001097          	auipc	ra,0x1
    51f6:	a0a080e7          	jalr	-1526(ra) # 5bfc <open>
    51fa:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51fc:	4481                	li	s1,0
    memset(buf, i, SZ);
    51fe:	00008917          	auipc	s2,0x8
    5202:	a7a90913          	add	s2,s2,-1414 # cc78 <buf>
  for(i = 0; i < N; i++){
    5206:	4a51                	li	s4,20
  if(fd < 0){
    5208:	0a054063          	bltz	a0,52a8 <bigfile+0xe6>
    memset(buf, i, SZ);
    520c:	25800613          	li	a2,600
    5210:	85a6                	mv	a1,s1
    5212:	854a                	mv	a0,s2
    5214:	00000097          	auipc	ra,0x0
    5218:	7ae080e7          	jalr	1966(ra) # 59c2 <memset>
    if(write(fd, buf, SZ) != SZ){
    521c:	25800613          	li	a2,600
    5220:	85ca                	mv	a1,s2
    5222:	854e                	mv	a0,s3
    5224:	00001097          	auipc	ra,0x1
    5228:	9b8080e7          	jalr	-1608(ra) # 5bdc <write>
    522c:	25800793          	li	a5,600
    5230:	08f51a63          	bne	a0,a5,52c4 <bigfile+0x102>
  for(i = 0; i < N; i++){
    5234:	2485                	addw	s1,s1,1
    5236:	fd449be3          	bne	s1,s4,520c <bigfile+0x4a>
  close(fd);
    523a:	854e                	mv	a0,s3
    523c:	00001097          	auipc	ra,0x1
    5240:	9a8080e7          	jalr	-1624(ra) # 5be4 <close>
  fd = open("bigfile.dat", 0);
    5244:	4581                	li	a1,0
    5246:	00003517          	auipc	a0,0x3
    524a:	cca50513          	add	a0,a0,-822 # 7f10 <malloc+0x1f34>
    524e:	00001097          	auipc	ra,0x1
    5252:	9ae080e7          	jalr	-1618(ra) # 5bfc <open>
    5256:	8a2a                	mv	s4,a0
  total = 0;
    5258:	4981                	li	s3,0
  for(i = 0; ; i++){
    525a:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    525c:	00008917          	auipc	s2,0x8
    5260:	a1c90913          	add	s2,s2,-1508 # cc78 <buf>
  if(fd < 0){
    5264:	06054e63          	bltz	a0,52e0 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5268:	12c00613          	li	a2,300
    526c:	85ca                	mv	a1,s2
    526e:	8552                	mv	a0,s4
    5270:	00001097          	auipc	ra,0x1
    5274:	964080e7          	jalr	-1692(ra) # 5bd4 <read>
    if(cc < 0){
    5278:	08054263          	bltz	a0,52fc <bigfile+0x13a>
    if(cc == 0)
    527c:	c971                	beqz	a0,5350 <bigfile+0x18e>
    if(cc != SZ/2){
    527e:	12c00793          	li	a5,300
    5282:	08f51b63          	bne	a0,a5,5318 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5286:	01f4d79b          	srlw	a5,s1,0x1f
    528a:	9fa5                	addw	a5,a5,s1
    528c:	4017d79b          	sraw	a5,a5,0x1
    5290:	00094703          	lbu	a4,0(s2)
    5294:	0af71063          	bne	a4,a5,5334 <bigfile+0x172>
    5298:	12b94703          	lbu	a4,299(s2)
    529c:	08f71c63          	bne	a4,a5,5334 <bigfile+0x172>
    total += cc;
    52a0:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    52a4:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52a6:	b7c9                	j	5268 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52a8:	85d6                	mv	a1,s5
    52aa:	00003517          	auipc	a0,0x3
    52ae:	c7650513          	add	a0,a0,-906 # 7f20 <malloc+0x1f44>
    52b2:	00001097          	auipc	ra,0x1
    52b6:	c72080e7          	jalr	-910(ra) # 5f24 <printf>
    exit(1);
    52ba:	4505                	li	a0,1
    52bc:	00001097          	auipc	ra,0x1
    52c0:	900080e7          	jalr	-1792(ra) # 5bbc <exit>
      printf("%s: write bigfile failed\n", s);
    52c4:	85d6                	mv	a1,s5
    52c6:	00003517          	auipc	a0,0x3
    52ca:	c7a50513          	add	a0,a0,-902 # 7f40 <malloc+0x1f64>
    52ce:	00001097          	auipc	ra,0x1
    52d2:	c56080e7          	jalr	-938(ra) # 5f24 <printf>
      exit(1);
    52d6:	4505                	li	a0,1
    52d8:	00001097          	auipc	ra,0x1
    52dc:	8e4080e7          	jalr	-1820(ra) # 5bbc <exit>
    printf("%s: cannot open bigfile\n", s);
    52e0:	85d6                	mv	a1,s5
    52e2:	00003517          	auipc	a0,0x3
    52e6:	c7e50513          	add	a0,a0,-898 # 7f60 <malloc+0x1f84>
    52ea:	00001097          	auipc	ra,0x1
    52ee:	c3a080e7          	jalr	-966(ra) # 5f24 <printf>
    exit(1);
    52f2:	4505                	li	a0,1
    52f4:	00001097          	auipc	ra,0x1
    52f8:	8c8080e7          	jalr	-1848(ra) # 5bbc <exit>
      printf("%s: read bigfile failed\n", s);
    52fc:	85d6                	mv	a1,s5
    52fe:	00003517          	auipc	a0,0x3
    5302:	c8250513          	add	a0,a0,-894 # 7f80 <malloc+0x1fa4>
    5306:	00001097          	auipc	ra,0x1
    530a:	c1e080e7          	jalr	-994(ra) # 5f24 <printf>
      exit(1);
    530e:	4505                	li	a0,1
    5310:	00001097          	auipc	ra,0x1
    5314:	8ac080e7          	jalr	-1876(ra) # 5bbc <exit>
      printf("%s: short read bigfile\n", s);
    5318:	85d6                	mv	a1,s5
    531a:	00003517          	auipc	a0,0x3
    531e:	c8650513          	add	a0,a0,-890 # 7fa0 <malloc+0x1fc4>
    5322:	00001097          	auipc	ra,0x1
    5326:	c02080e7          	jalr	-1022(ra) # 5f24 <printf>
      exit(1);
    532a:	4505                	li	a0,1
    532c:	00001097          	auipc	ra,0x1
    5330:	890080e7          	jalr	-1904(ra) # 5bbc <exit>
      printf("%s: read bigfile wrong data\n", s);
    5334:	85d6                	mv	a1,s5
    5336:	00003517          	auipc	a0,0x3
    533a:	c8250513          	add	a0,a0,-894 # 7fb8 <malloc+0x1fdc>
    533e:	00001097          	auipc	ra,0x1
    5342:	be6080e7          	jalr	-1050(ra) # 5f24 <printf>
      exit(1);
    5346:	4505                	li	a0,1
    5348:	00001097          	auipc	ra,0x1
    534c:	874080e7          	jalr	-1932(ra) # 5bbc <exit>
  close(fd);
    5350:	8552                	mv	a0,s4
    5352:	00001097          	auipc	ra,0x1
    5356:	892080e7          	jalr	-1902(ra) # 5be4 <close>
  if(total != N*SZ){
    535a:	678d                	lui	a5,0x3
    535c:	ee078793          	add	a5,a5,-288 # 2ee0 <sbrklast+0x86>
    5360:	02f99363          	bne	s3,a5,5386 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5364:	00003517          	auipc	a0,0x3
    5368:	bac50513          	add	a0,a0,-1108 # 7f10 <malloc+0x1f34>
    536c:	00001097          	auipc	ra,0x1
    5370:	8a0080e7          	jalr	-1888(ra) # 5c0c <unlink>
}
    5374:	70e2                	ld	ra,56(sp)
    5376:	7442                	ld	s0,48(sp)
    5378:	74a2                	ld	s1,40(sp)
    537a:	7902                	ld	s2,32(sp)
    537c:	69e2                	ld	s3,24(sp)
    537e:	6a42                	ld	s4,16(sp)
    5380:	6aa2                	ld	s5,8(sp)
    5382:	6121                	add	sp,sp,64
    5384:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5386:	85d6                	mv	a1,s5
    5388:	00003517          	auipc	a0,0x3
    538c:	c5050513          	add	a0,a0,-944 # 7fd8 <malloc+0x1ffc>
    5390:	00001097          	auipc	ra,0x1
    5394:	b94080e7          	jalr	-1132(ra) # 5f24 <printf>
    exit(1);
    5398:	4505                	li	a0,1
    539a:	00001097          	auipc	ra,0x1
    539e:	822080e7          	jalr	-2014(ra) # 5bbc <exit>

00000000000053a2 <fsfull>:
{
    53a2:	7135                	add	sp,sp,-160
    53a4:	ed06                	sd	ra,152(sp)
    53a6:	e922                	sd	s0,144(sp)
    53a8:	e526                	sd	s1,136(sp)
    53aa:	e14a                	sd	s2,128(sp)
    53ac:	fcce                	sd	s3,120(sp)
    53ae:	f8d2                	sd	s4,112(sp)
    53b0:	f4d6                	sd	s5,104(sp)
    53b2:	f0da                	sd	s6,96(sp)
    53b4:	ecde                	sd	s7,88(sp)
    53b6:	e8e2                	sd	s8,80(sp)
    53b8:	e4e6                	sd	s9,72(sp)
    53ba:	e0ea                	sd	s10,64(sp)
    53bc:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    53be:	00003517          	auipc	a0,0x3
    53c2:	c3a50513          	add	a0,a0,-966 # 7ff8 <malloc+0x201c>
    53c6:	00001097          	auipc	ra,0x1
    53ca:	b5e080e7          	jalr	-1186(ra) # 5f24 <printf>
  for(nfiles = 0; ; nfiles++){
    53ce:	4481                	li	s1,0
    name[0] = 'f';
    53d0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53d4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53d8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53dc:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53de:	00003c97          	auipc	s9,0x3
    53e2:	c2ac8c93          	add	s9,s9,-982 # 8008 <malloc+0x202c>
    name[0] = 'f';
    53e6:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    53ea:	0384c7bb          	divw	a5,s1,s8
    53ee:	0307879b          	addw	a5,a5,48
    53f2:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53f6:	0384e7bb          	remw	a5,s1,s8
    53fa:	0377c7bb          	divw	a5,a5,s7
    53fe:	0307879b          	addw	a5,a5,48
    5402:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5406:	0374e7bb          	remw	a5,s1,s7
    540a:	0367c7bb          	divw	a5,a5,s6
    540e:	0307879b          	addw	a5,a5,48
    5412:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5416:	0364e7bb          	remw	a5,s1,s6
    541a:	0307879b          	addw	a5,a5,48
    541e:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5422:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    5426:	f6040593          	add	a1,s0,-160
    542a:	8566                	mv	a0,s9
    542c:	00001097          	auipc	ra,0x1
    5430:	af8080e7          	jalr	-1288(ra) # 5f24 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5434:	20200593          	li	a1,514
    5438:	f6040513          	add	a0,s0,-160
    543c:	00000097          	auipc	ra,0x0
    5440:	7c0080e7          	jalr	1984(ra) # 5bfc <open>
    5444:	892a                	mv	s2,a0
    if(fd < 0){
    5446:	0a055563          	bgez	a0,54f0 <fsfull+0x14e>
      printf("open %s failed\n", name);
    544a:	f6040593          	add	a1,s0,-160
    544e:	00003517          	auipc	a0,0x3
    5452:	bca50513          	add	a0,a0,-1078 # 8018 <malloc+0x203c>
    5456:	00001097          	auipc	ra,0x1
    545a:	ace080e7          	jalr	-1330(ra) # 5f24 <printf>
  while(nfiles >= 0){
    545e:	0604c363          	bltz	s1,54c4 <fsfull+0x122>
    name[0] = 'f';
    5462:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5466:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    546a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    546e:	4929                	li	s2,10
  while(nfiles >= 0){
    5470:	5afd                	li	s5,-1
    name[0] = 'f';
    5472:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5476:	0344c7bb          	divw	a5,s1,s4
    547a:	0307879b          	addw	a5,a5,48
    547e:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5482:	0344e7bb          	remw	a5,s1,s4
    5486:	0337c7bb          	divw	a5,a5,s3
    548a:	0307879b          	addw	a5,a5,48
    548e:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5492:	0334e7bb          	remw	a5,s1,s3
    5496:	0327c7bb          	divw	a5,a5,s2
    549a:	0307879b          	addw	a5,a5,48
    549e:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    54a2:	0324e7bb          	remw	a5,s1,s2
    54a6:	0307879b          	addw	a5,a5,48
    54aa:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    54ae:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    54b2:	f6040513          	add	a0,s0,-160
    54b6:	00000097          	auipc	ra,0x0
    54ba:	756080e7          	jalr	1878(ra) # 5c0c <unlink>
    nfiles--;
    54be:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    54c0:	fb5499e3          	bne	s1,s5,5472 <fsfull+0xd0>
  printf("fsfull test finished\n");
    54c4:	00003517          	auipc	a0,0x3
    54c8:	b7450513          	add	a0,a0,-1164 # 8038 <malloc+0x205c>
    54cc:	00001097          	auipc	ra,0x1
    54d0:	a58080e7          	jalr	-1448(ra) # 5f24 <printf>
}
    54d4:	60ea                	ld	ra,152(sp)
    54d6:	644a                	ld	s0,144(sp)
    54d8:	64aa                	ld	s1,136(sp)
    54da:	690a                	ld	s2,128(sp)
    54dc:	79e6                	ld	s3,120(sp)
    54de:	7a46                	ld	s4,112(sp)
    54e0:	7aa6                	ld	s5,104(sp)
    54e2:	7b06                	ld	s6,96(sp)
    54e4:	6be6                	ld	s7,88(sp)
    54e6:	6c46                	ld	s8,80(sp)
    54e8:	6ca6                	ld	s9,72(sp)
    54ea:	6d06                	ld	s10,64(sp)
    54ec:	610d                	add	sp,sp,160
    54ee:	8082                	ret
    int total = 0;
    54f0:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    54f2:	00007a97          	auipc	s5,0x7
    54f6:	786a8a93          	add	s5,s5,1926 # cc78 <buf>
      if(cc < BSIZE)
    54fa:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    54fe:	40000613          	li	a2,1024
    5502:	85d6                	mv	a1,s5
    5504:	854a                	mv	a0,s2
    5506:	00000097          	auipc	ra,0x0
    550a:	6d6080e7          	jalr	1750(ra) # 5bdc <write>
      if(cc < BSIZE)
    550e:	00aa5563          	bge	s4,a0,5518 <fsfull+0x176>
      total += cc;
    5512:	00a989bb          	addw	s3,s3,a0
    while(1){
    5516:	b7e5                	j	54fe <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    5518:	85ce                	mv	a1,s3
    551a:	00003517          	auipc	a0,0x3
    551e:	b0e50513          	add	a0,a0,-1266 # 8028 <malloc+0x204c>
    5522:	00001097          	auipc	ra,0x1
    5526:	a02080e7          	jalr	-1534(ra) # 5f24 <printf>
    close(fd);
    552a:	854a                	mv	a0,s2
    552c:	00000097          	auipc	ra,0x0
    5530:	6b8080e7          	jalr	1720(ra) # 5be4 <close>
    if(total == 0)
    5534:	f20985e3          	beqz	s3,545e <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    5538:	2485                	addw	s1,s1,1
    553a:	b575                	j	53e6 <fsfull+0x44>

000000000000553c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    553c:	7179                	add	sp,sp,-48
    553e:	f406                	sd	ra,40(sp)
    5540:	f022                	sd	s0,32(sp)
    5542:	ec26                	sd	s1,24(sp)
    5544:	e84a                	sd	s2,16(sp)
    5546:	1800                	add	s0,sp,48
    5548:	84aa                	mv	s1,a0
    554a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554c:	00003517          	auipc	a0,0x3
    5550:	b0450513          	add	a0,a0,-1276 # 8050 <malloc+0x2074>
    5554:	00001097          	auipc	ra,0x1
    5558:	9d0080e7          	jalr	-1584(ra) # 5f24 <printf>
  if((pid = fork()) < 0) {
    555c:	00000097          	auipc	ra,0x0
    5560:	658080e7          	jalr	1624(ra) # 5bb4 <fork>
    5564:	02054e63          	bltz	a0,55a0 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5568:	c929                	beqz	a0,55ba <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    556a:	fdc40513          	add	a0,s0,-36
    556e:	00000097          	auipc	ra,0x0
    5572:	656080e7          	jalr	1622(ra) # 5bc4 <wait>
    if(xstatus != 0) 
    5576:	fdc42783          	lw	a5,-36(s0)
    557a:	c7b9                	beqz	a5,55c8 <run+0x8c>
      printf("FAILED\n");
    557c:	00003517          	auipc	a0,0x3
    5580:	afc50513          	add	a0,a0,-1284 # 8078 <malloc+0x209c>
    5584:	00001097          	auipc	ra,0x1
    5588:	9a0080e7          	jalr	-1632(ra) # 5f24 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5590:	00153513          	seqz	a0,a0
    5594:	70a2                	ld	ra,40(sp)
    5596:	7402                	ld	s0,32(sp)
    5598:	64e2                	ld	s1,24(sp)
    559a:	6942                	ld	s2,16(sp)
    559c:	6145                	add	sp,sp,48
    559e:	8082                	ret
    printf("runtest: fork error\n");
    55a0:	00003517          	auipc	a0,0x3
    55a4:	ac050513          	add	a0,a0,-1344 # 8060 <malloc+0x2084>
    55a8:	00001097          	auipc	ra,0x1
    55ac:	97c080e7          	jalr	-1668(ra) # 5f24 <printf>
    exit(1);
    55b0:	4505                	li	a0,1
    55b2:	00000097          	auipc	ra,0x0
    55b6:	60a080e7          	jalr	1546(ra) # 5bbc <exit>
    f(s);
    55ba:	854a                	mv	a0,s2
    55bc:	9482                	jalr	s1
    exit(0);
    55be:	4501                	li	a0,0
    55c0:	00000097          	auipc	ra,0x0
    55c4:	5fc080e7          	jalr	1532(ra) # 5bbc <exit>
      printf("OK\n");
    55c8:	00003517          	auipc	a0,0x3
    55cc:	ab850513          	add	a0,a0,-1352 # 8080 <malloc+0x20a4>
    55d0:	00001097          	auipc	ra,0x1
    55d4:	954080e7          	jalr	-1708(ra) # 5f24 <printf>
    55d8:	bf55                	j	558c <run+0x50>

00000000000055da <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    55da:	7179                	add	sp,sp,-48
    55dc:	f406                	sd	ra,40(sp)
    55de:	f022                	sd	s0,32(sp)
    55e0:	ec26                	sd	s1,24(sp)
    55e2:	e84a                	sd	s2,16(sp)
    55e4:	e44e                	sd	s3,8(sp)
    55e6:	e052                	sd	s4,0(sp)
    55e8:	1800                	add	s0,sp,48
    55ea:	84aa                	mv	s1,a0
  for (struct test *t = tests; t->s != 0; t++) {
    55ec:	6508                	ld	a0,8(a0)
    55ee:	c931                	beqz	a0,5642 <runtests+0x68>
    55f0:	892e                	mv	s2,a1
    55f2:	89b2                	mv	s3,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    55f4:	4a09                	li	s4,2
    55f6:	a021                	j	55fe <runtests+0x24>
  for (struct test *t = tests; t->s != 0; t++) {
    55f8:	04c1                	add	s1,s1,16
    55fa:	6488                	ld	a0,8(s1)
    55fc:	c91d                	beqz	a0,5632 <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    55fe:	00090863          	beqz	s2,560e <runtests+0x34>
    5602:	85ca                	mv	a1,s2
    5604:	00000097          	auipc	ra,0x0
    5608:	368080e7          	jalr	872(ra) # 596c <strcmp>
    560c:	f575                	bnez	a0,55f8 <runtests+0x1e>
      if(!run(t->f, t->s)){
    560e:	648c                	ld	a1,8(s1)
    5610:	6088                	ld	a0,0(s1)
    5612:	00000097          	auipc	ra,0x0
    5616:	f2a080e7          	jalr	-214(ra) # 553c <run>
    561a:	fd79                	bnez	a0,55f8 <runtests+0x1e>
        if(continuous != 2){
    561c:	fd498ee3          	beq	s3,s4,55f8 <runtests+0x1e>
          printf("SOME TESTS FAILED\n");
    5620:	00003517          	auipc	a0,0x3
    5624:	a6850513          	add	a0,a0,-1432 # 8088 <malloc+0x20ac>
    5628:	00001097          	auipc	ra,0x1
    562c:	8fc080e7          	jalr	-1796(ra) # 5f24 <printf>
          return 1;
    5630:	4505                	li	a0,1
        }
      }
    }
  }
  return 0;
}
    5632:	70a2                	ld	ra,40(sp)
    5634:	7402                	ld	s0,32(sp)
    5636:	64e2                	ld	s1,24(sp)
    5638:	6942                	ld	s2,16(sp)
    563a:	69a2                	ld	s3,8(sp)
    563c:	6a02                	ld	s4,0(sp)
    563e:	6145                	add	sp,sp,48
    5640:	8082                	ret
  return 0;
    5642:	4501                	li	a0,0
    5644:	b7fd                	j	5632 <runtests+0x58>

0000000000005646 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5646:	7139                	add	sp,sp,-64
    5648:	fc06                	sd	ra,56(sp)
    564a:	f822                	sd	s0,48(sp)
    564c:	f426                	sd	s1,40(sp)
    564e:	f04a                	sd	s2,32(sp)
    5650:	ec4e                	sd	s3,24(sp)
    5652:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5654:	fc840513          	add	a0,s0,-56
    5658:	00000097          	auipc	ra,0x0
    565c:	574080e7          	jalr	1396(ra) # 5bcc <pipe>
    5660:	06054763          	bltz	a0,56ce <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5664:	00000097          	auipc	ra,0x0
    5668:	550080e7          	jalr	1360(ra) # 5bb4 <fork>

  if(pid < 0){
    566c:	06054e63          	bltz	a0,56e8 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5670:	ed51                	bnez	a0,570c <countfree+0xc6>
    close(fds[0]);
    5672:	fc842503          	lw	a0,-56(s0)
    5676:	00000097          	auipc	ra,0x0
    567a:	56e080e7          	jalr	1390(ra) # 5be4 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    567e:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5680:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5682:	00001997          	auipc	s3,0x1
    5686:	af698993          	add	s3,s3,-1290 # 6178 <malloc+0x19c>
      uint64 a = (uint64) sbrk(4096);
    568a:	6505                	lui	a0,0x1
    568c:	00000097          	auipc	ra,0x0
    5690:	5b8080e7          	jalr	1464(ra) # 5c44 <sbrk>
      if(a == 0xffffffffffffffff){
    5694:	07250763          	beq	a0,s2,5702 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5698:	6785                	lui	a5,0x1
    569a:	97aa                	add	a5,a5,a0
    569c:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x103>
      if(write(fds[1], "x", 1) != 1){
    56a0:	8626                	mv	a2,s1
    56a2:	85ce                	mv	a1,s3
    56a4:	fcc42503          	lw	a0,-52(s0)
    56a8:	00000097          	auipc	ra,0x0
    56ac:	534080e7          	jalr	1332(ra) # 5bdc <write>
    56b0:	fc950de3          	beq	a0,s1,568a <countfree+0x44>
        printf("write() failed in countfree()\n");
    56b4:	00003517          	auipc	a0,0x3
    56b8:	a2c50513          	add	a0,a0,-1492 # 80e0 <malloc+0x2104>
    56bc:	00001097          	auipc	ra,0x1
    56c0:	868080e7          	jalr	-1944(ra) # 5f24 <printf>
        exit(1);
    56c4:	4505                	li	a0,1
    56c6:	00000097          	auipc	ra,0x0
    56ca:	4f6080e7          	jalr	1270(ra) # 5bbc <exit>
    printf("pipe() failed in countfree()\n");
    56ce:	00003517          	auipc	a0,0x3
    56d2:	9d250513          	add	a0,a0,-1582 # 80a0 <malloc+0x20c4>
    56d6:	00001097          	auipc	ra,0x1
    56da:	84e080e7          	jalr	-1970(ra) # 5f24 <printf>
    exit(1);
    56de:	4505                	li	a0,1
    56e0:	00000097          	auipc	ra,0x0
    56e4:	4dc080e7          	jalr	1244(ra) # 5bbc <exit>
    printf("fork failed in countfree()\n");
    56e8:	00003517          	auipc	a0,0x3
    56ec:	9d850513          	add	a0,a0,-1576 # 80c0 <malloc+0x20e4>
    56f0:	00001097          	auipc	ra,0x1
    56f4:	834080e7          	jalr	-1996(ra) # 5f24 <printf>
    exit(1);
    56f8:	4505                	li	a0,1
    56fa:	00000097          	auipc	ra,0x0
    56fe:	4c2080e7          	jalr	1218(ra) # 5bbc <exit>
      }
    }

    exit(0);
    5702:	4501                	li	a0,0
    5704:	00000097          	auipc	ra,0x0
    5708:	4b8080e7          	jalr	1208(ra) # 5bbc <exit>
  }

  close(fds[1]);
    570c:	fcc42503          	lw	a0,-52(s0)
    5710:	00000097          	auipc	ra,0x0
    5714:	4d4080e7          	jalr	1236(ra) # 5be4 <close>

  int n = 0;
    5718:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    571a:	4605                	li	a2,1
    571c:	fc740593          	add	a1,s0,-57
    5720:	fc842503          	lw	a0,-56(s0)
    5724:	00000097          	auipc	ra,0x0
    5728:	4b0080e7          	jalr	1200(ra) # 5bd4 <read>
    if(cc < 0){
    572c:	00054563          	bltz	a0,5736 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5730:	c105                	beqz	a0,5750 <countfree+0x10a>
      break;
    n += 1;
    5732:	2485                	addw	s1,s1,1
  while(1){
    5734:	b7dd                	j	571a <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5736:	00003517          	auipc	a0,0x3
    573a:	9ca50513          	add	a0,a0,-1590 # 8100 <malloc+0x2124>
    573e:	00000097          	auipc	ra,0x0
    5742:	7e6080e7          	jalr	2022(ra) # 5f24 <printf>
      exit(1);
    5746:	4505                	li	a0,1
    5748:	00000097          	auipc	ra,0x0
    574c:	474080e7          	jalr	1140(ra) # 5bbc <exit>
  }

  close(fds[0]);
    5750:	fc842503          	lw	a0,-56(s0)
    5754:	00000097          	auipc	ra,0x0
    5758:	490080e7          	jalr	1168(ra) # 5be4 <close>
  wait((int*)0);
    575c:	4501                	li	a0,0
    575e:	00000097          	auipc	ra,0x0
    5762:	466080e7          	jalr	1126(ra) # 5bc4 <wait>
  
  return n;
}
    5766:	8526                	mv	a0,s1
    5768:	70e2                	ld	ra,56(sp)
    576a:	7442                	ld	s0,48(sp)
    576c:	74a2                	ld	s1,40(sp)
    576e:	7902                	ld	s2,32(sp)
    5770:	69e2                	ld	s3,24(sp)
    5772:	6121                	add	sp,sp,64
    5774:	8082                	ret

0000000000005776 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5776:	711d                	add	sp,sp,-96
    5778:	ec86                	sd	ra,88(sp)
    577a:	e8a2                	sd	s0,80(sp)
    577c:	e4a6                	sd	s1,72(sp)
    577e:	e0ca                	sd	s2,64(sp)
    5780:	fc4e                	sd	s3,56(sp)
    5782:	f852                	sd	s4,48(sp)
    5784:	f456                	sd	s5,40(sp)
    5786:	f05a                	sd	s6,32(sp)
    5788:	ec5e                	sd	s7,24(sp)
    578a:	e862                	sd	s8,16(sp)
    578c:	e466                	sd	s9,8(sp)
    578e:	e06a                	sd	s10,0(sp)
    5790:	1080                	add	s0,sp,96
    5792:	8aaa                	mv	s5,a0
    5794:	892e                	mv	s2,a1
    5796:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    5798:	00003b97          	auipc	s7,0x3
    579c:	988b8b93          	add	s7,s7,-1656 # 8120 <malloc+0x2144>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    57a0:	00004b17          	auipc	s6,0x4
    57a4:	870b0b13          	add	s6,s6,-1936 # 9010 <quicktests>
      if(continuous != 2) {
    57a8:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    57aa:	00004c17          	auipc	s8,0x4
    57ae:	c36c0c13          	add	s8,s8,-970 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57b2:	00003d17          	auipc	s10,0x3
    57b6:	986d0d13          	add	s10,s10,-1658 # 8138 <malloc+0x215c>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57ba:	00003c97          	auipc	s9,0x3
    57be:	99ec8c93          	add	s9,s9,-1634 # 8158 <malloc+0x217c>
    57c2:	a839                	j	57e0 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    57c4:	856a                	mv	a0,s10
    57c6:	00000097          	auipc	ra,0x0
    57ca:	75e080e7          	jalr	1886(ra) # 5f24 <printf>
    57ce:	a089                	j	5810 <drivetests+0x9a>
    if((free1 = countfree()) < free0) {
    57d0:	00000097          	auipc	ra,0x0
    57d4:	e76080e7          	jalr	-394(ra) # 5646 <countfree>
    57d8:	04954863          	blt	a0,s1,5828 <drivetests+0xb2>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57dc:	06090363          	beqz	s2,5842 <drivetests+0xcc>
    printf("usertests starting\n");
    57e0:	855e                	mv	a0,s7
    57e2:	00000097          	auipc	ra,0x0
    57e6:	742080e7          	jalr	1858(ra) # 5f24 <printf>
    int free0 = countfree();
    57ea:	00000097          	auipc	ra,0x0
    57ee:	e5c080e7          	jalr	-420(ra) # 5646 <countfree>
    57f2:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    57f4:	864a                	mv	a2,s2
    57f6:	85ce                	mv	a1,s3
    57f8:	855a                	mv	a0,s6
    57fa:	00000097          	auipc	ra,0x0
    57fe:	de0080e7          	jalr	-544(ra) # 55da <runtests>
    5802:	c119                	beqz	a0,5808 <drivetests+0x92>
      if(continuous != 2) {
    5804:	03491d63          	bne	s2,s4,583e <drivetests+0xc8>
    if(!quick) {
    5808:	fc0a94e3          	bnez	s5,57d0 <drivetests+0x5a>
      if (justone == 0)
    580c:	fa098ce3          	beqz	s3,57c4 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    5810:	864a                	mv	a2,s2
    5812:	85ce                	mv	a1,s3
    5814:	8562                	mv	a0,s8
    5816:	00000097          	auipc	ra,0x0
    581a:	dc4080e7          	jalr	-572(ra) # 55da <runtests>
    581e:	d94d                	beqz	a0,57d0 <drivetests+0x5a>
        if(continuous != 2) {
    5820:	fb4908e3          	beq	s2,s4,57d0 <drivetests+0x5a>
          return 1;
    5824:	4505                	li	a0,1
    5826:	a839                	j	5844 <drivetests+0xce>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5828:	8626                	mv	a2,s1
    582a:	85aa                	mv	a1,a0
    582c:	8566                	mv	a0,s9
    582e:	00000097          	auipc	ra,0x0
    5832:	6f6080e7          	jalr	1782(ra) # 5f24 <printf>
      if(continuous != 2) {
    5836:	fb4905e3          	beq	s2,s4,57e0 <drivetests+0x6a>
        return 1;
    583a:	4505                	li	a0,1
    583c:	a021                	j	5844 <drivetests+0xce>
        return 1;
    583e:	4505                	li	a0,1
    5840:	a011                	j	5844 <drivetests+0xce>
  return 0;
    5842:	854a                	mv	a0,s2
}
    5844:	60e6                	ld	ra,88(sp)
    5846:	6446                	ld	s0,80(sp)
    5848:	64a6                	ld	s1,72(sp)
    584a:	6906                	ld	s2,64(sp)
    584c:	79e2                	ld	s3,56(sp)
    584e:	7a42                	ld	s4,48(sp)
    5850:	7aa2                	ld	s5,40(sp)
    5852:	7b02                	ld	s6,32(sp)
    5854:	6be2                	ld	s7,24(sp)
    5856:	6c42                	ld	s8,16(sp)
    5858:	6ca2                	ld	s9,8(sp)
    585a:	6d02                	ld	s10,0(sp)
    585c:	6125                	add	sp,sp,96
    585e:	8082                	ret

0000000000005860 <main>:

int
main(int argc, char *argv[])
{
    5860:	1101                	add	sp,sp,-32
    5862:	ec06                	sd	ra,24(sp)
    5864:	e822                	sd	s0,16(sp)
    5866:	e426                	sd	s1,8(sp)
    5868:	e04a                	sd	s2,0(sp)
    586a:	1000                	add	s0,sp,32
    586c:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    586e:	4789                	li	a5,2
    5870:	02f50263          	beq	a0,a5,5894 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5874:	4785                	li	a5,1
    5876:	08a7c063          	blt	a5,a0,58f6 <main+0x96>
  char *justone = 0;
    587a:	4601                	li	a2,0
  int quick = 0;
    587c:	4501                	li	a0,0
  int continuous = 0;
    587e:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5880:	00000097          	auipc	ra,0x0
    5884:	ef6080e7          	jalr	-266(ra) # 5776 <drivetests>
    5888:	c951                	beqz	a0,591c <main+0xbc>
    exit(1);
    588a:	4505                	li	a0,1
    588c:	00000097          	auipc	ra,0x0
    5890:	330080e7          	jalr	816(ra) # 5bbc <exit>
    5894:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5896:	00003597          	auipc	a1,0x3
    589a:	8f258593          	add	a1,a1,-1806 # 8188 <malloc+0x21ac>
    589e:	00893503          	ld	a0,8(s2)
    58a2:	00000097          	auipc	ra,0x0
    58a6:	0ca080e7          	jalr	202(ra) # 596c <strcmp>
    58aa:	85aa                	mv	a1,a0
    58ac:	e501                	bnez	a0,58b4 <main+0x54>
  char *justone = 0;
    58ae:	4601                	li	a2,0
    quick = 1;
    58b0:	4505                	li	a0,1
    58b2:	b7f9                	j	5880 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58b4:	00003597          	auipc	a1,0x3
    58b8:	8dc58593          	add	a1,a1,-1828 # 8190 <malloc+0x21b4>
    58bc:	00893503          	ld	a0,8(s2)
    58c0:	00000097          	auipc	ra,0x0
    58c4:	0ac080e7          	jalr	172(ra) # 596c <strcmp>
    58c8:	c521                	beqz	a0,5910 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58ca:	00003597          	auipc	a1,0x3
    58ce:	91658593          	add	a1,a1,-1770 # 81e0 <malloc+0x2204>
    58d2:	00893503          	ld	a0,8(s2)
    58d6:	00000097          	auipc	ra,0x0
    58da:	096080e7          	jalr	150(ra) # 596c <strcmp>
    58de:	cd05                	beqz	a0,5916 <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    58e0:	00893603          	ld	a2,8(s2)
    58e4:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x9e>
    58e8:	02d00793          	li	a5,45
    58ec:	00f70563          	beq	a4,a5,58f6 <main+0x96>
  int quick = 0;
    58f0:	4501                	li	a0,0
  int continuous = 0;
    58f2:	4581                	li	a1,0
    58f4:	b771                	j	5880 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58f6:	00003517          	auipc	a0,0x3
    58fa:	8a250513          	add	a0,a0,-1886 # 8198 <malloc+0x21bc>
    58fe:	00000097          	auipc	ra,0x0
    5902:	626080e7          	jalr	1574(ra) # 5f24 <printf>
    exit(1);
    5906:	4505                	li	a0,1
    5908:	00000097          	auipc	ra,0x0
    590c:	2b4080e7          	jalr	692(ra) # 5bbc <exit>
  char *justone = 0;
    5910:	4601                	li	a2,0
    continuous = 1;
    5912:	4585                	li	a1,1
    5914:	b7b5                	j	5880 <main+0x20>
    continuous = 2;
    5916:	85a6                	mv	a1,s1
  char *justone = 0;
    5918:	4601                	li	a2,0
    591a:	b79d                	j	5880 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    591c:	00003517          	auipc	a0,0x3
    5920:	8ac50513          	add	a0,a0,-1876 # 81c8 <malloc+0x21ec>
    5924:	00000097          	auipc	ra,0x0
    5928:	600080e7          	jalr	1536(ra) # 5f24 <printf>
  exit(0);
    592c:	4501                	li	a0,0
    592e:	00000097          	auipc	ra,0x0
    5932:	28e080e7          	jalr	654(ra) # 5bbc <exit>

0000000000005936 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5936:	1141                	add	sp,sp,-16
    5938:	e406                	sd	ra,8(sp)
    593a:	e022                	sd	s0,0(sp)
    593c:	0800                	add	s0,sp,16
  extern int main();
  main();
    593e:	00000097          	auipc	ra,0x0
    5942:	f22080e7          	jalr	-222(ra) # 5860 <main>
  exit(0);
    5946:	4501                	li	a0,0
    5948:	00000097          	auipc	ra,0x0
    594c:	274080e7          	jalr	628(ra) # 5bbc <exit>

0000000000005950 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5950:	1141                	add	sp,sp,-16
    5952:	e422                	sd	s0,8(sp)
    5954:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5956:	87aa                	mv	a5,a0
    5958:	0585                	add	a1,a1,1
    595a:	0785                	add	a5,a5,1
    595c:	fff5c703          	lbu	a4,-1(a1)
    5960:	fee78fa3          	sb	a4,-1(a5)
    5964:	fb75                	bnez	a4,5958 <strcpy+0x8>
    ;
  return os;
}
    5966:	6422                	ld	s0,8(sp)
    5968:	0141                	add	sp,sp,16
    596a:	8082                	ret

000000000000596c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    596c:	1141                	add	sp,sp,-16
    596e:	e422                	sd	s0,8(sp)
    5970:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    5972:	00054783          	lbu	a5,0(a0)
    5976:	cb91                	beqz	a5,598a <strcmp+0x1e>
    5978:	0005c703          	lbu	a4,0(a1)
    597c:	00f71763          	bne	a4,a5,598a <strcmp+0x1e>
    p++, q++;
    5980:	0505                	add	a0,a0,1
    5982:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    5984:	00054783          	lbu	a5,0(a0)
    5988:	fbe5                	bnez	a5,5978 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    598a:	0005c503          	lbu	a0,0(a1)
}
    598e:	40a7853b          	subw	a0,a5,a0
    5992:	6422                	ld	s0,8(sp)
    5994:	0141                	add	sp,sp,16
    5996:	8082                	ret

0000000000005998 <strlen>:

uint
strlen(const char *s)
{
    5998:	1141                	add	sp,sp,-16
    599a:	e422                	sd	s0,8(sp)
    599c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    599e:	00054783          	lbu	a5,0(a0)
    59a2:	cf91                	beqz	a5,59be <strlen+0x26>
    59a4:	0505                	add	a0,a0,1
    59a6:	87aa                	mv	a5,a0
    59a8:	86be                	mv	a3,a5
    59aa:	0785                	add	a5,a5,1
    59ac:	fff7c703          	lbu	a4,-1(a5)
    59b0:	ff65                	bnez	a4,59a8 <strlen+0x10>
    59b2:	40a6853b          	subw	a0,a3,a0
    59b6:	2505                	addw	a0,a0,1
    ;
  return n;
}
    59b8:	6422                	ld	s0,8(sp)
    59ba:	0141                	add	sp,sp,16
    59bc:	8082                	ret
  for(n = 0; s[n]; n++)
    59be:	4501                	li	a0,0
    59c0:	bfe5                	j	59b8 <strlen+0x20>

00000000000059c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    59c2:	1141                	add	sp,sp,-16
    59c4:	e422                	sd	s0,8(sp)
    59c6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59c8:	ca19                	beqz	a2,59de <memset+0x1c>
    59ca:	87aa                	mv	a5,a0
    59cc:	1602                	sll	a2,a2,0x20
    59ce:	9201                	srl	a2,a2,0x20
    59d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59d8:	0785                	add	a5,a5,1
    59da:	fee79de3          	bne	a5,a4,59d4 <memset+0x12>
  }
  return dst;
}
    59de:	6422                	ld	s0,8(sp)
    59e0:	0141                	add	sp,sp,16
    59e2:	8082                	ret

00000000000059e4 <strchr>:

char*
strchr(const char *s, char c)
{
    59e4:	1141                	add	sp,sp,-16
    59e6:	e422                	sd	s0,8(sp)
    59e8:	0800                	add	s0,sp,16
  for(; *s; s++)
    59ea:	00054783          	lbu	a5,0(a0)
    59ee:	cb99                	beqz	a5,5a04 <strchr+0x20>
    if(*s == c)
    59f0:	00f58763          	beq	a1,a5,59fe <strchr+0x1a>
  for(; *s; s++)
    59f4:	0505                	add	a0,a0,1
    59f6:	00054783          	lbu	a5,0(a0)
    59fa:	fbfd                	bnez	a5,59f0 <strchr+0xc>
      return (char*)s;
  return 0;
    59fc:	4501                	li	a0,0
}
    59fe:	6422                	ld	s0,8(sp)
    5a00:	0141                	add	sp,sp,16
    5a02:	8082                	ret
  return 0;
    5a04:	4501                	li	a0,0
    5a06:	bfe5                	j	59fe <strchr+0x1a>

0000000000005a08 <gets>:

char*
gets(char *buf, int max)
{
    5a08:	711d                	add	sp,sp,-96
    5a0a:	ec86                	sd	ra,88(sp)
    5a0c:	e8a2                	sd	s0,80(sp)
    5a0e:	e4a6                	sd	s1,72(sp)
    5a10:	e0ca                	sd	s2,64(sp)
    5a12:	fc4e                	sd	s3,56(sp)
    5a14:	f852                	sd	s4,48(sp)
    5a16:	f456                	sd	s5,40(sp)
    5a18:	f05a                	sd	s6,32(sp)
    5a1a:	ec5e                	sd	s7,24(sp)
    5a1c:	1080                	add	s0,sp,96
    5a1e:	8baa                	mv	s7,a0
    5a20:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a22:	892a                	mv	s2,a0
    5a24:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a26:	4aa9                	li	s5,10
    5a28:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a2a:	89a6                	mv	s3,s1
    5a2c:	2485                	addw	s1,s1,1
    5a2e:	0344d863          	bge	s1,s4,5a5e <gets+0x56>
    cc = read(0, &c, 1);
    5a32:	4605                	li	a2,1
    5a34:	faf40593          	add	a1,s0,-81
    5a38:	4501                	li	a0,0
    5a3a:	00000097          	auipc	ra,0x0
    5a3e:	19a080e7          	jalr	410(ra) # 5bd4 <read>
    if(cc < 1)
    5a42:	00a05e63          	blez	a0,5a5e <gets+0x56>
    buf[i++] = c;
    5a46:	faf44783          	lbu	a5,-81(s0)
    5a4a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a4e:	01578763          	beq	a5,s5,5a5c <gets+0x54>
    5a52:	0905                	add	s2,s2,1
    5a54:	fd679be3          	bne	a5,s6,5a2a <gets+0x22>
  for(i=0; i+1 < max; ){
    5a58:	89a6                	mv	s3,s1
    5a5a:	a011                	j	5a5e <gets+0x56>
    5a5c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a5e:	99de                	add	s3,s3,s7
    5a60:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a64:	855e                	mv	a0,s7
    5a66:	60e6                	ld	ra,88(sp)
    5a68:	6446                	ld	s0,80(sp)
    5a6a:	64a6                	ld	s1,72(sp)
    5a6c:	6906                	ld	s2,64(sp)
    5a6e:	79e2                	ld	s3,56(sp)
    5a70:	7a42                	ld	s4,48(sp)
    5a72:	7aa2                	ld	s5,40(sp)
    5a74:	7b02                	ld	s6,32(sp)
    5a76:	6be2                	ld	s7,24(sp)
    5a78:	6125                	add	sp,sp,96
    5a7a:	8082                	ret

0000000000005a7c <stat>:

int
stat(const char *n, struct stat *st)
{
    5a7c:	1101                	add	sp,sp,-32
    5a7e:	ec06                	sd	ra,24(sp)
    5a80:	e822                	sd	s0,16(sp)
    5a82:	e426                	sd	s1,8(sp)
    5a84:	e04a                	sd	s2,0(sp)
    5a86:	1000                	add	s0,sp,32
    5a88:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a8a:	4581                	li	a1,0
    5a8c:	00000097          	auipc	ra,0x0
    5a90:	170080e7          	jalr	368(ra) # 5bfc <open>
  if(fd < 0)
    5a94:	02054563          	bltz	a0,5abe <stat+0x42>
    5a98:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a9a:	85ca                	mv	a1,s2
    5a9c:	00000097          	auipc	ra,0x0
    5aa0:	178080e7          	jalr	376(ra) # 5c14 <fstat>
    5aa4:	892a                	mv	s2,a0
  close(fd);
    5aa6:	8526                	mv	a0,s1
    5aa8:	00000097          	auipc	ra,0x0
    5aac:	13c080e7          	jalr	316(ra) # 5be4 <close>
  return r;
}
    5ab0:	854a                	mv	a0,s2
    5ab2:	60e2                	ld	ra,24(sp)
    5ab4:	6442                	ld	s0,16(sp)
    5ab6:	64a2                	ld	s1,8(sp)
    5ab8:	6902                	ld	s2,0(sp)
    5aba:	6105                	add	sp,sp,32
    5abc:	8082                	ret
    return -1;
    5abe:	597d                	li	s2,-1
    5ac0:	bfc5                	j	5ab0 <stat+0x34>

0000000000005ac2 <atoi>:

int
atoi(const char *s)
{
    5ac2:	1141                	add	sp,sp,-16
    5ac4:	e422                	sd	s0,8(sp)
    5ac6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ac8:	00054683          	lbu	a3,0(a0)
    5acc:	fd06879b          	addw	a5,a3,-48
    5ad0:	0ff7f793          	zext.b	a5,a5
    5ad4:	4625                	li	a2,9
    5ad6:	02f66863          	bltu	a2,a5,5b06 <atoi+0x44>
    5ada:	872a                	mv	a4,a0
  n = 0;
    5adc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ade:	0705                	add	a4,a4,1
    5ae0:	0025179b          	sllw	a5,a0,0x2
    5ae4:	9fa9                	addw	a5,a5,a0
    5ae6:	0017979b          	sllw	a5,a5,0x1
    5aea:	9fb5                	addw	a5,a5,a3
    5aec:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5af0:	00074683          	lbu	a3,0(a4)
    5af4:	fd06879b          	addw	a5,a3,-48
    5af8:	0ff7f793          	zext.b	a5,a5
    5afc:	fef671e3          	bgeu	a2,a5,5ade <atoi+0x1c>
  return n;
}
    5b00:	6422                	ld	s0,8(sp)
    5b02:	0141                	add	sp,sp,16
    5b04:	8082                	ret
  n = 0;
    5b06:	4501                	li	a0,0
    5b08:	bfe5                	j	5b00 <atoi+0x3e>

0000000000005b0a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b0a:	1141                	add	sp,sp,-16
    5b0c:	e422                	sd	s0,8(sp)
    5b0e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b10:	02b57463          	bgeu	a0,a1,5b38 <memmove+0x2e>
    while(n-- > 0)
    5b14:	00c05f63          	blez	a2,5b32 <memmove+0x28>
    5b18:	1602                	sll	a2,a2,0x20
    5b1a:	9201                	srl	a2,a2,0x20
    5b1c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b20:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b22:	0585                	add	a1,a1,1
    5b24:	0705                	add	a4,a4,1
    5b26:	fff5c683          	lbu	a3,-1(a1)
    5b2a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b2e:	fee79ae3          	bne	a5,a4,5b22 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b32:	6422                	ld	s0,8(sp)
    5b34:	0141                	add	sp,sp,16
    5b36:	8082                	ret
    dst += n;
    5b38:	00c50733          	add	a4,a0,a2
    src += n;
    5b3c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b3e:	fec05ae3          	blez	a2,5b32 <memmove+0x28>
    5b42:	fff6079b          	addw	a5,a2,-1
    5b46:	1782                	sll	a5,a5,0x20
    5b48:	9381                	srl	a5,a5,0x20
    5b4a:	fff7c793          	not	a5,a5
    5b4e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b50:	15fd                	add	a1,a1,-1
    5b52:	177d                	add	a4,a4,-1
    5b54:	0005c683          	lbu	a3,0(a1)
    5b58:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b5c:	fee79ae3          	bne	a5,a4,5b50 <memmove+0x46>
    5b60:	bfc9                	j	5b32 <memmove+0x28>

0000000000005b62 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b62:	1141                	add	sp,sp,-16
    5b64:	e422                	sd	s0,8(sp)
    5b66:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b68:	ca05                	beqz	a2,5b98 <memcmp+0x36>
    5b6a:	fff6069b          	addw	a3,a2,-1
    5b6e:	1682                	sll	a3,a3,0x20
    5b70:	9281                	srl	a3,a3,0x20
    5b72:	0685                	add	a3,a3,1
    5b74:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b76:	00054783          	lbu	a5,0(a0)
    5b7a:	0005c703          	lbu	a4,0(a1)
    5b7e:	00e79863          	bne	a5,a4,5b8e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b82:	0505                	add	a0,a0,1
    p2++;
    5b84:	0585                	add	a1,a1,1
  while (n-- > 0) {
    5b86:	fed518e3          	bne	a0,a3,5b76 <memcmp+0x14>
  }
  return 0;
    5b8a:	4501                	li	a0,0
    5b8c:	a019                	j	5b92 <memcmp+0x30>
      return *p1 - *p2;
    5b8e:	40e7853b          	subw	a0,a5,a4
}
    5b92:	6422                	ld	s0,8(sp)
    5b94:	0141                	add	sp,sp,16
    5b96:	8082                	ret
  return 0;
    5b98:	4501                	li	a0,0
    5b9a:	bfe5                	j	5b92 <memcmp+0x30>

0000000000005b9c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b9c:	1141                	add	sp,sp,-16
    5b9e:	e406                	sd	ra,8(sp)
    5ba0:	e022                	sd	s0,0(sp)
    5ba2:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5ba4:	00000097          	auipc	ra,0x0
    5ba8:	f66080e7          	jalr	-154(ra) # 5b0a <memmove>
}
    5bac:	60a2                	ld	ra,8(sp)
    5bae:	6402                	ld	s0,0(sp)
    5bb0:	0141                	add	sp,sp,16
    5bb2:	8082                	ret

0000000000005bb4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bb4:	4885                	li	a7,1
 ecall
    5bb6:	00000073          	ecall
 ret
    5bba:	8082                	ret

0000000000005bbc <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bbc:	4889                	li	a7,2
 ecall
    5bbe:	00000073          	ecall
 ret
    5bc2:	8082                	ret

0000000000005bc4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bc4:	488d                	li	a7,3
 ecall
    5bc6:	00000073          	ecall
 ret
    5bca:	8082                	ret

0000000000005bcc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bcc:	4891                	li	a7,4
 ecall
    5bce:	00000073          	ecall
 ret
    5bd2:	8082                	ret

0000000000005bd4 <read>:
.global read
read:
 li a7, SYS_read
    5bd4:	4895                	li	a7,5
 ecall
    5bd6:	00000073          	ecall
 ret
    5bda:	8082                	ret

0000000000005bdc <write>:
.global write
write:
 li a7, SYS_write
    5bdc:	48c1                	li	a7,16
 ecall
    5bde:	00000073          	ecall
 ret
    5be2:	8082                	ret

0000000000005be4 <close>:
.global close
close:
 li a7, SYS_close
    5be4:	48d5                	li	a7,21
 ecall
    5be6:	00000073          	ecall
 ret
    5bea:	8082                	ret

0000000000005bec <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bec:	4899                	li	a7,6
 ecall
    5bee:	00000073          	ecall
 ret
    5bf2:	8082                	ret

0000000000005bf4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bf4:	489d                	li	a7,7
 ecall
    5bf6:	00000073          	ecall
 ret
    5bfa:	8082                	ret

0000000000005bfc <open>:
.global open
open:
 li a7, SYS_open
    5bfc:	48bd                	li	a7,15
 ecall
    5bfe:	00000073          	ecall
 ret
    5c02:	8082                	ret

0000000000005c04 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c04:	48c5                	li	a7,17
 ecall
    5c06:	00000073          	ecall
 ret
    5c0a:	8082                	ret

0000000000005c0c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c0c:	48c9                	li	a7,18
 ecall
    5c0e:	00000073          	ecall
 ret
    5c12:	8082                	ret

0000000000005c14 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c14:	48a1                	li	a7,8
 ecall
    5c16:	00000073          	ecall
 ret
    5c1a:	8082                	ret

0000000000005c1c <link>:
.global link
link:
 li a7, SYS_link
    5c1c:	48cd                	li	a7,19
 ecall
    5c1e:	00000073          	ecall
 ret
    5c22:	8082                	ret

0000000000005c24 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c24:	48d1                	li	a7,20
 ecall
    5c26:	00000073          	ecall
 ret
    5c2a:	8082                	ret

0000000000005c2c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c2c:	48a5                	li	a7,9
 ecall
    5c2e:	00000073          	ecall
 ret
    5c32:	8082                	ret

0000000000005c34 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c34:	48a9                	li	a7,10
 ecall
    5c36:	00000073          	ecall
 ret
    5c3a:	8082                	ret

0000000000005c3c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c3c:	48ad                	li	a7,11
 ecall
    5c3e:	00000073          	ecall
 ret
    5c42:	8082                	ret

0000000000005c44 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c44:	48b1                	li	a7,12
 ecall
    5c46:	00000073          	ecall
 ret
    5c4a:	8082                	ret

0000000000005c4c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c4c:	48b5                	li	a7,13
 ecall
    5c4e:	00000073          	ecall
 ret
    5c52:	8082                	ret

0000000000005c54 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c54:	48b9                	li	a7,14
 ecall
    5c56:	00000073          	ecall
 ret
    5c5a:	8082                	ret

0000000000005c5c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c5c:	1101                	add	sp,sp,-32
    5c5e:	ec06                	sd	ra,24(sp)
    5c60:	e822                	sd	s0,16(sp)
    5c62:	1000                	add	s0,sp,32
    5c64:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c68:	4605                	li	a2,1
    5c6a:	fef40593          	add	a1,s0,-17
    5c6e:	00000097          	auipc	ra,0x0
    5c72:	f6e080e7          	jalr	-146(ra) # 5bdc <write>
}
    5c76:	60e2                	ld	ra,24(sp)
    5c78:	6442                	ld	s0,16(sp)
    5c7a:	6105                	add	sp,sp,32
    5c7c:	8082                	ret

0000000000005c7e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c7e:	7139                	add	sp,sp,-64
    5c80:	fc06                	sd	ra,56(sp)
    5c82:	f822                	sd	s0,48(sp)
    5c84:	f426                	sd	s1,40(sp)
    5c86:	f04a                	sd	s2,32(sp)
    5c88:	ec4e                	sd	s3,24(sp)
    5c8a:	0080                	add	s0,sp,64
    5c8c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5c8e:	c299                	beqz	a3,5c94 <printint+0x16>
    5c90:	0805c963          	bltz	a1,5d22 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5c94:	2581                	sext.w	a1,a1
  neg = 0;
    5c96:	4881                	li	a7,0
    5c98:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    5c9c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5c9e:	2601                	sext.w	a2,a2
    5ca0:	00003517          	auipc	a0,0x3
    5ca4:	90850513          	add	a0,a0,-1784 # 85a8 <digits>
    5ca8:	883a                	mv	a6,a4
    5caa:	2705                	addw	a4,a4,1
    5cac:	02c5f7bb          	remuw	a5,a1,a2
    5cb0:	1782                	sll	a5,a5,0x20
    5cb2:	9381                	srl	a5,a5,0x20
    5cb4:	97aa                	add	a5,a5,a0
    5cb6:	0007c783          	lbu	a5,0(a5)
    5cba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cbe:	0005879b          	sext.w	a5,a1
    5cc2:	02c5d5bb          	divuw	a1,a1,a2
    5cc6:	0685                	add	a3,a3,1
    5cc8:	fec7f0e3          	bgeu	a5,a2,5ca8 <printint+0x2a>
  if(neg)
    5ccc:	00088c63          	beqz	a7,5ce4 <printint+0x66>
    buf[i++] = '-';
    5cd0:	fd070793          	add	a5,a4,-48
    5cd4:	00878733          	add	a4,a5,s0
    5cd8:	02d00793          	li	a5,45
    5cdc:	fef70823          	sb	a5,-16(a4)
    5ce0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5ce4:	02e05863          	blez	a4,5d14 <printint+0x96>
    5ce8:	fc040793          	add	a5,s0,-64
    5cec:	00e78933          	add	s2,a5,a4
    5cf0:	fff78993          	add	s3,a5,-1
    5cf4:	99ba                	add	s3,s3,a4
    5cf6:	377d                	addw	a4,a4,-1
    5cf8:	1702                	sll	a4,a4,0x20
    5cfa:	9301                	srl	a4,a4,0x20
    5cfc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d00:	fff94583          	lbu	a1,-1(s2)
    5d04:	8526                	mv	a0,s1
    5d06:	00000097          	auipc	ra,0x0
    5d0a:	f56080e7          	jalr	-170(ra) # 5c5c <putc>
  while(--i >= 0)
    5d0e:	197d                	add	s2,s2,-1
    5d10:	ff3918e3          	bne	s2,s3,5d00 <printint+0x82>
}
    5d14:	70e2                	ld	ra,56(sp)
    5d16:	7442                	ld	s0,48(sp)
    5d18:	74a2                	ld	s1,40(sp)
    5d1a:	7902                	ld	s2,32(sp)
    5d1c:	69e2                	ld	s3,24(sp)
    5d1e:	6121                	add	sp,sp,64
    5d20:	8082                	ret
    x = -xx;
    5d22:	40b005bb          	negw	a1,a1
    neg = 1;
    5d26:	4885                	li	a7,1
    x = -xx;
    5d28:	bf85                	j	5c98 <printint+0x1a>

0000000000005d2a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d2a:	715d                	add	sp,sp,-80
    5d2c:	e486                	sd	ra,72(sp)
    5d2e:	e0a2                	sd	s0,64(sp)
    5d30:	fc26                	sd	s1,56(sp)
    5d32:	f84a                	sd	s2,48(sp)
    5d34:	f44e                	sd	s3,40(sp)
    5d36:	f052                	sd	s4,32(sp)
    5d38:	ec56                	sd	s5,24(sp)
    5d3a:	e85a                	sd	s6,16(sp)
    5d3c:	e45e                	sd	s7,8(sp)
    5d3e:	e062                	sd	s8,0(sp)
    5d40:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d42:	0005c903          	lbu	s2,0(a1)
    5d46:	18090c63          	beqz	s2,5ede <vprintf+0x1b4>
    5d4a:	8aaa                	mv	s5,a0
    5d4c:	8bb2                	mv	s7,a2
    5d4e:	00158493          	add	s1,a1,1
  state = 0;
    5d52:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d54:	02500a13          	li	s4,37
    5d58:	4b55                	li	s6,21
    5d5a:	a839                	j	5d78 <vprintf+0x4e>
        putc(fd, c);
    5d5c:	85ca                	mv	a1,s2
    5d5e:	8556                	mv	a0,s5
    5d60:	00000097          	auipc	ra,0x0
    5d64:	efc080e7          	jalr	-260(ra) # 5c5c <putc>
    5d68:	a019                	j	5d6e <vprintf+0x44>
    } else if(state == '%'){
    5d6a:	01498d63          	beq	s3,s4,5d84 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    5d6e:	0485                	add	s1,s1,1
    5d70:	fff4c903          	lbu	s2,-1(s1)
    5d74:	16090563          	beqz	s2,5ede <vprintf+0x1b4>
    if(state == 0){
    5d78:	fe0999e3          	bnez	s3,5d6a <vprintf+0x40>
      if(c == '%'){
    5d7c:	ff4910e3          	bne	s2,s4,5d5c <vprintf+0x32>
        state = '%';
    5d80:	89d2                	mv	s3,s4
    5d82:	b7f5                	j	5d6e <vprintf+0x44>
      if(c == 'd'){
    5d84:	13490263          	beq	s2,s4,5ea8 <vprintf+0x17e>
    5d88:	f9d9079b          	addw	a5,s2,-99
    5d8c:	0ff7f793          	zext.b	a5,a5
    5d90:	12fb6563          	bltu	s6,a5,5eba <vprintf+0x190>
    5d94:	f9d9079b          	addw	a5,s2,-99
    5d98:	0ff7f713          	zext.b	a4,a5
    5d9c:	10eb6f63          	bltu	s6,a4,5eba <vprintf+0x190>
    5da0:	00271793          	sll	a5,a4,0x2
    5da4:	00002717          	auipc	a4,0x2
    5da8:	7ac70713          	add	a4,a4,1964 # 8550 <malloc+0x2574>
    5dac:	97ba                	add	a5,a5,a4
    5dae:	439c                	lw	a5,0(a5)
    5db0:	97ba                	add	a5,a5,a4
    5db2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5db4:	008b8913          	add	s2,s7,8
    5db8:	4685                	li	a3,1
    5dba:	4629                	li	a2,10
    5dbc:	000ba583          	lw	a1,0(s7)
    5dc0:	8556                	mv	a0,s5
    5dc2:	00000097          	auipc	ra,0x0
    5dc6:	ebc080e7          	jalr	-324(ra) # 5c7e <printint>
    5dca:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5dcc:	4981                	li	s3,0
    5dce:	b745                	j	5d6e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dd0:	008b8913          	add	s2,s7,8
    5dd4:	4681                	li	a3,0
    5dd6:	4629                	li	a2,10
    5dd8:	000ba583          	lw	a1,0(s7)
    5ddc:	8556                	mv	a0,s5
    5dde:	00000097          	auipc	ra,0x0
    5de2:	ea0080e7          	jalr	-352(ra) # 5c7e <printint>
    5de6:	8bca                	mv	s7,s2
      state = 0;
    5de8:	4981                	li	s3,0
    5dea:	b751                	j	5d6e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5dec:	008b8913          	add	s2,s7,8
    5df0:	4681                	li	a3,0
    5df2:	4641                	li	a2,16
    5df4:	000ba583          	lw	a1,0(s7)
    5df8:	8556                	mv	a0,s5
    5dfa:	00000097          	auipc	ra,0x0
    5dfe:	e84080e7          	jalr	-380(ra) # 5c7e <printint>
    5e02:	8bca                	mv	s7,s2
      state = 0;
    5e04:	4981                	li	s3,0
    5e06:	b7a5                	j	5d6e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    5e08:	008b8c13          	add	s8,s7,8
    5e0c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5e10:	03000593          	li	a1,48
    5e14:	8556                	mv	a0,s5
    5e16:	00000097          	auipc	ra,0x0
    5e1a:	e46080e7          	jalr	-442(ra) # 5c5c <putc>
  putc(fd, 'x');
    5e1e:	07800593          	li	a1,120
    5e22:	8556                	mv	a0,s5
    5e24:	00000097          	auipc	ra,0x0
    5e28:	e38080e7          	jalr	-456(ra) # 5c5c <putc>
    5e2c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e2e:	00002b97          	auipc	s7,0x2
    5e32:	77ab8b93          	add	s7,s7,1914 # 85a8 <digits>
    5e36:	03c9d793          	srl	a5,s3,0x3c
    5e3a:	97de                	add	a5,a5,s7
    5e3c:	0007c583          	lbu	a1,0(a5)
    5e40:	8556                	mv	a0,s5
    5e42:	00000097          	auipc	ra,0x0
    5e46:	e1a080e7          	jalr	-486(ra) # 5c5c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e4a:	0992                	sll	s3,s3,0x4
    5e4c:	397d                	addw	s2,s2,-1
    5e4e:	fe0914e3          	bnez	s2,5e36 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5e52:	8be2                	mv	s7,s8
      state = 0;
    5e54:	4981                	li	s3,0
    5e56:	bf21                	j	5d6e <vprintf+0x44>
        s = va_arg(ap, char*);
    5e58:	008b8993          	add	s3,s7,8
    5e5c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5e60:	02090163          	beqz	s2,5e82 <vprintf+0x158>
        while(*s != 0){
    5e64:	00094583          	lbu	a1,0(s2)
    5e68:	c9a5                	beqz	a1,5ed8 <vprintf+0x1ae>
          putc(fd, *s);
    5e6a:	8556                	mv	a0,s5
    5e6c:	00000097          	auipc	ra,0x0
    5e70:	df0080e7          	jalr	-528(ra) # 5c5c <putc>
          s++;
    5e74:	0905                	add	s2,s2,1
        while(*s != 0){
    5e76:	00094583          	lbu	a1,0(s2)
    5e7a:	f9e5                	bnez	a1,5e6a <vprintf+0x140>
        s = va_arg(ap, char*);
    5e7c:	8bce                	mv	s7,s3
      state = 0;
    5e7e:	4981                	li	s3,0
    5e80:	b5fd                	j	5d6e <vprintf+0x44>
          s = "(null)";
    5e82:	00002917          	auipc	s2,0x2
    5e86:	6c690913          	add	s2,s2,1734 # 8548 <malloc+0x256c>
        while(*s != 0){
    5e8a:	02800593          	li	a1,40
    5e8e:	bff1                	j	5e6a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    5e90:	008b8913          	add	s2,s7,8
    5e94:	000bc583          	lbu	a1,0(s7)
    5e98:	8556                	mv	a0,s5
    5e9a:	00000097          	auipc	ra,0x0
    5e9e:	dc2080e7          	jalr	-574(ra) # 5c5c <putc>
    5ea2:	8bca                	mv	s7,s2
      state = 0;
    5ea4:	4981                	li	s3,0
    5ea6:	b5e1                	j	5d6e <vprintf+0x44>
        putc(fd, c);
    5ea8:	02500593          	li	a1,37
    5eac:	8556                	mv	a0,s5
    5eae:	00000097          	auipc	ra,0x0
    5eb2:	dae080e7          	jalr	-594(ra) # 5c5c <putc>
      state = 0;
    5eb6:	4981                	li	s3,0
    5eb8:	bd5d                	j	5d6e <vprintf+0x44>
        putc(fd, '%');
    5eba:	02500593          	li	a1,37
    5ebe:	8556                	mv	a0,s5
    5ec0:	00000097          	auipc	ra,0x0
    5ec4:	d9c080e7          	jalr	-612(ra) # 5c5c <putc>
        putc(fd, c);
    5ec8:	85ca                	mv	a1,s2
    5eca:	8556                	mv	a0,s5
    5ecc:	00000097          	auipc	ra,0x0
    5ed0:	d90080e7          	jalr	-624(ra) # 5c5c <putc>
      state = 0;
    5ed4:	4981                	li	s3,0
    5ed6:	bd61                	j	5d6e <vprintf+0x44>
        s = va_arg(ap, char*);
    5ed8:	8bce                	mv	s7,s3
      state = 0;
    5eda:	4981                	li	s3,0
    5edc:	bd49                	j	5d6e <vprintf+0x44>
    }
  }
}
    5ede:	60a6                	ld	ra,72(sp)
    5ee0:	6406                	ld	s0,64(sp)
    5ee2:	74e2                	ld	s1,56(sp)
    5ee4:	7942                	ld	s2,48(sp)
    5ee6:	79a2                	ld	s3,40(sp)
    5ee8:	7a02                	ld	s4,32(sp)
    5eea:	6ae2                	ld	s5,24(sp)
    5eec:	6b42                	ld	s6,16(sp)
    5eee:	6ba2                	ld	s7,8(sp)
    5ef0:	6c02                	ld	s8,0(sp)
    5ef2:	6161                	add	sp,sp,80
    5ef4:	8082                	ret

0000000000005ef6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ef6:	715d                	add	sp,sp,-80
    5ef8:	ec06                	sd	ra,24(sp)
    5efa:	e822                	sd	s0,16(sp)
    5efc:	1000                	add	s0,sp,32
    5efe:	e010                	sd	a2,0(s0)
    5f00:	e414                	sd	a3,8(s0)
    5f02:	e818                	sd	a4,16(s0)
    5f04:	ec1c                	sd	a5,24(s0)
    5f06:	03043023          	sd	a6,32(s0)
    5f0a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f0e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f12:	8622                	mv	a2,s0
    5f14:	00000097          	auipc	ra,0x0
    5f18:	e16080e7          	jalr	-490(ra) # 5d2a <vprintf>
}
    5f1c:	60e2                	ld	ra,24(sp)
    5f1e:	6442                	ld	s0,16(sp)
    5f20:	6161                	add	sp,sp,80
    5f22:	8082                	ret

0000000000005f24 <printf>:

void
printf(const char *fmt, ...)
{
    5f24:	711d                	add	sp,sp,-96
    5f26:	ec06                	sd	ra,24(sp)
    5f28:	e822                	sd	s0,16(sp)
    5f2a:	1000                	add	s0,sp,32
    5f2c:	e40c                	sd	a1,8(s0)
    5f2e:	e810                	sd	a2,16(s0)
    5f30:	ec14                	sd	a3,24(s0)
    5f32:	f018                	sd	a4,32(s0)
    5f34:	f41c                	sd	a5,40(s0)
    5f36:	03043823          	sd	a6,48(s0)
    5f3a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f3e:	00840613          	add	a2,s0,8
    5f42:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f46:	85aa                	mv	a1,a0
    5f48:	4505                	li	a0,1
    5f4a:	00000097          	auipc	ra,0x0
    5f4e:	de0080e7          	jalr	-544(ra) # 5d2a <vprintf>
}
    5f52:	60e2                	ld	ra,24(sp)
    5f54:	6442                	ld	s0,16(sp)
    5f56:	6125                	add	sp,sp,96
    5f58:	8082                	ret

0000000000005f5a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f5a:	1141                	add	sp,sp,-16
    5f5c:	e422                	sd	s0,8(sp)
    5f5e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f60:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f64:	00003797          	auipc	a5,0x3
    5f68:	4ec7b783          	ld	a5,1260(a5) # 9450 <freep>
    5f6c:	a02d                	j	5f96 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f6e:	4618                	lw	a4,8(a2)
    5f70:	9f2d                	addw	a4,a4,a1
    5f72:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f76:	6398                	ld	a4,0(a5)
    5f78:	6310                	ld	a2,0(a4)
    5f7a:	a83d                	j	5fb8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5f7c:	ff852703          	lw	a4,-8(a0)
    5f80:	9f31                	addw	a4,a4,a2
    5f82:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5f84:	ff053683          	ld	a3,-16(a0)
    5f88:	a091                	j	5fcc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f8a:	6398                	ld	a4,0(a5)
    5f8c:	00e7e463          	bltu	a5,a4,5f94 <free+0x3a>
    5f90:	00e6ea63          	bltu	a3,a4,5fa4 <free+0x4a>
{
    5f94:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f96:	fed7fae3          	bgeu	a5,a3,5f8a <free+0x30>
    5f9a:	6398                	ld	a4,0(a5)
    5f9c:	00e6e463          	bltu	a3,a4,5fa4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fa0:	fee7eae3          	bltu	a5,a4,5f94 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5fa4:	ff852583          	lw	a1,-8(a0)
    5fa8:	6390                	ld	a2,0(a5)
    5faa:	02059813          	sll	a6,a1,0x20
    5fae:	01c85713          	srl	a4,a6,0x1c
    5fb2:	9736                	add	a4,a4,a3
    5fb4:	fae60de3          	beq	a2,a4,5f6e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5fb8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fbc:	4790                	lw	a2,8(a5)
    5fbe:	02061593          	sll	a1,a2,0x20
    5fc2:	01c5d713          	srl	a4,a1,0x1c
    5fc6:	973e                	add	a4,a4,a5
    5fc8:	fae68ae3          	beq	a3,a4,5f7c <free+0x22>
    p->s.ptr = bp->s.ptr;
    5fcc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5fce:	00003717          	auipc	a4,0x3
    5fd2:	48f73123          	sd	a5,1154(a4) # 9450 <freep>
}
    5fd6:	6422                	ld	s0,8(sp)
    5fd8:	0141                	add	sp,sp,16
    5fda:	8082                	ret

0000000000005fdc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5fdc:	7139                	add	sp,sp,-64
    5fde:	fc06                	sd	ra,56(sp)
    5fe0:	f822                	sd	s0,48(sp)
    5fe2:	f426                	sd	s1,40(sp)
    5fe4:	f04a                	sd	s2,32(sp)
    5fe6:	ec4e                	sd	s3,24(sp)
    5fe8:	e852                	sd	s4,16(sp)
    5fea:	e456                	sd	s5,8(sp)
    5fec:	e05a                	sd	s6,0(sp)
    5fee:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5ff0:	02051493          	sll	s1,a0,0x20
    5ff4:	9081                	srl	s1,s1,0x20
    5ff6:	04bd                	add	s1,s1,15
    5ff8:	8091                	srl	s1,s1,0x4
    5ffa:	0014899b          	addw	s3,s1,1
    5ffe:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    6000:	00003517          	auipc	a0,0x3
    6004:	45053503          	ld	a0,1104(a0) # 9450 <freep>
    6008:	c515                	beqz	a0,6034 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    600a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    600c:	4798                	lw	a4,8(a5)
    600e:	02977f63          	bgeu	a4,s1,604c <malloc+0x70>
  if(nu < 4096)
    6012:	8a4e                	mv	s4,s3
    6014:	0009871b          	sext.w	a4,s3
    6018:	6685                	lui	a3,0x1
    601a:	00d77363          	bgeu	a4,a3,6020 <malloc+0x44>
    601e:	6a05                	lui	s4,0x1
    6020:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6024:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6028:	00003917          	auipc	s2,0x3
    602c:	42890913          	add	s2,s2,1064 # 9450 <freep>
  if(p == (char*)-1)
    6030:	5afd                	li	s5,-1
    6032:	a895                	j	60a6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    6034:	0000a797          	auipc	a5,0xa
    6038:	c4478793          	add	a5,a5,-956 # fc78 <base>
    603c:	00003717          	auipc	a4,0x3
    6040:	40f73a23          	sd	a5,1044(a4) # 9450 <freep>
    6044:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6046:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    604a:	b7e1                	j	6012 <malloc+0x36>
      if(p->s.size == nunits)
    604c:	02e48c63          	beq	s1,a4,6084 <malloc+0xa8>
        p->s.size -= nunits;
    6050:	4137073b          	subw	a4,a4,s3
    6054:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6056:	02071693          	sll	a3,a4,0x20
    605a:	01c6d713          	srl	a4,a3,0x1c
    605e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6060:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6064:	00003717          	auipc	a4,0x3
    6068:	3ea73623          	sd	a0,1004(a4) # 9450 <freep>
      return (void*)(p + 1);
    606c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6070:	70e2                	ld	ra,56(sp)
    6072:	7442                	ld	s0,48(sp)
    6074:	74a2                	ld	s1,40(sp)
    6076:	7902                	ld	s2,32(sp)
    6078:	69e2                	ld	s3,24(sp)
    607a:	6a42                	ld	s4,16(sp)
    607c:	6aa2                	ld	s5,8(sp)
    607e:	6b02                	ld	s6,0(sp)
    6080:	6121                	add	sp,sp,64
    6082:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    6084:	6398                	ld	a4,0(a5)
    6086:	e118                	sd	a4,0(a0)
    6088:	bff1                	j	6064 <malloc+0x88>
  hp->s.size = nu;
    608a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    608e:	0541                	add	a0,a0,16
    6090:	00000097          	auipc	ra,0x0
    6094:	eca080e7          	jalr	-310(ra) # 5f5a <free>
  return freep;
    6098:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    609c:	d971                	beqz	a0,6070 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    609e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60a0:	4798                	lw	a4,8(a5)
    60a2:	fa9775e3          	bgeu	a4,s1,604c <malloc+0x70>
    if(p == freep)
    60a6:	00093703          	ld	a4,0(s2)
    60aa:	853e                	mv	a0,a5
    60ac:	fef719e3          	bne	a4,a5,609e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    60b0:	8552                	mv	a0,s4
    60b2:	00000097          	auipc	ra,0x0
    60b6:	b92080e7          	jalr	-1134(ra) # 5c44 <sbrk>
  if(p == (char*)-1)
    60ba:	fd5518e3          	bne	a0,s5,608a <malloc+0xae>
        return 0;
    60be:	4501                	li	a0,0
    60c0:	bf45                	j	6070 <malloc+0x94>
