/*
	Changeling Mutations! ~By Miauw (ALL OF IT :V)
	Contains:
		Arm Blade
		Space Suit
		Shield
		Armor
		Tentacles
*/


//Parent to shields and blades because muh copypasted code.
/datum/action/changeling/weapon
	abstract_type = /datum/action/changeling/weapon
	name = "有机武器"
	desc = "看到这个就去告诉程序员"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = CHANGELING_POWER_UNOBTAINABLE

	var/silent = FALSE
	var/weapon_type
	var/weapon_name_simple

/datum/action/changeling/weapon/Grant(mob/granted_to)
	. = ..()
	if (!owner || !req_human)
		return
	RegisterSignal(granted_to, COMSIG_HUMAN_MONKEYIZE, PROC_REF(became_monkey))

/datum/action/changeling/weapon/Remove(mob/remove_from)
	UnregisterSignal(remove_from, COMSIG_HUMAN_MONKEYIZE)
	unequip_held(remove_from)
	return ..()

/// Remove weapons if we become a monkey
/datum/action/changeling/weapon/proc/became_monkey(mob/source)
	SIGNAL_HANDLER
	unequip_held(source)

/// Removes weapon if it exists, returns true if we removed something
/datum/action/changeling/weapon/proc/unequip_held(mob/user)
	var/found_weapon = FALSE
	for(var/obj/item/held in user.held_items)
		found_weapon = check_weapon(user, held) || found_weapon
	return found_weapon

/datum/action/changeling/weapon/try_to_sting(mob/user, mob/target)
	if (unequip_held(user))
		return
	..(user, target)

/datum/action/changeling/weapon/proc/check_weapon(mob/user, obj/item/hand_item)
	if(istype(hand_item, weapon_type))
		user.temporarilyRemoveItemFromInventory(hand_item, TRUE) //DROPDEL will delete the item
		if(!silent)
			playsound(user, 'sound/effects/blob/blobattack.ogg', 30, TRUE)
			user.visible_message(span_warning("伴随着令人作呕的碎裂声，[user]将[user.p_their()]的[weapon_name_simple]重组为手臂！"), span_notice("我们将[weapon_name_simple]重新吸收回体内。"), span_italics("你听到有机物质被撕裂的声音！"))
		user.update_held_items()
		return TRUE

/datum/action/changeling/weapon/sting_action(mob/living/carbon/user)
	var/obj/item/held = user.get_active_held_item()
	if(held && !user.dropItemToGround(held))
		user.balloon_alert(user, "手被占用了！")
		return
	if(!istype(user))
		user.balloon_alert(user, "形态不对！")
		return
	..()
	var/limb_regen = 0
	if(HAS_TRAIT_FROM_ONLY(user, TRAIT_PARALYSIS_L_ARM, CHANGELING_TRAIT) || HAS_TRAIT_FROM_ONLY(user, TRAIT_PARALYSIS_R_ARM, CHANGELING_TRAIT))
		user.balloon_alert(user, "肌肉不足！") // no cheesing repuprosed glands
		return
	if(IS_RIGHT_INDEX(user.active_hand_index)) //we regen the arm before changing it into the weapon
		limb_regen = user.regenerate_limb(BODY_ZONE_R_ARM, 1)
	else
		limb_regen = user.regenerate_limb(BODY_ZONE_L_ARM, 1)
	if(limb_regen)
		user.visible_message(span_warning("[user]缺失的手臂重新成形，发出响亮而怪诞的声音！"), span_userdanger("你的手臂重新长出，发出响亮的嘎吱声，并带来巨大的痛苦！"), span_hear("你听到有机物质被撕裂的声音！"))
		user.emote("scream")
	var/obj/item/W = new weapon_type(user, silent)
	user.put_in_hands(W)
	if(!silent)
		playsound(user, 'sound/effects/blob/blobattack.ogg', 30, TRUE)
	return W


