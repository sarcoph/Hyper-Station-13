/*
DOING THIS ALL OVER AGAIN!! YIPPEE!!!
sarcoph april 2022
*/

GLOBAL_LIST_INIT(lewdoo_species, list(
	"basic", "canine", "moth", "bird",
	"lizard", "fish", "rabbit"
))

#define LEWDOO_COLOR_PRIMARY "Primary"
#define LEWDOO_COLOR_SECONDARY "Secondary"
#define LEWDOO_COLOR_EYES "Eye"

/obj/item/lewdoo
	name = "lewdoo doll"
	desc = "A doll capable of inflicting sensation on a chosen target. However, this one seems more geared for pleasure..."
	icon = 'hyperstation/icons/obj/lewdoo.dmi'
	icon_state = "basic_base"
	max_integrity = 10
	resistance_flags = FLAMMABLE
	/** The person who will receive interactions from the doll. */
	var/mob/living/carbon/human/target = null
	/** The user allowed to interact with the target. This is to prevent preference break;
	i.e. a target consenting to one person's interactions, but not others. */
	var/mob/living/carbon/holder = null
	/** A list of people who have left DNA on the inserted item. */
	var/list/mob/living/carbon/human/possible_targets = list()
	/** An item attached to the doll to determine the target list. */
	var/obj/item/attached_item = null
	/** The minimum time between interactions. */
	var/cooldown_time = 3 SECONDS
	var/cooldown = 0
	/** Determines the appearance of the doll. Must be a valid icon_state. */
	var/doll_style = "basic"
	/** The color of the doll's body. */
	var/primary_color = "#ffaaaa"
	/** The color of the doll's style-specific body parts. */
	var/secondary_color = "#aaffaa"
	/** The color of the doll's eyes. */
	var/eye_color = "#aaaaff"
	/** List of possible interactions. */
	var/list/interactions = list()


/obj/item/lewdoo/Initialize()
	. = ..()
	var/list/species = GLOB.lewdoo_species
	doll_style = pick(species)
	SetColor(LEWDOO_COLOR_PRIMARY, "#ffffff")
	SetColor(LEWDOO_COLOR_SECONDARY, "#" + random_color())
	SetColor(LEWDOO_COLOR_EYES, "#" + random_color())
	InitializeInteractions()

/obj/item/lewdoo/update_icon()
	. = ..()
	icon_state = "[doll_style]_base"
	update_overlays()

/obj/item/lewdoo/update_overlays()
	. = ..()
	cut_overlays()
	var/image/_visible_body = image(
		icon = icon,
		icon_state = icon_state)
	_visible_body.color = primary_color
	var/image/_extra_parts = image(
		icon = icon, 
		icon_state = "[doll_style]_secondary")
	_extra_parts.color = secondary_color
	var/image/_eyes = image(
		icon = icon, 
		icon_state = "eyes")
	_eyes.color = eye_color
	add_overlay(list(_visible_body, _extra_parts, _eyes))

/obj/item/lewdoo/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	AttachItem(I, user)

/*
TGUI:

Literally just the TGUI part of this
Allows players to interact with the doll and choose targets.
*/
/obj/item/lewdoo/ui_interact(mob/user, ui_key, datum/tgui/ui, force_open, datum/tgui/master_ui, datum/tgui_state/state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "LewdooDoll", name, 500, 400, master_ui, state)
		ui.open()
	
/obj/item/lewdoo/ui_act(action, params)
	if(..())
		return
	if(!src.loc == usr)
		return
	switch(action)
		if("interact")
			var/list/interaction = params["action"] || null
			Interact(usr, interaction)
		if("switch_intent")
			var/intent = params["intent"]
			usr.a_intent_change(intent)
		if("switch_zone")
			var/zone = params["zone"]
			var/obj/screen/zone_sel/selector = usr.hud_used.zone_select
			selector.set_selected_zone(zone_select, usr)
		if("change_color")
			var/color_name = params["color"]
			var/description = "Change the [lowertext(color_name)] color of the lewdoo doll"
			var/_input = input(usr, description, "Lewdoo Doll", primary_color) as color|null
			SetColor(color_name, _input)
		if("change_style")
			var/style = params["style"]
			doll_style = style
			update_icon()
		if("eject_item")
			DetachItem(usr)
		if("remove_target")
			RemoveTarget(usr)
		if("prompt_target")
			var/target = params["target"]
			if(target == "(none)") return TRUE
			for(var/mob/living/carbon/human/poss in possible_targets)
				if(poss.name == target)
					SelectTarget(usr, poss)
		if("sync_colors_to_target")
			SyncColorsToTarget()
	return TRUE

