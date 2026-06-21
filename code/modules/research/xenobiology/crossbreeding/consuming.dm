/*
Consuming extracts:
	Can eat food items.
	After consuming enough, produces special cookies.
*/
/obj/item/slimecross/consuming
	name = "消耗提取物"
	desc = "它渴望……<i>更多</i>。" //My slimecross has finally decided to eat... my buffet!
	icon_state = "consuming"
	effect = "consuming"
	var/nutriment_eaten = 0
	var/nutriment_required = 10
	var/cooldown = 600 //1 minute.
	var/last_produced = 0
	var/cookies = 5 //Number of cookies to spawn
	var/cookietype = /obj/item/slime_cookie

/obj/item/slimecross/consuming/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!IS_EDIBLE(tool))
		return NONE

	if(last_produced + cooldown > world.time)
		to_chat(user, span_warning("[src] 还在消化上一餐！"))
		return ITEM_INTERACT_BLOCKING

	var/datum/reagent/nutriments = tool.reagents.has_reagent(/datum/reagent/consumable/nutriment)
	if(!nutriments)
		to_chat(user, span_warning("[src] 对这份祭品发出不满的咕噜声。"))
		return ITEM_INTERACT_BLOCKING

	nutriment_eaten += nutriments.volume
	to_chat(user, span_notice("[src] opens up and swallows [tool] whole!"))
	qdel(tool)
	playsound(src, 'sound/items/eatfood.ogg', 20, TRUE)

	if(nutriment_eaten < nutriment_required)
		return ITEM_INTERACT_SUCCESS

	nutriment_eaten = 0
	user.visible_message(span_notice("[src] 膨胀起来，产出了一小堆饼干！"))
	playsound(src, 'sound/effects/splat.ogg', 40, TRUE)
	last_produced = world.time
	for(var/i in 1 to cookies)
		var/obj/item/cookie = spawncookie()
		cookie.pixel_x = base_pixel_x + rand(-5, 5)
		cookie.pixel_y = base_pixel_y + rand(-5, 5)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/consuming/proc/spawncookie()
	return new cookietype(get_turf(src))

/obj/item/slime_cookie //While this technically acts like food, it's so removed from it that I made it its own type.
	name = "错误曲奇"
	desc = "一块奇怪的黏液饼干。你不应该见到这样的东西。"
	icon = 'icons/obj/food/slimecookies.dmi'
	var/taste = "error"
	var/nutrition = 5
	icon_state = "base"
	force = 0
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/slime_cookie/proc/do_effect(mob/living/M, mob/user)
	return

/obj/item/slime_cookie/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	var/mob/living/living_mob = interacting_with
	var/fed = FALSE
	if(living_mob == user)
		living_mob.visible_message(span_notice("[user] 吃掉了 [src]！"), span_notice("你吃掉了 [src]。"))
		fed = TRUE
	else
		living_mob.visible_message(span_danger("[user] 试图强迫 [living_mob] 吃掉 [src]！"), span_userdanger("[user] 试图强迫你吃掉 [src]！"))
		if(do_after(user, 2 SECONDS, target = living_mob))
			fed = TRUE
			living_mob.visible_message(span_danger("[user] 强迫 [living_mob] 吃掉了 [src]！"), span_warning("[user] 强迫你吃掉了 [src]。"))
	if(fed)
		if(!HAS_TRAIT(living_mob, TRAIT_AGEUSIA))
			to_chat(living_mob, span_notice("你能尝到 [taste] 的味道。"))
		playsound(get_turf(living_mob), 'sound/items/eatfood.ogg', 20, TRUE)
		if(nutrition)
			living_mob.reagents.add_reagent(/datum/reagent/consumable/nutriment, nutrition)
		do_effect(living_mob, user)
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/item/slimecross/consuming/grey
	colour = SLIME_TYPE_GREY
	effect_desc = "Creates a slime cookie."
	cookietype = /obj/item/slime_cookie/grey