//Parent to space suits and armor.
/datum/action/changeling/suit
	abstract_type = /datum/action/changeling/suit
	name = "有机盔甲"
	desc = "看到这个就去告诉程序员"
	helptext = "Yell at Miauw and/or Perakp"
	chemical_cost = 1000
	dna_cost = CHANGELING_POWER_UNOBTAINABLE

	var/helmet_type = null
	var/suit_type = null
	var/suit_name_simple = "    "
	var/helmet_name_simple = "     "
	var/recharge_slowdown = 0
	var/blood_on_castoff = 0

/datum/action/changeling/suit/Grant(mob/granted_to)
	. = ..()
	if (!owner || !req_human)
		return
	RegisterSignal(granted_to, COMSIG_HUMAN_MONKEYIZE, PROC_REF(became_monkey))

/datum/action/changeling/suit/Remove(mob/remove_from)
	UnregisterSignal(remove_from, COMSIG_HUMAN_MONKEYIZE)
	check_suit(remove_from)
	return ..()

/// Remove suit if we become a monkey
/datum/action/changeling/suit/proc/became_monkey()
	SIGNAL_HANDLER
	check_suit(owner)

/datum/action/changeling/suit/try_to_sting(mob/user, mob/target)
	if(check_suit(user))
		return
	var/mob/living/carbon/human/H = user
	..(H, target)

//checks if we already have an organic suit and casts it off.
/datum/action/changeling/suit/proc/check_suit(mob/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	if(!ishuman(user) || !changeling)
		return 1
	var/mob/living/carbon/human/H = user

	if(istype(H.wear_suit, suit_type) || istype(H.head, helmet_type))
		var/name_to_use = (isnull(suit_type) ? helmet_name_simple : suit_name_simple)
		H.visible_message(span_warning("[H]甩掉了[H.p_their()]的[name_to_use]！"), span_warning("我们甩掉了我们的[name_to_use]。"), span_hear("你听到有机物质被撕裂的声音！"))
		if(!isnull(helmet_type))
			H.temporarilyRemoveItemFromInventory(H.head, TRUE) //The qdel on dropped() takes care of it
		if(!isnull(suit_type))
			H.temporarilyRemoveItemFromInventory(H.wear_suit, TRUE)
		H.update_worn_oversuit()
		H.update_worn_head()
		H.update_body_parts()

		if(blood_on_castoff)
			H.add_splatter_floor()
			playsound(H.loc, 'sound/effects/splat.ogg', 50, TRUE) //So real sounds

		changeling.chem_recharge_slowdown -= recharge_slowdown
		return 1

/datum/action/changeling/suit/sting_action(mob/living/carbon/human/user)
	if(!user.canUnEquip(user.wear_suit) && !isnull(suit_type))
		user.balloon_alert(user, "身体被占用！")
		return
	if(!user.canUnEquip(user.head) && !isnull(helmet_type))
		user.balloon_alert(user, "头部被占用！")
		return
	..()
	if(!isnull(suit_type))
		user.dropItemToGround(user.wear_suit)
		user.equip_to_slot_if_possible(new suit_type(user), ITEM_SLOT_OCLOTHING, 1, 1, 1)
	if(!isnull(helmet_type))
		user.dropItemToGround(user.head)
		user.equip_to_slot_if_possible(new helmet_type(user), ITEM_SLOT_HEAD, 1, 1, 1)

	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	changeling.chem_recharge_slowdown += recharge_slowdown
	return TRUE


//fancy headers yo
/***************************************\
|***************ARM BLADE***************|
\***************************************/
/datum/action/changeling/weapon/arm_blade
	name = "臂刃"
	desc = "将我们的一只手臂转化为致命的刀刃. 使用消耗5化学点"
	helptext = "We may retract our armblade in the same manner as we form it. Cannot be used while in lesser form."
	button_icon_state = "arm_blade"
	category = "combat"
	chemical_cost = 20
	dna_cost = 2
	req_human = TRUE
	weapon_type = /obj/item/melee/arm_blade
	weapon_name_simple = "blade"

/obj/item/melee/arm_blade
	name = "臂刃"
	desc = "一把能像热刀切黄油一样轻松切碎人体的骨肉怪异刀刃"
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	icon_angle = 180
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 25
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED
	wound_bonus = 10
	exposed_wound_bonus = 10
	armour_penetration = 35
	var/can_drop = FALSE
	var/fake = FALSE
	var/list/alt_continuous = list("stabs", "pierces", "impales")
	var/list/alt_simple = list("stab", "pierce", "impale")

/obj/item/melee/arm_blade/Initialize(mapload,silent,synthetic)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc) && !silent)
		loc.visible_message(span_warning("一把怪诞的刀刃在[loc.name]的手臂周围形成！"), span_warning("我们的手臂扭曲并变异，将其转变为一柄致命的刀刃。"), span_hear("你听到有机物质被撕裂的声音！"))
	if(synthetic)
		can_drop = TRUE
	alt_continuous = string_list(alt_continuous)
	alt_simple = string_list(alt_simple)
	AddComponent(/datum/component/alternative_sharpness, SHARP_POINTY, alt_continuous, alt_simple, -5)
	AddComponent(/datum/component/butchering, \
	speed = 6 SECONDS, \
	effectiveness = 80, \
	)

