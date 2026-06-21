/obj/item/claymore
	name = "阔剑"
	desc = "你还站在这儿盯着它看什么？快去杀敌！"
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "claymore"
	inhand_icon_state = "claymore"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 40
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("attacks", "slashes", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "slice", "tear", "lacerate", "rip", "dice", "cut")
	block_chance = 50
	block_sound = 'sound/items/weapons/parry.ogg'
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor_type = /datum/armor/item_claymore
	resistance_flags = FIRE_PROOF
	var/list/alt_continuous = list("stabs", "pierces", "impales")
	var/list/alt_simple = list("stab", "pierce", "impale")

/datum/armor/item_claymore
	fire = 100
	acid = 50

/obj/item/claymore/Initialize(mapload)
	. = ..()
	alt_continuous = string_list(alt_continuous)
	alt_simple = string_list(alt_simple)
	make_stabby()
	AddComponent(/datum/component/butchering, \
	speed = 4 SECONDS, \
	effectiveness = 105, \
	)

// Applies alt sharpness component, for overrides
/obj/item/claymore/proc/make_stabby()
	AddComponent(/datum/component/alternative_sharpness, SHARP_POINTY, alt_continuous, alt_simple, -15)

/obj/item/claymore/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正摔向 [src]！看起来 [user.p_theyre()] 试图自杀！"))
	return BRUTELOSS

/obj/item/claymore/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK || attack_type == LEAP_ATTACK || attack_type == OVERWHELMING_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight, and also you aren't going to really block someone full body tackling you with a sword. Or a road roller, if one happened to hit you.
	return ..()

//statistically similar to e-cutlasses
/obj/item/claymore/cutlass
	name = "弯刀"
	desc = "一把海盗风格的剑，被海盗们用来\"协商\"财宝的转移。"
	icon_state = "cutlass"
	inhand_icon_state = "cutlass"
	worn_icon_state = "cutlass"
	slot_flags = ITEM_SLOT_BACK
	force = 30
	throwforce = 20
	throw_speed = 3
	throw_range = 5
	armour_penetration = 35

/obj/item/claymore/cutlass/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item) //closed sword guard

/obj/item/claymore/cutlass/old
	name = "旧式弯刀"
	desc = parent_type::desc + "这把看起来有点旧了。"
	force = 24
	throwforce = 17
	armour_penetration = 20
	block_chance = 30

/obj/item/claymore/carrot
	name = "胡萝卜剑"
	desc = "一把全尺寸的胡萝卜剑。对眼睛绝对<b>不</b>好，再也不是了。"
	icon_state = "carrot_sword"
	inhand_icon_state = "carrot_sword"
	worn_icon_state = "carrot_sword"
	flags_1 = NONE
	force = 19
	throwforce = 7
	throw_speed = 3
	throw_range = 7
	armour_penetration = 5
	block_chance = 10
	resistance_flags = NONE

//bootleg claymore
/obj/item/claymore/shortsword
	name = "短剑"
	desc = "A mercenary's sword, chipped and worn from battles long gone. You could say it is a swordsman's shortsword short sword."
	icon_state = "shortsword"
	inhand_icon_state = "shortsword"
	worn_icon_state = "shortsword"
	slot_flags = ITEM_SLOT_BELT
	force = 20
	demolition_mod = 0.75
	block_chance = 30

/obj/item/claymore/highlander //ALL COMMENTS MADE REGARDING THIS SWORD MUST BE MADE IN ALL CAPS
	desc = "<b><i>只能有一个，那就是你！！！</i></b>\nActivate在手中激活它，指向最近的受害者。"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = DROPDEL //WOW BRO YOU LOST AN ARM, GUESS WHAT YOU DONT GET YOUR SWORD ANYMORE //I CANT BELIEVE SPOOKYDONUT WOULD BREAK THE REQUIREMENTS
	slot_flags = null
	block_chance = 0 //RNG WON'T HELP YOU NOW, PANSY
	light_range = 3
	attack_verb_continuous = list("brutalizes", "eviscerates", "disembowels", "hacks", "carves", "cleaves") //ONLY THE MOST VISCERAL ATTACK VERBS
	attack_verb_simple = list("brutalize", "eviscerate", "disembowel", "hack", "carve", "cleave")
	var/notches = 0 //HOW MANY PEOPLE HAVE BEEN SLAIN WITH THIS BLADE
	var/obj/item/disk/nuclear/nuke_disk //OUR STORED NUKE DISK

