/obj/item/clothing/neck
	name = "项链"
	icon = 'icons/obj/clothing/neck.dmi'
	abstract_type = /obj/item/clothing/neck
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	interaction_flags_click = NEED_DEXTERITY
	strip_delay = 4 SECONDS
	equip_delay_other = 4 SECONDS

/obj/item/clothing/neck/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands || !(body_parts_covered & HEAD))
		return
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")

/obj/item/clothing/neck/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands, icon_file, mutant_styles) // NOVA EDIT CHANGE - ORIGINAL: /obj/item/clothing/gloves/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands, icon_file)
	. = ..()
	if (isinhands || !(body_parts_covered & HEAD))
		return
	var/blood_overlay = get_blood_overlay("mask")
	if (blood_overlay)
		. += blood_overlay

/obj/item/clothing/neck/bowtie
	name = "bow tie"
	desc = "A small neosilk bowtie."
	inhand_icon_state = "" //no inhands
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_CREW
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/bowtie"
	post_init_icon_state = "bowtie_greyscale"
	greyscale_config = /datum/greyscale_config/ties
	greyscale_config_worn = /datum/greyscale_config/ties/worn
	greyscale_colors = "#151516ff"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/bowtie/rainbow
	name = "rainbow bow tie"
	desc = "An extremely large neosilk rainbow-colored bowtie."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bowtie_rainbow"
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

/obj/item/clothing/neck/tie
	name = "slick tie"
	desc = "A neosilk tie."
	inhand_icon_state = "" //no inhands
	alternate_worn_layer = LOW_NECK_LAYER // So that it renders below suit jackets, MODsuits, etc
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_CREW
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/tie"
	post_init_icon_state = "tie_greyscale_tied"
	greyscale_config = /datum/greyscale_config/ties
	greyscale_config_worn = /datum/greyscale_config/ties/worn
	greyscale_colors = "#4d4e4e"
	flags_1 = IS_PLAYER_COLORABLE_1
	/// All ties start untied unless otherwise specified
	var/is_tied = FALSE
	/// How long it takes to tie the tie
	var/tie_timer = 4 SECONDS
	/// Is this tie a clip-on, meaning it does not have an untied state?
	var/clip_on = FALSE

/obj/item/clothing/neck/tie/Initialize(mapload)
	. = ..()
	if(!clip_on)
		update_appearance(UPDATE_ICON)
	register_context()

/obj/item/clothing/neck/tie/examine(mob/user)
	. = ..()
	. += span_notice("The tie can be worn above or below your suit. Alt-Right-click to toggle.")
	if(clip_on)
		. += span_notice("Looking closely, you can see that it's actually a cleverly disguised clip-on.")
	else if(!is_tied)
		. += span_notice("The tie can be tied with Alt-Click.")
	else
		. += span_notice("The tie can be untied with Alt-Click.")

/obj/item/clothing/neck/tie/click_alt(mob/user)
	if(clip_on)
		return NONE
	to_chat(user, span_notice("你集中精神，开始[is_tied ? "untying" : "tying"] [src]..."))
	var/tie_timer_actual = tie_timer
	// Mirrors give you a boost to your tying speed. I realize this stacks and I think that's hilarious.
	for(var/obj/structure/mirror/reflection in view(2, user))
		tie_timer_actual *= 0.8
	// Heads of staff are experts at tying their ties.
	if(HAS_TRAIT(user, TRAIT_FAST_TYING))
		tie_timer_actual *= 0.5
	// Tie/Untie our tie
	if(!do_after(user, tie_timer_actual))
		to_chat(user, span_notice("Your fingers fumble away from [src] as your concentration breaks."))
		return CLICK_ACTION_BLOCKING
	// Clumsy & Dumb people have trouble tying their ties.
	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		to_chat(user, span_notice("You just can't seem to get a proper grip on [src]!"))
		return CLICK_ACTION_BLOCKING
	// Success!
	is_tied = !is_tied
	user.visible_message(
		span_notice("[user] 调整了[user.p_their()]领带[HAS_TRAIT(user, TRAIT_BALD) ? "" : " and runs a hand across [user.p_their()] head"]。"),
		span_notice("你成功地[is_tied ? "tied" : "untied"]了 [src]！"),
	)
	update_appearance(UPDATE_ICON)
	user.update_clothing(ITEM_SLOT_NECK)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/neck/tie/click_alt_secondary(mob/user)
	alternate_worn_layer = (alternate_worn_layer == initial(alternate_worn_layer) ? NONE : initial(alternate_worn_layer))
	user.update_clothing(ITEM_SLOT_NECK)
	balloon_alert(user, "穿在[alternate_worn_layer == initial(alternate_worn_layer) ? "below" : "above"]")

