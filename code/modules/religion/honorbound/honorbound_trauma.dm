/// one reason for declaring guilty is specifically checked for, keeping it as a define to avoid future mistakes
#define GUILT_REASON_DECLARATION "from your declaration."

///Honorbound prevents you from attacking the unready, the just, or the innocent
/datum/brain_trauma/special/honorbound
	name = "教条强迫症"
	desc = "患者感到被迫遵守所谓的\"战斗规则\"。"
	scan_desc = "damaged frontal lobe"
	symptoms = "Gains a strict code of honor that governs their behavior, \
		forbidding them from attacking those who are unready, just, or innocent. \
		This code often leads to strife, both external and internal, \
		as the patient struggles to reconcile their beliefs with the realities of combat and survival."
	gain_text = span_notice("你感到受荣誉约束！")
	lose_text = span_warning("你感到从你的荣誉准则中解脱了！")
	random_gain = FALSE
	/// list of guilty people
	var/list/guilty = list()

/datum/brain_trauma/special/honorbound/on_gain()
	//moodlet
	owner.add_mood_event("honorbound", /datum/mood_event/honorbound)
	//checking spells cast by honorbound
	RegisterSignal(owner, COMSIG_MOB_CAST_SPELL, PROC_REF(spell_check))
	RegisterSignal(owner, COMSIG_MOB_FIRED_GUN, PROC_REF(staff_check))

	//adds the relay_attackers element to the owner so whoever attacks him becomes guilty.
	if(!HAS_TRAIT(owner, TRAIT_RELAYING_ATTACKER))
		owner.AddElement(/datum/element/relay_attackers)
	RegisterSignal(owner, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked))

	//signal that checks for dishonorable attacks
	RegisterSignal(owner, COMSIG_LIVING_EARLY_UNARMED_ATTACK, PROC_REF(unarmed_attack_honor))
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(attack_honor))
	RegisterSignal(owner, COMSIG_MOB_TRYING_TO_FIRE_GUN, PROC_REF(fire_gun_honor))
	var/datum/action/cooldown/spell/pointed/declare_evil/declare = new(owner)
	declare.Grant(owner)
	return ..()

/datum/brain_trauma/special/honorbound/on_lose(silent)
	owner.clear_mood_event("honorbound")
	UnregisterSignal(owner, list(
		COMSIG_LIVING_EARLY_UNARMED_ATTACK,
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_MOB_TRYING_TO_FIRE_GUN,
		COMSIG_MOB_CAST_SPELL,
		COMSIG_MOB_FIRED_GUN,
	))
	return ..()

/datum/brain_trauma/special/honorbound/proc/unarmed_attack_honor(mob/living/carbon/human/honorbound, atom/target, proximity_flag, modifiers)
	SIGNAL_HANDLER

	if(modifiers[ALT_CLICK] || modifiers[SHIFT_CLICK] || modifiers[CTRL_CLICK] || modifiers[MIDDLE_CLICK])
		return

	if(!proximity_flag || !isliving(target))
		return NONE

	var/mob/living/punched_mob = target

	if(!(punched_mob in guilty))
		check_visible_guilt(punched_mob)

	if((honorbound.combat_mode || modifiers[RIGHT_CLICK]) && !is_honorable(honorbound, punched_mob))
		return COMPONENT_CANCEL_ATTACK_CHAIN

/// Signal to see if the trauma allows us to attack a target with a weapon
/datum/brain_trauma/special/honorbound/proc/attack_honor(mob/living/honorbound, atom/attacked, list/modifiers)
	SIGNAL_HANDLER

	if(!isliving(attacked))
		return

	var/mob/living/attacked_mob = attacked
	var/obj/item/weapon = honorbound.get_active_held_item()

	if(weapon?.item_flags & NOBLUDGEON)
		return

	if(!(attacked_mob in guilty))
		check_visible_guilt(attacked_mob)

	if(((weapon?.item_flags & NEEDS_PERMIT) || honorbound.combat_mode || weapon?.force > 0) && !is_honorable(honorbound, attacked_mob))
		return COMPONENT_CANCEL_ATTACK_CHAIN