/obj/item/melee/arm_blade/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(QDELETED(target))
		return
	if(istype(target, /obj/structure/table))
		var/obj/smash = target
		smash.deconstruct(FALSE)

	else if(istype(target, /obj/machinery/computer))
		target.attack_alien(user) //muh copypasta

	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/opening = target

		if((!opening.requiresID() || opening.allowed(user)) && opening.hasPower()) //This is to prevent stupid shit like hitting a door with an arm blade, the door opening because you have acces and still getting a "the airlocks motors resist our efforts to force it" message, power requirement is so this doesn't stop unpowered doors from being pried open if you have access
			return
		if(opening.locked)
			opening.balloon_alert(user, "已上锁！")
			return

		if(opening.hasPower())
			user.visible_message(span_warning("[user]将[src]卡进气闸门并开始撬开它！"), span_warning("我们开始强行打开[opening]。"), \
			span_hear("你听到金属刮擦的声音。"))
			playsound(opening, 'sound/machines/airlock/airlock_alien_prying.ogg', 100, TRUE)
			if(!do_after(user, 10 SECONDS, target = opening))
				return
		//user.say("Heeeeeeeeeerrre's Johnny!")
		user.visible_message(span_warning("[user]用[user.p_their()]的[src]强行打开了气闸门！"), span_warning("我们强行打开了[opening]。"), \
		span_hear("你听到金属刮擦的声音。"))
		opening.open(BYPASS_DOOR_CHECKS)

/obj/item/melee/arm_blade/dropped(mob/user)
	..()
	if(can_drop)
		new /obj/item/melee/synthetic_arm_blade(get_turf(user))

/***************************************\
|***********COMBAT TENTACLES*************|
\***************************************/

/datum/action/changeling/weapon/tentacle
	name = "触手"
	desc = "使我们生长出为抓捕受害者或物品而存在的触手. 使用消耗10化学点"
	helptext = "We can use it once to retrieve a distant item. If used on living creatures, the effect depends on our combat mode: \
	In our neutral stance, we will simply drag them closer; if we try to shove, we will grab whatever they're holding in their active hand instead of them; \
	In our combat stance, we will put the victim in our hold after catching them, and we will pull them in and impale them if we're also holding a sharp weapon, or have an armblade. This pierces armor. \
	Cannot be used while in lesser form."
	button_icon_state = "tentacle"
	category = "combat"
	chemical_cost = 10
	dna_cost = 2
	req_human = TRUE
	weapon_type = /obj/item/gun/magic/tentacle
	weapon_name_simple = "tentacle"
	silent = TRUE

/obj/item/gun/magic/tentacle
	name = "触手"
	desc = "一种伸展后将抓捕物品或人的血肉触手"
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "tentacle"
	inhand_icon_state = "tentacle"
	icon_angle = 180
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	antimagic_flags = NONE
	pinless = TRUE
	ammo_type = /obj/item/ammo_casing/magic/tentacle
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1 DECISECONDS
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	can_hold_up = FALSE

