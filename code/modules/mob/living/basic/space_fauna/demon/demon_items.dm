/// The loot from killing a slaughter demon - can be consumed to allow the user to blood crawl
/obj/item/organ/heart/demon
	name = "恶魔心脏"
	desc = "它仍在剧烈跳动，散发着彻底的憎恨气息。"
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
		span_warning("[user]将[src]举到[user.p_their()]嘴边，用[user.p_their()]的牙齿撕咬它！"),
		span_danger("一股非自然的饥饿感吞噬了你。你将[src]举到嘴边并吞食了它！"),
	)
	playsound(user, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)

	if(locate(/datum/action/cooldown/spell/jaunt/bloodcrawl) in user.actions)
		to_chat(user, span_warning("...而你并没有感到任何不同。"))
		qdel(src)
		return

	user.visible_message(
		span_warning("[user]的双眼迸发出深红色的光芒！"),
		span_userdanger("你感到一股奇异的力量渗入你的身体……你已吸收了恶魔的血行能力！"),
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
	name = "一堆内脏"
	desc = "一堆令人作呕的肠子和血块。"
	gender = NEUTER
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "innards"
	random_icon_states = null
