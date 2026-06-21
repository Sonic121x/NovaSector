/obj/item/clothing/suit/costume
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	abstract_type = /obj/item/clothing/suit/costume

/obj/item/clothing/suit/hooded/flashsuit
	name = "华丽服装"
	desc = "你想的是什么？"
	icon_state = "flashsuit"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	hoodtype = /obj/item/clothing/head/hooded/flashsuit

/obj/item/clothing/head/hooded/flashsuit
	name = "闪光按钮"
	desc = "你会学会害怕闪光的。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "flashsuit"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR|HIDEFACE|HIDEMASK|HIDESNOUT

/obj/item/clothing/head/hooded/flashsuit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/wearable_client_colour, /datum/client_colour/flash_hood, ITEM_SLOT_HEAD, HELMET_TRAIT, forced = TRUE)

/obj/item/clothing/suit/costume/pirate
	name = "海盗大衣"
	desc = "呀儿。"
	icon_state = "pirate"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
		/obj/item/melee/energy/sword/pirate,
		/obj/item/clothing/glasses/eyepatch,
		/obj/item/reagent_containers/cup/glass/bottle/rum,
		/obj/item/gun/energy/laser/musket,
		/obj/item/gun/energy/disabler/smoothbore,
	)
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/costume/pirate/armored
	armor_type = /datum/armor/pirate_armored
	strip_delay = 4 SECONDS
	equip_delay_other = 2 SECONDS
	species_exception = null

/obj/item/clothing/suit/costume/pirate/armored/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

/obj/item/clothing/suit/costume/pirate/captain
	name = "海盗船长大衣"
	desc = "Yarr."
	icon_state = "hgpirate"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/pirate/captain/armored
	armor_type = /datum/armor/pirate_armored
	strip_delay = 4 SECONDS
	equip_delay_other = 2 SECONDS
	species_exception = null

/obj/item/clothing/suit/costume/cyborg_suit
	name = "赛博服"
	desc = "与赛博服配套的衣服。"
	icon_state = "death"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|FEET
	obj_flags = CONDUCTS_ELECTRICITY
	fire_resist = T0C+5200
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL // NOVA EDIT CHANGE - ORIGINAL: flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/costume/justice
	name = "正义服"
	desc = "看起来真的很可笑。" //Needs no fixing
	icon_state = "justice"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor_type = /datum/armor/costume_justice

/obj/item/clothing/suit/costume/justice/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_vest_allowed

/datum/armor/costume_justice
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/suit/costume/judgerobe
	name = "正义长袍"
	desc = "这件长袍象征着权威。"
	icon_state = "judge"
	inhand_icon_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/storage/fancy/cigarettes, /obj/item/stack/spacecash)

/obj/item/clothing/suit/syndicatefake
	name = "红黑双色太空服复制品"
	icon_state = "syndicate-black-red"
	icon = 'icons/obj/clothing/suits/spacesuit.dmi'
	worn_icon = 'icons/mob/clothing/suits/spacesuit.dmi'
	inhand_icon_state = "syndicate-black-red"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|FEET
	desc = "一套塑料材质的辛迪加太空服模型。穿上它，你看起来就像一个真正的冷酷无情的辛迪加特工！这只是个玩具，并非设计用于太空！"
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	resistance_flags = NONE

/obj/item/clothing/suit/costume/hastur
	name = "\improper 哈斯特长袍"
	desc = "不是给男人穿的长袍。"
	icon_state = "hastur"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/costume/imperium_monk
	name = "\improper 帝国僧侣服"
	desc = "你今天杀了异形了吗?"
	icon_state = "imperium_monk"
	inhand_icon_state = "imperium_monk"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDEBELT

/obj/item/clothing/suit/costume/imperium_monk/Initialize(mapload)
	. = ..()
	allowed = GLOB.chaplain_suit_allowed

/obj/item/clothing/suit/costume/chickensuit
	name = "小鸡服"
	desc = "一套很久以前由古代帝国KFC制作的衣服。"
	icon_state = "chickensuit"
	inhand_icon_state = "chickensuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/costume/monkeysuit
	name = "猴子服"
	desc = "一套看起来像灵长类动物的衣服。"
	icon_state = "monkeysuit"
	inhand_icon_state = null
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/toggle/owlwings
	name = "猫头鹰斗篷"
	desc = "由合成羽毛制成的柔软的棕色斗篷。触感柔软，时尚，两米的翼展，足以让女士们疯狂。"
	icon_state = "owl_wings"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = null
	toggle_noun = "wings"
	body_parts_covered = ARMS|CHEST

