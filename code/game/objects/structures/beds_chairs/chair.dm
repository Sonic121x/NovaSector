/obj/structure/chair
	name = "chair"
	desc = "你坐在这里，不是用意志就是用武力。"
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair"
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 0 //you sit in a chair, not lay
	resistance_flags = NONE
	max_integrity = 100
	integrity_failure = 0.1
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	layer = OBJ_LAYER
	interaction_flags_mouse_drop = ALLOW_RESTING

	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 1
	var/item_chair = /obj/item/chair // if null it can't be picked up
	///How much sitting on this chair influences fishing difficulty
	var/fishing_modifier = -5
	var/has_armrest = FALSE

/obj/structure/chair/Initialize(mapload)
	. = ..()
	if(prob(0.2))
		name = "tactical [name]"
		fishing_modifier -= 8
	MakeRotate()
	if(can_buckle && fishing_modifier)
		AddElement(/datum/element/adjust_fishing_difficulty, fishing_modifier)

/obj/structure/chair/buckle_feedback(mob/living/being_buckled, mob/buckler)
	if(HAS_TRAIT(being_buckled, TRAIT_RESTRAINED))
		return ..()

	if(being_buckled == buckler)
		being_buckled.visible_message(
			span_notice("[buckler]坐在了[src]上。"),
			span_notice("你坐在了[src]上。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_buckled.visible_message(
			span_notice("[buckler]让[being_buckled]坐在了[src]上。"),
			span_notice("[buckler]让你坐在了[src]上。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/chair/unbuckle_feedback(mob/living/being_unbuckled, mob/unbuckler)
	if(HAS_TRAIT(being_unbuckled, TRAIT_RESTRAINED))
		return ..()

	if(being_unbuckled == unbuckler)
		being_unbuckled.visible_message(
			span_notice("[unbuckler]从[src]上站了起来。"),
			span_notice("你从[src]上站了起来。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_unbuckled.visible_message(
			span_notice("[unbuckler]把[being_unbuckled]从[src]上扶了起来。"),
			span_notice("[unbuckler]把你从[src]上扶了起来。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/chair/examine(mob/user)
	. = ..()
	. += span_notice("它由几个<b>螺栓</b>固定在一起。")
	if(!has_buckled_mobs() && can_buckle)
		. += span_notice("站在[src]上时，将你的精灵拖放到[src]上即可固定。")

///This proc adds the rotate component, overwrite this if you for some reason want to change some specific args.
/obj/structure/chair/proc/MakeRotate()
	AddElement(/datum/element/simple_rotation, ROTATION_IGNORE_ANCHORED|ROTATION_GHOSTS_ALLOWED)

/obj/structure/chair/Destroy()
	SSjob.latejoin_trackers -= src //These may be here due to the arrivals shuttle
	return ..()

/obj/structure/chair/atom_deconstruct(disassembled)
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	else
		for(var/datum/material/mat as anything in custom_materials)
			new mat.sheet_type(loc, FLOOR(custom_materials[mat] / SHEET_MATERIAL_AMOUNT, 1))

/obj/structure/chair/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/chair/narsie_act()
	var/obj/structure/chair/wood/W = new/obj/structure/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/structure/chair/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(W, /obj/item/assembly/shock_kit) && !HAS_TRAIT(src, TRAIT_ELECTRIFIED_BUCKLE))
		electrify_self(W, user)
		return
	. = ..()

/obj/structure/chair/update_overlays()
	. = ..()
	if (!has_buckled_mobs())
		return
	var/mutable_appearance/armrest = mutable_appearance(icon, "[icon_state]_armrest", ABOVE_MOB_LAYER, src, appearance_flags = KEEP_APART)
	var/mutable_appearance/armrest_blocker = emissive_blocker(icon, "[icon_state]_armrest", src, ABOVE_MOB_LAYER)
	if (cached_color_filter)
		armrest = filter_appearance_recursive(armrest, cached_color_filter)
	. += armrest
	. += armrest_blocker

///allows each chair to request the electrified_buckle component with overlays that dont look ridiculous
/obj/structure/chair/proc/electrify_self(obj/item/assembly/shock_kit/input_shock_kit, mob/user, list/overlays_from_child_procs)
	SHOULD_CALL_PARENT(TRUE)
	if(!user.temporarilyRemoveItemFromInventory(input_shock_kit))
		return
	if(!overlays_from_child_procs || overlays_from_child_procs.len == 0)
		var/mutable_appearance/echair_overlay = mutable_appearance('icons/obj/chairs.dmi', "echair_over", OBJ_LAYER, src, appearance_flags = KEEP_APART)
		AddComponent(/datum/component/electrified_buckle, (SHOCK_REQUIREMENT_ITEM | SHOCK_REQUIREMENT_LIVE_CABLE | SHOCK_REQUIREMENT_SIGNAL_RECEIVED_TOGGLE), input_shock_kit, list(echair_overlay), FALSE)
	else
		AddComponent(/datum/component/electrified_buckle, (SHOCK_REQUIREMENT_ITEM | SHOCK_REQUIREMENT_LIVE_CABLE | SHOCK_REQUIREMENT_SIGNAL_RECEIVED_TOGGLE), input_shock_kit, overlays_from_child_procs, FALSE)

	if(HAS_TRAIT(src, TRAIT_ELECTRIFIED_BUCKLE))
		to_chat(user, span_notice("你将电击套件连接到\the [src]，使其带电"))
	else
		user.put_in_active_hand(input_shock_kit)
		to_chat(user, span_notice("你无法将电击套件安装到\the [src]上！"))


/obj/structure/chair/wrench_act_secondary(mob/living/user, obj/item/weapon)
	..()
	weapon.play_tool_sound(src)
	deconstruct(disassembled = TRUE)
	return TRUE

/obj/structure/chair/attack_tk(mob/user)
	if(!anchored || has_buckled_mobs() || !isturf(user.loc))
		return ..()
	setDir(turn(dir,-90))
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/structure/chair/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/structure/chair/proc/handle_layer()
	if(has_buckled_mobs() && dir == NORTH)
		layer = ABOVE_MOB_LAYER
	else
		layer = OBJ_LAYER

/obj/structure/chair/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	//NOVA EDIT ADDITION
	if(HAS_TRAIT(M, TRAIT_OVERSIZED))
		visible_message(span_warning("[src]在[M]的重压下弯曲断裂了！"))
		playsound(src, 'modular_nova/modules/oversized/sound/chair_break.ogg', 70, TRUE)
		deconstruct()
	//NOVA EDIT END
	if (has_armrest)
		update_appearance()

/obj/structure/chair/post_unbuckle_mob()
	. = ..()
	handle_layer()
	if (has_armrest)
		update_appearance()

/obj/structure/chair/setDir(newdir)
	..()
	handle_rotation(newdir)

// Chair types

///Material chair
/obj/structure/chair/greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	item_chair = /obj/item/chair/greyscale
	buildstacktype = null //Custom mats handle this


/obj/structure/chair/wood
	icon_state = "wooden_chair"
	name = "木椅"
	desc = "经典就是永不过时的时尚"
	resistance_flags = FLAMMABLE
	max_integrity = 40
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 3
	item_chair = /obj/item/chair/wood
	fishing_modifier = -6
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

/obj/structure/chair/wood/narsie_act()
	return

/obj/structure/chair/wood/wings
	icon_state = "wooden_chair_wings"
	item_chair = /obj/item/chair/wood/wings

/obj/structure/chair/comfy
	name = "康乐椅"
	desc = "看起来很舒服。"
	icon_state = "comfychair"
	color = rgb(255, 255, 255)
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstackamount = 2
	item_chair = null
	fishing_modifier = -7
	has_armrest = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/chair/comfy/brown
	color = rgb(70, 47, 28)

/obj/structure/chair/comfy/beige
	color = rgb(240, 238, 198)

/obj/structure/chair/comfy/teal
	color = rgb(117, 214, 214)

/obj/structure/chair/comfy/black
	color = rgb(61, 60, 56)

/obj/structure/chair/comfy/lime
	color = rgb(193, 248, 104)

/obj/structure/chair/comfy/shuttle
	name = "穿梭机椅"
	desc = "一个舒适、安全的座位，它有一个看起来更坚固的屈曲系统，以实现更平稳的飞行。"
	icon_state = "shuttle_chair"
	buildstacktype = /obj/item/stack/sheet/mineral/titanium
	buckle_sound = SFX_SEATBELT_BUCKLE
	unbuckle_sound = SFX_SEATBELT_UNBUCKLE
	resistance_flags = FIRE_PROOF
	max_integrity = 120
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/chair/comfy/shuttle/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/chair/comfy/shuttle/electrify_self(obj/item/assembly/shock_kit/input_shock_kit, mob/user, list/overlays_from_child_procs)
	if(!overlays_from_child_procs)
		var/mutable_appearance/echair_overlay = mutable_appearance('icons/obj/chairs.dmi', "echair_over", OBJ_LAYER, src, appearance_flags = KEEP_APART)
		echair_overlay.pixel_x = -1
		overlays_from_child_procs = list(echair_overlay)
	. = ..()

/obj/structure/chair/comfy/shuttle/buckle_feedback(mob/living/being_buckled, mob/buckler)
	if(being_buckled == buckler)
		being_buckled.visible_message(
			span_notice("[buckler] 坐在 [src] 上，拉下头顶的约束装置来固定 [buckler.p_them()]自己。"),
			span_notice("你坐在[src]上，拉下头顶的安全带将自己固定好。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_buckled.visible_message(
			span_notice("[buckler]让[being_buckled]坐在[src]上，拉下头顶的安全带将[buckler.p_them()]固定好。"),
			span_notice("[buckler]让你坐在[src]上，拉下头顶的安全带将你固定好。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/chair/comfy/shuttle/unbuckle_feedback(mob/living/being_unbuckled, mob/unbuckler)
	if(being_unbuckled == unbuckler)
		being_unbuckled.visible_message(
			span_notice("[unbuckler]掀开头上的安全带，从[src]上站了起来。"),
			span_notice("你掀起了头顶的束缚带，从[src]上站了起来。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_unbuckled.visible_message(
			span_notice("[unbuckler]掀起了头顶的束缚带，将[being_unbuckled]从[src]上扶了起来。"),
			span_notice("[unbuckler]掀起了头顶的束缚带，将你从[src]上扶了起来。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/chair/comfy/shuttle/update_overlays()
	. = ..()
	if(has_buckled_mobs())
		. += mutable_appearance(icon, "[icon_state]_down_front", ABOVE_MOB_LAYER + 0.01)
		. += mutable_appearance(icon, "[icon_state]_down_behind", src.layer + 0.01)
	else
		. += mutable_appearance(icon, "[icon_state]_up", src.layer + 0.01)

/obj/structure/chair/comfy/shuttle/tactical
	name = "战术椅"

/obj/structure/chair/comfy/carp
	name = "鲤鱼皮椅"
	desc = "一张极尽奢华的椅子，众多紫色鳞片反射出让人愉悦的光泽。"
	icon_state = "carp_chair"
	buildstacktype = /obj/item/stack/sheet/animalhide/carp
	fishing_modifier = -12
	custom_materials = null

/obj/structure/chair/office
	name = "办公椅"
	anchored = FALSE
	buildstackamount = 5
	item_chair = null
	fishing_modifier = -6
	icon_state = "officechair_dark"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)

/obj/structure/chair/office/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement)

/obj/structure/chair/office/electrify_self(obj/item/assembly/shock_kit/input_shock_kit, mob/user, list/overlays_from_child_procs)
	if(!overlays_from_child_procs)
		var/mutable_appearance/echair_overlay = mutable_appearance('icons/obj/chairs.dmi', "echair_over", OBJ_LAYER, src, appearance_flags = KEEP_APART)
		echair_overlay.pixel_x = -1
		overlays_from_child_procs = list(echair_overlay)
	. = ..()

/obj/structure/chair/office/tactical
	name = "战术转椅"
	fishing_modifier = -10

/obj/structure/chair/office/light
	name = "办公椅"
	icon_state = "officechair_white"

//Stool

/obj/structure/chair/stool
	name = "stool"
	desc = "应用屁股。"
	icon_state = "stool"
	buildstackamount = 1
	item_chair = /obj/item/chair/stool
	max_integrity = 300

/obj/structure/chair/stool/post_buckle_mob(mob/living/Mob)
	Mob.add_offsets(type, z_add = 4)
	. = ..()

/obj/structure/chair/stool/post_unbuckle_mob(mob/living/Mob)
	Mob.remove_offsets(type)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/chair/stool, 0)

/obj/structure/chair/stool/narsie_act()
	return

/obj/structure/chair/mouse_drop_dragged(atom/over_object, mob/user, src_location, over_location, params)
	if(!isliving(user) || over_object != user)
		return
	if(!item_chair || has_buckled_mobs())
		return
	if(flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice("你试图捡起\the [src]，但它消失了！"))
		qdel(src)
		return

	user.visible_message(span_notice("[user] 抓住了\the [src.name]。"), span_notice("你抓住了\the [src.name]。"))
	var/obj/item/chair_item = new item_chair(loc)
	chair_item.set_custom_materials(custom_materials)
	TransferComponents(chair_item)
	chair_item.update_integrity(get_integrity())
	user.put_in_hands(chair_item)
	qdel(src)

/obj/structure/chair/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return ..()

/obj/structure/chair/stool/bar
	name = "bar stool"
	desc = "上面有一些难闻的污渍……"
	icon_state = "bar"
	item_chair = /obj/item/chair/stool/bar

/obj/structure/chair/stool/bar/post_buckle_mob(mob/living/Mob)
	. = ..()
	Mob.add_offsets(type, z_add = 7)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/chair/stool/bar, 0)

/obj/structure/chair/stool/bamboo
	name = "竹凳"
	desc = "一张看起来质朴的临时竹凳。"
	icon_state = "bamboo_stool"
	resistance_flags = FLAMMABLE
	max_integrity = 40
	buildstacktype = /obj/item/stack/sheet/mineral/bamboo
	buildstackamount = 2
	item_chair = /obj/item/chair/stool/bamboo
	custom_materials = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT * 2)

/obj/item/chair
	name = "椅子"
	desc = "酒吧斗殴必不可少。"
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair_toppled"
	inhand_icon_state = "chair"
	icon_angle = 180
	lefthand_file = 'icons/mob/inhands/items/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 8
	throwforce = 10
	demolition_mod = 1.25
	throw_range = 3
	max_integrity = 100
	hitsound = 'sound/items/trayhit/trayhit1.ogg'
	hit_reaction_chance = 50
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	item_flags = SKIP_FANTASY_ON_SPAWN

	// Duration of daze inflicted when the chair is smashed against someone from behind.
	var/daze_amount = 3 SECONDS

	// What structure type does this chair become when placed?
	var/obj/structure/chair/origin_type = /obj/structure/chair

/obj/item/chair/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item)

/obj/item/chair/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始用\the [user.p_them()] 打[src]自己！看起来[user.p_theyre()]想自杀！"))
	playsound(src,hitsound,50,TRUE)
	return BRUTELOSS

/obj/item/chair/narsie_act()
	var/obj/item/chair/wood/W = new/obj/item/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/item/chair/attack_self(mob/user)
	plant(user)

/obj/item/chair/proc/plant(mob/user)
	var/turf/turf = user.loc
	if(!istype(turf) || isgroundlessturf(turf))
		to_chat(user, span_warning("你需要地面才能放置这个！"))
		return
	if(!user.dropItemToGround(src))
		to_chat(user, span_warning("[src]粘在你手上了！"))
		return
	if(flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice("你试图放下\the [src]，但它消失了！"))
		qdel(src)
		return

	for(var/obj/object in turf)
		if(istype(object, /obj/structure/chair))
			to_chat(user, span_warning("这里已经有一把椅子了！"))
			return
		if(object.density && !(object.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("这里已经有东西了！"))
			return

	user.visible_message(span_notice("[user] 扶正了\the [src.name]。"), span_notice("你扶正了\the [name]。"))
	var/obj/structure/chair/chair = new origin_type(turf)
	chair.set_custom_materials(custom_materials)
	TransferComponents(chair)
	chair.setDir(user.dir)
	chair.update_integrity(get_integrity())
	qdel(src)

/obj/item/chair/proc/smash(mob/living/user)
	var/stack_type = initial(origin_type.buildstacktype)
	if(!stack_type)
		return
	var/remaining_mats = initial(origin_type.buildstackamount)
	remaining_mats-- //Part of the chair was rendered completely unusable. It magically disappears. Maybe make some dirt?
	if(remaining_mats)
		for(var/M=1 to remaining_mats)
			new stack_type(get_turf(loc))
	else if(custom_materials[SSmaterials.get_material(/datum/material/iron)])
		new /obj/item/stack/rods(get_turf(loc), 2)
	qdel(src)

/obj/item/chair/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == UNARMED_ATTACK && prob(hit_reaction_chance) || attack_type == LEAP_ATTACK && prob(hit_reaction_chance))
		owner.visible_message(span_danger("[owner]用[src]挡开了[attack_text]！"))
		if(take_chair_damage(damage, damage_type, MELEE)) // Our chair takes our incoming damage for us, which can result in it smashing.
			smash(owner)
		return TRUE
	return FALSE

/obj/item/chair/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(!ishuman(target))
		return

	var/mob/living/carbon/human/give_this_fucker_the_chair = target

	// Here we determine if our attack is against a vulnerable target
	var/vulnerable_hit = check_behind(user, give_this_fucker_the_chair)

	// If our attack is against a vulnerable target, we do additional damage to the chair
	var/damage_to_inflict = vulnerable_hit ? (force * 5) : (force * 2.5)

	if(!take_chair_damage(damage_to_inflict, damtype, MELEE)) // If we would do enough damage to bring our chair's integrity to 0, we instead go past the check to smash it against our target
		return

	user.visible_message(span_danger("[user]将[src]砸向[give_this_fucker_the_chair]，椅子碎成了碎片"))
	if(!HAS_TRAIT(give_this_fucker_the_chair, TRAIT_BRAWLING_KNOCKDOWN_BLOCKED))
		if(vulnerable_hit || give_this_fucker_the_chair.get_timed_status_effect_duration(/datum/status_effect/staggered))
			give_this_fucker_the_chair.Knockdown(2 SECONDS, daze_amount = daze_amount)
			if(give_this_fucker_the_chair.health < give_this_fucker_the_chair.maxHealth*0.5)
				give_this_fucker_the_chair.adjust_confusion(10 SECONDS)

	smash(user)

/obj/item/chair/proc/take_chair_damage(damage_to_inflict, damage_type, armor_flag)
	if(damage_to_inflict >= atom_integrity)
		return TRUE
	take_damage(damage_to_inflict, damage_type, armor_flag)
	return FALSE

/obj/item/chair/greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	origin_type = /obj/structure/chair/greyscale

/obj/item/chair/stool
	name = "凳子"
	icon_state = "stool_toppled"
	inhand_icon_state = "stool"
	origin_type = /obj/structure/chair/stool
	max_integrity = 300 //It's too sturdy.

/obj/item/chair/stool/bar
	name = "酒吧凳"
	icon_state = "bar_toppled"
	inhand_icon_state = "stool_bar"
	origin_type = /obj/structure/chair/stool/bar

/obj/item/chair/stool/bamboo
	name = "竹凳"
	icon_state = "bamboo_stool"
	inhand_icon_state = "stool_bamboo"
	hitsound = 'sound/items/weapons/genhit1.ogg'
	origin_type = /obj/structure/chair/stool/bamboo
	max_integrity = 40 //Submissive and breakable unlike the chad iron stool
	daze_amount = 0 //Not hard enough to cause them to become dazed
	custom_materials = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT * 2)

/obj/item/chair/stool/narsie_act()
	return //sturdy enough to ignore a god

/obj/item/chair/wood
	name = "木椅"
	icon_state = "wooden_chair_toppled"
	inhand_icon_state = "woodenchair"
	resistance_flags = FLAMMABLE
	max_integrity = 40
	hitsound = 'sound/items/weapons/genhit1.ogg'
	origin_type = /obj/structure/chair/wood
	custom_materials = null
	daze_amount = 0
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

/obj/item/chair/wood/narsie_act()
	return

/obj/item/chair/wood/wings
	icon_state = "wooden_chair_wings_toppled"
	origin_type = /obj/structure/chair/wood/wings

/obj/structure/chair/old
	name = "奇怪的椅子"
	desc = "你坐在这里，不是用意志就是用武力，看起来真的很不舒服。"
	icon_state = "chairold"
	item_chair = null
	fishing_modifier = 4

/obj/structure/chair/bronze
	name = "黄铜椅"
	desc = "青铜制成的细长的椅子，它有用于轮子的小齿轮！"
	anchored = FALSE
	icon_state = "brass_chair"
	buildstacktype = /obj/item/stack/sheet/bronze
	buildstackamount = 1
	item_chair = null
	fishing_modifier = -13 //the pinnacle of Ratvarian technology.
	has_armrest = TRUE
	custom_materials = list(/datum/material/bronze = SHEET_MATERIAL_AMOUNT)
	/// Total rotations made
	var/turns = 0

/obj/structure/chair/bronze/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement, 'sound/machines/clockcult/integration_cog_install.ogg', 50)

/obj/structure/chair/bronze/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	. = ..()

/obj/structure/chair/bronze/process()
	setDir(turn(dir,-90))
	playsound(src, 'sound/effects/servostep.ogg', 50, FALSE)
	turns++
	if(turns >= 8)
		STOP_PROCESSING(SSfastprocess, src)

/obj/structure/chair/bronze/MakeRotate()
	return

/obj/structure/chair/bronze/click_alt(mob/user)
	turns = 0
	if(!(datum_flags & DF_ISPROCESSING))
		user.visible_message(span_notice("[user]转动了[src]，拉特瓦尔技术的最后残余让它永远旋转下去。"), \
		span_notice("自动旋转椅。古代拉特瓦尔技术的巅峰。"))
		START_PROCESSING(SSfastprocess, src)
	else
		user.visible_message(span_notice("[user] 停止了 [src] 的失控旋转。"), \
		span_notice("你抓住 [src]，停止了它疯狂的旋转。"))
		STOP_PROCESSING(SSfastprocess, src)
	return CLICK_ACTION_SUCCESS

/obj/structure/chair/mime
	name = "隐形椅"
	desc = "哑剧演员需要这个坐下并且闭嘴。"
	anchored = FALSE
	icon_state = null
	buildstacktype = null
	item_chair = null
	obj_flags = parent_type::obj_flags | NO_DEBRIS_AFTER_DECONSTRUCTION
	alpha = 0
	fishing_modifier = -21 //it only lives for 25 seconds, so we make them worth it.
	custom_materials = null

/obj/structure/chair/mime/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tool_blocker, TOOL_WRENCH, TOOL_ACT_SECONDARY)

/obj/structure/chair/mime/post_buckle_mob(mob/living/M)
	M.add_offsets(type, z_add = 5)

/obj/structure/chair/mime/post_unbuckle_mob(mob/living/M)
	M.remove_offsets(type)

/obj/structure/chair/plastic
	icon_state = "plastic_chair"
	name = "塑料折叠椅"
	desc = "不管你怎么扭动身体，它仍然会让你感到不舒服。"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 2)
	buildstacktype = /obj/item/stack/sheet/plastic
	buildstackamount = 2
	item_chair = /obj/item/chair/plastic
	fishing_modifier = -10

/obj/structure/chair/plastic/post_buckle_mob(mob/living/Mob)
	Mob.add_offsets(type, z_add = 2)
	. = ..()
	if(iscarbon(Mob))
		INVOKE_ASYNC(src, PROC_REF(snap_check), Mob)

/obj/structure/chair/plastic/post_unbuckle_mob(mob/living/Mob)
	Mob.remove_offsets(type)

/obj/structure/chair/plastic/proc/snap_check(mob/living/carbon/Mob)
	if (Mob.nutrition >= NUTRITION_LEVEL_FAT)
		to_chat(Mob, span_warning("椅子开始发出爆裂声和开裂声，你太重了！"))
		if(do_after(Mob, 6 SECONDS, progress = FALSE))
			Mob.visible_message(span_notice("塑料椅子在 [Mob] 的重量下断裂了！"))
			new /obj/effect/decal/cleanable/plastic(loc)
			qdel(src)

/obj/item/chair/plastic
	name = "塑料折叠椅"
	desc = "不知怎么的，你总能在摔角场下找到一个。"
	icon = 'icons/obj/chairs.dmi'
	icon_state = "folded_chair"
	inhand_icon_state = "folded_chair"
	lefthand_file = 'icons/mob/inhands/items/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/chairs_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 7
	throw_range = 5 //Lighter Weight --> Flies Farther.
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 2)
	max_integrity = 70
	daze_amount = 0
	origin_type = /obj/structure/chair/plastic

