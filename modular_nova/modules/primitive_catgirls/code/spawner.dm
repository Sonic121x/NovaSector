/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl
	name = "地上的洞"
	desc = "一个明显是手工挖掘的地洞，似乎通向某种小洞穴？里面相当黑暗。"
	prompt_name = "冰月住民"
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "hole"
	mob_species = /datum/species/human/felinid/primitive
	outfit = /datum/outfit/primitive_catgirl
	density = FALSE
	you_are_text = "你是一名冰月住民。"
	flavour_text = "For as long as you can remember, the icemoon has been your home. \
		It's been the home of your ancestors, and their ancestors, and the ones before them. \
		Currently, you and your kin live in uneasy tension with your nearby human-and-otherwise \
		neighbors. Keep your village and your Kin safe, but bringing death on their heads from \
		being reckless with the outsiders will not have the Gods be so kind."
	spawner_job_path = /datum/job/primitive_catgirl
	interaction_flags_mouse_drop = NEED_DEXTERITY

	/// The team the spawner will assign players to and use to keep track of people that have already used the spawner
	var/datum/team/primitive_catgirls/team

	restricted_species = list(/datum/species/human/felinid/primitive)
	quirks_enabled = TRUE
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	loadout_enabled = FALSE
	uses = 12
	deletes_on_zero_uses_left = FALSE

	/// The list of real names of those that have gone back into the hole.
	/// Should get modified automatically by `create()` and `put_back_in()`.
	var/list/went_back_to_sleep = list()
	/// The cached string to display for additional info on who joined and who left.
	/// Nulled every time someone joins or leaves to ensure it gets re-generated.
	var/join_and_leave_log_cache = null
	/// The minimum time someone needs to be SSD before they can be put back in
	var/ssd_time = 30 MINUTES


/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/Initialize(mapload)
	. = ..()
	team = new /datum/team/primitive_catgirls()

	important_text = "在此处<a href=\"[CONFIG_GET(string/icecats_policy_link)]\">阅读完整政策</a>。"

/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/Destroy()
	team = null
	return ..()

/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/examine(mob/user)
	. = ..()

	if(uses)
		. += span_notice("你能看到<b>[uses]</b>个身影在下面熟睡着。")
	else
		. += span_notice("看起来相当空旷。")

	if(isprimitivedemihuman(user) || isobserver(user))
		. += span_notice("<i>你可以更仔细地检查它...</i>")

	return .


/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/examine_more(mob/user)
	. = ..()

	if(!isprimitivedemihuman(user) && !isobserver(user))
		return

	. += get_joined_and_left_log()


/**
 * Returns the `join_and_leave_log_cache` string if it already exists, otherwise
 * generates and returns it.
 */
/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/proc/get_joined_and_left_log()
	if(join_and_leave_log_cache)
		return join_and_leave_log_cache

	var/list/joined_player_names = list()

	for(var/datum/mind/joined_mind in team.members)
		joined_player_names += joined_mind.name

	if(!length(joined_player_names) && !length(went_back_to_sleep))
		join_and_leave_log_cache = span_notice("大家似乎都还在洞里安详地睡着。")
		return join_and_leave_log_cache

	var/nobody_joined = !length(joined_player_names)
	var/nobody_returned = !length(went_back_to_sleep)
	var/should_add_newline = !nobody_returned && !nobody_joined // if we have both missing kin and kin who went back to sleep, add a newline

	join_and_leave_log_cache = span_notice( \
		"[nobody_joined ? "" : "You smell that the following kin are missing from the hole:\n\
		<b>[joined_player_names.Join("</b>, <b>")]</b>"]\
		[should_add_newline ? "\n\n" : ""]\
		[nobody_returned ? "" : "You catch the scent of the following kin having recently went back to sleep:\n\
		<b>[went_back_to_sleep.Join("</b>, <b>")]</b>"]" \
	)

	return join_and_leave_log_cache