/obj/item/clothing/neck/tie/update_icon()
	. = ..()
	if(clip_on)
		return
	// Normal strip & equip delay, along with 2 second self equip since you need to squeeze your head through the hole.
	if(is_tied)
		icon_state = "tie_greyscale_tied"
		strip_delay = 4 SECONDS
		equip_delay_other = 4 SECONDS
		equip_delay_self = 2 SECONDS
	else // Extremely quick strip delay, it's practically a ribbon draped around your neck
		icon_state = "tie_greyscale_untied"
		strip_delay = 1 SECONDS
		equip_delay_other = 1 SECONDS
		equip_delay_self = 0 SECONDS

/obj/item/clothing/neck/tie/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_RMB] = "Wear [alternate_worn_layer == initial(alternate_worn_layer) ? "above" : "below"] suit"
	if(clip_on)
		return CONTEXTUAL_SCREENTIP_SET
	if(is_tied)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Untie"
	else
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Tie"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/neck/tie/worn_overlays(mutable_appearance/standing, isinhands)
	. = ..()
	var/mob/living/carbon/human/wearer = loc
	if(!ishuman(wearer) || !wearer.w_uniform)
		return
	var/obj/item/clothing/under/undershirt = wearer.w_uniform
	if(!istype(undershirt) || !LAZYLEN(undershirt.attached_accessories))
		return
	if(alternate_worn_layer)
		. += undershirt.accessory_overlay

/obj/item/clothing/neck/tie/blue
	name = "蓝色领带"
	icon_state = "/obj/item/clothing/neck/tie/blue"
	post_init_icon_state = "tie_greyscale_untied"
	greyscale_colors = "#5275b6ff"

/obj/item/clothing/neck/tie/red
	name = "红色领带"
	icon_state = "/obj/item/clothing/neck/tie/red"
	post_init_icon_state = "tie_greyscale_untied"
	greyscale_colors = "#c23838ff"

/obj/item/clothing/neck/tie/red/tied
	is_tied = TRUE
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/neck/tie/red/hitman
	desc = "这是一条价值 47,000 美元的定制版“猎手报酬”领带。领带的丝线取自科库维尔一家微型养蚕场里培育的新型蚕，其独特的图案是由自 21 世纪起就传承下来的修道院裁缝师们所设计的！"
	tie_timer = 1 SECONDS // You're a professional.
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/neck/tie/red/hitman/tied
	is_tied = TRUE
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/neck/tie/black
	name = "黑色领带"
	icon_state = "/obj/item/clothing/neck/tie/black"
	post_init_icon_state = "tie_greyscale_untied"
	greyscale_colors = "#151516ff"

/obj/item/clothing/neck/tie/black/tied
	is_tied = TRUE
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/neck/tie/horrible
	name = "糟糕的领带"
	desc = "A neosilk tie. This one is disgusting."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "horribletie"
	post_init_icon_state = null
	clip_on = TRUE
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

/obj/item/clothing/neck/robe_cape
	name = "robe cape"
	desc = "A comfortable cape, draped down your back and held around your neck with a brooch."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/robe_cape"
	post_init_icon_state = "robe_cape"
	worn_icon = 'icons/mob/clothing/neck.dmi'
	worn_icon_state = "robe_cape"
	abstract_type = /obj/item/clothing/neck
	greyscale_config = /datum/greyscale_config/robe_cape
	greyscale_config_worn = /datum/greyscale_config/robe_cape/worn
	greyscale_colors = "#2a2844"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/robe_cape/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/surgery_aid, "cape")

