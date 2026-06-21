GLOBAL_LIST_INIT(biblenames, list(
	"Bible",
	"Quran",
	"Scrapbook",
	"Burning Bible",
	"Clown Bible",
	"Banana Bible",
	"Creeper Bible",
	"White Bible",
	"Holy Light",
	"The God Delusion",
	"Tome",
	"The King in Yellow",
	"Ithaqua",
	"Scientology",
	"Melted Bible",
	"Necronomicon",
	"Insulationism",
	"Guru Granth Sahib",
	"Kojiki",
))
//If you get these two lists not matching in size, there will be runtimes and I will hurt you in ways you couldn't even begin to imagine
// if your bible has no custom itemstate, use one of the existing ones
GLOBAL_LIST_INIT(biblestates, list(
	"bible",
	"koran",
	"scrapbook",
	"burning",
	"honk1",
	"honk2",
	"creeper",
	"white",
	"holylight",
	"atheist",
	"tome",
	"kingyellow",
	"ithaqua",
	"scientology",
	"melted",
	"necronomicon",
	"insuls",
	"gurugranthsahib",
	"kojiki",
))
GLOBAL_LIST_INIT(bibleitemstates, list(
	"bible",
	"koran",
	"scrapbook",
	"burning",
	"honk1",
	"honk2",
	"creeper",
	"white",
	"holylight",
	"atheist",
	"tome",
	"kingyellow",
	"ithaqua",
	"scientology",
	"melted",
	"necronomicon",
	"kingyellow",
	"gurugranthsahib",
	"kojiki",
))

/obj/item/book/bible
	name = "圣经"
	desc = "反复敲击头部。"
	icon = 'icons/obj/storage/book.dmi'
	icon_state = "bible"
	worn_icon_state = "bible"
	inhand_icon_state = "bible"
	lefthand_file = 'icons/mob/inhands/items/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/books_righthand.dmi'
	force_string = "holy"
	unique = TRUE
	carved_storage_type = /datum/storage/carved_book/bible

	/// Deity this bible is related to
	var/deity_name = "Space Jesus"

/obj/item/book/bible/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, MAGIC_RESISTANCE_HOLY)
	AddComponent(\
		/datum/component/bullet_intercepting,\
		active_slots = ITEM_SLOT_SUITSTORE,\
		on_intercepted = CALLBACK(src, PROC_REF(on_intercepted_bullet)),\
		block_charges = 1,\
	)
	RegisterSignal(src, COMSIG_ATOM_IGNITED_BY_ITEM, PROC_REF(curse_heathen))

/// Destroy the bible when it's shot by a bullet
/obj/item/book/bible/proc/on_intercepted_bullet(mob/living/victim, obj/projectile/bullet)
	victim.add_mood_event("blessing", /datum/mood_event/blessing)
	playsound(victim, 'sound/effects/magic/magic_block_holy.ogg', 50, TRUE)
	victim.visible_message(span_warning("[src] 替 [victim] 挡下了 [bullet]！"))
	var/obj/structure/fluff/paper/stack/pages = new(get_turf(src))
	pages.setDir(pick(GLOB.alldirs))
	name = "被刺穿的圣经"
	desc = "一份好运的纪念品，抑或是神圣的干预？"
	icon_state = "shot"
	if (!GLOB.bible_icon_state)
		GLOB.bible_icon_state = "shot" // New symbol of your religion if you hadn't picked one
	atom_storage?.remove_all(get_turf(src))
	QDEL_NULL(atom_storage)

/obj/item/book/bible/examine(mob/user)
	. = ..()
	if(deity_name)
		. += span_notice("这本圣经已获得 [deity_name] 的认可。")
	if(user.mind?.holy_role)
		if(GLOB.chaplain_altars.len)
			. += span_notice("[src] 带有一个扩展包，可用于替换任何损坏的祭坛。")
		else
			. += span_notice("[src] 可以通过在神圣区域的地面上敲击来展开。")

/obj/item/book/bible/get_attack_self_context(mob/living/user)
	if(can_set_bible_skin(user))
		return "Select bible skin"

