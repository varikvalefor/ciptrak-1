/*
ni'o la .varik. cu morji le du'u vo'a benji fi le co'e ja pendo be vo'a fa lo notci pe zoi zoi.

	ni'o la .varik. cu tolsti lo pu'u vo'a ciksi lo me'oi .tracker. proga fo la'oi .RP2350.
	.i la .varik. cu co'e ja narka'e zo'e je tu'a lo zgike je cu co'e ja se cnino tu'a la'oi .RP2350.
	.i ku'i la .varik. cu co'e ja cinmo lo ka la'oi .RP2350. cusku pe'a lo se du'u ri djica pe'a tu'a lo me'oi .tracker. proga kei ce'u
	.i la .varik. na krici lo du'u lo skami cu prenu ja cu se xadni lo prenu  .i ku'i la .varik. cu jinvi le du'u lo skami cu mapti lo su'o co'e je cu tolmapti lo su'o co'e

	VARIK begins the process of explaining (for the RP2350) a music tracker program.
	VARIK is stupid with music and whatnot.  Additionally, the RP2350 is new/whatever for VARIK.
	But VARIK feels/whatever that the RP2350 "states" (to VARIK) that the RP2350 "desires" a music tracker program.
	VARIK does not believe that computers are prenu or are bodies of prenu.  But VARIK opines that computers are appropriate for some things and are ill-suited for some things.

.zoi.  .i la .varik. na birti lo du'u le notci cu jai filri'a lo nu jimpe ji kau lo nu jinvi lo du'u vo'a jai fenki  .i ku'i la .varik. na birti le du'u ri na fenki

.i la .varik. cu jinvi le du'u vo'a pilno lo mu'oi glibau. Raspberry Pi Pico 2 W .glibau.

.i la .varik. cu kucli lo du'u ma kau mapti la'oi .RP2350. jenai zo'e
*/

#include "shortcut.S"

#define	REG_ALIAS_CLR_BITS	0x3000
#define	PADS_BANK0_GPIO0_ISO_BIT	8

#define	FAMVLA	0xFFFFFFFF	# .i .indika lo du'u fanmo lo me'oi .pattern.  .i la .varik. cu jinvi le du'u mapti fa lo nu la'oi .FAMVLA. lamji je se se lidne lo pa moi be lo'i jai .indika pe lo me'oi .pattern.

.data
/* | TODO: .i xu frili cumki fa lo nu vimcu pe'a */
patton:	.word	1,	2,	3,	4, \
		5,	6,	7,	8, \
		FAMVLA

/* | .i sa'u liste lo'i judri be lo me'oi .sample.
 * .i sa'u nai ru'e ga naja mapti gi ro da poi ke'a kacna'u je cu dubjavme'a lo ni barda zo'u
 * su'o de zo'u du...
   * fa ga ce'o...
     * lo meirmoi be da bei la'oi .sanceListe. be'o gi
     * lo meirmoi be lo sumji be li pa bei da be'o be'o bei la'oi .sanceListe.
   * fe lo judri be de be'o ce'o lo ni de barda
*/
sanceListe: .word	0,	0,	0,	0

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
	0,	0,	0,	0,	/* 29 / 0x1D | PTJD */ \
	/* ^ .i le so moi cu jai .indika lo du'u ma kau judri lo me'oi .pattern. */ \
	0,	0,	0,	0,	/* 33 / 0x21 | SIDX */ \
	/* ^ .i co'e ja me'oi .sample. se zvati */ \
	0,	0,	0,	0,	/* 37 / 0x25 | POCKET SAND */ \
	/* \
	 * ^ .i me'oi .SHA256. ke cunso pe'a \
	 * .i pilno la'oi .SHA256. jenai la'oi .TRNG. ki'u zo'e joi le su'u jinvi le du'u la'oi .SHA256. zmadu fi le ka ce'u jai zilsutra \
	 * .i la .varik. na jinvi le du'u sarcu fa lo nu zmadu fi le ka ce'u cunso pe'a \
	 * \
	 */ \
	0,	/* 38 / 0x26 | SHA_EN */\
	/* ^ .i xu djica tu'a lo me'oi .SHA256. co'e */ \
	0,	0,	0,	0	/* 42 / 2A | SIVNI */ \
	/* ^ .i zgitci pe'a sivni datni */

#define	CUR_TEMCI	4 * 0
#define	CUR_XOSC_SNIDU	4 * 1
#define	CUR_DENPA_INST(x)	4 * (2 + x)
#define	CUR_ZGITCI0(x)		4 * (6 + 4 * x)
#define	CUR_PATN_SEZVATI_OFFSET	22
#define	CUR_PATN_SEZVATI(x)	4 * (CUR_PATN_SEZVATI_OFFSET + x)
#define	CUR_PATN_JUDRI_OFFSET	26
#define	CUR_PATN_JUDRI(x)	4 * (CUR_PATN_JUDRI_OFFSET + x)
#define	CUR_ZGITCI_SAMP_IDX_OFFSET	30
#define	CUR_ZGITCI_SAMP_IDX(x)	4 * (CUR_ZGITCI_SAMP_IDX_OFFSET + x)
#define	CUR_SHA_OFFSET	4 * 34
#define	CUR_SHA_EN_OFFSET	38
#define	CUR_SHA_EN	4 * CUR_SHA_EN_OFFSET
#define	CUR_ZGITCI_SIVNI_OFFSET	39
#define	CUR_ZGITCI_SIVNI(x)	4 * (CUR_ZGITCI_SIVNI_OFFSET + x)

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
	// | t0 = XOSC_BASE + XOSC_STATUS_OFFSET
	addi	t0,	t0,	XOSC_STATUS_OFFSET - XOSC_CTRL_OFFSET
main_init_xosc_cipra_lupe:
	lw	t1,	(t0)
	li	t2,	RESETS_BASE + RESETS_RESET_OFFSET	// lw opt; main_init_sha256
	bexti	t1,	t1,	XOSC_STATUS_ENABLED_BIT
	beqz	t1,	main_init_xosc_cipra_lupe
