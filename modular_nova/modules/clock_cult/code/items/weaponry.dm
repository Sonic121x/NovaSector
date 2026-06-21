#define HAMMER_FLING_DISTANCE 2
#define HAMMER_THROW_FLING_DISTANCE 3
#define BRASS_RIFLE_REDUCED_DELAY 0.25 SECONDS

/obj/item/clockwork/weapon
	name = "发条武器"
	desc = "某物"
	icon = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_weapons.dmi'
	lefthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_lefthand.dmi'
	righthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_righthand.dmi'
	worn_icon = 'modular_nova/modules/clock_cult/icons/clockwork_garb_worn.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 20
	throw_speed = 4
	armour_penetration = 10
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "pokes", "jabs", "tears", "gores")
	attack_verb_simple = list("attack", "poke", "jab", "tear", "gore")
	sharpness = SHARP_EDGED
	/// Typecache of valid turfs to have the weapon's special effect on
	var/static/list/effect_turf_typecache = typecacheof(list(/turf/open/floor/bronze))

/obj/item/clockwork/weapon/attack(mob/living/target, mob/living/user)
	. = ..()
	var/turf/gotten_turf = get_turf(user)

	if(!is_type_in_typecache(gotten_turf, effect_turf_typecache))
		return

	if(!QDELETED(target) && target.stat != DEAD && !IS_CLOCK(target) && !target.can_block_magic(MAGIC_RESISTANCE_HOLY))
		hit_effect(target, user)

/obj/item/clockwork/weapon/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return

	if(!isliving(hit_atom))
		return

	var/mob/living/target = hit_atom

	if(!target.can_block_magic(MAGIC_RESISTANCE_HOLY) && !IS_CLOCK(target))
		hit_effect(target, throwingdatum.thrower, TRUE)

/// What occurs to non-holy people when attacked from brass tiles
/obj/item/clockwork/weapon/proc/hit_effect(mob/living/target, mob/living/user, thrown = FALSE)
	return

/obj/item/clockwork/weapon/brass_spear
	name = "黄铜长矛"
	desc = "一把由黄铜制成的锋利长矛。它因蕴含几乎无法抑制的能量而微微震颤。"
	icon_state = "ratvarian_spear"
	embed_type = /datum/embedding/spear/brass
	throwforce = 36
	force = 25
	armour_penetration = 24

/datum/embedding/spear/brass
	impact_pain_mult = parent_type::impact_pain_mult + 8
	remove_pain_mult = parent_type::remove_pain_mult + 8

/obj/item/clockwork/weapon/brass_battlehammer
	name = "黄铜战锤"
	desc = "一把散发着能量光芒的黄铜锤。"
	base_icon_state = "ratvarian_hammer"
	icon_state = "ratvarian_hammer0"
	throwforce = 25
	armour_penetration = 6
	attack_verb_simple = list("bash", "hammer", "attack", "smash")
	attack_verb_continuous = list("bashes", "hammers", "attacks", "smashes")
	clockwork_desc = "Enemies hit by this will be flung back while you are on bronze tiles."
	sharpness = 0
	hitsound = 'sound/items/weapons/smash.ogg'

/obj/item/clockwork/weapon/brass_battlehammer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_unwielded = 15, \
		icon_wielded = "[base_icon_state]1", \
		force_wielded = 28, \
	)

/obj/item/clockwork/weapon/brass_battlehammer/hit_effect(mob/living/target, mob/living/user, thrown = FALSE)
	if(!thrown && !HAS_TRAIT(src, TRAIT_WIELDED))
		return

	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, thrown ? HAMMER_THROW_FLING_DISTANCE : HAMMER_FLING_DISTANCE, 4)

/obj/item/clockwork/weapon/brass_battlehammer/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/clockwork/weapon/brass_sword
	name = "黄铜长剑"
	desc = "一把由黄铜制成的大剑。"
	icon_state = "ratvarian_sword"
	force = 26
	throwforce = 20
	armour_penetration = 12
	attack_verb_simple = list("attack", "slash", "cut", "tear", "gore")
	attack_verb_continuous = list("attacks", "slashes", "cuts", "tears", "gores")
	clockwork_desc = "Enemies and mechs will be struck with a powerful electromagnetic pulse while you are on bronze tiles, with a cooldown."
	COOLDOWN_DECLARE(emp_cooldown)

