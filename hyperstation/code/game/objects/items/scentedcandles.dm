/*
SCENTED CANDLES

with a Scented Candle Kit, you can "capture" the aroma of an object and create 
scented candles out of it. scented candles can support up to three fragrances
and be given a custom name and color. when someone walks into a room with a
scented candle, they'll be given flavor text about it - "you can smell [aroma]
from [candle]."

created as a gimmick item for janitors, but anyone can enjoy making scented 
candles

-- sarcoph, july 2022
*/


/// Scented candle; produced by scented candle kit. When lit, it produces flavor text describing the aroma.
/obj/item/candle/scented
	name = "scented candle"
	desc = "A candle that produces a special aroma when lit."
	icon = 'hyperstation/icons/obj/scented_candle.dmi'
	icon_state = "candle1"
	wax = 2000
	var/list/aromas = list()
	var/list/detected = list()
	var/candle_color = "#cccccc"

/obj/item/candle/scented/Initialize()
	. = ..()
	update_icon()

/obj/item/candle/scented/examine(mob/user)
	. = ..()
	if (length(aromas) > 0)
		. += "This one smells like [english_list(aromas)]."
		return
	. += "This one doesn't smell like anything."

/obj/item/candle/scented/update_icon()
	cut_overlays()
	var/stage = 1
	switch(wax)
		if(0 to 800)
			stage = 3
		if(800 to 1400)
			stage = 2
		if(1400 to INFINITE)
			stage = 1
	icon_state = "candle[stage]"
	var/mutable_appearance/candle_icon = mutable_appearance(icon = src.icon, icon_state = src.icon_state, color = src.candle_color )
	var/mutable_appearance/wick_icon = mutable_appearance(icon = src.icon, icon_state = "wick[stage][lit ? "_lit" : ""]")
	add_overlay(candle_icon)
	add_overlay(wick_icon)

/obj/item/candle/scented/process()
	if(!lit)
		detected = list()
		return PROCESS_KILL
	if(!infinite)
		wax--
	if(!wax)
		var/obj/item/trash/candle/scented/trash = new /obj/item/trash/candle/scented(loc)
		trash.color = candle_color
		qdel(src)
	update_icon()
	open_flame()
	ScentProcess()

/**
  *	Effectively: Whenever you enter a room with a scented candle, or a scented candle is lit
  *	in the same room as you, you will get a bit of flavor text. You will not receive this
  * flavor text again unless you leave the room and come back.
  *
  * Basically, the candle has a list of mobs it has detected. It assembles a new list of mobs
  * each ScentProcess. If you're in the new list, but not the old list, then you have just entered
  * the candle's range. You get the flavor text. The new list replaces the old list.
  *
  * If you're still in the room for the next ScentProcess, you will not receive the text. If you
  * exit range, you'll be removed from the list, meaning next time you enter range, you get the text
  * again.
  *
  * I wonder if there's a better way to do this because for some reason, initiating a new
  * list every time does not feel like the best option.
  */
/obj/item/candle/scented/proc/ScentProcess()
	if(aromas.len < 1)
		return
	var/list/_new_detected = list()
	var/_scent_source = src
	var/_scent_range = 8
	if(isliving(src.loc))
		_new_detected.Add(WEAKREF(src.loc))
		_scent_source = src.loc
		_scent_range = 2
	for(var/mob/living/_mob in view(_scent_range, _scent_source))
		_new_detected.Add(WEAKREF(_mob))
		if(detected.Find(WEAKREF(_mob)))
			continue
		to_chat(_mob, "<span class='notice'>You can smell [english_list(aromas)].</span>")
	detected = _new_detected


/// Scented trash candle; has color of original candle
/obj/item/trash/candle/scented
	name = "scented candle"
	icon = 'hyperstation/icons/obj/scented_candle.dmi'
	icon_state = "candle4"


/// Fragrance bottles, used in Scented Candle Kit
/obj/item/scentcontainer
	name = "empty fragrance bottle"
	icon = 'hyperstation/icons/obj/scented_candle.dmi'
	icon_state = "emptybottle"
	var/aroma = null

/obj/item/scentcontainer/proc/EmptyFragrance(mob/living/user)
	if(aroma)
		to_chat(user, "<span class='notice'>You empty the [src.name].</span>")
		aroma = null
	update_icon_state()

/obj/item/scentcontainer/proc/FillWithFragrance(mob/living/user, scent)
	aroma = scent
	update_icon_state()

/obj/item/scentcontainer/update_icon_state()
	if(aroma)
		icon_state = "filledbottle"
		name = "[aroma] fragrance bottle"
		return
	icon_state = "emptybottle"
	name = "empty fragrance bottle"

/obj/item/scentcontainer/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!aroma)
		FillWithFragrance(user, M.name)

/obj/item/scentcontainer/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(!aroma)
		FillWithFragrance(user, O.name)

/obj/item/scentcontainer/CtrlClick(mob/user)
	. = ..()
	EmptyFragrance(user)
