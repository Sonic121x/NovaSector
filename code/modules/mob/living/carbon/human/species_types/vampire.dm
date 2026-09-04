// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

///how many vampires exist in each house
#define VAMPIRES_PER_HOUSE 5
///maximum a vampire will drain, they will drain less if they hit their cap
#define VAMP_DRAIN_AMOUNT 50

/datum/species/human/vampire
	name = "Vampire"
	id = SPECIES_VAMPIRE
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_BLOOD_CLANS,
		TRAIT_USES_SKINTONES,
		TRAIT_NO_MIRROR_REFLECTION,
		TRAIT_UNHOLY_BANEABLE, //still baned by silver even if they get a different heart
	)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN | MIRROR_PRIDE | WABBAJACK | ERT_SPAWN
	exotic_bloodtype = /datum/blood_type/universal/vampire
	blood_deficiency_drain_rate = BLOOD_DEFICIENCY_MODIFIER // vampires already passively lose blood, so this just makes them lose it slightly more quickly when they have blood deficiency.
	mutant_organs = list(
		/obj/item/organ/fangs/vampire,
	)
	mutantheart = /obj/item/organ/heart/vampire
	///some starter text sent to the vampire initially, because vampires have shit to do to stay alive
	var/info_text = "You are a <span class='danger'>Vampire</span>. You will slowly but constantly lose blood if outside of a coffin. If inside a coffin, you will slowly heal. You may gain more blood by grabbing a live victim and using your drain ability."

/datum/species/human/vampire/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/human/vampire/on_species_gain(mob/living/carbon/human/new_vampire, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	to_chat(new_vampire, "[info_text]")
	new_vampire.skin_tone = "albino"
	RegisterSignal(new_vampire, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))
	RegisterSignal(new_vampire, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	if(new_vampire.hud_used)
		on_hud_created(new_vampire)

/datum/species/human/vampire/on_species_loss(mob/living/carbon/human/old_vampire, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(old_vampire, list(
		COMSIG_MOB_HUD_CREATED,
		COMSIG_LIVING_LIFE,
	))
	old_vampire.hud_used?.remove_screen_object(HUD_MOB_BLOOD_LEVEL)

/datum/species/human/vampire/proc/on_life(mob/living/carbon/human/vampire, seconds_per_tick)
	SIGNAL_HANDLER
	if(istype(vampire.loc, /obj/structure/closet/crate/coffin))
		var/need_mob_update = FALSE
		need_mob_update += vampire.heal_overall_damage(brute = 2 * seconds_per_tick, burn = 2 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
		need_mob_update += vampire.adjust_tox_loss(-2 * seconds_per_tick, updating_health = FALSE,)
		need_mob_update += vampire.adjust_oxy_loss(-2 * seconds_per_tick, updating_health = FALSE,)
		if(need_mob_update)
			vampire.updatehealth()
		return
	vampire.adjust_blood_volume(-0.125 * seconds_per_tick)
	if(vampire.get_blood_volume(apply_modifiers = TRUE) <= BLOOD_VOLUME_SURVIVE)
		to_chat(vampire, span_danger(LANG("datum.f729390ec2a338c2", null)))
		vampire.investigate_log("has been dusted by a lack of blood (vampire).", INVESTIGATE_DEATHS)
		vampire.dust()
	var/area/A = get_area(vampire)
	if(istype(A, /area/station/service/chapel))
		to_chat(vampire, span_warning(LANG("datum.07655515379ca85d", null)))
		vampire.adjust_fire_loss(10 * seconds_per_tick)
		vampire.adjust_fire_stacks(3 * seconds_per_tick)
		vampire.ignite_mob()

///Gives the blood HUD to the vampire so they always know how much blood they have.
/datum/species/human/vampire/proc/on_hud_created(mob/source)
	SIGNAL_HANDLER
	source.hud_used.add_screen_object(/atom/movable/screen/blood_level, HUD_MOB_BLOOD_LEVEL, HUD_GROUP_INFO, update_screen = TRUE)

/datum/species/human/vampire/get_physical_attributes()
	return "Vampires are afflicted with the Thirst, needing to sate it by draining the blood out of another living creature. However, they do not need to breathe or eat normally. \
		They will instantly turn into dust if they run out of blood or enter a holy area. However, coffins stabilize and heal them, and they can transform into bats!"

/datum/species/human/vampire/get_species_description()
	return "A classy Vampire! They descend upon Space Station Thirteen Every year to spook the crew! \"Bleeg!!\""

/datum/species/human/vampire/get_species_lore()
	return list(
		"Vampires are unholy beings blessed and cursed with The Thirst. \
		The Thirst requires them to feast on blood to stay alive, and in return it gives them many bonuses. \
		Because of this, Vampires have split into two clans, one that embraces their powers as a blessing and one that rejects it.",
	)

/datum/species/human/vampire/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bed",
			SPECIES_PERK_NAME = LANG("datum.1bd5f5caf1fd2561", null),
			SPECIES_PERK_DESC = LANG("datum.67e9a75ce3b8f88c", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "book-dead",
			SPECIES_PERK_NAME = LANG("datum.56d58c346f626eb6", null),
			SPECIES_PERK_DESC = LANG("datum.520efad578cb8aed", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "cross",
			SPECIES_PERK_NAME = LANG("datum.3fbf28cc94f8f69c", null),
			SPECIES_PERK_DESC = LANG("datum.60563dde98e23e4d", null),
		),
	)

	return to_add

// Vampire blood is special, so it needs to be handled with its own entry.
/datum/species/human/vampire/create_pref_blood_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "tint",
		SPECIES_PERK_NAME = LANG("datum.046e1fdfb0274006", null),
		SPECIES_PERK_DESC = LANG("datum.83bda28c507968b1", null),
	))

	return to_add

// There isn't a "Minor Undead" biotype, so we have to explain it in an override (see: dullahans)
/datum/species/human/vampire/create_pref_biotypes_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "skull",
		SPECIES_PERK_NAME = LANG("datum.e00d4a39bfe0dc7b", null),
		SPECIES_PERK_DESC = LANG("datum.ea0f02c18fdab51a", list(name)),
	))

	return to_add

