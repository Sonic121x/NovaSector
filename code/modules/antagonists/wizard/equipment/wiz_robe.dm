/obj/item/clothing/head/wizard
	name = "巫师帽"
	desc = "一顶造型奇特的帽子，无疑属于一位真正的魔法使用者。"
	icon = 'icons/obj/clothing/head/wizard.dmi'
	worn_icon = 'icons/mob/clothing/head/wizard.dmi'
	icon_state = "wizard"
	inhand_icon_state = "wizhat"
	armor_type = /datum/armor/head_wizard
	strip_delay = 5 SECONDS
	equip_delay_other = 5 SECONDS
	clothing_flags = SNUG_FIT | CASTING_CLOTHES
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = /datum/dog_fashion/head/blue_wizard
	///How much this hat affects fishing difficulty
	var/fishing_modifier = -6

/obj/item/clothing/head/wizard/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, fishing_modifier) //A wizard always practices his casting (ba dum tsh)

/datum/armor/head_wizard
	melee = 30
	bullet = 20
	laser = 20
	energy = 30
	bomb = 20
	bio = 100
	fire = 100
	acid = 100
	wound = 20

/obj/item/clothing/head/wizard/red
	name = "红色巫师帽"
	desc = "一顶造型奇特的红色帽子，无疑属于一位真正的魔法使用者。"
	icon_state = "redwizard"
	dog_fashion = /datum/dog_fashion/head/red_wizard

/obj/item/clothing/head/wizard/yellow
	name = "黄色巫师帽"
	desc = "一顶造型奇特的黄色帽子，无疑属于一位强大的魔法使用者。"
	icon_state = "yellowwizard"
	dog_fashion = null

/obj/item/clothing/head/wizard/black
	name = "黑色巫师帽"
	desc = "一顶造型奇特的黑色帽饰，几乎可以肯定属于一具真正的骷髅。真吓人。"
	icon_state = "blackwizard"
	dog_fashion = null

/obj/item/clothing/head/wizard/fake
	name = "巫师帽"
	desc = "上面用亮片写着“巫师”二字。附赠一个酷炫的胡子。"
	icon_state = "wizard-fake"
	armor_type = /datum/armor/none
	resistance_flags = FLAMMABLE
	dog_fashion = /datum/dog_fashion/head/blue_wizard
	fishing_modifier = -2

/obj/item/clothing/head/wizard/chanterelle
	name = "鸡油菌帽"
	desc = "一个被掏空内部以容纳头部的巨大鸡油菌。看起来有点像巫师的帽子。"
	icon_state = "chanterelle"
	inhand_icon_state = "chanterellehat"
	armor_type = /datum/armor/none
	resistance_flags = FLAMMABLE

/obj/item/clothing/head/wizard/chanterelle/fr
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/wizard/marisa
	name = "女巫帽"
	desc = "造型奇特的帽子。让你想发射火球。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/wizard/marisa"
	post_init_icon_state = "witch_hat"
	greyscale_config = /datum/greyscale_config/witch_hat
	greyscale_config_worn = /datum/greyscale_config/witch_hat/worn
	greyscale_colors = "#343640#e0cab8#e0cab8"
	flags_1 = IS_PLAYER_COLORABLE_1
	dog_fashion = null

/obj/item/clothing/head/wizard/tape
	name = "胶带帽"
	desc = "一顶完全由胶带制成的魔法调谐帽子。你几乎看不见。"
	icon_state = "tapehat"
	inhand_icon_state = "tapehat"
	dog_fashion = null
	worn_y_offset = 6
	body_parts_covered = HEAD //this used to also cover HAIR, but that was never valid code as HAIR is not actually a body_part define!
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/wizard/magus
	name = "\improper 大法师头盔"
	icon_state = "magus"
	desc = "一顶神秘的、散发着不祥力量嗡鸣的头盔。"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEARS|HIDEEYES|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	inhand_icon_state = null
	dog_fashion = null