/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/allow_spawn(mob/user, silent = FALSE)
	if(!(user.ckey in team.players_spawned)) // One spawn per person
		return TRUE
	if(!silent)
		to_chat(user, span_warning("如果那个洞穴里有多个你，会很奇怪，不是吗？"))
	return FALSE


/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/create(mob/mob_possessor, newname, apply_prefs)
	. = ..()

	// We remove their name from there if they come back.
	went_back_to_sleep -= newname
	join_and_leave_log_cache = null


// This stuff is put on equip because it turns out /special sometimes just don't get called because Nova
/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/equip(mob/living/carbon/human/spawned_human)
	. = ..()

	spawned_human.mind.add_antag_datum(/datum/antagonist/primitive_catgirl, team)

	team.players_spawned += (spawned_human.ckey)


/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/mouse_drop_receive(mob/living/carbon/human/target, mob/user, params)
	if(!istype(target))
		return
	if(!isprimitivedemihuman(target) || target.buckled)
		return

	if(target.stat == DEAD)
		to_chat(user, span_danger("死去的族人无法被放回去睡觉。"))
		return

	if(target.ckey && target != user)
		if(!target.get_organ_by_type(/obj/item/organ/brain) || (target.mind && !target.ssd_indicator))
			to_chat(user, span_danger("醒着的族人不能违背其意愿被放回去睡觉。"))
			return

		if(target.lastclienttime + ssd_time >= world.time)
			to_chat(user, span_userdanger("你还要等<b>[round(((ssd_time - (world.time - target.lastclienttime)) / (1 MINUTES)), 1)]</b>分钟才能把[target]放进[src]。"))
			log_admin("[key_name(user)] has attempted to put [key_name(target)] back into [src], but they were only disconnected for [round(((world.time - target.lastclienttime) / (1 MINUTES)), 1)] minutes.")
			message_admins("[key_name(user)] has attempted to put [key_name(target)] back into [src]. [ADMIN_JMP(src)]")
			return

		else if(tgui_alert(user, "是否要将[target]放入[src]？", "放回去睡觉？", list("Yes", "No")) == "Yes")

			visible_message(span_infoplain("[user]开始把[target]放进[src]..."))

			if(!do_after(user, 3 SECONDS, target))
				balloon_alert(user, "取消转移！")
				return

			to_chat(user, span_danger("你把[target]放进了[src]。"))
			log_admin("[key_name(user)] has put [key_name(target)] back into [src].")
			message_admins("[key_name(user)] has put [key_name(target)] back into [src]. [ADMIN_JMP(src)]")

	if(target == user)
		if(tgui_alert(target, "你想要回去睡觉吗？", "回去睡觉？", list("Yes", "No")) != "Yes")
			return

		visible_message(span_infoplain("[user]开始爬进[src]..."))

		if(!do_after(user, 3 SECONDS, target))
			balloon_alert(user, "取消转移！")
			return

	if(LAZYLEN(target.buckled_mobs) > 0)
		if(target == user)
			to_chat(user, span_danger("有人被绑在你身上时，你无法进入[src]。"))
		else
			to_chat(user, span_danger("当有人被绑在[target]身上时，你无法将其放入[src]。"))

		return

	// Just in case something happened in-between, to make sure it doesn't do unexpected behaviors.
	if(!isprimitivedemihuman(target) || !can_interact(user) || !target.Adjacent(user)  || target.buckled || target.stat == DEAD)
		return

	if(target == user)
		visible_message(span_infoplain("[user]爬进了[src]。"))
	else
		visible_message(span_infoplain("[user] 将 [target] 放进了 [src]。"))

	log_admin("[key_name(target)] returned to [src].")
	message_admins("[key_name_admin(target)] returned to [src]. [ADMIN_JMP(src)]")
	add_fingerprint(target)
	put_back_in(target)


/**
 * Puts the target back into the spawner, effectively qdel'ing them after
 * stripping them of all their items, and finishes by adding back a use to the
 * spawner.
 */
