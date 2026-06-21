// Badges, pins, and other very small items that slot onto a shirt.
/obj/item/clothing/accessory/lawyers_badge
	name = "律师徽章"
	desc = "让你充满正义的信念。律师们总想把它展示给遇到的每一个人。"
	icon_state = "lawyerbadge"

/obj/item/clothing/accessory/lawyers_badge/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "lawyer", BUBBLE_ICON_PRIORITY_ACCESSORY)

/obj/item/clothing/accessory/lawyers_badge/interact(mob/user)
	. = ..()
	if(prob(1))
		user.say("The testimony contradicts the evidence!", forced = "[src]")
	user.point_at(src)

/obj/item/clothing/accessory/lawyers_badge/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_LIVING_SLAM_TABLE, PROC_REF(table_slam))

/obj/item/clothing/accessory/lawyers_badge/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_LIVING_SLAM_TABLE)

/obj/item/clothing/accessory/lawyers_badge/proc/table_slam(mob/living/source, obj/structure/table/the_table)
	SIGNAL_HANDLER

	ASYNC
		source.say("Objection!!", spans = list(SPAN_YELL), forced = "[src]")

/obj/item/clothing/accessory/clown_enjoyer_pin
	name = "\improper 小丑徽章"
	desc = "一枚用来展示你对小丑和小丑艺术的欣赏之情的徽章！"
	icon_state = "clown_enjoyer_pin"

/obj/item/clothing/accessory/clown_enjoyer_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/mime_fan_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, "不能两边都选！")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/clown_enjoyer_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CLOWN_ENJOYER))
		user.add_mood_event("clown_enjoyer_pin", /datum/mood_event/clown_enjoyer_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/clown_enjoyer_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("clown_enjoyer_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/mime_fan_pin
	name = "\improper 默剧演员徽章"
	desc = "一枚用来展示你对默剧演员和默剧艺术的欣赏之情的徽章！"
	icon_state = "mime_fan_pin"

/obj/item/clothing/accessory/mime_fan_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/clown_enjoyer_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, "不能两边都选！")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/mime_fan_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_MIME_FAN))
		user.add_mood_event("mime_fan_pin", /datum/mood_event/mime_fan_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/mime_fan_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("mime_fan_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/pocketprotector
	name = "口袋保护套"
	desc = "可以保护你的衣服免受墨水污渍，但如果你用了它，看起来会像个书呆子。"
	icon_state = "pocketprotector"

/obj/item/clothing/accessory/pocketprotector/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/pocketprotector)

/obj/item/clothing/accessory/pocketprotector/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return

	if(!isnull(attach_to.atom_storage))
		if(user)
			attach_to.balloon_alert(user, "不兼容！")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/pocketprotector/full

/obj/item/clothing/accessory/pocketprotector/full/Initialize(mapload)
	. = ..()
	new /obj/item/pen/red(src)
	new /obj/item/pen(src)
	new /obj/item/pen/blue(src)

/obj/item/clothing/accessory/pocketprotector/cosmetology

/obj/item/clothing/accessory/pocketprotector/cosmetology/Initialize(mapload)
	. = ..()
	for(var/i in 1 to 3)
		new /obj/item/lipstick/random(src)

/obj/item/clothing/accessory/dogtag
	name = "狗牌"
	desc = "不能戴项圈，但这个就可以？"
	icon_state = "allergy"
	w_class = WEIGHT_CLASS_TINY
	attachment_slot = NONE // actually NECK but that doesn't make sense
	/// What message is displayed when our dogtags / its clothes / its wearer is examined
	var/display = "Nothing!"

/obj/item/clothing/accessory/dogtag/examine(mob/user)
	. = ..()
	. += display

// Examining the clothes will display the examine message of the dogtag
/obj/item/clothing/accessory/dogtag/attach(obj/item/clothing/under/attached_to)
	. = ..()
	RegisterSignal(attached_to, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/obj/item/clothing/accessory/dogtag/detach(obj/item/clothing/under/detach_from)
	. = ..()
	UnregisterSignal(detach_from, COMSIG_ATOM_EXAMINE)

// Double examining the person wearing the clothes will display the examine message of the dogtag
/obj/item/clothing/accessory/dogtag/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine))

/obj/item/clothing/accessory/dogtag/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE_MORE)

/// Adds the examine message to the clothes and mob.
/obj/item/clothing/accessory/dogtag/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	// Only show the examine message if we're close (2 tiles)
	if(!IN_GIVEN_RANGE(get_turf(user), get_turf(src), 2))
		return

	if(ismob(source))
		// Examining a mob wearing the clothes, wearing the dogtag will also show the message
		examine_list += "A dogtag is hanging around [source.p_their()] neck: [display]"
	else
		examine_list += "A dogtag is attached to [source]: [display]"

/obj/item/clothing/accessory/dogtag/allergy
	name = "过敏狗牌"
	desc = "一张列有过敏原的狗牌。"

/obj/item/clothing/accessory/dogtag/allergy/Initialize(mapload, allergy_string)
	. = ..()
	if(allergy_string)
		display = span_notice("狗牌上列有过敏原：[allergy_string]")
	else
		display = span_notice("狗牌上满是划痕。")

/obj/item/clothing/accessory/dogtag/borg_ready
	name = "预批准赛博格候选者狗牌"
	display = "This employee has been screened for negative mental traits to an acceptable level of accuracy, and is approved for the NT Cyborg program as an alternative to medical resuscitation."

