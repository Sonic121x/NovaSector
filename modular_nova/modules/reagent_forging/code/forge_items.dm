GLOBAL_LIST_INIT(allowed_forging_materials, list(
	/datum/material/iron,
	/datum/material/silver,
	/datum/material/gold,
	/datum/material/uranium,
	/datum/material/bananium,
	/datum/material/titanium,
	/datum/material/runite,
	/datum/material/adamantine,
	/datum/material/mythril,
	/datum/material/metalhydrogen,
	/datum/material/runedmetal,
	/datum/material/bronze,
	/datum/material/hauntium,
	/datum/material/alloy/plasteel,
	/datum/material/alloy/plastitanium,
	/datum/material/alloy/alien,
	/datum/material/cobolterium,
	/datum/material/copporcitite,
	/datum/material/tinumium,
	/datum/material/brussite,
))

/obj/item/forging
	icon = 'modular_nova/modules/reagent_forging/icons/obj/forge_items.dmi'
	lefthand_file = 'modular_nova/modules/reagent_forging/icons/mob/forge_weapon_l.dmi'
	righthand_file = 'modular_nova/modules/reagent_forging/icons/mob/forge_weapon_r.dmi'
	toolspeed = 1
	///whether the item is in use or not
	var/in_use = FALSE

/obj/item/forging/tongs
	name = "锻造钳"
	desc = "A set of tongs specifically crafted for use in forging. A wise man once said 'I lift things up and put them down.'"
	icon = 'modular_nova/modules/reagent_forging/icons/obj/forge_items.dmi'
	icon_state = "tong_empty"
	tool_behaviour = TOOL_TONG

/obj/item/forging/tongs/primitive
	name = "原始锻造钳"
	toolspeed = 2
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)

/obj/item/forging/tongs/attack_self(mob/user, modifiers)
	. = ..()
	var/obj/search_obj = locate(/obj) in contents
	if(search_obj)
		search_obj.forceMove(get_turf(src))
		icon_state = "tong_empty"
		return

/obj/item/forging/hammer
	name = "锻造木槌"
	desc = "专为锻造打造的槌子。用于缓慢塑形金属；小心，你可能会用它砸坏东西！"
	icon_state = "hammer"
	inhand_icon_state = "hammer"
	worn_icon_state = "hammer_back"
	tool_behaviour = TOOL_HAMMER
	///the list of things that, if attacked, will set the attack speed to rapid
	var/static/list/fast_attacks = list(
		/obj/structure/reagent_anvil,
		/obj/structure/reagent_crafting_bench
	)

/obj/item/forging/hammer/afterattack(atom/target, mob/user, click_parameters)
	. = ..()
	if(!is_type_in_list(target, fast_attacks))
		return
	user.changeNext_move(CLICK_CD_RAPID)

/obj/item/forging/hammer/primitive
	name = "原始锻造锤"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)

/obj/item/forging/billow
	name = "锻造风箱"
	desc = "专为锻造打造的风箱。用于鼓风助燃，保持锻炉火势。"
	icon_state = "billow"
	tool_behaviour = TOOL_BILLOW

/obj/item/forging/billow/primitive
	name = "原始锻造风箱"
	toolspeed = 2
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5)

//incomplete pre-complete items
/obj/item/forging/incomplete
	name = "父级开发物品"
	desc = "一件未完成的锻造物品，继续努力，你的付出终将获得回报。"
	//the time remaining that you can hammer before too cool
	COOLDOWN_DECLARE(heating_remainder)
	//the time between each strike
	COOLDOWN_DECLARE(striking_cooldown)
	///the amount of times it takes for the item to become ready
	var/average_hits = 30
	///the amount of times the item has been hit currently
	var/times_hit = 0
	///the required time before each strike to prevent spamming
	var/average_wait = 1 SECONDS
	///the path of the item that will be spawned upon completion
	var/spawn_item
	//because who doesn't want to have a plasma sword?
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR

/obj/item/forging/incomplete/tong_act(mob/living/user, obj/item/tool)
	. = ..()
	if(length(tool.contents) > 0)
		user.balloon_alert(user, "钳子已经满了！")
		return
	forceMove(tool)
	tool.icon_state = "tong_full"

