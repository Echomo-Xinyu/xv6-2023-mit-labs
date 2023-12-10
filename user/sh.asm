
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	add	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	add	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	2ee58593          	add	a1,a1,750 # 1300 <malloc+0xea>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	dfa080e7          	jalr	-518(ra) # e16 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	bd2080e7          	jalr	-1070(ra) # bfc <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c0c080e7          	jalr	-1012(ra) # c42 <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	add	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	add	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	add	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	2a858593          	add	a1,a1,680 # 1308 <malloc+0xf2>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	0c6080e7          	jalr	198(ra) # 1130 <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	d82080e7          	jalr	-638(ra) # df6 <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	add	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	add	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	d6a080e7          	jalr	-662(ra) # dee <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	add	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	27650513          	add	a0,a0,630 # 1310 <malloc+0xfa>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	add	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	ec26                	sd	s1,24(sp)
      b2:	1800                	add	s0,sp,48
  if(cmd == 0)
      b4:	c10d                	beqz	a0,d6 <runcmd+0x2c>
      b6:	84aa                	mv	s1,a0
  switch(cmd->type){
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e263          	bltu	a5,a4,e0 <runcmd+0x36>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	sll	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	34a70713          	add	a4,a4,842 # 1410 <malloc+0x1fa>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00001097          	auipc	ra,0x1
      dc:	d1e080e7          	jalr	-738(ra) # df6 <exit>
    panic("runcmd");
      e0:	00001517          	auipc	a0,0x1
      e4:	23850513          	add	a0,a0,568 # 1318 <malloc+0x102>
      e8:	00000097          	auipc	ra,0x0
      ec:	f6e080e7          	jalr	-146(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
      f0:	6508                	ld	a0,8(a0)
      f2:	c515                	beqz	a0,11e <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f4:	00848593          	add	a1,s1,8
      f8:	00001097          	auipc	ra,0x1
      fc:	d36080e7          	jalr	-714(ra) # e2e <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     100:	6490                	ld	a2,8(s1)
     102:	00001597          	auipc	a1,0x1
     106:	21e58593          	add	a1,a1,542 # 1320 <malloc+0x10a>
     10a:	4509                	li	a0,2
     10c:	00001097          	auipc	ra,0x1
     110:	024080e7          	jalr	36(ra) # 1130 <fprintf>
  exit(0);
     114:	4501                	li	a0,0
     116:	00001097          	auipc	ra,0x1
     11a:	ce0080e7          	jalr	-800(ra) # df6 <exit>
      exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	cd6080e7          	jalr	-810(ra) # df6 <exit>
    close(rcmd->fd);
     128:	5148                	lw	a0,36(a0)
     12a:	00001097          	auipc	ra,0x1
     12e:	cf4080e7          	jalr	-780(ra) # e1e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     132:	508c                	lw	a1,32(s1)
     134:	6888                	ld	a0,16(s1)
     136:	00001097          	auipc	ra,0x1
     13a:	d00080e7          	jalr	-768(ra) # e36 <open>
     13e:	00054763          	bltz	a0,14c <runcmd+0xa2>
    runcmd(rcmd->cmd);
     142:	6488                	ld	a0,8(s1)
     144:	00000097          	auipc	ra,0x0
     148:	f66080e7          	jalr	-154(ra) # aa <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14c:	6890                	ld	a2,16(s1)
     14e:	00001597          	auipc	a1,0x1
     152:	1e258593          	add	a1,a1,482 # 1330 <malloc+0x11a>
     156:	4509                	li	a0,2
     158:	00001097          	auipc	ra,0x1
     15c:	fd8080e7          	jalr	-40(ra) # 1130 <fprintf>
      exit(1);
     160:	4505                	li	a0,1
     162:	00001097          	auipc	ra,0x1
     166:	c94080e7          	jalr	-876(ra) # df6 <exit>
    if(fork1() == 0)
     16a:	00000097          	auipc	ra,0x0
     16e:	f12080e7          	jalr	-238(ra) # 7c <fork1>
     172:	e511                	bnez	a0,17e <runcmd+0xd4>
      runcmd(lcmd->left);
     174:	6488                	ld	a0,8(s1)
     176:	00000097          	auipc	ra,0x0
     17a:	f34080e7          	jalr	-204(ra) # aa <runcmd>
    wait(0);
     17e:	4501                	li	a0,0
     180:	00001097          	auipc	ra,0x1
     184:	c7e080e7          	jalr	-898(ra) # dfe <wait>
    runcmd(lcmd->right);
     188:	6888                	ld	a0,16(s1)
     18a:	00000097          	auipc	ra,0x0
     18e:	f20080e7          	jalr	-224(ra) # aa <runcmd>
    if(pipe(p) < 0)
     192:	fd840513          	add	a0,s0,-40
     196:	00001097          	auipc	ra,0x1
     19a:	c70080e7          	jalr	-912(ra) # e06 <pipe>
     19e:	04054363          	bltz	a0,1e4 <runcmd+0x13a>
    if(fork1() == 0){
     1a2:	00000097          	auipc	ra,0x0
     1a6:	eda080e7          	jalr	-294(ra) # 7c <fork1>
     1aa:	e529                	bnez	a0,1f4 <runcmd+0x14a>
      close(1);
     1ac:	4505                	li	a0,1
     1ae:	00001097          	auipc	ra,0x1
     1b2:	c70080e7          	jalr	-912(ra) # e1e <close>
      dup(p[1]);
     1b6:	fdc42503          	lw	a0,-36(s0)
     1ba:	00001097          	auipc	ra,0x1
     1be:	cb4080e7          	jalr	-844(ra) # e6e <dup>
      close(p[0]);
     1c2:	fd842503          	lw	a0,-40(s0)
     1c6:	00001097          	auipc	ra,0x1
     1ca:	c58080e7          	jalr	-936(ra) # e1e <close>
      close(p[1]);
     1ce:	fdc42503          	lw	a0,-36(s0)
     1d2:	00001097          	auipc	ra,0x1
     1d6:	c4c080e7          	jalr	-948(ra) # e1e <close>
      runcmd(pcmd->left);
     1da:	6488                	ld	a0,8(s1)
     1dc:	00000097          	auipc	ra,0x0
     1e0:	ece080e7          	jalr	-306(ra) # aa <runcmd>
      panic("pipe");
     1e4:	00001517          	auipc	a0,0x1
     1e8:	15c50513          	add	a0,a0,348 # 1340 <malloc+0x12a>
     1ec:	00000097          	auipc	ra,0x0
     1f0:	e6a080e7          	jalr	-406(ra) # 56 <panic>
    if(fork1() == 0){
     1f4:	00000097          	auipc	ra,0x0
     1f8:	e88080e7          	jalr	-376(ra) # 7c <fork1>
     1fc:	ed05                	bnez	a0,234 <runcmd+0x18a>
      close(0);
     1fe:	00001097          	auipc	ra,0x1
     202:	c20080e7          	jalr	-992(ra) # e1e <close>
      dup(p[0]);
     206:	fd842503          	lw	a0,-40(s0)
     20a:	00001097          	auipc	ra,0x1
     20e:	c64080e7          	jalr	-924(ra) # e6e <dup>
      close(p[0]);
     212:	fd842503          	lw	a0,-40(s0)
     216:	00001097          	auipc	ra,0x1
     21a:	c08080e7          	jalr	-1016(ra) # e1e <close>
      close(p[1]);
     21e:	fdc42503          	lw	a0,-36(s0)
     222:	00001097          	auipc	ra,0x1
     226:	bfc080e7          	jalr	-1028(ra) # e1e <close>
      runcmd(pcmd->right);
     22a:	6888                	ld	a0,16(s1)
     22c:	00000097          	auipc	ra,0x0
     230:	e7e080e7          	jalr	-386(ra) # aa <runcmd>
    close(p[0]);
     234:	fd842503          	lw	a0,-40(s0)
     238:	00001097          	auipc	ra,0x1
     23c:	be6080e7          	jalr	-1050(ra) # e1e <close>
    close(p[1]);
     240:	fdc42503          	lw	a0,-36(s0)
     244:	00001097          	auipc	ra,0x1
     248:	bda080e7          	jalr	-1062(ra) # e1e <close>
    wait(0);
     24c:	4501                	li	a0,0
     24e:	00001097          	auipc	ra,0x1
     252:	bb0080e7          	jalr	-1104(ra) # dfe <wait>
    wait(0);
     256:	4501                	li	a0,0
     258:	00001097          	auipc	ra,0x1
     25c:	ba6080e7          	jalr	-1114(ra) # dfe <wait>
    break;
     260:	bd55                	j	114 <runcmd+0x6a>
    if(fork1() == 0)
     262:	00000097          	auipc	ra,0x0
     266:	e1a080e7          	jalr	-486(ra) # 7c <fork1>
     26a:	ea0515e3          	bnez	a0,114 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     26e:	6488                	ld	a0,8(s1)
     270:	00000097          	auipc	ra,0x0
     274:	e3a080e7          	jalr	-454(ra) # aa <runcmd>

0000000000000278 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     278:	1101                	add	sp,sp,-32
     27a:	ec06                	sd	ra,24(sp)
     27c:	e822                	sd	s0,16(sp)
     27e:	e426                	sd	s1,8(sp)
     280:	1000                	add	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     282:	0a800513          	li	a0,168
     286:	00001097          	auipc	ra,0x1
     28a:	f90080e7          	jalr	-112(ra) # 1216 <malloc>
     28e:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     290:	0a800613          	li	a2,168
     294:	4581                	li	a1,0
     296:	00001097          	auipc	ra,0x1
     29a:	966080e7          	jalr	-1690(ra) # bfc <memset>
  cmd->type = EXEC;
     29e:	4785                	li	a5,1
     2a0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a2:	8526                	mv	a0,s1
     2a4:	60e2                	ld	ra,24(sp)
     2a6:	6442                	ld	s0,16(sp)
     2a8:	64a2                	ld	s1,8(sp)
     2aa:	6105                	add	sp,sp,32
     2ac:	8082                	ret

00000000000002ae <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ae:	7139                	add	sp,sp,-64
     2b0:	fc06                	sd	ra,56(sp)
     2b2:	f822                	sd	s0,48(sp)
     2b4:	f426                	sd	s1,40(sp)
     2b6:	f04a                	sd	s2,32(sp)
     2b8:	ec4e                	sd	s3,24(sp)
     2ba:	e852                	sd	s4,16(sp)
     2bc:	e456                	sd	s5,8(sp)
     2be:	e05a                	sd	s6,0(sp)
     2c0:	0080                	add	s0,sp,64
     2c2:	8b2a                	mv	s6,a0
     2c4:	8aae                	mv	s5,a1
     2c6:	8a32                	mv	s4,a2
     2c8:	89b6                	mv	s3,a3
     2ca:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2cc:	02800513          	li	a0,40
     2d0:	00001097          	auipc	ra,0x1
     2d4:	f46080e7          	jalr	-186(ra) # 1216 <malloc>
     2d8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2da:	02800613          	li	a2,40
     2de:	4581                	li	a1,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	91c080e7          	jalr	-1764(ra) # bfc <memset>
  cmd->type = REDIR;
     2e8:	4789                	li	a5,2
     2ea:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ec:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f0:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f4:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f8:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fc:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	70e2                	ld	ra,56(sp)
     304:	7442                	ld	s0,48(sp)
     306:	74a2                	ld	s1,40(sp)
     308:	7902                	ld	s2,32(sp)
     30a:	69e2                	ld	s3,24(sp)
     30c:	6a42                	ld	s4,16(sp)
     30e:	6aa2                	ld	s5,8(sp)
     310:	6b02                	ld	s6,0(sp)
     312:	6121                	add	sp,sp,64
     314:	8082                	ret

0000000000000316 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     316:	7179                	add	sp,sp,-48
     318:	f406                	sd	ra,40(sp)
     31a:	f022                	sd	s0,32(sp)
     31c:	ec26                	sd	s1,24(sp)
     31e:	e84a                	sd	s2,16(sp)
     320:	e44e                	sd	s3,8(sp)
     322:	1800                	add	s0,sp,48
     324:	89aa                	mv	s3,a0
     326:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     328:	4561                	li	a0,24
     32a:	00001097          	auipc	ra,0x1
     32e:	eec080e7          	jalr	-276(ra) # 1216 <malloc>
     332:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     334:	4661                	li	a2,24
     336:	4581                	li	a1,0
     338:	00001097          	auipc	ra,0x1
     33c:	8c4080e7          	jalr	-1852(ra) # bfc <memset>
  cmd->type = PIPE;
     340:	478d                	li	a5,3
     342:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     344:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     348:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34c:	8526                	mv	a0,s1
     34e:	70a2                	ld	ra,40(sp)
     350:	7402                	ld	s0,32(sp)
     352:	64e2                	ld	s1,24(sp)
     354:	6942                	ld	s2,16(sp)
     356:	69a2                	ld	s3,8(sp)
     358:	6145                	add	sp,sp,48
     35a:	8082                	ret

000000000000035c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35c:	7179                	add	sp,sp,-48
     35e:	f406                	sd	ra,40(sp)
     360:	f022                	sd	s0,32(sp)
     362:	ec26                	sd	s1,24(sp)
     364:	e84a                	sd	s2,16(sp)
     366:	e44e                	sd	s3,8(sp)
     368:	1800                	add	s0,sp,48
     36a:	89aa                	mv	s3,a0
     36c:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36e:	4561                	li	a0,24
     370:	00001097          	auipc	ra,0x1
     374:	ea6080e7          	jalr	-346(ra) # 1216 <malloc>
     378:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37a:	4661                	li	a2,24
     37c:	4581                	li	a1,0
     37e:	00001097          	auipc	ra,0x1
     382:	87e080e7          	jalr	-1922(ra) # bfc <memset>
  cmd->type = LIST;
     386:	4791                	li	a5,4
     388:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38a:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38e:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     392:	8526                	mv	a0,s1
     394:	70a2                	ld	ra,40(sp)
     396:	7402                	ld	s0,32(sp)
     398:	64e2                	ld	s1,24(sp)
     39a:	6942                	ld	s2,16(sp)
     39c:	69a2                	ld	s3,8(sp)
     39e:	6145                	add	sp,sp,48
     3a0:	8082                	ret

00000000000003a2 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a2:	1101                	add	sp,sp,-32
     3a4:	ec06                	sd	ra,24(sp)
     3a6:	e822                	sd	s0,16(sp)
     3a8:	e426                	sd	s1,8(sp)
     3aa:	e04a                	sd	s2,0(sp)
     3ac:	1000                	add	s0,sp,32
     3ae:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b0:	4541                	li	a0,16
     3b2:	00001097          	auipc	ra,0x1
     3b6:	e64080e7          	jalr	-412(ra) # 1216 <malloc>
     3ba:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3bc:	4641                	li	a2,16
     3be:	4581                	li	a1,0
     3c0:	00001097          	auipc	ra,0x1
     3c4:	83c080e7          	jalr	-1988(ra) # bfc <memset>
  cmd->type = BACK;
     3c8:	4795                	li	a5,5
     3ca:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3cc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d0:	8526                	mv	a0,s1
     3d2:	60e2                	ld	ra,24(sp)
     3d4:	6442                	ld	s0,16(sp)
     3d6:	64a2                	ld	s1,8(sp)
     3d8:	6902                	ld	s2,0(sp)
     3da:	6105                	add	sp,sp,32
     3dc:	8082                	ret

00000000000003de <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3de:	7139                	add	sp,sp,-64
     3e0:	fc06                	sd	ra,56(sp)
     3e2:	f822                	sd	s0,48(sp)
     3e4:	f426                	sd	s1,40(sp)
     3e6:	f04a                	sd	s2,32(sp)
     3e8:	ec4e                	sd	s3,24(sp)
     3ea:	e852                	sd	s4,16(sp)
     3ec:	e456                	sd	s5,8(sp)
     3ee:	e05a                	sd	s6,0(sp)
     3f0:	0080                	add	s0,sp,64
     3f2:	8a2a                	mv	s4,a0
     3f4:	892e                	mv	s2,a1
     3f6:	8ab2                	mv	s5,a2
     3f8:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fa:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fc:	00002997          	auipc	s3,0x2
     400:	c0c98993          	add	s3,s3,-1012 # 2008 <whitespace>
     404:	00b4fe63          	bgeu	s1,a1,420 <gettoken+0x42>
     408:	0004c583          	lbu	a1,0(s1)
     40c:	854e                	mv	a0,s3
     40e:	00001097          	auipc	ra,0x1
     412:	810080e7          	jalr	-2032(ra) # c1e <strchr>
     416:	c509                	beqz	a0,420 <gettoken+0x42>
    s++;
     418:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41a:	fe9917e3          	bne	s2,s1,408 <gettoken+0x2a>
    s++;
     41e:	84ca                	mv	s1,s2
  if(q)
     420:	000a8463          	beqz	s5,428 <gettoken+0x4a>
    *q = s;
     424:	009ab023          	sd	s1,0(s5)
  ret = *s;
     428:	0004c783          	lbu	a5,0(s1)
     42c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     430:	03c00713          	li	a4,60
     434:	06f76663          	bltu	a4,a5,4a0 <gettoken+0xc2>
     438:	03a00713          	li	a4,58
     43c:	00f76e63          	bltu	a4,a5,458 <gettoken+0x7a>
     440:	cf89                	beqz	a5,45a <gettoken+0x7c>
     442:	02600713          	li	a4,38
     446:	00e78963          	beq	a5,a4,458 <gettoken+0x7a>
     44a:	fd87879b          	addw	a5,a5,-40
     44e:	0ff7f793          	zext.b	a5,a5
     452:	4705                	li	a4,1
     454:	06f76d63          	bltu	a4,a5,4ce <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     458:	0485                	add	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45a:	000b0463          	beqz	s6,462 <gettoken+0x84>
    *eq = s;
     45e:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     462:	00002997          	auipc	s3,0x2
     466:	ba698993          	add	s3,s3,-1114 # 2008 <whitespace>
     46a:	0124fe63          	bgeu	s1,s2,486 <gettoken+0xa8>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	00000097          	auipc	ra,0x0
     478:	7aa080e7          	jalr	1962(ra) # c1e <strchr>
     47c:	c509                	beqz	a0,486 <gettoken+0xa8>
    s++;
     47e:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9917e3          	bne	s2,s1,46e <gettoken+0x90>
    s++;
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48a:	8556                	mv	a0,s5
     48c:	70e2                	ld	ra,56(sp)
     48e:	7442                	ld	s0,48(sp)
     490:	74a2                	ld	s1,40(sp)
     492:	7902                	ld	s2,32(sp)
     494:	69e2                	ld	s3,24(sp)
     496:	6a42                	ld	s4,16(sp)
     498:	6aa2                	ld	s5,8(sp)
     49a:	6b02                	ld	s6,0(sp)
     49c:	6121                	add	sp,sp,64
     49e:	8082                	ret
  switch(*s){
     4a0:	03e00713          	li	a4,62
     4a4:	02e79163          	bne	a5,a4,4c6 <gettoken+0xe8>
    s++;
     4a8:	00148693          	add	a3,s1,1
    if(*s == '>'){
     4ac:	0014c703          	lbu	a4,1(s1)
     4b0:	03e00793          	li	a5,62
      s++;
     4b4:	0489                	add	s1,s1,2
      ret = '+';
     4b6:	02b00a93          	li	s5,43
    if(*s == '>'){
     4ba:	faf700e3          	beq	a4,a5,45a <gettoken+0x7c>
    s++;
     4be:	84b6                	mv	s1,a3
  ret = *s;
     4c0:	03e00a93          	li	s5,62
     4c4:	bf59                	j	45a <gettoken+0x7c>
  switch(*s){
     4c6:	07c00713          	li	a4,124
     4ca:	f8e787e3          	beq	a5,a4,458 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4ce:	00002997          	auipc	s3,0x2
     4d2:	b3a98993          	add	s3,s3,-1222 # 2008 <whitespace>
     4d6:	00002a97          	auipc	s5,0x2
     4da:	b2aa8a93          	add	s5,s5,-1238 # 2000 <symbols>
     4de:	0524f163          	bgeu	s1,s2,520 <gettoken+0x142>
     4e2:	0004c583          	lbu	a1,0(s1)
     4e6:	854e                	mv	a0,s3
     4e8:	00000097          	auipc	ra,0x0
     4ec:	736080e7          	jalr	1846(ra) # c1e <strchr>
     4f0:	e50d                	bnez	a0,51a <gettoken+0x13c>
     4f2:	0004c583          	lbu	a1,0(s1)
     4f6:	8556                	mv	a0,s5
     4f8:	00000097          	auipc	ra,0x0
     4fc:	726080e7          	jalr	1830(ra) # c1e <strchr>
     500:	e911                	bnez	a0,514 <gettoken+0x136>
      s++;
     502:	0485                	add	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     504:	fc991fe3          	bne	s2,s1,4e2 <gettoken+0x104>
      s++;
     508:	84ca                	mv	s1,s2
    ret = 'a';
     50a:	06100a93          	li	s5,97
  if(eq)
     50e:	f40b18e3          	bnez	s6,45e <gettoken+0x80>
     512:	bf95                	j	486 <gettoken+0xa8>
    ret = 'a';
     514:	06100a93          	li	s5,97
     518:	b789                	j	45a <gettoken+0x7c>
     51a:	06100a93          	li	s5,97
     51e:	bf35                	j	45a <gettoken+0x7c>
     520:	06100a93          	li	s5,97
  if(eq)
     524:	f20b1de3          	bnez	s6,45e <gettoken+0x80>
     528:	bfb9                	j	486 <gettoken+0xa8>

000000000000052a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     52a:	7139                	add	sp,sp,-64
     52c:	fc06                	sd	ra,56(sp)
     52e:	f822                	sd	s0,48(sp)
     530:	f426                	sd	s1,40(sp)
     532:	f04a                	sd	s2,32(sp)
     534:	ec4e                	sd	s3,24(sp)
     536:	e852                	sd	s4,16(sp)
     538:	e456                	sd	s5,8(sp)
     53a:	0080                	add	s0,sp,64
     53c:	8a2a                	mv	s4,a0
     53e:	892e                	mv	s2,a1
     540:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     542:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     544:	00002997          	auipc	s3,0x2
     548:	ac498993          	add	s3,s3,-1340 # 2008 <whitespace>
     54c:	00b4fe63          	bgeu	s1,a1,568 <peek+0x3e>
     550:	0004c583          	lbu	a1,0(s1)
     554:	854e                	mv	a0,s3
     556:	00000097          	auipc	ra,0x0
     55a:	6c8080e7          	jalr	1736(ra) # c1e <strchr>
     55e:	c509                	beqz	a0,568 <peek+0x3e>
    s++;
     560:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     562:	fe9917e3          	bne	s2,s1,550 <peek+0x26>
    s++;
     566:	84ca                	mv	s1,s2
  *ps = s;
     568:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56c:	0004c583          	lbu	a1,0(s1)
     570:	4501                	li	a0,0
     572:	e991                	bnez	a1,586 <peek+0x5c>
}
     574:	70e2                	ld	ra,56(sp)
     576:	7442                	ld	s0,48(sp)
     578:	74a2                	ld	s1,40(sp)
     57a:	7902                	ld	s2,32(sp)
     57c:	69e2                	ld	s3,24(sp)
     57e:	6a42                	ld	s4,16(sp)
     580:	6aa2                	ld	s5,8(sp)
     582:	6121                	add	sp,sp,64
     584:	8082                	ret
  return *s && strchr(toks, *s);
     586:	8556                	mv	a0,s5
     588:	00000097          	auipc	ra,0x0
     58c:	696080e7          	jalr	1686(ra) # c1e <strchr>
     590:	00a03533          	snez	a0,a0
     594:	b7c5                	j	574 <peek+0x4a>

0000000000000596 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     596:	7159                	add	sp,sp,-112
     598:	f486                	sd	ra,104(sp)
     59a:	f0a2                	sd	s0,96(sp)
     59c:	eca6                	sd	s1,88(sp)
     59e:	e8ca                	sd	s2,80(sp)
     5a0:	e4ce                	sd	s3,72(sp)
     5a2:	e0d2                	sd	s4,64(sp)
     5a4:	fc56                	sd	s5,56(sp)
     5a6:	f85a                	sd	s6,48(sp)
     5a8:	f45e                	sd	s7,40(sp)
     5aa:	f062                	sd	s8,32(sp)
     5ac:	ec66                	sd	s9,24(sp)
     5ae:	1880                	add	s0,sp,112
     5b0:	8a2a                	mv	s4,a0
     5b2:	89ae                	mv	s3,a1
     5b4:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b6:	00001b97          	auipc	s7,0x1
     5ba:	db2b8b93          	add	s7,s7,-590 # 1368 <malloc+0x152>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5be:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5c2:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5c6:	a02d                	j	5f0 <parseredirs+0x5a>
      panic("missing file for redirection");
     5c8:	00001517          	auipc	a0,0x1
     5cc:	d8050513          	add	a0,a0,-640 # 1348 <malloc+0x132>
     5d0:	00000097          	auipc	ra,0x0
     5d4:	a86080e7          	jalr	-1402(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d8:	4701                	li	a4,0
     5da:	4681                	li	a3,0
     5dc:	f9043603          	ld	a2,-112(s0)
     5e0:	f9843583          	ld	a1,-104(s0)
     5e4:	8552                	mv	a0,s4
     5e6:	00000097          	auipc	ra,0x0
     5ea:	cc8080e7          	jalr	-824(ra) # 2ae <redircmd>
     5ee:	8a2a                	mv	s4,a0
    switch(tok){
     5f0:	03e00b13          	li	s6,62
     5f4:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5f8:	865e                	mv	a2,s7
     5fa:	85ca                	mv	a1,s2
     5fc:	854e                	mv	a0,s3
     5fe:	00000097          	auipc	ra,0x0
     602:	f2c080e7          	jalr	-212(ra) # 52a <peek>
     606:	c925                	beqz	a0,676 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     608:	4681                	li	a3,0
     60a:	4601                	li	a2,0
     60c:	85ca                	mv	a1,s2
     60e:	854e                	mv	a0,s3
     610:	00000097          	auipc	ra,0x0
     614:	dce080e7          	jalr	-562(ra) # 3de <gettoken>
     618:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     61a:	f9040693          	add	a3,s0,-112
     61e:	f9840613          	add	a2,s0,-104
     622:	85ca                	mv	a1,s2
     624:	854e                	mv	a0,s3
     626:	00000097          	auipc	ra,0x0
     62a:	db8080e7          	jalr	-584(ra) # 3de <gettoken>
     62e:	f9851de3          	bne	a0,s8,5c8 <parseredirs+0x32>
    switch(tok){
     632:	fb9483e3          	beq	s1,s9,5d8 <parseredirs+0x42>
     636:	03648263          	beq	s1,s6,65a <parseredirs+0xc4>
     63a:	fb549fe3          	bne	s1,s5,5f8 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     63e:	4705                	li	a4,1
     640:	20100693          	li	a3,513
     644:	f9043603          	ld	a2,-112(s0)
     648:	f9843583          	ld	a1,-104(s0)
     64c:	8552                	mv	a0,s4
     64e:	00000097          	auipc	ra,0x0
     652:	c60080e7          	jalr	-928(ra) # 2ae <redircmd>
     656:	8a2a                	mv	s4,a0
      break;
     658:	bf61                	j	5f0 <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     65a:	4705                	li	a4,1
     65c:	60100693          	li	a3,1537
     660:	f9043603          	ld	a2,-112(s0)
     664:	f9843583          	ld	a1,-104(s0)
     668:	8552                	mv	a0,s4
     66a:	00000097          	auipc	ra,0x0
     66e:	c44080e7          	jalr	-956(ra) # 2ae <redircmd>
     672:	8a2a                	mv	s4,a0
      break;
     674:	bfb5                	j	5f0 <parseredirs+0x5a>
    }
  }
  return cmd;
}
     676:	8552                	mv	a0,s4
     678:	70a6                	ld	ra,104(sp)
     67a:	7406                	ld	s0,96(sp)
     67c:	64e6                	ld	s1,88(sp)
     67e:	6946                	ld	s2,80(sp)
     680:	69a6                	ld	s3,72(sp)
     682:	6a06                	ld	s4,64(sp)
     684:	7ae2                	ld	s5,56(sp)
     686:	7b42                	ld	s6,48(sp)
     688:	7ba2                	ld	s7,40(sp)
     68a:	7c02                	ld	s8,32(sp)
     68c:	6ce2                	ld	s9,24(sp)
     68e:	6165                	add	sp,sp,112
     690:	8082                	ret

0000000000000692 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     692:	7159                	add	sp,sp,-112
     694:	f486                	sd	ra,104(sp)
     696:	f0a2                	sd	s0,96(sp)
     698:	eca6                	sd	s1,88(sp)
     69a:	e8ca                	sd	s2,80(sp)
     69c:	e4ce                	sd	s3,72(sp)
     69e:	e0d2                	sd	s4,64(sp)
     6a0:	fc56                	sd	s5,56(sp)
     6a2:	f85a                	sd	s6,48(sp)
     6a4:	f45e                	sd	s7,40(sp)
     6a6:	f062                	sd	s8,32(sp)
     6a8:	ec66                	sd	s9,24(sp)
     6aa:	1880                	add	s0,sp,112
     6ac:	8a2a                	mv	s4,a0
     6ae:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6b0:	00001617          	auipc	a2,0x1
     6b4:	cc060613          	add	a2,a2,-832 # 1370 <malloc+0x15a>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	e72080e7          	jalr	-398(ra) # 52a <peek>
     6c0:	e905                	bnez	a0,6f0 <parseexec+0x5e>
     6c2:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6c4:	00000097          	auipc	ra,0x0
     6c8:	bb4080e7          	jalr	-1100(ra) # 278 <execcmd>
     6cc:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6ce:	8656                	mv	a2,s5
     6d0:	85d2                	mv	a1,s4
     6d2:	00000097          	auipc	ra,0x0
     6d6:	ec4080e7          	jalr	-316(ra) # 596 <parseredirs>
     6da:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6dc:	008c0913          	add	s2,s8,8
     6e0:	00001b17          	auipc	s6,0x1
     6e4:	cb0b0b13          	add	s6,s6,-848 # 1390 <malloc+0x17a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6e8:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6ec:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6ee:	a0b1                	j	73a <parseexec+0xa8>
    return parseblock(ps, es);
     6f0:	85d6                	mv	a1,s5
     6f2:	8552                	mv	a0,s4
     6f4:	00000097          	auipc	ra,0x0
     6f8:	1bc080e7          	jalr	444(ra) # 8b0 <parseblock>
     6fc:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6fe:	8526                	mv	a0,s1
     700:	70a6                	ld	ra,104(sp)
     702:	7406                	ld	s0,96(sp)
     704:	64e6                	ld	s1,88(sp)
     706:	6946                	ld	s2,80(sp)
     708:	69a6                	ld	s3,72(sp)
     70a:	6a06                	ld	s4,64(sp)
     70c:	7ae2                	ld	s5,56(sp)
     70e:	7b42                	ld	s6,48(sp)
     710:	7ba2                	ld	s7,40(sp)
     712:	7c02                	ld	s8,32(sp)
     714:	6ce2                	ld	s9,24(sp)
     716:	6165                	add	sp,sp,112
     718:	8082                	ret
      panic("syntax");
     71a:	00001517          	auipc	a0,0x1
     71e:	c5e50513          	add	a0,a0,-930 # 1378 <malloc+0x162>
     722:	00000097          	auipc	ra,0x0
     726:	934080e7          	jalr	-1740(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     72a:	8656                	mv	a2,s5
     72c:	85d2                	mv	a1,s4
     72e:	8526                	mv	a0,s1
     730:	00000097          	auipc	ra,0x0
     734:	e66080e7          	jalr	-410(ra) # 596 <parseredirs>
     738:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     73a:	865a                	mv	a2,s6
     73c:	85d6                	mv	a1,s5
     73e:	8552                	mv	a0,s4
     740:	00000097          	auipc	ra,0x0
     744:	dea080e7          	jalr	-534(ra) # 52a <peek>
     748:	e131                	bnez	a0,78c <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     74a:	f9040693          	add	a3,s0,-112
     74e:	f9840613          	add	a2,s0,-104
     752:	85d6                	mv	a1,s5
     754:	8552                	mv	a0,s4
     756:	00000097          	auipc	ra,0x0
     75a:	c88080e7          	jalr	-888(ra) # 3de <gettoken>
     75e:	c51d                	beqz	a0,78c <parseexec+0xfa>
    if(tok != 'a')
     760:	fb951de3          	bne	a0,s9,71a <parseexec+0x88>
    cmd->argv[argc] = q;
     764:	f9843783          	ld	a5,-104(s0)
     768:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     76c:	f9043783          	ld	a5,-112(s0)
     770:	04f93823          	sd	a5,80(s2)
    argc++;
     774:	2985                	addw	s3,s3,1
    if(argc >= MAXARGS)
     776:	0921                	add	s2,s2,8
     778:	fb7999e3          	bne	s3,s7,72a <parseexec+0x98>
      panic("too many args");
     77c:	00001517          	auipc	a0,0x1
     780:	c0450513          	add	a0,a0,-1020 # 1380 <malloc+0x16a>
     784:	00000097          	auipc	ra,0x0
     788:	8d2080e7          	jalr	-1838(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     78c:	098e                	sll	s3,s3,0x3
     78e:	9c4e                	add	s8,s8,s3
     790:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     794:	040c3c23          	sd	zero,88(s8)
  return ret;
     798:	b79d                	j	6fe <parseexec+0x6c>

000000000000079a <parsepipe>:
{
     79a:	7179                	add	sp,sp,-48
     79c:	f406                	sd	ra,40(sp)
     79e:	f022                	sd	s0,32(sp)
     7a0:	ec26                	sd	s1,24(sp)
     7a2:	e84a                	sd	s2,16(sp)
     7a4:	e44e                	sd	s3,8(sp)
     7a6:	1800                	add	s0,sp,48
     7a8:	892a                	mv	s2,a0
     7aa:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7ac:	00000097          	auipc	ra,0x0
     7b0:	ee6080e7          	jalr	-282(ra) # 692 <parseexec>
     7b4:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7b6:	00001617          	auipc	a2,0x1
     7ba:	be260613          	add	a2,a2,-1054 # 1398 <malloc+0x182>
     7be:	85ce                	mv	a1,s3
     7c0:	854a                	mv	a0,s2
     7c2:	00000097          	auipc	ra,0x0
     7c6:	d68080e7          	jalr	-664(ra) # 52a <peek>
     7ca:	e909                	bnez	a0,7dc <parsepipe+0x42>
}
     7cc:	8526                	mv	a0,s1
     7ce:	70a2                	ld	ra,40(sp)
     7d0:	7402                	ld	s0,32(sp)
     7d2:	64e2                	ld	s1,24(sp)
     7d4:	6942                	ld	s2,16(sp)
     7d6:	69a2                	ld	s3,8(sp)
     7d8:	6145                	add	sp,sp,48
     7da:	8082                	ret
    gettoken(ps, es, 0, 0);
     7dc:	4681                	li	a3,0
     7de:	4601                	li	a2,0
     7e0:	85ce                	mv	a1,s3
     7e2:	854a                	mv	a0,s2
     7e4:	00000097          	auipc	ra,0x0
     7e8:	bfa080e7          	jalr	-1030(ra) # 3de <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7ec:	85ce                	mv	a1,s3
     7ee:	854a                	mv	a0,s2
     7f0:	00000097          	auipc	ra,0x0
     7f4:	faa080e7          	jalr	-86(ra) # 79a <parsepipe>
     7f8:	85aa                	mv	a1,a0
     7fa:	8526                	mv	a0,s1
     7fc:	00000097          	auipc	ra,0x0
     800:	b1a080e7          	jalr	-1254(ra) # 316 <pipecmd>
     804:	84aa                	mv	s1,a0
  return cmd;
     806:	b7d9                	j	7cc <parsepipe+0x32>

0000000000000808 <parseline>:
{
     808:	7179                	add	sp,sp,-48
     80a:	f406                	sd	ra,40(sp)
     80c:	f022                	sd	s0,32(sp)
     80e:	ec26                	sd	s1,24(sp)
     810:	e84a                	sd	s2,16(sp)
     812:	e44e                	sd	s3,8(sp)
     814:	e052                	sd	s4,0(sp)
     816:	1800                	add	s0,sp,48
     818:	892a                	mv	s2,a0
     81a:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     81c:	00000097          	auipc	ra,0x0
     820:	f7e080e7          	jalr	-130(ra) # 79a <parsepipe>
     824:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     826:	00001a17          	auipc	s4,0x1
     82a:	b7aa0a13          	add	s4,s4,-1158 # 13a0 <malloc+0x18a>
     82e:	a839                	j	84c <parseline+0x44>
    gettoken(ps, es, 0, 0);
     830:	4681                	li	a3,0
     832:	4601                	li	a2,0
     834:	85ce                	mv	a1,s3
     836:	854a                	mv	a0,s2
     838:	00000097          	auipc	ra,0x0
     83c:	ba6080e7          	jalr	-1114(ra) # 3de <gettoken>
    cmd = backcmd(cmd);
     840:	8526                	mv	a0,s1
     842:	00000097          	auipc	ra,0x0
     846:	b60080e7          	jalr	-1184(ra) # 3a2 <backcmd>
     84a:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     84c:	8652                	mv	a2,s4
     84e:	85ce                	mv	a1,s3
     850:	854a                	mv	a0,s2
     852:	00000097          	auipc	ra,0x0
     856:	cd8080e7          	jalr	-808(ra) # 52a <peek>
     85a:	f979                	bnez	a0,830 <parseline+0x28>
  if(peek(ps, es, ";")){
     85c:	00001617          	auipc	a2,0x1
     860:	b4c60613          	add	a2,a2,-1204 # 13a8 <malloc+0x192>
     864:	85ce                	mv	a1,s3
     866:	854a                	mv	a0,s2
     868:	00000097          	auipc	ra,0x0
     86c:	cc2080e7          	jalr	-830(ra) # 52a <peek>
     870:	e911                	bnez	a0,884 <parseline+0x7c>
}
     872:	8526                	mv	a0,s1
     874:	70a2                	ld	ra,40(sp)
     876:	7402                	ld	s0,32(sp)
     878:	64e2                	ld	s1,24(sp)
     87a:	6942                	ld	s2,16(sp)
     87c:	69a2                	ld	s3,8(sp)
     87e:	6a02                	ld	s4,0(sp)
     880:	6145                	add	sp,sp,48
     882:	8082                	ret
    gettoken(ps, es, 0, 0);
     884:	4681                	li	a3,0
     886:	4601                	li	a2,0
     888:	85ce                	mv	a1,s3
     88a:	854a                	mv	a0,s2
     88c:	00000097          	auipc	ra,0x0
     890:	b52080e7          	jalr	-1198(ra) # 3de <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     894:	85ce                	mv	a1,s3
     896:	854a                	mv	a0,s2
     898:	00000097          	auipc	ra,0x0
     89c:	f70080e7          	jalr	-144(ra) # 808 <parseline>
     8a0:	85aa                	mv	a1,a0
     8a2:	8526                	mv	a0,s1
     8a4:	00000097          	auipc	ra,0x0
     8a8:	ab8080e7          	jalr	-1352(ra) # 35c <listcmd>
     8ac:	84aa                	mv	s1,a0
  return cmd;
     8ae:	b7d1                	j	872 <parseline+0x6a>

00000000000008b0 <parseblock>:
{
     8b0:	7179                	add	sp,sp,-48
     8b2:	f406                	sd	ra,40(sp)
     8b4:	f022                	sd	s0,32(sp)
     8b6:	ec26                	sd	s1,24(sp)
     8b8:	e84a                	sd	s2,16(sp)
     8ba:	e44e                	sd	s3,8(sp)
     8bc:	1800                	add	s0,sp,48
     8be:	84aa                	mv	s1,a0
     8c0:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8c2:	00001617          	auipc	a2,0x1
     8c6:	aae60613          	add	a2,a2,-1362 # 1370 <malloc+0x15a>
     8ca:	00000097          	auipc	ra,0x0
     8ce:	c60080e7          	jalr	-928(ra) # 52a <peek>
     8d2:	c12d                	beqz	a0,934 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8d4:	4681                	li	a3,0
     8d6:	4601                	li	a2,0
     8d8:	85ca                	mv	a1,s2
     8da:	8526                	mv	a0,s1
     8dc:	00000097          	auipc	ra,0x0
     8e0:	b02080e7          	jalr	-1278(ra) # 3de <gettoken>
  cmd = parseline(ps, es);
     8e4:	85ca                	mv	a1,s2
     8e6:	8526                	mv	a0,s1
     8e8:	00000097          	auipc	ra,0x0
     8ec:	f20080e7          	jalr	-224(ra) # 808 <parseline>
     8f0:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8f2:	00001617          	auipc	a2,0x1
     8f6:	ace60613          	add	a2,a2,-1330 # 13c0 <malloc+0x1aa>
     8fa:	85ca                	mv	a1,s2
     8fc:	8526                	mv	a0,s1
     8fe:	00000097          	auipc	ra,0x0
     902:	c2c080e7          	jalr	-980(ra) # 52a <peek>
     906:	cd1d                	beqz	a0,944 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     908:	4681                	li	a3,0
     90a:	4601                	li	a2,0
     90c:	85ca                	mv	a1,s2
     90e:	8526                	mv	a0,s1
     910:	00000097          	auipc	ra,0x0
     914:	ace080e7          	jalr	-1330(ra) # 3de <gettoken>
  cmd = parseredirs(cmd, ps, es);
     918:	864a                	mv	a2,s2
     91a:	85a6                	mv	a1,s1
     91c:	854e                	mv	a0,s3
     91e:	00000097          	auipc	ra,0x0
     922:	c78080e7          	jalr	-904(ra) # 596 <parseredirs>
}
     926:	70a2                	ld	ra,40(sp)
     928:	7402                	ld	s0,32(sp)
     92a:	64e2                	ld	s1,24(sp)
     92c:	6942                	ld	s2,16(sp)
     92e:	69a2                	ld	s3,8(sp)
     930:	6145                	add	sp,sp,48
     932:	8082                	ret
    panic("parseblock");
     934:	00001517          	auipc	a0,0x1
     938:	a7c50513          	add	a0,a0,-1412 # 13b0 <malloc+0x19a>
     93c:	fffff097          	auipc	ra,0xfffff
     940:	71a080e7          	jalr	1818(ra) # 56 <panic>
    panic("syntax - missing )");
     944:	00001517          	auipc	a0,0x1
     948:	a8450513          	add	a0,a0,-1404 # 13c8 <malloc+0x1b2>
     94c:	fffff097          	auipc	ra,0xfffff
     950:	70a080e7          	jalr	1802(ra) # 56 <panic>

0000000000000954 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     954:	1101                	add	sp,sp,-32
     956:	ec06                	sd	ra,24(sp)
     958:	e822                	sd	s0,16(sp)
     95a:	e426                	sd	s1,8(sp)
     95c:	1000                	add	s0,sp,32
     95e:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     960:	c521                	beqz	a0,9a8 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     962:	4118                	lw	a4,0(a0)
     964:	4795                	li	a5,5
     966:	04e7e163          	bltu	a5,a4,9a8 <nulterminate+0x54>
     96a:	00056783          	lwu	a5,0(a0)
     96e:	078a                	sll	a5,a5,0x2
     970:	00001717          	auipc	a4,0x1
     974:	ab870713          	add	a4,a4,-1352 # 1428 <malloc+0x212>
     978:	97ba                	add	a5,a5,a4
     97a:	439c                	lw	a5,0(a5)
     97c:	97ba                	add	a5,a5,a4
     97e:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     980:	651c                	ld	a5,8(a0)
     982:	c39d                	beqz	a5,9a8 <nulterminate+0x54>
     984:	01050793          	add	a5,a0,16
      *ecmd->eargv[i] = 0;
     988:	67b8                	ld	a4,72(a5)
     98a:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     98e:	07a1                	add	a5,a5,8
     990:	ff87b703          	ld	a4,-8(a5)
     994:	fb75                	bnez	a4,988 <nulterminate+0x34>
     996:	a809                	j	9a8 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     998:	6508                	ld	a0,8(a0)
     99a:	00000097          	auipc	ra,0x0
     99e:	fba080e7          	jalr	-70(ra) # 954 <nulterminate>
    *rcmd->efile = 0;
     9a2:	6c9c                	ld	a5,24(s1)
     9a4:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9a8:	8526                	mv	a0,s1
     9aa:	60e2                	ld	ra,24(sp)
     9ac:	6442                	ld	s0,16(sp)
     9ae:	64a2                	ld	s1,8(sp)
     9b0:	6105                	add	sp,sp,32
     9b2:	8082                	ret
    nulterminate(pcmd->left);
     9b4:	6508                	ld	a0,8(a0)
     9b6:	00000097          	auipc	ra,0x0
     9ba:	f9e080e7          	jalr	-98(ra) # 954 <nulterminate>
    nulterminate(pcmd->right);
     9be:	6888                	ld	a0,16(s1)
     9c0:	00000097          	auipc	ra,0x0
     9c4:	f94080e7          	jalr	-108(ra) # 954 <nulterminate>
    break;
     9c8:	b7c5                	j	9a8 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9ca:	6508                	ld	a0,8(a0)
     9cc:	00000097          	auipc	ra,0x0
     9d0:	f88080e7          	jalr	-120(ra) # 954 <nulterminate>
    nulterminate(lcmd->right);
     9d4:	6888                	ld	a0,16(s1)
     9d6:	00000097          	auipc	ra,0x0
     9da:	f7e080e7          	jalr	-130(ra) # 954 <nulterminate>
    break;
     9de:	b7e9                	j	9a8 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9e0:	6508                	ld	a0,8(a0)
     9e2:	00000097          	auipc	ra,0x0
     9e6:	f72080e7          	jalr	-142(ra) # 954 <nulterminate>
    break;
     9ea:	bf7d                	j	9a8 <nulterminate+0x54>

00000000000009ec <parsecmd>:
{
     9ec:	7179                	add	sp,sp,-48
     9ee:	f406                	sd	ra,40(sp)
     9f0:	f022                	sd	s0,32(sp)
     9f2:	ec26                	sd	s1,24(sp)
     9f4:	e84a                	sd	s2,16(sp)
     9f6:	1800                	add	s0,sp,48
     9f8:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9fc:	84aa                	mv	s1,a0
     9fe:	00000097          	auipc	ra,0x0
     a02:	1d4080e7          	jalr	468(ra) # bd2 <strlen>
     a06:	1502                	sll	a0,a0,0x20
     a08:	9101                	srl	a0,a0,0x20
     a0a:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a0c:	85a6                	mv	a1,s1
     a0e:	fd840513          	add	a0,s0,-40
     a12:	00000097          	auipc	ra,0x0
     a16:	df6080e7          	jalr	-522(ra) # 808 <parseline>
     a1a:	892a                	mv	s2,a0
  peek(&s, es, "");
     a1c:	00001617          	auipc	a2,0x1
     a20:	9c460613          	add	a2,a2,-1596 # 13e0 <malloc+0x1ca>
     a24:	85a6                	mv	a1,s1
     a26:	fd840513          	add	a0,s0,-40
     a2a:	00000097          	auipc	ra,0x0
     a2e:	b00080e7          	jalr	-1280(ra) # 52a <peek>
  if(s != es){
     a32:	fd843603          	ld	a2,-40(s0)
     a36:	00961e63          	bne	a2,s1,a52 <parsecmd+0x66>
  nulterminate(cmd);
     a3a:	854a                	mv	a0,s2
     a3c:	00000097          	auipc	ra,0x0
     a40:	f18080e7          	jalr	-232(ra) # 954 <nulterminate>
}
     a44:	854a                	mv	a0,s2
     a46:	70a2                	ld	ra,40(sp)
     a48:	7402                	ld	s0,32(sp)
     a4a:	64e2                	ld	s1,24(sp)
     a4c:	6942                	ld	s2,16(sp)
     a4e:	6145                	add	sp,sp,48
     a50:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a52:	00001597          	auipc	a1,0x1
     a56:	99658593          	add	a1,a1,-1642 # 13e8 <malloc+0x1d2>
     a5a:	4509                	li	a0,2
     a5c:	00000097          	auipc	ra,0x0
     a60:	6d4080e7          	jalr	1748(ra) # 1130 <fprintf>
    panic("syntax");
     a64:	00001517          	auipc	a0,0x1
     a68:	91450513          	add	a0,a0,-1772 # 1378 <malloc+0x162>
     a6c:	fffff097          	auipc	ra,0xfffff
     a70:	5ea080e7          	jalr	1514(ra) # 56 <panic>

0000000000000a74 <main>:
{
     a74:	7179                	add	sp,sp,-48
     a76:	f406                	sd	ra,40(sp)
     a78:	f022                	sd	s0,32(sp)
     a7a:	ec26                	sd	s1,24(sp)
     a7c:	e84a                	sd	s2,16(sp)
     a7e:	e44e                	sd	s3,8(sp)
     a80:	e052                	sd	s4,0(sp)
     a82:	1800                	add	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a84:	00001497          	auipc	s1,0x1
     a88:	97448493          	add	s1,s1,-1676 # 13f8 <malloc+0x1e2>
     a8c:	4589                	li	a1,2
     a8e:	8526                	mv	a0,s1
     a90:	00000097          	auipc	ra,0x0
     a94:	3a6080e7          	jalr	934(ra) # e36 <open>
     a98:	00054963          	bltz	a0,aaa <main+0x36>
    if(fd >= 3){
     a9c:	4789                	li	a5,2
     a9e:	fea7d7e3          	bge	a5,a0,a8c <main+0x18>
      close(fd);
     aa2:	00000097          	auipc	ra,0x0
     aa6:	37c080e7          	jalr	892(ra) # e1e <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aaa:	00001497          	auipc	s1,0x1
     aae:	57648493          	add	s1,s1,1398 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ab2:	06300913          	li	s2,99
     ab6:	02000993          	li	s3,32
     aba:	a819                	j	ad0 <main+0x5c>
    if(fork1() == 0)
     abc:	fffff097          	auipc	ra,0xfffff
     ac0:	5c0080e7          	jalr	1472(ra) # 7c <fork1>
     ac4:	c549                	beqz	a0,b4e <main+0xda>
    wait(0);
     ac6:	4501                	li	a0,0
     ac8:	00000097          	auipc	ra,0x0
     acc:	336080e7          	jalr	822(ra) # dfe <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ad0:	06400593          	li	a1,100
     ad4:	8526                	mv	a0,s1
     ad6:	fffff097          	auipc	ra,0xfffff
     ada:	52a080e7          	jalr	1322(ra) # 0 <getcmd>
     ade:	08054463          	bltz	a0,b66 <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ae2:	0004c783          	lbu	a5,0(s1)
     ae6:	fd279be3          	bne	a5,s2,abc <main+0x48>
     aea:	0014c703          	lbu	a4,1(s1)
     aee:	06400793          	li	a5,100
     af2:	fcf715e3          	bne	a4,a5,abc <main+0x48>
     af6:	0024c783          	lbu	a5,2(s1)
     afa:	fd3791e3          	bne	a5,s3,abc <main+0x48>
      buf[strlen(buf)-1] = 0;  // chop \n
     afe:	00001a17          	auipc	s4,0x1
     b02:	522a0a13          	add	s4,s4,1314 # 2020 <buf.0>
     b06:	8552                	mv	a0,s4
     b08:	00000097          	auipc	ra,0x0
     b0c:	0ca080e7          	jalr	202(ra) # bd2 <strlen>
     b10:	fff5079b          	addw	a5,a0,-1
     b14:	1782                	sll	a5,a5,0x20
     b16:	9381                	srl	a5,a5,0x20
     b18:	9a3e                	add	s4,s4,a5
     b1a:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     b1e:	00001517          	auipc	a0,0x1
     b22:	50550513          	add	a0,a0,1285 # 2023 <buf.0+0x3>
     b26:	00000097          	auipc	ra,0x0
     b2a:	340080e7          	jalr	832(ra) # e66 <chdir>
     b2e:	fa0551e3          	bgez	a0,ad0 <main+0x5c>
        fprintf(2, "cannot cd %s\n", buf+3);
     b32:	00001617          	auipc	a2,0x1
     b36:	4f160613          	add	a2,a2,1265 # 2023 <buf.0+0x3>
     b3a:	00001597          	auipc	a1,0x1
     b3e:	8c658593          	add	a1,a1,-1850 # 1400 <malloc+0x1ea>
     b42:	4509                	li	a0,2
     b44:	00000097          	auipc	ra,0x0
     b48:	5ec080e7          	jalr	1516(ra) # 1130 <fprintf>
     b4c:	b751                	j	ad0 <main+0x5c>
      runcmd(parsecmd(buf));
     b4e:	00001517          	auipc	a0,0x1
     b52:	4d250513          	add	a0,a0,1234 # 2020 <buf.0>
     b56:	00000097          	auipc	ra,0x0
     b5a:	e96080e7          	jalr	-362(ra) # 9ec <parsecmd>
     b5e:	fffff097          	auipc	ra,0xfffff
     b62:	54c080e7          	jalr	1356(ra) # aa <runcmd>
  exit(0);
     b66:	4501                	li	a0,0
     b68:	00000097          	auipc	ra,0x0
     b6c:	28e080e7          	jalr	654(ra) # df6 <exit>

0000000000000b70 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     b70:	1141                	add	sp,sp,-16
     b72:	e406                	sd	ra,8(sp)
     b74:	e022                	sd	s0,0(sp)
     b76:	0800                	add	s0,sp,16
  extern int main();
  main();
     b78:	00000097          	auipc	ra,0x0
     b7c:	efc080e7          	jalr	-260(ra) # a74 <main>
  exit(0);
     b80:	4501                	li	a0,0
     b82:	00000097          	auipc	ra,0x0
     b86:	274080e7          	jalr	628(ra) # df6 <exit>

0000000000000b8a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     b8a:	1141                	add	sp,sp,-16
     b8c:	e422                	sd	s0,8(sp)
     b8e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b90:	87aa                	mv	a5,a0
     b92:	0585                	add	a1,a1,1
     b94:	0785                	add	a5,a5,1
     b96:	fff5c703          	lbu	a4,-1(a1)
     b9a:	fee78fa3          	sb	a4,-1(a5)
     b9e:	fb75                	bnez	a4,b92 <strcpy+0x8>
    ;
  return os;
}
     ba0:	6422                	ld	s0,8(sp)
     ba2:	0141                	add	sp,sp,16
     ba4:	8082                	ret

0000000000000ba6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba6:	1141                	add	sp,sp,-16
     ba8:	e422                	sd	s0,8(sp)
     baa:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     bac:	00054783          	lbu	a5,0(a0)
     bb0:	cb91                	beqz	a5,bc4 <strcmp+0x1e>
     bb2:	0005c703          	lbu	a4,0(a1)
     bb6:	00f71763          	bne	a4,a5,bc4 <strcmp+0x1e>
    p++, q++;
     bba:	0505                	add	a0,a0,1
     bbc:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     bbe:	00054783          	lbu	a5,0(a0)
     bc2:	fbe5                	bnez	a5,bb2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bc4:	0005c503          	lbu	a0,0(a1)
}
     bc8:	40a7853b          	subw	a0,a5,a0
     bcc:	6422                	ld	s0,8(sp)
     bce:	0141                	add	sp,sp,16
     bd0:	8082                	ret

0000000000000bd2 <strlen>:

uint
strlen(const char *s)
{
     bd2:	1141                	add	sp,sp,-16
     bd4:	e422                	sd	s0,8(sp)
     bd6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bd8:	00054783          	lbu	a5,0(a0)
     bdc:	cf91                	beqz	a5,bf8 <strlen+0x26>
     bde:	0505                	add	a0,a0,1
     be0:	87aa                	mv	a5,a0
     be2:	86be                	mv	a3,a5
     be4:	0785                	add	a5,a5,1
     be6:	fff7c703          	lbu	a4,-1(a5)
     bea:	ff65                	bnez	a4,be2 <strlen+0x10>
     bec:	40a6853b          	subw	a0,a3,a0
     bf0:	2505                	addw	a0,a0,1
    ;
  return n;
}
     bf2:	6422                	ld	s0,8(sp)
     bf4:	0141                	add	sp,sp,16
     bf6:	8082                	ret
  for(n = 0; s[n]; n++)
     bf8:	4501                	li	a0,0
     bfa:	bfe5                	j	bf2 <strlen+0x20>

0000000000000bfc <memset>:

void*
memset(void *dst, int c, uint n)
{
     bfc:	1141                	add	sp,sp,-16
     bfe:	e422                	sd	s0,8(sp)
     c00:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c02:	ca19                	beqz	a2,c18 <memset+0x1c>
     c04:	87aa                	mv	a5,a0
     c06:	1602                	sll	a2,a2,0x20
     c08:	9201                	srl	a2,a2,0x20
     c0a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c0e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c12:	0785                	add	a5,a5,1
     c14:	fee79de3          	bne	a5,a4,c0e <memset+0x12>
  }
  return dst;
}
     c18:	6422                	ld	s0,8(sp)
     c1a:	0141                	add	sp,sp,16
     c1c:	8082                	ret

0000000000000c1e <strchr>:

char*
strchr(const char *s, char c)
{
     c1e:	1141                	add	sp,sp,-16
     c20:	e422                	sd	s0,8(sp)
     c22:	0800                	add	s0,sp,16
  for(; *s; s++)
     c24:	00054783          	lbu	a5,0(a0)
     c28:	cb99                	beqz	a5,c3e <strchr+0x20>
    if(*s == c)
     c2a:	00f58763          	beq	a1,a5,c38 <strchr+0x1a>
  for(; *s; s++)
     c2e:	0505                	add	a0,a0,1
     c30:	00054783          	lbu	a5,0(a0)
     c34:	fbfd                	bnez	a5,c2a <strchr+0xc>
      return (char*)s;
  return 0;
     c36:	4501                	li	a0,0
}
     c38:	6422                	ld	s0,8(sp)
     c3a:	0141                	add	sp,sp,16
     c3c:	8082                	ret
  return 0;
     c3e:	4501                	li	a0,0
     c40:	bfe5                	j	c38 <strchr+0x1a>

0000000000000c42 <gets>:

char*
gets(char *buf, int max)
{
     c42:	711d                	add	sp,sp,-96
     c44:	ec86                	sd	ra,88(sp)
     c46:	e8a2                	sd	s0,80(sp)
     c48:	e4a6                	sd	s1,72(sp)
     c4a:	e0ca                	sd	s2,64(sp)
     c4c:	fc4e                	sd	s3,56(sp)
     c4e:	f852                	sd	s4,48(sp)
     c50:	f456                	sd	s5,40(sp)
     c52:	f05a                	sd	s6,32(sp)
     c54:	ec5e                	sd	s7,24(sp)
     c56:	1080                	add	s0,sp,96
     c58:	8baa                	mv	s7,a0
     c5a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c5c:	892a                	mv	s2,a0
     c5e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c60:	4aa9                	li	s5,10
     c62:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c64:	89a6                	mv	s3,s1
     c66:	2485                	addw	s1,s1,1
     c68:	0344d863          	bge	s1,s4,c98 <gets+0x56>
    cc = read(0, &c, 1);
     c6c:	4605                	li	a2,1
     c6e:	faf40593          	add	a1,s0,-81
     c72:	4501                	li	a0,0
     c74:	00000097          	auipc	ra,0x0
     c78:	19a080e7          	jalr	410(ra) # e0e <read>
    if(cc < 1)
     c7c:	00a05e63          	blez	a0,c98 <gets+0x56>
    buf[i++] = c;
     c80:	faf44783          	lbu	a5,-81(s0)
     c84:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c88:	01578763          	beq	a5,s5,c96 <gets+0x54>
     c8c:	0905                	add	s2,s2,1
     c8e:	fd679be3          	bne	a5,s6,c64 <gets+0x22>
  for(i=0; i+1 < max; ){
     c92:	89a6                	mv	s3,s1
     c94:	a011                	j	c98 <gets+0x56>
     c96:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c98:	99de                	add	s3,s3,s7
     c9a:	00098023          	sb	zero,0(s3)
  return buf;
}
     c9e:	855e                	mv	a0,s7
     ca0:	60e6                	ld	ra,88(sp)
     ca2:	6446                	ld	s0,80(sp)
     ca4:	64a6                	ld	s1,72(sp)
     ca6:	6906                	ld	s2,64(sp)
     ca8:	79e2                	ld	s3,56(sp)
     caa:	7a42                	ld	s4,48(sp)
     cac:	7aa2                	ld	s5,40(sp)
     cae:	7b02                	ld	s6,32(sp)
     cb0:	6be2                	ld	s7,24(sp)
     cb2:	6125                	add	sp,sp,96
     cb4:	8082                	ret

0000000000000cb6 <stat>:

int
stat(const char *n, struct stat *st)
{
     cb6:	1101                	add	sp,sp,-32
     cb8:	ec06                	sd	ra,24(sp)
     cba:	e822                	sd	s0,16(sp)
     cbc:	e426                	sd	s1,8(sp)
     cbe:	e04a                	sd	s2,0(sp)
     cc0:	1000                	add	s0,sp,32
     cc2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cc4:	4581                	li	a1,0
     cc6:	00000097          	auipc	ra,0x0
     cca:	170080e7          	jalr	368(ra) # e36 <open>
  if(fd < 0)
     cce:	02054563          	bltz	a0,cf8 <stat+0x42>
     cd2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cd4:	85ca                	mv	a1,s2
     cd6:	00000097          	auipc	ra,0x0
     cda:	178080e7          	jalr	376(ra) # e4e <fstat>
     cde:	892a                	mv	s2,a0
  close(fd);
     ce0:	8526                	mv	a0,s1
     ce2:	00000097          	auipc	ra,0x0
     ce6:	13c080e7          	jalr	316(ra) # e1e <close>
  return r;
}
     cea:	854a                	mv	a0,s2
     cec:	60e2                	ld	ra,24(sp)
     cee:	6442                	ld	s0,16(sp)
     cf0:	64a2                	ld	s1,8(sp)
     cf2:	6902                	ld	s2,0(sp)
     cf4:	6105                	add	sp,sp,32
     cf6:	8082                	ret
    return -1;
     cf8:	597d                	li	s2,-1
     cfa:	bfc5                	j	cea <stat+0x34>

0000000000000cfc <atoi>:

int
atoi(const char *s)
{
     cfc:	1141                	add	sp,sp,-16
     cfe:	e422                	sd	s0,8(sp)
     d00:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d02:	00054683          	lbu	a3,0(a0)
     d06:	fd06879b          	addw	a5,a3,-48
     d0a:	0ff7f793          	zext.b	a5,a5
     d0e:	4625                	li	a2,9
     d10:	02f66863          	bltu	a2,a5,d40 <atoi+0x44>
     d14:	872a                	mv	a4,a0
  n = 0;
     d16:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d18:	0705                	add	a4,a4,1
     d1a:	0025179b          	sllw	a5,a0,0x2
     d1e:	9fa9                	addw	a5,a5,a0
     d20:	0017979b          	sllw	a5,a5,0x1
     d24:	9fb5                	addw	a5,a5,a3
     d26:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d2a:	00074683          	lbu	a3,0(a4)
     d2e:	fd06879b          	addw	a5,a3,-48
     d32:	0ff7f793          	zext.b	a5,a5
     d36:	fef671e3          	bgeu	a2,a5,d18 <atoi+0x1c>
  return n;
}
     d3a:	6422                	ld	s0,8(sp)
     d3c:	0141                	add	sp,sp,16
     d3e:	8082                	ret
  n = 0;
     d40:	4501                	li	a0,0
     d42:	bfe5                	j	d3a <atoi+0x3e>

0000000000000d44 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d44:	1141                	add	sp,sp,-16
     d46:	e422                	sd	s0,8(sp)
     d48:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d4a:	02b57463          	bgeu	a0,a1,d72 <memmove+0x2e>
    while(n-- > 0)
     d4e:	00c05f63          	blez	a2,d6c <memmove+0x28>
     d52:	1602                	sll	a2,a2,0x20
     d54:	9201                	srl	a2,a2,0x20
     d56:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d5a:	872a                	mv	a4,a0
      *dst++ = *src++;
     d5c:	0585                	add	a1,a1,1
     d5e:	0705                	add	a4,a4,1
     d60:	fff5c683          	lbu	a3,-1(a1)
     d64:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d68:	fee79ae3          	bne	a5,a4,d5c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d6c:	6422                	ld	s0,8(sp)
     d6e:	0141                	add	sp,sp,16
     d70:	8082                	ret
    dst += n;
     d72:	00c50733          	add	a4,a0,a2
    src += n;
     d76:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d78:	fec05ae3          	blez	a2,d6c <memmove+0x28>
     d7c:	fff6079b          	addw	a5,a2,-1
     d80:	1782                	sll	a5,a5,0x20
     d82:	9381                	srl	a5,a5,0x20
     d84:	fff7c793          	not	a5,a5
     d88:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d8a:	15fd                	add	a1,a1,-1
     d8c:	177d                	add	a4,a4,-1
     d8e:	0005c683          	lbu	a3,0(a1)
     d92:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d96:	fee79ae3          	bne	a5,a4,d8a <memmove+0x46>
     d9a:	bfc9                	j	d6c <memmove+0x28>

0000000000000d9c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d9c:	1141                	add	sp,sp,-16
     d9e:	e422                	sd	s0,8(sp)
     da0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     da2:	ca05                	beqz	a2,dd2 <memcmp+0x36>
     da4:	fff6069b          	addw	a3,a2,-1
     da8:	1682                	sll	a3,a3,0x20
     daa:	9281                	srl	a3,a3,0x20
     dac:	0685                	add	a3,a3,1
     dae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     db0:	00054783          	lbu	a5,0(a0)
     db4:	0005c703          	lbu	a4,0(a1)
     db8:	00e79863          	bne	a5,a4,dc8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dbc:	0505                	add	a0,a0,1
    p2++;
     dbe:	0585                	add	a1,a1,1
  while (n-- > 0) {
     dc0:	fed518e3          	bne	a0,a3,db0 <memcmp+0x14>
  }
  return 0;
     dc4:	4501                	li	a0,0
     dc6:	a019                	j	dcc <memcmp+0x30>
      return *p1 - *p2;
     dc8:	40e7853b          	subw	a0,a5,a4
}
     dcc:	6422                	ld	s0,8(sp)
     dce:	0141                	add	sp,sp,16
     dd0:	8082                	ret
  return 0;
     dd2:	4501                	li	a0,0
     dd4:	bfe5                	j	dcc <memcmp+0x30>

0000000000000dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dd6:	1141                	add	sp,sp,-16
     dd8:	e406                	sd	ra,8(sp)
     dda:	e022                	sd	s0,0(sp)
     ddc:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     dde:	00000097          	auipc	ra,0x0
     de2:	f66080e7          	jalr	-154(ra) # d44 <memmove>
}
     de6:	60a2                	ld	ra,8(sp)
     de8:	6402                	ld	s0,0(sp)
     dea:	0141                	add	sp,sp,16
     dec:	8082                	ret

0000000000000dee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dee:	4885                	li	a7,1
 ecall
     df0:	00000073          	ecall
 ret
     df4:	8082                	ret

0000000000000df6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     df6:	4889                	li	a7,2
 ecall
     df8:	00000073          	ecall
 ret
     dfc:	8082                	ret

0000000000000dfe <wait>:
.global wait
wait:
 li a7, SYS_wait
     dfe:	488d                	li	a7,3
 ecall
     e00:	00000073          	ecall
 ret
     e04:	8082                	ret

0000000000000e06 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e06:	4891                	li	a7,4
 ecall
     e08:	00000073          	ecall
 ret
     e0c:	8082                	ret

0000000000000e0e <read>:
.global read
read:
 li a7, SYS_read
     e0e:	4895                	li	a7,5
 ecall
     e10:	00000073          	ecall
 ret
     e14:	8082                	ret

0000000000000e16 <write>:
.global write
write:
 li a7, SYS_write
     e16:	48c1                	li	a7,16
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <close>:
.global close
close:
 li a7, SYS_close
     e1e:	48d5                	li	a7,21
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e26:	4899                	li	a7,6
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e2e:	489d                	li	a7,7
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <open>:
.global open
open:
 li a7, SYS_open
     e36:	48bd                	li	a7,15
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e3e:	48c5                	li	a7,17
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e46:	48c9                	li	a7,18
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e4e:	48a1                	li	a7,8
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <link>:
.global link
link:
 li a7, SYS_link
     e56:	48cd                	li	a7,19
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e5e:	48d1                	li	a7,20
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e66:	48a5                	li	a7,9
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <dup>:
.global dup
dup:
 li a7, SYS_dup
     e6e:	48a9                	li	a7,10
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e76:	48ad                	li	a7,11
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e7e:	48b1                	li	a7,12
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e86:	48b5                	li	a7,13
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e8e:	48b9                	li	a7,14
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e96:	1101                	add	sp,sp,-32
     e98:	ec06                	sd	ra,24(sp)
     e9a:	e822                	sd	s0,16(sp)
     e9c:	1000                	add	s0,sp,32
     e9e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ea2:	4605                	li	a2,1
     ea4:	fef40593          	add	a1,s0,-17
     ea8:	00000097          	auipc	ra,0x0
     eac:	f6e080e7          	jalr	-146(ra) # e16 <write>
}
     eb0:	60e2                	ld	ra,24(sp)
     eb2:	6442                	ld	s0,16(sp)
     eb4:	6105                	add	sp,sp,32
     eb6:	8082                	ret

0000000000000eb8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eb8:	7139                	add	sp,sp,-64
     eba:	fc06                	sd	ra,56(sp)
     ebc:	f822                	sd	s0,48(sp)
     ebe:	f426                	sd	s1,40(sp)
     ec0:	f04a                	sd	s2,32(sp)
     ec2:	ec4e                	sd	s3,24(sp)
     ec4:	0080                	add	s0,sp,64
     ec6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ec8:	c299                	beqz	a3,ece <printint+0x16>
     eca:	0805c963          	bltz	a1,f5c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ece:	2581                	sext.w	a1,a1
  neg = 0;
     ed0:	4881                	li	a7,0
     ed2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     ed6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ed8:	2601                	sext.w	a2,a2
     eda:	00000517          	auipc	a0,0x0
     ede:	5c650513          	add	a0,a0,1478 # 14a0 <digits>
     ee2:	883a                	mv	a6,a4
     ee4:	2705                	addw	a4,a4,1
     ee6:	02c5f7bb          	remuw	a5,a1,a2
     eea:	1782                	sll	a5,a5,0x20
     eec:	9381                	srl	a5,a5,0x20
     eee:	97aa                	add	a5,a5,a0
     ef0:	0007c783          	lbu	a5,0(a5)
     ef4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ef8:	0005879b          	sext.w	a5,a1
     efc:	02c5d5bb          	divuw	a1,a1,a2
     f00:	0685                	add	a3,a3,1
     f02:	fec7f0e3          	bgeu	a5,a2,ee2 <printint+0x2a>
  if(neg)
     f06:	00088c63          	beqz	a7,f1e <printint+0x66>
    buf[i++] = '-';
     f0a:	fd070793          	add	a5,a4,-48
     f0e:	00878733          	add	a4,a5,s0
     f12:	02d00793          	li	a5,45
     f16:	fef70823          	sb	a5,-16(a4)
     f1a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f1e:	02e05863          	blez	a4,f4e <printint+0x96>
     f22:	fc040793          	add	a5,s0,-64
     f26:	00e78933          	add	s2,a5,a4
     f2a:	fff78993          	add	s3,a5,-1
     f2e:	99ba                	add	s3,s3,a4
     f30:	377d                	addw	a4,a4,-1
     f32:	1702                	sll	a4,a4,0x20
     f34:	9301                	srl	a4,a4,0x20
     f36:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f3a:	fff94583          	lbu	a1,-1(s2)
     f3e:	8526                	mv	a0,s1
     f40:	00000097          	auipc	ra,0x0
     f44:	f56080e7          	jalr	-170(ra) # e96 <putc>
  while(--i >= 0)
     f48:	197d                	add	s2,s2,-1
     f4a:	ff3918e3          	bne	s2,s3,f3a <printint+0x82>
}
     f4e:	70e2                	ld	ra,56(sp)
     f50:	7442                	ld	s0,48(sp)
     f52:	74a2                	ld	s1,40(sp)
     f54:	7902                	ld	s2,32(sp)
     f56:	69e2                	ld	s3,24(sp)
     f58:	6121                	add	sp,sp,64
     f5a:	8082                	ret
    x = -xx;
     f5c:	40b005bb          	negw	a1,a1
    neg = 1;
     f60:	4885                	li	a7,1
    x = -xx;
     f62:	bf85                	j	ed2 <printint+0x1a>

0000000000000f64 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f64:	715d                	add	sp,sp,-80
     f66:	e486                	sd	ra,72(sp)
     f68:	e0a2                	sd	s0,64(sp)
     f6a:	fc26                	sd	s1,56(sp)
     f6c:	f84a                	sd	s2,48(sp)
     f6e:	f44e                	sd	s3,40(sp)
     f70:	f052                	sd	s4,32(sp)
     f72:	ec56                	sd	s5,24(sp)
     f74:	e85a                	sd	s6,16(sp)
     f76:	e45e                	sd	s7,8(sp)
     f78:	e062                	sd	s8,0(sp)
     f7a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f7c:	0005c903          	lbu	s2,0(a1)
     f80:	18090c63          	beqz	s2,1118 <vprintf+0x1b4>
     f84:	8aaa                	mv	s5,a0
     f86:	8bb2                	mv	s7,a2
     f88:	00158493          	add	s1,a1,1
  state = 0;
     f8c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f8e:	02500a13          	li	s4,37
     f92:	4b55                	li	s6,21
     f94:	a839                	j	fb2 <vprintf+0x4e>
        putc(fd, c);
     f96:	85ca                	mv	a1,s2
     f98:	8556                	mv	a0,s5
     f9a:	00000097          	auipc	ra,0x0
     f9e:	efc080e7          	jalr	-260(ra) # e96 <putc>
     fa2:	a019                	j	fa8 <vprintf+0x44>
    } else if(state == '%'){
     fa4:	01498d63          	beq	s3,s4,fbe <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
     fa8:	0485                	add	s1,s1,1
     faa:	fff4c903          	lbu	s2,-1(s1)
     fae:	16090563          	beqz	s2,1118 <vprintf+0x1b4>
    if(state == 0){
     fb2:	fe0999e3          	bnez	s3,fa4 <vprintf+0x40>
      if(c == '%'){
     fb6:	ff4910e3          	bne	s2,s4,f96 <vprintf+0x32>
        state = '%';
     fba:	89d2                	mv	s3,s4
     fbc:	b7f5                	j	fa8 <vprintf+0x44>
      if(c == 'd'){
     fbe:	13490263          	beq	s2,s4,10e2 <vprintf+0x17e>
     fc2:	f9d9079b          	addw	a5,s2,-99
     fc6:	0ff7f793          	zext.b	a5,a5
     fca:	12fb6563          	bltu	s6,a5,10f4 <vprintf+0x190>
     fce:	f9d9079b          	addw	a5,s2,-99
     fd2:	0ff7f713          	zext.b	a4,a5
     fd6:	10eb6f63          	bltu	s6,a4,10f4 <vprintf+0x190>
     fda:	00271793          	sll	a5,a4,0x2
     fde:	00000717          	auipc	a4,0x0
     fe2:	46a70713          	add	a4,a4,1130 # 1448 <malloc+0x232>
     fe6:	97ba                	add	a5,a5,a4
     fe8:	439c                	lw	a5,0(a5)
     fea:	97ba                	add	a5,a5,a4
     fec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     fee:	008b8913          	add	s2,s7,8
     ff2:	4685                	li	a3,1
     ff4:	4629                	li	a2,10
     ff6:	000ba583          	lw	a1,0(s7)
     ffa:	8556                	mv	a0,s5
     ffc:	00000097          	auipc	ra,0x0
    1000:	ebc080e7          	jalr	-324(ra) # eb8 <printint>
    1004:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1006:	4981                	li	s3,0
    1008:	b745                	j	fa8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    100a:	008b8913          	add	s2,s7,8
    100e:	4681                	li	a3,0
    1010:	4629                	li	a2,10
    1012:	000ba583          	lw	a1,0(s7)
    1016:	8556                	mv	a0,s5
    1018:	00000097          	auipc	ra,0x0
    101c:	ea0080e7          	jalr	-352(ra) # eb8 <printint>
    1020:	8bca                	mv	s7,s2
      state = 0;
    1022:	4981                	li	s3,0
    1024:	b751                	j	fa8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    1026:	008b8913          	add	s2,s7,8
    102a:	4681                	li	a3,0
    102c:	4641                	li	a2,16
    102e:	000ba583          	lw	a1,0(s7)
    1032:	8556                	mv	a0,s5
    1034:	00000097          	auipc	ra,0x0
    1038:	e84080e7          	jalr	-380(ra) # eb8 <printint>
    103c:	8bca                	mv	s7,s2
      state = 0;
    103e:	4981                	li	s3,0
    1040:	b7a5                	j	fa8 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    1042:	008b8c13          	add	s8,s7,8
    1046:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    104a:	03000593          	li	a1,48
    104e:	8556                	mv	a0,s5
    1050:	00000097          	auipc	ra,0x0
    1054:	e46080e7          	jalr	-442(ra) # e96 <putc>
  putc(fd, 'x');
    1058:	07800593          	li	a1,120
    105c:	8556                	mv	a0,s5
    105e:	00000097          	auipc	ra,0x0
    1062:	e38080e7          	jalr	-456(ra) # e96 <putc>
    1066:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1068:	00000b97          	auipc	s7,0x0
    106c:	438b8b93          	add	s7,s7,1080 # 14a0 <digits>
    1070:	03c9d793          	srl	a5,s3,0x3c
    1074:	97de                	add	a5,a5,s7
    1076:	0007c583          	lbu	a1,0(a5)
    107a:	8556                	mv	a0,s5
    107c:	00000097          	auipc	ra,0x0
    1080:	e1a080e7          	jalr	-486(ra) # e96 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1084:	0992                	sll	s3,s3,0x4
    1086:	397d                	addw	s2,s2,-1
    1088:	fe0914e3          	bnez	s2,1070 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    108c:	8be2                	mv	s7,s8
      state = 0;
    108e:	4981                	li	s3,0
    1090:	bf21                	j	fa8 <vprintf+0x44>
        s = va_arg(ap, char*);
    1092:	008b8993          	add	s3,s7,8
    1096:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    109a:	02090163          	beqz	s2,10bc <vprintf+0x158>
        while(*s != 0){
    109e:	00094583          	lbu	a1,0(s2)
    10a2:	c9a5                	beqz	a1,1112 <vprintf+0x1ae>
          putc(fd, *s);
    10a4:	8556                	mv	a0,s5
    10a6:	00000097          	auipc	ra,0x0
    10aa:	df0080e7          	jalr	-528(ra) # e96 <putc>
          s++;
    10ae:	0905                	add	s2,s2,1
        while(*s != 0){
    10b0:	00094583          	lbu	a1,0(s2)
    10b4:	f9e5                	bnez	a1,10a4 <vprintf+0x140>
        s = va_arg(ap, char*);
    10b6:	8bce                	mv	s7,s3
      state = 0;
    10b8:	4981                	li	s3,0
    10ba:	b5fd                	j	fa8 <vprintf+0x44>
          s = "(null)";
    10bc:	00000917          	auipc	s2,0x0
    10c0:	38490913          	add	s2,s2,900 # 1440 <malloc+0x22a>
        while(*s != 0){
    10c4:	02800593          	li	a1,40
    10c8:	bff1                	j	10a4 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    10ca:	008b8913          	add	s2,s7,8
    10ce:	000bc583          	lbu	a1,0(s7)
    10d2:	8556                	mv	a0,s5
    10d4:	00000097          	auipc	ra,0x0
    10d8:	dc2080e7          	jalr	-574(ra) # e96 <putc>
    10dc:	8bca                	mv	s7,s2
      state = 0;
    10de:	4981                	li	s3,0
    10e0:	b5e1                	j	fa8 <vprintf+0x44>
        putc(fd, c);
    10e2:	02500593          	li	a1,37
    10e6:	8556                	mv	a0,s5
    10e8:	00000097          	auipc	ra,0x0
    10ec:	dae080e7          	jalr	-594(ra) # e96 <putc>
      state = 0;
    10f0:	4981                	li	s3,0
    10f2:	bd5d                	j	fa8 <vprintf+0x44>
        putc(fd, '%');
    10f4:	02500593          	li	a1,37
    10f8:	8556                	mv	a0,s5
    10fa:	00000097          	auipc	ra,0x0
    10fe:	d9c080e7          	jalr	-612(ra) # e96 <putc>
        putc(fd, c);
    1102:	85ca                	mv	a1,s2
    1104:	8556                	mv	a0,s5
    1106:	00000097          	auipc	ra,0x0
    110a:	d90080e7          	jalr	-624(ra) # e96 <putc>
      state = 0;
    110e:	4981                	li	s3,0
    1110:	bd61                	j	fa8 <vprintf+0x44>
        s = va_arg(ap, char*);
    1112:	8bce                	mv	s7,s3
      state = 0;
    1114:	4981                	li	s3,0
    1116:	bd49                	j	fa8 <vprintf+0x44>
    }
  }
}
    1118:	60a6                	ld	ra,72(sp)
    111a:	6406                	ld	s0,64(sp)
    111c:	74e2                	ld	s1,56(sp)
    111e:	7942                	ld	s2,48(sp)
    1120:	79a2                	ld	s3,40(sp)
    1122:	7a02                	ld	s4,32(sp)
    1124:	6ae2                	ld	s5,24(sp)
    1126:	6b42                	ld	s6,16(sp)
    1128:	6ba2                	ld	s7,8(sp)
    112a:	6c02                	ld	s8,0(sp)
    112c:	6161                	add	sp,sp,80
    112e:	8082                	ret

0000000000001130 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1130:	715d                	add	sp,sp,-80
    1132:	ec06                	sd	ra,24(sp)
    1134:	e822                	sd	s0,16(sp)
    1136:	1000                	add	s0,sp,32
    1138:	e010                	sd	a2,0(s0)
    113a:	e414                	sd	a3,8(s0)
    113c:	e818                	sd	a4,16(s0)
    113e:	ec1c                	sd	a5,24(s0)
    1140:	03043023          	sd	a6,32(s0)
    1144:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1148:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    114c:	8622                	mv	a2,s0
    114e:	00000097          	auipc	ra,0x0
    1152:	e16080e7          	jalr	-490(ra) # f64 <vprintf>
}
    1156:	60e2                	ld	ra,24(sp)
    1158:	6442                	ld	s0,16(sp)
    115a:	6161                	add	sp,sp,80
    115c:	8082                	ret

000000000000115e <printf>:

void
printf(const char *fmt, ...)
{
    115e:	711d                	add	sp,sp,-96
    1160:	ec06                	sd	ra,24(sp)
    1162:	e822                	sd	s0,16(sp)
    1164:	1000                	add	s0,sp,32
    1166:	e40c                	sd	a1,8(s0)
    1168:	e810                	sd	a2,16(s0)
    116a:	ec14                	sd	a3,24(s0)
    116c:	f018                	sd	a4,32(s0)
    116e:	f41c                	sd	a5,40(s0)
    1170:	03043823          	sd	a6,48(s0)
    1174:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1178:	00840613          	add	a2,s0,8
    117c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1180:	85aa                	mv	a1,a0
    1182:	4505                	li	a0,1
    1184:	00000097          	auipc	ra,0x0
    1188:	de0080e7          	jalr	-544(ra) # f64 <vprintf>
}
    118c:	60e2                	ld	ra,24(sp)
    118e:	6442                	ld	s0,16(sp)
    1190:	6125                	add	sp,sp,96
    1192:	8082                	ret

0000000000001194 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1194:	1141                	add	sp,sp,-16
    1196:	e422                	sd	s0,8(sp)
    1198:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    119a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    119e:	00001797          	auipc	a5,0x1
    11a2:	e727b783          	ld	a5,-398(a5) # 2010 <freep>
    11a6:	a02d                	j	11d0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11a8:	4618                	lw	a4,8(a2)
    11aa:	9f2d                	addw	a4,a4,a1
    11ac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11b0:	6398                	ld	a4,0(a5)
    11b2:	6310                	ld	a2,0(a4)
    11b4:	a83d                	j	11f2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11b6:	ff852703          	lw	a4,-8(a0)
    11ba:	9f31                	addw	a4,a4,a2
    11bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11be:	ff053683          	ld	a3,-16(a0)
    11c2:	a091                	j	1206 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11c4:	6398                	ld	a4,0(a5)
    11c6:	00e7e463          	bltu	a5,a4,11ce <free+0x3a>
    11ca:	00e6ea63          	bltu	a3,a4,11de <free+0x4a>
{
    11ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d0:	fed7fae3          	bgeu	a5,a3,11c4 <free+0x30>
    11d4:	6398                	ld	a4,0(a5)
    11d6:	00e6e463          	bltu	a3,a4,11de <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11da:	fee7eae3          	bltu	a5,a4,11ce <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11de:	ff852583          	lw	a1,-8(a0)
    11e2:	6390                	ld	a2,0(a5)
    11e4:	02059813          	sll	a6,a1,0x20
    11e8:	01c85713          	srl	a4,a6,0x1c
    11ec:	9736                	add	a4,a4,a3
    11ee:	fae60de3          	beq	a2,a4,11a8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11f6:	4790                	lw	a2,8(a5)
    11f8:	02061593          	sll	a1,a2,0x20
    11fc:	01c5d713          	srl	a4,a1,0x1c
    1200:	973e                	add	a4,a4,a5
    1202:	fae68ae3          	beq	a3,a4,11b6 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1206:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1208:	00001717          	auipc	a4,0x1
    120c:	e0f73423          	sd	a5,-504(a4) # 2010 <freep>
}
    1210:	6422                	ld	s0,8(sp)
    1212:	0141                	add	sp,sp,16
    1214:	8082                	ret

0000000000001216 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1216:	7139                	add	sp,sp,-64
    1218:	fc06                	sd	ra,56(sp)
    121a:	f822                	sd	s0,48(sp)
    121c:	f426                	sd	s1,40(sp)
    121e:	f04a                	sd	s2,32(sp)
    1220:	ec4e                	sd	s3,24(sp)
    1222:	e852                	sd	s4,16(sp)
    1224:	e456                	sd	s5,8(sp)
    1226:	e05a                	sd	s6,0(sp)
    1228:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    122a:	02051493          	sll	s1,a0,0x20
    122e:	9081                	srl	s1,s1,0x20
    1230:	04bd                	add	s1,s1,15
    1232:	8091                	srl	s1,s1,0x4
    1234:	0014899b          	addw	s3,s1,1
    1238:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    123a:	00001517          	auipc	a0,0x1
    123e:	dd653503          	ld	a0,-554(a0) # 2010 <freep>
    1242:	c515                	beqz	a0,126e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1244:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1246:	4798                	lw	a4,8(a5)
    1248:	02977f63          	bgeu	a4,s1,1286 <malloc+0x70>
  if(nu < 4096)
    124c:	8a4e                	mv	s4,s3
    124e:	0009871b          	sext.w	a4,s3
    1252:	6685                	lui	a3,0x1
    1254:	00d77363          	bgeu	a4,a3,125a <malloc+0x44>
    1258:	6a05                	lui	s4,0x1
    125a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    125e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1262:	00001917          	auipc	s2,0x1
    1266:	dae90913          	add	s2,s2,-594 # 2010 <freep>
  if(p == (char*)-1)
    126a:	5afd                	li	s5,-1
    126c:	a895                	j	12e0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    126e:	00001797          	auipc	a5,0x1
    1272:	e1a78793          	add	a5,a5,-486 # 2088 <base>
    1276:	00001717          	auipc	a4,0x1
    127a:	d8f73d23          	sd	a5,-614(a4) # 2010 <freep>
    127e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1280:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1284:	b7e1                	j	124c <malloc+0x36>
      if(p->s.size == nunits)
    1286:	02e48c63          	beq	s1,a4,12be <malloc+0xa8>
        p->s.size -= nunits;
    128a:	4137073b          	subw	a4,a4,s3
    128e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1290:	02071693          	sll	a3,a4,0x20
    1294:	01c6d713          	srl	a4,a3,0x1c
    1298:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    129a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    129e:	00001717          	auipc	a4,0x1
    12a2:	d6a73923          	sd	a0,-654(a4) # 2010 <freep>
      return (void*)(p + 1);
    12a6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12aa:	70e2                	ld	ra,56(sp)
    12ac:	7442                	ld	s0,48(sp)
    12ae:	74a2                	ld	s1,40(sp)
    12b0:	7902                	ld	s2,32(sp)
    12b2:	69e2                	ld	s3,24(sp)
    12b4:	6a42                	ld	s4,16(sp)
    12b6:	6aa2                	ld	s5,8(sp)
    12b8:	6b02                	ld	s6,0(sp)
    12ba:	6121                	add	sp,sp,64
    12bc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12be:	6398                	ld	a4,0(a5)
    12c0:	e118                	sd	a4,0(a0)
    12c2:	bff1                	j	129e <malloc+0x88>
  hp->s.size = nu;
    12c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12c8:	0541                	add	a0,a0,16
    12ca:	00000097          	auipc	ra,0x0
    12ce:	eca080e7          	jalr	-310(ra) # 1194 <free>
  return freep;
    12d2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12d6:	d971                	beqz	a0,12aa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12da:	4798                	lw	a4,8(a5)
    12dc:	fa9775e3          	bgeu	a4,s1,1286 <malloc+0x70>
    if(p == freep)
    12e0:	00093703          	ld	a4,0(s2)
    12e4:	853e                	mv	a0,a5
    12e6:	fef719e3          	bne	a4,a5,12d8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    12ea:	8552                	mv	a0,s4
    12ec:	00000097          	auipc	ra,0x0
    12f0:	b92080e7          	jalr	-1134(ra) # e7e <sbrk>
  if(p == (char*)-1)
    12f4:	fd5518e3          	bne	a0,s5,12c4 <malloc+0xae>
        return 0;
    12f8:	4501                	li	a0,0
    12fa:	bf45                	j	12aa <malloc+0x94>
