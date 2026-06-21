	//NASA Voidsuit
/obj/item/clothing/head/helmet/space/nasavoid
	name = "\improper NASA void helmet"
	desc = "一顶由NASA中央指挥部分部设计的旧款暗红色太空服头盔。"
	icon_state = "void"
	inhand_icon_state = "void_helmet"

/obj/item/clothing/suit/space/nasavoid
	name = "\improper NASA voidsuit"
	icon_state = "void"
	inhand_icon_state = "void_suit"
	desc = "一套由NASA中央指挥部分部设计的旧款暗红色太空服。"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/multitool)

/obj/item/clothing/head/helmet/space/nasavoid/old
	name = "\improper engineering void helmet"
	desc = "一顶中央指挥部工程部制式的暗红色太空服头盔。虽然积尘陈旧，但依然可靠耐用。"
	icon_state = "void"
	visor_dirt = "void_dirt"

/obj/item/clothing/suit/space/nasavoid/old
	name = "\improper engineering voidsuit"
	icon_state = "void"
	inhand_icon_state = "void_suit"
	desc = "一套中央指挥部工程部制式的暗红色太空服。岁月磨损让这套服装行动变得笨重不便。"
	slowdown = 4
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/multitool)

	//EVA suit
/obj/item/clothing/suit/space/eva
	name = "\improper EVA suit"
	icon_state = "space"
	inhand_icon_state = "s_suit"
	desc = "一套轻便的太空服，具备在紧急情况下可保护穿戴者免受太空真空的影响的基本能力。"
	armor_type = /datum/armor/space_eva

/obj/item/clothing/head/helmet/space/eva
	name = "\improper EVA helmet"
	icon_state = "space"
	inhand_icon_state = "space_helmet"
	desc = "一款轻便的太空头盔，具备在紧急情况下可保护穿戴者免受太空真空的影响的基本能力。"
	flash_protect = FLASH_PROTECTION_NONE
	armor_type = /datum/armor/space_eva
	visor_dirt = "space_dirt"
	has_visor = TRUE

/datum/armor/space_eva
	bio = 100
	fire = 50
	acid = 65

/obj/item/clothing/head/helmet/space/eva/examine(mob/user)
	. = ..()
	. += span_notice("你可以用一个[span_bold("cyborg leg")]开始建造一个适合小动物的机甲。")

/obj/item/clothing/head/helmet/space/eva/attackby(obj/item/attacked_with, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return
	if(!istype(attacked_with, /obj/item/bodypart/leg/left/robot) && !istype(attacked_with, /obj/item/bodypart/leg/right/robot))
		return
	if(ismob(loc))
		user.balloon_alert(user, "先放下头盔！")
		return
	user.balloon_alert(user, "腿部已连接")
	new /obj/item/bot_assembly/vim(loc)
	qdel(attacked_with)
	qdel(src)

	//Emergency suit
/obj/item/clothing/head/helmet/space/fragile
	name = "应急太空服头盔"
	desc = "一种笨重的、气密的头盔，旨在紧急情况下保护使用者。它看起来不太耐用。"
	icon_state = "syndicate-helm-orange"
	inhand_icon_state = "syndicate-helm-orange" //resprite?
	armor_type = /datum/armor/space_fragile
	strip_delay = 6.5 SECONDS

/obj/item/clothing/suit/space/fragile
	name = "应急太空服"
	desc = "一种笨重的、气密的防护服，旨在紧急情况下保护使用者。它看起来不太耐用。"
	var/torn = FALSE
	icon_state = "syndicate-orange"
	inhand_icon_state = "syndicate-orange"
	slowdown = 2
	armor_type = /datum/armor/space_fragile
	strip_delay = 6.5 SECONDS

/datum/armor/space_fragile
	melee = 5

/obj/item/clothing/suit/space/fragile/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(!torn && prob(50))
		to_chat(owner, span_warning("[src]因损伤而撕裂，破坏了气密性！"))
		clothing_flags &= ~STOPSPRESSUREDAMAGE
		name = "撕[src]"
		desc = "一种笨重的防护服，用于在紧急情况下保护使用者，在有人把防护服撕开一个洞之前。"
		torn = TRUE
		playsound(loc, 'sound/items/weapons/slashmiss.ogg', 50, TRUE)
		playsound(loc, 'sound/effects/refill.ogg', 50, TRUE)
