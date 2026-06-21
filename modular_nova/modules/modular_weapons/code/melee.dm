// Sabres, including the cargo variety

/obj/item/storage/belt/sheath/sabre/cargo
	name = "正宗舍施尔弯刀皮鞘"
	desc = "一个外观不错的刀鞘，广告宣称由真正的金星黑皮革制成。摸起来感觉相当像塑料，而且看起来是为英式骑兵军刀设计的。"
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	stored_blade = /obj/item/melee/sabre/cargo

/obj/item/melee/sabre
	force = 20 // Original: 15
	wound_bonus = 5 // Original: 10
	exposed_wound_bonus = 20 // Original: 25 Both down slightly, to make up for the damage buff, since it'd get a bit wacky ontop of the armor pen.

/obj/item/melee/sabre/cargo
	name = "正宗舍施尔弯刀"
	desc = "一把工艺精湛的历史人类刀剑，曾为波斯人所用，最近因金星历史重演运动而流行起来。有个小瑕疵，生产这些刀的塔吉公司误将它们认作是类似纳米传讯高层官员使用的英式骑兵军刀。至少砍起来效果一样！"
	icon_state = "sabre"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/melee.dmi'
	lefthand_file = 'modular_nova/modules/modular_weapons/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'modular_nova/modules/modular_weapons/icons/mob/inhands/weapons/swords_righthand.dmi'
	block_chance = 20
	armour_penetration = 25

// This is here so that people can't buy the Sabres and craft them into powercrepes
/datum/crafting_recipe/food/powercrepe
	blacklist = list(/obj/item/melee/sabre/cargo)

// Prevents our common weapons from being used to easily craft stunswords
// Claymore blacklists can be found in code\datums\components\crafting\melee_weapon.dm
/datum/crafting_recipe/stunswordalt
	blacklist = list(/obj/item/katana/weak/curator)

/datum/crafting_recipe/stunswordalt2
	blacklist = list(/obj/item/melee/sabre/cargo)

/obj/item/melee/baton
	/// For use with jousting. For each usable jousting tile, increase the stamina damage of the jousting hit by this much.
	var/stamina_damage_per_jousting_tile = 2

/obj/item/melee/baton/Initialize(mapload)
	. = ..()

	add_jousting_component()

/// Component adder proc for custom behavior, without needing to add more vars.
/obj/item/melee/baton/proc/add_jousting_component()
	AddComponent(/datum/component/jousting, damage_boost_per_tile = 0, knockdown_chance_per_tile = 6)

/// For jousting. Called when a joust is considered successfully done.
/obj/item/melee/baton/proc/on_successful_joust(mob/living/target, mob/user, usable_charge)
	target.apply_damage(stamina_damage_per_jousting_tile * usable_charge, STAMINA)

/obj/item/melee/baton/nunchaku
	cooldown = 2 SECONDS // Original Melee CD (0.8 sec), weapon deemed too powerful with the throwmode that makes you immune to melee and throw
