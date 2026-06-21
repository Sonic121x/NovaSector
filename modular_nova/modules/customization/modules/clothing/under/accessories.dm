/obj/item/clothing/accessory/badge
	name = "侦探徽章"
	desc = "安保部侦探徽章，由黄金制成。"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "badge"
	slot_flags = ITEM_SLOT_NECK
	attachment_slot = CHEST

	var/stored_name
	var/badge_string = "Corporate Security"

	drop_sound = 'modular_nova/master_files/sound/items/drop/ring.ogg'
	pickup_sound = 'modular_nova/master_files/sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/badge/old
	name = "褪色徽章"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	desc = "一枚褪色的徽章，背面衬有皮革。上面印有法证部门的徽记。"
	icon_state = "goldbadge"

/obj/item/clothing/accessory/badge/proc/set_name(new_name)
	stored_name = new_name
	name = "[initial(name)] ([stored_name])"

/obj/item/clothing/accessory/badge/proc/set_desc(mob/living/carbon/human/H)

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "你深情地擦拭着你的旧徽章，把表面擦得锃亮。")
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message(span_notice("[user]展示了他们的[src.name]。\nIt上写着：[stored_name]，[badge_string]。"),span_notice("你展示了你的[src.name]。\nIt上写着：[stored_name]，[badge_string]。"))
		else
			user.visible_message(span_notice("[user]展示了他们的[src.name]。\nIt上写着：[badge_string]。"),span_notice("你展示了你的 [src.name]。上面写着：[badge_string]。"))

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message(span_danger("[user] invades [M]'s personal space, thrusting [src] into their face insistently."),span_danger("You invade [M]'s personal space, thrusting [src] into their face insistently."))
		user.do_attack_animation(M)

// Sheriff Badge (toy)
/obj/item/clothing/accessory/badge/sheriff
	name = "警长徽章"
	desc = "这镇子可容不下咱俩，伙计。"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "sheriff"

/obj/item/clothing/accessory/badge/sheriff/attack_self(mob/user as mob)
	user.visible_message("[user]亮出了他们的警长徽章。镇上来新警长了！",\
		"You flash the sheriff badge to everyone around you!")

/obj/item/clothing/accessory/badge/sheriff/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message(span_danger("[user] invades [M]'s personal space, the sheriff badge into their face!."),span_danger("You invade [M]'s personal space, thrusting the sheriff badge into their face insistently."))
		user.do_attack_animation(M)

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "全息徽章"
	desc = "这枚发着蓝光的徽章标志着佩戴者即为法律。"
	icon_state = "holobadge"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'

/obj/item/clothing/accessory/badge/holo/blue
	name = "蓝色全息徽章"
	desc = "这枚发着蓝光的徽章标志着佩戴者即为法律。"
	icon_state = "holobadge_blue"

/obj/item/clothing/accessory/badge/holo/cord
	name = "带挂绳的全息徽章"
	icon_state = "holobadge-cord"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	attachment_slot = NONE // it has a lanyard. you don't pin lanyards to your uniform, you wear them around your neck.

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "在刷卡前挥舞全息徽章没什么意义。")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(remaining_charges, mob/user)
	if(obj_flags & EMAGGED)
		balloon_alert(user, "已经破解")
		return FALSE

	obj_flags |= EMAGGED
	balloon_alert(user, "安全检查已破解！")
	to_chat(user, span_danger("你破解了全息徽章的安保检查。"))
	return TRUE

/obj/item/clothing/accessory/badge/holo/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/card/id))

		var/obj/item/card/id/id_card = null

		if(istype(attacking_item, /obj/item/card/id))
			id_card = attacking_item

		if((ACCESS_SECURITY in id_card.access) || (obj_flags & EMAGGED))
			to_chat(user, "你将ID信息刻印到了徽章上。")
			set_name(user.real_name)
			badge_string = id_card.assignment
		else
			to_chat(user, "[src]拒绝了你的访问权限。")
		return
	return ..()

/obj/item/storage/box/holobadge
	name = "全息徽章盒"
	desc = "一个声称装有全息徽章的盒子。"

/obj/item/storage/box/holobadge/PopulateContents()
	. = ..()
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo/cord(src)
	new /obj/item/clothing/accessory/badge/holo/cord(src)
	return

