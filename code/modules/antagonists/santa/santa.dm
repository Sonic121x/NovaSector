/datum/antagonist/santa
	name = "\improper 圣诞老人"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	suicide_cry = "FOR CHRISTMAS!!"
	var/datum/component/listen_prayers/santa_prayers

/datum/antagonist/santa/on_gain()
	. = ..()
	give_equipment()
	give_objective()

	owner.add_traits(list(TRAIT_CANNOT_OPEN_PRESENTS, TRAIT_PRESENT_VISION), TRAIT_SANTA)

	santa_prayers = owner.AddComponent(/datum/component/listen_prayers, CALLBACK(src, PROC_REF(check_if_santa_prayer)), "Santa Claus", "Allows you to listen for prayers that mention you or Christmas.")

/datum/antagonist/santa/proc/check_if_santa_prayer(list/arguments)
	SIGNAL_HANDLER
	var/message = arguments[ARG_PRAYER_MSG]
	var/mob/boy_girl = arguments[ARG_PRAYING_MOB]
	var/regex/santa_regex = regex("(santa|claus|christmas|xmas)", "i")
	if(!santa_regex.Find(message) && (!prob(60) || !findtext(message, "satan")))
		return FALSE //The message doesn't mention us (or satan, cuz the names are so similar, accidents may happen)
	var/is_good_boy_girl = !boy_girl.is_antag() && !HAS_TRAIT(boy_girl, TRAIT_EVIL)
	arguments[ARG_PRAYER_TYPE] = is_good_boy_girl ? SANTA_PRAYER : SANTA_NAUGHTY_PRAYER
	arguments[ARG_PRAYER_SYMBOL] = icon('icons/obj/storage/wrapping.dmi', "giftdeliverypackage4")
	return TRUE

/datum/antagonist/santa/on_removal()
	if(!owner)
		return ..()
	owner.remove_traits(list(TRAIT_CANNOT_OPEN_PRESENTS, TRAIT_PRESENT_VISION), TRAIT_SANTA)
	QDEL_NULL(santa_prayers)
	if(owner.current)
		var/datum/action/cooldown/spell/teleport/area_teleport/wizard/santa/teleport = locate() in owner.current.actions
		qdel(teleport)
	return ..()

/datum/antagonist/santa/greet()
	. = ..()
	to_chat(owner, span_bolddanger("你的目标是为这座空间站上的人们带来欢乐。你有一个魔法袋，只要拥有它就能不断生成礼物！你可以检查礼物来窥探内部，确保将合适的礼物送给合适的人。"))

/datum/antagonist/santa/proc/give_equipment()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.equipOutfit(/datum/outfit/santa)
		H.dna.update_dna_identity()

	var/datum/action/cooldown/spell/teleport/area_teleport/wizard/santa/teleport = new(owner)
	teleport.Grant(H)

/datum/antagonist/santa/proc/give_objective()
	var/datum/objective/santa_objective = new()
	santa_objective.explanation_text = "Bring joy and presents to the station!"
	santa_objective.completed = TRUE //lets cut our santas some slack.
	santa_objective.owner = owner
	objectives |= santa_objective
