// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/mod/construction
	desc = "A part used in MOD construction."
	icon = 'icons/obj/clothing/modsuit/mod_construction.dmi'
	inhand_icon_state = "rack_parts"

/obj/item/mod/construction/helmet
	name = "MOD helmet"
	icon_state = "helmet"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5)

/obj/item/mod/construction/helmet/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.2167c56c", null))

/obj/item/mod/construction/chestplate
	name = "MOD chestplate"
	icon_state = "chestplate"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5)

/obj/item/mod/construction/chestplate/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.2167c56c", null))

/obj/item/mod/construction/gauntlets
	name = "MOD gauntlets"
	icon_state = "gauntlets"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5)

/obj/item/mod/construction/gauntlets/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.9db100df", null))

/obj/item/mod/construction/boots
	name = "MOD boots"
	icon_state = "boots"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5)

/obj/item/mod/construction/boots/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.9db100df", null))

/obj/item/mod/construction/broken_core
	name = "broken MOD core"
	icon_state = "mod-core"
	desc = "An internal power source for a Modular Outerwear Device. You don't seem to be able to source any power from this one, though."

/obj/item/mod/construction/broken_core/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.f81088c7", null))

/obj/item/mod/construction/broken_core/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	balloon_alert(user, LANG("obj.b52342a8", null))
	if(!tool.use_tool(src, user, 5 SECONDS, volume = 30))
		balloon_alert(user, LANG("obj.c67b5d27", null))
		return
	new /obj/item/mod/core/standard(drop_location())
	qdel(src)

/obj/item/mod/construction/lavalandcore
	name = "plasma flower"
	icon_state = "plasma-flower"
	desc = "A strange flower from the desolate wastes of lavaland. It pulses with a bright purple glow.  \
		Its shape is remarkably similar to that of a MOD core."
	light_system = OVERLAY_LIGHT
	light_color = "#cc00cc"
	light_range = 2.5
	light_power = 1.5

/obj/item/mod/construction/lavalandcore/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.558de421", null))

/obj/item/mod/construction/lavalandcore/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stack/cable_coil))
		return NONE

	if(!tool.tool_start_check(user, amount=2))
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, LANG("obj.f547a475", null))
	if(!tool.use_tool(src, user, 5 SECONDS, amount = 2, volume = 30))
		balloon_alert(user, LANG("obj.c67b5d27", null))
		return ITEM_INTERACT_BLOCKING

	new /obj/item/mod/core/plasma/lavaland(drop_location())
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/mod/construction/plating
	name = "MOD external plating"
	desc = "External plating used to finish a MOD control unit."
	icon_state = "standard-plating"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5)
	var/datum/mod_theme/theme = /datum/mod_theme

/obj/item/mod/construction/plating/Initialize(mapload)
	. = ..()
	var/datum/mod_theme/used_theme = GLOB.mod_themes[theme]
	name = "MOD [lang_reverse_text(used_theme.name)] external plating" // NOVA EDIT CHANGE - I18N - ORIGINAL: name = "MOD [used_theme.name] external plating"
	desc = "[desc] [lang_reverse_text(used_theme.desc)]" // NOVA EDIT CHANGE - I18N - ORIGINAL: desc = "[desc] [used_theme.desc]"
	icon_state = "[used_theme.default_skin]-plating"

/obj/item/mod/construction/plating/civilian
	theme = /datum/mod_theme/civilian
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5)

/obj/item/mod/construction/plating/portable_suit
	theme = /datum/mod_theme/portable_suit
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/plastic = SHEET_MATERIAL_AMOUNT, /datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5)

/obj/item/mod/construction/plating/engineering
	theme = /datum/mod_theme/engineering
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/gold = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5)

/obj/item/mod/construction/plating/atmospheric
	theme = /datum/mod_theme/atmospheric
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/titanium = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5)

/obj/item/mod/construction/plating/medical
	theme = /datum/mod_theme/medical
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/silver = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5)

/obj/item/mod/construction/plating/security
	theme = /datum/mod_theme/security

