/* Kitchen tools
 * Contains:
 * Fork
 * Kitchen knives
 * Rolling Pins
 * Plastic Utensils
 * Tongs
 */

#define PLASTIC_BREAK_PROBABILITY 25

/obj/item/kitchen
	icon = 'icons/obj/service/kitchen.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	abstract_type = /obj/item/kitchen
	worn_icon_state = "kitchen_tool"

/obj/item/kitchen/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_APC_SHOCKING, INNATE_TRAIT)

/obj/item/kitchen/fork
	name = "叉子"
	desc = "尖锐。"
	icon_state = "fork"
	icon_angle = -90
	force = 4
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.8)
	obj_flags = CONDUCTS_ELECTRICITY
	attack_verb_continuous = list("attacks", "stabs", "pokes")
	attack_verb_simple = list("attack", "stab", "poke")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	armor_type = /datum/armor/kitchen_fork
	sharpness = SHARP_POINTY
	var/datum/reagent/forkload //used to eat omelette
	custom_price = PAYCHECK_LOWER
	sound_vary = TRUE
	pickup_sound = SFX_CUTLERY_PICKUP
	drop_sound = SFX_CUTLERY_DROP

/datum/armor/kitchen_fork
	fire = 50
	acid = 30

/obj/item/kitchen/fork/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)

/obj/item/kitchen/fork/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] stabs \the [src] into [user.p_their()] chest! It looks like [user.p_theyre()] trying to take a bite out of [user.p_them()]self!"))
	playsound(src, 'sound/items/eatfood.ogg', 50, TRUE)
	return BRUTELOSS

/obj/item/kitchen/fork/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()

	if(forkload)
		if(M == user)
			M.visible_message(span_notice("[user] 享用了一叉美味的煎蛋卷！"))
			M.reagents.add_reagent(forkload.type, 1)
		else
			M.visible_message(span_notice("[user] 喂给 [M] 一叉美味的煎蛋卷！"))
			M.reagents.add_reagent(forkload.type, 1)
		icon_state = "fork"
		forkload = null
	else
		return ..()

/obj/item/kitchen/fork/plastic
	name = "塑料叉子"
	desc = "瞬间将你带回高中午餐时光。"
	icon_state = "plastic_fork"
	force = 0
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	custom_materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.8)
	custom_price = PAYCHECK_LOWER * 1
	pickup_sound = null
	drop_sound = null

/obj/item/kitchen/fork/plastic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/easily_fragmented, PLASTIC_BREAK_PROBABILITY)

/obj/item/knife/kitchen
	name = "厨房刀"
	desc = "一把由太空烹饪公司制造的多用途厨师刀。保证多年锋利如新。"

/obj/item/knife/plastic
	name = "塑料刀"
	icon_state = "plastic_knife"
	inhand_icon_state = "knife"
	desc = "一把非常安全、几乎不锋利的塑料刀。适合切食物，其他用途有限。"
	force = 0
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_range = 5
	custom_materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT)
	attack_verb_continuous = list("prods", "whiffs", "scratches", "pokes")
	attack_verb_simple = list("prod", "whiff", "scratch", "poke")
	sharpness = SHARP_EDGED
	custom_price = PAYCHECK_LOWER * 2
	pickup_sound = null
	drop_sound = null

/obj/item/knife/plastic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/easily_fragmented, PLASTIC_BREAK_PROBABILITY)

/obj/item/knife/kitchen/silicon
	name = "厨房工具套装"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "sili_knife"
	icon_angle = 0
	desc = "合成工程学的突破性成果，这把刀被编程为在非烹饪用途时会变钝，并且可以将刀片更换为擀面杖"
	force = 0
	throwforce = 0
	sharpness = SHARP_EDGED
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("prods", "whiffs", "scratches", "pokes")
	attack_verb_simple = list("prod", "whiff", "scratch", "poke")
	tool_behaviour = TOOL_KNIFE

/obj/item/knife/kitchen/silicon/get_all_tool_behaviours()
	return list(TOOL_ROLLINGPIN, TOOL_KNIFE)

/obj/item/knife/kitchen/silicon/examine()
	. = ..()
	. += "It's fitted with a [tool_behaviour] head."