/obj/item/clothing/accessory/badge/holo/warden
	name = "典狱长的全息徽章"
	desc = "A silver corporate security badge. Stamped with the words 'Warden.'"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "silverbadge"
	slot_flags = ITEM_SLOT_NECK

/obj/item/clothing/accessory/badge/holo/hos
	name = "安全主管的全息徽章"
	desc = "An immaculately polished gold security badge. Labeled 'Head of Security.'"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "goldbadge"
	slot_flags = ITEM_SLOT_NECK

/obj/item/clothing/accessory/badge/holo/detective
	name = "侦探的全息徽章"
	desc = "An immaculately polished gold security badge on leather. Labeled 'Detective.'"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "marshalbadge"
	slot_flags = ITEM_SLOT_NECK

/obj/item/storage/box/holobadge/hos
	name = "全息徽章盒"
	desc = "一个声称装有全息徽章的盒子。"

/obj/item/storage/box/holobadge/hos/PopulateContents()
	. = ..()
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo/warden(src)
	new /obj/item/clothing/accessory/badge/holo/detective(src)
	new /obj/item/clothing/accessory/badge/holo/detective(src)
	new /obj/item/clothing/accessory/badge/holo/hos(src)
	new /obj/item/clothing/accessory/badge/holo/cord(src)
	return

// The newbie pin
/obj/item/clothing/accessory/green_pin
	name = "绿色别针"
	desc = "一枚发给甲板上新雇员的别针。"
	icon_state = "green"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	attachment_slot = NONE
	/// Who the pin originally belonged to, for purposes of tracking hours of playtime left
	var/datum/weakref/owner_ref

/obj/item/clothing/accessory/green_pin/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ACCESSORY_ATTACHED, PROC_REF(on_pin_attached))

/obj/item/clothing/accessory/green_pin/proc/on_pin_attached(obj/item/clothing/accessory/source, obj/item/clothing/under/attached_to)
	SIGNAL_HANDLER

	var/mob/accessory_wearer = attached_to.loc
	if(isnull(owner_ref) && istype(accessory_wearer))
		owner_ref = WEAKREF(accessory_wearer)

// Double examining the person wearing the clothes will display the examine message of the pin
/obj/item/clothing/accessory/green_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine))

/obj/item/clothing/accessory/green_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE_MORE)

/// Adds the examine message to the clothes and mob.
/obj/item/clothing/accessory/green_pin/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	// Only show the examine message if we're close (2 tiles)
	if(!IN_GIVEN_RANGE(get_turf(user), get_turf(src), 2))
		return

	var/mob/living/carbon/human/owner = owner_ref?.resolve()
	if(isnull(owner))
		owner_ref = null

	// How many hours of playtime left until the green pin expires
	var/green_time_remaining = sanitize_integer((PLAYTIME_GREEN - owner.client?.get_exp_living(pure_numeric = TRUE) / 60), 0, (PLAYTIME_GREEN / 60))
	// Only show this if we have green time remaining
	var/green_time_remaining_text = ""
	if(green_time_remaining > 0)
		green_time_remaining_text = " It reads '[green_time_remaining] hour[green_time_remaining >= 2 ? "s" : ""].'"

	if(ismob(source))
		var/mob/living/carbon/human/human_wearer = source
		// Examining a mob wearing the clothes, wearing the pin will also show the message
		var/obj/item/clothing/attached_to = loc
		examine_list += "A green pin is attached to [human_wearer.p_their()] [attached_to.name][owner ? ", belonging to [owner]." : "."][green_time_remaining_text]"
	else
		examine_list += "A green pin is attached to [source][owner ? ", belonging to [owner]." : "."][green_time_remaining_text]"

/obj/item/clothing/accessory/green_pin/examine(mob/user)
	. = ..()
	var/mob/living/carbon/human/owner = owner_ref?.resolve()
	if(isnull(owner))
		owner_ref = null
		return

	// What is shown when a mob examines it.
	var/examine_text = "This belongs to [owner]."
	// How many hours of playtime left until the green pin expires
	var/green_time_remaining = sanitize_integer((PLAYTIME_GREEN - owner.client?.get_exp_living(pure_numeric = TRUE) / 60), 0, (PLAYTIME_GREEN / 60))
	if(green_time_remaining > 0)
		examine_text += (" It reads '[green_time_remaining] hour[green_time_remaining >= 2 ? "s" : ""].'")

	. += span_nicegreen(examine_text)

