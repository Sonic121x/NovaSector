/obj/item/uplink/old_radio
	name = "旧收音机"
	desc = "一台看起来布满灰尘的旧收音机。"

/obj/item/uplink/old_radio/Initialize(mapload, owner, tc_amount = 0)
	. = ..()
	var/datum/component/uplink/hidden_uplink = GetComponent(/datum/component/uplink)
	hidden_uplink.name = "旧收音机"

//Unrestricted MODs
/obj/item/mod/control/pre_equipped/elite/unrestricted
	req_access = null

//Syndie wep charger kit
/obj/item/storage/box/syndie_kit/recharger
	name = "盒装充能器套件"
	desc = "一个光滑、坚固的盒子，用于存放组装武器充能器的所有部件。"
	icon_state = "syndiebox"

/obj/item/storage/box/syndie_kit/recharger/PopulateContents()
	new /obj/item/circuitboard/machine/recharger(src)
	new /obj/item/stock_parts/capacitor/quadratic(src)
	new /obj/item/stack/sheet/iron/five(src)
	new /obj/item/stack/cable_coil/five(src)
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench(src)

//Back-up space suit
/obj/item/storage/box/syndie_kit/space_suit
	name = "盒装太空服与头盔"
	desc = "一个光滑、坚固的盒子，用于存放应急太空服。"
	icon_state = "syndiebox"
	illustration = "syndiesuit"
	storage_type = /datum/storage/box/syndicate_space

/datum/storage/box/syndicate_space
	max_specific_storage = WEIGHT_CLASS_BULKY
	max_slots = 2

/obj/item/storage/box/syndie_kit/space_suit/PopulateContents()
	switch(pick(list("red", "green", "dgreen", "blue", "orange", "black")))
		if("green")
			new /obj/item/clothing/head/helmet/space/syndicate/green(src)
			new /obj/item/clothing/suit/space/syndicate/green(src)
		if("dgreen")
			new /obj/item/clothing/head/helmet/space/syndicate/green/dark(src)
			new /obj/item/clothing/suit/space/syndicate/green/dark(src)
		if("blue")
			new /obj/item/clothing/head/helmet/space/syndicate/blue(src)
			new /obj/item/clothing/suit/space/syndicate/blue(src)
		if("red")
			new /obj/item/clothing/head/helmet/space/syndicate(src)
			new /obj/item/clothing/suit/space/syndicate(src)
		if("orange")
			new /obj/item/clothing/head/helmet/space/syndicate/orange(src)
			new /obj/item/clothing/suit/space/syndicate/orange(src)
		if("black")
			new /obj/item/clothing/head/helmet/space/syndicate/black(src)
			new /obj/item/clothing/suit/space/syndicate/black(src)

//Spy
/obj/item/clothing/suit/jacket/det_suit/noir/armoured
	armor_type = /datum/armor/heister

/obj/item/clothing/head/beret/frenchberet/armoured
	armor_type = /datum/armor/cosmetic_sec

/obj/item/clothing/under/suit/black/armoured
	armor_type = /datum/armor/clothing_under/syndicate

/obj/item/clothing/under/suit/black/skirt/armoured
	armor_type = /datum/armor/clothing_under/syndicate

/obj/item/storage/belt/holster/detective/dark
	name = "深色皮革枪套"
	icon_state = "syndicate_holster"

/obj/item/storage/box/syndie_kit/gunman_outfit
	name = "枪手服装套装"
	desc = "一个装满装甲且时尚服装的盒子，专为有抱负的枪手准备。"

/obj/item/clothing/suit/jacket/leather_trenchcoat/gunman
	name = "皮革大衣"
	desc = "一件装甲皮革大衣，旨在成为任何有抱负枪手的首选穿着。"
	body_parts_covered = CHEST|GROIN|ARMS
	armor_type = /datum/armor/leather_gunman

/datum/armor/leather_gunman
	melee = 45
	bullet = 40
	laser = 40
	energy = 50
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/under/pants/track/robohand
	name = "狠角色长裤"
	desc = "异常坚固却又柔软的黑色长裤，似乎带有一些装甲衬垫以提供额外保护。"
	armor_type = /datum/armor/clothing_under/robohand

/datum/armor/clothing_under/robohand
	melee = 20
	bullet = 20
	laser = 20
	energy = 20
	bomb = 20

/obj/item/clothing/glasses/sunglasses/robohand
	name = "狠角色太阳镜"
	desc = "用于提供基本眼部保护的异常古老技术。增强的屏蔽层能阻挡闪光。这些看起来似乎是防弹的？"
	body_parts_covered = HEAD //What do you mean glasses don't protect your head? Of course they do. Cyberpunk has flying cars(mostly intentional)!
	armor_type = /datum/armor/sunglasses_robohand

/datum/armor/sunglasses_robohand
	melee = 20
	bullet = 60
	laser = 20
	energy = 20
	bomb = 20
	wound = 5

//More items
/obj/item/guardian_creator/tech/choose/traitor/opfor
	allow_changeling = TRUE