/obj/item/slime_cookie/grey
	name = "史莱姆曲奇"
	desc = "一个透明的灰色曲奇.含有营养，大概吧."
	icon_state = "grey"
	taste = "goo"
	nutrition = 15

/obj/item/slimecross/consuming/orange
	colour = SLIME_TYPE_ORANGE
	effect_desc = "Creates a slime cookie that heats the target up and grants cold immunity for a short time."
	cookietype = /obj/item/slime_cookie/orange

/obj/item/slime_cookie/orange
	name = "火辣曲奇"
	desc = "一块带有炽热图案的橙色曲奇。摸起来很温暖。"
	icon_state = "orange"
	taste = "cinnamon and burning"

/obj/item/slime_cookie/orange/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/firecookie)

/obj/item/slimecross/consuming/purple
	colour = SLIME_TYPE_PURPLE
	effect_desc = "Creates a slime cookie that heals the target from every type of damage."
	cookietype = /obj/item/slime_cookie/purple

/obj/item/slime_cookie/purple
	name = "治愈曲奇"
	desc = "一个带有十字图案的紫色曲奇，令人舒缓."
	icon_state = "purple"
	taste = "fruit jam and cough medicine"

/obj/item/slime_cookie/purple/do_effect(mob/living/M, mob/user)
	var/need_mob_update = FALSE
	need_mob_update += M.adjust_brute_loss(-5, updating_health = FALSE)
	need_mob_update += M.adjust_fire_loss(-5, updating_health = FALSE)
	need_mob_update += M.adjust_tox_loss(-5, updating_health = FALSE, forced = TRUE) //To heal slimepeople.
	need_mob_update += M.adjust_oxy_loss(-5, updating_health = FALSE)
	need_mob_update += M.adjust_organ_loss(ORGAN_SLOT_BRAIN, -5)
	if(need_mob_update)
		M.updatehealth()

/obj/item/slimecross/consuming/blue
	colour = SLIME_TYPE_BLUE
	effect_desc = "Creates a slime cookie that wets the floor around you and makes you immune to water based slipping for a short time."
	cookietype = /obj/item/slime_cookie/blue

/obj/item/slime_cookie/blue
	name = "水曲奇"
	desc = "一个透明的蓝色曲奇，总是湿哒哒的."
	icon_state = "blue"
	taste = "water"

/obj/item/slime_cookie/blue/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/watercookie)

/obj/item/slimecross/consuming/metal
	colour = SLIME_TYPE_METAL
	effect_desc = "Creates a slime cookie that increases the target's resistance to brute damage."
	cookietype = /obj/item/slime_cookie/metal

/obj/item/slime_cookie/metal
	name = "金属曲奇"
	desc = "一个闪亮的灰色曲奇.摸起来很硬."
	icon_state = "metal"
	taste = "copper"

/obj/item/slime_cookie/metal/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/metalcookie)

/obj/item/slimecross/consuming/yellow
	colour = SLIME_TYPE_YELLOW
	effect_desc = "Creates a slime cookie that makes the target immune to electricity for a short time."
	cookietype = /obj/item/slime_cookie/yellow

/obj/item/slime_cookie/yellow
	name = "电花曲奇"
	desc = "一块带有闪电图案的黄色曲奇。质地有点像橡胶。"
	icon_state = "yellow"
	taste = "lemon cake and rubber gloves"

/obj/item/slime_cookie/yellow/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/sparkcookie)

/obj/item/slimecross/consuming/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE
	effect_desc = "Creates a slime cookie that reverses how the target's body treats toxins."
	cookietype = /obj/item/slime_cookie/darkpurple

/obj/item/slime_cookie/darkpurple
	name = "毒素曲奇"
	desc = "一块深紫色的曲奇，散发着等离子体的气味。"
	icon_state = "darkpurple"
	taste = "slime jelly and toxins"

/obj/item/slime_cookie/darkpurple/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/toxincookie)

