// Ritual spells which affect the station at large
/// How much threat we need to let these rituals happen on dynamic
#define MINIMUM_THREAT_FOR_RITUALS 98

/datum/spellbook_entry/summon/ghosts
	name = "召唤幽灵"
	desc = "Spook the crew out by making them see dead people. \
		Be warned, ghosts are capricious and occasionally vindicative, \
		and some will use their incredibly minor abilities to frustrate you."
	cost = 0

/datum/spellbook_entry/summon/ghosts/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	summon_ghosts(user)
	playsound(get_turf(user), 'sound/effects/ghost2.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/guns
	name = "召唤枪"
	desc = "Nothing could possibly go wrong with arming a crew of lunatics just itching for an excuse to kill you. \
		There is a good chance that they will shoot each other first."

/datum/spellbook_entry/summon/guns/can_be_purchased()
	// Must be a high chaos round + Also must be config enabled
	return SSdynamic.current_tier.tier == DYNAMIC_TIER_HIGH && !CONFIG_GET(flag/no_summon_guns)

/datum/spellbook_entry/summon/guns/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	summon_guns(user, 10)
	playsound(get_turf(user), 'sound/effects/magic/castsummon.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/magic
	name = "召唤法术"
	desc = "Share the wonders of magic with the crew and show them \
		why they aren't to be trusted with it at the same time."

/datum/spellbook_entry/summon/magic/can_be_purchased()
	// Must be a high chaos round + Also must be config enabled
	return SSdynamic.current_tier.tier == DYNAMIC_TIER_HIGH && !CONFIG_GET(flag/no_summon_magic)

/datum/spellbook_entry/summon/magic/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	summon_magic(user, 10)
	playsound(get_turf(user), 'sound/effects/magic/castsummon.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/events
	name = "召唤事件"
	desc = "Give Murphy's law a little push and replace all events with \
		special wizard ones that will confound and confuse everyone. \
		Multiple castings increase the rate of these events."
	cost = 2
	limit = 5 // Each purchase can intensify it.

/datum/spellbook_entry/summon/events/can_be_purchased()
	// Must be a high chaos round + Also must be config enabled
	return SSdynamic.current_tier.tier == DYNAMIC_TIER_HIGH && !CONFIG_GET(flag/no_summon_events)

/datum/spellbook_entry/summon/events/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	summon_events(user)
	playsound(get_turf(user), 'sound/effects/magic/castsummon.ogg', 50, TRUE)
	return ..()

/datum/spellbook_entry/summon/curse_of_madness
	name = "癫狂之咒"
	desc = "诅咒着这座空间站，扭曲了站内所有人的思维，造成了持久的创伤。警告：若未从安全距离施展此法术，您也会受到影响。"
	cost = 4

/datum/spellbook_entry/summon/curse_of_madness/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	var/message = tgui_input_text(user, "低语一个秘密真相，将你的受害者逼向疯狂", "疯狂低语", max_length = MAX_MESSAGE_LEN)
	if(!message || QDELETED(user) || QDELETED(book) || !can_buy(user, book))
		return FALSE
	curse_of_madness(user, message)
	playsound(user, 'sound/effects/magic/mandswap.ogg', 50, TRUE)
	return ..()

/// A wizard ritual that allows the wizard to teach a specific spellbook enty to everyone on the station.
/// This includes item entries (which will be given to everyone) but disincludes other rituals like itself
/datum/spellbook_entry/summon/specific_spell
	name = "群体巫师教学"
	desc = "Teach a specific spell (or give a specific item) to everyone on the station. \
		The cost of this is increased by the cost of the spell you choose. And don't worry - you, too, will learn the spell!"
	cost = 3 // cheapest is 4 cost, most expensive is 7 cost
	limit = 1

/datum/spellbook_entry/summon/specific_spell/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	var/list/spell_options = list()
	for(var/datum/spellbook_entry/entry as anything in book.entries)
		if(istype(entry, /datum/spellbook_entry/summon))
			continue
		if(!entry.can_be_purchased())
			continue

		spell_options[entry.name] = entry

	sortTim(spell_options, GLOBAL_PROC_REF(cmp_text_asc))
	var/chosen_spell_name = tgui_input_list(user, "选择一个法术（或物品）授予所有人...", "巫师教学", spell_options)
	if(isnull(chosen_spell_name) || QDELETED(user) || QDELETED(book))
		return FALSE
	if(GLOB.mass_teaching)
		tgui_alert(user, "已经有人施放过[name]了！", "巫师教学", list("Shame"))
		return FALSE

	var/datum/spellbook_entry/chosen_entry = spell_options[chosen_spell_name]
	if(cost + chosen_entry.cost > book.uses)
		tgui_alert(user, "你无法负担授予所有人 [chosen_spell_name] 的代价！（需要 [cost] 点）", "巫师教学", list("Shame"))
		return FALSE

	cost += chosen_entry.cost
	if(!can_buy(user, book))
		cost = initial(cost)
		return FALSE

	GLOB.mass_teaching = new(chosen_entry.type)
	GLOB.mass_teaching.equip_all_affected()

	var/item_entry = istype(chosen_entry, /datum/spellbook_entry/item)
	to_chat(user, span_hypnophrase("你已经 [item_entry ? "granted everyone the power" : "taught everyone the ways"] 了 [chosen_spell_name] ！"))
	message_admins("[ADMIN_LOOKUPFLW(user)] gave everyone the [item_entry ? "item" : "spell"] \"[chosen_spell_name]\"!")
	user.log_message("has gave everyone the [item_entry ? "item" : "spell"] \"[chosen_spell_name]\"!", LOG_GAME)

	name = "[name]：[chosen_spell_name]"
	return ..()

/datum/spellbook_entry/summon/specific_spell/can_buy(mob/living/carbon/human/user, obj/item/spellbook/book)
	if(GLOB.mass_teaching)
		return FALSE
	return ..()

/datum/spellbook_entry/summon/specific_spell/can_be_purchased()
	if(SSdynamic.current_tier.tier != DYNAMIC_TIER_HIGH)
		return FALSE
	if(GLOB.mass_teaching)
		return FALSE
	return ..()

#undef MINIMUM_THREAT_FOR_RITUALS
