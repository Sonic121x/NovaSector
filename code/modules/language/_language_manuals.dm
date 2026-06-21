/obj/item/language_manual
	icon = 'icons/obj/service/library.dmi'
	icon_state = "book2"
	/// Number of charges the book has, limits the number of times it can be used.
	var/charges = 1
	/// Path to a language datum that the book teaches.
	var/datum/language/language = /datum/language/common
	/// Flavour text to display when the language is successfully learned.
	var/flavour_text = "突然间你的脑海中充满了暗语和回应"

/obj/item/language_manual/attack_self(mob/living/user)
	if(!isliving(user))
		return

	if(user.has_language(language))
		to_chat(user, span_boldwarning("你开始翻阅[src]，但你已经掌握了[initial(language.name)]。"))
		return

	to_chat(user, span_bolddanger("你开始翻阅[src]，并且[flavour_text]。"))

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
		M.visible_message(span_danger("[user]用[src]拍打[M]毫无生气的尸体。"), span_userdanger("[user]用[src]拍打你毫无生气的尸体。"), span_hear("你听到拍打声。"))
	else if(M.has_language(language))
		M.visible_message(span_danger("[user]用[src]猛击[M]的头部！"), span_userdanger("[user]用[src]猛击你的头部！"), span_hear("你听到拍打声。"))
	else
		M.visible_message(span_notice("[user]通过用[src]猛击[M.p_them()]的头部来教导[M]！"), span_boldnotice("当[user]用[src]击中你时，[flavour_text]。"), span_hear("你听到拍打声。"))
		M.grant_language(language, source = LANGUAGE_MIND)
		use_charge(user)

/obj/item/language_manual/proc/use_charge(mob/user)
	charges--
	if(!charges)
		user.visible_message(span_notice("[user] 手中书本的封面开始扭曲变化！它从 [user.p_their()] 手中掉落了！"),
							span_warning("[src]的封面和内容开始扭曲变化！它从你手中滑落了！"))
		new /obj/item/book/manual/random(get_turf(src))
		qdel(src)

/obj/item/language_manual/codespeak_manual
	name = "密语手册"
	desc = "书的封面上写着：\"Codespeak(tm) - 用如此精巧的隐喻来保护你的通信，它们看起来像是随机生成的！\""
	language = /datum/language/codespeak
	flavour_text = "突然间，你的脑海中充满了代码词和应答语"

/obj/item/language_manual/codespeak_manual/unlimited
	name = "豪华版密语手册"
	charges = INFINITY

/obj/item/language_manual/roundstart_species

/obj/item/language_manual/roundstart_species/Initialize(mapload)
	. = ..()
	var/list/available_languages = length(GLOB.uncommon_roundstart_languages) ? GLOB.uncommon_roundstart_languages : list(/datum/language/common)
	language = pick(available_languages)
	name = "[initial(language.name)] 手册"
	desc = "这本书的封面上写着：\"[initial(language.name)] 外星人专用 - 数秒内学会常见银河系语言。\""
	flavour_text = "你感到自己掌握了[initial(language.name)]的精髓"

/obj/item/language_manual/roundstart_species/unlimited
	charges = INFINITY

/obj/item/language_manual/roundstart_species/unlimited/Initialize(mapload)
	. = ..()
	name = "豪华[initial(language.name)]手册"

/obj/item/language_manual/roundstart_species/five
	charges = 5

/obj/item/language_manual/roundstart_species/five/Initialize(mapload)
	. = ..()
	name = "扩展版[initial(language.name)]手册"

/obj/item/language_manual/piratespeak
	name = "\improper 皮特船长的海盗行话指南"
	icon_state = "book_pirate"
	desc = "一本包含了所有知识、行话和流行语的书，让你能像真正的老水手一样说话。"
	language = /datum/language/piratespeak
	flavour_text = "老天！我感觉自己不那么像个旱鸭子了。"
	charges = 5

// So drones can teach borgs and AI dronespeak. For best effect, combine with mother drone lawset.
/obj/item/language_manual/dronespeak_manual
	name = "无人机语手册"
	desc = "The book's cover reads: \"Understanding Dronespeak - An exercise in futility.\" The book is written entirely in binary, non-silicons probably won't understand it."
	language = /datum/language/drone
	flavour_text = "突然间，无人机的吱喳声变得可以理解了"
	charges = INFINITY

/obj/item/language_manual/dronespeak_manual/attack(mob/living/M, mob/living/user)
	// If they are not drone or silicon, we don't want them to learn this language.
	if(!(isdrone(M) || issilicon(M)))
		M.visible_message(span_danger("[user] 用 [M] 敲打 [src] 的头！"), span_userdanger("[user] 用 [src] 敲了你的头！"), span_hear("你听见了拍打声。"))
		return

	return ..()

/obj/item/language_manual/dronespeak_manual/attack_self(mob/living/user)
	if(!(isdrone(user) || issilicon(user)))
		to_chat(user, span_danger("你用[src]猛敲自己的头！"))
		return

	return ..()
