# ni'o la .varik. cu kucli lo du'u xu kau frili cumki fa tu'a lo me'oi .tracker. pe la'oi .RP2350.
# .i la'e di'u krinu tu'a le datnyvei  .i la .varik. na ta'e sampla  .i ku'i la'oi .RP2350. co'e ja cinri la .varik.
# .i la .varik. cu pilno la'o glibau. Raspberry Pi Pico 2 W .glibau.

#include "shortcut.S"

#define	REG_ALIAS_CLR_BITS	0x3000
#define	PADS_BANK0_GPIO0_ISO_BIT	8

#define	FAMVLA	0xFFFFFFFF	# .i .indika lo du'u fanmo lo me'oi .pattern.  .i la .varik. cu jinvi le du'u mapti fa lo nu la'oi .FAMVLA. lamji je se se lidne lo pa moi be lo'i jai .indika pe lo me'oi .pattern.

.data
patton:	.word	1,	2,	3,	4, \
		5,	6,	7,	8, \
		FAMVLA

cur: .word	0,				/* 0 */ \
	/* ^ .i temci namcu */ \
	0,				/* 1 */ \
	/* ^ .i .indika lo du'u ma kau me'oi .XOSC. snidu pe'a lo pu'u denpa fo tu'a la'o zoi. main_lupe .zoi. */ \
	0,	0,	0,	0, 	/* 5 */ \
	/* ^ .i .indika tu'a lo du'u ma kau snidu pe'a lo pu'u denpa */ \
	0,	0,	0,	0, 	/* 9 | ZT1 */ \
	0,	0,	0,	0, 	/* 13 / 0xD | ZT2 */ \
	0,	0,	0,	0, 	/* 17 / 0x11 | ZT3 */ \
	0,	0,	0,	0, 	/* 21 / 0x15 | ZT4 */ \
	/* ^ .i le vo co'e cu jai .indika tu'a lo zgitci */ \
	0,	0,	0,	0,	/* 25 / 0x19 | PTSZ */ \
	/* ^ .i le bi moi cu jai .indika lo du'u zvati pe'a ma kau poi ke'a pagbu lo me'oi .pattern. */ \
	0,	0,	0,	0	/* 29 / 0x1D | PTJD */
	/* ^ .i le so moi cu jai .indika lo du'u ma kau judri lo me'oi .pattern. */

#define	CUR_XOSC_SNIDU	4 * 1
#define	CUR_DENPA_INST(x)	4 * (2 + x)
#define	CUR_ZGITCI0(x)		4 * (6 + 4 * x)
#define	CUR_PATN_SEZVATI(x)	4 * (22 + x)
#define	CUR_PATN_JUDRI(x)	4 * (26 + x)

.global main

main:
main_init:
main_onit_oe:
	# .i curmi tu'a lo dikca
	li	t0,	SIO_BASE + GPIO_OE_SET_OFFSET
	li	t1,	0 | (1<<2) | (1<<4) | (1<<6)
	sw	t1,	(t0)
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

main_lupe_tcidu:
	/* ni'o la .varik. cu jinvi le du'u racli fa lo nu sruma lo du'u lo ro co'e cu srana lo zgitci */
	/* ni'o ji'a la .varik. cu jinvi le du'u cumki fa lo nu me'oi .unroll.
	   .i ku'i la .varik. cu jinvi le du'u banzuka le ka ce'u jai pluja kei le ka mapti fa lo nu na me'oi .unroll. ce'u  .i la .varik. cu jinvi le du'u le na'e me'oi .unroll. versiio cu zmadu fi le ka frili fa lo nu jimpe fi ce'u
	   .i ku'i la .varik. cu co'e ja djica curmi tu'a lo pinka */
	#define	ctr_a0	a0
	#define	judri_j_a1	a1
	#define	sezvati_j_a2	a2
	#define	datni_cur_j_a3	a3
	#define	judri_t0	t0
	#define	sezvati_t1	t1
	li	ctr_a0,	4
	addi	judri_j_a1,	vrc_s1,	CUR_PATN_JUDRI(0)
	addi	sezvati_j_a2,	vrc_s1,	CUR_PATN_SEZVATI(0)
	addi	datni_cur_j_a3,	vrc_s1,	CUR_ZGITCI0(0)
