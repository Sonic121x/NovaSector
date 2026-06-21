//Basically the assistant suit
/obj/item/clothing/under/plasmaman
	name = "等离子环境服"
	desc = "一套特殊的等离子防护服，能保证以等离子为存在基础的生物在富含氧气的环境下安全生存，并在紧急情况下为穿戴者灭火。尽管密封性良好，但是无法适用于太空环境。"
	icon_state = "plasmaman"
	inhand_icon_state = "plasmaman"
	icon = 'icons/obj/clothing/under/plasmaman.dmi'
	worn_icon = 'icons/mob/clothing/under/plasmaman.dmi'
	clothing_flags = PLASMAMAN_PREVENT_IGNITION | NO_ZONE_DISABLING
	armor_type = /datum/armor/clothing_under/plasmaman
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	can_adjust = FALSE
	strip_delay = 8 SECONDS
	resistance_flags = FIRE_PROOF
	COOLDOWN_DECLARE(extinguish_timer)
	var/extinguish_cooldown = 100
	var/extinguishes_left = 5

/datum/armor/clothing_under/plasmaman
	bio = 100
	fire = 95
	acid = 95

/obj/item/clothing/under/plasmaman/examine(mob/user)
	. = ..()
	. += span_notice("这套防护服里还有[extinguishes_left == 1 ? "is" : "are"] [extinguishes_left]次灭火器充能。")

/obj/item/clothing/under/plasmaman/equipped(mob/living/user, slot)
	. = ..()
	if (slot & ITEM_SLOT_ICLOTHING)
		RegisterSignals(user, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_LIVING_IGNITED, SIGNAL_ADDTRAIT(TRAIT_HEAD_ATMOS_SEALED)), PROC_REF(check_fire_state))
		check_fire_state()

/obj/item/clothing/under/plasmaman/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_LIVING_IGNITED, SIGNAL_ADDTRAIT(TRAIT_HEAD_ATMOS_SEALED)))

/obj/item/clothing/under/plasmaman/proc/check_fire_state(datum/source)
	SIGNAL_HANDLER

	if (!ishuman(loc))
		return

	// This is weird but basically we're calling this proc once the cooldown ends in case our wearer gets set on fire again during said cooldown
	// This is why we're ignoring source and instead checking by loc
	var/mob/living/carbon/human/owner = loc
	if (!owner.on_fire || !owner.is_atmos_sealed(additional_flags = PLASMAMAN_PREVENT_IGNITION, check_hands = TRUE))
		return

	if (!extinguishes_left || !COOLDOWN_FINISHED(src, extinguish_timer))
		return

	extinguishes_left -= 1
	COOLDOWN_START(src, extinguish_timer, extinguish_cooldown)
	// Check if our (possibly other) wearer is on fire once the cooldown ends
	addtimer(CALLBACK(src, PROC_REF(check_fire_state)), extinguish_cooldown)
	owner.visible_message(span_warning("[owner]的服装自动扑灭了[owner.p_them()]！"), span_warning("你的服装自动扑灭了你身上的火焰。"))
	owner.extinguish_mob()
	new /obj/effect/particle_effect/water(get_turf(owner))

/obj/item/clothing/under/plasmaman/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (!istype(tool, /obj/item/extinguisher_refill))
		return ..()

	if (extinguishes_left == 5)
		to_chat(user, span_notice("内置灭火器已充满。"))
		return ITEM_INTERACT_BLOCKING

	extinguishes_left = 5
	to_chat(user, span_notice("你补充了服装内置灭火器的充能，用完了这个灭火器罐。"))
	check_fire_state()
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

/obj/item/extinguisher_refill
	name = "环境服灭火器补充盒"
	desc = "一种装有压缩灭火器混合物的弹药筒，用于在等离子防护服上的自动灭火器补充燃料。"
	icon_state = "plasmarefill"
	icon = 'icons/obj/canisters.dmi'

/obj/item/clothing/under/plasmaman/cargo
	name = "货舱等离子环境服"
	desc = "一种等离子人军需官和货运技术员通用的环境防护服，因为从裤腿长度区分两者的后勤问题而设计。"
	icon_state = "cargo_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/mining
	name = "采矿等离子环境服"
	desc = "为等离子人在熔岩地作业设计的密封卡其色服装。"
	icon_state = "explorer_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/chef
	name = "厨师的等离子环境服"
	desc = "为烹饪实践设计的白色等离子人环境防护服。有人可能会质疑，一个不需要进食的种族成员为何要成为厨师。"
	icon_state = "chef_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/enviroslacks
	name = "时髦等离子环境服"
	desc = "这是一位特别讲究的等离子人的个人项目，这套定制服装很快被纳米特拉森公司征用，供其律师和调酒师使用。"
	icon_state = "enviroslacks"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/chaplain
	name = "牧师的等离子环境服"
	desc = "一套专为最虔诚的等离子人设计的防护服"
	icon_state = "chap_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/curator
	name = "馆长的等离子环境服"
	desc = "这套装备是由改良后的真空服改造而成的，是纳米传讯公司为解决使用等离子人所带来的“后勤问题”而推出的首个解决方案。由于进行了改造，这套装备已不再具备太空行走能力。尽管存在一些限制，但这些装备仍被历史学家和传统等离子人所使用。"
	icon_state = "prototype_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/janitor
	name = "清洁工等离子环境服"
	desc = "一套灰色和紫色相间的环保防护服，专为等离子人清洁工设计。"
	icon_state = "janitor_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/botany
	name = "植物学等离子环境防护服"
	desc = "一款绿色和蓝色相间的环境防护服，可以为等离子人防护轻微的植物相关伤害。"
	icon_state = "botany_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/mime
	name = "默剧等离子环境防护服"
	desc = "颜色不是很鲜艳"
	icon_state = "mime_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/clown
	name = "小丑等离子环境防护服"
	desc = "<i>' honk！'</i>"
	icon_state = "clown_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/bitrunner
	name = "比特行者环境防护服"
	desc = "专为有不良姿势的等离子人设计的环境防护服。"
	icon_state = "bitrunner_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/clown/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)

/obj/item/clothing/under/plasmaman/prisoner
	name = "囚犯等离子环境防护服"
	desc = "一套橙色的环境防护服，可以识别并保护一个犯罪的等离子人。它的服装传感器被卡在“完全开启”的位置。"
	icon_state = "prisoner_envirosuit"
	inhand_icon_state = null
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/plasmaman/clown/check_fire_state(datum/source, datum/status_effect/fire_handler/status_effect)
	if (!ishuman(loc))
		return

	// This is weird but basically we're calling this proc once the cooldown ends in case our wearer gets set on fire again during said cooldown
	// This is why we're ignoring source and instead checking by loc
	var/mob/living/carbon/human/owner = loc
	if (!owner.on_fire || !owner.is_atmos_sealed(additional_flags = PLASMAMAN_PREVENT_IGNITION, check_hands = TRUE))
		return

	if (!extinguishes_left || !COOLDOWN_FINISHED(src, extinguish_timer))
		return

	extinguishes_left -= 1
	COOLDOWN_START(src, extinguish_timer, extinguish_cooldown)
	// Check if our (possibly other) wearer is on fire once the cooldown ends
	addtimer(CALLBACK(src, PROC_REF(check_fire_state)), extinguish_cooldown)
	owner.visible_message(span_warning("[owner]的服装喷得到处都是太空润滑剂！"), span_warning("你的防护服喷得到处都是太空润滑剂！"))
	owner.extinguish_mob()
	do_foam(4, src, get_turf(owner), /datum/reagent/lube, 15)