main_init_sha256:
	/* ni'o jitfa fa le du'u sarcu fa lo nu pilno
	 * .i ku'i la .varik. cu jinvi le du'u lo nu me'oi .reset. va'o lo nu djuno lo du'u pilno
	 * cu zmadu fi le ka ce'u jai zilmasno */
	lw	t1,	(t2)
	bseti	t1,	t1,	RESETS_SHA256_BIT
	sw	t1,	(t2)

main_lupe_pre:
	#define	vrc_s1	s1
	la	vrc_s1,	cur
main_lupe:
main_lupe_xosc_counter:
	lw	t1,	CUR_XOSC_SNIDU(vrc_s1)
	li	t0,	(XOSC_BASE + XOSC_COUNT_OFFSET)
	sw	t1,	(t0)

main_lupe_sha:
	/* DROP [at][01234567] */

	addi	t0,	vrc_s1,	CUR_SHA_EN
	lw	t0,	(t0)
	beqz	t0,	main_lupe_tcidu

	addi	t0,	vrc_s1,	CUR_TEMCI
	lw	t0,	(t0)
	li	t1,	1	// x48Xyorh.  lw opt
	andi	t0,	t0,	0xF
	bnez	t0,	main_lupe_tcidu

	li	t0,	SHA256_BASE + SHA256_CSR_OFFSET
	// li	t1,	1	// .i mapti fa zo'e pe zo'oi .x48Xyorh.
	sw	t1,	(t0)

	// not (dma design)
	#define	dma_rd_j_t2	t2
	#define	dma_w_j_t3	t3
	#define	dma_tx_j_t4	t4
	#define	dma_ctrl_t5	t5
	addi	t1,	vrc_s1,	CUR_PATN_SEZVATI(0)
	li	dma_rd_j_t2,	DMA_BASE + DMA_CHx_READ_ADDR_OFFSET(0)
	sw	t1,	(dma_rd_j_t2)
	li	t0,	SHA256_BASE + SHA256_WDATA_OFFSET
	// | li	dma_w_j_t3,	DMA_BASE + DMA_CHx_WRITE_ADDR_OFFSET(0)
	addi	dma_w_j_t3,	dma_rd_j_t2,	(DMA_CHx_WRITE_ADDR_OFFSET(0) - DMA_CHx_READ_ADDR_OFFSET(0))
	sw	t0,	(dma_w_j_t3)
	// | li	dma_tx_j_t4,	DMA_BASE + DMA_CHx_TRANS_COUNT_OFFSET(0)
	addi	dma_tx_j_t4,	dma_w_j_t3,	(DMA_CHx_TRANS_COUNT_OFFSET(0) - DMA_CHx_WRITE_ADDR_OFFSET(0))
	li	t1,	(512 / 32)
	sw	t1,	(dma_tx_j_t4)
	// li	dma_ctrl_t5,	DMA_BASE + DMA_CHx_CTRL_TRIG_OFFSET(0)
	addi	dma_ctrl_t5,	dma_tx_j_t4,	(DMA_CHx_CTRL_TRIG_OFFSET(0) - DMA_CHx_TRANS_COUNT_OFFSET(0))
	li	t1,	1 | (0x2 << 2)
	sw	t1,	(dma_ctrl_t5)

	/* ni'o la .varik. cu jinvi fo zo'e joi le du'u masno tu'a la'oi .dma_ctrl_t5. kei fe le du'u na sarcu fa lo me'oi .nop. co'e */

	addi	t0,	vrc_s1,	CUR_SHA_OFFSET
	sw	t0,	(dma_w_j_t3)
	li	t0,	SHA256_BASE + SHA256_SUM0_OFFSET
	sw	t0,	(dma_rd_j_t2)
	li	t0,	4
	sw	t0,	(dma_tx_j_t4)
	sw	t1,	(dma_ctrl_t5) // hack hack hack

	addi    t0,     vrc_s1, CUR_SHA_EN
	sw	x0,	(t0)

main_lupe_tcidu:
	/* DROP [at][01234567] */

	/* ni'o la .varik. cu jinvi le du'u racli fa lo nu sruma lo du'u lo ro co'e cu srana lo zgitci */
	/* ni'o ji'a la .varik. cu jinvi le du'u cumki fa lo nu me'oi .unroll.
	   .i ku'i la .varik. cu jinvi le du'u banzuka le ka ce'u jai pluja kei le ka mapti fa lo nu na me'oi .unroll. ce'u  .i la .varik. cu jinvi le du'u le na'e me'oi .unroll. versiio cu zmadu fi le ka frili fa lo nu jimpe fi ce'u
	   .i ku'i la .varik. cu co'e ja djica curmi tu'a lo pinka */
	#define	ctr_a0	a0
	#define	judri_j_a1	a1
	#define	datni_cur_j_a3	a3
	#define	judri_t0	t0
	#define	sezvati_t1	t1
	#define	sivniP_t4	t4
	li	ctr_a0,	4
	addi	judri_j_a1,	vrc_s1,	4 * CUR_PATN_JUDRI(0)
	addi	datni_cur_j_a3,	vrc_s1,	CUR_ZGITCI0(0)
main_lupe_tcidu_lupe_co_barda:
	lw	judri_t0,	(judri_j_a1)
	lw	sezvati_t1,	(4 * (CUR_PATN_SEZVATI(0) - CUR_PATN_JUDRI(0)))(judri_j_a1)
	#define	datni_j_t2	t2
	add	datni_j_t2,	judri_t0,	sezvati_t1
	#define	datni_t3	t3
	lw	datni_t3,	(datni_j_t2)
	// | .i la .varik. cu jimpe le du'u cumki fa lo nu na pilno
	// .i ku'i la .varik. cu jinvi le du'u na'e vecnu pe'a tu'a zo'oi .li. ri'a tu'a zo'oi .lw.
	li	sivniP_t4,	CUR_ZGITCI_SIVNI_OFFSET + 4	// lw opt; NZwe53kb_1
	beqz	datni_t3,	main_lupe_tcidu_lupe_co_cmalu_fanmo