/obj/item/organ/fangs/vampire
	name = "vampire fangs"
	desc = "The only thing with which it's acceptable to say \"I will suck you dry!\""
	icon_state = "fangs_vampire"
	actions_types = list(/datum/action/item_action/organ_action/vampire)
	organ_traits = list(
		TRAIT_DRINKS_BLOOD,
		// future todo : tie nobreath and nohunger to a vampire organ set bonus
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_REFINED_BITER,
	)
	COOLDOWN_DECLARE(drain_cooldown)

/obj/item/organ/fangs/vampire/on_mob_insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	RegisterSignal(receiver, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(stab_bloodbag))

/obj/item/organ/fangs/vampire/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_ATOM_ITEM_INTERACTION)

/obj/item/organ/fangs/vampire/proc/stab_bloodbag(mob/living/source, mob/living/user,  obj/item/used_item, list/modifiers)
	SIGNAL_HANDLER

	if(user != source)
		return NONE
	if(!istype(used_item, /obj/item/reagent_containers/blood))
		return NONE
	if(used_item.reagents?.total_volume <= 0)
		to_chat(user, span_warning(LANG("obj.02d482cc1aef0cef", list(src))))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(
		span_notice(LANG("obj.f479ad5198958a92", list(user, used_item, user.p_their()))),
		span_notice(LANG("obj.b4570b27d5e0162b", list(used_item))),
		span_hear(LANG("obj.1e0e197e9a76a0df", null)),
		COMBAT_MESSAGE_RANGE,
	)
	INVOKE_ASYNC(src, PROC_REF(async_stab_bloodbag), user, used_item)
	return ITEM_INTERACT_BLOCKING