/obj/item/clothing/head/wizard/santa
	name = "圣诞老人的帽子"
	desc = "呵-呵-呵。圣诞快乐！"
	icon_state = "santahat"
	inhand_icon_state = "santahat"
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	dog_fashion = null

/obj/item/clothing/head/wizard/hood
	name = "巫师兜帽"
	icon_state = "wizhood"

/obj/item/clothing/suit/wizrobe
	name = "巫师袍"
	desc = "一件华丽的、镶有宝石的长袍，似乎散发着力量。"
	icon = 'icons/obj/clothing/suits/wizard.dmi'
	icon_state = "wizard"
	worn_icon = 'icons/mob/clothing/suits/wizard.dmi'
	inhand_icon_state = "wizrobe"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor_type = /datum/armor/suit_wizrobe
	allowed = list(/obj/item/highfrequencyblade/wizard, /obj/item/storage/belt/wand_bandolier, /obj/item/teleportation_scroll)
	flags_inv = HIDEJUMPSUIT
	strip_delay = 5 SECONDS
	equip_delay_other = 5 SECONDS
	clothing_flags = CASTING_CLOTHES
	resistance_flags = FIRE_PROOF | ACID_PROOF
	///How much this robe affects fishing difficulty
	var/fishing_modifier = -7

/obj/item/clothing/suit/wizrobe/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, fishing_modifier) //A wizard always practices his casting (ba dum tsh)

/datum/armor/suit_wizrobe
	melee = 30
	bullet = 20
	laser = 20
	energy = 30
	bomb = 20
	bio = 100
	fire = 100
	acid = 100
	wound = 20

/obj/item/clothing/suit/wizrobe/red
	name = "红色巫师袍"
	desc = "一件华丽的红色镶宝石长袍，似乎散发着力量。"
	icon_state = "redwizard"
	inhand_icon_state = null

/obj/item/clothing/suit/wizrobe/yellow
	name = "黄色巫师袍"
	desc = "一件华丽的黄色镶宝石长袍，似乎散发着力量。"
	icon_state = "yellowwizard"
	inhand_icon_state = null

/obj/item/clothing/suit/wizrobe/black
	name = "黑色巫师袍"
	desc = "一件令人不安的黑色镶宝石长袍，散发着死亡与腐朽的气息。"
	icon_state = "blackwizard"
	inhand_icon_state = null

/obj/item/clothing/suit/wizrobe/marisa
	name = "女巫袍"
	desc = "魔法就是关于法术的力量，ZE！"
	icon_state = "marisa"
	inhand_icon_state = null

/obj/item/clothing/suit/wizrobe/tape
	name = "胶带长袍"
	desc = "一件由魔法调谐的胶带制成的精美长袍。"
	icon_state = "taperobe"
	inhand_icon_state = "taperobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "\improper 大法师长袍"
	desc = "一套似乎散发着黑暗力量的装甲长袍。"
	icon_state = "magusblue"
	inhand_icon_state = null
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/wizrobe/magusred
	name = "\improper 大法师长袍"
	desc = "一套似乎散发着黑暗力量的装甲长袍。"
	icon_state = "magusred"
	inhand_icon_state = null
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/wizrobe/santa
	name = "圣诞老人套装"
	desc = "节日气氛！"
	icon_state = "santa"
	inhand_icon_state = "santa"

/obj/item/clothing/suit/wizrobe/fake
	name = "巫师袍"
	desc = "一件相当单调的蓝色长袍，旨在模仿真正的巫师袍。"
	icon_state = "wizard-fake"
	inhand_icon_state = "wizrobe"
	armor_type = /datum/armor/none
	resistance_flags = FLAMMABLE
	fishing_modifier = -3

/obj/item/clothing/head/wizard/marisa/fake
	name = "女巫帽"
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1
	armor_type = /datum/armor/none
	resistance_flags = FLAMMABLE
	fishing_modifier = -2