/obj/item/mod/construction/plating/cosmohonk
	theme = /datum/mod_theme/cosmohonk
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/bananium = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5)

#define START_STEP "start"
#define CORE_STEP "core"
#define SCREWED_CORE_STEP "screwed_core"
#define HELMET_STEP "helmet"
#define CHESTPLATE_STEP "chestplate"
#define GAUNTLETS_STEP "gauntlets"
#define BOOTS_STEP "boots"
#define WRENCHED_ASSEMBLY_STEP "wrenched_assembly"
#define SCREWED_ASSEMBLY_STEP "screwed_assembly"

/obj/item/mod/construction/shell
	name = "MOD shell"
	icon_state = "mod-construction_start"
	desc = "A MOD shell."
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/plasma = SHEET_MATERIAL_AMOUNT * 2.5)
	var/obj/item/core
	var/obj/item/helmet
	var/obj/item/chestplate
	var/obj/item/gauntlets
	var/obj/item/boots
	var/step = START_STEP

/obj/item/mod/construction/shell/examine(mob/user)
	. = ..()
	var/display_text
	switch(step)
		if(START_STEP)
			display_text = "It looks like it's missing a <b>MOD core</b>..."
		if(CORE_STEP)
			display_text = "The core seems <b>loose</b>..."
		if(SCREWED_CORE_STEP)
			display_text = "It looks like it's missing a <b>helmet</b>..."
		if(HELMET_STEP)
			display_text = "It looks like it's missing a <b>chestplate</b>..."
		if(CHESTPLATE_STEP)
			display_text = "It looks like it's missing <b>gauntlets</b>..."
		if(GAUNTLETS_STEP)
			display_text = "It looks like it's missing <b>boots</b>..."
		if(BOOTS_STEP)
			display_text = "The assembly seems <b>unsecured</b>..."
		if(WRENCHED_ASSEMBLY_STEP)
			display_text = "The assembly seems <b>loose</b>..."
		if(SCREWED_ASSEMBLY_STEP)
			display_text = "All it's missing is <b>external plating</b>..."
	. += span_notice(display_text)