main_lupe_tcidu_lupe_vimcu:
	lw	t5,	(datni_cur_j_a3)
	sub	sivniP_t4,	sivniP_t4,	ctr_a0	// lw opt; NZwe53kb_2
	beq	t5,	datni_t3,	main_lupe_tcidu_lupe_co_cmalu

	// se morji: CUR_ZGITCI_SIVNI(0)     4 * (CUR_ZGITCI_SIVNI_OFFSET + x)
	// .i vimcu ki'u zo'e joi le su'u steci tu'a lo zgitci pe'a
	// .i ku'i la .varik. na ba'e birti lo du'u xu kau mapti
	#define	sivni_t5	t5
	// li	sivniP_t4,	CUR_ZGITCI_SIVNI_OFFSET + 4	// .i ronsa zo'e pe zoi zoi. NZwe53kb_1 .zoi.
	// sub	sivniP_t4,	sivniP_t4,	ctr_a0	// .i ronsa zo'e pe zoi zoi. NZwe53kb_2 .zoi.  .i indika tu'a zoi zoi. ctr_a0 = 4 - CUR_ZGITCI .zoi.  .i la'oi .Maxima. jai .indika tu'a zoi zoi. (CUR_ZGITCI_SIVNI_OFFSET + 4) - (4 - x) = CUR_ZGITCI_SIVNI_OFFSET + x .zoi.
	sh2add	sivni_t5,	vrc_s1,	t4
	sw	x0,	(sivni_t5)
main_lupe_tcidu_lupe_co_cmalu:
	#define	datni2_t4	t4
	lw	datni_t3,	(datni_j_t2)
	lw	datni2_t4,	4(datni_j_t2)
	sw	datni_t3,	(datni_cur_j_a3)
	sw	datni2_t4,	4(datni_cur_j_a3)
	lw	datni_t3,	8(datni_j_t2)
	lw	datni2_t4,	0xC(datni_j_t2)
	sw	datni_t3,	8(datni_cur_j_a3)
	sw	datni2_t4,	0xC(datni_cur_j_a3)
main_lupe_tcidu_lupe_co_cmalu_fanmo:
	addi	ctr_a0,	ctr_a0,	-1	// TODO: .i xu frili cumki fa lo nu sisti tu'a la'oi .ctr_a0.
	addi	judri_j_a1,	judri_j_a1,	4
	addi	datni_cur_j_a3,	datni_cur_j_a3,	4
	bnez	ctr_a0,	main_lupe_tcidu_lupe_co_barda

main_incri:
	/* DROP [at][01234567] */

	#define	temci_t1	t1
	lw	temci_t1,	CUR_TEMCI(vrc_s1)

	/* TODO
	 * .i xu frili cumki fa lo nu jdikygau pe'a fi lo ka ce'u zilmasno
	 */
	lw	t2,	(CUR_PATN_SEZVATI(0))(vrc_s1)
	lw	t4,	(CUR_PATN_SEZVATI(1))(vrc_s1)
	rem     t3,     temci_t1,       t2
	rem	t5,	temci_t1,	t4
	lw	a0,	(CUR_PATN_SEZVATI(2))(vrc_s1)
	lw	a2,	(CUR_PATN_SEZVATI(3))(vrc_s1)
	rem	a1,	temci_t1,	a0
	rem	a3,	temci_t1,	a2

	bnez	t3,	main_incri_next_t5
	addi    t2,     t2,     1
	sw      t2,     (CUR_PATN_SEZVATI(0))(vrc_s1)
main_incri_next_t5:
	bnez	t5,	main_incri_next_a0
	addi    t4,     t4,     1
	sw      t4,     (CUR_PATN_SEZVATI(1))(vrc_s1)
main_incri_next_a0:
	bnez	a1,	main_incri_next_a2
	addi    a0,     a0,     1
	sw      a0,     (CUR_PATN_SEZVATI(2))(vrc_s1)
main_incri_next_a2:
	bnez	a3,	main_reset_denpa
	addi    a2,     a2,     1
	sw      a2,     (CUR_PATN_SEZVATI(3))(vrc_s1)

	addi	temci_t1,	temci_t1,	1
	sw	temci_t1,	CUR_TEMCI(vrc_s1)

main_lupe_zgike:
	/* DROP [at][01234567] */

	addi	t0,	vrc_s1,	CUR_ZGITCI0(0)
	lw	a0,	0x0(t0)
	lw	a1,	0x4(t0)
	lw	a2,	0x8(t0)
	lw	a3,	0xC(t0)
	li	a4,	0
	jal	zgitci_frob
	addi	t0,	vrc_s1,	CUR_ZGITCI0(1)
	lw	a0,	0x0(t0)
	lw	a1,	0x4(t0)
	lw	a2,	0x8(t0)
	lw	a3,	0xC(t0)
	li	a4,	1
	jal	zgitci_frob
	addi	t0,	vrc_s1,	CUR_ZGITCI0(2)
	lw	a0,	0x0(t0)
	lw	a1,	0x4(t0)
	lw	a2,	0x8(t0)
	lw	a3,	0xC(t0)
	li	a4,	2
	jal	zgitci_frob
	addi	t0,	vrc_s1,	CUR_ZGITCI0(3)
	lw	a0,	0x0(t0)
	lw	a1,	0x4(t0)
	lw	a2,	0x8(t0)
	lw	a3,	0xC(t0)
	li	a4,	3
	jal	zgitci_frob
	// 6 by 6
	// 7 by 7
	// 8 by 8
	// 9 by 9

main_reset_denpa:
	/* DROP [at][01234567] */

	# .i denpa fi tu'a la'oi .XOSC.
	li	t0,	(XOSC_BASE + XOSC_COUNT_OFFSET)
main_reset_denpa_lupe:
	lh	t1,	2(t0)	// TODO: .i xu mapti  .i morji le du'u mu'oi glibau. little-endian .glibau.
	bnez	t1,	main_reset_denpa_lupe

	j	main_lupe

#define	zgitci_a4	a4
// | TODO: .i xu lo me'oi .switch. co'e cu zmadu
zgitci_frob:
	/* TODO: .i xu cadga fa lo nu bixygau pe'a fi lo me'oi .switch. co'e  .i la .varik. cu jinvi le du'u zmadu fi le ka ce'u mapti tu'a lo so'i co'e... kei jenai ku'i le ka ce'u mapti tu'a lo ke jai .indika ke'e namcu */
	bnez	a0,	zgitci_frob_mapti_0
	ret

/* PWM
 *
 * 0x1
 *
 * [?: 0xXXXXXXX][?: 0bXX][slice: 0bXX]
 *
 * ?
 *
 * ?
 *
 * ?
 *
 */
