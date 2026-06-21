/obj/item/statuebust
	name = "半身像"
	desc = "一座无价的古代大理石半身像，属于博物馆的那种。" //or you can hit people with it
	icon = 'icons/obj/art/statue.dmi'
	icon_state = "bust"
	force = 15
	throwforce = 10
	throw_speed = 5
	throw_range = 2
	attack_verb_continuous = list("busts")
	attack_verb_simple = list("bust")
	var/impressiveness = 45

/obj/item/statuebust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/art, impressiveness)
	AddElement(/datum/element/beauty, 1000)

/obj/item/statuebust/hippocratic
	name = "希波克拉底半身像"
	desc = "著名的希腊医师希波克拉底（科斯的）的半身像，常被称为西方医学之父。"
	icon_state = "hippocratic"
	impressiveness = 50
	// If it hits the prob(reference_chance) chance, this is set to TRUE. Adds medical HUD when wielded, but has a 10% slower attack speed and is too bloody to make an oath with.
	var/reference = FALSE
	// Chance for above.
	var/reference_chance = 1
	// Minimum time inbetween oaths.
	COOLDOWN_DECLARE(oath_cd)

/obj/item/statuebust/hippocratic/evil
	reference_chance = 100

/obj/item/statuebust/hippocratic/Initialize(mapload)
	. = ..()
	if(prob(reference_chance))
		name = "庄严誓言"
		desc = "艺术爱好者会珍视希波克拉底的半身像，它纪念了一个医疗人员仍认为不造成伤害是好主意的时代。"
		attack_speed = CLICK_CD_SLOW
		reference = TRUE

/obj/item/statuebust/hippocratic/examine(mob/user)
	. = ..()
	if(reference)
		. += span_notice("你可以手持激活这尊半身像来宣誓或背弃希波克拉底誓言……但看起来有人觉得它更像是希波克拉底建议。这东西沾满了血污和内脏碎块。")
		return
	. += span_notice("你可以手持激活这尊半身像来宣誓或背弃希波克拉底誓言！除了和平主义或吹嘘的权利外没有其他效果。不会移除其他和平主义来源。请勿食用。")

/obj/item/statuebust/hippocratic/equipped(mob/living/carbon/human/user, slot)
	..()
	if(!(slot & ITEM_SLOT_HANDS))
		return
	ADD_TRAIT(user, TRAIT_MEDICAL_HUD, type)

/obj/item/statuebust/hippocratic/dropped(mob/living/carbon/human/user)
	..()
	if(HAS_TRAIT_NOT_FROM(user, TRAIT_MEDICAL_HUD, type))
		return
	REMOVE_TRAIT(user, TRAIT_MEDICAL_HUD, type)

/obj/item/statuebust/hippocratic/attack_self(mob/user)
	if(!iscarbon(user))
		to_chat(user, span_warning("你想起希波克拉底誓言中提到的'我的同胞人类'，意识到这对你来说毫无意义。"))
		return

	if(reference)
		to_chat(user, span_warning("当你准备宣誓时，你意识到在一尊沾满血污的半身像上宣誓可能不是个好主意。"))
		return

	if(!COOLDOWN_FINISHED(src, oath_cd))
		to_chat(user, span_warning("你宣誓或背弃誓言的时间太近，无法撤销决定。半身像用厌恶的眼神看着你。"))
		return

	COOLDOWN_START(src, oath_cd, 5 MINUTES)

	if(HAS_TRAIT_FROM(user, TRAIT_PACIFISM, type))
		to_chat(user, span_warning("你已经发过誓了。你开始准备撤销它……"))
		if(do_after(user, 5 SECONDS, target = user))
			user.say("Yeah this Hippopotamus thing isn't working out. I quit!", forced = "hippocratic hippocrisy")
			REMOVE_TRAIT(user, TRAIT_PACIFISM, type)

	// they can still do it for rp purposes
	if(HAS_TRAIT_NOT_FROM(user, TRAIT_PACIFISM, type))
		to_chat(user, span_warning("你本来就不想伤害别人，这不会有任何作用！"))


	to_chat(user, span_notice("你回想起希波克拉底誓言的内容，准备宣誓遵守……"))
	if(do_after(user, 4 SECONDS, target = user))
		user.say("I swear to fulfill, to the best of my ability and judgment, this covenant:", forced = "hippocratic oath")
	else
		return fuck_it_up(user)
	if(do_after(user, 2 SECONDS, target = user))
		user.say("I will apply, for the benefit of the sick, all measures that are required, avoiding those twin traps of overtreatment and therapeutic nihilism.", forced = "hippocratic oath")
	else
		return fuck_it_up(user)
	if(do_after(user, 3 SECONDS, target = user))
		user.say("I will remember that I remain a member of society, with special obligations to all my fellow human beings, those sound of mind and body as well as the infirm.", forced = "hippocratic oath")
	else

		return fuck_it_up(user)
	if(do_after(user, 3 SECONDS, target = user))
		user.say("If I do not violate this oath, may I enjoy life and art, respected while I live and remembered with affection thereafter. May I always act so as to preserve the finest traditions of my calling and may I long experience the joy of healing those who seek my help.", forced = "hippocratic oath")
	else
		return fuck_it_up(user)

	to_chat(user, span_notice("当你完成誓言时，满足感、理解力和使命感涌上心头。你思考了一秒伤害的概念，不禁打了个寒颤。"))
	ADD_TRAIT(user, TRAIT_PACIFISM, type)

// Bully the guy for fucking up.
/obj/item/statuebust/hippocratic/proc/fuck_it_up(mob/living/carbon/user)
	to_chat(user, span_warning("你像个傻瓜一样忘记了接下来该说什么。希波克拉底半身像俯视着你，一脸失望。"))
	user.adjust_organ_loss(ORGAN_SLOT_BRAIN, 2)
	COOLDOWN_RESET(src, oath_cd)

/obj/item/maneki_neko
	name = "招财猫"
	desc = "一只拿着硬币的猫雕像，据说能带来好运和财富，它的爪子永远在做招手的动作。"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "maneki-neko"
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	attack_verb_continuous = list("bashes", "beckons", "hit")
	attack_verb_simple = list("bash", "beckon", "hit")

/obj/item/maneki_neko/Initialize(mapload)
	. = ..()
	//Not compatible with greyscale configs because it's animated.
	add_atom_colour(pick_weight(list(COLOR_WHITE = 3, COLOR_GOLD = 2, COLOR_DARK = 1)), FIXED_COLOUR_PRIORITY)
	var/mutable_appearance/neko_overlay = mutable_appearance(icon, "maneki-neko-overlay", appearance_flags = RESET_COLOR|KEEP_APART)
	add_overlay(neko_overlay)
	AddElement(/datum/element/art, GOOD_ART)
	AddElement(/datum/element/beauty, 800)
