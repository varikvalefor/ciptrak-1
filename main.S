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
# .i le vo moi je le mu moi je le xa moi je le ze moi cu jai .indika tu'a lo zgitci
# .i le bi moi cu jai .indika lo du'u zvati pe'a ma kau poi ke'a pagbu lo me'oi .pattern.
# .i le so moi cu jai .indika lo du'u ma kau judri lo me'oi .pattern.
cur: .word	0,				/* 0 */ \
	0,				/* 1 */ \
	0,	0,	0,	0, 	/* 5 */ \
	0,	0,	0,	0, 	/* 9 | ZT1 */ \
	0,	0,	0,	0, 	/* 13 / 0xD | ZT2 */ \
	0,	0,	0,	0, 	/* 17 / 0x11 | ZT3 */ \
	0,	0,	0,	0, 	/* 21 / 0x15 | ZT4 */ \
	0,	0,	0,	0,	/* 25 / 0x19 | PTSZ */ \
	0,	0,	0,	0	/* 29 / 0x1D | PTJD */

#define	CUR_XOSC_SNIDU	1
#define	CUR_DENPA_INST(x)	4 * (2 + x)
#define	CUR_ZGITCI0(x)		4 * (6 + 4 * x)
#define	CUR_PATN_SEZVATI(x)	4 * (22 + x)
#define	CUR_PATN_JUDRI(x)	4 * (26 + x)

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
main_lupe_tcidu:
	/* ni'o la .varik. cu jinvi le du'u racli fa lo nu sruma lo du'u lo ro co'e cu srana lo zgitci */
	#define	ctr_a0	a0
	#define	judri_idx_j_a1	a1
	#define	sezvati_j_a2	a2
	#define	datni_cur_j_a3	a3
	#define	judri_idx_t0	t0
	#define	sezvati_t1	t1
	li	ctr_a0,	4
	addi	judri_idx_j_a1,	vrc_s1,	CUR_PATN_JUDRI(0)
	addi	sezvati_j_a2,	vrc_s1,	CUR_PATN_SEZVATI(0)
	addi	datni_cur_j_a3,	vrc_s1,	CUR_ZGITCI0(0)
main_lupe_tcidu_lupe_co_barda:
	lw	judri_idx_t0,	(judri_idx_j_a1)
	lw	sezvati_t1,	(sezvati_j_a2)
	#define	datni_j_t2	t2
	add	datni_j_t2,	judri_idx_t0,	sezvati_t1
	#define	datni_t3	t3
	lw	datni_t3,	(datni_j_t2)
	beqz	datni_t3,	main_lupe_tcidu_lupe_co_cmalu_fanmo
	#define	pagbu_ctr_t6	t6
	li	pagbu_ctr_t6,	3
main_lupe_tcidu_lupe_co_cmalu:
	sw	datni_t3,	(datni_cur_j_a3)
	addi	pagbu_ctr_t6,	pagbu_ctr_t6,	-1
	lw	datni_t3,	(datni_j_t2)
	addi	datni_j_t2,	datni_j_t2,	4
	addi	datni_cur_j_a3,	datni_cur_j_a3,	4
	bnez	pagbu_ctr_t6,	main_lupe_tcidu_lupe_co_cmalu
main_lupe_tcidu_lupe_co_cmalu_fanmo:
	addi	ctr_a0,	ctr_a0,	-1
	addi	judri_idx_j_a1,	judri_idx_j_a1,	4
	addi	sezvati_j_a2,	sezvati_j_a2,	4
	addi	datni_cur_j_a3,	datni_cur_j_a3,	4
	bnez	ctr_a0,	main_lupe_tcidu_lupe_co_barda

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