/obj/item/book/bible/proc/curse_heathen(datum/source, mob/living/user, obj/item/burning_tool)
	SIGNAL_HANDLER

	// no deity to cast a curse upon thee
	if(!deity_name)
		return
	var/datum/component/omen/existing_omen = user.GetComponent(/datum/component/omen)
	//DOUBLE CURSED?! Just straight up gib the guy.
	if(existing_omen)
		to_chat(user, span_userdanger("[deity_name] <b>天罚</b>于你！"))
		add_memory_in_range(user, 7, /datum/memory/witnessed_gods_wrath, protagonist = user, deuteragonist = src, antagonist = deity_name)
		user.client?.give_award(/datum/award/achievement/misc/gods_wrath, user)
		user.gib(DROP_ALL_REMAINS)
	else
		to_chat(user, span_userdanger("[deity_name] 对你降下诅咒！"))
		user.AddComponent(/datum/component/omen/bible)

/obj/item/book/bible/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正将[user.p_them()]自己献给[deity_name]！看起来[user.p_theyre()]试图自杀！"))
	return BRUTELOSS

/obj/item/book/bible/proc/can_set_bible_skin(mob/living/user)
	if(GLOB.bible_icon_state)
		return FALSE
	if(user?.mind?.holy_role != HOLY_ROLE_HIGHPRIEST)
		return FALSE
	return TRUE

/obj/item/book/bible/attack_self(mob/living/carbon/human/user)
	if(!can_set_bible_skin(user))
		return FALSE

	var/list/skins = list()
	for(var/i in 1 to GLOB.biblestates.len)
		var/image/bible_image = image(icon = 'icons/obj/storage/book.dmi', icon_state = GLOB.biblestates[i])
		skins += list("[GLOB.biblenames[i]]" = bible_image)

	var/choice = show_radial_menu(user, src, skins, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 40, require_near = TRUE)
	if(!choice)
		return FALSE
	var/bible_index = GLOB.biblenames.Find(choice)
	if(!bible_index)
		return FALSE
	icon_state = GLOB.biblestates[bible_index]
	inhand_icon_state = GLOB.bibleitemstates[bible_index]

	switch(icon_state)
		if("honk1")
			user.dna.add_mutation(/datum/mutation/clumsy, MUTATION_SOURCE_CLOWN_CLUMSINESS)
			user.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(user), ITEM_SLOT_MASK)
		if("honk2")
			user.dna.add_mutation(/datum/mutation/clumsy, MUTATION_SOURCE_CLOWN_CLUMSINESS)
			user.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(user), ITEM_SLOT_MASK)
		if("insuls")
			var/obj/item/clothing/gloves/color/fyellow/insuls = new
			insuls.name = "insuls"
			insuls.desc = "不过是真正 insuls 的复制品。"
			insuls.siemens_coefficient = 0.99999
			user.equip_to_slot(insuls, ITEM_SLOT_GLOVES)
	GLOB.bible_icon_state = icon_state
	GLOB.bible_inhand_icon_state = inhand_icon_state
	SSblackbox.record_feedback("text", "religion_book", 1, "[choice]")

/**
 * Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with the menu
 */
/obj/item/book/bible/proc/check_menu(mob/living/carbon/human/user)
	if(!istype(user) || !user.is_holding(src))
		return FALSE
	if(user.incapacitated)
		return FALSE
	if(!can_set_bible_skin(user))
		return FALSE
	return TRUE

/obj/item/book/bible/proc/make_new_altar(atom/bible_smacked, mob/user)
	var/new_altar_area = get_turf(bible_smacked)

	balloon_alert(user, "正在展开圣经...")
	if(!do_after(user, 15 SECONDS, new_altar_area))
		return
	new /obj/structure/altar/of_gods(new_altar_area)
	qdel(src)

/obj/item/book/bible/proc/bless(mob/living/blessed, mob/living/user)
	if(GLOB.religious_sect)
		return GLOB.religious_sect.sect_bless(blessed,user)

	if(!ishuman(blessed))
		return BLESSING_FAILED

	var/mob/living/carbon/human/built_in_his_image = blessed
	for(var/obj/item/bodypart/bodypart as anything in built_in_his_image.get_bodyparts())
		if(!IS_ORGANIC_LIMB(bodypart))
			balloon_alert(user, "无法治愈无机物！")
			return BLESSING_IGNORED

	var/heal_amt = 10
	var/list/hurt_limbs = built_in_his_image.get_damaged_bodyparts(1, 1, BODYTYPE_ORGANIC)
	if(!length(hurt_limbs))
		return BLESSING_IGNORED

	for(var/obj/item/bodypart/affecting as anything in hurt_limbs)
		if(affecting.heal_damage(heal_amt, heal_amt, required_bodytype = BODYTYPE_ORGANIC))
			built_in_his_image.update_damage_overlays()

	built_in_his_image.visible_message(span_notice("[user] 借助[deity_name]的力量治愈了[built_in_his_image]！"))
	to_chat(built_in_his_image, span_boldnotice("愿[deity_name]的力量迫使你痊愈！"))
	playsound(built_in_his_image, SFX_PUNCH, 25, TRUE, -1)
	built_in_his_image.add_mood_event("blessing", /datum/mood_event/blessing)
	return BLESSING_SUCCESS