/obj/item/lewdoo/ui_data(mob/user)
	var/list/data = list()
	var/valid = src.loc == target || src.loc == holder
	var/mob/living/carbon/human/_holder = valid ? src.loc : null
	data["possibleTargets"] = possible_targets
	data["validLocation"] = valid
	data["intent"] = _holder ? _holder.a_intent : null
	data["zone"] = _holder ? _holder.zone_selected : null
	data["heldItem"] = user.get_active_held_item()
	data["target"] = target
	data["holder"] = holder
	data["activeStyle"] = doll_style
	data["colors"] = list(
		LEWDOO_COLOR_PRIMARY = primary_color, 
		LEWDOO_COLOR_SECONDARY = secondary_color, 
		LEWDOO_COLOR_EYES = eye_color)
	return data
	
/obj/item/lewdoo/ui_static_data(mob/user)
	var/list/data = list()
	data["interactions"] = interactions
	data["dollStyles"] = GLOB.lewdoo_species
	return data

/* 
CUSTOMIZATION:

change colors and doll style
todo: accessories?
*/

/obj/item/lewdoo/proc/SyncColorsToTarget()
	if(!target) 
		return
	var/datum/dna/_dna = target.dna
	var/datum/species/_species = _dna.species
	var/list/_features = _dna.features
	var/list/_traits = _species.species_traits
	SetColor(LEWDOO_COLOR_PRIMARY, skintone2hex(target.skin_tone))
	SetColor(LEWDOO_COLOR_EYES, hex3tohex6(target.eye_color))
	if(_traits.Find(MUTCOLORS))
		SetColor(LEWDOO_COLOR_PRIMARY, hex3tohex6(_features["mcolor"]))
		SetColor(LEWDOO_COLOR_SECONDARY, hex3tohex6(_features["mcolor2"]))

/obj/item/lewdoo/proc/hex3tohex6(hex3)
	var/_color = ReadRGB(hex3)
	return rgb(_color[1], _color[2], _color[3])

/obj/item/lewdoo/proc/SetColor(color, value)
	if(!value) return
	switch(color)
		if(LEWDOO_COLOR_PRIMARY) 
			primary_color = value
		if(LEWDOO_COLOR_SECONDARY) 
			secondary_color = value
		if(LEWDOO_COLOR_EYES) 
			eye_color = value
	update_icon()

/*
ITEM LINKING:

Any small items can be attached to the doll, and anyone whose DNA is on the item
is a valid target for selection. The target MUST consent to being targeted by a
lewdoo doll for it to work, similar to the hypnosis items.
*/
/obj/item/lewdoo/proc/AttachItem(obj/item/I, mob/living/user)
	if(!attached_item && I.loc == user && istype(I) && I.w_class <= WEIGHT_CLASS_SMALL)
		if (user.transferItemToLoc(I,src))
			attached_item = I
			to_chat(user, "You attach \the [I] to \the [src].")
			UpdatePossibleTargets()

/obj/item/lewdoo/proc/DetachItem(mob/living/user)
	RemoveTarget()
	if(attached_item)
		to_chat(user, "<span class='notice'>You remove \the [attached_item] from \the [src].</span>")
		attached_item.forceMove(drop_location())
		attached_item = null
		UpdatePossibleTargets()

/obj/item/lewdoo/proc/UpdatePossibleTargets()
	possible_targets = list()
	if(attached_item)
		for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
			if(md5(H.dna.uni_identity) in attached_item.fingerprints)
				LAZYOR(possible_targets, H)

/obj/item/lewdoo/proc/RemoveTarget(mob/living/user)
	if(target)
		to_chat(target, "<span class='notice'>You feel a tug at your being disappear.</span>")
		to_chat(user, "<span class='notice'>You feel \the [src] grow lighter as its connection to its target disappears.</span>")
	target = null
	holder = null