// Pride pin skins
/datum/atom_skin/pride_pin
	abstract_type = /datum/atom_skin/pride_pin

/datum/atom_skin/pride_pin/gay
	preview_name = "Rainbow Pride"
	new_icon_state = "pride"

/datum/atom_skin/pride_pin/bi
	preview_name = "Bisexual Pride"
	new_icon_state = "pride_bi"

/datum/atom_skin/pride_pin/pan
	preview_name = "Pansexual Pride"
	new_icon_state = "pride_pan"

/datum/atom_skin/pride_pin/ace
	preview_name = "Asexual Pride"
	new_icon_state = "pride_ace"

/datum/atom_skin/pride_pin/enby
	preview_name = "Non-binary Pride"
	new_icon_state = "pride_enby"

/datum/atom_skin/pride_pin/trans
	preview_name = "Transgender Pride"
	new_icon_state = "pride_trans"

/datum/atom_skin/pride_pin/intersex
	preview_name = "Intersex Pride"
	new_icon_state = "pride_intersex"

/datum/atom_skin/pride_pin/lesbian
	preview_name = "Lesbian Pride"
	new_icon_state = "pride_lesbian"

/obj/item/clothing/accessory/pride
	name = "骄傲徽章"
	desc = "一枚由纳米特拉森多元与包容中心赞助的全息徽章，用于展示你的骄傲，提醒船员们他们对公平、多元与包容的坚定承诺！"
	icon_state = "pride"
	obj_flags = UNIQUE_RENAME

/obj/item/clothing/accessory/pride/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/pride_pin, infinite = TRUE)

/obj/item/clothing/accessory/deaf_pin
	name = "聋人人员徽章"
	desc = "表明佩戴者是聋人。"
	icon_state = "deaf_pin"

///Awarded for being dutiful and extinguishing the debt from the "Indebted" quirk.
/obj/item/clothing/accessory/debt_payer_pin
	name = "债务偿还者徽章"
	desc = "我已偿还债务，只得到了这枚徽章。"
	icon_state = "debt_payer_pin"

/// Self-identify as a dangerous subversive
/obj/item/clothing/accessory/anti_sec_pin
	name = "颠覆性徽章"
	desc = "一枚响亮而自豪地宣告你对纳米特拉森安保团队乃至一切权威的敌意的徽章。"
	icon_state = "anti_sec"
	clothing_traits = list(TRAIT_ALWAYS_WANTED)

/obj/item/clothing/accessory/anti_sec_pin/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/pinnable_accessory, silent = TRUE, pinning_time = 5 SECONDS)

/obj/item/clothing/accessory/anti_sec_pin/try_attach(obj/item/clothing/under/attach_to, mob/living/attacher)
	. = ..()
	if (!. || isnull(attacher))
		return

	var/target = ishuman(attach_to.loc) ? attach_to.loc : attach_to
	log_combat(attacher, target, "pinned an 'arrest me immediately' pin onto", src)
	return TRUE

/obj/item/clothing/accessory/anti_sec_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	. = ..()
	if (ishuman(user))
		var/mob/living/carbon/human/human_wearer = user
		human_wearer.sec_hud_set_security_status()

/obj/item/clothing/accessory/anti_sec_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	. = ..()
	if (ishuman(user))
		var/mob/living/carbon/human/human_wearer = user
		human_wearer.sec_hud_set_security_status()

/obj/item/clothing/accessory/press_badge
	name = "记者证"
	desc = "一枚蓝色的记者证，清楚地标识佩戴者为媒体成员。虽然它表明了媒体身份，但无论佩戴者如何叫嚣，它都不会授予任何特殊特权或权利。"
	desc_controls = "Click person with it to show them it"
	icon_state = "press_badge"
	attachment_slot = NONE // actually NECK but that doesn't make sense
	/// The name of the person in the badge
	var/journalist_name
	/// The name of the press person is working for
	var/press_name

/obj/item/clothing/accessory/press_badge/examine(mob/user)
	. = ..()
	if(!journalist_name || !press_name)
		. += span_notice("在手中使用以输入信息")
		return

	. += span_notice("它属于 <b>[journalist_name]</b>，<b>[press_name]</b>")

/obj/item/clothing/accessory/press_badge/attack_self(mob/user, modifiers)
	. = ..()
	if(!journalist_name)
		journalist_name = tgui_input_text(user, "你的名字是什么？", "记者姓名", "[user.name]", max_length = MAX_NAME_LEN)
	if(!press_name)
		press_name = tgui_input_text(user, "你为哪个组织工作？", "所属机构", "纳米传讯", max_length = MAX_CHARTER_LEN)

/obj/item/clothing/accessory/press_badge/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(!isliving(interacting_with))
		return

	var/mob/living/interacting_living = interacting_with
	if(user.combat_mode)
		playsound(interacting_living, 'sound/items/weapons/throw.ogg', 30)
		interacting_living.examinate(src)
		to_chat(interacting_living, span_userdanger("[user] 把 [src] 塞到你脸上！"))
		user.visible_message(span_warning("[user] 将一个 [src] 塞到了 [interacting_living] 的脸上。"))
	else
		playsound(interacting_living, 'sound/items/weapons/throwsoft.ogg', 20)
		interacting_living.examinate(src)
		to_chat(interacting_living, span_boldwarning("[user] 向你展示了 [src]。"))
		user.visible_message(span_notice("[user] 向 [interacting_living] 展示了一个 [src]。"))