/obj/item/clothing/suit/toggle/owlwings/Initialize(mapload)
	. = ..()
	allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/toggle/owlwings/griffinwings
	name = "狮鹫斗篷"
	desc = "由合成羽毛制成的白色长毛绒斗篷。触感柔软，时尚，2米的翼展,足以让你的俘虏发疯。"
	icon_state = "griffin_wings"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/cardborg
	name = "纸板机器人服装"
	desc = "一个普通的纸板箱，边上开了个洞。"
	icon_state = "cardborg"
	inhand_icon_state = "cardborg"
	body_parts_covered = CHEST|GROIN|LEGS
	flags_inv = HIDEJUMPSUIT
	dog_fashion = /datum/dog_fashion/back
	custom_materials = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT * 3)
	var/in_use = FALSE

/obj/item/clothing/suit/costume/cardborg/equipped(mob/living/user, slot)
	..()
	if(slot & ITEM_SLOT_OCLOTHING)
		disguise(user)

/obj/item/clothing/suit/costume/cardborg/dropped(mob/living/user)
	..()
	if (!in_use)
		return
	user.remove_alt_appearance("standard_borg_disguise")
	in_use = FALSE
	var/mob/living/carbon/human/human_user = user
	if (istype(human_user.head, /obj/item/clothing/head/costume/cardborg))
		UnregisterSignal(human_user.head, COMSIG_ITEM_DROPPED)

/obj/item/clothing/suit/costume/cardborg/proc/disguise(mob/living/carbon/human/human_user, obj/item/clothing/head/costume/cardborg/borghead)
	if(!istype(human_user))
		return
	if(!borghead)
		borghead = human_user.head
	if(!istype(borghead, /obj/item/clothing/head/costume/cardborg)) //why is this done this way? because equipped() is called BEFORE THE ITEM IS IN THE SLOT WHYYYY
		return
	RegisterSignal(borghead, COMSIG_ITEM_DROPPED, PROC_REF(helmet_drop)) // Don't need to worry about qdeleting since dropped will be called from there
	in_use = TRUE
	var/image/override_image = image(icon = 'icons/mob/silicon/robots.dmi' , icon_state = "robot", loc = human_user)
	override_image.override = TRUE
	override_image.add_overlay(mutable_appearance('icons/mob/silicon/robots.dmi', "robot_e")) //gotta look realistic
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "standard_borg_disguise", override_image) //you look like a robot to robots! (including yourself because you're totally a robot)

/obj/item/clothing/suit/costume/cardborg/proc/helmet_drop(datum/source, mob/living/user)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_ITEM_DROPPED)
	user.remove_alt_appearance("standard_borg_disguise")
	in_use = FALSE

/obj/item/clothing/suit/costume/snowman
	name = "雪人装"
	desc = "两个白色球体，表面覆盖着白色的鳞片。这就是这个季节的特色。"
	icon_state = "snowman"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/costume/poncho
	name = "斗篷"
	desc = "你那经典的不含倪哥种族主义的斗篷。"
	icon_state = "classicponcho"
	inhand_icon_state = null
	species_exception = list(/datum/species/golem)
	flags_inv = HIDEBELT

/obj/item/clothing/suit/costume/poncho/green
	name = "绿色斗篷"
	desc = "你那经典的不含倪哥种族主义的斗篷。不过这个是绿的。"
	icon_state = "greenponcho"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/poncho/red
	name = "红色斗篷"
	desc = "你那经典的不含倪哥种族主义的斗篷。不过这个是红的。"
	icon_state = "redponcho"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/poncho/ponchoshame
	name = "耻辱斗篷"
	desc = "由于不得已的假扮墨西哥人的身份生活下去，你和你的那件披风变得形影不离了。"
	icon_state = "ponchoshame"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/poncho/ponchoshame/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, SHAMEBRERO_TRAIT)

/obj/item/clothing/suit/costume/whitedress
	name = "白色裙子"
	desc = "一条精致的白色裙子。"
	icon_state = "white_dress"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDEBELT

/obj/item/clothing/suit/hooded/carp_costume
	name = "鲤鱼装"
	desc = "A costume made from 'synthetic' carp scales, it smells."
	icon_state = "carp_casual"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|FEET
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT //Space carp like space, so you should too
	clothing_flags = CARP_STYLE_FACTOR
	allowed = list(/obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/gun/ballistic/rifle/boltaction/harpoon)
	hoodtype = /obj/item/clothing/head/hooded/carp_hood

