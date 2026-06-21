/obj/structure/spawner
	name = "怪物巢穴"
	icon = 'icons/mob/simple/animal.dmi'
	icon_state = "hole"
	max_integrity = 100

	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	anchored = TRUE
	density = TRUE

	faction = list(FACTION_HOSTILE)

	var/max_mobs = 5
	var/spawn_time = 30 SECONDS
	var/mob_types = list(/mob/living/basic/carp)
	var/spawn_text = "emerges from"
	var/spawner_type = /datum/component/spawner
	/// Is this spawner taggable with something?
	var/scanner_taggable = FALSE
	/// If this spawner's taggable, what can we tag it with?
	var/static/list/scanner_types = list(/obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner)
	/// If this spawner's taggable, what's the text we use to describe what we can tag it with?
	var/scanner_descriptor = "mining analyzer"
	/// Has this spawner been tagged/analyzed by a mining scanner?
	var/gps_tagged = FALSE
	/// A short identifier for the mob it spawns. Keep around 3 characters or less?
	var/mob_gps_id = "???"
	/// A short identifier for what kind of spawner it is, for use in putting together its GPS tag.
	var/spawner_gps_id = "Creature Nest"
	/// A complete identifier. Generated on tag (if tagged), used for its examine.
	var/assigned_tag

/obj/structure/spawner/examine(mob/user)
	. = ..()
	if(!scanner_taggable)
		return
	if(gps_tagged)
		. += span_notice("一个全息标签已被附着，正投射着\"<b>[assigned_tag]</b>\"。")
	else
		. += span_notice("看起来你或许可以用一个<b>[scanner_descriptor]</b>来扫描并标记它。")

