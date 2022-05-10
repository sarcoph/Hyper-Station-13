/* GENITAL REWORK */
/obj/item/organ/genital
	/// Bitflags representing the capabilities of this genital.
	var/base_capabilities = (VISIBLE_GENITALS)
	/// Bitflag capabilities that are temporarily disabled for this genital.
	var/negated_capabilities
	/// A multiplier applied to arousal gained from stimulating this genital.
	var/sensitivity = SENSITIVITY_DEFAULT
	/// Numbers temporarily added or multiplied to different stats.
	var/list/stat_modifiers
	/// The fertility of this genital. Only relevant if genital CAN_GET_PREGNANT or CAN_IMPREGNATE.
	var/fertility = 0


/obj/item/organ/genital/proc/enable_capability(capability)
	if(!capability)
		return
	DISABLE_BITFIELD(negated_capabilities, capability)

/obj/item/organ/genital/proc/disable_capability(capability)
	if(!capability)
		return
	ENABLE_BITFIELD(negated_capabilities, capability)

/obj/item/organ/genital/proc/get_effective_capabilities()
	var/capabilities = src.base_capabilities
	DISABLE_BITFIELD(capabilities, negated_capabilities)
	return capabilities


/obj/item/organ/genital/proc/is_capable(capability)
	if(!capability)
		return
	return CHECK_BITFIELD(get_effective_capabilities(), capability)


/**
	* Gets the "usable" value of a given stat, taking into account all modifiers.
	*
	* **Example:** Let's say the character's penis has a base sensitivity of 1.
	* They have consumed a chemical that is giving them +0.1 base sensitivity.
	* They have a sounding rod inserted, which gives them *1.5 sensitivity.
	* The calculated totaal would be (BASE + BASEMOD) * MULTIPLIER + MODIFIER,
	* which would be (1 + 0.1) * 1.5 + 0 = 1.65 sensitivity.
	*
	* Unlike `get_modifier_totals()`, this also factors in the `linked_organ`'s
	* total stats.
	*
	* Arguments:
	* - `stat_name`: The (numeric) variable name of the stat being calculated.
	*
	* Returns:
	* - A number representing the calculated total of the stat, including linked organ.
	*/
/obj/item/organ/genital/proc/get_effective_stat(stat_name)
	if(!stat_name)
		return
	var/stat_value = src[stat_name]
	var/list/totals = src.get_modifier_totals(stat_name)
	if(linked_organ)
		totals[STAT_ADD_BASE] += linked_organ.get_mod_total(stat_name, STAT_ADD_BASE, include_base=TRUE)
		totals[STAT_MULTIPLY] *= linked_organ.get_mod_total(stat_name, STAT_MULTIPLY)
		totals[STAT_ADD_MOD] += linked_organ.get_mod_total(stat_name, STAT_ADD_MOD)
	stat_value += totals[STAT_ADD_BASE]
	stat_value *= totals[STAT_MULTIPLY]
	stat_value += totals[STAT_ADD_MOD]
	return stat_value


/**
	* Gets a total of modifiers for one specific stat.
	* Unlike `get_effective_stat()`, this does not take into account the
	* linked organ's stats
	*
	* Arguments:
	* - `stat_name`: The (numeric) variable name of the stat being calculated.
	* - `include_base`: Whether or not to include the base number for the STAT_ADD_BASE total.
	*
	* Returns:
	* - A number representing the calculated total of the stat.
	*/
/obj/item/organ/genital/proc/get_modifier_totals(stat_name, include_base=FALSE)
	if(!stat_name)
		return
	var/list/modifier_totals = list()
	for(var/op in STAT_MODIFIERS)
		modifier_totals[op] = get_mod_total(stat_name, op, include_base)
	return modifier_totals


/**
	* Gets a total modifier value of a certain type for a specific stat.
	*
	* Arguments:
	* - `stat_name`: The (numeric) variable name of the stat being calculated.
	* - `type`: The type of stat modifier that is being calculated.
	* - `include_base`: Whether or not to include the base number, if the type is STAT_ADD_BASE.
	*
	* Returns:
	* - A number representing the calculated total of the stat modifier.
	*/
/obj/item/organ/genital/proc/get_mod_total(stat_name, type=STAT_ADD_MOD, include_base=FALSE)
	if(!stat_name || !src[stat_name])
		return
	var/total = (include_base && type==STAT_ADD_MOD) ? src[stat_name] : (type==STAT_MULTIPLY) ? 1 : 0 
	if(!stat_modifiers.len)
		return total
	for(var/mod in stat_modifiers)
		if(mod["stat"] == stat_name && mod["type"] == type)
			if(type == STAT_MULTIPLY)
				total *= mod["value"]
				continue
			total += mod["value"]
	return total
		

/**
	* Adds a modifier to the organ's modifier list, identified by name.
	* Modifiers with duplicate names will not exist; the latest-added modifier with that name
	* will be the one in effect.
	*
	* Arguments:
	* - `type`: The type of modifier to add. Either STAT_ADD_MOD, STAT_MULTIPLY, or STAT_ADD_BASE.
	* - `name`: The uniquely identifying name of this modifier.
	* - `stat`: The stat that this modifier is affecting.
	* - `value`: The value of the modifier.
	*/
/obj/item/organ/genital/proc/add_modifier(type=STAT_ADD_MOD, name, stat, value)
	if(!type || !name || !stat || !value)
		return
	remove_modifier(name) // replacing the modifier
	stat_modifiers[stat] += list(list(type=type, name=name, value=value))


/**
	* Removes a modifier from the list of modifiers.
	* 
	* Arguments:
	* - `name`: The name of the modifier to remove.
	*/
/obj/item/organ/genital/proc/remove_modifier(name)
	if(!stat_modifiers.len)
		return
	for(var/mod in stat_modifiers)
		if(mod["name"] == name)
			stat_modifiers -= mod
			break


/**
	* Gets the source of fluids for this genital, which is either the genital itself
	* or the genital's `linked_organ`.
	*
	* Returns:
	* `null`|`var/datum/reagents`: The reagent data connected to this organ.
	*/
/obj/item/organ/genital/proc/get_fluid_source()
	if(is_capable(PRODUCE_FLUIDS))
		return src.reagents
	if(linked_organ && linked_organ.is_capable(PRODUCE_FLUIDS))
		return linked_organ.reagents
	return null