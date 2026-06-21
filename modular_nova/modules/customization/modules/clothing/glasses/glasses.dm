#define MODULAR_EYES_ICON 'modular_nova/master_files/icons/obj/clothing/glasses.dmi'
#define MODULAR_EYES_WORN_ICON 'modular_nova/master_files/icons/mob/clothing/eyes.dmi'

/obj/item/clothing/glasses/eyepatch/wrap
	name = "眼部绷带"
	desc = "一个美化了的绷带。至少这个是真正为你的头部设计的……"
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "eyewrap"
	base_icon_state = "eyewrap"

/obj/item/clothing/glasses/eyepatch/white
	name = "白色眼罩"
	desc = "这就是海盗获得博士学位后的样子。"
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "eyepatch_white"
	base_icon_state = "eyepatch_white"

///GLASSES

/datum/atom_skin/modern_glasses
	abstract_type = /datum/atom_skin/modern_glasses

/datum/atom_skin/modern_glasses/glasses_alt
	preview_name = "Translucent"
	new_icon_state = "glasses_alt"

/datum/atom_skin/modern_glasses/glasses_alt_t
	preview_name = "Transparent"
	new_icon_state = "glasses_alt_t"

/obj/item/clothing/glasses/regular/modern
	name = "现代眼镜"
	desc = "在Nerd. Co公司因逃税和入侵而破产后，他们被Dork.Co收购，后者彻底改造了他们的经典设计。"
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "glasses_alt"
	inhand_icon_state = "glasses"

/obj/item/clothing/glasses/regular/modern/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/modern_glasses)

/obj/item/clothing/glasses/trickblindfold/hamburg
	name = "窃贼面罩"
	desc = "非常适合从无辜的跨国资本主义垄断企业那里偷汉堡。"
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "thiefmask"

///GOGGLES
/obj/item/clothing/glasses/biker
	name = "机车护目镜"
	desc = "棕色皮革骑行装备，你可以离开，只要把汽油给我们。"
	icon = MODULAR_EYES_ICON
	worn_icon = MODULAR_EYES_WORN_ICON
	icon_state = "biker"
	inhand_icon_state = "welding-g"
	clothing_traits = list(TRAIT_NEARSIGHTED_CORRECTED)

// Like sunglasses, but without any protection
/obj/item/clothing/glasses/fake_sunglasses
	name = "低紫外线太阳镜"
	desc = "一种更便宜的太阳镜品牌，其紫外线防护等级要低得多。无法为用户提供任何针对强光的保护。"
	icon_state = "sun"
	inhand_icon_state = "sunglasses"

#undef MODULAR_EYES_ICON
#undef MODULAR_EYES_WORN_ICON