zgitci_frob_mapti_0:
	li	t1,	1
	bne	a0,	t1,	zgitci_frob_check_2
zgitci_frob_mapti_0_xu_akti:
	#define	SIVNI_A1_SLICE_BITS	0b11
	#define	pwm_slice_a5	a5
	andi	pwm_slice_a5,	a1,	SIVNI_A1_SLICE_BITS

	li	t0,	PWM_BASE + PWM_EN_OFFSET
	lw	t0,	(t0)
	bext	t1,	t0,	pwm_slice_a5
	beqz	t1,	zgitci_frob_1_pwm_aktigau

	#define	gpio_ctrl_j_t0	t0
	// se morji: IO_BANK0_GPIOx_CTRL(x)  0x004 + 0x008 * x
	slli    t0,     pwm_slice_a5,        (1 + 3) # 8 * PIN
	// addi	t0,	t0,	4	# IO_BANK0_GPIOx_CTRL_OFFSET
	li	t1,	IO_BANK0_BASE + 4 // "
	add	gpio_ctrl_j_t0,	t0,	t1
	#define	gpio_curf_t1	t1
	lw	gpio_curf_t1,	(gpio_ctrl_j_t0)
	li	t2,	4 # GPIO PWM
	/* | .i sruma lo du'u mapti va'o zo'e */
	beq	gpio_curf_t1,	t2,	zgitci_frob_1_pwm_aktigau_se_lidne
	sw	t2,	(gpio_ctrl_j_t0)
zgitci_frob_1_pwm_aktigau:
	/* DROP t[0-6] */

	li	t0,	RESETS_BASE + RESETS_RESET_OFFSET + REG_ALIAS_CLR_BITS
	li	t1,	(1<<RESETS_PWM_BIT) | (1<<RESETS_PADS_BANK0_BIT) | (1<<RESETS_IO_BANK0_BIT)
	sw	t1,	(t0)
	li	t0,	RESETS_BASE + RESETS_RESET_DONE_OFFSET	// TODO: .i xu lo me'oi .addi. co'e cu frili cumki
	li	t1,	(1<<RESETS_IO_BANK0_BIT) | (1<<RESETS_PWM_BIT) | (1<<RESETS_PADS_BANK0_BIT)
zgitci_frob_1_pwm_aktigau_denpa:
	lw	t2,	(t0)
	and	t2,	t2,	t1
	bne	t1,	t2,	zgitci_frob_1_pwm_aktigau_denpa

	/* DROP t[0-6] */

	# IO_BANK0_GPIOx_CTRL
	#define	pads_gpio_j_t0	t0
	slli	t0,	pwm_slice_a5,	(1 + 2)	# 4 * PIN
	// addi	t0,	t0,	4 # PADS_BANK0_GPIOx_OFFSET
	li	t1,	PADS_BANK0_BASE + REG_ALIAS_CLR_BITS + 4 // "
	add	pads_gpio_j_t0,	t0,	t1
	li	t1,	(1<<PADS_BANK0_GPIO0_ISO_BIT) | (1<<5 + 1<<4) # drive
	sw	t1,	(pads_gpio_j_t0)
zgitci_frob_1_pwm_aktigau_se_lidne:
zgitci_frob_1_pwm_div:
	srli	t0,	a1,	2
	li	t1,	0b11111111111111
	and	t0,	t0,	t1
	#define	zenba_t1	t1
	#define	jdika_t2	t2
	// | TODO: .i xu mapti
	bexti	zenba_t1,	a1,	17
	bexti	jdika_t2,	a1,	16
	#define	div_j_t3	t3
	// se morji: PWM_CHx_DIV_OFFSET(x)   4 + x * 0x14
	li	t3,	0x14
	mul	t3,	t3,	pwm_slice_a5
	li	t4,	PWM_BASE + 4
	add	div_j_t3,	t3,	t4
	bne	zenba_t1,	jdika_t2,	zgitci_frob_1_pwm_div_sampu
	bnez	zenba_t1,	zgitci_frob_1_pwm_div_slilu
zgitci_frob_1_pwm_div_basti:
	sw	t0,	(div_j_t3)
	j	zgitci_frob_1_pwm_csr
zgitci_frob_1_pwm_div_slilu:
	/* TODO
	 *
	 * .i slilu ma
	 */
	j	zgitci_frob_1_pwm_csr
zgitci_frob_1_pwm_div_sampu:
	lw	t4,	(div_j_t3)
	bnez	zenba_t1,	zgitci_frob_1_pwm_div_sampu_zenba
	sub	t0,	x0,	t0
zgitci_frob_1_pwm_div_sampu_zenba:
	add	t0,	t0,	t4
	sw	t0,	(div_j_t3)
zgitci_frob_1_pwm_csr:
	/* ni'o vajni fa ma pe la'oi .CSR.
	 * .i djica tu'a la'oi .A_INV. ji la'oi .PH_CORRECT. ji la'oi .DIVMODE. ji ma
	 * .i xu djica lo nu curmi tu'a lo me'oi .B. pijne  .i la .varik. cu jinvi le du'u zmadu fi le ka ce'u pluja kei kei fo zo'e joi le du'u sarcu fa lo nu cusku lo se du'u djica tu'a lo me'oi .B. pijne kei kei kei noi vo'a jinvi ke'a
	 * .i la .varik. cu jinvi le du'u frili cumki fa ko'a goi lo nu rejgau pe'a ro lo ze me'oi .bit.
	 * .i ku'i la .varik. na birti lo du'u xu kau ko'a banzuka lo ka ce'u tolmapti lo nu na'e binxo pe'a kei kei lo ka ce'u mapti
	 */

	// se morji: PWM_CHx_CSR_OFFSET(x)   x * 0x14
	//           PWM_CHx_DIV_OFFSET(x)   4 + x * 0x14
	#define	csr_j_t0	t0
	addi	csr_j_t0,	div_j_t3,	-4
	// TODO

	# PWM_CHx_TOP_OFFSET
	# ???
	# TODO

	# PWM_CHx_CC_OFFSET
	# ???
	# TODO
	# ???

	/* ni'o la .varik. na te cadga fi tu'a lo me'oi .DIV. */