/obj/item/knife/kitchen/silicon/attack_self(mob/user)
	playsound(get_turf(user), 'sound/items/tools/change_drill.ogg', 50, TRUE)
	if(tool_behaviour != TOOL_ROLLINGPIN)
		tool_behaviour = TOOL_ROLLINGPIN
		to_chat(user, span_notice("你将擀面杖组件安装到[src]上。"))
		icon_state = "sili_rolling_pin"
		force = 8
		sharpness = NONE
		hitsound = SFX_SWING_HIT
		attack_verb_continuous = list("bashes", "batters", "bludgeons", "thrashes", "whacks")
		attack_verb_simple = list("bash", "batter", "bludgeon", "thrash", "whack")

	else
		tool_behaviour = TOOL_KNIFE
		to_chat(user, span_notice("你将刀具组件安装到[src]上。"))
		icon_state = "sili_knife"
		force = 0
		sharpness = SHARP_EDGED
		hitsound = 'sound/items/weapons/bladeslice.ogg'
		attack_verb_continuous = list("prods", "whiffs", "scratches", "pokes")
		attack_verb_simple = list("prod", "whiff", "scratch", "poke")

/obj/item/kitchen/rollingpin
	name = "擀面杖"
	desc = "用来敲晕酒保。"
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "rolling_pin"
	worn_icon_state = "rolling_pin"
	inhand_icon_state = "rolling_pin"
	icon_angle = -45
	force = 8
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("bashes", "batters", "bludgeons", "thrashes", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "thrash", "whack")
	custom_price = PAYCHECK_CREW * 1.5
	tool_behaviour = TOOL_ROLLINGPIN
	sound_vary = TRUE
	pickup_sound = SFX_ROLLING_PIN_PICKUP
	drop_sound = SFX_ROLLING_PIN_DROP


/obj/item/kitchen/rollingpin/illegal
	name = "金属擀面杖"
	desc = "一根沉重的金属擀面杖，用来砸碎那些烦人的食材。"
	icon_state = "metal_rolling_pin"
	inhand_icon_state = "metal_rolling_pin"
	force = 12
	obj_flags = CONDUCTS_ELECTRICITY
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plastic = SHEET_MATERIAL_AMOUNT * 1.5)
	custom_price = PAYCHECK_CREW * 2
	exposed_wound_bonus = 14

/obj/item/kitchen/rollingpin/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始用\the [user.p_their()] 拍扁[src] 的头！看起来[user.p_theyre()] 想自杀！"))
	return BRUTELOSS
/* Trays  moved to /obj/item/storage/bag */

/obj/item/kitchen/spoon
	name = "勺子"
	desc = "小心别让你的食物先把勺子给熔化了。"
	icon_state = "spoon"
	base_icon_state = "spoon"
	icon_angle = -90
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CONDUCTS_ELECTRICITY
	force = 2
	throw_speed = 3
	throw_range = 5
	attack_verb_simple = list("whack", "spoon", "tap")
	attack_verb_continuous = list("whacks", "spoons", "taps")
	armor_type = /datum/armor/kitchen_spoon
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 1.2)
	custom_price = PAYCHECK_LOWER * 2
	tool_behaviour = TOOL_MINING
	toolspeed = 25 // Literally 25 times worse than the base pickaxe
	sound_vary = TRUE
	pickup_sound = SFX_CUTLERY_PICKUP
	drop_sound = SFX_CUTLERY_DROP

	var/spoon_sip_size = 5

/obj/item/kitchen/spoon/Initialize(mapload)
	. = ..()
	create_reagents(5, INJECTABLE|OPENCONTAINER|DUNKABLE)
	register_item_context()

/obj/item/kitchen/spoon/create_reagents(max_vol, flags)
	. = ..()
	RegisterSignal(reagents, COMSIG_REAGENTS_HOLDER_UPDATED, PROC_REF(on_reagent_change))

/obj/item/kitchen/spoon/proc/on_reagent_change(datum/reagents/reagents)
	SIGNAL_HANDLER

	update_appearance(UPDATE_OVERLAYS)

/obj/item/kitchen/spoon/add_item_context(obj/item/source, list/context, atom/target, mob/living/user)
	if(target.is_open_container())
		context[SCREENTIP_CONTEXT_LMB] = "Empty spoonful"
		context[SCREENTIP_CONTEXT_RMB] = "Grab spoonful"
		return CONTEXTUAL_SCREENTIP_SET
	if(isliving(target))
		context[SCREENTIP_CONTEXT_LMB] = target == user ? "[spoon_sip_size >= reagents.maximum_volume ? "Swallow" : "Taste"] spoonful" : "Give spoonful"
		return CONTEXTUAL_SCREENTIP_SET
	return NONE

