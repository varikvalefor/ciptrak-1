#define	X_VRICI_DENPA_OFFSET	1
#define	X_VRICI_DENPA(i)\
	X_VRICI_DENPA_OFFSET + (i << (4 * 2))
#define	X_VRICI_J_OFFSET	1 + X_VRICI_DENPA_OFFSET
#define	X_VRICI_J(i)\
	(X_VRICI_J_OFFSET + (1 << (4 * 2))