/obj/item/clockwork/weapon/brass_sword/hit_effect(mob/living/target, mob/living/user, thrown)
	if(!COOLDOWN_FINISHED(src, emp_cooldown))
		return

	COOLDOWN_START(src, emp_cooldown, 30 SECONDS)

	target.emp_act(EMP_LIGHT)
	new /obj/effect/temp_visual/emp/pulse(target.loc)
	addtimer(CALLBACK(src, PROC_REF(send_message), user), 30 SECONDS)
	to_chat(user, span_brass("你用电磁脉冲击中了[target]！"))
	playsound(user, 'sound/effects/magic/lightningshock.ogg', 40)

/obj/item/clockwork/weapon/brass_sword/attack_atom(obj/attacked_obj, mob/living/user, params)
	. = ..()
	var/turf/gotten_turf = get_turf(user)

	if(!ismecha(attacked_obj) || !is_type_in_typecache(gotten_turf, effect_turf_typecache))
		return

	if(!COOLDOWN_FINISHED(src, emp_cooldown))
		return

	COOLDOWN_START(src, emp_cooldown, 20 SECONDS)

	var/obj/vehicle/sealed/mecha/target = attacked_obj
	target.emp_act(EMP_HEAVY)
	new /obj/effect/temp_visual/emp/pulse(target.loc)
	addtimer(CALLBACK(src, PROC_REF(send_message), user), 20 SECONDS)
	to_chat(user, span_brass("你用电磁脉冲击中了[target]！"))
	playsound(user, 'sound/effects/magic/lightningshock.ogg', 40)

/obj/item/clockwork/weapon/brass_sword/proc/send_message(mob/living/target)
	to_chat(target, span_brass("[src]发出光芒，预示着下一次攻击将扰乱目标的电子设备。"))


/obj/item/gun/ballistic/bow/clockwork
	name = "黄铜弓"
	desc = "一把由黄铜和其他你无法完全理解的部件制成的弓。它散发着深邃的能量光芒，并能自行制造箭矢。"
	icon = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_weapons.dmi'
	lefthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_lefthand.dmi'
	righthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_righthand.dmi'
	icon_state = "bow_clockwork_unchambered_undrawn"
	inhand_icon_state = "clockwork_bow"
	base_icon_state = "bow_clockwork"
	force = 10
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/bow/clockwork
	/// Time between bolt recharges
	var/recharge_time = 1.5 SECONDS
	/// Typecache of valid turfs to have the weapon's special effect on
	var/static/list/effect_turf_typecache = typecacheof(list(/turf/open/floor/bronze))

/obj/item/gun/ballistic/bow/clockwork/Initialize(mapload)
	. = ..()
	update_icon_state()
	AddElement(/datum/element/clockwork_description, "Firing from brass tiles will halve the time that it takes to recharge a bolt.")
	AddElement(/datum/element/clockwork_pickup)

/obj/item/gun/ballistic/bow/clockwork/try_fire_gun(atom/target, mob/living/user, params)
	if(!drawn || !chambered)
		to_chat(user, span_notice("[src]必须拉满弓弦才能发射！"))
		return FALSE
	return ..()

/obj/item/gun/ballistic/bow/clockwork/shoot_live_shot(mob/living/user, pointblank, atom/pbtarget, message)
	. = ..()
	var/turf/user_turf = get_turf(user)

	if(is_type_in_typecache(user_turf, effect_turf_typecache))
		recharge_time = 0.75 SECONDS

	addtimer(CALLBACK(src, PROC_REF(recharge_bolt)), recharge_time)
	recharge_time = initial(recharge_time)

/obj/item/gun/ballistic/bow/clockwork/attack_self(mob/living/user)
	if(drawn || !chambered)
		return

	if(!do_after(user, 0.5 SECONDS, src))
		return

	to_chat(user, span_notice("你拉满了弓弦。"))
	drawn = TRUE
	playsound(src, 'modular_nova/modules/tribal_extended/sound/sound_weapons_bowdraw.ogg', 75, 0) //gets way too high pitched if the freq varies
	update_icon()

