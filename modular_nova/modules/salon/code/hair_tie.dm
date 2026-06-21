/obj/item/clothing/head/hair_tie
	name = "发圈"
	desc = "一个弹力发圈，用来束起你的头发！"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "hairtie"
	worn_icon = 'modular_nova/modules/salon/icons/items.dmi'
	worn_icon_state = "hair_tie_worn_no_icon"
	lefthand_file = 'modular_nova/modules/salon/icons/items.dmi'
	righthand_file = 'modular_nova/modules/salon/icons/items.dmi'
	inhand_icon_state = "hair_tie_worn_no_icon"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW * 0.2
	///string which set_hairstyle() will read
	var/picked_hairstyle
	///storage for the original hairstyle string
	var/actual_hairstyle
	///which projectile object to use as flicked hair tie
	var/projectile_to_fire = /obj/projectile/bullet/hair_tie
	///how long the do_after takes to flick the hair tie
	var/fire_speed = 3 SECONDS
	///how big is the randomized aim radius when flicked
	var/projectile_aim_radius = 30

/obj/item/clothing/head/hair_tie/scrunchie
	name = "发绳"
	desc = "一个弹力发圈，其面料如天鹅绒般柔软。"
	icon_state = "hairtie_scrunchie"

/obj/item/clothing/head/hair_tie/plastic_beads
	name = "彩色发圈"
	desc = "一个弹力发圈，装饰着彩色塑料珠。"
	icon_state = "hairtie_beads"
	custom_materials = (list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT))

/obj/item/clothing/head/hair_tie/syndicate
	name = "\improper 辛迪加发圈"
	desc = "一个带有金属夹的弹力发圈，印有辛迪加的徽标。"
	icon_state = "hairtie_syndie"
	fire_speed = 1.5 SECONDS
	projectile_to_fire = /obj/projectile/bullet/hair_tie/syndicate
	projectile_aim_radius = 0 //accurate aim

/obj/item/clothing/head/hair_tie/examine(mob/user)
	. = ..()
	if(picked_hairstyle)
		. += span_notice("佩戴它会将你的发型改为'[picked_hairstyle]'。")
	. += span_notice("<b>在手中使用</b>以选择新发型。")
	. += span_notice("<b>Alt-点击</b> [src] 将其甩出。")

/obj/item/clothing/head/hair_tie/mob_can_equip(mob/living/carbon/human/user, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(user.hairstyle == "Bald") //could create a list of the bald hairstyles to check
		return FALSE
	return ..()

/obj/item/clothing/head/hair_tie/attack_self(mob/user)
	var/hair_id = tgui_input_list(user, "你的头发扎起来是什么样子？", "选择！", SSaccessories.hairstyles_list)
	if(!hair_id || hair_id == "Bald")
		balloon_alert(user, "错误！")
		return
	balloon_alert(user, "[hair_id]")
	picked_hairstyle = hair_id

/obj/item/clothing/head/hair_tie/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!ishuman(user) || !(slot_flags & slot))
		return
	if(!picked_hairstyle)
		return
	user.visible_message(
		span_notice("[user.name] 将 [user.p_their()] 头发扎了起来。"),
		span_notice("你扎起了自己的头发！"),
	)
	actual_hairstyle = user.hairstyle
	user.set_hairstyle(picked_hairstyle, update = TRUE)

/obj/item/clothing/head/hair_tie/dropped(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return
	if(!picked_hairstyle || !actual_hairstyle)
		return
	user.visible_message(
		span_notice("[user.name] 将 [src] 从 [user.p_their()] 头发上取了下来。"),
		span_notice("你放下了头发！"),
	)
	user.set_hairstyle(actual_hairstyle, update = TRUE)
	actual_hairstyle = null

/obj/item/clothing/head/hair_tie/click_alt(mob/living/user)
	if(!(user.get_slot_by_item(src) == ITEM_SLOT_HANDS))
		balloon_alert(user, "请拿在手上！")
		return CLICK_ACTION_BLOCKING
	user.visible_message(
		span_danger("[user.name] 将 [src] 绕在 [user.p_their()] 手指上，开始弹它！"),
		span_notice("你试图弹 [src]！"),
	)
	flick_hair_tie(user)
	return CLICK_ACTION_SUCCESS

///This proc flicks the hair tie out of the player's hand, tripping the target hit for 1 second
/obj/item/clothing/head/hair_tie/proc/flick_hair_tie(mob/living/user)
	if(!do_after(user, fire_speed, src))
		return
	//build the projectile
	var/obj/projectile/bullet/hair_tie/proj = new projectile_to_fire (drop_location())
	//clone some vars
	proj.name = name
	proj.icon_state = icon_state
	//add projectile_drop
	proj.AddElement(/datum/element/projectile_drop, type)
	//aim and fire
	proj.firer = user
	proj.fired_from = user
	proj.fire((dir2angle(user.dir) + rand(-projectile_aim_radius, projectile_aim_radius)))
	playsound(src, 'sound/items/weapons/effects/batreflect.ogg', 25, TRUE)
	//get rid of what we just launched to let projectile_drop spawn a new one
	qdel(src)

/obj/projectile/bullet/hair_tie
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "hairtie"
	hitsound = 'sound/items/weapons/genhit.ogg'
	damage = 0 //its just about the knockdown
	sharpness = NONE
	shrapnel_type = NONE //no embedding pls
	impact_effect_type = null
	ricochet_chance = 0
	range = 7
	knockdown = 1 SECONDS

/obj/projectile/bullet/hair_tie/syndicate
	damage = 10 //getting hit with this one fucking sucks
	stamina = 30
	eyeblur = 2 SECONDS
	jitter = 8 SECONDS
