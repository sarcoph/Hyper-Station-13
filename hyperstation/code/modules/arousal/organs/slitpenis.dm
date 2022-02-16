/**
* Genital slits
* 
* description: genital that is penetrable, but exposes a penis when aroused 
* (allowing it to also penetrate others.) perfect for reptile, fish, insect
* characters.
*/
/obj/item/organ/genital/slit_penis
	name = "genital slit"
	desc = "A reproductive organ concealing a penis."
	icon_state = "slit"
	icon = 'hyperstation/icons/obj/genitals/genital_slit.dmi'
	zone = "groin"
	slot = ORGAN_SLOT_PENIS
	fluid_transfer_factor = 0.5
	size = 2
	can_climax = TRUE
	can_masturbate_with = TRUE

	/// default (flaccid) state	
	masturbation_verb = "finger"
	can_be_penetrated = TRUE
	can_penetrate = FALSE


/obj/item/organ/genital/slit_penis/Initialize()
	. = ..()
	
/obj/item/organ/genital/slit_penis/update_size()
	
/* also triggered on arousal state change */
/obj/item/organ/genital/slit_penis/update_appearance()
	if(aroused_state)
		masturbation_verb = "stroke"
		can_be_penetrated = TRUE
		can_penetrate = TRUE
	else
		masturbation_verb = "finger"
		can_be_penetrated = TRUE
		can_penetrate = FALSE

/obj/item/organ/genital/slit_penis/update_link()
	