/obj/item/clothing/suit/hooded/carp_costume/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

/obj/item/clothing/head/hooded/carp_hood
	name = "鲤鱼兜帽"
	desc = "与鲤鱼装相匹配的兜帽。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "carp_casual"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR|HIDEEARS
	clothing_flags = CARP_STYLE_FACTOR

/obj/item/clothing/head/hooded/carp_hood/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5)

/obj/item/clothing/head/hooded/carp_hood/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot & ITEM_SLOT_HEAD)
		user.add_faction("carp")

/obj/item/clothing/head/hooded/carp_hood/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		user.remove_faction("carp")

/obj/item/clothing/suit/hooded/carp_costume/spaceproof
	name = "鲤鱼太空服"
	desc = "这是一项可疑的太空鲤鱼技术，你怀疑它经不起肉搏战的打击。"
	icon_state = "carp_suit"
	inhand_icon_state = "space_suit_syndicate"
	armor_type = /datum/armor/carp_costume_spaceproof
	allowed = list(/obj/item/tank/internals, /obj/item/gun/ballistic/rifle/boltaction/harpoon) //I'm giving you a hint here
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL // NOVA EDIT CHANGE - ORIGINAL: flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | CARP_STYLE_FACTOR
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	hoodtype = /obj/item/clothing/head/hooded/carp_hood/spaceproof
	resistance_flags = NONE

/datum/armor/carp_costume_spaceproof
	melee = -20
	bio = 100
	fire = 60
	acid = 75

/obj/item/clothing/head/hooded/carp_hood/spaceproof
	name = "鲤鱼头盔"
	desc = "它看起来像太空鲤鱼的头，闻起来也像。"
	icon_state = "carp_helm"
	armor_type = /datum/armor/carp_hood_spaceproof
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR //facial hair will clip with the helm, this'll need a dynamic_fhair_suffix at some point.
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE|THICKMATERIAL|SNUG_FIT|STACKABLE_HELMET_EXEMPT|CARP_STYLE_FACTOR
	body_parts_covered = HEAD
	resistance_flags = NONE
	flash_protect = FLASH_PROTECTION_WELDER
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF

/datum/armor/carp_hood_spaceproof
	melee = -20
	bio = 100
	fire = 60
	acid = 75

/obj/item/clothing/head/hooded/carp_hood/spaceproof/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)

/obj/item/clothing/suit/hooded/carp_costume/spaceproof/old
	name = "破损鲤鱼太空服"
	desc = "上面布满了咬痕和抓痕，但似乎功能完好。"
	slowdown = 1

/obj/item/clothing/suit/hooded/ian_costume //It's Ian, rub his bell- oh god what happened to his inside parts?
	name = "柯基装"
	desc = "一件看起来像有人做了一只人形柯基犬的服装，它不能保证你的肚子会被抚摸。"
	icon_state = "ian"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|FEET
	allowed = list()
	hoodtype = /obj/item/clothing/head/hooded/ian_hood
	dog_fashion = /datum/dog_fashion/back

/obj/item/clothing/head/hooded/ian_hood
	name = "柯基兜帽"
	desc = "一个看起来像柯基犬头的兜帽，它不能保证你得到狗饼干。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "ian"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/suit/hooded/bee_costume // It's Hip!
	name = "蜜蜂装"
	desc = "广大蜜蜂才是真正的女王！"
	icon_state = "bee"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	clothing_flags = THICKMATERIAL
	hoodtype = /obj/item/clothing/head/hooded/bee_hood

/obj/item/clothing/head/hooded/bee_hood
	name = "蜜蜂兜帽"
	desc = "与蜜蜂装相匹配的兜帽。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "bee"
	body_parts_covered = HEAD
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/suit/hooded/shark_costume // Blahaj
	name = "鲨鱼戏服"
	desc = "终于，有一件能配得上你最爱的毛绒玩具的戏服了。"
	icon_state = "shark"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "shark"
	body_parts_covered = CHEST|GROIN|ARMS
	clothing_flags = THICKMATERIAL
	hoodtype = /obj/item/clothing/head/hooded/shark_hood

/obj/item/clothing/suit/hooded/shark_costume/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

/obj/item/clothing/head/hooded/shark_hood
	name = "鲨鱼兜帽"
	desc = "鲨鱼戏服附带的兜帽。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "shark"
	body_parts_covered = HEAD
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/head/hooded/shark_hood/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5)