/obj/item/clothing/neck/tie/detective
	name = "松垮的领带"
	desc = "松松系着的领带，是工作过度的侦探的完美配饰。"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "detective"
	post_init_icon_state = null
	clip_on = TRUE
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

/obj/item/clothing/neck/stethoscope
	name = "听诊器"
	desc = "一台过时的、用于聆听人体声响的医疗仪器。它也能让你看起来像个懂行的人。"
	icon_state = "stethoscope"

/obj/item/clothing/neck/stethoscope/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) //FISH DOCTOR?!

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 把\the [src]放在[user.p_their()]胸口！看起来[user.p_they()]听不到多少声音了！"))
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/target, mob/living/user)
	if(!ishuman(target) || !isliving(user))
		return ..()
	if(user.combat_mode)
		return

	var/mob/living/carbon/carbon_patient = target
	var/body_part = carbon_patient.parse_zone_with_bodypart(user.zone_selected)
	var/oxy_loss = carbon_patient.get_oxy_loss()

	var/heart_strength
	var/pulse_pressure
	var/having_heart_attack = carbon_patient.has_status_effect(/datum/status_effect/heart_attack)
	var/heart_noises = TRUE

	var/obj/item/organ/heart/heart = carbon_patient.get_organ_slot(ORGAN_SLOT_HEART)
	var/obj/item/organ/lungs/lungs = carbon_patient.get_organ_slot(ORGAN_SLOT_LUNGS)
	var/obj/item/organ/liver/liver = carbon_patient.get_organ_slot(ORGAN_SLOT_LIVER)
	var/obj/item/organ/appendix/appendix = carbon_patient.get_organ_slot(ORGAN_SLOT_APPENDIX)

	var/render_list = list()//information will be packaged in a list for clean display to the user

	//determine what specific action we're taking
	switch (body_part)
		if(BODY_ZONE_CHEST)//Listening to the chest
			user.visible_message(span_notice("[user] 将 [src] 贴在 [carbon_patient] 的 [body_part] 上，专注地倾听着。"), ignored_mobs = user)
			if(HAS_TRAIT(user, TRAIT_DEAF))
				to_chat(user, span_notice("You place [src] against [carbon_patient]'s [body_part]. Fat load of good it does you though, since you can't hear."))
				return
			else
				render_list += span_info("You place [src] against [carbon_patient]'s [body_part]:\n")

			//assess breathing
			var/lung_noises = TRUE
			if(isnull(lungs) \
				|| carbon_patient.stat == DEAD \
				|| (HAS_TRAIT(carbon_patient, TRAIT_FAKEDEATH)) \
				|| (HAS_TRAIT(carbon_patient, TRAIT_NOBREATH))\
				|| carbon_patient.failed_last_breath \
				|| carbon_patient.losebreath)//If pt is dead or otherwise not breathing
				render_list += "<span class='danger ml-1'>[target.p_Theyre()] not breathing!</span>\n"
				lung_noises = FALSE

			else if(lungs.damage > 10)//if breathing, check for lung damage
				render_list += "<span class='danger ml-1'>You hear fluid in [target.p_their()] lungs!</span>\n"
			else if(oxy_loss > 10)//if they have suffocation damage
				render_list += "<span class='danger ml-1'>[target.p_Theyre()] breathing heavily!</span>\n"
			else
				render_list += "<span class='notice ml-1'>[target.p_Theyre()] breathing normally.</span>\n"//they're okay :D
			if(lung_noises)
				render_list += "<span class='notice ml-1'>[lungs.hear_breath_noise(user)]</span>\n"
			//assess heart
			if(body_part == BODY_ZONE_CHEST)//if we're listening to the chest
				if(isnull(heart) || !heart.is_beating() || carbon_patient.stat == DEAD)
					render_list += "<span class='danger ml-1'>You don't hear a heartbeat!</span>\n"//they're dead or their heart isn't beating
					heart_noises = FALSE
				else if(having_heart_attack)
					render_list += "<span class='danger ml-1'>You hear a rapid, irregular heartbeat.</span>\n"
				else if(heart.damage > 10 || carbon_patient.get_blood_volume(apply_modifiers = TRUE) <= BLOOD_VOLUME_OKAY)
					render_list += "<span class='danger ml-1'>You hear a weak heartbeat.</span>\n"//their heart is damaged, or they have critical blood
				else
					render_list += "<span class='notice ml-1'>You hear a healthy heartbeat.</span>\n"//they're okay :D
				if(heart_noises)
					render_list += "<span class='notice ml-1'>[heart.hear_beat_noise(user)]</span>\n"

		if(BODY_ZONE_PRECISE_GROIN)//If we're targeting the groin
			render_list += span_info("你小心地按压[carbon_patient]的腹部：\n")
			user.visible_message(span_notice("[user]将手按在[carbon_patient]的腹部上。"), ignored_mobs = user)

			//assess abdominal organs
			var/appendix_okay = TRUE
			var/liver_okay = TRUE
			if(!liver)//sanity check, ensure the patient actually has a liver
				render_list += "<span class='danger ml-1'>You can't feel anything where [target.p_their()] liver would be.</span>\n"
				liver_okay = FALSE
			else
				if(liver.damage > 10)
					render_list += "<span class='danger ml-1'>[target.p_Their()] liver feels firm.</span>\n"//their liver is damaged
					liver_okay = FALSE
			if(!appendix)//sanity check, ensure the patient actually has an appendix
				render_list += "<span class='danger ml-1'>You can't feel anything where [target.p_their()] appendix would be.</span>\n"
				appendix_okay = FALSE
			else
				if(appendix.damage > 10 && carbon_patient.stat == CONSCIOUS)
					render_list += "<span class='danger ml-1'>[target] screams when you lift your hand from [target.p_their()] appendix!</span>\n"//scream if their appendix is damaged and they're awake
					target.emote("scream")
					appendix_okay = FALSE
			if(liver_okay && appendix_okay)//if they have all their organs and have no detectable damage
				render_list += "<span class='notice ml-1'>You don't find anything abnormal.</span>\n"//they're okay :D

		if(BODY_ZONE_PRECISE_EYES)
			balloon_alert(user, "做不到！")
			return

		if(BODY_ZONE_PRECISE_MOUTH)
			balloon_alert(user, "做不到！")
			return

		else//targeting an extremity or the head
			if(body_part ==  BODY_ZONE_HEAD)
				render_list += span_info("你小心地将手指按在[carbon_patient]的颈部：\n")
				user.visible_message(span_notice("[user]将手指按在[carbon_patient]的颈部。"), ignored_mobs = user)
			else
				render_list += span_info("你小心地将手指按在[carbon_patient]的[body_part]上：\n")
				user.visible_message(span_notice("[user]将手指按在[carbon_patient]的[body_part]上。"), ignored_mobs = user)

			var/cached_blood_volume = carbon_patient.get_blood_volume(apply_modifiers = TRUE)

			//assess pulse (heart & blood level)
			if(isnull(heart) || !heart.is_beating() || cached_blood_volume <= BLOOD_VOLUME_OKAY || carbon_patient.stat == DEAD)
				render_list += "<span class='danger ml-1'>You can't find a pulse!</span>\n"//they're dead, their heart isn't beating, or they have critical blood
			else
				if(having_heart_attack)
					heart_strength = span_danger("irregular")
				else if(heart.damage > 10)
					heart_strength = span_danger("weak")//their heart is damaged
				else
					heart_strength = span_notice("regular")//they're okay :D

				if((cached_blood_volume <= BLOOD_VOLUME_SAFE && cached_blood_volume > BLOOD_VOLUME_OKAY) || having_heart_attack)
					pulse_pressure = span_danger("thready")//low blood
				else
					pulse_pressure = span_notice("strong")//they're okay :D

				render_list += "<span class='notice ml-1'>[target.p_Their()] pulse is [pulse_pressure] and [heart_strength].</span>\n"

	//display our packaged information in an examine block for easy reading
	to_chat(user, boxed_message(jointext(render_list, "")), type = MESSAGE_TYPE_INFO)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf
	name = "围巾"
	desc = "一个时尚的围巾。对于那些有敏锐时尚感的人，以及那些不能忍受脖子上的冷风的人来说，这是完美的冬季配饰。"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/scarf"
	post_init_icon_state = "scarf"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#EEEEEE#EEEEEE"
	greyscale_config = /datum/greyscale_config/scarf
	greyscale_config_worn = /datum/greyscale_config/scarf/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/scarf/black
	name = "黑围巾"
	icon_state = "/obj/item/clothing/neck/scarf/black"
	greyscale_colors = "#4A4A4B#4A4A4B"

