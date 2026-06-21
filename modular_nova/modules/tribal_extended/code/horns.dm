/// Constants for stamina usage and thresholds for both horn types
#define BHORN_STAMINA_MINIMUM 11
#define WHORN_STAMINA_MINIMUM 1
#define BHORN_STAMINA_USE 10
#define WHORN_STAMINA_USE 50

/// Blowing horn item variant (carried by players)
/obj/item/blowing_horn
	name = "吹奏号角"
	desc = "一种用野兽角制成的粗糙乐器，据说曾在地精袭击时用来召集族人——至少故事里是这么说的。"
	icon = 'modular_nova/modules/tribal_extended/icons/items_and_weapons.dmi'
	icon_state = "blow_horn"
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_SUITSTORE
	///List of tunes that can be selected when using the item.
	var/list/tune_patterns = list("short short long", "long short", "short long short", "long long", "short short short")
	///Currently selected tune in the previous list.
	var/current_tune = "short short long"
	COOLDOWN_DECLARE(bhorn_cooldown)

/obj/item/blowing_horn/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/blowing_horn/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(!user.is_holding(src))
		return
	context[SCREENTIP_CONTEXT_CTRL_SHIFT_LMB] = "Switch tune"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/blowing_horn/examine(mob/user)
	. = ..()
	. += span_notice("使用[EXAMINE_HINT("Shift+Ctrl+Click")]切换曲调。")

/// Switch horn tune on ctrl+shift click
/obj/item/blowing_horn/click_ctrl_shift(mob/user)
	switch_tune(user)

/// Blows the horn if the user has enough stamina
/obj/item/blowing_horn/attack_self(mob/living/user)
	if (user.get_stamina_loss() > BHORN_STAMINA_MINIMUM)
		balloon_alert(user, "太累了！")
		return
	var/bhorn_origin = get_turf(user)
	if (user.is_mouth_covered())
		balloon_alert(user, "有东西挡着！")
		return
	else if (isspaceturf(bhorn_origin))
		user.visible_message(
			span_emote("[user] 举起号角，对着虚无的太空吹响。什么也没发生。"),
			span_notice("你试图在太空真空中吹响号角。你指望能发生什么？")
		)
		return
	if(!COOLDOWN_FINISHED(src, bhorn_cooldown))
		balloon_alert(user, "等待[COOLDOWN_TIMELEFT(src, bhorn_cooldown) / 10]秒！")
		return
	else
		user.visible_message(
			span_emote("[user] 举起号角，用尽全力吹响。"),
			span_notice("你竭尽全力吹响了号角。")
		)
		for (var/mob/hearing_player as anything in SSmobs.clients_by_zlevel[user.z])
			if (get_dist(hearing_player, user) >= 170)
				continue
			if (HAS_TRAIT(hearing_player, TRAIT_DEAF))
				continue
			var/direction_text = span_bold("[dir2text(get_dir(get_turf(hearing_player), bhorn_origin))]")
			hearing_player.playsound_local(bhorn_origin, 'modular_nova/master_files/sound/items/blow_horn.ogg', 150, TRUE)
			if (hearing_player != user)
				hearing_player.show_message(span_warning("在 [direction_text] 方向的某处，号角以某种模式鸣响：'[current_tune]'。"))
	user.adjust_stamina_loss(BHORN_STAMINA_USE)
	COOLDOWN_START(src, bhorn_cooldown, 5.5 SECONDS)

/// Switches the current tune of the horn to the next in the list
/obj/item/blowing_horn/proc/switch_tune(mob/user)
	var/selected_tune = tgui_input_list(user, "选择要播放的曲调", "可用曲调", tune_patterns)
	if(isnull(selected_tune))
		return
	current_tune = selected_tune
	to_chat(user, span_notice("你准备以模式：'[current_tune]' 吹响号角。"))

/// Adds additional info to horn examination
/obj/item/blowing_horn/examine(mob/user)
	. = ..()
	if (!in_range(user, src))
		return
	. += span_notice("当前选定模式：<b>[current_tune]</b>")
	. += span_notice("使用[EXAMINE_HINT("Shift+Ctrl+Click")]切换曲调。")