/obj/item/organ/fangs/vampire/proc/async_stab_bloodbag(mob/living/carbon/user, obj/item/reagent_containers/blood/bloodbag, time = 0.5 SECONDS)
	if(!do_after(user, time, bloodbag))
		return

	to_chat(user, span_notice(LANG("obj.d015814857f16b4e", list(src))))
	playsound(bloodbag, 'sound/items/drink.ogg', 50, TRUE) //slurp
	bloodbag.reagents.trans_to(user, bloodbag.reagents.maximum_volume * 0.05, transferred_by = user, methods = INGEST)
	if(bloodbag.reagents.total_volume > 0)
		async_stab_bloodbag(user, bloodbag, 1 SECONDS)

/datum/action/item_action/organ_action/vampire
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "drain_victim"
	background_icon_state = "bg_vampire"

/datum/action/item_action/organ_action/vampire/do_effect(trigger_flags)
	if(!iscarbon(owner))
		return FALSE

	var/mob/living/carbon/user = owner
	var/obj/item/organ/fangs/vampire/fang_drinker = target
	if(!COOLDOWN_FINISHED(fang_drinker, drain_cooldown))
		to_chat(user, span_warning(LANG("datum.5dcd793ce96c6e87", null)))
		return FALSE

	if(!iscarbon(user.pulling))
		return FALSE

	var/mob/living/carbon/victim = user.pulling
	if(user.get_blood_volume() >= BLOOD_VOLUME_MAXIMUM)
		to_chat(user, span_warning(LANG("datum.3aec2368918f2046", null)))
		return FALSE
	if(victim.stat == DEAD)
		to_chat(user, span_warning(LANG("datum.cbeaa122734af69c", null)))
		return FALSE
	var/blood_name = LOWER_TEXT(user.get_bloodtype()?.get_blood_name())
	if(!victim.get_blood_volume() || victim.get_blood_reagent() != user.get_blood_reagent())
		if (blood_name)
			to_chat(user, span_warning(LANG("datum.509e4326629bc862", list(victim, blood_name))))
		else
			to_chat(user, span_warning(LANG("datum.f731b50267022f1b", list(victim))))
		return FALSE
	COOLDOWN_START(fang_drinker, drain_cooldown, 3 SECONDS)
	if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 0))
		victim.show_message(span_warning("[user] tries to bite you, but stops before touching you!"))
		to_chat(user, span_warning(LANG("datum.135f1a2f23cab109", list(victim))))
		return FALSE
	if(victim.has_reagent(/datum/reagent/consumable/garlic))
		victim.show_message(span_warning("[user] tries to bite you, but recoils in disgust!"))
		to_chat(user, span_warning(LANG("datum.bd4a7b9283eb1fd2", list(victim))))
		return FALSE
	if(!do_after(user, 3 SECONDS, target = victim, cog_icon = null))
		return FALSE

	victim.show_message(span_danger("[user] is draining your blood!"))
	to_chat(user, span_notice(LANG("datum.4bcde6418dd39359", null)))
	playsound(user, 'sound/items/drink.ogg', 30, TRUE, -2)

	// Since we adjust the user first, we need to take the victim's blood volume into account.
	var/amount_drained = min(VAMP_DRAIN_AMOUNT, victim.get_blood_volume())

	// Takes into account how much blood the vampire can take.
	amount_drained = user.adjust_blood_volume(amount_drained)

	victim.adjust_blood_volume(-amount_drained)

	if(!victim.get_blood_volume())
		to_chat(user, span_notice(LANG("datum.2165913a024dc546", list(victim, blood_name))))
	return TRUE

/obj/item/organ/heart/vampire
	name = "vampire heart"
	icon_state = "heart_vampire"
	desc = "Some guy stabbed his brother 6,000 years ago so now you have this."
	organ_traits = list(TRAIT_UNHOLY_BANEABLE)

#undef VAMPIRES_PER_HOUSE
#undef VAMP_DRAIN_AMOUNT
