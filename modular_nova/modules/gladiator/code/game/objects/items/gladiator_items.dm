#define BERSERK_MAX_CHARGE 100
#define PROJECTILE_HIT_MULTIPLIER 1.5
#define DAMAGE_TO_CHARGE_SCALE 1
#define CHARGE_DRAINED_PER_SECOND 3
#define BERSERK_MELEE_ARMOR_ADDED 50
#define BERSERK_ATTACK_SPEED_MODIFIER 0.25

/obj/item/crusher_trophy/gladiator
	name = "灰烬骸骨"
	desc = "一套来自一位值得尊敬的战士的、覆盖着煤灰的肋骨。适合作为动能粉碎者的战利品。"
	icon_state = "demon_claws"
	color = "#808080"
	gender = PLURAL
	denied_type = /obj/item/crusher_trophy/gladiator
	bonus_value = 15

/obj/item/crusher_trophy/gladiator/effect_desc()
	return "the crusher to have a <b>[bonus_value]%</b> chance to block incoming attacks"

/obj/item/crusher_trophy/gladiator/add_to(obj/item/kinetic_crusher/incomingchance, mob/living/user)
	. = ..()
	if(.)
		incomingchance.block_chance += bonus_value

/obj/item/crusher_trophy/gladiator/remove_from(obj/item/kinetic_crusher/incomingchance, mob/living/user)
	. = ..()
	if(.)
		incomingchance.block_chance -= bonus_value

/obj/item/clothing/neck/warrior_cape
	name = "受印者披风"
	desc = "一件由那些曾直面死亡并最终获胜者所穿戴的披风。"
	icon = 'modular_nova/modules/gladiator/icons/berserk_icons.dmi'
	worn_icon = 'modular_nova/modules/gladiator/icons/berserk_suit.dmi'
	icon_state = "berk_cape"
	inhand_icon_state = "" //lul
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/neck/warrior_cape/examine()
	. = ..()
	. += span_warning("无论潮水多么汹涌，都要与之抗争。")

/obj/item/clothing/suit/hooded/berserker/gatsu
	name = "狂战士盔甲"
	desc = "一套古老的身体盔甲，注入了强大的精神磁力，能够大幅提升穿戴者的近战技能，代价是摧残其心智并使其身体过度劳累。"
	icon_state = "berk_suit"
	icon = 'modular_nova/modules/gladiator/icons/berserk_icons.dmi'
	worn_icon = 'modular_nova/modules/gladiator/icons/berserk_suit.dmi'
	worn_icon_digi = 'modular_nova/modules/gladiator/icons/berserk_suit_digi.dmi'
	hoodtype = /obj/item/clothing/head/hooded/berserker/gatsu
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/berserker_gatsu
	resistance_flags = INDESTRUCTIBLE

/datum/armor/berserker_gatsu
	melee = 40
	bullet = 40
	laser = 20
	energy = 25
	bomb = 70
	bio = 100
	fire = 100
	acid = 100

/obj/item/clothing/suit/hooded/berserker/gatsu/examine()
	. = ..()
	. += span_warning("狂怒模式需要装备盔甲的头盔，并且只能通过承受伤害来充能。")

/obj/item/clothing/head/hooded/berserker/gatsu
	name = "狂战士头盔"
	desc = "一顶风格独特的头盔，有着骇人的红色眼睛，能将使用者密封在内。"
	icon_state = "berk_helm"
	icon = 'modular_nova/modules/gladiator/icons/berserk_icons.dmi'
	worn_icon = 'modular_nova/modules/gladiator/icons/berserk_suit.dmi'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	armor_type = /datum/armor/berserker_gatsu
	resistance_flags = INDESTRUCTIBLE
	actions_types = list(/datum/action/item_action/berserk_mode)

/obj/item/clothing/head/hooded/berserker/gatsu/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)

/obj/item/clothing/head/hooded/berserker/gatsu/examine()
	. = ..()
	. += span_warning("狂怒模式在充能达到100%时可用，并且需要头盔保持关闭状态才能维持激活。") //woag!!!

/obj/item/clothing/head/hooded/berserker/gatsu/process(seconds_per_tick)
	if(berserk_active)
		berserk_charge = clamp(berserk_charge - CHARGE_DRAINED_PER_SECOND * seconds_per_tick, 0, BERSERK_MAX_CHARGE)
	if(!berserk_charge)
		if(ishuman(loc))
			end_berserk(loc)

/obj/item/clothing/head/hooded/berserker/gatsu/dropped(mob/user)
	. = ..()
	end_berserk(user)

/obj/item/clothing/head/hooded/berserker/gatsu/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(berserk_active)
		return
	var/berserk_value = damage * DAMAGE_TO_CHARGE_SCALE
	if(attack_type == PROJECTILE_ATTACK)
		berserk_value *= PROJECTILE_HIT_MULTIPLIER
	berserk_charge = clamp(round(berserk_charge + berserk_value), 0, BERSERK_MAX_CHARGE)
	if(berserk_charge >= BERSERK_MAX_CHARGE)
		balloon_alert(owner, "狂暴充能完毕")