/obj/item/clothing/suit/hooded/shork_costume // Oh God Why
	name = "鲨鲨戏服"
	desc = "你为什么要这么做？"
	icon_state = "sharkcursed"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "sharkcursed"
	body_parts_covered = CHEST|GROIN|ARMS
	clothing_flags = THICKMATERIAL
	hoodtype = /obj/item/clothing/head/hooded/shork_hood

/obj/item/clothing/suit/hooded/shork_costume/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 4)

/obj/item/clothing/head/hooded/shork_hood
	name = "鲨鲨兜帽"
	desc = "鲨鲨戏服附带的兜帽。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "sharkcursed"
	body_parts_covered = HEAD
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/head/hooded/shork_hood/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 5)

/obj/item/clothing/suit/hooded/bloated_human //OH MY GOD WHAT HAVE YOU DONE!?!?!?
	name = "臃肿的人皮衣"
	desc = "一件用人皮做成的臃肿得可怕的衣服。"
	icon_state = "lingspacesuit"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|FEET
	allowed = list()
	hoodtype = /obj/item/clothing/head/hooded/human_head
	species_exception = list(/datum/species/golem) //Finally, flesh

/obj/item/clothing/head/hooded/human_head
	name = "臃肿的人头"
	desc = "一个可怕的臃肿和怪异的人头。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "lingspacehelmet"
	body_parts_covered = HEAD
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/suit/costume/shrine_maiden
	name = "巫女的服装"
	desc = "这让你恨不得退治一些妖怪。"
	icon_state = "shrine_maiden"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/costume/striped_sweater
	name = "条纹毛衣"
	desc = "让你想起某个人，但就是说不出是谁……"
	icon_state = "waldo_shirt"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/dracula
	name = "德古拉外套"
	desc = "看起来像是在古老的电影场景中的。"
	icon_state = "draculacoat"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/drfreeze_coat
	name = "冷冻博士的实验服"
	desc = "一件具有特殊功能并能实现冻结效果的实验室大衣。"
	icon_state = "drfreeze_coat"
	inhand_icon_state = null

/obj/item/clothing/suit/costume/gothcoat
	name = "哥特风大衣"
	desc = "对于那些想在酒吧角落里偷窥的人来说是完美的。"
	icon_state = "gothcoat"
	inhand_icon_state = null
	flags_inv = HIDEBELT

/obj/item/clothing/suit/costume/xenos
	name = "异形服"
	desc = "用壳质异形皮做成的衣服。"
	icon_state = "xenos"
	inhand_icon_state = "xenos_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDEBELT
	allowed = list(/obj/item/clothing/mask/facehugger/toy)

/obj/item/clothing/suit/costume/nemes
	name = "法老王外衣"
	desc = "豪华太空金字塔不包括在内。"
	icon_state = "pharoah"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/costume/changshan_red
	name = "红色长衫"
	desc = "带有华丽刺绣的丝绸长衫。"
	icon_state = "changshan_red"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/costume/changshan_blue
	name = "蓝色长衫"
	desc = "带有华丽刺绣的丝绸长衫。"
	icon_state = "changshan_blue"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/costume/cheongsam_red
	name = "红色旗袍"
	desc = "带有华丽刺绣的丝绸旗袍。"
	icon_state = "cheongsam_red"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/costume/cheongsam_blue
	name = "蓝色旗袍"
	desc = "带有华丽刺绣的丝绸旗袍。"
	icon_state = "cheongsam_blue"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS

/obj/item/clothing/suit/costume/bronze
	name = "青铜服"
	desc = "一套由青铜制成的又大又响的衣服，没有保护作用，看起来很不时尚。很好。"
	icon_state = "clockwork_cuirass_old"
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/tank/jetpack/captain,
		/obj/item/storage/belt/holster,
		//new
		/obj/item/toy/clockwork_watch,
		)
	armor_type = /datum/armor/costume_bronze
	custom_materials = list(/datum/material/bronze = SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/suit/hooded/mysticrobe
	name = "神秘的长袍"
	desc = "戴上它会让你觉得自己与宇宙的本质更契合……也显得你有点不负责任了。"
	icon_state = "mysticrobe"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = "mysticrobe"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/spellbook, /obj/item/book/bible)
	flags_inv = HIDEJUMPSUIT
	hoodtype = /obj/item/clothing/head/hooded/mysticrobe

/obj/item/clothing/head/hooded/mysticrobe
	name = "神秘主义兜帽"
	desc = "现实的天平向秩序倾斜。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "mystichood"
	inhand_icon_state = null
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR|HIDEFACE|HIDEMASK