/obj/item/gun/magic/tentacle/Initialize(mapload, silent)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		if(!silent)
			loc.visible_message(span_warning("[loc.name]的手臂开始非人地伸长！"), span_warning("我们的手臂扭曲并变异，将其转变为一根触手。"), span_hear("你听到有机物质被撕裂的声音！"))
		else
			to_chat(loc, span_notice("你准备好伸展出一条触手。"))


/obj/item/gun/magic/tentacle/shoot_with_empty_chamber(mob/living/user as mob|obj)
	user.balloon_alert(user, "尚未就绪！")

/obj/item/gun/magic/tentacle/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	var/obj/projectile/tentacle/tentacle_shot = chambered.loaded_projectile //Gets the actual projectile we will fire
	tentacle_shot.fire_modifiers = params2list(params)
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/item/gun/magic/tentacle/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]将[src]紧紧缠绕在[user.p_their()]脖子上！看起来[user.p_theyre()]想要自杀！"))
	return OXYLOSS

/obj/item/ammo_casing/magic/tentacle
	name = "触手"
	desc = "一把触手"
	projectile_type = /obj/projectile/tentacle
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	var/obj/item/gun/magic/tentacle/gun //the item that shot it

/obj/item/ammo_casing/magic/tentacle/Initialize(mapload)
	gun = loc
	. = ..()

/obj/item/ammo_casing/magic/tentacle/Destroy()
	gun = null
	return ..()

/obj/projectile/tentacle
	name = "触手"
	icon_state = "tentacle_end"
	pass_flags = PASSTABLE
	damage = 0
	damage_type = BRUTE
	range = 8
	hitsound = 'sound/items/weapons/shove.ogg'
	var/chain
	var/obj/item/ammo_casing/magic/tentacle/source //the item that shot it
	///Click params that were used to fire the tentacle shot
	var/list/fire_modifiers

/obj/projectile/tentacle/Initialize(mapload)
	source = loc
	. = ..()

/obj/projectile/tentacle/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle", emissive = FALSE)
	..()

/obj/projectile/tentacle/proc/reset_throw(mob/living/carbon/human/user)
	if(user.throw_mode)
		user.throw_mode_off(THROW_MODE_TOGGLE) //Don't annoy the changeling if he doesn't catch the item

/obj/projectile/tentacle/proc/tentacle_grab(mob/living/carbon/human/user, mob/living/carbon/victim)
	if(!user.Adjacent(victim))
		return

	if(user.get_active_held_item() && !user.get_inactive_held_item())
		user.swap_hand()

	if(user.get_active_held_item())
		return

	victim.grabbedby(user)
	victim.grippedby(user, instant = TRUE) //instant aggro grab

	for(var/obj/item/weapon in user.held_items)
		if(weapon.get_sharpness())
			victim.visible_message(span_danger("[user]用[user.p_their()]的[weapon.name]刺穿了[victim]！"), span_userdanger("[user]用[user.p_their()]的[weapon.name]刺穿了你！"))
			victim.apply_damage(weapon.force, BRUTE, BODY_ZONE_CHEST, attacking_item = weapon)
			user.do_item_attack_animation(victim, used_item = weapon, animation_type = ATTACK_ANIMATION_PIERCE)
			user.add_blood_DNA_to_items(victim.get_blood_dna_list(), ITEM_SLOT_ICLOTHING|ITEM_SLOT_OCLOTHING)
			playsound(get_turf(user),weapon.hitsound,75,TRUE)
			return