/// Signal to see if we're targeting a mob that is guilty or not.
/datum/brain_trauma/special/honorbound/proc/fire_gun_honor(mob/living/honorbound, obj/item/gun/the_gun_in_question, atom/target, flag, params)
	SIGNAL_HANDLER

	if(istype(the_gun_in_question, /obj/item/gun/magic))
		return

	if(!isliving(target)) //No shooting an innocent you weren't aiming at to get around this. Aim true or go home, honor-dork
		return COMPONENT_CANCEL_GUN_FIRE

	var/mob/living/shot_mob = target

	if(!(shot_mob in guilty))
		check_visible_guilt(shot_mob)

	if(!is_honorable(honorbound, shot_mob))
		return COMPONENT_CANCEL_GUN_FIRE

/// Checks a mob for any obvious signs of evil, and applies a guilty reason for each.
/datum/brain_trauma/special/honorbound/proc/check_visible_guilt(mob/living/attacked_mob)
	//will most likely just hit nuke ops but good catch-all. WON'T hit traitors
	if(attacked_mob.has_faction(ROLE_SYNDICATE))
		guilty(attacked_mob, "for their misaligned association with the Syndicate!")
	//not an antag datum check so it applies to wizard minions as well
	if(attacked_mob.has_faction(ROLE_WIZARD))
		guilty(attacked_mob, "for blasphemous magicks!")
	if(HAS_TRAIT(attacked_mob, TRAIT_CULT_HALO))
		guilty(attacked_mob, "for blasphemous worship!")
	if(HAS_TRAIT(attacked_mob, TRAIT_EVIL))
		guilty(attacked_mob, "for an almost fanatical commitment to EEEEVIL!")
	if(attacked_mob.mind)
		var/datum/mind/guilty_conscience = attacked_mob.mind
		if(guilty_conscience.has_antag_datum(/datum/antagonist/abductor))
			guilty(attacked_mob, "for their blatant surgical malice...")
		if(guilty_conscience.has_antag_datum(/datum/antagonist/nightmare))
			guilty(attacked_mob, "for being a light-consuming nightmare!")
		if(guilty_conscience.has_antag_datum(/datum/antagonist/ninja))
			guilty(attacked_mob, "for their misaligned association with the Spider Clan!")
		var/datum/antagonist/heretic/heretic_datum = guilty_conscience.has_antag_datum(/datum/antagonist/heretic)
		if(heretic_datum?.ascended)
			guilty(attacked_mob, "for blasphemous, heretical, out of control worship!")

/**
 * Called by hooked signals whenever someone attacks the person with this trauma
 * Checks if the attacker should be considered guilty and adds them to the guilty list if true
 *
 * Arguments:
 * * user: person who attacked the honorbound
 * * reason: why this person is now guilty (future pr idea: letting honorbound print a receipt for why someone is guilty? lol)
 */
/datum/brain_trauma/special/honorbound/proc/guilty(mob/living/user, reason = "for no particular reason!")
	if(user in guilty)
		return
	var/datum/mind/guilty_conscience = user.mind
	if(guilty_conscience && reason != GUILT_REASON_DECLARATION) //sec and medical are immune to becoming guilty through attack (we don't check holy because holy shouldn't be able to attack eachother anyways)
		var/datum/job/job = guilty_conscience.assigned_role
		if(job.departments_bitflags & (DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SECURITY))
			return
	to_chat(owner, span_notice("[user] 现在被 [GLOB.deity] 视为有罪 [reason]"))
	to_chat(user, span_danger("[GLOB.deity] 不再视你为无辜者！"))
	guilty += user

///Signal sent by the relay_attackers element. It makes the attacker guilty unless the damage was stamina or it was a shove.
/datum/brain_trauma/special/honorbound/proc/on_attacked(mob/source, mob/attacker, attack_flags)
	SIGNAL_HANDLER
	if(!(attack_flags & (ATTACKER_STAMINA_ATTACK|ATTACKER_SHOVING)))
		guilty(attacker, "for attacking [source] first.")