/obj/item/slimecross/consuming/darkblue
	colour = SLIME_TYPE_DARK_BLUE
	effect_desc = "Creates a slime cookie that chills the target and extinguishes them."
	cookietype = /obj/item/slime_cookie/darkblue

/obj/item/slime_cookie/darkblue
	name = "霜冻曲奇"
	desc = "一块深蓝色的饼干，上面有雪花图案。摸起来很凉爽。"
	icon_state = "darkblue"
	taste = "mint and bitter cold"

/obj/item/slime_cookie/darkblue/do_effect(mob/living/M, mob/user)
	M.adjust_bodytemperature(-110)
	M.extinguish_mob()

/obj/item/slimecross/consuming/silver
	colour = SLIME_TYPE_SILVER
	effect_desc = "Creates a slime cookie that never gets the target fat."
	cookietype = /obj/item/slime_cookie/silver

/obj/item/slime_cookie/silver
	name = "保健曲奇"
	desc = "一块温暖酥脆的饼干，在光线下呈现出闪亮的银色。闻起来香气扑鼻。"
	icon_state = "silver"
	taste = "masterful elven baking"
	nutrition = 0 //We don't want normal nutriment

/obj/item/slime_cookie/silver/do_effect(mob/living/M, mob/user)
	M.reagents.add_reagent(/datum/reagent/consumable/nutriment/stabilized,10)

/obj/item/slimecross/consuming/bluespace
	colour = SLIME_TYPE_BLUESPACE
	effect_desc = "Creates a slime cookie that teleports the target to a random place in the area."
	cookietype = /obj/item/slime_cookie/bluespace

/obj/item/slime_cookie/bluespace
	name = "太空曲奇"
	desc = "一块白色的饼干，上面覆盖着绿色的糖霜。出奇地难握。"
	icon_state = "bluespace"
	taste = "sugar and starlight"

/obj/item/slime_cookie/bluespace/do_effect(mob/living/eater, mob/user)
	var/list/area_turfs = get_area_turfs(get_area(get_turf(eater)))
	var/turf/target

	while (length(area_turfs))
		var/turf/check_turf = pick_n_take(area_turfs)
		if (is_centcom_level(check_turf.z))
			continue // Probably already filtered out by NOTELEPORT but let's just be careful
		if (check_turf.is_blocked_turf())
			continue
		target = check_turf
		break

	if (isnull(target))
		fail_effect(eater)
		return
	if (!do_teleport(eater, target, 0, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE))
		fail_effect(eater)
		return
	new /obj/effect/particle_effect/sparks(target)
	playsound(target, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/item/slime_cookie/bluespace/proc/fail_effect(mob/living/eater)
	eater.visible_message(
		message = span_warning("[eater] 短暂地消失了……然后重重地摔在地上"),
		self_message = span_warning("你短暂地消失了……然后被重重地摔回地面。")
	)
	eater.Knockdown(0.1 SECONDS)
	new /obj/effect/particle_effect/sparks(get_turf(eater))

/obj/item/slimecross/consuming/sepia
	colour = SLIME_TYPE_SEPIA
	effect_desc = "Creates a slime cookie that makes the target do things slightly faster."
	cookietype = /obj/item/slime_cookie/sepia

/obj/item/slime_cookie/sepia
	name = "时间曲奇"
	desc = "一块浅棕色的饼干，上面有钟形图案。咀嚼起来需要一些时间。"
	icon_state = "sepia"
	taste = "brown sugar and a metronome"

/obj/item/slime_cookie/sepia/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/timecookie)

/obj/item/slimecross/consuming/cerulean
	colour = SLIME_TYPE_CERULEAN
	effect_desc = "Creates a slime cookie that has a chance to make another once you eat it."
	cookietype = /obj/item/slime_cookie/cerulean
	cookies = 3 //You're gonna get more.