/obj/item/book/bible/attack(mob/living/target_mob, mob/living/carbon/human/user, list/modifiers, list/attack_modifiers, heal_mode = TRUE)
	if(!ISADVANCEDTOOLUSER(user))
		balloon_alert(user, "不够灵巧！")
		return

	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		to_chat(user, span_danger("[src] 从你手中滑脱，砸中了你的头。"))
		user.take_bodypart_damage(10)
		user.Unconscious(40 SECONDS)
		return

	if(!user.mind?.holy_role)
		to_chat(user, span_danger("这本书在你手中滋滋作响。"))
		user.take_bodypart_damage(burn = 10)
		return

	if(!heal_mode)
		return ..()

	if(target_mob.stat == DEAD)
		if(GLOB.religious_sect?.sect_dead_bless(target_mob, user) == BLESSING_FAILED)
			target_mob.visible_message(span_danger("[user] 用[src]拍打[target_mob]了无生气的尸体。"))
			playsound(target_mob, SFX_PUNCH, 25, TRUE, -1)
		return

	if(user == target_mob)
		balloon_alert(user, "无法治愈自己！")
		return

	var/smack_chance = DEFAULT_SMACK_CHANCE
	if(GLOB.religious_sect)
		smack_chance = GLOB.religious_sect.smack_chance

	if(!prob(smack_chance))
		var/bless_result = bless(target_mob, user)
		if (bless_result != BLESSING_FAILED)
			SEND_SIGNAL(target_mob, COMSIG_LIVING_BLESSED, user, src, bless_result)
			return

	if(iscarbon(target_mob))
		var/mob/living/carbon/carbon_target = target_mob
		if(!istype(carbon_target.head, /obj/item/clothing/head/helmet))
			carbon_target.adjust_organ_loss(ORGAN_SLOT_BRAIN, 5, 60)
			carbon_target.balloon_alert(carbon_target, "你感觉变笨了！")
	target_mob.visible_message(span_danger("[user] 用[src]猛击[target_mob]的头部！"), \
			span_userdanger("[user] 用[src]猛击[target_mob]的头部！"))
	playsound(target_mob, SFX_PUNCH, 25, TRUE, -1)
	log_combat(user, target_mob, "attacked", src)

/obj/item/book/bible/interact_with_atom(atom/bible_smacked, mob/living/user, list/modifiers)
	if(!user.mind?.holy_role)
		return
	if(SEND_SIGNAL(bible_smacked, COMSIG_BIBLE_SMACKED, user) & COMSIG_END_BIBLE_CHAIN)
		return ITEM_INTERACT_SUCCESS
	if(isfloorturf(bible_smacked))
		var/area/current_area = get_area(bible_smacked)
		if(!GLOB.chaplain_altars.len && istype(current_area, /area/station/service/chapel))
			make_new_altar(bible_smacked, user)
			return ITEM_INTERACT_SUCCESS
		for(var/obj/effect/rune/nearby_runes in range(2, user))
			nearby_runes.SetInvisibility(INVISIBILITY_NONE, id=type, priority=INVISIBILITY_PRIORITY_BASIC_ANTI_INVISIBILITY)
		bible_smacked.balloon_alert(user, "地板被拍打了！")
		return ITEM_INTERACT_SUCCESS

	if(bible_smacked.reagents?.has_reagent(/datum/reagent/water)) // blesses all the water in the holder
		bible_smacked.balloon_alert(user, "已祝福")
		var/water2holy = bible_smacked.reagents.get_reagent_amount(/datum/reagent/water)
		bible_smacked.reagents.del_reagent(/datum/reagent/water)
		bible_smacked.reagents.add_reagent(/datum/reagent/water/holywater,water2holy)
		return ITEM_INTERACT_SUCCESS
	if(bible_smacked.reagents?.has_reagent(/datum/reagent/fuel/unholywater)) // yeah yeah, copy pasted code - sue me
		bible_smacked.balloon_alert(user, "已净化")
		var/unholy2holy = bible_smacked.reagents.get_reagent_amount(/datum/reagent/fuel/unholywater)
		bible_smacked.reagents.del_reagent(/datum/reagent/fuel/unholywater)
		bible_smacked.reagents.add_reagent(/datum/reagent/water/holywater,unholy2holy)
		return ITEM_INTERACT_SUCCESS
	if(istype(bible_smacked, /obj/item/book/bible) && !istype(bible_smacked, /obj/item/book/bible/syndicate))
		bible_smacked.balloon_alert(user, "已转化")
		var/obj/item/book/bible/other_bible = bible_smacked
		other_bible.name = name
		other_bible.icon_state = icon_state
		other_bible.inhand_icon_state = inhand_icon_state
		other_bible.deity_name = deity_name
		return ITEM_INTERACT_SUCCESS

	if(istype(bible_smacked, /obj/item/melee/cultblade/haunted) && !IS_CULTIST(user))
		var/obj/item/melee/cultblade/haunted/sword_smacked = bible_smacked
		if(!sword_smacked.bound)
			sword_smacked.balloon_alert(user, "必须被绑定！")
			return ITEM_INTERACT_BLOCKING
		var/obj/item/melee/cultblade/haunted/sword = bible_smacked
		sword.balloon_alert(user, "驱魔中...")
		playsound(src,'sound/effects/hallucinations/veryfar_noise.ogg',40,TRUE)
		if(do_after(user, 12 SECONDS, target = sword))
			playsound(src,'sound/effects/pray_chaplain.ogg',60,TRUE)
			new /obj/item/nullrod/nullblade(get_turf(sword))
			user.visible_message(span_notice("[user] 驱除了 [sword]！"))
			qdel(sword)
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return NONE