/obj/item/clothing/neck/scarf/pink
	name = "粉围巾"
	icon_state = "/obj/item/clothing/neck/scarf/pink"
	greyscale_colors = "#F699CD#F699CD"

/obj/item/clothing/neck/scarf/red
	name = "红围巾"
	icon_state = "/obj/item/clothing/neck/scarf/red"
	greyscale_colors = "#D91414#D91414"

/obj/item/clothing/neck/scarf/green
	name = "绿围巾"
	icon_state = "/obj/item/clothing/neck/scarf/green"
	greyscale_colors = "#5C9E54#5C9E54"

/obj/item/clothing/neck/scarf/darkblue
	name = "深蓝围巾"
	icon_state = "/obj/item/clothing/neck/scarf/darkblue"
	greyscale_colors = "#1E85BC#1E85BC"

/obj/item/clothing/neck/scarf/purple
	name = "紫围巾"
	icon_state = "/obj/item/clothing/neck/scarf/purple"
	greyscale_colors = "#9557C5#9557C5"

/obj/item/clothing/neck/scarf/yellow
	name = "黄围巾"
	icon_state = "/obj/item/clothing/neck/scarf/yellow"
	greyscale_colors = "#E0C14F#E0C14F"

/obj/item/clothing/neck/scarf/orange
	name = "橙围巾"
	icon_state = "/obj/item/clothing/neck/scarf/orange"
	greyscale_colors = "#C67A4B#C67A4B"

