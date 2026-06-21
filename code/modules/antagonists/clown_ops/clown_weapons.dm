/obj/item/reagent_containers/spray/waterflower/lube
	name = "水花"
	desc = "一朵看似无害的向日葵……却带有一点变化。一个<i>滑溜溜的</i>变化。"
	icon = 'icons/obj/service/hydroponics/harvest.dmi'
	icon_state = "sunflower"
	inhand_icon_state = "sunflower"
	amount_per_transfer_from_this = 3
	spray_range = 1
	stream_range = 1
	volume = 30
	list_reagents = list(/datum/reagent/lube = 30)

//BANANIUM SWORD

/obj/item/melee/energy/sword/bananium
	name = "蕉矿剑"
	icon_state = "e_sword"
	attack_verb_continuous = list("hits", "taps", "pokes")
	attack_verb_simple = list("hit", "tap", "poke")
	force = 0
	throwforce = 0
	hitsound = null
	embed_type = null
	light_color = COLOR_YELLOW
	sword_color_icon = "bananium"
	active_heat = 0
	/// Cooldown for making a trombone noise for failing to make a bananium desword
	COOLDOWN_DECLARE(next_trombone_allowed)

/obj/item/melee/energy/sword/bananium/make_transformable()
	AddComponent( \
		/datum/component/transforming, \
		throw_speed_on = 4, \
		attack_verb_continuous_on = list("slips"), \
		attack_verb_simple_on = list("slip"), \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/energy/sword/bananium/on_transform(obj/item/source, mob/user, active)
	. = ..()
	adjust_slipperiness()

/*
 * Adds or removes a slippery component, depending on whether the sword is active or not.
 */
/obj/item/melee/energy/sword/bananium/proc/adjust_slipperiness()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		AddComponent(/datum/component/slippery, 60, GALOSHES_DONT_HELP)
	else
		qdel(GetComponent(/datum/component/slippery))

/obj/item/melee/energy/sword/bananium/attack(mob/living/M, mob/living/user)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
		slipper.Slip(src, M)

/obj/item/melee/energy/sword/bananium/throw_impact(atom/hit_atom, throwingdatum)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
		slipper.Slip(src, hit_atom)

/obj/item/melee/energy/sword/bananium/attackby(obj/item/weapon, mob/living/user, list/modifiers, list/attack_modifiers)
	if(COOLDOWN_FINISHED(src, next_trombone_allowed) && istype(weapon, /obj/item/melee/energy/sword/bananium))
		COOLDOWN_START(src, next_trombone_allowed, 5 SECONDS)
		to_chat(user, span_warning("你将两把剑拍在一起。可惜，它们似乎无法组合！"))
		playsound(src, 'sound/misc/sadtrombone.ogg', 50)
		return TRUE
	return ..()

/obj/item/melee/energy/sword/bananium/suicide_act(mob/living/user)
	if(!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		attack_self(user)
	user.visible_message(span_suicide("[user]正在[pick("slitting [user.p_their()] stomach open with", "falling on")][src]！看起来[user.p_theyre()]试图切腹自尽，但刀刃从[user.p_them()]身上无害地滑开了！"))
	var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
	slipper.Slip(src, user)
	return SHAME

//BANANIUM SHIELD

/obj/item/shield/energy/bananium
	name = "蕉矿光盾"
	desc = "一个可以挡住大部分近战攻击的盾牌，能保护使用者免受几乎所有能量投射物的伤害，并且可以投掷以滑倒对手。"
	icon_state = "bananaeshield"
	inhand_icon_state = "bananaeshield"
	throw_speed = 1
	force = 0
	throwforce = 0
	throw_range = 5

	active_force = 0
	active_throwforce = 0
	active_throw_speed = 1
	can_clumsy_use = TRUE

/obj/item/shield/energy/bananium/on_transform(obj/item/source, mob/user, active)
	. = ..()
	adjust_comedy()

/*
 * Adds or removes a slippery and boomerang component, depending on whether the shield is active or not.
 */
/obj/item/shield/energy/bananium/proc/adjust_comedy()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		AddComponent(/datum/component/slippery, 60, GALOSHES_DONT_HELP)
		AddComponent(/datum/component/boomerang, throw_range+2, TRUE)
	else
		qdel(GetComponent(/datum/component/slippery))
		qdel(GetComponent(/datum/component/boomerang))

/obj/item/shield/energy/bananium/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
		if(iscarbon(hit_atom) && !caught)//if they are a carbon and they didn't catch it
			var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
			slipper.Slip(src, hit_atom)
	else
		return ..()


//BOMBANANA

/obj/item/seeds/banana/bombanana
	name = "炸弹香蕉种子包"
	desc = "它们是可以长成爆炸香蕉树的种子。种好后，请交给小丑。"
	plantname = "Bombanana Tree"
	product = /obj/item/food/grown/banana/bombanana

/obj/item/food/grown/banana/bombanana
	trash_type = /obj/item/grown/bananapeel/bombanana
	seed = /obj/item/seeds/banana/bombanana
	tastes = list("explosives" = 10)
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)

/obj/item/food/grown/banana/bombanana/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_FOOD_CONSUMED, PROC_REF(on_consumed))

