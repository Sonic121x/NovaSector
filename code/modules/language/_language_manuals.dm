// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/language_manual
	icon = 'icons/obj/service/library.dmi'
	icon_state = "book2"
	/// Number of charges the book has, limits the number of times it can be used.
	var/charges = 1
	/// Path to a language datum that the book teaches.
	var/datum/language/language = /datum/language/common
	/// Flavour text to display when the language is successfully learned.
	var/flavour_text = "suddenly your mind is filled with codewords and responses"

/obj/item/language_manual/attack_self(mob/living/user)
	if(!isliving(user))
		return

	if(user.has_language(language))
		to_chat(user, span_boldwarning(LANG("obj.6e7d7669350ca85b", list(src, initial(language.name)))))
		return

	to_chat(user, span_bolddanger(LANG("obj.0550275b8865088a", list(src, flavour_text))))

	user.grant_language(language)
	user.remove_blocked_language(language, source=LANGUAGE_ALL)
	ADD_TRAIT(user.mind, TRAIT_TOWER_OF_BABEL, MAGIC_TRAIT) // this makes you immune to babel effects

	use_charge(user)

/obj/item/language_manual/attack(mob/living/M, mob/living/user)
	if(!istype(M) || !istype(user))
		return
	if(M == user)
		attack_self(user)
		return

	playsound(loc, SFX_PUNCH, 25, TRUE, -1)

	if(M.stat == DEAD)
		M.visible_message(span_danger(LANG("obj.d96b11d66b5980f5", list(user, M, src))), span_userdanger(LANG("obj.25819aec3d525113", list(user, src))), span_hear(LANG("obj.e821c025d0846fa2", null)))
	else if(M.has_language(language))
		M.visible_message(span_danger(LANG("obj.908ad4aa37bb4e1e", list(user, M, src))), span_userdanger(LANG("obj.f3960582586a528e", list(user, src))), span_hear(LANG("obj.e821c025d0846fa2", null)))
	else
		M.visible_message(span_notice(LANG("obj.4936305eee6e0467", list(user, M, M.p_them(), src))), span_boldnotice(LANG("obj.e1674db86e041990", list(user, src, flavour_text))), span_hear(LANG("obj.e821c025d0846fa2", null)))
		M.grant_language(language, source = LANGUAGE_MIND)
		use_charge(user)

/obj/item/language_manual/proc/use_charge(mob/user)
	charges--
	if(!charges)
		user.visible_message(span_notice(LANG("obj.d3148291f7c6aeab", list(user, user.p_their()))),
							span_warning(LANG("obj.4d96de82274039bd", list(src))))
		new /obj/item/book/manual/random(get_turf(src))
		qdel(src)

/obj/item/language_manual/codespeak_manual
	name = "codespeak manual"
	desc = "The book's cover reads: \"Codespeak(tm) - Secure your communication with metaphors so elaborate, they seem randomly generated!\""
	language = /datum/language/codespeak
	flavour_text = "suddenly your mind is filled with codewords and responses"

/obj/item/language_manual/codespeak_manual/unlimited
	name = "deluxe codespeak manual"
	charges = INFINITY

/obj/item/language_manual/roundstart_species
	name = "roundstart species language manual"

/obj/item/language_manual/roundstart_species/Initialize(mapload)
	. = ..()
	if(!language) //if a language is already set, use it instead.
		var/list/available_languages = length(GLOB.uncommon_roundstart_languages) ? GLOB.uncommon_roundstart_languages : list(/datum/language/common)
		language = pick(available_languages)
	name = "[initial(language.name)] manual"
	desc = LANG("obj.09c2ca37a995125b", list(initial(language.name)))
	flavour_text = "you feel empowered with a mastery over [initial(language.name)]"

/obj/item/language_manual/roundstart_species/unlimited
	charges = INFINITY

/obj/item/language_manual/roundstart_species/unlimited/Initialize(mapload)
	. = ..()
	name = "deluxe [initial(language.name)] manual"

/obj/item/language_manual/roundstart_species/five
	charges = 5

/obj/item/language_manual/roundstart_species/five/Initialize(mapload)
	. = ..()
	name = "extended [initial(language.name)] manual"

/obj/item/language_manual/roundstart_species/draconic
	name = "Draconic manual"

/obj/item/language_manual/piratespeak
	name = "\improper Captain Pete's Guide to Pirate Lingo"
	icon_state = "book_pirate"
	desc = "A book containing all the knowledge, jargon and buzzwords to speak like a true old salt."
	language = /datum/language/piratespeak
	flavour_text = "Blimey! I feel less of a landlubber now."
	charges = 5

// So drones can teach borgs and AI dronespeak. For best effect, combine with mother drone lawset.
/obj/item/language_manual/dronespeak_manual
	name = "dronespeak manual"
	desc = "The book's cover reads: \"Understanding Dronespeak - An exercise in futility.\" The book is written entirely in binary, non-silicons probably won't understand it."
	language = /datum/language/drone
	flavour_text = "suddenly the drone chittering makes sense"
	charges = INFINITY

/obj/item/language_manual/dronespeak_manual/attack(mob/living/M, mob/living/user)
	// If they are not drone or silicon, we don't want them to learn this language.
	if(!(isdrone(M) || issilicon(M)))
		M.visible_message(span_danger(LANG("obj.908ad4aa37bb4e1e", list(user, M, src))), span_userdanger(LANG("obj.f3960582586a528e", list(user, src))), span_hear(LANG("obj.e821c025d0846fa2", null)))
		return

	return ..()

/obj/item/language_manual/dronespeak_manual/attack_self(mob/living/user)
	if(!(isdrone(user) || issilicon(user)))
		to_chat(user, span_danger(LANG("obj.ffff29ef06ac5b23", list(src))))
		return

	return ..()