/obj/item/slime_cookie/cerulean
	name = "克隆曲奇"
	desc = "一块湛蓝色的曲奇，其形状十分奇特。感觉它很容易就会碎掉。"
	icon_state = "cerulean"
	taste = "a sugar cookie"

/obj/item/slime_cookie/cerulean/do_effect(mob/living/M, mob/user)
	if(prob(50))
		to_chat(M, span_notice("你咀嚼时，[src] 的一块碎片脱落，掉在了地上。"))
		var/obj/item/slime_cookie/cerulean/C = new(get_turf(M))
		C.taste = taste + " and a sugar cookie"

/obj/item/slimecross/consuming/pyrite
	colour = SLIME_TYPE_PYRITE
	effect_desc = "Creates a slime cookie that randomly colors the target."
	cookietype = /obj/item/slime_cookie/pyrite

/obj/item/slime_cookie/pyrite
	name = "多彩曲奇"
	desc = "有彩虹色外皮的黄色曲奇.奇异地反射着光线."
	icon_state = "pyrite"
	taste = "vanilla and " //Randomly selected color dye.
	var/colour = COLOR_WHITE

/obj/item/slime_cookie/pyrite/Initialize(mapload)
	. = ..()
	var/tastemessage = "paint remover"
	switch(rand(1,7))
		if(1)
			tastemessage = "red dye"
			colour = COLOR_RED
		if(2)
			tastemessage = "orange dye"
			colour = "#FFA500"
		if(3)
			tastemessage = "yellow dye"
			colour = COLOR_YELLOW
		if(4)
			tastemessage = "green dye"
			colour = COLOR_VIBRANT_LIME
		if(5)
			tastemessage = "blue dye"
			colour = COLOR_BLUE
		if(6)
			tastemessage = "indigo dye"
			colour = "#4B0082"
		if(7)
			tastemessage = "violet dye"
			colour = COLOR_MAGENTA
	taste += tastemessage

/obj/item/slime_cookie/pyrite/do_effect(mob/living/M, mob/user)
	M.add_atom_colour(colour,WASHABLE_COLOUR_PRIORITY)

/obj/item/slimecross/consuming/red
	colour = SLIME_TYPE_RED
	effect_desc = "Creates a slime cookie that creates a spatter of blood on the floor, while also restoring some of the target's blood."
	cookietype = /obj/item/slime_cookie/red

/obj/item/slime_cookie/red
	name = "血曲奇"
	desc = "一块红色的曲奇，上面渗出了粘稠的红色液体.吸血鬼可能会喜欢."
	icon_state = "red"
	taste = "red velvet and iron"

/obj/item/slime_cookie/red/do_effect(mob/living/M, mob/user)
	new /obj/effect/decal/cleanable/blood(get_turf(M))
	playsound(get_turf(M), 'sound/effects/splat.ogg', 10, TRUE)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.adjust_blood_volume(25) //Half a vampire drain.

/obj/item/slimecross/consuming/green
	colour = SLIME_TYPE_GREEN
	effect_desc = "Creates a slime cookie that is absolutely disgusting, makes the target vomit, however all reagent in their body are also removed."
	cookietype = /obj/item/slime_cookie/green

/obj/item/slime_cookie/green
	name = "极臭曲奇"
	desc = "一块散发着恶臭、满是脓液的绿色曲奇。光是看着它，你就会觉得不舒服。"
	icon_state = "green"
	taste = "the contents of your stomach"

/obj/item/slime_cookie/green/do_effect(mob/living/M, mob/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 25)
	M.reagents.remove_all()

/obj/item/slimecross/consuming/pink
	colour = SLIME_TYPE_PINK
	effect_desc = "Creates a slime cookie that makes the target want to spread the love."
	cookietype = /obj/item/slime_cookie/pink

/obj/item/slime_cookie/pink
	name = "爱心曲奇"
	desc = "一块粉色的曲奇，上面还装饰着一个糖霜做成的心形图案。真可爱啊。"
	icon_state = "pink"
	taste = "love and hugs"

