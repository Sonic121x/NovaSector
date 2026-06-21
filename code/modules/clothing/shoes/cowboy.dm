/obj/item/clothing/shoes/cowboy
	name = "牛仔靴"
	desc = "一张小贴纸告诉你它们已经检查过是否有蛇，不清楚检查是多久前进行的..."
	icon_state = "cowboy_brown"
	armor_type = /datum/armor/shoes_cowboy
	custom_price = PAYCHECK_CREW
	fastening_type = SHOES_SLIPON
	interaction_flags_mouse_drop = NEED_HANDS | NEED_DEXTERITY

	var/max_occupants = 4
	/// Do these boots have spur sounds?
	var/has_spurs = FALSE
	/// The jingle jangle jingle of our spurs
	var/list/spur_sound = list('sound/effects/footstep/spurs1.ogg'=1,'sound/effects/footstep/spurs2.ogg'=1,'sound/effects/footstep/spurs3.ogg'=1)

/datum/armor/shoes_cowboy
	bio = 90

/obj/item/clothing/shoes/cowboy/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/shoes)
	if(prob(2)) //There's a snake in my boot
		new /mob/living/basic/snake(src)
	if(has_spurs)
		LoadComponent(/datum/component/squeak, spur_sound, 50, falloff_exponent = 20)
	AddElement(/datum/element/ignites_matches)

/obj/item/clothing/shoes/cowboy/equipped(mob/living/carbon/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SLAM_TABLE, PROC_REF(table_slam), override = TRUE)
	if(slot & ITEM_SLOT_FEET)
		for(var/mob/living/occupant in contents)
			var/target_zone = user.get_random_valid_zone(blacklisted_parts = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), even_weights = TRUE, bypass_warning = TRUE)
			if(!target_zone) //we broke their legs right on off!
				break
			occupant.forceMove(user.drop_location())
			user.visible_message(span_warning("[user] 因有东西从 [src] 中滑出而猛地缩回。"), span_userdanger("You feel a sudden stabbing pain in your [pick("foot", "toe", "ankle")]!"))
			user.Knockdown(20) //Is one second paralyze better here? I feel you would fall on your ass in some fashion.
			occupant.UnarmedAttack(user, proximity_flag = TRUE)

/obj/item/clothing/shoes/cowboy/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, COMSIG_LIVING_SLAM_TABLE)

/obj/item/clothing/shoes/cowboy/proc/table_slam(mob/living/source, obj/structure/table/the_table)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(handle_table_slam), source)

/obj/item/clothing/shoes/cowboy/proc/handle_table_slam(mob/living/user)
	user.say(pick("Hot damn!", "Hoo-wee!", "Got-dang!"), spans = list(SPAN_YELL), forced=TRUE)
	user.client?.give_award(/datum/award/achievement/misc/hot_damn, user)

/obj/item/clothing/shoes/cowboy/mouse_drop_receive(mob/living/target, mob/living/user, params)
	. = ..()
	if(!(user.mobility_flags & MOBILITY_USE) || !isliving(target))
		return
	if(contents.len >= max_occupants)
		to_chat(user, span_warning("[src] 已经满了！"))
		return
	if(istype(target, /mob/living/basic/snake) || istype(target, /mob/living/basic/headslug) || islarva(target))
		target.forceMove(src)
		to_chat(user, span_notice("[target] 滑进了[src]。"))

/obj/item/clothing/shoes/cowboy/container_resist_act(mob/living/user)
	if(!do_after(user, 1 SECONDS, target = user))
		return
	user.forceMove(drop_location())

/obj/item/clothing/shoes/cowboy/white
	name = "白色牛仔靴"
	icon_state = "cowboy_white"

/obj/item/clothing/shoes/cowboy/black
	name = "黑色牛仔靴"
	desc = "你会有种感觉，仿佛有人是穿着这双靴子被绞死的。"
	icon_state = "cowboy_black"

/obj/item/clothing/shoes/cowboy/fancy
	name = "比尔顿牧马人靴"
	desc = "一双来自加利福尼亚日式时尚区的正宗高级定制靴子。你怀疑它们从未靠近过牛群。"
	icon_state = "cowboy_fancy"
	armor_type = /datum/armor/cowboy_fancy

/datum/armor/cowboy_fancy
	bio = 95

/obj/item/clothing/shoes/cowboy/lizard
	name = "蜥蜴皮靴"
	desc = "你可以听到从靴子里发出微弱的嘶嘶声；你希望它只是一个悲伤的鬼魂。"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/cowboy/lizard"
	post_init_icon_state = "lizardboots"
	greyscale_config = /datum/greyscale_config/lizard_shoes
	greyscale_config_worn = /datum/greyscale_config/lizard_shoes/worn
	greyscale_colors = "#859333"
	armor_type = /datum/armor/cowboy_lizard

/datum/armor/cowboy_lizard
	bio = 90
	fire = 40

/obj/item/clothing/shoes/cowboy/lizard/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	var/obj/item/stack/sheet/animalhide/carbon/lizard/skin = locate() in components
	if (isnull(skin) || !length(skin.skin_color)) // what
		return ..()
	set_greyscale(skin.skin_color)
	return ..()

/obj/item/clothing/shoes/cowboy/lizard/masterwork
	name = "\improper 抱脚蜥蜴皮靴"
	desc = "一双工艺精湛的蜥蜴皮靴。终于为空间站最烦人的居民找到了一个好用途。"
	greyscale_colors = "#3e76a7"

/// Shoes for the nuke-ops cowboy fit
/obj/item/clothing/shoes/cowboy/black/syndicate
	name = "黑色带马刺牛仔靴"
	desc = "它们唱着，哦，单身难道不快乐吗？这首歌说得可一点没错。"
	armor_type = /datum/armor/shoes_combat
	has_spurs = TRUE
	body_parts_covered = FEET|LEGS

// Laced variants for loadout
/obj/item/clothing/shoes/cowboy/laced
	fastening_type = SHOES_LACED

/obj/item/clothing/shoes/cowboy/white/laced
	fastening_type = SHOES_LACED

/obj/item/clothing/shoes/cowboy/black/laced
	fastening_type = SHOES_LACED