/obj/item/clothing/head/hooded/berserker/gatsu/IsReflect()
	if(berserk_active)
		return TRUE

/obj/item/claymore/dragonslayer
	name = "\proper 斩龙剑"
	desc = "一把大到不该被称为剑的刀刃。太大、太厚、太重、太粗糙，它更像是一大块生铁。"
	icon = 'modular_nova/modules/gladiator/icons/dragonslayer.dmi'
	icon_state = "dragonslayer"
	inhand_icon_state = "dragonslayer"
	lefthand_file = 'modular_nova/master_files/icons/mob/64x64_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	hitsound = 'modular_nova/master_files/sound/weapons/bloodyslice.ogg'
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = null
	force = 20
	wound_bonus = 10
	exposed_wound_bonus = 5
	resistance_flags = INDESTRUCTIBLE
	armour_penetration = 35 //this boss is really hard and this sword is really big
	block_chance = 25
	sharpness = SHARP_EDGED
	item_flags = NO_BLOOD_ON_ITEM
	// aughhghghgh this really should be elementized but this works for now
	var/faction_bonus_force = 40
	var/static/list/nemesis_factions = list(FACTION_MINING, FACTION_BOSS)
	/// how much stamina does it cost to roll
	var/roll_stamcost = 10
	/// how far do we roll?
	var/roll_range = 3

/obj/item/claymore/dragonslayer/examine()
	. = ..()
	. += span_warning("通过超自然能量，在熔岩地敌人和首领的对抗中得到锤炼。右键点击以消耗耐力进行闪避。")

/obj/item/claymore/dragonslayer/attack(mob/living/target, mob/living/carbon/human/user)
	var/is_nemesis_faction = FALSE
	for(var/found_faction in target.get_faction())
		if(found_faction in nemesis_factions)
			is_nemesis_faction = TRUE
			force += faction_bonus_force
			break
	. = ..()
	if(is_nemesis_faction)
		force -= faction_bonus_force

/obj/item/claymore/dragonslayer/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.IsImmobilized()) // no free dodgerolls
		return NONE
	var/turf/where_to = get_turf(interacting_with)
	user.apply_damage(damage = roll_stamcost, damagetype = STAMINA)
	user.Immobilize(0.1 SECONDS) // you dont get to adjust your roll
	user.throw_at(where_to, range = roll_range, speed = 1, force = MOVE_FORCE_NORMAL)
	user.apply_status_effect(/datum/status_effect/dodgeroll_iframes)
	playsound(user, SFX_BODYFALL, 50, TRUE)
	playsound(user, SFX_RUSTLE, 50, TRUE)
	return ITEM_INTERACT_SUCCESS

/datum/status_effect/dodgeroll_iframes
	id = "dodgeroll_dodging"
	alert_type = null
	status_type = STATUS_EFFECT_REFRESH
	duration = 1 SECONDS // worth tweaking?

/datum/status_effect/dodgeroll_iframes/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(whiff))
	return TRUE

/datum/status_effect/dodgeroll_iframes/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_CHECK_BLOCK)
	return ..()

/datum/status_effect/dodgeroll_iframes/proc/whiff()
	SIGNAL_HANDLER
	owner.balloon_alert_to_viewers("MISS!")
	playsound(src, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)
	return SUCCESSFUL_BLOCK

/obj/item/claymore/dragonslayer/very_fucking_loud
	name = "\proper 锤炼斩龙剑"
	desc = null
	hitsound = 'modular_nova/modules/gladiator/Clang_cut.ogg'

/obj/item/claymore/dragonslayer/very_fucking_loud/examine()
	. = ..()
	. += span_userdanger("哐当")

/obj/structure/closet/crate/necropolis/gladiator
	name = "角斗士宝箱"

/obj/structure/closet/crate/necropolis/gladiator/crusher
	name = "可怖角斗士宝箱"

/obj/structure/closet/crate/necropolis/gladiator/PopulateContents()
	if(prob(5))
		new /obj/item/claymore/dragonslayer/very_fucking_loud(src)
	else
		new /obj/item/claymore/dragonslayer(src)
	new /obj/item/clothing/suit/hooded/berserker/gatsu(src)
	new /obj/item/clothing/neck/warrior_cape(src)

/obj/structure/closet/crate/necropolis/gladiator/crusher/PopulateContents()
	..()
	new /obj/item/crusher_trophy/gladiator(src)

#undef BERSERK_MAX_CHARGE
#undef PROJECTILE_HIT_MULTIPLIER
#undef DAMAGE_TO_CHARGE_SCALE
#undef CHARGE_DRAINED_PER_SECOND
#undef BERSERK_MELEE_ARMOR_ADDED
#undef BERSERK_ATTACK_SPEED_MODIFIER
