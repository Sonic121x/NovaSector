/* Clown Items
 * Contains:
 * Soap
 * Bike Horns
 * Air Horns
 * Canned Laughter
 * Balloon Mallet
 */

/*
 * Soap
 */

/obj/item/soap
	name = "肥皂"
	desc = "一块便宜的肥皂。没有气味。"
	gender = PLURAL
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "soap"
	inhand_icon_state = "soap"
	worn_icon_state = "soap"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/cleanspeed = 3.5 SECONDS //slower than mop
	force_string = "robust... against germs"
	var/uses = 100

/obj/item/soap/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 80)
	AddComponent(/datum/component/cleaner, cleanspeed, 0.1, pre_clean_callback=CALLBACK(src, PROC_REF(should_clean)), on_cleaned_callback=CALLBACK(src, PROC_REF(decreaseUses))) //less scaling for soapies

/obj/item/soap/grind_results()
	return list(/datum/reagent/lye = 10)

/obj/item/soap/examine(mob/user)
	. = ..()
	var/max_uses = initial(uses)
	var/msg = "It looks like it just came out of the package."
	if(uses != max_uses)
		var/percentage_left = uses / max_uses
		switch(percentage_left)
			if(0 to 0.15)
				msg = "There's just a tiny bit left of what it used to be, you're not sure it'll last much longer."
			if(0.15 to 0.30)
				msg = "It's dissolved quite a bit, but there's still some life to it."
			if(0.30 to 0.50)
				msg = "It's past its prime, but it's definitely still good."
			if(0.50 to 0.75)
				msg = "It's started to get a little smaller than it used to be, but it'll definitely still last for a while."
			else
				msg = "It's seen some light use, but it's still pretty fresh."
	. += span_notice("[msg]")

/obj/item/soap/homemade
	desc = "一块自制的肥皂。闻起来……嗯……"
	icon_state = "soapgibs"
	inhand_icon_state = "soapgibs"
	worn_icon_state = "soapgibs"
	cleanspeed = 3 SECONDS // faster than base soap to reward chemists for going to the effort

/obj/item/soap/homemade/grind_results()
	return list(/datum/reagent/consumable/liquidgibs = 9, /datum/reagent/lye = 9)

/obj/item/soap/nanotrasen
	desc = "一块纳米特拉森品牌的重型肥皂。闻起来有等离子体的味道。"
	icon_state = "soapnt"
	inhand_icon_state = "soapnt"
	worn_icon_state = "soapnt"
	cleanspeed = 2.8 SECONDS //janitor gets this
	uses = 300

/obj/item/soap/nanotrasen/grind_results()
	return list(/datum/reagent/toxin/plasma = 10, /datum/reagent/lye = 10)

/obj/item/soap/deluxe
	desc = "一块华夫饼公司品牌的豪华肥皂。闻起来有高档奢华的气息。"
	icon_state = "soapdeluxe"
	inhand_icon_state = "soapdeluxe"
	worn_icon_state = "soapdeluxe"
	cleanspeed = 2 SECONDS //captain gets one of these

/obj/item/soap/deluxe/grind_results()
	return list(/datum/reagent/consumable/aloejuice = 10, /datum/reagent/lye = 10)

/obj/item/soap/syndie
	desc = "一块由强力化学剂制成、能更快溶解血液的不可靠肥皂。"
	icon_state = "soapsyndie"
	inhand_icon_state = "soapsyndie"
	worn_icon_state = "soapsyndie"
	cleanspeed = 0.5 SECONDS //faster than mops so it's useful for traitors who want to clean crime scenes

/obj/item/soap/syndie/grind_results()
	return list(/datum/reagent/toxin/acid = 10, /datum/reagent/lye = 10)

/obj/item/soap/drone
	name = "\improper 集成肥皂模块"
	inhand_icon_state = "soapnt"
	worn_icon_state = "soapnt"
	cleanspeed = 0.5 SECONDS //can be changed if someone isn't happy
	uses = INFINITY

/obj/item/soap/omega
	name = "\improper 欧米茄肥皂"
	desc = "人类已知最先进的肥皂。细菌终结的开端。"
	icon_state = "soapomega"
	inhand_icon_state = "soapomega"
	worn_icon_state = "soapomega"
	cleanspeed = 0.3 SECONDS //Only the truest of mind soul and body get one of these
	uses = 800 //In the Greek numeric system, Omega has a value of 800

/obj/item/soap/omega/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 120) //Same slipperiness as Super Lube