/obj/item/slime_cookie/pink/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/lovecookie)

/obj/item/slimecross/consuming/gold
	colour = SLIME_TYPE_GOLD
	effect_desc = "Creates a slime cookie that has a gold coin inside."
	cookietype = /obj/item/slime_cookie/gold

/obj/item/slime_cookie/gold
	name = "镀金曲奇"
	desc = "一块金黄酥脆的曲奇，更像是一块面包而非其他什么。愿好运降临于你。"
	icon_state = "gold"
	taste = "sweet cornbread and wealth"

/obj/item/slime_cookie/gold/do_effect(mob/living/M, mob/user)
	var/obj/item/held = M.get_active_held_item() //This should be itself, but just in case...
	M.dropItemToGround(held)
	var/newcoin = /obj/item/coin/gold
	var/obj/item/coin/C = new newcoin(get_turf(M))
	playsound(get_turf(C), 'sound/items/coinflip.ogg', 50, TRUE)
	M.put_in_hand(C)

/obj/item/slimecross/consuming/oil
	colour = SLIME_TYPE_OIL
	effect_desc = "Creates a slime cookie that slows anyone next to the user."
	cookietype = /obj/item/slime_cookie/oil

/obj/item/slime_cookie/oil
	name = "焦油曲奇"
	desc = "一块油腻的黑色曲奇，粘在你的手上。闻起来有巧克力的香味。"
	icon_state = "oil"
	taste = "rich molten chocolate and tar"

/obj/item/slime_cookie/oil/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/tarcookie)

/obj/item/slimecross/consuming/black
	colour = SLIME_TYPE_BLACK
	effect_desc = "Creates a slime cookie that makes the target look like a spooky skeleton for a little bit."
	cookietype = /obj/item/slime_cookie/black

/obj/item/slime_cookie/black
	name = "恐怖曲奇"
	desc = "一块漆黑的曲奇，正面有一个糖霜绘制的鬼魂图案。好恐怖啊！"
	icon_state = "black"
	taste = "ghosts and stuff"

/obj/item/slime_cookie/black/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/spookcookie)

/obj/item/slimecross/consuming/lightpink
	colour = SLIME_TYPE_LIGHT_PINK
	effect_desc = "Creates a slime cookie that makes the target, and anyone next to the target, pacifistic for a small amount of time."
	cookietype = /obj/item/slime_cookie/lightpink

/obj/item/slime_cookie/lightpink
	name = "平静曲奇"
	desc = "一块浅粉色的曲奇，其表面的糖霜上有一个和平标志。真漂亮！"
	icon_state = "lightpink"
	taste = "strawberry icing and P.L.U.R" //Literal candy raver.

/obj/item/slime_cookie/lightpink/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/peacecookie)

/obj/item/slimecross/consuming/adamantine
	colour = SLIME_TYPE_ADAMANTINE
	effect_desc = "Creates a slime cookie that increases the target's resistance to burn damage."
	cookietype = /obj/item/slime_cookie/adamantine

/obj/item/slime_cookie/adamantine
	name = "水晶曲奇"
	desc = "一块半透明的糖霜状糖果，外形像一块曲奇。令人惊讶的是，它非常有嚼劲。"
	icon_state = "adamantine"
	taste = "crystalline sugar and metal"

/obj/item/slime_cookie/adamantine/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/adamantinecookie)

/obj/item/slimecross/consuming/rainbow
	colour = SLIME_TYPE_RAINBOW
	effect_desc = "Creates a slime cookie that has the effect of a random cookie."

/obj/item/slimecross/consuming/rainbow/spawncookie()
	var/cookie_type = pick(subtypesof(/obj/item/slime_cookie))
	var/obj/item/slime_cookie/S = new cookie_type(get_turf(src))
	S.name = "彩虹曲奇"
	S.desc = "一块色彩斑斓的彩虹曲奇，在光的照射下不断变换着颜色。"
	S.icon_state = "rainbow"
	return S