/obj/item/forging/incomplete/chain
	name = "未完成的链条"
	icon_state = "hot_chain"
	average_hits = 10
	average_wait = 0.5 SECONDS
	spawn_item = /obj/item/forging/complete/chain

/obj/item/forging/incomplete/plate
	name = "未完成的板材"
	icon_state = "hot_plate"
	average_hits = 10
	average_wait = 0.5 SECONDS
	spawn_item = /obj/item/forging/complete/plate

/obj/item/forging/incomplete/sword
	name = "未完成的剑刃"
	icon_state = "hot_blade"
	spawn_item = /obj/item/forging/complete/sword

/obj/item/forging/incomplete/katana
	name = "未完成的武士刀刃"
	icon_state = "hot_katanablade"
	spawn_item = /obj/item/forging/complete/katana

/obj/item/forging/incomplete/dagger
	name = "未完成的匕首刃"
	icon_state = "hot_daggerblade"
	spawn_item = /obj/item/forging/complete/dagger

/obj/item/forging/incomplete/staff
	name = "未完成的杖头"
	icon_state = "hot_staffhead"
	spawn_item = /obj/item/forging/complete/staff

/obj/item/forging/incomplete/spear
	name = "未完成的矛头"
	icon_state = "hot_spearhead"
	spawn_item = /obj/item/forging/complete/spear

/obj/item/forging/incomplete/axe
	name = "未完成的斧头"
	icon_state = "hot_axehead"
	spawn_item = /obj/item/forging/complete/axe

/obj/item/forging/incomplete/hammer
	name = "未完成的锤头"
	icon_state = "hot_hammerhead"
	spawn_item = /obj/item/forging/complete/hammer

/obj/item/forging/incomplete/pickaxe
	name = "未完成的镐头"
	icon_state = "hot_pickaxehead"
	spawn_item = /obj/item/forging/complete/pickaxe

/obj/item/forging/incomplete/shovel
	name = "未完成的铲头"
	icon_state = "hot_shovelhead"
	spawn_item = /obj/item/forging/complete/shovel

/obj/item/forging/incomplete/arrowhead
	name = "未完成的箭头"
	icon_state = "hot_arrowhead"
	average_hits = 12
	average_wait = 0.5 SECONDS
	spawn_item = /obj/item/forging/complete/arrowhead

/obj/item/forging/incomplete/rail_nail
	name = "未完成的轨道钉"
	icon = 'modular_nova/modules/ashwalkers/icons/railroad.dmi'
	icon_state = "hot_nail"
	average_hits = 10
	average_wait = 0.5 SECONDS
	spawn_item = /obj/item/forging/complete/rail_nail

/obj/item/forging/incomplete/rail_cart
	name = "未完成的轨道车"
	icon = 'modular_nova/modules/ashwalkers/icons/railroad.dmi'
	icon_state = "hot_cart"
	spawn_item = /obj/vehicle/ridden/rail_cart

//"complete" pre-complete items
/obj/item/forging/complete
	///the path of the item that will be created
	var/spawning_item
	//because who doesn't want to have a plasma sword?
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR

/obj/item/forging/complete/examine(mob/user)
	. = ..()
	if(spawning_item)
		. += span_notice("<br>要完成这件物品，需要一个工作台！")

/obj/item/forging/complete/chain
	name = "链条"
	desc = "一根单独的链条，最好与多根链条组合使用。"
	icon_state = "chain"

/obj/item/forging/complete/plate
	name = "板材"
	desc = "一块板材，最好与多块板材组合使用。"
	icon_state = "plate"

/obj/item/forging/complete/sword
	name = "剑刃"
	desc = "一把剑刃，准备好配上木柄即可完成。"
	icon_state = "blade"
	spawning_item = /obj/item/forging/reagent_weapon/sword

/obj/item/forging/complete/katana
	name = "武士刀刃"
	desc = "一把武士刀刃，准备好配上木柄即可完成。"
	icon_state = "katanablade"
	spawning_item = /obj/item/forging/reagent_weapon/katana

/obj/item/forging/complete/dagger
	name = "匕首刃"
	desc = "一把匕首刃，准备好配上木柄即可完成。"
	icon_state = "daggerblade"
	spawning_item = /obj/item/forging/reagent_weapon/dagger