/obj/item/codeword_granter
	name = "暗语手册"
	desc = "一本黑色手册，封面上印有一个红色的S，由工厂最精良的印刷机满怀爱意地压印而成。"
	icon = 'modular_nova/modules/opposing_force/icons/items.dmi'
	icon_state = "codeword_book"
	/// Number of charges the book has, limits the number of times it can be used.
	var/charges = 1


/obj/item/codeword_granter/attack_self(mob/living/user)
	if(!isliving(user))
		return

	to_chat(user, span_boldannounce("你开始浏览[src]，突然感到被灌输了以下暗语的知识："))

	user.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_phrase_regex, "blue", src)
	user.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_response_regex, "red", src)
	to_chat(user, "<b>Code Phrases</b>: [jointext(GLOB.syndicate_code_phrase, ", ")]")
	to_chat(user, "<b>暗号回应</b>: [span_red("[jointext(GLOB.syndicate_code_response, ", ")]")]")

	use_charge(user)


/obj/item/codeword_granter/attack(mob/living/attacked_mob, mob/living/user)
	if(!istype(attacked_mob) || !istype(user))
		return

	if(attacked_mob == user)
		attack_self(user)
		return

	playsound(loc, SFX_PUNCH, 25, TRUE, -1)

	if(attacked_mob.stat == DEAD)
		attacked_mob.visible_message(span_danger("[user] 用 [src] 拍打着 [attacked_mob] 毫无生气的尸体。"), span_userdanger("[user] 用 [src] 拍打你毫无生气的尸体。"), span_hear("你听到拍打声。"))
	else
		attacked_mob.visible_message(span_notice("[user] 用 [src] 敲打 [attacked_mob] 的头来教导 [attacked_mob.p_them()]！"), span_boldnotice("As [user] hits you with [src], you feel suddenly imparted with the knowledge of some [span_red("specific words")]."), span_hear("你听到拍打声。"))
		attacked_mob.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_phrase_regex, "blue", src)
		attacked_mob.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_response_regex, "red", src)
		to_chat(attacked_mob, span_boldnotice("你突然感到被灌输了以下暗号的知识："))
		to_chat(attacked_mob, "<b>Code Phrases</b>: [span_blue("[jointext(GLOB.syndicate_code_phrase, ", ")]")]")
		to_chat(attacked_mob, "<b>Code Responses</b>: [span_red("[jointext(GLOB.syndicate_code_response, ", ")]")]")
		use_charge(user)


/obj/item/codeword_granter/proc/use_charge(mob/user)
	charges--

	if(!charges)
		var/turf/src_turf = get_turf(src)
		src_turf.visible_message(span_warning("[src] 的封面和内容开始移动和变化！它从你手中滑落了！"))
		new /obj/item/book/manual/random(src_turf)
		qdel(src)


/obj/item/antag_granter
	icon = 'modular_nova/modules/opposing_force/icons/items.dmi'
	/// What antag datum to give
	var/antag_datum = /datum/antagonist/traitor
	/// What to tell the user when they use the granter
	var/user_message = ""


/obj/item/antag_granter/attack(mob/living/target_mob, mob/living/user, params)
	. = ..()

	if(target_mob != user) // As long as you're attacking yourself it counts.
		return
	attack_self(user)


/obj/item/antag_granter/attack_self(mob/user, modifiers)
	. = ..()
	if(!isliving(user) || !user.mind)
		return FALSE

	to_chat(user, span_notice(user_message))
	user.mind.add_antag_datum(antag_datum)
	qdel(src)
	return TRUE

/obj/item/antag_granter/changeling
	name = "病毒注射器"
	desc = "一个蓝色的注射器，里面装满了某种粘稠的红色物质。除了靠近大针头的橙色警告条纹外，没有任何标记。"
	icon_state = "changeling_injector"
	antag_datum = /datum/antagonist/changeling
	user_message = "As you inject the substance into yourself, you start to feel... <span class='red'><b>better</b></span>."


/obj/item/antag_granter/heretic
	name = "奇怪的书"
	desc = "一本紫色的书，封面上有一只绿色的眼睛。你发誓它在看着你...."
	icon_state = "heretic_granter"
	antag_datum = /datum/antagonist/heretic
	user_message = "As you open the book, you see a great flash as <span class='hypnophrase'>the world becomes all the clearer for you</span>."

/obj/item/antag_granter/clock_cultist
	name = "黄铜装置"
	desc = "一个黄铜制成的齿轮状装置，中心悬浮着一块玻璃透镜。"
	icon = 'modular_nova/modules/clock_cult/icons/clockwork_objects.dmi'
	icon_state = "vanguard_cogwheel"
	antag_datum = /datum/antagonist/clock_cultist/solo
	user_message = "A whirring fills your ears as <span class='brass'>knowledge of His Eminence fills your mind</span>."

/obj/item/antag_granter/clock_cultist/attack_self(mob/user, modifiers)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/clockwork/clockwork_slab/slab = new
	user.put_in_hands(slab, FALSE)