/// Log whenever someone eats this with an explicit message since it willspawn a live bomb.
/obj/item/food/grown/banana/bombanana/proc/on_consumed(datum/source, mob/living/eater, mob/feeder)
	SIGNAL_HANDLER
	var/list/concatable = list("[key_name_and_tag(eater)] has eaten a bombanana!")
	if(feeder != eater)
		concatable += "This person was fed this by [key_name_and_tag(feeder)]."

	concatable += "As a result of this, a bombanana peel will be spawned at [AREACOORD(src)]."

	var/final_string = jointext(concatable, " ")
	log_bomber(details = final_string) // sorta wacks out the traditional "log_bomber" format but it gets the point across better
	return NONE

/obj/item/grown/bananapeel/bombanana
	desc = parent_type::desc + "为什么它在哔哔响？"
	seed = /obj/item/seeds/banana/bombanana
	/// How long we have until we explode.
	var/det_time = 5 SECONDS
	/// Ref to the bomb we spawn when we explode.
	var/obj/item/grenade/syndieminibomb/bomb

/obj/item/grown/bananapeel/bombanana/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, det_time)
	bomb = new /obj/item/grenade/syndieminibomb(src)
	bomb.name = "炸弹香蕉皮"
	bomb.det_time = det_time

	var/potential_user = null
	if(iscarbon(loc))
		to_chat(loc, span_danger("[src]开始发出哔哔声。"))
		potential_user = loc // just for fingerprint diagnosis in explosion logging, the on_consumed proc will have provided the necessary context already

	bomb.arm_grenade(potential_user, msg = FALSE)

/obj/item/grown/bananapeel/bombanana/Destroy()
	. = ..()
	QDEL_NULL(bomb)

/obj/item/grown/bananapeel/bombanana/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 故意踩上了 \the [src]！看起来 \he 想自杀。"))
	playsound(loc, 'sound/misc/slip.ogg', 50, TRUE, -1)
	bomb.arm_grenade(user, 0, FALSE)
	return BRUTELOSS

//TEARSTACHE GRENADE

/obj/item/grenade/chem_grenade/teargas/moustache
	name = "催泪胡子手榴弹"
	desc = "一颗衣着华丽的催泪手榴弹。"
	icon_state = "moustacheg"
	clumsy_check = GRENADE_NONCLUMSY_FUMBLE

/obj/item/grenade/chem_grenade/teargas/moustache/detonate(mob/living/lanced_by)
	var/myloc = get_turf(src)
	. = ..()
	if(!.)
		return

	for(var/mob/living/carbon/M in view(6, myloc))
		if(!istype(M.wear_mask, /obj/item/clothing/mask/gas/clown_hat) && !istype(M.wear_mask, /obj/item/clothing/mask/gas/mime) )
			if(!M.wear_mask || M.dropItemToGround(M.wear_mask))
				var/obj/item/clothing/mask/fakemoustache/sticky/the_stash = new /obj/item/clothing/mask/fakemoustache/sticky()
				M.equip_to_slot_or_del(the_stash, ITEM_SLOT_MASK, TRUE, TRUE, TRUE, TRUE)

/obj/item/clothing/mask/fakemoustache/sticky
	var/unstick_time = 600

/obj/item/clothing/mask/fakemoustache/sticky/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_MOUSTACHE_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(unstick)), unstick_time)

/obj/item/clothing/mask/fakemoustache/sticky/proc/unstick()
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_MOUSTACHE_TRAIT)