/obj/projectile/tentacle/on_hit(atom/movable/target, blocked = 0, pierce_hit)
	if(!isliving(firer) || !ismovable(target))
		return ..()

	if(blocked >= 100)
		return BULLET_ACT_BLOCK

	var/mob/living/ling = firer
	if(isitem(target) && iscarbon(ling))
		var/obj/item/catching = target
		if(catching.anchored)
			return BULLET_ACT_BLOCK

		var/mob/living/carbon/carbon_ling = ling
		to_chat(carbon_ling, span_notice("你将[catching]拉向自己。"))
		carbon_ling.throw_mode_on(THROW_MODE_TOGGLE)
		catching.throw_at(
			target = carbon_ling,
			range = 10,
			speed = 2,
			thrower = carbon_ling,
			diagonals_first = TRUE,
			callback = CALLBACK(src, PROC_REF(reset_throw), carbon_ling),
			gentle = TRUE,
		)
		return BULLET_ACT_HIT

	. = ..()
	if(. != BULLET_ACT_HIT)
		return .
	var/mob/living/victim = target
	if(!isliving(victim) || target.anchored || victim.throwing)
		return BULLET_ACT_BLOCK

	if(!iscarbon(victim) || !ishuman(ling) || !ling.combat_mode)
		victim.visible_message(
			span_danger("[victim] is grabbed by [ling]'s [src]]!"),
			span_userdanger("\A [src] 抓住了你并将你拉向 [ling]！"),
		)
		victim.throw_at(
			target = get_step_towards(ling, victim),
			range = 8,
			speed = 2,
			thrower = ling,
			diagonals_first = TRUE,
			gentle = TRUE,
		)
		return BULLET_ACT_HIT

	if(LAZYACCESS(fire_modifiers, RIGHT_CLICK))
		var/obj/item/stealing = victim.get_active_held_item()
		if(!isnull(stealing))
			if(victim.dropItemToGround(stealing))
				victim.visible_message(
					span_danger("[stealing]被[src]从[victim]的手上扯了下来！"),
					span_userdanger("\A [src] 将 [stealing] 从你身边拉开了！"),
				)
				return on_hit(stealing) //grab the item as if you had hit it directly with the tentacle

			to_chat(ling, span_warning("你似乎无法从[victim]的手上撬下[stealing]！"))
			return BULLET_ACT_BLOCK

		to_chat(ling, span_danger("[victim]手上没有东西可以缴械！"))
		return BULLET_ACT_HIT

	if(ling.combat_mode)
		victim.visible_message(
			span_danger("[victim] 被 \a [ling] 扔向了 [src]！"),
			span_userdanger("\A [src] 抓住了你并将你扔向 [ling]！"),
		)
		victim.throw_at(
			target = get_step_towards(ling, victim),
			range  = 8,
			speed = 2,
			thrower = ling,
			diagonals_first = TRUE,
			callback = CALLBACK(src, PROC_REF(tentacle_grab), ling, victim),
			gentle = TRUE,
		)

	return BULLET_ACT_HIT

/obj/projectile/tentacle/Destroy()
	qdel(chain)
	source = null
	return ..()


/***************************************\
|****************SHIELD*****************|
\***************************************/
/datum/action/changeling/weapon/shield
	name = "有机盾"
	desc = "将我们的一只手臂转化为坚硬护盾. 使用消耗20化学点"
	helptext = "Organic tissue cannot resist damage forever; the shield will break after it is hit too much. The more genomes we absorb, the stronger it is. Cannot be used while in lesser form."
	button_icon_state = "organic_shield"
	category = "combat"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE

	weapon_type = /obj/item/shield/changeling
	weapon_name_simple = "shield"

/datum/action/changeling/weapon/shield/sting_action(mob/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user) //So we can read the absorbed_count.
	if(!changeling)
		return

	var/obj/item/shield/changeling/S = ..(user)
	S.remaining_uses = round(changeling.absorbed_count * 3)
	return TRUE

/obj/item/shield/changeling
	name = "盾状肉块"
	desc = "一大块坚固的骨肉组织. 你依然能看到护盾上由手指构成的扭曲团块"
	item_flags = ABSTRACT | DROPDEL
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "ling_shield"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	block_chance = 50
	is_bashable = FALSE

	var/remaining_uses //Set by the changeling ability.

/obj/item/shield/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		loc.visible_message(span_warning("[loc.name]的手掌末端迅速膨胀，形成了一个巨大的盾牌状肿块！"), span_warning("我们将手膨胀成一个坚固的盾牌。"), span_hear("你听到有机物质被撕裂的声音！"))

/obj/item/shield/changeling/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == OVERWHELMING_ATTACK)
		return FALSE

	if(remaining_uses < 1)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.visible_message(span_warning("伴随着令人作呕的碎裂声，[H]将[H.p_their()]的盾牌重新塑造成了一只手臂！"), span_notice("我们将盾牌同化回身体"), span_italics("你听到有机物质被撕裂的声音！"))
		qdel(src)
		return 0
	else
		remaining_uses--
		return ..()