zgitci_frob_1_pwm_idx:
	// se morji: CUR_ZGITCI_SIVNI(x)     4 * (CUR_ZGITCI_SIVNI_OFFSET + x)
	addi	t0,	zgitci_a4,	4 * CUR_ZGITCI_SIVNI_OFFSET
	sh2add	t0,	vrc_s1,	t0
	lw	t1,	(t0)
	addi	t1,	t1,	1
	sw	t1,	(t0)

	ret
/*
 * SANCE DATNYVEI PE'A
 * .i xu cadga fa lo nu pilno lo re moi be lo'i rucyca'a lo me'oi .PWM. co'e
 * .i la .varik. cu jinvi le du'u lo me'oi .PWM. co'e cu mapti tu'a lo sance datnyvei pe'a
 *
 * [23]
 *
 * [?????][sid: 0xXXX]
 * ^ .i lo se pilno cu meirmoi lo me'oi .sid. lo co'e be la'oi .sanceListe.
 *
 * ?
 *
 * ?
 *
 */
zgitci_frob_check_2:
	// | (a0 `elem` [2,3])?
	addi	t0,	a0,	-2
	li	t1,	2
	bgeu	t0,	t1,	zgitci_frob_c000_mv
	# todo
	#define	zts_id_t0	t0
	// li	t0,	0xFFF	// 2c
	// andi	zts_id_t0,	a1,	0xFFF	// 1c
	slli	t0,	a1,	(32 - 4 * 3)	// 1c
	srli	zts_id_t0,	t0,	(32 - 4 * 3)	// 1c
	#define	zts_j_t1	t1
	la	t2,	sanceListe
	sh1add	zts_j_t1,	t2,	t1

	#define	zts_sance_idx_t2	t2
	// se morji: CUR_ZGITCI_SAMP_IDX(x)  4 * (CUR_ZGITCI_SAMP_IDX_OFFSET + x)
	addi	t2,	zgitci_a4,	CUR_ZGITCI_SAMP_IDX_OFFSET
	slli	zts_sance_idx_t2,	t2,	2

	// do it now, kid
	#define	pwmval_t0	t0
	/* .i la .varik. na birti lo du'u xu kau dukse le ka ce'u sampu
	   .i xu zmadu fa lo nu zmiku pe'a lo nu se meirmoi muvgau pe'a
	   TODO: FACKI */
	lw	t0,	(zts_j_t1)
	add	t0,	t0,	zts_sance_idx_t2
	lw	pwmval_t0,	(t0)

	// TODO: PWM crap

	bexti	t1,	a0,	0
	beqz	t1,	zgitci_frob_check_2_0out
	li	t1,	1
	amoadd.w	x0,	t1,	(zts_sance_idx_t2)
	j	zgitci_frob_check_2_fanmo
zgitci_frob_check_2_0out:
	sw	x0,	(zts_sance_idx_t2)
zgitci_frob_check_2_fanmo:
	ret
/*
 * DAMRI
 *
 * 0x00000004
 *
 * [cnino: 0bX][tonga: 0bXXXXXXXXXXXXXXX][nibarda: 0xXXXX]
 *
 * 0xXXXXXX[nlev: 0bXX][sha256_noise: 0bX]
 *
 * ?
 */
zgitci_frob_damri:
	#define	SIVNI_A2_SHA256_NOISE_BIT	0
	li	t0,	0x0000004
	bne	a0,	t0,	zgitci_frob_check_pio

	#define	A1_SIVNI_CNINO_BIT	31
	#define	curval_a5	a5
	#define	idx_j_t0	t0
	// se morji: CUR_ZGITCI_SAMP_IDX(x)  4 * (CUR_ZGITCI_SAMP_IDX_OFFSET + x)
	addi	t0,	zgitci_a4,	CUR_ZGITCI_SAMP_IDX_OFFSET
	sh2add	idx_j_t0,	vrc_s1,	t0

	bexti	t1,	a1,	A1_SIVNI_CNINO_BIT
	beqz	t1,	zgitci_frob_damri_sezvati_incr
zgitci_frob_damri_sezvati_reset:
	sw	x0,	(idx_j_t0)
	j	zgitci_frob_damri_sezvati_incr_post
zgitci_frob_damri_sezvati_incr:
	lw	t1,	(idx_j_t0)
	addi	t1,	t1,	1
	sw	t1,	(idx_j_t0)
zgitci_frob_damri_sezvati_incr_post:

	// TODO: curval_a5 = ?

zgitci_frob_damri_sha:
	bexti   t0,     a2,     SIVNI_A2_SHA256_NOISE_BIT
	beqz    t0,     zgitci_frob_damri_sha_post

	li	t0,	1
	addi	t1,	vrc_s1,	CUR_SHA_EN
	sw	t0,	(t1)

	#define sha_t0	t0
	addi	t0,	vrc_s1,	CUR_SHA_OFFSET
	lw	sha_t0,	(t0)

	#define	nlev_t2	t2
	clz	t1,	curval_a5
	srli	t2,	a2,	1
	andi	nlev_t2,	t2,	0b11
	add	t1,	t1,	nlev_t2
	srl	sha_t0,	sha_t0,	t1

	// | TODO: .i xu cadga fa lo nu frica
	bexti	t1,	sha_t0,	0
	beqz	t1,	zgitci_frob_damri_sha_jdika
	add	curval_a5,	curval_a5,	sha_t0
	j	zgitci_frob_damri_sha_min
zgitci_frob_damri_sha_jdika:
	sub     curval_a5,      curval_a5,      sha_t0
zgitci_frob_damri_sha_min:
	minu	curval_a5,	curval_a5,	x0
zgitci_frob_damri_cusku:

	/* TODO: cusku pe'a */
	/* TODO: .i xu cadga fa lo nu pilno lo me'oi .PWM. co'e
	   .i xu mapti fa tu'a lo me'oi .jal. co'e
	   .i ma pu'u jdika pe'a tu'a zo'e je lo tonga pa'a tu'a lo damri
	   .i la .varik. na birti */

	ret
/*
 * PIO
 *
 * 0x0001000X
 *
 * [judri: 0xXXXXXXXX]
 *
 * [?: 0x????][?: 0bXXXXXXXXXX][idx: 0bX][nibarda: 0bXXXXX]
 * ^ .i srana lo se meirmoi be lo me'oi .idx. bei lo'i me'oi .PIO.
 *   .i lo me'oi .nibarda. cu te sumji li pa lo ni barda fa lo'i velski be lo me'oi .PIO. co'e
 *
 * ?
 */