// Pride Pin Over-ride (item-version)
/datum/atom_skin/pride_pin
	new_icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	allow_all_subtypes_in_loadout = TRUE // To allow for our icon override subtype to show up in the loadout menu.

/datum/atom_skin/pride_pin/nova
	abstract_type = /datum/atom_skin/pride_pin/nova
	new_icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	new_worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'

/datum/atom_skin/pride_pin/nova/man_loving_man
	preview_name = "Man-Loving-Man / Gay Pride"
	new_icon_state = "pride_mlm"

/datum/atom_skin/pride_pin/nova/genderfluid
	preview_name = "Genderfluid Pride"
	new_icon_state = "pride_genderfluid"

/datum/atom_skin/pride_pin/nova/genderqueer
	preview_name = "Genderqueer Pride"
	new_icon_state = "pride_genderqueer"

/datum/atom_skin/pride_pin/nova/aromantic
	preview_name = "Aromantic Pride"
	new_icon_state = "pride_aromantic"

/obj/item/clothing/accessory/pride
	attachment_slot = NONE

// Accessory for Akula species, it makes them wet and happy! :)
/obj/item/clothing/accessory/vaporizer
	name = "\improper 星装水合蒸汽器"
	desc = "An expensive device manufactured for the civilian work-force of the Azulean military power. \
		Relying on an internal battery, the coil mechanism synthesizes a hydrogen oxygen mixture, \
		which can then be used to moisturize the wearer's skin. \n\n\
		<i>A label on its back warns about the potential dangers of electro-magnetic pulses.</i> \n\
		<b>ctrl-click</b> in-hand to hide the device while worn. \n\
		Can also be worn inside of a pocket."
	icon_state = "wetmaker"
	base_icon_state = "wetmaker"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	obj_flags = UNIQUE_RENAME
	attachment_slot = NONE

/obj/item/clothing/accessory/vaporizer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wetsuit)

/obj/item/clothing/accessory/vaporizer/item_ctrl_click(mob/user)
	. = ..()
	if(!ishuman(user))
		return CLICK_ACTION_BLOCKING
	var/mob/living/carbon/human/wearer = user
	if(wearer.get_active_held_item() != src)
		to_chat(wearer, span_warning("你必须将[src]拿在手中才能这么做！"))
		return CLICK_ACTION_BLOCKING
	if(icon_state == "[base_icon_state]")
		icon_state = "[base_icon_state]_hidden"
		worn_icon_state = "[base_icon_state]_hidden"
		balloon_alert(wearer, "已隐藏")
	else
		icon_state = "[base_icon_state]"
		worn_icon_state = "[base_icon_state]"
		balloon_alert(wearer, "已显示")
	update_icon() // update that mf
	return CLICK_ACTION_SUCCESS

/mob/living/carbon/human/emp_act(severity) // necessary to still emp when worn as accessory
	. = ..()
	var/obj/item/clothing/under/worn_uniform = w_uniform
	if(!worn_uniform)
		return
	var/obj/item/clothing/accessory/vaporizer/vaporizer = locate() in worn_uniform.attached_accessories
	vaporizer?.on_emp()
	var/obj/item/clothing/accessory/energy_shield/energy_shield = locate() in worn_uniform.attached_accessories
	energy_shield?.emp_act(severity)

/obj/item/clothing/accessory/vaporizer/emp_act(severity)
	. = ..()
	var/turf/open/tile = get_turf(src)
	var/list/victims = get_hearers_in_view(4, tile)
	if(istype(tile))
		tile.atmos_spawn_air("[GAS_WATER_VAPOR]=50;[TURF_TEMPERATURE(1000)]")
	tile.balloon_alert_to_viewers("overloaded!")
	tile.visible_message("<span class='danger'>[src] overloads, exploding in a cloud of hot steam!</span>")
	playsound(tile, 'sound/effects/spray.ogg', 80)
	for(var/mob/living/collateral in victims)
		collateral.set_jitter_if_lower(15 SECONDS)
		collateral.set_eye_blur_if_lower(5 SECONDS)
	qdel(src)

/obj/item/clothing/accessory/vaporizer/proc/on_emp()
	var/obj/item/clothing/under/attached_to = loc
	detach(attached_to) // safely remove wetsuit status effect
	emp_act(EMP_LIGHT)

/datum/design/vaporizer
	name = "水合蒸汽器"
	id = "vaporizer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/accessory/vaporizer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
