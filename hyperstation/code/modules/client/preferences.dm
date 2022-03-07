/datum/preferences/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/tgui_state/state = GLOB.tgui_always_state)
	. = ..()
	// If you leave and come back, re-register the character preview
	// if (!isnull(character_preview_view) && !(character_preview_view in user.client?.screen))
	// 	user.client?.register_map_obj(character_preview_view)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "PreferencesWindow", "Preferences Setup", 700, 600, master_ui, state)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/preferences/ui_status(mob/user, datum/tgui_state/state)
	return user.client == parent ? UI_INTERACTIVE : UI_CLOSE

/datum/preferences/ui_data(mob/user)
	var/list/data = list()
	return data

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if (.)
		return

// /datum/preferences/ui_close(mob/user)
// 	save_character()
// 	save_preferences()
// 	QDEL_NULL(character_preview_view)