/***************************************\
|*****************ARMOR*****************|
\***************************************/
/datum/action/changeling/suit/armor
	name = "壳质装甲"
	desc = "将我们的皮肤转化至保护我们抵御伤害的坚硬甲壳质. 使用消耗20化学点"
	helptext = "Upkeep of the armor requires a low expenditure of chemicals. The armor provides decent protection against brute force and energy weapons. Cannot be used in lesser form."
	button_icon_state = "chitinous_armor"
	category = "combat"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE
	recharge_slowdown = 0.125

	suit_type = /obj/item/clothing/suit/armor/changeling
	helmet_type = /obj/item/clothing/head/helmet/changeling
	suit_name_simple = "armor"
	helmet_name_simple = "helmet"

/obj/item/clothing/suit/armor/changeling
	name = "壳质肉块"
	desc = "一种坚硬的硬封黑甲壳质"
	icon_state = "lingarmor"
	inhand_icon_state = null
	item_flags = DROPDEL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_changeling
	flags_inv = HIDEJUMPSUIT
	cold_protection = 0
	heat_protection = 0

/datum/armor/armor_changeling
	melee = 40
	bullet = 40
	laser = 40
	energy = 50
	bomb = 10
	bio = 10
	fire = 90
	acid = 90

/obj/item/clothing/suit/armor/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc))
		loc.visible_message(span_warning("[loc.name]的肉体变黑，迅速转化为坚硬的几丁质外壳！"), span_warning("我们硬化了肉体，创造出一套护甲！"), span_hear("你听到有机物质被撕裂的声音！"))

/obj/item/clothing/head/helmet/changeling
	name = "壳质肉块"
	desc = "一种有着半透明壳质在前的坚硬硬封黑甲壳质"
	icon_state = "lingarmorhelmet"
	inhand_icon_state = null
	item_flags = DROPDEL
	armor_type = /datum/armor/helmet_changeling
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT

/datum/armor/helmet_changeling
	melee = 40
	bullet = 40
	laser = 40
	energy = 50
	bomb = 10
	bio = 10
	fire = 90
	acid = 90

/obj/item/clothing/head/helmet/changeling/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)

/datum/action/changeling/suit/hive_head
	name = "蜂巢头"
	desc = "我们在头部覆盖一层类似蜂巢的蜡质外层，可用于制造蜜蜂攻击敌人。消耗15点化学物质。"
	helptext = "While the hive head does not provide much in the ways of armor, it does allow the user to send bees out to attack targets. Reagents can poured inside the hive to cause all bees released to inject said reagents."
	button_icon_state = "hive_head"
	category = "combat"
	chemical_cost = 15
	dna_cost = 2
	req_human = FALSE
	blood_on_castoff = TRUE

	helmet_type = /obj/item/clothing/head/helmet/changeling_hivehead
	helmet_name_simple = "hive head"

/obj/item/clothing/head/helmet/changeling_hivehead
	name = "蜂巢头"
	desc = "一种覆盖头部的奇怪蜡质外层。会让你耳鸣。"
	icon_state = "hivehead"
	inhand_icon_state = null
	flash_protect = FLASH_PROTECTION_FLASH
	item_flags = DROPDEL
	armor_type = /datum/armor/changeling_hivehead
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT
	actions_types = list(/datum/action/cooldown/hivehead_spawn_minions)
	///Does this hive head hold reagents?
	var/holds_reagents = TRUE

/obj/item/clothing/head/helmet/changeling_hivehead/Initialize(mapload)
	. = ..()
	if(holds_reagents)
		create_reagents(50, REFILLABLE)

/datum/armor/changeling_hivehead
	melee = 10
	bullet = 10
	laser = 10
	energy = 10
	bio = 50

/obj/item/clothing/head/helmet/changeling_hivehead/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)

