# ni'o la .varik. cu kucli lo du'u xu kau frili cumki fa tu'a lo me'oi .tracker. pe la'oi .RP2350.
# .i la'e di'u krinu tu'a le datnyvei  .i la .varik. na ta'e sampla  .i ku'i la'oi .RP2350. co'e ja cinri la .varik.
# .i la .varik. cu pilno la'o glibau. Raspberry Pi Pico 2 W .glibau.

#include "shortcut.S"

#define	FAMVLA	0xFFFFFFFF	# .i .indika lo du'u fanmo lo me'oi .pattern.  .i la .varik. cu jinvi le du'u mapti fa lo nu la'oi .FAMVLA. lamji je se se lidne lo pa moi be lo'i jai .indika pe lo me'oi .pattern.

.data
patton:	.word	1,	2,	3,	4, \
		5,	6,	7,	8, \
		FAMVLA

# ni'o le pa moi cu temci namcu
# .i le re moi cu jai .indika lo du'u ma kau me'oi .XOSC. snidu pe'a lo pu'u denpa fo tu'a la'o zoi. main_lupe .zoi.
# .i le ci moi cu jai .indika tu'a lo du'u ma kau snidu pe'a lo pu'u denpa
# .i le vo moi cu jai .indika tu'a lo zgitci
# .i le mu moi cu jai .indika lo du'u zvati pe'a ma kau poi ke'a pagbu lo me'oi .pattern.
# .i le xa moi cu jai .indika lo du'u ma kau judri lo me'oi .pattern.
cur: .word	0, 				# 0 \
		0,				# 1 \
		0,	0,	0,	0, 	# 5 \
		0,	0,	0,	0, 	# 9 \
		0,	0,	0,	0,	# 13 / 0xD
		0,	0,	0,	0	# 17 / 0x11

#define	CUR_XOSC_SNIDU	1
#define	CUR_DENPA_INST(x)	4 * (2 + x)
#define	CUR_PATN_SEZVATI(x)	4 * (10 + x)
#define	CUR_PATN_JUDRI(x)	4 * (14 + x)

.global main

main:
main_init:
main_init_xosc:
	# .i zu'edji lo ka ce'u pilno la'oi .XOSC. lo temci co'e
	li	t0,	(XOSC_BASE + XOSC_CTRL_OFFSET)
	li	t1,	(XOSC_CTRL_ENABLE_BITS << XOSC_CTRL_ENABLE_BIT)
	sw	t1,	(t0)
main_init_xosc_cipra:
	li	t0,	(XOSC_BASE + XOSC_STATUS_OFFSET)
main_init_xosc_cipra_lupe:
	lw	t1,	(t0)
	andi	t1,	t1,	XOSC_STATUS_ENABLED_BIT
	beqz	t1,	main_init_xosc_cipra_lupe

main_lupe_pre:
	#define	ptn_s0	s0
	la	s0,	patton
	#define	vrc_s1	s1
	la	vrc_s1,	cur
main_lupe:
main_lupe_xosc_counter:
	lw	t1,	CUR_XOSC_SNIDU(vrc_s1)
	li	t0,	(XOSC_BASE + XOSC_COUNT_OFFSET)
	sw	t1,	(t0)

	# tcidu

	# zgike

	# denpa

	# incr
main_incri:
	lw	t1,	0(vrc_s1)
	addi	t1,	t1,	1
	sw	t1,	0(vrc_s1)

	lw	t2,	(CUR_DENPA_INST(0))(vrc_s1)
	rem	t3,	t1,	t2
	bnez	t3,	main_incri_post_0
	addi	t2,	t2,	1
	sw	t2,	(CUR_DENPA_INST(0))(vrc_s1)
main_incri_post_0:
	lw	t2,	(CUR_DENPA_INST(1))(vrc_s1)
	rem	t3,	t1,	t2
	bnez	t3,	main_incri_post_1
	addi	t2,	t2,	1
	sw	t2,	(CUR_DENPA_INST(1))(vrc_s1)
main_incri_post_1:
	lw	t2,	(CUR_DENPA_INST(2))(vrc_s1)
	rem	t3,	t1,	t2
	bnez	t3,	main_incri_post_2
	addi	t2,	t2,	1
	sw	t2,	(CUR_DENPA_INST(2))(vrc_s1)
main_incri_post_2:
	lw	t2,	(CUR_DENPA_INST(3))(vrc_s1)
	rem	t3,	t1,	t2
	bnez	t3,	main_incri_post_3
	addi	t2,	t2,	1
	sw	t2,	(CUR_DENPA_INST(3))(vrc_s1)
main_incri_post_3:

	# .i denpa fi tu'a la'oi .XOSC.
	li	t0,	(XOSC_BASE + XOSC_COUNT_OFFSET)
main_reset_denpa_lupe:
	lw	t1,	(t0)
	bnez	t1,	main_reset_denpa_lupe

	j	main_lupe