main_lupe_tcidu_lupe_co_barda:
	lw	judri_t0,	(judri_j_a1)
	lw	sezvati_t1,	(sezvati_j_a2)
	#define	datni_j_t2	t2
	add	datni_j_t2,	judri_t0,	sezvati_t1
	#define	datni_t3	t3
	lw	datni_t3,	(datni_j_t2)
	beqz	datni_t3,	main_lupe_tcidu_lupe_co_cmalu_fanmo
	#define	pagbu_ctr_t4	t4
	li	pagbu_ctr_t4,	3
main_lupe_tcidu_lupe_co_cmalu:
	sw	datni_t3,	(datni_cur_j_a3)
	addi	pagbu_ctr_t4,	pagbu_ctr_t4,	-1
	lw	datni_t3,	(datni_j_t2)
	addi	datni_j_t2,	datni_j_t2,	4
	addi	datni_cur_j_a3,	datni_cur_j_a3,	4
	bnez	pagbu_ctr_t4,	main_lupe_tcidu_lupe_co_cmalu
main_lupe_tcidu_lupe_co_cmalu_fanmo:
	addi	ctr_a0,	ctr_a0,	-1
	addi	judri_j_a1,	judri_j_a1,	4
	addi	sezvati_j_a2,	sezvati_j_a2,	4
	addi	datni_cur_j_a3,	datni_cur_j_a3,	4
	bnez	ctr_a0,	main_lupe_tcidu_lupe_co_barda

	# zgike
	addi	a0,	vrc_s1,	CUR_ZGITCI0(0)
	lw	a0,	(a0)
	addi	a1,	vrc_s1,	4 + CUR_ZGITCI0(0)
	lw	a1,	(a1)
	addi	a2,	vrc_s1,	8 + CUR_ZGITCI0(0)
	lw	a2,	(a2)
	addi	a3,	vrc_s1,	0xC + CUR_ZGITCI0(0)
	lw	a3,	(a3)
	li	a4,	0
	jal	zgitci_frob
	addi	a0,	vrc_s1,	CUR_ZGITCI0(1)
	lw	a0,	(a0)
	addi	a1,	vrc_s1,	4 + CUR_ZGITCI0(1)
	lw	a1,	(a1)
	addi	a2,	vrc_s1,	8 + CUR_ZGITCI0(1)
	lw	a2,	(a2)
	addi	a3,	vrc_s1,	0xC + CUR_ZGITCI0(1)
	lw	a3,	(a3)
	li	a4,	1
	jal	zgitci_frob
	addi	a0,	vrc_s1,	CUR_ZGITCI0(2)
	lw	a0,	(a0)
	addi	a1,	vrc_s1,	4 + CUR_ZGITCI0(2)
	lw	a1,	(a1)
	addi	a2,	vrc_s1,	8 + CUR_ZGITCI0(2)
	lw	a2,	(a2)
	addi	a3,	vrc_s1,	0xC + CUR_ZGITCI0(2)
	lw	a3,	(a3)
	li	a4,	2
	jal	zgitci_frob
	addi	a0,	vrc_s1,	CUR_ZGITCI0(3)
	lw	a0,	(a0)
	addi	a1,	vrc_s1,	4 + CUR_ZGITCI0(3)
	lw	a1,	(a1)
	addi	a2,	vrc_s1,	8 + CUR_ZGITCI0(3)
	lw	a2,	(a2)
	addi	a3,	vrc_s1,	0xC + CUR_ZGITCI0(3)
	lw	a3,	(a3)
	li	a4,	3
	jal	zgitci_frob

	# incr
main_incri:
	#define	temci_t1	t1
	lw	temci_t1,	0(vrc_s1)
	addi	temci_t1,	temci_t1,	1
	sw	temci_t1,	0(vrc_s1)

	lw	t2,	(CUR_DENPA_INST(0))(vrc_s1)
	rem	t3,	temci_t1,	t2
	bnez	t3,	main_incri_post_0
	addi	t2,	t2,	1
	sw	t2,	(CUR_DENPA_INST(0))(vrc_s1)
main_incri_post_0:
	lw	t2,	(CUR_DENPA_INST(1))(vrc_s1)
	rem	t3,	temci_t1,	t2
	bnez	t3,	main_incri_post_1
	addi	t2,	t2,	1
	sw	t2,	(CUR_DENPA_INST(1))(vrc_s1)