/**
 * Called by attack_honor signal to check whether an attack should be allowed or not
 *
 * Arguments:
 * * honorbound_human: typecasted owner of the trauma
 * * target_creature: person honorbound_human is attacking
 */
/datum/brain_trauma/special/honorbound/proc/is_honorable(mob/living/carbon/human/honorbound_human, mob/living/target_creature)
	var/is_guilty = (target_creature in guilty)
	var/is_human = ishuman(target_creature)
	//THE UNREADY (Applies over ANYTHING else!)
	if(honorbound_human == target_creature)
		return TRUE //oh come on now
	if(target_creature.IsSleeping() || target_creature.IsUnconscious() || HAS_TRAIT(target_creature, TRAIT_RESTRAINED))
		to_chat(honorbound_human, span_warning("攻击<b>未准备就绪者</b>毫无荣誉可言。"))
		return FALSE
	//THE JUST (Applies over guilt except for med, so you best be careful!)
	if(is_human)
		var/mob/living/carbon/human/target_human = target_creature
		var/datum/job/job = target_human.mind?.assigned_role
		var/is_holy = target_human.mind?.holy_role
		if(is_holy || (job?.departments_bitflags & DEPARTMENT_BITFLAG_SECURITY))
			to_chat(honorbound_human, span_warning("攻击<b>正义者</b>毫无公义可言。"))
			return FALSE
		if(job?.departments_bitflags & DEPARTMENT_BITFLAG_MEDICAL && !is_guilty)
			to_chat(honorbound_human, span_warning("如果你真认为这位医者并非<b>无辜</b>，就宣告他们有罪。"))
			return FALSE
	//THE INNOCENT (human and borg exclusive)
	if(!is_guilty && (is_human || issilicon(target_creature)))
		to_chat(target_creature, span_warning("攻击<b>无辜者</b>毫无公义可言。"))
		return FALSE
	return TRUE

//spell checking
/datum/brain_trauma/special/honorbound/proc/spell_check(mob/user, datum/action/cooldown/spell/spell_cast)
	SIGNAL_HANDLER
	punishment(user, spell_cast.school)

/datum/brain_trauma/special/honorbound/proc/staff_check(mob/user, obj/item/gun/gun_fired, target, params, zone_override, list/bonus_spread_values)
	SIGNAL_HANDLER
	if(!istype(gun_fired, /obj/item/gun/magic))
		return
	var/obj/item/gun/magic/offending_staff = gun_fired
	punishment(user, offending_staff.school)

/**
 * Called when a spell is casted or a magic gun is fired, checks the signal and punishes accordingly
 *
 * Arguments:
 * * user: typecasted owner of trauma
 * * school: school of magic casted from the staff/spell
 */
/datum/brain_trauma/special/honorbound/proc/punishment(mob/living/carbon/human/user, school)
	switch(school)
		if(SCHOOL_HOLY, SCHOOL_MIME, SCHOOL_RESTORATION, SCHOOL_PSYCHIC)
			return
		if(SCHOOL_NECROMANCY, SCHOOL_FORBIDDEN, SCHOOL_SANGUINE)
			to_chat(user, span_userdanger("[GLOB.deity] 因你使用禁忌魔法而震怒！"))
			lightningbolt(user)
			user.mind.set_holy_role(NONE)
			qdel(src)
			owner.add_mood_event("honorbound", /datum/mood_event/banished) //add mood event after we already cleared our events
			to_chat(user, span_userdanger("你已被逐出教门！你不再神圣！"))
		else
			to_chat(user, span_userdanger("[GLOB.deity] 对你使用 [school == SCHOOL_UNSET ? "strange" : school] 魔法感到愤怒！"))
			lightningbolt(user)
			owner.add_mood_event("honorbound", /datum/mood_event/holy_smite)//permanently lose your moodlet after this