/obj/item/book/bible/booze
	desc = "需要反复敲击头部使用。"

/obj/item/book/bible/booze/Initialize(mapload)
	. = ..()
	carve_out()
	new /obj/item/reagent_containers/cup/glass/bottle/whiskey(src)

/obj/item/book/bible/syndicate
	name = "辛迪加典籍"
	desc = "一本外形酷似圣经、散发着不祥气息的典籍。"
	icon_state ="ebook"
	item_flags = NO_BLOOD_ON_ITEM
	throw_speed = 2
	throw_range = 7
	throwforce = 18
	force = 18
	hitsound = 'sound/items/weapons/sear.ogg'
	damtype = BURN
	attack_verb_continuous = list("attacks", "burns", "blesses", "damns", "scorches", "curses", "smites")
	attack_verb_simple = list("attack", "burn", "bless", "damn", "scorch", "curse", "smite")
	deity_name = "The Syndicate"
	var/uses = 1
	var/owner_name

/obj/item/book/bible/syndicate/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY)
	AddComponent(/datum/component/bane, affected_biotypes = MOB_SPIRIT, added_damage = 25)
	AddComponent(/datum/component/effect_remover, \
		success_feedback = "You disrupt the magic of %THEEFFECT with %THEWEAPON.", \
		success_forcesay = "BEGONE FOUL MAGIKS!!", \
		tip_text = "Clear rune", \
		effects_we_clear = list(/obj/effect/rune, /obj/effect/heretic_rune, /obj/effect/cosmic_rune), \
	)

/obj/item/book/bible/syndicate/attack_self(mob/living/carbon/human/user, modifiers)
	if(!uses || !istype(user))
		return
	user.mind.set_holy_role(HOLY_ROLE_PRIEST)
	uses -= 1
	to_chat(user, span_userdanger("你试图翻开这本书，它却咬了你一口！"))
	playsound(src.loc, 'sound/effects/snap.ogg', 50, TRUE)
	user.apply_damage(5, BRUTE, user.get_active_hand(), attacking_item = src)
	to_chat(user, span_notice("你的名字以鲜血的形式出现在扉页上。"))
	owner_name = user.real_name

/obj/item/book/bible/syndicate/examine(mob/user)
	. = ..()
	if(owner_name)
		. += span_warning("封面内侧用鲜血写着 [owner_name] 的名字。")

/obj/item/book/bible/syndicate/get_attack_self_context(mob/living/user)
	if(uses)
		return "Read"

/obj/item/book/bible/syndicate/attack(mob/living/target_mob, mob/living/carbon/human/user,  list/modifiers, list/attack_modifiers, heal_mode = TRUE)
	if(!user.combat_mode)
		return ..()
	return ..(target_mob, user, modifiers, attack_modifiers, heal_mode = FALSE)