zgitci_frob_check_pio:
	li	t0,	0x0001000F
	or	t1,	a0,	t0
	bne	t1,	t0,	zgitci_frob_c000_mv
	// TODO: .aktigau pe'a lo me'oi .PIO. co'e
	// .i la'e di'u srana lo me'oi .GPIO. co'e
zgitci_frob_check_pio_gpio_post:
	#define	max_t0	t0
	andi	max_t0,	a2,	31	// .i la .varik. cu jinvi fo tu'a le velcki fe le du'u li ci no cu nilzilcmi lo'i me'oi .PIO. midnoi pe'a
	sh1add	max_t0,	max_t0,	a1	// .i jinvi le du'u bitni li pa xa
	#define	pio_j_t1	t1
	// TODO: pio_j_t1 = PIOx_BASE + PIOx_INSTR_MEM0_OFFSET
	// TODO: .i cadga fa lo nu pilno lo xo moi be lo'i me'oi .PIO. co'e
	bexti	t3,	a1,	0	// temp

	/* TODO: .i xu mapti fa tu'a lo me'oi .DMA. co'e */
	beqz	t3,	zgitci_frob_check_pio_ld_lupe
zgitci_frob_check_pio_ld_lupe_co_barda:
	#define	pio_instrX_t2	t2
	lw	pio_instrX_t2,	(a1)
	addi	a1,	a1,	4	// 4vxsBM5S.  lw opt

	// | TODO: .i xu mapti  .i morji le du'u mu'oi zoi. little-endian .zoi.
	sh	pio_instrX_t2,	0(pio_j_t1)
	srli	pio_instrX_t2,	pio_instrX_t2,	16
	sh	pio_instrX_t2,	4(pio_j_t1)

	// | pg 950 rp2350
	addi	pio_j_t1,	pio_j_t1,	8
	// addi	a1,	a1,	4	// .i jinvi le du'u ronsa la'o zoi. 4vxsBM5S .zoi.
	blt	a1,	max_t0,	zgitci_frob_check_pio_ld_lupe_co_barda

	ret
zgitci_frob_check_pio_ld_lupe:
	#define	pio_instrX_t2	t2
	lh	pio_instrX_t2,	(a1)
	addi	a1,	a1,	2	// fmSxJdTB.  lh opt
	sh	pio_instrX_t2,	(pio_j_t1)
	// addi	a1,	a1,	2	// .i jinvi le du'u ronsa la'o zoi. fmSxJdTB .zoi.
	addi	pio_j_t1,	pio_j_t1,	4
	blt	a1,	max_t0,	zgitci_frob_check_pio_ld_lupe
	ret

/*
 * MV
 *
 * 0xC000000[12]
 *
 * [patn: 0xXXXXXXXX]
 *
 * [sezvati: 0xXXXXXXXX]
 *
 * [?: 0xXXXX][ctr: 0xXXXX]
 */
zgitci_frob_c000_mv:
	#define	patn_a1	a1
	#define	sezvati_a2	a2
	li	t0,	0xC0000000
	bclri	t1,	a0,	0
	bne	t1,	t0,	zgitci_frob_c000_sutra
	// se morji:	CUR_PATN_SEZVATI(x)	4 * (22 + x)
	//		CUR_PATN_JUDRI(x)	4 * (26 + x)
	#define	sezvati_j_t0	t0
	#define	judri_j_t1	t1
	addi	t0,	zgitci_a4,	CUR_PATN_SEZVATI_OFFSET
	sh2add	sezvati_j_t0,	vrc_s1,	t0
	addi	judri_j_t1,	sezvati_j_t0,	4 * (CUR_PATN_JUDRI_OFFSET - CUR_PATN_SEZVATI_OFFSET)	// CUR_PATN_JUDRI

	slli	t2,	a3,	16
	srli	t2,	t2,	16
	beqz	t2,	zgitci_frob_c000_mv_cont

	srli	t3,	a3,	16
	slli	t3,	t3,	16
	addi	t2,	t2,	-1

	add	judri_j_t1,	judri_j_t1,	sezvati_j_t0
	lw	t0,	(judri_j_t1)
	add	a3,	t2,	t3	// lw opt
	sw	a3,	0xC(t0)
	ret

zgitci_frob_c000_mv_cont:
	sw	sezvati_a2,	(sezvati_j_t0)
	sw	patn_a1,	(judri_j_t1)

	bexti	t2,	a0,	0
	beqz	t2,	zgitci_frob_c000_mv_post
	// If my calculations are correct, when this baby hits 88 miles per hour, you're going to see some serious shit.
	lw	t0,	(judri_j_t1)
	lw	t1,	(sezvati_j_t0)
	addi	sp,	sp,	-4
	sw	ra,	(sp)

	add	t0,	t0,	t1
	lw	a0,	(t0)
	lw	a1,	4(t0)
	lw	a2,	8(t0)
	lw	a3,	0xC(t0)

	jal	zgitci_frob

	lw	ra,	(sp)
	addi	sp,	sp,	4
zgitci_frob_c000_mv_post:
	ret

/*
 * SUTRA
 * .i la .varik. cu zu'edji tu'a lo nu la'oi .SUTRA. jai filri'a lo nu zi'o sutra tu'a lo'i zgitci co'e... noi la judri judri lo pa moi be lo'i co'e be ke'a je noi la'oi .nibarda. nilzilcmi ke'a
 * .i la'oi .SUTRA. smimlu zo'e pe la'oi .main. le ka lo co'e co me la judri cu judri lo co'e be lo zgike be'o poi ke'a mapti tu'a la'oi .zgitci_frob.
 *
 * ===== !!!!! =====
 * .i ku'i la .varik. cu kajde fi zo'e joi le su'u la'oi .SUTRA. panra la'oi .MV. le ka vo'a jinvi le du'u ke'a jai filri'a lo nu co'e ja spofu
 * ===== !!!!! =====
 *
 * == aX ==
 *
 * 0xC0000002
 *
 * [judri: 0xXXXXXXXX]
 *
 * [?: 0xXXXX][nibarda: 0xXXXX]
 *
 * ?
 */