/obj/item/mod/construction/shell/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	switch(step)
		if(START_STEP)
			if(!istype(tool, /obj/item/mod/core))
				return NONE

			if(!user.transferItemToLoc(tool, src))
				balloon_alert(user, LANG("obj.ee463177", null))
				return ITEM_INTERACT_BLOCKING

			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			balloon_alert(user, LANG("obj.de575d7b", null))
			core = tool
			step = CORE_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(SCREWED_CORE_STEP)
			if(!istype(tool, /obj/item/mod/construction/helmet)) //Construct
				return NONE

			if(!user.transferItemToLoc(tool, src))
				balloon_alert(user, LANG("obj.ee463177", null))
				return ITEM_INTERACT_BLOCKING

			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			balloon_alert(user, LANG("obj.95fcc204", null))
			helmet = tool
			step = HELMET_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(HELMET_STEP)
			if(!istype(tool, /obj/item/mod/construction/chestplate)) //Construct
				return NONE

			if(!user.transferItemToLoc(tool, src))
				balloon_alert(user, LANG("obj.ee463177", null))
				return ITEM_INTERACT_BLOCKING

			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			balloon_alert(user, LANG("obj.6f263f01", null))
			chestplate = tool
			step = CHESTPLATE_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(CHESTPLATE_STEP)
			if(!istype(tool, /obj/item/mod/construction/gauntlets)) //Construct
				return NONE

			if(!user.transferItemToLoc(tool, src))
				balloon_alert(user, LANG("obj.ee463177", null))
				return ITEM_INTERACT_BLOCKING

			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			balloon_alert(user, LANG("obj.9df0f806", null))
			gauntlets = tool
			step = GAUNTLETS_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(GAUNTLETS_STEP)
			if(!istype(tool, /obj/item/mod/construction/boots)) //Construct
				return NONE

			if(!user.transferItemToLoc(tool, src))
				balloon_alert(user, LANG("obj.ee463177", null))
				return ITEM_INTERACT_BLOCKING

			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			balloon_alert(user, LANG("obj.61bb5191", null))
			boots = tool
			step = BOOTS_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(SCREWED_ASSEMBLY_STEP)
			if(!istype(tool, /obj/item/mod/construction/plating)) //Construct
				return NONE

			var/obj/item/mod/construction/plating/external_plating = tool
			if(!user.transferItemToLoc(tool, src))
				balloon_alert(user, LANG("obj.ee463177", null))
				return ITEM_INTERACT_BLOCKING

			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			var/obj/item/mod = new /obj/item/mod/control(drop_location(), external_plating.theme, null, core)
			core = null
			qdel(src)
			user.put_in_hands(mod)
			mod.balloon_alert(user, LANG("obj.33113ef2", null))
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/mod/construction/shell/screwdriver_act(mob/living/user, obj/item/tool)
	switch(step)

		if(CORE_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			balloon_alert(user, LANG("obj.a5967dfa", null))
			step = SCREWED_CORE_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(SCREWED_CORE_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			balloon_alert(user, LANG("obj.4e25acf7", null))
			step = CORE_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(WRENCHED_ASSEMBLY_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			balloon_alert(user, LANG("obj.8284d713", null))
			step = SCREWED_ASSEMBLY_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(SCREWED_ASSEMBLY_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			balloon_alert(user, LANG("obj.b5142f35", null))
			step = WRENCHED_ASSEMBLY_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/mod/construction/shell/crowbar_act(mob/living/user, obj/item/tool)
	switch(step)
		if(CORE_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_SUCCESS

			core.forceMove(drop_location())
			balloon_alert(user, LANG("obj.17bf120a", null))
			step = START_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(HELMET_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			helmet.forceMove(drop_location())
			balloon_alert(user, LANG("obj.b42b2433", null))
			helmet = null
			step = SCREWED_CORE_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(CHESTPLATE_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			chestplate.forceMove(drop_location())
			balloon_alert(user, LANG("obj.1d2b3d3b", null))
			chestplate = null
			step = HELMET_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(GAUNTLETS_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			gauntlets.forceMove(drop_location())
			balloon_alert(user, LANG("obj.cb7f46ae", null))
			gauntlets = null
			step = CHESTPLATE_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(BOOTS_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			boots.forceMove(drop_location())
			balloon_alert(user, LANG("obj.1bbfd35b", null))
			boots = null
			step = GAUNTLETS_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/mod/construction/shell/wrench_act(mob/living/user, obj/item/tool)
	switch(step)
		if(BOOTS_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			balloon_alert(user, LANG("obj.40e42e49", null))
			step = WRENCHED_ASSEMBLY_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

		if(WRENCHED_ASSEMBLY_STEP)
			if(!tool.use_tool(src, user, 0, volume = 30))
				return ITEM_INTERACT_BLOCKING

			balloon_alert(user, LANG("obj.213e899a", null))
			step = BOOTS_STEP
			update_icon_state()
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/mod/construction/shell/update_icon_state()
	. = ..()
	icon_state = "mod-construction_[step]"

/obj/item/mod/construction/shell/Destroy()
	QDEL_NULL(core)
	QDEL_NULL(helmet)
	QDEL_NULL(chestplate)
	QDEL_NULL(gauntlets)
	QDEL_NULL(boots)
	return ..()

/obj/item/mod/construction/shell/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == core)
		core = null
	if(gone == helmet)
		helmet = null
	if(gone == chestplate)
		chestplate = null
	if(gone == gauntlets)
		gauntlets = null
	if(gone == boots)
		boots = null

#undef START_STEP
#undef CORE_STEP
#undef SCREWED_CORE_STEP
#undef HELMET_STEP
#undef CHESTPLATE_STEP
#undef GAUNTLETS_STEP
#undef BOOTS_STEP
#undef WRENCHED_ASSEMBLY_STEP
#undef SCREWED_ASSEMBLY_STEP