/obj/item/kitchen/spoon/update_overlays()
	. = ..()
	if(reagents.total_volume <= 0)
		return
	var/mutable_appearance/filled_overlay = mutable_appearance(icon, "[base_icon_state]_filled")
	filled_overlay.color = mix_color_from_reagents(reagents.reagent_list)
	. += filled_overlay

/obj/item/kitchen/spoon/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!target_mob.reagents || reagents.total_volume <= 0)
		return  ..()

	if(target_mob.is_mouth_covered(ITEM_SLOT_HEAD) || target_mob.is_mouth_covered(ITEM_SLOT_MASK))
		if(target_mob == user)
			target_mob.balloon_alert(user, "嘴被遮住了，没法吃！")
		else
			target_mob.balloon_alert(user, "[target_mob.p_their()] 嘴被遮住了！")
		return TRUE

	if(target_mob == user)
		user.visible_message(
			span_notice("[user]舀了一勺送进[user.p_their()]嘴里。"),
			span_notice("你舀了一勺送进自己嘴里。")
		)

	else
		to_chat(target_mob, span_userdanger("[target_mob.is_blind() ? "Someone" : "[user]"] 把勺子塞进你脸上！"))
		target_mob.balloon_alert(user, "正在喂食一勺...")
		if(!do_after(user, 3 SECONDS, target_mob))
			target_mob.balloon_alert(user, "被打断了！")
			return TRUE

		to_chat(target_mob, span_userdanger("[target_mob.is_blind() ? "You are forced to" : "[user] forces you to"] 吞下了一勺东西！"))
		user.visible_message(
			span_danger("[user] 舀了一勺塞进 [target_mob] 的嘴里。"),
			span_notice("你舀了一勺塞进 [target_mob] 的嘴里。")
		)

	playsound(target_mob, 'sound/items/drink.ogg', rand(10,50), vary = TRUE)
	reagents.trans_to(target_mob, spoon_sip_size, methods = INGEST)
	return TRUE

/obj/item/kitchen/spoon/pre_attack(atom/attacked_atom, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return
	if(isliving(attacked_atom))
		return
	if(!attacked_atom.is_open_container())
		return
	if(reagents.total_volume <= 0)
		return

	var/amount_given = reagents.trans_to(attacked_atom, reagents.maximum_volume)
	if(amount_given >= reagents.total_volume)
		attacked_atom.balloon_alert(user, "勺子清空了")
	else if(amount_given > 0)
		attacked_atom.balloon_alert(user, "勺子部分清空")
	else
		attacked_atom.balloon_alert(user, "已经满了！")
	return TRUE

/obj/item/kitchen/spoon/pre_attack_secondary(atom/attacked_atom, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(isliving(attacked_atom))
		return SECONDARY_ATTACK_CALL_NORMAL
	if(!attacked_atom.is_open_container())
		return SECONDARY_ATTACK_CALL_NORMAL

	if(reagents.total_volume >= reagents.maximum_volume || attacked_atom.reagents.total_volume <= 0)
		return SECONDARY_ATTACK_CALL_NORMAL

	if(attacked_atom.reagents.trans_to(src, reagents.maximum_volume))
		attacked_atom.balloon_alert(user, "舀了一勺")
	else
		attacked_atom.balloon_alert(user, "勺子已经满了！")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/kitchen/spoon/plastic
	name = "塑料勺"
	icon_state = "plastic_spoon"
	force = 0
	custom_materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 1.2)
	toolspeed = 75 // The plastic spoon takes 5 minutes to dig through a single mineral turf... It's one, continuous, breakable, do_after...
	custom_price = PAYCHECK_LOWER * 1
	pickup_sound = null
	drop_sound = null

/datum/armor/kitchen_spoon
	fire = 50
	acid = 30

/obj/item/kitchen/spoon/plastic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/easily_fragmented, PLASTIC_BREAK_PROBABILITY)

/obj/item/kitchen/spoon/soup_ladle
	name = "长柄勺"
	desc = "长柄勺不就是个滑稽的大勺子吗？"
	icon_state = "ladle"
	base_icon_state = "ladle"
	inhand_icon_state = "spoon"
	icon_angle = 90
	custom_price = PAYCHECK_LOWER * 4
	spoon_sip_size = 3 // just a taste