zgitci_frob_c000_sutra:
	li	t0,	0xC0000002
	bne	a0,	t0,	zgitci_frob_c000_denpa

	addi	sp,	sp,	-(3*4)
	sw	ra,	(sp)
	sw	s2,	4(sp)
	sw	s3,	8(sp)

	#define	max_s3	s3
	#define	judri_s2	s2
	mv	judri_s2,	a1
	slli	s3,	a2,	16
	srli	s3,	t0,	16
	sh2add	max_s3,	judri_s2,	t0
zgitci_frob_c000_sutra_lupe:
	/* DROP t[0-7] */
	lw	t0,	(judri_s2)

	// | loop crap
	// .i jinvi le du'u rinka lo me'oi .lw. co'e je ke zmadu be fi le ka ce'u zilsutra
	addi	judri_s2,	judri_s2,	4

	lw	a0,	0x0(t0)
	lw	a1,	0x4(t0)
	lw	a2,	0x8(t0)
	lw	a3,	0xC(t0)
	// ni'o xu su'o da zo'u mapti fa lo nu co'e da se ri'a lo nu le me'oi .lw. co'e cu zenba pe'a le ka ce'u jai zilsutra
	jal	zgitci_frob

	blt	judri_s2,	max_s3,	zgitci_frob_c000_sutra_lupe
zgitci_frob_c000_sutra_post:
	lw	ra,	(sp)
	lw	s2,	4(sp)
	lw	s3,	8(sp)
	addi	sp,	sp,	(3*4)

	ret

/*
 * DENPA BIXYGAU PE'A
 *
 * 0xC0000010
 *
 * [nidenpa: 0xXXXXXXXX]
 *
 * ?
 *
 * ?
 */
zgitci_frob_c000_denpa:
	li	t0,	0xC0000010
	bne	a0,	t0,	zgitci_frob_deaf_xosc

	// se morji: CUR_DENPA_INST(x)       4 * (2 + x)
	#define	denpa_j_t0	t0
	addi	t0,	zgitci_a4,	2
	sh2add	denpa_j_t0,	vrc_s1,	t0

	sw	a1,	(denpa_j_t0)

	// TODO: .i xu cadga fa lo nu zukte lo frica
	// .i la .varik. cu te smimlu fi le ka ce'u sampu kei je cu jinvi le du'u zo'oi .jal. jai zilmasno

	ret
/*
 * XOSC BIXYGAU PE'A
 *
 * 0xDEAF0000
 *
 * 0xXXXX [dp: 0xXXXX]
 * ^ .i sa'u co'e ja cpedu lo nu lo me'oi .dp. cu snidu pe'a tu'a la'oi .XOSC.
 *
 * XXX[?: bbb][x1: b][st: 0xXXX]
 * ^ .i sa'u lo me'oi .x1. srana lo du'u xu kau djica lo nu co'e co ni zilsutra
 *   .i sa'u lo me'oi .st. cu mu'oi zoi. FREQ_RANGE .zoi. namcu
 *
 * ?
 */
zgitci_frob_deaf_xosc:
	#define	SIVNI_ST_MASK	0xFFF
	li	t0,	0xDEAF0000
	bne	a0,	t0,	zgitci_frob_deaf_bixygau
	li	t1,	0xFFFF
	and	t0,	a1,	t1
	sw	t1,	CUR_XOSC_SNIDU(vrc_s1)

	bexti	t1,	a2,	(1 + 4 * 3)	// temp
	beqz	t1,	zgitci_frob_deaf_xosc_post

	li	t1,	SIVNI_ST_MASK
	and	t1,	a2,	t1
	li	t0,	(XOSC_BASE + XOSC_CTRL_OFFSET)
	sw	t1,	(t0)

/*
 * BIXYGAU PE'A
 * .i zu'edji tu'a lo nu la'oi .BIXYGAU. jai filri'a lo nu basygau pe'a lo zgitci co'e
 *
 * 0xDEAF0001
 *
 * [judriP: 0xXXXXXXX][?: 0bXXX][idx: 0bX]
 *
 * [zt1: 0xXXXXXXXX]
 *
 * [zt2: 0xXXXXXXXX]
 */
zgitci_frob_deaf_bixygau:
	li	t0,	0xDEAF0001
	bne	t0,	a0,	zgitci_frob_deaf_setsivni

	#define	judri0_t0	t0
	#define	A1_SIVNI_JUDRIP_OFFSET	4

	srli	t0,	a1,	A1_SIVNI_JUDRIP_OFFSET

	// | .i jinvi le du'u lo me'oi .idx. cu jai to'e filri'a tu'a lo barda judri
	// .i ku'i jinvi ga je le du'u lakne fa lo nu pilno lo me'oi .DATA. judri gi le du'u la'e zo'oi .0x10000000. pa moi lo'i me'oi .DATA. judri
	li	t1,	0x10000000
	add	t0,	t0,	t1

	// | + t1 * 8
	// .i jinvi le du'u jai filri'a tu'a lo me'oi .offset. kei joi le du'i baitni li bi fa loi re zgitci co'e
	bexti	t1,	a1,	0
	sh3add	judri0_t0,	t0,	t1

	sw	a2,	0(judri0_t0)
	sw	a3,	4(judri0_t0)

	ret

/*
 * SET SIVNI
 *
 * 0xDEAF0002
 *
 * [?: 0xXXXXXXX][offset:0bXX][e: 0bXX]
 *
 * [sivni1]
 *
 * [sivni2]
 */
zgitci_frob_deaf_setsivni:
	li	t0,	0xDEAF0002
	bne	t0,	a0,	zgitci_frob_nope

	#define	A1_SIVNI_ENABLE_BIT_0	0
	#define	A1_SIVNI_ENABLE_BIT_1	1
	#define	A1_SIVNI_OFFSET_BIT_0	2
	#define	A1_SIVNI_OFFSET_BIT_1	3

	bexti	t0,	a1,	A1_SIVNI_ENABLE_BIT_0
	beqz	t0,	zgitci_frob_deaf_setsivni_i2
	// se morji: CUR_ZGITCI_SIVNI(x)     4 * (CUR_ZGITCI_SIVNI_OFFSET + x)
	bexti	t0,	a1,	A1_SIVNI_OFFSET_BIT_0
	addi	t0,	t0,	CUR_ZGITCI_SIVNI_OFFSET
	sh2add	t0,	vrc_s1,	t0
	sw	a2,	(t0)