/// Recharges a bolt, done after the delay in shoot_live_shot
/obj/item/gun/ballistic/bow/clockwork/proc/recharge_bolt()
	var/obj/item/ammo_casing/arrow/clockbolt/bolt = new
	magazine.give_round(bolt)
	chambered = bolt
	update_icon()

/obj/item/gun/ballistic/bow/clockwork/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	return

/obj/item/gun/ballistic/bow/clockwork/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[chambered ? "chambered" : "unchambered"]_[drawn ? "drawn" : "undrawn"]"

/obj/item/ammo_box/magazine/internal/bow/clockwork
	ammo_type = /obj/item/ammo_casing/arrow/clockbolt
	start_empty = FALSE

/obj/item/ammo_casing/arrow/clockbolt
	name = "能量箭矢"
	desc = "一支由奇异能量构成的箭矢。"
	icon = 'modular_nova/modules/clock_cult/icons/weapons/ammo.dmi'
	icon_state = "arrow_redlight"
	projectile_type = /obj/projectile/energy/clockbolt

/obj/projectile/energy/clockbolt
	name = "能量箭矢"
	icon = 'modular_nova/modules/clock_cult/icons/projectiles.dmi'
	icon_state = "arrow_energy"
	damage = 35
	damage_type = BURN

/obj/item/gun/ballistic/rifle/lionhunter/clockwork
	name = "黄铜步枪"
	desc = "一把精心制作的古董黄铜步枪。顶部装有一个齿轮形状的华丽瞄准镜。"
	icon = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_weapons_40x32.dmi'
	lefthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_lefthand.dmi'
	righthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_righthand.dmi'
	worn_icon = 'modular_nova/modules/clock_cult/icons/clockwork_garb_worn.dmi'
	slot_flags = ITEM_SLOT_BACK
	icon_state = "clockwork_rifle"
	inhand_icon_state = "clockwork_rifle"
	worn_icon_state = "clockwork_rifle"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/lionhunter/clockwork
	fire_sound = 'sound/items/weapons/gun/sniper/shot.ogg'
	show_bolt_icon = FALSE

/obj/item/gun/ballistic/rifle/lionhunter/clockwork/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clockwork_description, "The speed of which you aim at far targets while standing on brass will be massively increased.")
	AddElement(/datum/element/clockwork_pickup)

/obj/item/ammo_box/magazine/internal/boltaction/lionhunter/clockwork
	name = "黄铜步枪内置弹匣"
	ammo_type = /obj/item/ammo_casing/strilka310/lionhunter/clock

/obj/item/ammo_casing/strilka310/lionhunter/clock
	name = "黄铜步枪弹"
	projectile_type = /obj/projectile/bullet/strilka310/lionhunter/clock
	min_distance = 3

/obj/item/ammo_casing/strilka310/lionhunter/clock/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from)
	var/obj/item/gun/ballistic/fired_gun = fired_from

	if(istype(get_turf(user), /turf/open/floor/bronze) && istype(fired_gun, /obj/item/gun/ballistic/rifle/lionhunter/clockwork))
		seconds_per_distance = BRASS_RIFLE_REDUCED_DELAY

	return ..()

/obj/projectile/bullet/strilka310/lionhunter/clock
	name = "黄铜 .310 子弹"
	// These stats are only applied if the weapon is fired fully aimed
	// If fired without aiming or at someone too close, it will do much less
	damage = 45
	stamina = 45

/obj/item/ammo_box/speedloader/strilka310/lionhunter/clock
	name = "桥夹（.310 黄铜弹）"
	desc = "一个和它容纳的子弹一样黄铜的桥夹。"
	icon = 'modular_nova/modules/clock_cult/icons/weapons/ammo.dmi'
	icon_state = "762_brass"
	ammo_type = /obj/item/ammo_casing/strilka310/lionhunter/clock
	max_ammo = 3
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/storage/pouch/ammo/clock

/obj/item/storage/pouch/ammo/clock/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/speedloader/strilka310/lionhunter/clock = 3
	)

	generate_items_inside(items_inside, src)

#undef HAMMER_FLING_DISTANCE
#undef HAMMER_THROW_FLING_DISTANCE
#undef BRASS_RIFLE_REDUCED_DELAY