/obj/item/kitchen/spoon/soup_ladle/Initialize(mapload)
	. = ..()
	create_reagents(SOUP_SERVING_SIZE + 5, INJECTABLE|OPENCONTAINER)

/// Tongs, let you pick up and feed people food from further away.
/obj/item/kitchen/tongs
	name = "夹子"
	desc = "这样你就不用用你那脏兮兮、没洗过的手去碰任何东西了。"
	reach = 2
	icon_state = "tongs"
	base_icon_state = "tongs"
	inhand_icon_state = "fork" // close enough
	icon_angle = -45
	attack_verb_continuous = list("pinches", "tongs", "nips")
	attack_verb_simple = list("pinch", "tong", "nip")
	/// What are we holding in our tongs?
	var/obj/item/tonged
	/// Sound to play when we click our tongs together
	var/clack_sound = 'sound/items/handling/component_drop.ogg'
	/// Time to wait between clacking sounds
	var/clack_delay = 2 SECONDS
	/// Have we clacked recently?
	COOLDOWN_DECLARE(clack_cooldown)

/obj/item/kitchen/tongs/Destroy(force)
	QDEL_NULL(tonged)
	return ..()

/obj/item/kitchen/tongs/examine(mob/user)
	. = ..()
	if (!isnull(tonged))
		. += span_notice("它正夹着 [tonged]。")

/obj/item/kitchen/tongs/dropped(mob/user, silent)
	. = ..()
	drop_tonged()

/obj/item/kitchen/tongs/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return TRUE
	if (!isnull(tonged))
		drop_tonged()
		return TRUE
	if (!COOLDOWN_FINISHED(src, clack_cooldown))
		return TRUE
	user.visible_message(span_notice("[user] 像螃蟹一样咔哒咔哒地敲击着 [user.p_their()] 的 [name]。咔嚓咔嚓！"))
	click_clack()
	return TRUE

/// Release the food we are holding
/obj/item/kitchen/tongs/proc/drop_tonged()
	if (isnull(tonged))
		return
	visible_message(span_notice("[tonged] 掉到了地上！"))
	var/turf/location = drop_location()
	tonged.forceMove(location)
	tonged.do_drop_animation(location)

/// Play a clacking sound and appear closed, then open again
/obj/item/kitchen/tongs/proc/click_clack()
	COOLDOWN_START(src, clack_cooldown, clack_delay)
	playsound(src, clack_sound, vol = 100, vary = FALSE)
	icon_state = "[base_icon_state]_closed"
	var/delay = min(0.5 SECONDS, clack_delay / 2) // Just in case someone's been fucking with the cooldown
	addtimer(CALLBACK(src, PROC_REF(clack)), delay, TIMER_DELETE_ME)

/// Plays a clacking sound and appear open
/obj/item/kitchen/tongs/proc/clack()
	playsound(src, clack_sound, vol = 100, vary = FALSE)
	icon_state = base_icon_state

/obj/item/kitchen/tongs/Exited(atom/movable/leaving, direction)
	. = ..()
	if (leaving != tonged)
		return
	tonged = null
	update_appearance(UPDATE_ICON)

/obj/item/kitchen/tongs/pre_attack(obj/item/attacked, mob/living/user, list/modifiers, list/attack_modifiers)
	if (!isnull(tonged) && tonged.force <= 0) // prevents tongs from giving food-weapons extra range
		attacked.attackby(tonged, user)
		return TRUE
	if (isliving(attacked))
		if (COOLDOWN_FINISHED(src, clack_cooldown))
			click_clack()
		return ..()
	if (!IS_EDIBLE(attacked) || attacked.w_class > WEIGHT_CLASS_NORMAL || !isnull(tonged))
		return ..()
	tonged = attacked
	attacked.do_pickup_animation(src)
	attacked.forceMove(src)
	update_appearance(UPDATE_ICON)
	return TRUE

/obj/item/kitchen/tongs/update_overlays()
	. = ..()
	if (isnull(tonged))
		return
	var/mutable_appearance/held_food = new /mutable_appearance(tonged.appearance)
	held_food.layer = layer
	held_food.plane = plane
	held_food.transform = held_food.transform.Scale(0.7, 0.7)
	held_food.pixel_w = 6
	held_food.pixel_z = 6
	. += held_food

#undef PLASTIC_BREAK_PROBABILITY