/obj/item/clothing/neck/scarf/cyan
	name = "青围巾"
	icon_state = "/obj/item/clothing/neck/scarf/cyan"
	greyscale_colors = "#54A3CE#54A3CE"

/obj/item/clothing/neck/scarf/zebra
	name = "条纹围巾"
	icon_state = "/obj/item/clothing/neck/scarf/zebra"
	greyscale_colors = "#333333#EEEEEE"

/obj/item/clothing/neck/scarf/christmas
	name = "圣诞围巾"
	icon_state = "/obj/item/clothing/neck/scarf/christmas"
	greyscale_colors = "#038000#960000"

/obj/item/clothing/neck/large_scarf
	name = "大围巾"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/large_scarf"
	post_init_icon_state = "large_scarf"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW
	greyscale_config = /datum/greyscale_config/scarf
	greyscale_config_worn = /datum/greyscale_config/scarf/worn
	greyscale_colors = "#C6C6C6#EEEEEE"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/large_scarf/red
	name = "红色大围巾"
	icon_state = "/obj/item/clothing/neck/large_scarf/red"
	greyscale_colors = "#8A2908#A06D66"

/obj/item/clothing/neck/large_scarf/green
	name = "绿色大围巾"
	icon_state = "/obj/item/clothing/neck/large_scarf/green"
	greyscale_colors = "#525629#888674"

/obj/item/clothing/neck/large_scarf/blue
	name = "蓝色大围巾"
	icon_state = "/obj/item/clothing/neck/large_scarf/blue"
	greyscale_colors = "#20396C#6F7F91"

/obj/item/clothing/neck/large_scarf/syndie
	name = "可疑的条纹围巾"
	desc = "Ready to operate."
	icon_state = "/obj/item/clothing/neck/large_scarf/syndie"
	greyscale_colors = "#B40000#545350"
	armor_type = /datum/armor/large_scarf_syndie