/obj/item/soap/omega/grind_results()
	return list(
		/datum/reagent/consumable/potato_juice = 9,
		/datum/reagent/consumable/ethanol/lizardwine = 9,
		/datum/reagent/monkey_powder = 9,
		/datum/reagent/drug/krokodil = 9,
		/datum/reagent/toxin/acid/nitracid = 9,
		/datum/reagent/baldium = 9,
		/datum/reagent/consumable/ethanol/hooch = 9,
		/datum/reagent/bluespace = 9,
		/datum/reagent/drug/pumpup = 9,
		/datum/reagent/consumable/space_cola = 9,
		/datum/reagent/iron = 9
	)

/obj/item/soap/omega/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正在用 [src] 把自己从时间线上擦除！看起来 [user.p_theyre()] 试图自杀！"))
	new /obj/structure/chrono_field(user.loc, user)
	return MANUAL_SUICIDE

/obj/item/paper/fluff/stations/soap
	name = "古老的清洁工诗歌"
	desc = "一张经手多人的旧纸。"
	default_raw_text = "<h1><b>The Legend of the Omega Soap</b></h1><br><br>Essence of <b>potato</b>, juice, not grind.<br>A <b>lizard's</b> tail, turned into wine.<br><b>Powder of monkey</b>, to help the workload.<br>Some <b>Krokodil</b>, because meth would explode.<br><b>Nitric acid</b> and <b>Baldium</b>, for organic dissolving.<br>A cup full of <b>hooch</b>, for sins' absolving.<br>A dash of <b>bluespace dust</b>, for removal of stains.<br>A syringe of <b>Pump-Up</b>, Security's worst of pains.<br>A can of <b>Space Cola</b>, to watch the dirt fade.<br><b>Heat</b> as hot as possible, let the soap be your blade.<br>With <b>ten</b> units of each, the soap that topples all will be made."

/obj/item/soap/suicide_act(mob/living/user)
	user.say(";FFFFFFFFFFFFFFFFUUUUUUUDGE!!", forced="soap suicide")
	user.visible_message(span_suicide("[user] 将 [src] 举到 [user.p_their()] 嘴边，疯狂地啃咬，产生浓密的泡沫！[user.p_They()] 再也得不到那把BB枪了！"))
	do_foam(1, src, get_turf(user))
	return TOXLOSS

/obj/item/soap/proc/should_clean(datum/cleaning_source, atom/atom_to_clean, mob/living/cleaner)
	. = CLEAN_ALLOWED
	if(!check_allowed_items(atom_to_clean))
		. |= CLEAN_NO_XP|CLEAN_NO_WASH

/**
 * Decrease the number of uses the bar of soap has.
 *
 * The higher the cleaning skill, the less likely the soap will lose a use.
 * Arguments
 * * source - the source of the cleaning
 * * target - The atom that is being cleaned
 * * user - The mob that is using the soap to clean.
 */
/obj/item/soap/proc/decreaseUses(datum/source, atom/target, mob/living/user, clean_succeeded)
	if(!clean_succeeded)
		return
	var/skillcheck = 1
	if(user?.mind)
		skillcheck = user.mind.get_skill_modifier(/datum/skill/cleaning, SKILL_SPEED_MODIFIER)
	if(prob(skillcheck*100)) //higher level = more uses assuming RNG is nice
		uses--
	if(uses <= 0)
		noUses(user)

/obj/item/soap/proc/noUses(mob/user)
	to_chat(user, span_warning("[src] 碎成了小碎片！"))
	qdel(src)

/obj/item/soap/nanotrasen/cyborg
	name = "内置肥皂"

/obj/item/soap/nanotrasen/cyborg/noUses(mob/user)
	to_chat(user, span_warning("[src] 的化学物质用完了！前往充电器补充。"))

/obj/item/soap/nanotrasen/cyborg/should_clean(datum/cleaning_source, atom/atom_to_clean, mob/living/cleaner)
	if(uses <= 0)
		return CLEAN_BLOCKED
	return ..()

/*
 * Bike Horns
 */

/obj/item/bikehorn
	name = "自行车喇叭"
	desc = "一个从自行车上拆下来的喇叭。传闻它们是用回收的小丑制成的。"
	icon = 'icons/obj/art/horn.dmi'
	icon_state = "bike_horn"
	inhand_icon_state = "bike_horn"
	worn_icon_state = "horn"
	lefthand_file = 'icons/mob/inhands/equipment/horns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/horns_righthand.dmi'
	throwforce = 0
	hitsound = null //To prevent tap.ogg playing, as the item lacks of force
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	throw_speed = 3
	throw_range = 7
	attack_verb_continuous = list("HONKS")
	attack_verb_simple = list("HONK")
	///sound file given to the squeaky component we make in Initialize() so sub-types can specify their own sound
	var/sound_file = 'sound/items/bikehorn.ogg'