/obj/item/clothing/suit/coordinator
	name = "舰长夹克"
	desc = "派对协调员的夹克，很时髦！"
	icon_state = "capformal"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	inhand_icon_state = null
	armor_type = /datum/armor/suit_coordinator

/datum/armor/suit_coordinator
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/suit/costume/hawaiian
	name = "夏威夷罩衫"
	desc = "一件适合在沙滩休闲穿的凉爽衬衫。"
	icon = 'icons/map_icons/clothing/suit/costume.dmi'
	icon_state = "/obj/item/clothing/suit/costume/hawaiian"
	post_init_icon_state = "hawaiian_shirt"
	inhand_icon_state = null
	greyscale_config = /datum/greyscale_config/hawaiian_shirt
	greyscale_config_worn = /datum/greyscale_config/hawaiian_shirt/worn
	greyscale_colors = "#313B82#CCCFF0"
	flags_1 = IS_PLAYER_COLORABLE_1
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/costume/hawaiian/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5)
	allowed += GLOB.personal_carry_allowed

/obj/item/clothing/suit/costume/football_armor
	name = "足球防护装备服"
	desc = "把球传给队友！"
	icon = 'icons/map_icons/clothing/suit/costume.dmi'
	icon_state = "/obj/item/clothing/suit/costume/football_armor"
	post_init_icon_state = "football_armor"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	greyscale_config = /datum/greyscale_config/football_armor
	greyscale_config_worn = /datum/greyscale_config/football_armor/worn
	greyscale_colors = "#D74722"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/costume/joker
	name = "戏剧演员外套"
	desc = "我是说，当喜剧演员不是必须要很有趣吗？"
	icon_state = "joker_coat"

/obj/item/clothing/suit/costume/joker/Initialize(mapload)
	. = ..()
	allowed += GLOB.personal_carry_allowed

/obj/item/clothing/suit/costume/deckers
	name = "戴克连帽衣"
	desc = "基础?基于什么？"
	icon_state = "decker_suit"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/costume/soviet
	name = "动员兵护具"
	desc = "应征报名！，由杜松公司主办的复刻第三次世界大战历史场景！"
	icon_state = "soviet_suit"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/costume/yuri
	name = "尤里新兵外衣"
	desc = "尤里是主人！由杜松公司赞助，重现心灵终结的历史！"
	icon_state = "yuri_coat"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/costume/tmc
	name = "\improper 迷失M.C外套"
	desc = "让所有人都知道你是奥尔德尼最好的飞车党。"
	icon_state = "tmc_suit"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/costume/pg
	name = "火药夹克"
	desc = "提醒安保他们给囚犯实施爆破刑罚时犯下的错误。"
	icon_state = "pg_suit"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/costume/irs
	name = "国税局夹克"
	desc = "我疯到敢去惹猫头鹰，但国税局？不不不，谢了！"
	icon_state = "irs_suit"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/costume/bear_suit
	name = "熊装"
	desc = "一件100%熊毛制成的套装。要是前面没有那条巨大的拉链，说服力可能会强得多。"
	icon_state = "bear"
	worn_icon_state = "bear"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	///Are we friendly with bears (wearing the full head/suit combo)?
	var/full_suit = FALSE

/obj/item/clothing/suit/costume/bear_suit/equipped(mob/living/user, slot)
	..()
	if(slot & ITEM_SLOT_OCLOTHING)
		var/mob/living/carbon/human/human_user = user
		make_friendly(user, human_user.head)

/obj/item/clothing/suit/costume/bear_suit/dropped(mob/living/user)
	..()
	if (!full_suit)
		return
	full_suit = FALSE
	var/mob/living/carbon/human/human_user = user
	UnregisterSignal(human_user.head, COMSIG_ITEM_DROPPED)
	user.remove_faction(FACTION_BEAR)

/obj/item/clothing/suit/costume/bear_suit/proc/make_friendly(mob/living/carbon/human/human_user, obj/item/clothing/head/costume/bearpelt/bear_head)
	if(!istype(human_user))
		return
	if(!bear_head || !istype(bear_head))
		return
	RegisterSignal(bear_head, COMSIG_ITEM_DROPPED, PROC_REF(helmet_drop))
	full_suit = TRUE
	human_user.add_faction(FACTION_BEAR)

/obj/item/clothing/suit/costume/bear_suit/proc/helmet_drop(datum/source, mob/living/user)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_ITEM_DROPPED)
	full_suit = FALSE
	user.remove_faction(FACTION_BEAR)
