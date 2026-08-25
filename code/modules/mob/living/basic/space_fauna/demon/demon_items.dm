// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// The loot from killing a slaughter demon - can be consumed to allow the user to blood crawl
/obj/item/organ/heart/demon
	name = "demon heart"
	desc = "Still it beats furiously, emanating an aura of utter hate."
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "demon_heart-on"
	decay_factor = 0

/obj/item/organ/heart/demon/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/organ/heart/demon/attack(mob/target_mob, mob/living/carbon/user, obj/target)
	if(target_mob != user)
		return ..()

	user.visible_message(
		span_warning(LANG("obj.664a40e4bc1d155b", list(user, src, user.p_their(), user.p_their()))),
		span_danger(LANG("obj.8b4896420268f34e", list(src))),
	)
	playsound(user, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)

	if(locate(/datum/action/cooldown/spell/jaunt/bloodcrawl) in user.actions)
		to_chat(user, span_warning(LANG("obj.97b6dab6be296408", null)))
		qdel(src)
		return

	user.visible_message(
		span_warning(LANG("obj.62b29bd206257510", list(user))),
		span_userdanger(LANG("obj.ea9df6a6ef57b06b", null)),
	)

	user.temporarilyRemoveItemFromInventory(src, TRUE)
	src.Insert(user) //Consuming the heart literally replaces your heart with a demon heart. H A R D C O R E

/obj/item/organ/heart/demon/on_mob_insert(mob/living/carbon/heart_owner)
	. = ..()
	// Gives a non-eat-people crawl to the new owner
	var/datum/action/cooldown/spell/jaunt/bloodcrawl/crawl = new(heart_owner)
	crawl.Grant(heart_owner)

/obj/item/organ/heart/demon/on_mob_remove(mob/living/carbon/heart_owner, special = FALSE, movement_flags)
	. = ..()
	var/datum/action/cooldown/spell/jaunt/bloodcrawl/crawl = locate() in heart_owner.actions
	qdel(crawl)

/obj/item/organ/heart/demon/Stop()
	return FALSE // Always beating.

/obj/effect/decal/cleanable/blood/innards
	name = "pile of viscera"
	desc = "A repulsive pile of guts and gore."
	gender = NEUTER
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "innards"
	random_icon_states = null
