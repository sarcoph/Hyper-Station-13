/obj/item/organ/genital/penis
	base_capabilities = (VISIBLE_GENITALS|CAN_GRIND|PENETRATING|CAN_CLIMAX|EJACULATES)

/obj/item/organ/genital/testicles
	base_capabilities = (VISIBLE_GENITALS|PRODUCE_FLUIDS|CAN_GRIND|CAN_CLIMAX|CAN_IMPREGNATE)
	sensitivity = SENSITIVITY_LESS
	fertility = 1

/obj/item/organ/genital/vagina
	base_capabilities = (VISIBLE_GENITALS|CAN_GRIND|PENETRABLE|CAN_CLIMAX|EJACULATES)

/obj/item/organ/genital/womb
	base_capabilities = (PRODUCE_FLUIDS|CAN_GET_PREGNANT|DO_NOT_LIST)
	sensitivity = 0
	fertility = 1

/obj/item/organ/genital/anus
	base_capabilities = (VISIBLE_GENITALS|PENETRABLE|CAN_CLIMAX)

/obj/item/organ/genital/breasts
	base_capabilities = (VISIBLE_GENITALS|PRODUCE_FLUIDS|CAN_GRIND|CAN_CLIMAX|EJACULATES)
	sensitivity = SENSITIVITY_LESS

/obj/item/organ/genital/belly
	base_capabilities = (VISIBLE_GENITALS)
	sensitivity = SENSITIVITY_LOW

/obj/item/organ/genital/ovipositor
	base_capabilities = (VISIBLE_GENITALS|DO_NOT_LIST)

/obj/item/organ/genital/eggsack
	base_capabilities = (VISIBLE_GENITALS|DO_NOT_LIST)