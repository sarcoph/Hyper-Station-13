/mob/living/carbon/proc/get_capable_genitals(capability)
	if(!capability)
		return
	var/list/capable_genitals = list()
	for(var/obj/item/organ/genital/genital in internal_organs)
		if(genital.is_capable(capability))
			capable_genitals += genital
	return capable_genitals


/mob/living/carbon/proc/get_first_capable_genital(capability)
	if(!capability)
		return
	var/list/capable_genitals = get_capable_genitals(capability)
	if(!capable_genitals.len)
		return
	return capable_genitals[1]


/proc/get_impregnation_chance(obj/item/organ/genital/target, obj/item/organ/genital/partner)
	if(!target.is_capable(CAN_GET_PREGNANT) || !partner.is_capable(CAN_IMPREGNATE))
		return 0
	var/mob_fertility = target.get_effective_stat("fertility")
	var/partner_fertility = partner.get_effective_stat("fertility")
	var/mob_chance = (FERTILITY*mob_fertility) * prob(partner_fertility * 100)
	return mob_chance