/obj/item/claymore/highlander/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER_TRAIT)
	START_PROCESSING(SSobj, src)

/obj/item/claymore/highlander/Destroy()
	if(nuke_disk)
		nuke_disk.forceMove(get_turf(src))
		nuke_disk.visible_message(span_warning("核弹盘变得脆弱了！"))
		nuke_disk = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/claymore/highlander/process()
	if(ishuman(loc))
		var/mob/living/carbon/human/holder = loc
		holder.layer = ABOVE_ALL_MOB_LAYER //NO HIDING BEHIND PLANTS FOR YOU, DICKWEED (HA GET IT, BECAUSE WEEDS ARE PLANTS)
		ADD_TRAIT(holder, TRAIT_NOBLOOD, HIGHLANDER_TRAIT) //AND WE WON'T BLEED OUT LIKE COWARDS
	else
		if(!(flags_1 & ADMIN_SPAWNED_1))
			qdel(src)


/obj/item/claymore/highlander/pickup(mob/living/user)
	. = ..()
	to_chat(user, span_notice("苏格兰之力护佑着你！你免疫所有击晕与击倒效果。"))
	user.ignore_slowdown(HIGHLANDER_TRAIT)
	user.add_stun_absorption(
		source = HIGHLANDER_TRAIT,
		message = span_warning("%EFFECT_OWNER受到苏格兰之力的保护！"),
		self_message = span_boldwarning("苏格兰之力吸收了这次击晕！"),
		examine_message = span_warning("%EFFECT_OWNER_THEYRE受到苏格兰之力的保护！"),
	)

/obj/item/claymore/highlander/dropped(mob/living/user)
	. = ..()
	user.unignore_slowdown(HIGHLANDER_TRAIT)
	user.remove_stun_absorption(HIGHLANDER_TRAIT)

/obj/item/claymore/highlander/examine(mob/user)
	. = ..()
	. += "It has [!notches ? "nothing" : "[notches] notches"] scratched into the blade."
	if(nuke_disk)
		. += span_boldwarning("它正握着核弹盘！")

/obj/item/claymore/highlander/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!QDELETED(target) && target.stat == DEAD && target.mind?.has_antag_datum(/datum/antagonist/highlander))
		user.fully_heal() //STEAL THE LIFE OF OUR FALLEN FOES
		add_notch(user)
		target.visible_message(span_warning("[target]在[user]的猛击下化为尘埃！"), span_userdanger("当你倒下时，你的身体化为了尘埃！"))
		target.investigate_log("has been dusted by a highlander claymore.", INVESTIGATE_DEATHS)
		target.dust()

/obj/item/claymore/highlander/attack_self(mob/living/user)
	var/closest_victim
	var/closest_distance = 255
	for(var/mob/living/carbon/human/scot in GLOB.player_list - user)
		if(scot.mind?.has_antag_datum(/datum/antagonist/highlander) && (!closest_victim || get_dist(user, closest_victim) < closest_distance))
			closest_victim = scot
	for(var/mob/living/silicon/robot/siliscot in GLOB.player_list - user)
		if(siliscot.mind?.has_antag_datum(/datum/antagonist/highlander) && (!closest_victim || get_dist(user, closest_victim) < closest_distance))
			closest_victim = siliscot

	if(!closest_victim)
		to_chat(user, span_warning("[src]嗡鸣片刻后黯淡下来。或许附近没有其他人了。"))
		return
	to_chat(user, span_danger("[src]嗡鸣着指向[dir2text(get_dir(user, closest_victim))]方向。"))

/obj/item/claymore/highlander/IsReflect()
	return 1 //YOU THINK YOUR PUNY LASERS CAN STOP ME?