/datum/action/cooldown/spell/pointed/declare_evil
	name = "宣告邪恶"
	desc = "若某人显然为此世之恶，你可消耗大量恩惠来宣告其有罪。"
	button_icon_state = "declaration"
	ranged_mousepointer = 'icons/effects/mouse_pointers/honorbound.dmi'

	school = SCHOOL_HOLY
	cooldown_time = 0

	invocation = "This is an error!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_HUMAN

	active_msg = "You prepare to declare a sinner..."
	deactive_msg = "You decide against a declaration."

	/// The amount of favor required to declare on someone
	var/required_favor = 150
	/// A ref to our owner's honorbound trauma
	var/datum/brain_trauma/special/honorbound/honor_trauma
	/// The declaration that's shouted in invocation. Set in New()
	var/declaration = "By the divine light of my deity, you are an evil of this world that must be wrought low!"

/datum/action/cooldown/spell/pointed/declare_evil/New()
	. = ..()
	declaration = "By the divine light of [GLOB.deity], you are an evil of this world that must be wrought low!"

/datum/action/cooldown/spell/pointed/declare_evil/Grant(mob/grant_to)
	if(!ishuman(grant_to))
		return FALSE

	var/mob/living/carbon/human/human_owner = grant_to
	var/datum/brain_trauma/special/honorbound/honorbound = human_owner.has_trauma_type(/datum/brain_trauma/special/honorbound)
	if(QDELETED(honorbound))
		return FALSE

	RegisterSignal(honorbound, COMSIG_QDELETING, PROC_REF(on_honor_trauma_lost))
	honor_trauma = honorbound
	return ..()

/datum/action/cooldown/spell/pointed/declare_evil/Remove(mob/living/remove_from)
	. = ..()
	UnregisterSignal(honor_trauma, COMSIG_QDELETING)
	honor_trauma = null

/// If we lose our honor trauma somehow, self-delete (and clear references)
/datum/action/cooldown/spell/pointed/declare_evil/proc/on_honor_trauma_lost(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/datum/action/cooldown/spell/pointed/declare_evil/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	if(!GLOB.religious_sect)
		if(feedback)
			to_chat(owner, span_warning("周围没有神明来批准你的宣告！"))
		return FALSE

	if(GLOB.religious_sect.favor < required_favor)
		if(feedback)
			to_chat(owner, span_warning("你需要至少150点恩惠才能宣告某人为邪恶！"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/declare_evil/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(cast_on))
		to_chat(owner, span_warning("你只能宣告活着的生灵为邪恶！"))
		return FALSE

	var/mob/living/living_cast_on = cast_on
	if(living_cast_on.stat == DEAD)
		to_chat(owner, span_warning("对死者宣告？认真的吗？"))
		return FALSE

	// sec and medical are immune to becoming guilty through attack
	// (we don't check holy, because holy shouldn't be able to attack eachother anyways)
	if(!living_cast_on.key || !living_cast_on.mind)
		to_chat(owner, span_warning("空洞的头脑无法行恶。"))
		return FALSE

	// also handles any kind of issues with self declarations
	if(living_cast_on.mind.holy_role)
		to_chat(owner, span_warning("[GLOB.deity] 的信徒不可能是邪恶的！"))
		return FALSE

	// cannot declare security as evil
	if(living_cast_on.mind.assigned_role.departments_bitflags & DEPARTMENT_BITFLAG_SECURITY)
		to_chat(owner, span_warning("安保部门的成员是不可腐蚀的！你不能宣告他们为邪恶！"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/declare_evil/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	invocation = "[cast_on]! [declaration]"

/datum/action/cooldown/spell/pointed/declare_evil/cast(mob/living/cast_on)
	. = ..()
	GLOB.religious_sect.adjust_favor(-required_favor, owner)
	honor_trauma.guilty(cast_on, GUILT_REASON_DECLARATION)

#undef GUILT_REASON_DECLARATION