zgitci_frob_deaf_setsivni_i2:
	bexti	t0,	a1,	A1_SIVNI_ENABLE_BIT_1
	beqz	t0,	zgitci_frob_deaf_setsivni_post
	// se morji: CUR_ZGITCI_SIVNI(x)     4 * (CUR_ZGITCI_SIVNI_OFFSET + x)
	bexti	t0,	a1,	A1_SIVNI_OFFSET_BIT_1
	addi	t0,	t0,	CUR_ZGITCI_SIVNI_OFFSET + 2	// .i jinvi le du'u filri'a tu'a lo ci moi je lo vo moi
	sh2add	t0,	vrc_s1,	t0
	sw	a3,	(t0)
zgitci_frob_deaf_setsivni_post:
	ret

/*
 * NOPE.AVI
 */
zgitci_frob_nope:
	ret

/*
 * VRICI
 * .i pilno lo me'oi .a5... tu'a lo vrici  .i go'i
 *
 * [klesi: 0xFF][?: 0xXXXXXX]
 *
 * DROP t[0-7] a5
 */
vrici_frob:
	#define	SIVNI_NILZILCMI	6
	srli	t0,	a5,	(6 * 4)
	li	t1,	SIVNI_NILZILCMI
	ble	t0,	t1,	vrici_frob_dispatch_pre
	ret
vrici_frob_dispatch_pre:
	#define	datni_a5	a5
	// | metfo: andi	datni_a5,	datni_a5,	0xFFFFFF
	slli	datni_a5,	datni_a5,	8
	srli	datni_a5,	datni_a5,	8

	slli	t0,	t0,	2
vrici_frob_dispatch:
	// | TODO: .i xu mapti  .i la .varik. cu milxe le ka ce'u senpi
	j	t0
	// | 0
	ret
	// | 1
	j	vrici_frob_denpa
	// | 2
	j	vrici_frob_j
	// | 3
	j	vrici_frob_0
	// | 4
	j	vrici_frob_jog
	// | 5
	j	vrici_frob_sivni
	// | 6
	j	vrici_frob_denpaV
vrici_frob_denpa:
	#define	denpa_j_t0	t0
	// se morji: CUR_DENPA_INST(x)       4 * (2 + x)
	addi	t0,	zgitci_a4,	2
	sh2add	denpa_j_t0,	vrc_s1,	t0

	sw	datni_a5,	(denpa_j_t0)

	ret
vrici_frob_j:
	// se morji: CUR_PATN_SEZVATI(x)     4 * (22 + x)
	addi	t1,	zgitci_a4,	CUR_PATN_SEZVATI_OFFSET
	sh2add	t1,	vrc_s1,	t1

	sw	datni_a5,	(t1)

	ret
/*
 * RUB ONE OUT
 */
vrici_frob_0:
	// se morji: CUR_PATN_SEZVATI(x)	4 * (22 + x)
	//           CUR_PATN_JUDRI(x)	4 * (26 + x)
	addi	t0,	zgitci_a4,	CUR_PATN_SEZVATI_OFFSET
	sh2add	t0,	vrc_s1,	t0

	lw	t1,	(4 * (CUR_PATN_JUDRI_OFFSET - CUR_PATN_SEZVATI_OFFSET))(t0)	// CUR_PATN_JUDRI
	lw	t0,	(t0)

	add	t1,	t1,	datni_a5
	add	t0,	t0,	t1

	sw	x0,	(t0)

	ret
vrici_frob_jog:
	#define	sezvati_j_t0	t0
	// se morji: CUR_PATN_SEZVATI(x)     4 * (22 + x)
	addi	t0,	zgitci_a4,	CUR_PATN_SEZVATI_OFFSET
	sh2add	sezvati_j_t0,	vrc_s1,	t0

	#define	sign_t1	t1
	bexti	sign_t1,	datni_a5,	23
	bclri	datni_a5,	datni_a5,	23

	#define	sezvati_t2	t2
	lw	sezvati_t2,	(sezvati_j_t0)
	beqz	sign_t1,	vrici_frob_jog_sesumji
	// | ni'o xu mapti fa tu'a la'oi .sh2add.  .i la .varik. cu jinvi le du'u zmadu fi le ka ce'u mapti lo so'i judri kei je le ka co'e ja nandu fa lo nu spofu ri'a tu'a ce'u  .i ku'i la .varik. na birti lo du'u xu kau banzuka le ka ce'u zilmasno
	// .i ji'a xu lo me'oi .slli. co'e zmadu ni'i zo'e joi lo su'u mapti le su'u pilno la'oi .slli. tu'a la'oi .vrici_frob_jog_sesumji.
	sh2add	sezvati_t2,	sezvati_t2,	datni_a5
	sw	sezvati_t2,	(sezvati_j_t0)
	ret
vrici_frob_jog_sesumji:
	slli	datni_a5,	datni_a5,	2
	sub	sezvati_t2,	sezvati_t2,	datni_a5
	sw	sezvati_t2,	(sezvati_j_t0)
	ret
// | TODO: .i xu mapti
vrici_frob_sivni:
	// se morji: CUR_ZGITCI_SIVNI(x)     4 * (CUR_ZGITCI_SIVNI_OFFSET + x)
	addi	t0,	zgitci_a4,	CUR_ZGITCI_SIVNI_OFFSET
	sh2add	t0,	vrc_s1,	t0
	sw	datni_a5,	(t0)
	ret
vrici_frob_denpaV:
	#define	zt_idx_t0	t0
	srli	zt_idx_t0,	datni_a5,	22	// b[23], b[22]
	// se morji: CUR_DENPA_INST(x)       4 * (2 + x)
	addi	t0,	zt_idx_t0,	2
	#define	denpa_j_t0	t0
	sh2add	denpa_j_t0,	vrc_s1,	t0

	bclri	datni_a5,	datni_a5,	23
	bclri	datni_a5,	datni_a5,	22

	sw	datni_a5,	(denpa_j_t0)

	ret