/obj/item/bikehorn/Initialize(mapload)
	. = ..()
	var/list/sound_list = list()
	sound_list[sound_file] = 1
	AddComponent(/datum/component/squeak, sound_list, 50, falloff_exponent = 20)

/obj/item/bikehorn/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(user != M && ishuman(user))
		var/mob/living/carbon/human/H = user
		if (HAS_TRAIT(H, TRAIT_CLUMSY)) //only clowns can unlock its true powers
			M.add_mood_event("honk", /datum/mood_event/honk)
	return ..()

/obj/item/bikehorn/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 庄重地将 [src] 对准了 [user.p_their()] 的太阳穴！看起来 [user.p_theyre()] 想要自杀！"))
	playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE)
	return BRUTELOSS

//air horn
/obj/item/bikehorn/airhorn
	name = "空气喇叭"
	desc = "好家伙，你从哪儿搞来的？"
	icon_state = "air_horn"
	worn_icon_state = "horn_air"
	sound_file = 'sound/items/airhorn/airhorn2.ogg'

/datum/crafting_recipe/airhorn
	name = "空气喇叭"
	result = /obj/item/bikehorn/airhorn
	reqs = list(
		/obj/item/bikehorn = 1,
		/obj/item/toy/crayon/spraycan = 1,
	)
	category = CAT_ENTERTAINMENT

//golden bikehorn
/obj/item/bikehorn/golden
	name = "金色自行车喇叭"
	desc = "金色的？很明显，这是用香蕉矿做的！哔哔！"
	icon_state = "gold_horn"
	inhand_icon_state = "gold_horn"
	worn_icon_state = "horn_gold"
	COOLDOWN_DECLARE(golden_horn_cooldown)
	custom_materials = list(/datum/material/bananium = SHEET_MATERIAL_AMOUNT * 5)

/obj/item/bikehorn/golden/attack()
	flip_mobs()
	return ..()

/obj/item/bikehorn/golden/attack_self(mob/user)
	flip_mobs()
	..()

/obj/item/bikehorn/golden/proc/flip_mobs(mob/living/carbon/M, mob/user)
	if(!COOLDOWN_FINISHED(src, golden_horn_cooldown))
		return
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(!HAS_TRAIT(M, TRAIT_DEAF))
			M.emote("flip")
	COOLDOWN_START(src, golden_horn_cooldown, 1 SECONDS)

/obj/item/bikehorn/rubberducky/plasticducky
	name = "塑料小鸭"
	desc = "这是一个可爱的沐浴玩具的廉价塑料仿制品。"
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/bikehorn/rubberducky
	name = "橡皮小鸭"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~" //thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	inhand_icon_state = "rubberducky"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	worn_icon_state = "duck"
	sound_file = 'sound/effects/quack.ogg'

//canned laughter
/obj/item/reagent_containers/cup/soda_cans/canned_laughter
	name = "罐装笑声"
	desc = "光是看着这个就让人想咯咯笑。"
	icon_state = "laughter"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/laughter = 50)

//balloon mallet
/obj/item/balloon_mallet
	name = "气球锤"
	desc = "It's a mallet, a weapon known for being heavy, but made from notoriously light balloons. Air inside removes any force from the swings. It'd be quite embarrassing to get hit by this."
	icon = 'icons/obj/weapons/hammer.dmi'
	icon_state = "balloon_mallet"
	inhand_icon_state = "balloon_mallet"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/hammers_righthand.dmi'
	siemens_coefficient = 0
	force = 1
	throw_speed = 1
	throwforce = 1
	throw_range = 1
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_continuous = list("mallets", "smoother")
	attack_verb_simple = list("mallet", "smoother")
	max_integrity = 20
	armor_type = /datum/armor/item_banhammer
	resistance_flags = FIRE_PROOF

/obj/item/balloon_mallet/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user,TRAIT_BALLOON_SUTRA))
		. += "A sacred weapon of the higher castes from the clown planet, used to strike fear into the hearts of their foes. Wield it with care."

/obj/item/balloon_mallet/attack(mob/living/target, mob/living/user)
	playsound(loc, 'sound/mobs/non-humanoids/clown/hehe.ogg', 20)
	if (!isliving(target))
		return
	switch(target.mob_mood.sanity)
		if (SANITY_INSANE to SANITY_CRAZY)
			force = 8
		if (SANITY_UNSTABLE to SANITY_DISTURBED)
			force = 4
			target.add_mood_event("humiliated", /datum/mood_event/mallet_humiliation)
		if (SANITY_NEUTRAL to SANITY_GREAT)
			target.add_mood_event("humiliated", /datum/mood_event/mallet_humiliation)

	if(user.combat_mode)
		return ..(target, user)