/obj/item/clothing/head/helmet/changeling_hivehead/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/organ/monster_core/regenerative_core/legion) || !holds_reagents)
		return NONE
	visible_message(span_boldwarning("当[user]将[tool]塞进[src]时，[src]开始变异。"))
	var/mob/living/carbon/wearer = loc
	playsound(wearer, 'sound/effects/blob/attackblob.ogg', 60, TRUE)
	wearer.temporarilyRemoveItemFromInventory(wearer.head, TRUE)
	wearer.equip_to_slot_if_possible(new /obj/item/clothing/head/helmet/changeling_hivehead/legion(wearer), ITEM_SLOT_HEAD, 1, 1, 1)
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

/datum/action/cooldown/hivehead_spawn_minions
	name = "释放蜜蜂"
	desc = "释放一群蜜蜂攻击所有其他生命体。"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"
	button_icon = 'icons/mob/simple/bees.dmi'
	button_icon_state = "queen_item"
	cooldown_time = 30 SECONDS
	///The mob we're going to spawn
	var/spawn_type = /mob/living/basic/bee/timed/short
	///How many are we going to spawn
	var/spawn_count = 6

/datum/action/cooldown/hivehead_spawn_minions/PreActivate(atom/target)
	if(owner.movement_type & VENTCRAWLING)
		owner.balloon_alert(owner, "此处不可用")
		return FALSE
	return ..()

/datum/action/cooldown/hivehead_spawn_minions/Activate(atom/target)
	. = ..()
	do_tell()
	var/spawns = spawn_count
	if(owner.stat >= HARD_CRIT)
		spawns = 1
	for(var/i in 1 to spawns)
		var/mob/living/basic/summoned_minion = new spawn_type(owner.drop_location())
		summoned_minion.set_allies(list("[REF(owner)]"))
		summoned_minion.set_faction(null)
		minion_additional_changes(summoned_minion)

///Our tell that we're using this ability. Usually a sound and a visible message.area
/datum/action/cooldown/hivehead_spawn_minions/proc/do_tell()
	owner.visible_message(span_warning("[owner]的头部开始嗡嗡作响，蜜蜂开始涌出！"), span_warning("我们释放了蜜蜂。"), span_hear("你听到一阵响亮的嗡嗡声！"))
	playsound(owner, 'sound/mobs/non-humanoids/bee/bee_swarm.ogg', 60, TRUE)

///Stuff we want to do to our minions. This is in its own proc so subtypes can override this behaviour.
/datum/action/cooldown/hivehead_spawn_minions/proc/minion_additional_changes(mob/living/basic/minion)
	var/mob/living/basic/bee/summoned_bee = minion
	var/mob/living/carbon/wearer = owner
	if(istype(summoned_bee) && length(wearer.head.reagents.reagent_list))
		summoned_bee.assign_reagent(pick(wearer.head.reagents.reagent_list))

/obj/item/clothing/head/helmet/changeling_hivehead/legion
	name = "军团蜂巢头"
	desc = "一种覆盖头部的奇怪骨质外壳，内部柔软。出奇地舒适。"
	icon_state = "hivehead_legion"
	actions_types = list(/datum/action/cooldown/hivehead_spawn_minions/legion)
	holds_reagents = FALSE

/datum/action/cooldown/hivehead_spawn_minions/legion
	name = "释放军团"
	desc = "释放一群军团攻击所有其他生命体。"
	button_icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	button_icon_state = "legion_head"
	cooldown_time = 15 SECONDS
	spawn_type = /mob/living/basic/mining/legion_brood
	spawn_count = 4

/datum/action/cooldown/hivehead_spawn_minions/legion/do_tell()
	owner.visible_message(span_warning("[owner]的头部开始摇晃，军团开始涌出！"), span_warning("我们释放军团。"), span_hear("你听到一阵响亮的挤压声！"))
	playsound(owner, 'sound/effects/blob/attackblob.ogg', 60, TRUE)

/datum/action/cooldown/hivehead_spawn_minions/legion/minion_additional_changes(mob/living/basic/minion)
	var/mob/living/basic/mining/legion_brood/brood = minion
	if (istype(brood))
		brood.assign_creator(owner, FALSE)