main_incri_post_1:
	lw	t2,	(CUR_DENPA_INST(2))(vrc_s1)
	rem	t3,	temci_t1,	t2
	bnez	t3,	main_incri_post_2
	addi	t2,	t2,	1
	sw	t2,	(CUR_DENPA_INST(2))(vrc_s1)
main_incri_post_2:
	lw	t2,	(CUR_DENPA_INST(3))(vrc_s1)
	rem	t3,	temci_t1,	t2
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

#define	zgitci_a4	a4
zgitci_frob:
	bnez	a0,	zgitci_frob_mapti_0
	ret
zgitci_frob_mapti_0:
	li	t1,	1
	bne	a0,	t1,	zgitci_frob_check_2
	#define	pwm_slice_a5	a5
	andi	pwm_slice_a5,	a1,	0b11
	li	t0,	0x14
	mul	t0,	a1,	t0
	li	t1,	PWM_BASE
	add	t0,	t0,	t1
	lw	t1,	(t0)
	andi	t1,	t1,	PWM_CSR_PH_EN_BIT
	beqz	t1,	zgitci_frob_1_pwm_aktigau
	slli    t0,     pwm_slice_a5,        (1 + 3) # 8 * PIN
	// addi	t0,	t0,	4	# IO_BANK0_GPIOx_CTRL_OFFSET
	li	t1,	IO_BANK0_BASE + 4 // "
	add	t0,	t0,	t1
	lw	t1,	(t0)
	li	t0,	4 # GPIO PWM
	beq	t1,	t0,	zgitci_frob_1_pwm_aktigau_se_lidne
	/* ^ .i sruma lo du'u mapti va'o zo'e */
zgitci_frob_1_pwm_aktigau:
	li	t0,	RESETS_BASE + RESETS_RESET_OFFSET + REG_ALIAS_CLR_BITS
	li	t1,	(1<<RESETS_PWM_BIT) | (1<<RESETS_PADS_BANK0_BIT) | (1<<RESETS_IO_BANK0_BIT)
	sw	t1,	(t0)
	li	t0,	RESETS_BASE + RESETS_RESET_DONE_OFFSET
	li	t1,	(1<<RESETS_IO_BANK0_BIT) | (1<<RESETS_PWM_BIT) | (1<<RESETS_PADS_BANK0_BIT)
zgitci_frob_1_pwm_aktigau_denpa:
	lw	t2,	(t0)
	and	t2,	t2,	t1
	bne	t1,	t2,	zgitci_frob_1_pwm_aktigau_denpa

	# IO_BANK0_GPIOx_CTRL
	slli	t0,	pwm_slice_a5,	(1 + 2)	# 4 * PIN
	// addi	t0,	t0,	4 # PADS_BANK0_GPIOx_OFFSET
	li	t1,	PADS_BANK0_BASE + REG_ALIAS_CLR_BITS + 4 // "
	add	t0,	t0,	t1
	li	t1,	(1<<PADS_BANK0_GPIO0_ISO_BIT) | (1<<5 + 1<<4) # drive
	sw	t1,	(t0)

	# GPIO_FUNC_PWM
	slli    t0,     pwm_slice_a5,        (1 + 3) # 8 * PIN
	li	t1,	IO_BANK0_BASE + 4 # IO_BANK0_GPIOx_CTRL_OFFSET
	add	t0,	t0,	t1
	li	t1,	4 # GPIO PWM
	sw	t1,	(t0)
zgitci_frob_1_pwm_aktigau_se_lidne:
zgitci_frob_1_pwm_div_ningau:
	srli	t0,	a1,	2
	li	t1,	0b11111111111111
	and	t0,	t0,	t1
	#define	zenba_t1	t1
	#define	jdika_t2	t2
	bexti	zenba_t1,	t0,	17
	bexti	jdika_t2,	t0,	16
	bclri	t0,	t0,	17
	bclri	t0,	t0,	16
	#define	div_j_t3	t3
	li	t3,	0x14 * 2
	mul	t3,	t3,	pwm_slice_a5
	li	t4,	PWM_BASE
	add	div_j_t3,	t3,	t4
	bne	zenba_t1,	jdika_t2,	zgitci_frob_1_pwm_div_sampu
	bnez	zenba_t1,	zgitci_frob_1_pwm_div_slilu