/obj/structure/chair/musical
	name = "音乐椅"
	desc = "你听这个，不是用意志就是用武力。"
	item_chair = /obj/item/chair/musical
	particles = new /particles/musical_notes

/obj/item/chair/musical
	name = "音乐椅"
	desc = "哦，这就像是一个混乱的大富翁游戏，没有规则，你可以随心所欲地拿起和放置音乐椅。"
	particles = new /particles/musical_notes
	origin_type = /obj/structure/chair/musical

/obj/structure/handrail
	name = "扶手"
	desc = "抓紧了！"
	icon = 'icons/obj/handrail.dmi'
	icon_state = "handrail"
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = NO_BUCKLE_LYING
	resistance_flags = FIRE_PROOF
	max_integrity = 50
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	layer = OBJ_LAYER

/obj/structure/handrail/attack_hand(mob/living/user, list/modifiers)
	return ..() || mouse_buckle_handling(user, user)

/obj/structure/handrail/is_user_buckle_possible(mob/living/target, mob/user, check_loc = TRUE)
	return ..() && user == target && !HAS_TRAIT(target, TRAIT_HANDS_BLOCKED)

/obj/structure/handrail/post_buckle_mob(mob/living/buckled_mob)
	RegisterSignal(buckled_mob, SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED), PROC_REF(stop_buckle))

	var/z_offset = 0
	var/w_offset = 0
	if(dir & NORTH)
		z_offset = -4
	else if(dir & SOUTH)
		z_offset = 8
	if(dir & EAST)
		w_offset = -8
	else if(dir & WEST)
		w_offset = 8

	buckled_mob.add_offsets(type, z_add = z_offset, w_add = w_offset)

