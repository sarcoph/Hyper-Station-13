#define BELLY_MIN_SIZE 0
#define BELLY_MAX_SIZE 8

#define BELLY_STRAIN_SIZE 3 // for flavor text
#define BELLY_STRETCH_SIZE 6 // for flavor text

#define BUTT_MIN_SIZE 0
#define BUTT_MAX_SIZE_SELECTABLE 5
#define BUTT_MAX_SIZE 8

#define GENITALS_HIDDEN "hidden"
#define GENITALS_CLOTHES "clothes"
#define GENITALS_VISIBLE "visible"

/* GENITAL REWORK: CAPABILITIES */
#define PENETRABLE (1<<0) /// if you can insert things into this genital
#define PENETRATING (1<<1) /// if you can insert this genital into things
#define CAN_CLIMAX (1<<2) /// if this genital can climax
#define EJACULATES (1<<3) /// if this genital releases fluids on climax
#define PRODUCE_FLUIDS (1<<4) /// if this genital produces and stores fluids
#define CAN_IMPREGNATE (1<<5) /// if this genital can get someone pregnant
#define CAN_GET_PREGNANT (1<<6) /// if this genital can lead to impregnation
#define EXTERNAL_GENITALS (1<<7) /// if you can rub this genital against something

#define SENSITIVITY_DEFAULT 1
#define SENSITIVITY_LESS 0.66
#define SENSITIVITY_LOW 0.33

/* GENITAL REWORK: MODIFIER OPERATIONS */
#define STAT_ADD_BASE "+="
#define STAT_ADD_MOD "+"
#define STAT_MULTIPLY "*"
#define STAT_MODIFIERS list(STAT_ADD_BASE, STAT_ADD_MOD, STAT_MULTIPLY)
// (BASE += BASE_ADDITIONS) * MULTIPLIER + MODIFIER_ADDITIONS 