/obj/item/lewdoo/proc/SelectTarget(mob/living/carbon/user, mob/living/carbon/human/selected)
	RemoveTarget()
	if(!length(possible_targets || !selected)) return
	var/_consent = selected == user ? "Yes" : GetTargetConsent(selected)
	world.log << _consent
	if(_consent == "Yes" && !target)
		target = selected
		holder = user
		log_game("[key_name(user)] linked [key_name(target)] to a lewdoo doll.")
		to_chat(target, "<span class='warning'>You feel as if an unseen force is now tugging at your being...</span>")
		to_chat(user, "<span class='notice'>You feel \the [src] grow weightier as it successfully links with [selected].</span>")
	else
		to_chat(selected, "<span class='warning'>You feel as if your being has rejected an unseen influence...</span>")
		to_chat(user, "<span class='warning'>You feel as if [selected] has rejected \the [src]'s influence.</span>")

/obj/item/lewdoo/proc/GetTargetConsent(mob/living/carbon/human/target)
	var/consent_message = "Someone is attempting to link you to a lewdoo doll."
	consent_message += " Allow this player to anonymously interact with yours in lewd ways?"
	var/_consent = alert(target, consent_message, "Lewdoo Doll", "Yes", "No")
	return _consent


/*
INTERACTIONS:

Based on the intent, targeted body part, and possibly an item in hand, the holder
may interact with the doll, which passes onto the target in some way.

Ensure that interactions are NOT griefy or abusable. Damaging interactions should
be kept within the threshold! Non-masochists should not receive pain, for the
sake of preferences.
*/
/obj/item/lewdoo/proc/Interact(mob/living/carbon/user, list/action)
	if(!target || !action) return
	if(user != holder && user != target) return
	ReplaceActionTerms(action, user, usr.get_active_held_item())
	SendActionMessages(action, user)
	DoActionEffects(action, user)

/obj/item/lewdoo/proc/DoActionEffects(var/list/_action, mob/living/carbon/user)
	var/zone = user.zone_selected
	if(_action["pleasure_gain"])
		target.adjustArousalLoss(_action["pleasure_gain"])
		if(_action["can_cum"])
			target.attempt_climax()
	if(_action["holder_pleasure"])
		user.adjustArousalLoss(_action["holder_pleasure"])
		if(_action["can_cum"])
			user.attempt_climax()
	if(_action["pain_gain"])
		var/max_pain_action = 0.2 * target.max_pain
		var/max_pain_loss = max_pain_action - clamp(target.total_pain, 0, max_pain_action)
		var/pain_from_action = clamp(_action["pain_gain"], 0, max_pain_loss)
		target.adjustPainLoss(pain_from_action, affected_zone=zone)
	if(_action["mood_event"])
		SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT,\
			_action["mood_event"]["name"],\
			_action["mood_event"]["event"])	

/obj/item/lewdoo/proc/SendActionMessages(var/list/_action, mob/living/carbon/user)
	to_chat(user, _action["holder_text"])
	if(_action["visible_text"])
		target.visible_message(_action["visible_text"], _action["self_text"])
	else if(_action["self_text"])
		to_chat(target, _action["self_text"])

/obj/item/lewdoo/proc/ReplaceActionTerms(var/list/_action, mob/living/carbon/user, obj/item/I)
	var/zone = user.zone_selected
	var/parsed_zone = parse_zone(zone)
	var/list/texts = list("holder_text","self_text","visible_text")
	var/list/replace_terms = list(
		"%doll%" = src,
		"%target%" = target,
		"%target.they%" = target.p_they(),
		"%target.their%" = target.p_their(),
		"%target.them%" = target.p_them(),
		"%holder%" = user,
		"%zone%" = parsed_zone,
		"%part%" = target.get_bodypart(zone),
		"%item%" = I)
	for(var/text in texts)
		if(!_action[text]) continue
		var/colon = findtext(_action[text], ":")
		if(colon)
			var/class = copytext(_action[text], 1, colon)
			var/new_text = copytext(_action[text], colon + 1, 0)
			_action[text] = "<span class=\"[class]\">[new_text]</span>"
		for(var/term in replace_terms) 
			_action[text] = replacetext(_action[text], term, replace_terms[term])

