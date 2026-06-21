/obj/item/clothing/head/soft
	name = "货舱帽"
	desc = "这是一顶精致的棕色棒球帽。"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "cargosoft"
	inhand_icon_state = "greyscale_softcap" //todo wip
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING
	/// For setting icon archetype
	var/soft_type = "cargo"
	/// If there is a suffix to append
	var/soft_suffix = "soft"

	dog_fashion = /datum/dog_fashion/head/cargo_tech
	/// Whether this is on backwards... Woah, cool
	var/flipped = FALSE

/obj/item/clothing/head/soft/dropped()
	icon_state = "[soft_type][soft_suffix]"
	flipped = FALSE
	..()

/obj/item/clothing/head/soft/verb/flipcap()
	set name = "Flip cap"

	flip(usr)


/obj/item/clothing/head/soft/click_alt(mob/user)
	flip(user)
	return CLICK_ACTION_SUCCESS


/obj/item/clothing/head/soft/proc/flip(mob/user)
	if(!user.incapacitated)
		flipped = !flipped
		if(flipped)
			icon_state = "[soft_type][soft_suffix]_flipped"
			to_chat(user, span_notice("你把帽子翻转到后面。"))
		else
			icon_state = "[soft_type][soft_suffix]"
			to_chat(user, span_notice("你把帽子翻回正常位置。"))
		update_icon()
		usr.update_worn_head() //so our mob-overlays update

/obj/item/clothing/head/soft/examine(mob/user)
	. = ..()
	. += span_notice("Alt-点击帽子可以将其[flipped ? "forwards" : "backwards"]翻转。")

/obj/item/clothing/head/soft/red
	name = "红色棒球帽"
	desc = "这是一顶俗气的红色棒球帽。"
	icon_state = "redsoft"
	soft_type = "red"
	dog_fashion = null

/obj/item/clothing/head/soft/blue
	name = "蓝色棒球帽"
	desc = "这是一顶俗气的蓝色棒球帽。"
	icon_state = "bluesoft"
	soft_type = "blue"
	dog_fashion = null

/obj/item/clothing/head/soft/green
	name = "绿色棒球帽"
	desc = "这是一顶俗气的绿色棒球帽。"
	icon_state = "greensoft"
	soft_type = "green"
	dog_fashion = null

/obj/item/clothing/head/soft/yellow
	name = "黄色棒球帽"
	desc = "这是一顶俗气的黄色棒球帽。"
	icon_state = "yellowsoft"
	soft_type = "yellow"
	dog_fashion = null

/obj/item/clothing/head/soft/grey
	name = "灰色棒球帽"
	desc = "这是一顶诱人的灰色棒球帽。"
	icon_state = "greysoft"
	soft_type = "grey"
	dog_fashion = null

/obj/item/clothing/head/soft/orange
	name = "橙色棒球帽"
	desc = "这是一顶俗气的橙色棒球帽。"
	icon_state = "orangesoft"
	soft_type = "orange"
	dog_fashion = null

/obj/item/clothing/head/soft/mime
	name = "白色棒球帽"
	desc = "这是一顶俗气的白色棒球帽。"
	icon_state = "mimesoft"
	soft_type = "mime"
	dog_fashion = null

/obj/item/clothing/head/soft/purple
	name = "紫色棒球帽"
	desc = "这是一顶俗气的紫色棒球帽。"
	icon_state = "purplesoft"
	soft_type = "purple"
	dog_fashion = null

/obj/item/clothing/head/soft/black
	name = "黑色棒球帽"
	desc = "这是一顶俗气的黑色棒球帽。"
	icon_state = "blacksoft"
	soft_type = "black"
	dog_fashion = null

/obj/item/clothing/head/soft/rainbow
	name = "七彩棒球帽"
	desc = "这是一顶色彩艳丽的彩色棒球帽。"
	icon_state = "rainbowsoft"
	inhand_icon_state = "rainbow_softcap"
	soft_type = "rainbow"
	dog_fashion = null

/obj/item/clothing/head/soft/sec
	name = "安保人员棒球帽"
	desc = "这是一顶强健的红色棒球帽。"
	icon_state = "secsoft"
	soft_type = "sec"
	armor_type = /datum/armor/cosmetic_sec
	strip_delay = 6 SECONDS
	dog_fashion = null

/obj/item/clothing/head/soft/veteran
	name = "老兵帽"
	desc = "这是一顶坚固的棒球帽，采用雅致的黑色，并带有金色的“铭记”字样。"
	icon_state = "veteransoft"
	soft_type = "veteran"
	armor_type = /datum/armor/cosmetic_sec
	strip_delay = 6 SECONDS
	dog_fashion = null

/obj/item/clothing/head/soft/paramedic
	name = "急救员鸭舌帽"
	desc = "这是一顶深蓝色的棒球帽，帽顶上有一个反光的十字标志。"
	icon_state = "paramedicsoft"
	soft_type = "paramedic"
	dog_fashion = null

/obj/item/clothing/head/soft/fishing_hat
	name = "传奇钓鱼帽"
	desc = "An ancient relic of a bygone era of bountiful catches and endless rivers. Printed on the front is a poem:<i>\n\
		Women Fear Me\n\
		Fish Fear Me\n\
		Men Turn Their Eyes Away From Me\n\
		As I Walk No Beast Dares Make A Sound In My Presence\n\
		I Am Alone On This Barren Earth.</i>"
	icon_state = "fishing_hat"
	soft_type = "fishing_hat"
	inhand_icon_state = "fishing_hat"
	soft_suffix = null
	worn_y_offset = 5
	clothing_flags = SNUG_FIT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE
	dog_fashion = null
	clothing_traits = list(TRAIT_SCARY_FISHERMAN) //Fish, carps, lobstrosities and frogs fear me.

/obj/item/clothing/head/soft/fishing_hat/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = strings("crustacean_replacement.json", "crustacean")) //you asked for this.
	AddElement(/datum/element/skill_reward, /datum/skill/fishing)
	AddElement(/datum/element/adjust_fishing_difficulty, -5)

#define PROPHAT_MOOD "prophat"

/obj/item/clothing/head/soft/propeller_hat
	name = "螺旋桨帽"
	desc = "一顶色彩鲜艳的帽子，顶上有一个旋转的螺旋桨。"
	icon_state = "propeller_hat"
	soft_type = "propeller_hat"
	inhand_icon_state = "rainbow_softcap"
	worn_y_offset = 1
	soft_suffix = null
	actions_types = list(/datum/action/item_action/toggle)
	var/enabled_waddle = TRUE
	var/active = FALSE

/obj/item/clothing/head/soft/propeller_hat/update_icon_state()
	. = ..()
	worn_icon_state = "[soft_type][flipped ? "_flipped" : null][active ? "_on" : null]"

/obj/item/clothing/head/soft/propeller_hat/attack_self(mob/user)
	active = !active
	balloon_alert(user, (active ? "启动了螺旋桨" : "停止了螺旋桨"))
	update_icon()
	user.update_worn_head()
	add_fingerprint(user)

/obj/item/clothing/head/soft/propeller_hat/equipped(mob/living/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_HEAD)
		user.add_mood_event(PROPHAT_MOOD, /datum/mood_event/prophat)

/obj/item/clothing/head/soft/propeller_hat/dropped(mob/living/user)
	. = ..()
	user.clear_mood_event(PROPHAT_MOOD)
	active = FALSE
	update_icon()

#undef PROPHAT_MOOD
