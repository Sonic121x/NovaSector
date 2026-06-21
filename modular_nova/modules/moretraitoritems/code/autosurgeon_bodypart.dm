/obj/item/autosurgeon/bodypart
	name = "身体部件升级自动手术仪"
	desc = "一种能专业替换你身体部件的设备。"

	var/bodypart_type = /obj/item/bodypart

	var/starting_bodypart //The bodypart we come with

	var/obj/item/bodypart/storedbodypart

/obj/item/autosurgeon/bodypart/Initialize(mapload)
	. = ..()
	if(starting_bodypart)
		insert_bodypart(new starting_bodypart(src))

/obj/item/autosurgeon/bodypart/proc/insert_bodypart(obj/item/I)
	storedbodypart = I
	I.forceMove(src)
	name = "[initial(name)] ([storedbodypart.name])"

/obj/item/autosurgeon/bodypart/attack_self(mob/user)//when the object it used...
	if(!uses)
		to_chat(user, span_alert("[src] 已经使用过了。工具已经变钝，无法再次激活。"))
		return
	if(!storedbodypart)
		to_chat(user, span_alert("[src] 当前没有存储植入体。"))
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/obj/item/bodypart/oldBP = H.get_bodypart(storedbodypart.body_zone)

	if(oldBP)
		to_chat(H, span_warning("[src] 移除了你的 [oldBP.name]！"))
		oldBP.dismember()

	user.visible_message(span_notice("[H] 按下了 [src] 上的一个按钮，你听到一阵短暂的机械噪音。"), span_notice("当 [src] 刺入你的身体时，你感到一阵尖锐的刺痛。"))

	if(!storedbodypart.try_attach_limb(H))
		to_chat(H, span_warning("[src] 未能成功连接 [storedbodypart]！"))
		return

	playsound(get_turf(H), 'sound/items/weapons/circsawhit.ogg', 50, TRUE)
	storedbodypart = null
	name = initial(name)
	if(uses != INFINITY)
		uses--
	if(!uses)
		desc = "[initial(desc)] 看起来它已经被用完了。"

/obj/item/autosurgeon/bodypart/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, bodypart_type))
		if(storedbodypart)
			to_chat(user, span_alert("[src] 已经存储了一个植入体。"))
			return
		else if(!uses)
			to_chat(user, span_alert("[src] 已经用完了。"))
			return
		if(!user.transferItemToLoc(attacking_item, src))
			return
		storedbodypart = attacking_item
		to_chat(user, span_notice("你将 [attacking_item] 插入了 [src]。"))
	else
		return ..()

/obj/item/autosurgeon/bodypart/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(!storedbodypart)
		to_chat(user, span_warning("[src] 里没有可供你移除的植入物！"))
	else
		var/atom/drop_loc = user.drop_location()
		for(var/J in src)
			var/atom/movable/AM = J
			AM.forceMove(drop_loc)

		to_chat(user, span_notice("你从 [src] 中取出了 [storedbodypart]。"))
		I.play_tool_sound(src)
		storedbodypart = null
		if(uses != INFINITY)
			uses--
		if(!uses)
			desc = "[initial(desc)] 看起来它已经被用完了。"
	return TRUE