/obj/structure/spawner/attackby(obj/item/item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return TRUE
	if(scanner_taggable && is_type_in_list(item, scanner_types))
		gps_tag(user)
		return TRUE

/// Tag the spawner, prefixing its GPS entry with an identifier - or giving it one, if nonexistent.
/obj/structure/spawner/proc/gps_tag(mob/user)
	if(gps_tagged)
		to_chat(user, span_warning("[src] 已经附有一个全息标签了！"))
		return
	to_chat(user, span_notice("你将一枚全息标签贴在了[src]上。"))
	playsound(src, 'sound/machines/beep/twobeep.ogg', 100)
	gps_tagged = TRUE
	assigned_tag = "\[[mob_gps_id]-[rand(100,999)]\] " + spawner_gps_id
	var/datum/component/gps/our_gps = GetComponent(/datum/component/gps)
	if(our_gps)
		our_gps.gpstag = assigned_tag
		return
	AddComponent(/datum/component/gps, assigned_tag)

/obj/structure/spawner/Initialize(mapload)
	. = ..()
	AddComponent(\
		spawner_type, \
		spawn_types = mob_types, \
		spawn_time = spawn_time, \
		max_spawned = max_mobs, \
		faction = faction, \
		spawn_text = spawn_text,\
		spawn_callback = CALLBACK(src, PROC_REF(on_mob_spawn)), \
		initial_spawn_delay = !mapload, \
	)

/obj/structure/spawner/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if(faction_check_atom(user) && !user.client)
		return
	return ..()

/obj/structure/spawner/proc/on_mob_spawn(atom/created_atom)
	return

/obj/structure/spawner/syndicate
	name = "跃迁灯标"
	icon = 'icons/obj/machines/beacon.dmi'
	icon_state = "syndbeacon"
	spawn_text = "warps in from"
	mob_types = list(/mob/living/basic/trooper/syndicate/ranged)
	faction = list(ROLE_SYNDICATE)
	mob_gps_id = "SYN" // syndicate
	spawner_gps_id = "Hostile Warp Beacon"

/obj/structure/spawner/skeleton
	name = "骨坑"
	desc = "一个满是骨头的坑，有些似乎还在移动。"
	icon_state = "hole"
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	max_integrity = 150
	max_mobs = 15
	spawn_time = 15 SECONDS
	mob_types = list(/mob/living/basic/skeleton)
	spawn_text = "climbs out of"
	faction = list(FACTION_SKELETON)
	mob_gps_id = "SKL" // skeletons
	spawner_gps_id = "Bone Pit"

/obj/structure/spawner/clown
	name = "大笑的拉里"
	desc = "一个欢笑、快乐的身影，好像有什么东西卡在他的喉咙里。"
	icon_state = "clownbeacon"
	icon = 'icons/obj/machines/beacon.dmi'
	max_integrity = 200
	max_mobs = 15
	spawn_time = 15 SECONDS
	mob_types = list(
		/mob/living/basic/clown,
		/mob/living/basic/clown/banana,
		/mob/living/basic/clown/clownhulk,
		/mob/living/basic/clown/clownhulk/chlown,
		/mob/living/basic/clown/clownhulk/honkmunculus,
		/mob/living/basic/clown/fleshclown,
		/mob/living/basic/clown/mutant/glutton,
		/mob/living/basic/clown/honkling,
		/mob/living/basic/clown/longface,
		/mob/living/basic/clown/lube,
	)
	spawn_text = "climbs out of"
	faction = list(FACTION_CLOWN)
	mob_gps_id = "???" // clowns
	spawner_gps_id = "Clown Planet Distortion"

/obj/structure/spawner/mining
	name = "怪物巢洞"
	desc = "洞穴在地下挖的洞，藏匿在大多数洞穴或采矿小行星中的各种怪物。"
	icon_state = "hole"
	max_integrity = 200
	max_mobs = 3
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	spawn_text = "crawls out of"
	mob_types = list(
		/mob/living/basic/mining/basilisk,
		/mob/living/basic/mining/goldgrub,
		/mob/living/basic/mining/goliath/ancient,
		/mob/living/basic/mining/hivelord,
		/mob/living/basic/wumborian_fugu,
	)
	faction = list(FACTION_MINING)

/obj/structure/spawner/mining/goldgrub
	name = "金蛆巢洞"
	desc = "一个藏有金蛆窝的洞，令人讨厌，但可以说比你在巢中找到的任何东西都要好得多。"
	mob_types = list(/mob/living/basic/mining/goldgrub)
	mob_gps_id = "GG"

/obj/structure/spawner/mining/goliath
	name = "歌利亚巢洞"
	desc = "一个洞穴，里面住着一窝歌利亚，哦天呐，为什么？"
	mob_types = list(/mob/living/basic/mining/goliath/ancient)
	mob_gps_id = "GL|A"

/obj/structure/spawner/mining/hivelord
	name = "幼虫领主巢穴"
	desc = "一个栖息着一窝幼虫领主的巢穴。"
	mob_types = list(/mob/living/basic/mining/hivelord)
	mob_gps_id = "HL"

/obj/structure/spawner/mining/basilisk
	name = "蛇怪石蛛巢穴"
	desc = "一个栖息着一窝蛇怪石蛛的巢穴，记得带点保暖的衣服。"
	mob_types = list(/mob/living/basic/mining/basilisk)
	mob_gps_id = "BK"

/obj/structure/spawner/mining/wumborian
	name = "wumborian fugu巢穴"
	desc = "一个栖息着一窝wumborian fugu的巢穴，它们到底怎么全塞进这个小地方的。"
	mob_types = list(/mob/living/basic/wumborian_fugu)
	mob_gps_id = "WF"

/obj/structure/spawner/nether
	name = "幽冥界链接"
	desc = null //see examine()
	icon_state = "nether"
	max_integrity = 50
	spawn_time = 60 SECONDS
	max_mobs = 15
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	spawn_text = "crawls through"
	mob_types = list(
		/mob/living/basic/blankbody,
		/mob/living/basic/creature,
		/mob/living/basic/migo,
	)
	faction = list(FACTION_NETHER)
	scanner_taggable = TRUE
	mob_gps_id = "?!?"
	spawner_gps_id = "Netheric Distortion"

/obj/structure/spawner/nether/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/spawner/nether/examine(mob/user)
	. = ..()
	if(isskeleton(user) || iszombie(user))
		. += "A direct link to another dimension full of creatures very happy to see you. [span_nicegreen("You can see your house from here!")]"
	else
		. += "A direct link to another dimension full of creatures not very happy to see you. [span_warning("Entering the link would be a very bad idea.")]"

/obj/structure/spawner/nether/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(isskeleton(user) || iszombie(user))
		to_chat(user, span_notice("你还不想回家..."))
	else
		user.visible_message(span_warning("[user] 被猛地拽进了连接中！"), \
							span_userdanger("触摸传送门，你被迅速拉入了一个充满难以想象的恐怖的世界！"))
		contents.Add(user)

/obj/structure/spawner/nether/process(seconds_per_tick)
	for(var/mob/living/living_mob in contents)
		playsound(src, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
		living_mob.adjust_brute_loss(60 * seconds_per_tick)
		new /obj/effect/gibspawner/generic(get_turf(living_mob), living_mob)
		if(living_mob.stat == DEAD)
			var/mob/living/basic/blankbody/newmob = new(loc)
			newmob.name = "[living_mob]"
			newmob.desc = "这是[living_mob]，但[living_mob.p_their()]的皮肤有着灰烬般的质感，并且[living_mob.p_their()]的脸除了诡异的微笑外没有任何特征。"
			src.visible_message(span_warning("[living_mob]从连接中重新出现了！"))
			qdel(living_mob)

/obj/structure/spawner/sentient
	var/role_name = "A sentient mob"
	var/assumed_control_message = "You are a sentient mob from a badly coded spawner"

/obj/structure/spawner/sentient/Initialize(mapload)
	. = ..()
	notify_ghosts(
		"A [name] has been created in \the [get_area(src)]!",
		source = src,
		header = "Sentient Spawner Created",
		notify_flags = NOTIFY_CATEGORY_NOFLASH,
	)

/obj/structure/spawner/sentient/on_mob_spawn(atom/created_atom)
	created_atom.AddComponent(\
		/datum/component/ghost_direct_control,\
		role_name = src.role_name,\
		assumed_control_message = src.assumed_control_message,\
		after_assumed_control = CALLBACK(src, PROC_REF(became_player_controlled)),\
	)

/obj/structure/spawner/sentient/proc/became_player_controlled(mob/proteon)
	return

/obj/structure/spawner/sentient/proteon_spawner
	name = "邪神传送门"
	desc = "A dizzying structure that somehow links into Nar'Sie's own domain. The screams of the damned echo continously."
	icon = 'icons/obj/antags/cult/structures.dmi'
	icon_state = "hole"
	light_power = 2
	light_color = COLOR_CULT_RED
	max_integrity = 50
	density = FALSE
	max_mobs = 2
	spawn_time = 15 SECONDS
	mob_types = list(/mob/living/basic/construct/proteon/hostile)
	spawn_text = "arises from"
	faction = list(FACTION_CULT)
	role_name = "A proteon cult construct"
	assumed_control_message = null

/obj/structure/spawner/sentient/proteon_spawner/examine_status(mob/user)
	if(IS_CULTIST(user) || !isliving(user))
		return span_cult("它的稳定性为<b>[round(atom_integrity * 100 / max_integrity)]%</b>。")
	return ..()

/obj/structure/spawner/sentient/proteon_spawner/examine(mob/user)
	. = ..()
	if(!IS_CULTIST(user) && isliving(user))
		var/mob/living/living_user = user
		living_user.adjust_organ_loss(ORGAN_SLOT_BRAIN, 15)
		. += span_danger("受诅咒者的声音在你脑海中无情地回响，你越是专注于[src]，它们就越是在你自我的壁垒上不断反弹。你的头阵阵作痛，最好离远点……")
	else
		. += span_cult("传送门每[spawn_time * 0.1]秒会创造一个弱小的普洛提恩构造体，最多可达[max_mobs]个，这些构造体可能被死者的灵魂所控制。")

/obj/structure/spawner/sentient/proteon_spawner/became_player_controlled(mob/living/basic/construct/proteon/proteon)
	proteon.mind.add_antag_datum(/datum/antagonist/cult)
	proteon.add_filter("awoken_proteon", 3, list("type" = "outline", "color" = COLOR_CULT_RED, "size" = 2))
	visible_message(span_cult_bold("[proteon]苏醒了，散发出诡异的红光，从它的恍惚状态中活动起来！"))
	playsound(proteon, 'sound/items/haunted/ghostitemattack.ogg', 100, TRUE)
	proteon.balloon_alert_to_viewers("awoken!")
	addtimer(CALLBACK(src, PROC_REF(remove_wake_outline), proteon), 8 SECONDS)

/obj/structure/spawner/sentient/proteon_spawner/proc/remove_wake_outline(mob/proteon)
	proteon.remove_filter("awoken_proteon")
	proteon.add_filter("sentient_proteon", 3, list("type" = "outline", "color" = COLOR_CULT_RED, "size" = 2, "alpha" = 40))

/obj/structure/spawner/sentient/proteon_spawner/handle_deconstruct(disassembled)
	playsound(src, 'sound/effects/hallucinations/veryfar_noise.ogg', 75)
	visible_message(span_cult_bold("[src]完全解体了，受诅咒者的尖叫声达到狂热的顶点，然后慢慢消逝，归于虚无。"))