/obj/item/claymore/highlander/proc/add_notch(mob/living/user) //DYNAMIC CLAYMORE PROGRESSION SYSTEM - THIS IS THE FUTURE
	notches++
	force++
	var/new_name = name
	switch(notches)
		if(1)
			to_chat(user, span_notice("你的首次击杀——希望这只是众多中的第一个。你在[src]的剑刃上刻下一道凹痕。"))
			to_chat(user, span_warning("你感到败亡敌人的灵魂正涌入你的剑刃，治愈你的创伤！"))
			new_name = "notched claymore"
		if(2)
			to_chat(user, span_notice("又一人倒在你面前。又一个灵魂与你融为一体。剑刃上再添一道凹痕。"))
			new_name = "double-notched claymore"
			add_atom_colour(rgb(255, 235, 235), ADMIN_COLOUR_PRIORITY)
		if(3)
			to_chat(user, span_notice("You're beginning to</span> <span class='danger'><b>relish</b> the <b>thrill</b> of <b>battle.</b>"))
			new_name = "triple-notched claymore"
			add_atom_colour(rgb(255, 215, 215), ADMIN_COLOUR_PRIORITY)
		if(4)
			to_chat(user, span_notice("You've lost count of</span> <span class='bolddanger'>how many you've killed."))
			new_name = "many-notched claymore"
			add_atom_colour(rgb(255, 195, 195), ADMIN_COLOUR_PRIORITY)
		if(5)
			to_chat(user, span_bolddanger("五个声音在你脑海中回响，为这场屠杀欢呼。"))
			new_name = "battle-tested claymore"
			add_atom_colour(rgb(255, 175, 175), ADMIN_COLOUR_PRIORITY)
		if(6)
			to_chat(user, span_bolddanger("这就是维京人的感受吗？当你斩杀第六个敌人时，荣耀的幻象充斥脑海。"))
			new_name = "battle-scarred claymore"
			add_atom_colour(rgb(255, 155, 155), ADMIN_COLOUR_PRIORITY)
		if(7)
			to_chat(user, span_bolddanger("杀戮。屠戮。<i>征服。</i>"))
			new_name = "vicious claymore"
			add_atom_colour(rgb(255, 135, 135), ADMIN_COLOUR_PRIORITY)
		if(8)
			to_chat(user, span_userdanger("IT NEVER GETS OLD. THE <i>SCREAMING</i>. THE <i>BLOOD</i> AS IT <i>SPRAYS</i> ACROSS YOUR <i>FACE.</i>"))
			new_name = "bloodthirsty claymore"
			add_atom_colour(rgb(255, 115, 115), ADMIN_COLOUR_PRIORITY)
		if(9)
			to_chat(user, span_userdanger("又一人倒在了你的打击之下。又一个不配活着的弱者。"))
			new_name = "gore-stained claymore"
			add_atom_colour(rgb(255, 95, 95), ADMIN_COLOUR_PRIORITY)
		if(10)
			user.visible_message(span_warning("[user]的眼中燃起了复仇的火焰！"), \
			span_userdanger("你感受到瓦尔哈拉的力量在你体内奔涌！<i>只能有一个！！！</i>"))
			new_name = "GORE-DRENCHED CLAYMORE OF [pick("THE WHIMSICAL SLAUGHTER", "A THOUSAND SLAUGHTERED CATTLE", "GLORY AND VALHALLA", "ANNIHILATION", "OBLITERATION")]"
			icon_state = "claymore_gold"
			inhand_icon_state = "cultblade"
			lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
			righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
			remove_atom_colour(ADMIN_COLOUR_PRIORITY)
			user.update_held_items()

	name = new_name
	playsound(user, 'sound/items/tools/screwdriver2.ogg', 50, TRUE)

/obj/item/claymore/highlander/robot //BLOODTHIRSTY BORGS NOW COME IN PLAID
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "claymore_cyborg"

/obj/item/claymore/highlander/robot/Initialize(mapload)
	. = ..()
	if(!iscyborg(loc))
		return INITIALIZE_HINT_QDEL

/obj/item/claymore/highlander/robot/process()
	loc.layer = ABOVE_ALL_MOB_LAYER

/obj/item/claymore/gladius
	name = "罗马短剑"
	desc = "一把短小但威力强大的剑，深受最近复活的古代战士喜爱。"
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "gladius"
	inhand_icon_state = "gladius"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	sharpness = SHARP_POINTY
	attack_verb_continuous = list("stabs", "cuts")
	attack_verb_simple = list("stab", "cut")
	slot_flags = null
	sound_vary = TRUE
	block_sound = 'sound/items/weapons/parry.ogg'
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	pickup_sound = SFX_KNIFE_PICKUP
	drop_sound = SFX_KNIFE_DROP