/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/proc/put_back_in(mob/living/carbon/human/target)
	if(!istype(target))
		return

	// We don't want to constantly drop stuff that they spawn with.
	var/static/list/item_drop_blacklist
	if(!item_drop_blacklist)
		item_drop_blacklist = generate_item_drop_blacklist()

	for(var/obj/item/item in target)
		if(item_drop_blacklist[item.type] || (item.item_flags & ABSTRACT) || HAS_TRAIT(item, TRAIT_NODROP))
			continue

		target.dropItemToGround(item, FALSE)

	// We make sure people can come back in again, if they needed to fix prefs
	// or whatever.
	team.players_spawned -= (target.ckey)
	team.remove_member(target.mind)
	went_back_to_sleep += target.real_name
	join_and_leave_log_cache = null

	for(var/list/record in GLOB.ghost_records)
		if(record["name"] == target.real_name)
			GLOB.ghost_records.Remove(list(record))
			break

	// Just so the target's ghost ends up above the hole.
	target.forceMove(loc)
	target.ghostize(FALSE)

	qdel(target)

	uses += 1


/**
 * Simple helper to generate the item drop blacklist based on the spawner's
 * outfit, only taking the used slots into account.
 */
/obj/effect/mob_spawn/ghost_role/human/primitive_catgirl/proc/generate_item_drop_blacklist()
	PROTECTED_PROC(TRUE)

	var/list/blacklist = list()

	blacklist[initial(outfit.uniform)] = TRUE
	blacklist[initial(outfit.shoes)] = TRUE
	blacklist[initial(outfit.gloves)] = TRUE
	blacklist[initial(outfit.suit)] = TRUE
	blacklist[initial(outfit.neck)] = TRUE
	blacklist[initial(outfit.back)] = TRUE

	return blacklist


/datum/job/primitive_catgirl
	title = "Icemoon Dweller"

// Antag and team datums

/datum/team/primitive_catgirls
	name = "冰行者"
	member_name = "Icewalker"
	show_roundend_report = FALSE

/datum/team/primitive_catgirls/roundend_report()
	var/list/report = list()

	report += span_header("一个冰行者部族栖息在这片废土上...</span><br>")
	if(length(members))
		report += "The [member_name]s were:"
		report += printplayerlist(members)
	else
		report += "<b>But none of its members woke up!</b>"

	return "<div class='panel redborder'>[report.Join("<br>")]</div>"

// Antagonist datum

/datum/antagonist/primitive_catgirl
	name = "\improper 冰行者"
	pref_flag = ROLE_LAVALAND // If you're ashwalker banned you should also not be playing this, other way around as well
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antagpanel_category = "Icemoon Dwellers"
	antag_flags = ANTAG_FAKE | ANTAG_SKIP_GLOBAL_LIST
	show_in_roundend = FALSE

	/// Tracks the antag datum's 'team' for showing in the ghost orbit menu
	var/datum/team/primitive_catgirls/feline_team

	antag_recipes = list(
		/datum/crafting_recipe/anointing_oil,
		/datum/crafting_recipe/black_pelt_bed,
		/datum/crafting_recipe/boneaxe,
		/datum/crafting_recipe/bonedagger,
		/datum/crafting_recipe/bonespear,
		/datum/crafting_recipe/frozen_breath,
		/datum/crafting_recipe/handcrafted_hearthkin_armor,
		/datum/crafting_recipe/hearthkin_ship_fragment_inactive,
		/datum/crafting_recipe/runic_greataxe,
		/datum/crafting_recipe/runic_greatsword,
		/datum/crafting_recipe/runic_spear,
		/datum/crafting_recipe/skeleton_key,
		/datum/crafting_recipe/white_pelt_bed,
	)

/datum/antagonist/primitive_catgirl/Destroy()
	feline_team = null
	return ..()

/datum/antagonist/primitive_catgirl/create_team(datum/team/team)
	if(team)
		feline_team = team
		objectives |= feline_team.objectives
	else
		feline_team = new

/datum/antagonist/primitive_catgirl/get_team()
	return feline_team