/obj/item/forging/complete/staff
	name = "杖头"
	desc = "一个杖头，准备好配上木柄即可完成。"
	icon_state = "staffhead"
	spawning_item = /obj/item/forging/reagent_weapon/staff

/obj/item/forging/complete/spear
	name = "矛头"
	desc = "一个矛头，准备好配上木柄即可完成。"
	icon_state = "spearhead"
	spawning_item = /obj/item/forging/reagent_weapon/spear

/obj/item/forging/complete/axe
	name = "斧头"
	desc = "一个斧头，准备好获取一些木材来完成制作。"
	icon_state = "axehead"
	spawning_item = /obj/item/forging/reagent_weapon/axe

/obj/item/forging/complete/hammer
	name = "锤头"
	desc = "一个锤头，准备好获取一些木材来完成制作。"
	icon_state = "hammerhead"
	spawning_item = /obj/item/forging/reagent_weapon/hammer

/obj/item/forging/complete/pickaxe
	name = "镐头"
	desc = "一个镐头，准备好获取一些木材来完成制作。"
	icon_state = "pickaxehead"
	spawning_item = /obj/item/pickaxe/reagent_weapon

/obj/item/forging/complete/shovel
	name = "铲头"
	desc = "一个铲头，准备好获取一些木材来完成制作。"
	icon_state = "shovelhead"
	spawning_item = /obj/item/shovel/reagent_weapon

/obj/item/forging/complete/arrowhead
	name = "箭头"
	desc = "一个箭头，准备好获取一些木材来完成制作。"
	icon_state = "arrowhead"
	spawning_item = /obj/item/arrow_spawner

/obj/item/forging/complete/rail_nail
	name = "轨道钉"
	desc = "一颗钉子，准备好与一些木材一起使用来制作轨道。"
	icon = 'modular_nova/modules/ashwalkers/icons/railroad.dmi'
	icon_state = "nail"
	spawning_item = /obj/item/stack/rail_track/ten

/obj/item/forging/coil
	name = "线圈"
	desc = "一个简单的线圈，由卷曲的铁棒组成。"
	icon_state = "coil"

/obj/item/forging/incomplete_bow
	name = "未完成的长弓"
	desc = "一把尚未上弦的木弓。"
	icon_state = "nostring_bow"

/obj/item/forging/incomplete_bow/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/weaponcrafting/silkstring))
		new /obj/item/gun/ballistic/bow/longbow(get_turf(src))
		qdel(attacking_item)
		qdel(src)
		return
	return ..()

/obj/item/arrow_spawner
	name = "箭矢生成器"
	desc = "你不应该看到这个。"
	/// the amount of arrows that are spawned from the spawner
	var/spawning_amount = 4

/obj/item/arrow_spawner/Initialize(mapload)
	. = ..()
	var/turf/src_turf = get_turf(src)
	for(var/i in 1 to spawning_amount)
		new /obj/item/ammo_casing/arrow/(src_turf)
	qdel(src)

/obj/item/stock_parts/power_store/cell/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/forging/coil))
		var/obj/item/stock_parts/power_store/cell/crank/new_crank = new(get_turf(src))
		new_crank.maxcharge = maxcharge
		new_crank.charge = charge
		qdel(attacking_item)
		qdel(src)
		return
	return ..()

/obj/item/stack/tong_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!(material_type in GLOB.allowed_forging_materials))
		user.balloon_alert(user, "只能锻造金属！")
		return
	if(length(tool.contents) > 0)
		user.balloon_alert(user, "钳子已经满了！")
		return FALSE
	if(!material_type && !custom_materials)
		user.balloon_alert(user, "无效材料！")
		return
	forceMove(tool)
	tool.icon_state = "tong_full"

/obj/tong_act(mob/living/user, obj/item/tool)
	. = ..()
	if(length(tool.contents))
		user.balloon_alert(user, "钳子已经满了！")
		return FALSE
	if(obj_flags_nova & ANVIL_REPAIR)
		forceMove(tool)
		tool.icon_state = "tong_full"

/obj/item/stack/sheet/mineral/adamantine
	material_type = /datum/material/adamantine
