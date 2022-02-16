/*
mild rework of the genital system. instead of concretely defining genitals as "penis", 
"vagina", etc. categories, this defines genitals by their capability; e.g. penetration, 
sensitivity and whatnot.

this allows external factors to change these variables; for example, a chastity cage would
render a penis _unable to penetrate_ and _less(?) sensitive_.

it also allows for more interesting fantasy genital setups!

sarcoph 2022
*/


/obj/item/organ/genital
	var/can_be_penetrated = FALSE
	var/can_penetrate = FALSE
	var/sensitivity	= GENITAL_SENSITIVITY_HIGH


/obj/item/organ/genital/anus
	can_be_penetrated = TRUE

/obj/item/organ/genital/ovipositor
	can_penetrate = TRUE

/obj/item/organ/genital/penis
	can_penetrate = TRUE

/obj/item/organ/genital/vagina
	can_be_penetrated = TRUE