zgitci_frob_1_pwm_div_basti:
	sw	t0,	(div_j_t3)
	j	zgitci_frob_1_pwm_csr
zgitci_frob_1_pwm_div_slilu:
	# ???
	# TODO
	j	zgitci_frob_1_pwm_csr
zgitci_frob_1_pwm_div_sampu:
	lw	t4,	(div_j_t3)
	beqz	zenba_t1,	zgitci_frob_1_pwm_div_sampu_jdika
	add	t0,	t0,	t4
	sw	t0,	(div_j_t3)
	j	zgitci_frob_1_pwm_csr
zgitci_frob_1_pwm_div_sampu_jdika:
	sub	t0,	t0,	t4
	sw	t0,	(div_j_t3)
zgitci_frob_1_pwm_csr:
	/* ni'o vajni fa ma pe la'oi .CSR.
	 * .i djica tu'a la'oi .A_INV. ji la'oi .PH_CORRECT. ji la'oi .DIVMODE. ji ma
	 * .i la .varik. cu jinvi le du'u frili cumki fa ko'a goi lo nu rejgau pe'a ro lo ze me'oi .bit.
	 * .i ku'i la .varik. na birti lo du'u xu kau ko'a banzuka lo ka ce'u tolmapti lo nu na'e binxo pe'a kei kei lo ka ce'u mapti
	 */
	# PWM_CHx_CSR_OFFSET
	# ???
	# TODO

	# PWM_CHx_TOP_OFFSET
	# ???
	# TODO

	# PWM_CHx_CC_OFFSET
	# ???
	# TODO
	# ???

	ret
zgitci_frob_check_2:
	# todo
zgtici_frob_c000_mv:
	#define	patn_a1	a1
	#define	sezvati_a2	a2
	li	t1,	0xC0000000
	bclri	t1,	a0,	0
	bne	a0,	t0,	zgitci_frob_deaf_xosc
	/* se morji: 	CUR_PATN_SEZVATI(x)	4 * (22 + x)
			CUR_PATN_JUDRI(x)	4 * (26 + x) */
	#define	sezvati_j_t0	t0
	#define	judri_j_t1	t1
	addi	t0,	zgitci_a4,	22
	slli	sezvati_j_t0,	t0,	2
	sw	sezvati_a2,	(sezvati_j_t0)
	addi	t1,	zgitci_a4,	26
	slli	judri_j_t1,	t0,	2
	sw	patn_a1,	(judri_j_t1)

	bexti	t0,	a0,	0
	beqz	t0,	zgtici_frob_c000_mv_post
	// If my calculations are correct, when this baby hits 88 miles per hour, you're going to see some serious shit.
	add	t0,	sezvati_j_t0,	judri_j_t1
	lw	a0,	(t0)
	lw	a1,	4(t0)
	lw	a2,	8(t0)
	lw	a3,	0xC(t0)
	addi	sp,	sp,	-4
	sw	s0,	(sp)
	mv	s0,	ra
	jal	zgitci_frob
	mv	ra,	s0
	lw	s0,	(sp)
	addi	sp,	sp,	4
zgtici_frob_c000_mv_post:
	ret

/*
 * 0xDEAF0000
 *
 * 0xXXXX [dp: 0xXXXX]
 * ^ .i sa'u co'e ja cpedu lo nu lo me'oi .dp. cu snidu pe'a tu'a la'oi .XOSC.
 *
 * XXX[x1][st: bbbbbbbbbbbb]
 * ^ .i sa'u lo me'oi .x1. srana lo du'u xu kau djica lo nu co'e co ni zilsutra
 *   .i sa'u lo me'oi .st. cu mu'oi zoi. FREQ_RANGE .zoi. namcu
 *
 * ?
 */
zgitci_frob_deaf_xosc:
	li	t0,	0xDEAF0000
	bne	a0,	t0,	zgitci_frob_deaf_xosc_post
	li	t1,	0xFFFF
	and	t0,	a1,	t1
	sw	t1,	CUR_XOSC_SNIDU(vrc_s1)

	li	t0,	0xFFF
	bexti	t1,	a2,	(1 + 4 * 3)
	beqz	t1,	zgitci_frob_deaf_xosc_post
	and	t1,	a2,	t0
	li	t0,	(XOSC_BASE + XOSC_CTRL_OFFSET)
	sw	t1,	(t0)
zgitci_frob_deaf_xosc_post:
	ret
