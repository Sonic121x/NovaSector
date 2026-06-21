///Tracking reasons
/datum/antagonist/heretic_monster
	name = "\improper 异畏之怖"
	roundend_category = "Heretics"
	antagpanel_category = ANTAG_GROUP_HORRORS
	antag_moodlet = /datum/mood_event/heretics
	pref_flag = ROLE_HERETIC
	antag_hud_name = "heretic_beast"
	suicide_cry = "MY MASTER SMILES UPON ME!!"
	show_in_antagpanel = FALSE
	stinger_sound = 'sound/music/antag/heretic/heretic_gain.ogg'
	/// Our master (a heretic)'s mind.
	var/datum/mind/master

/datum/antagonist/heretic_monster/on_removal()
	if(!silent)
		if(master?.current)
			to_chat(master.current, span_warning("[owner]——你仆从的本质，正从你的意识中消逝。"))
		if(owner.current)
			to_chat(owner.current, span_deconversion_message("Your mind begins to fill with haze - your master is no longer[master ? " [master]":""], you are free!"))
			owner.current.visible_message(span_deconversion_message("[owner.current]看起来[owner.current.p_theyve()]已从曼苏斯的锁链中解放！"), ignored_mobs = owner.current)

	master = null
	return ..()

/datum/antagonist/heretic_monster/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/target = mob_override || owner.current
	ADD_TRAIT(target, TRAIT_HERETIC_SUMMON, REF(src))

/datum/antagonist/heretic_monster/remove_innate_effects(mob/living/mob_override)
	var/mob/living/target = mob_override || owner.current
	REMOVE_TRAIT(target, TRAIT_HERETIC_SUMMON, REF(src))
	return ..()

/*
 * Set our [master] var to a new mind.
 */
/datum/antagonist/heretic_monster/proc/set_owner(datum/mind/master)
	src.master = master
	owner.enslave_mind_to_creator(master.current)

	var/datum/objective/master_obj = new()
	master_obj.owner = owner
	master_obj.explanation_text = "Assist your master."
	master_obj.completed = TRUE

	objectives += master_obj
	owner.announce_objectives()
	to_chat(owner, span_boldnotice("You are a [ishuman(owner.current) ? "shambling corpse returned":"horrible creation brought"] to this plane through the Gates of the Mansus."))
	to_chat(owner, span_notice("你的主人是[master]。不惜一切代价协助他们。"))