/obj/item/clothing/neck/infinity_scarf
	name = "无限围巾"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/infinity_scarf"
	post_init_icon_state = "infinity_scarf"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW
	greyscale_colors = COLOR_VERY_LIGHT_GRAY
	greyscale_config = /datum/greyscale_config/infinity_scarf
	greyscale_config_worn = /datum/greyscale_config/infinity_scarf/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/petcollar
	name = "宠物项圈"
	desc = "为宠物准备的。"
	icon_state = "petcollar"
	var/tagname = null
	var/human_wearable = FALSE

/datum/armor/large_scarf_syndie
	fire = 50
	acid = 40

/obj/item/clothing/neck/petcollar/mob_can_equip(mob/M, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE, ignore_equipped = FALSE, indirect_action = FALSE)
	if(!ismonkey(M) && !human_wearable)
		return FALSE
	return ..()

/obj/item/clothing/neck/petcollar/wearable
	human_wearable = TRUE

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = sanitize_name(tgui_input_text(user, "你想要更改标签上的名字吗？", "宠物命名", "Spot", MAX_NAME_LEN))
	if (!tagname || !length(tagname))
		name = initial(name)
		tagname = null
		return
	name = "[initial(name)] - [tagname]"

/obj/item/clothing/neck/petcollar/wearable/cyber
	desc = "You wear the tie, or you wear this. Your choice."
	icon_state = "petcollar_cyber"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "金项链"
	desc = "该死，当地痞无赖的感觉可真好。"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/necklace/dope/merchant
	desc = "不要问它是怎么工作的，证据就在全息芯片里！"
	/// scales the amount received in case an admin wants to emulate taxes/fees.
	var/profit_scaling = 1
	/// toggles between sell (TRUE) and get price post-fees (FALSE)
	var/selling = FALSE

/obj/item/clothing/neck/necklace/dope/merchant/attack_self(mob/user)
	. = ..()
	selling = !selling
	to_chat(user, span_notice("[src] has been set to [selling ? "'Sell'" : "'Get Price'"] mode."))

/obj/item/clothing/neck/necklace/dope/merchant/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/datum/export_report/ex = export_item_and_contents(interacting_with, delete_unsold = selling, dry_run = !selling)
	var/price = 0
	for(var/x in ex.total_amount)
		price += ex.total_value[x]

	if(price)
		var/true_price = round(price*profit_scaling)
		var/fee_display = round(price-true_price)
		to_chat(user, span_notice("[selling ? "Sold" : "Getting the price of"] [interacting_with], value: <b>[true_price]</b> [MONEY_NAME][interacting_with.contents.len ? " (exportable contents included)" : ""].[profit_scaling < 1 && selling ? "<b>[fee_display]</b> [MONEY_NAME_AUTOPURAL(fee_display)] taken as processing fee\s." : ""]"))
		if(selling)
			new /obj/item/holochip(get_turf(user), true_price)
	else
		to_chat(user, span_warning("There is no export value for [interacting_with] or any items within it."))

	return ITEM_INTERACT_BLOCKING

/obj/item/clothing/neck/beads
	name = "塑料珠项链"
	desc = "A cheap, plastic bead necklace. Show team spirit! Collect them! Throw them away! The possibilities are endless!"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "beads"
	color = "#ffffff"
	custom_price = PAYCHECK_CREW * 0.2
	custom_materials = (list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT*5))

/obj/item/clothing/neck/beads/Initialize(mapload)
	. = ..()
	color = color = pick("#ff0077","#d400ff","#2600ff","#00ccff","#00ff2a","#e5ff00","#ffae00","#ff0000", "#ffffff")

/obj/item/clothing/neck/wreath
	name = "\improper Watcher Wreath"
	desc = "An elaborate crown made from the twisted flesh and sinew of a watcher. \
		Wearing it makes you feel like you have eyes in the back of your head."
	icon_state = "watcher_wreath"
	worn_y_offset = 10
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 2, /datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2)

/obj/item/clothing/neck/wreath/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "wreath_emissive", src, alpha = src.alpha)

/obj/item/clothing/neck/wreath/icewing
	name = "\improper 冰翼花冠"
	desc = "An elaborate crown made from the twisted flesh and sinew of an icewing watcher. \
		Wearing it sends shivers down your spine just from being near it."
	icon_state = "icewing_wreath"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT, /datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2)