/// War horn structure variant (stationary object)
/obj/structure/war_horn
	name = "战争号角"
	desc = "一个比记忆更古老的号角，由早已消失的双手塑造。当它响起时，大地会倾听。旧日战争的呼吸仍在其螺旋中萦绕。一声呼唤，那些记得的人便会回应。（Alt+点击切换模式。）"
	icon = 'modular_nova/modules/tribal_extended/icons/items_and_weapons.dmi'
	icon_state = "war_horn"
	resistance_flags = FLAMMABLE
	anchored = TRUE
	///List of tunes that can be selected when using the structure.
	var/list/tune_patterns = list("short short long", "long short", "short long short", "long long", "short short short")
	///Currently selected tune in the previous list.
	var/current_tune = "short short long"
	COOLDOWN_DECLARE(whorn_cooldown)

/obj/structure/war_horn/Initialize(mapload)
	. = ..()
	register_context()

/obj/structure/war_horn/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if (!in_range(user, src))
		return
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Switch tune"
	return CONTEXTUAL_SCREENTIP_SET

/// Adds additional info to horn examination
/obj/structure/war_horn/examine(mob/user)
	. = ..()
	if (!in_range(user, src))
		return
	. += span_notice("使用[EXAMINE_HINT("Alt+Click")]切换曲调。")
	. += span_notice("当前选定模式：<b>[current_tune]</b>")

/// Switch war horn tune on alt-click
/obj/structure/war_horn/click_alt(mob/living/user)
	switch_tune(user)
	return CLICK_ACTION_SUCCESS

/// Plays war horn sound globally to all valid players
/obj/structure/war_horn/attack_hand(mob/living/user)
	if (!ishuman(user))
		balloon_alert(user, "你无法使用这个！")
		return
	if (user.get_stamina_loss() > WHORN_STAMINA_MINIMUM)
		balloon_alert(user, "太累了！")
		return
	if (user.is_mouth_covered())
		balloon_alert(user, "有东西挡着！")
		return
	if(!COOLDOWN_FINISHED(src, whorn_cooldown))
		balloon_alert(user, "等待 [COOLDOWN_TIMELEFT(src, whorn_cooldown) / 10] 秒！")
		return
	///This shouldn't happen as the war horn spawns in the natives camps and isn't movable.
	var/location = get_turf(user)
	if (!is_mining_level(user.z))
		user.visible_message(
			span_emote("[user] 稳住身形，从这件为不同大气环境调音的乐器中发出微弱的声音。"),
			span_warning("你吹响了战争号角，但它只发出微弱的声音，这是为不同大气环境调音的。")
		)
		playsound(location, 'modular_nova/modules/admin/sound/duckhonk.ogg', 100, TRUE)
		return
	var/loc_text = "the molten wastes of Indecipheres"
	if (SSmapping.level_trait(user.z, ZTRAIT_ICE_RUINS_UNDERGROUND))
		loc_text = "the depths of Freyja's caves"
	user.visible_message(
		span_emote("[user] 稳住身形，在战争号角上吹出一声雷鸣般的巨响。"),
		span_warning("你竭尽全力吹响了战争号角。")
	)
	for (var/mob/hearing_player in GLOB.player_list)
		if (!is_mining_level(hearing_player.z) || HAS_TRAIT(hearing_player, TRAIT_DEAF))
			continue
		hearing_player.show_message(span_big("战争号角的声音从 [loc_text] 传来——其节奏为：'[current_tune]'。"))
		hearing_player.playsound_local(location, 'modular_nova/master_files/sound/items/war_horn.ogg', 150, TRUE)
	user.adjust_stamina_loss(WHORN_STAMINA_USE)
	COOLDOWN_START(src, whorn_cooldown, 11.5 SECONDS)


/// Switches the current tune of the horn to the next in the list
/obj/structure/war_horn/proc/switch_tune(mob/user)
	var/selected_tune = tgui_input_list(user, "选择要播放的曲调", "可用曲调", tune_patterns)
	if(isnull(selected_tune))
		return
	current_tune = selected_tune
	to_chat(user, span_notice("你准备以模式：'[current_tune]' 吹响号角。"))

/// Cleanup macros
#undef BHORN_STAMINA_MINIMUM
#undef WHORN_STAMINA_MINIMUM
#undef BHORN_STAMINA_USE
#undef WHORN_STAMINA_USE