/obj/structure/handrail/post_unbuckle_mob(mob/living/unbuckled_mob)
	UnregisterSignal(unbuckled_mob, SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED))
	unbuckled_mob.remove_offsets(type)

/obj/structure/handrail/proc/stop_buckle(mob/living/source, ...)
	SIGNAL_HANDLER
	source.visible_message(
		span_warning("[source] 松开了 [source.p_their()] 抓住 [src] 的手！"),
		span_warning("你松开了抓住 [src] 的手！"),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		vision_distance = COMBAT_MESSAGE_RANGE,
	)
	unbuckle_mob(source, TRUE, TRUE)

/obj/structure/handrail/buckle_feedback(mob/living/being_buckled, mob/buckler)
	buckler.visible_message(
		span_notice("[buckler] 紧紧抓住[src]，保持[buckler.p_them()]自己直立。"),
		span_notice("你紧紧抓住 [src]，保持自己直立。"),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		vision_distance = COMBAT_MESSAGE_RANGE,
	)

/obj/structure/handrail/unbuckle_feedback(mob/living/being_unbuckled, mob/unbuckler)
	if(being_unbuckled == unbuckler)
		being_unbuckled.visible_message(
			span_notice("[unbuckler] 松开了 [src]。"),
			span_notice("你松开了 [src]。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
	else
		being_unbuckled.visible_message(
			span_warning("[unbuckler] 强迫 [being_unbuckled] 松开了 [src]！"),
			span_warning("[unbuckler] 强迫你松开了 [src]！"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