/obj/item/lewdoo/proc/CheckVisibility(var/genital, mob/living/carbon/user)
	var/obj/item/organ/genital/_organ = user.getorganslot(genital)
	var/_exposed = _organ&&_organ.is_exposed() ? TRUE : FALSE
	return list(_organ, _exposed)

/obj/item/lewdoo/proc/GetLewdSettings(mob/living/carbon/user)
	var/list/options = list()
	options["breasts"] = CheckVisibility("breasts", user)
	options["balls"] = CheckVisibility("balls", user)
	options["penis"] = CheckVisibility("penis", user)
	options["vagina"] = CheckVisibility("vagina", user)
	options["belly"] = CheckVisibility("belly", user)
	options["anus"] = CheckVisibility("anus", user)
	options["arousal"] = user.canbearoused
	options["noncon"] = user.client?.prefs.noncon
	return options


/* 
interactions
	intent
		list(
			trait: 						a trait required for this interaction
			genital:					genital part required for this interaction (help intent only)
			item:							item required for this interaction (item attack only)
			noncon:						if this interaction requires noncon enabled (harm intent only)

			holder_text: 			the text shown to the holder
			self_text: 				the text shown to the target
			visible_text: 		text shown to people around the target. DO NOT PREFBREAK
			emote:						the forced emote of the target (chance, emote)
			
			holder_pleasure:	how much pleasure the holder gains
			pleasure_gain: 		how much pleasure the target gains
			can_cum:					whether or not the target can cum from this interaction
			pain_gain: 				number representing pain gain
			mood_event: 			a mood event granted to the target when interacted
		)
*/
/obj/item/lewdoo/proc/InitializeInteractions()
	interactions = list(
		INTENT_HELP = list(
			BODY_ZONE_HEAD = list(
				"test" = list(list(
					"holder_text" = "Hello World",
					"self_text" = "Foo",
					"visible_text" = "Bar"
				))
			)
		),
		INTENT_GRAB = list(
			BODY_ZONE_HEAD = list(
				"test" = list(list(
					"holder_text" = "Hello World",
					"self_text" = "Foo",
					"visible_text" = "Bar"
				))
			)
		),
		INTENT_DISARM = list(
			BODY_ZONE_HEAD = list(
				"headpat" = list(
					list(
						"trait" = TRAIT_HEADPAT_SLUT,
						"holder_text" = "notice:You give %doll% a little headpat.",
						"self_text" = "notice:You feel an unseen force patting you on the head!!",
						"visible_text" = "%target% suddenly seems excited.", 
						"pleasure_gain" = 5,
						"mood_event" = list(
							"name" = "lewd_headpat", 
							"event" = /datum/mood_event/lewd_headpat)
					),
					list(
						"trait" = TRAIT_DISTANT,
						"holder_text" = "notice:You give %doll% a little headpat.",
						"self_text" = "warning:You swat at an unseen force patting you on the head.",
						"visible_text" = "%target% swats at the air above %target.their% head.",
						"pleasure_gain" = -5
					),
					list(
						"holder_text" = "notice:You give %doll% a little headpat.",
						"self_text" = "notice:You feel an unseen force patting you on the head.",
						"visible_text" = null, 
						"pleasure_gain" = 0,
						"mood_event" = list(
							"name" = "headpat", 
							"event" = /datum/mood_event/headpat)
					)
				)
			)
		),
		INTENT_HARM = list(
			"default" = list(
				"jab with point" = list(
					list(
						"trait" = TRAIT_MASO,
						"item" = "is_pointed",
						"holder_text" = "warning:You jab %doll% in the %zone% with the %item%!",
						"self_text" = "love:You feel an unseen force stab you in the %part%!",
						"emote" = list(40, "scream"),
						"pain_gain" = 5,
						"pleasure_gain" = 5,
						"can_cum" = TRUE
					),
					list(
						"noncon" = TRUE,
						"item" = "is_pointed",
						"holder_text" = "warning:You jab %doll% in the %zone% with the %item%!",
						"self_text" = "danger:You feel an unseen force stab you in the %part%!",
						"emote" = list(60, "scream"),
						"pain_gain" = 5,
						"pleasure_gain" = -5
					),
					list(
						"item" = "is_pointed",
						"holder_text" = "warning:You jab %doll% in the %zone% with the %item%!",
						"self_text" = "notice:You feel an unseen force poke you in the %part%."
					)
				)
			)
		)
	)