/obj/item/clothing/head/wizard/tape/fake
	name = "胶带帽"
	desc = "一顶完全由胶带设计的帽子。你几乎看不清。"
	armor_type = /datum/armor/none
	resistance_flags = FLAMMABLE
	fishing_modifier = -2

/obj/item/clothing/suit/wizrobe/marisa/fake
	name = "女巫袍"
	desc = "魔法全在于法术威力，ZE！"
	icon_state = "marisa"
	inhand_icon_state = null
	armor_type = /datum/armor/none
	resistance_flags = FLAMMABLE
	fishing_modifier = -3

/obj/item/clothing/suit/wizrobe/tape/fake
	name = "胶带袍"
	desc = "一套完全由胶带设计的服装。穿起来很费劲。"
	armor_type = /datum/armor/none
	resistance_flags = FLAMMABLE
	fishing_modifier = -3

/obj/item/clothing/suit/wizrobe/durathread
	name = "杜拉纤维长袍"
	desc = "一件相当单调的杜拉纤维长袍；防护性不如一件合适的盔甲，但时尚得多。"
	icon_state = "durathread-fake"
	inhand_icon_state = null
	armor_type = /datum/armor/robe_durathread
	allowed = /obj/item/clothing/suit/apron::allowed
	fishing_modifier = -6

/datum/armor/robe_durathread
	melee = 15
	bullet = 5
	laser = 25
	energy = 30
	bomb = 10
	fire = 30
	acid = 40

/obj/item/clothing/suit/wizrobe/durathread/fire
	name = "纵火法师袍"
	desc = "一件相当单调的杜拉纤维长袍；防护性不如编织盔甲，但时尚得多。"
	icon_state = "durathread-fire"

/obj/item/clothing/suit/wizrobe/durathread/ice
	name = "纵火法师袍"
	desc = "一件相当单调的杜拉纤维长袍；防护性不如编织盔甲，但时尚得多。"
	icon_state = "durathread-ice"

/obj/item/clothing/suit/wizrobe/durathread/electric
	name = "电法师袍"
	desc = "实际上并不传导或隔离电力。不过由于是由杜拉纤维制成，确实有一些耐久性。"
	icon_state = "durathread-electric"

/obj/item/clothing/suit/wizrobe/durathread/earth
	name = "地脉法师长袍"
	desc = "一件相当朴素的杜拉纤维长袍；防护性不如编织盔甲，但时尚得多。"
	icon_state = "durathread-earth"

/obj/item/clothing/suit/wizrobe/durathread/necro
	name = "死灵法师长袍"
	desc = "一件相当朴素的杜拉纤维长袍；防护性不如编织盔甲，但时尚得多。"
	icon_state = "durathread-necro"

/obj/item/clothing/suit/wizrobe/paper
	name = "纸浆长袍" // no non-latin characters!
	desc = "一件由各种透明胶带和浆糊粘合而成的长袍。"
	icon_state = "wizard-paper"
	inhand_icon_state = null
	COOLDOWN_DECLARE(summoning_cooldown)
	actions_types = list(/datum/action/item_action/stickmen)

/obj/item/clothing/suit/wizrobe/paper/ui_action_click(mob/user, action)
	if(!ishuman(user))
		return

	if(!COOLDOWN_FINISHED(src, summoning_cooldown))
		user.balloon_alert(user, "法袍正在充能！")
		return

	conjure_stickmen(user)

/obj/item/clothing/suit/wizrobe/paper/proc/conjure_stickmen(mob/living/carbon/human/summoner)
	summoner.force_say()
	summoner.say("Rise, my creation! Off your page into this realm!", forced = "stickman summoning")
	playsound(src, 'sound/effects/magic/summon_magic.ogg', 50, TRUE, TRUE)

	var/mob/living/stickman = new /mob/living/basic/stickman/lesser(get_turf(summoner))
	stickman.remove_faction(FACTION_NEUTRAL) //These bad boys shouldn't inherit the neutral faction from the crew

	COOLDOWN_START(src, summoning_cooldown, 3 SECONDS)
