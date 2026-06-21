/obj/structure/ore_vein
	name = "矿脉"
	desc = "一个可供开采的矿脉。"
	icon = 'modular_nova/modules/stone/icons/ore.dmi'
	icon_state = "stone1"
	base_icon_state = "stone"
	density = TRUE
	anchored = TRUE
	/// When we start mining, what do we tell the user they're mining?
	var/ore_descriptor = "stone"
	/// What type of ore do we drop?
	var/ore_type = /obj/item/stack/stone
	/// How much ore do we drop?
	var/ore_amount = 5
	/// If the ore vein has been recently mined. If so, we cannot mine and must wait for it to regenerate.
	var/depleted = FALSE
	/// How long it takes for the ore to 'respawn' after being mined.
	var/regeneration_time = 3 MINUTES
	/// How long it takes for a tool to mine the ore vein.
	var/mining_time = 10 SECONDS
	/// How many unique sprites for ore we have, we will pick them at random.
	var/unique_sprites = 3
	/// If we should pick a random sprite for the ore vein or not.
	var/random_sprite = TRUE
	/// Our original description to hold. We'll revert to this when switching between the ore vein being depleted and not.
	var/base_desc = ""

/obj/structure/ore_vein/Initialize(mapload)
	. = ..()
	base_desc = desc
	if(random_sprite)
		base_icon_state += "[rand(1, (unique_sprites))]"

	icon_state = base_icon_state

/obj/structure/ore_vein/update_icon_state()
	icon_state = "[base_icon_state][depleted ? "_depleted" : ""]"

	return ..()

/obj/structure/ore_vein/examine()
	. = ..()
	. += "[depleted ? "The ore vein is exhausted." : ""]"

/obj/structure/ore_vein/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour != TOOL_MINING)
		to_chat(user, span_notice("你需要一把镐来开采这个。"))
		return FALSE
	if(!ore_type)
		to_chat(user, span_notice("没有矿石可开采！"))
		return FALSE
	if(!ore_amount)
		to_chat(user, span_notice("这个[src]品质太低，无法产出任何有用的[ore_descriptor]。"))
		return FALSE
	if(depleted == TRUE)
		to_chat(user, span_notice("这个矿脉已枯竭。"))
		return FALSE
	// Our early return checks to tell the user what went wrong.
	to_chat(user, span_notice("你开始开采[ore_descriptor]..."))
	if(W.use_tool(src, user, src.mining_time, volume=50))
		to_chat(user, span_notice("你开采了[ore_descriptor]。"))
		if(ore_type && ore_amount && depleted == FALSE)
			new ore_type(loc, ore_amount)
		SSblackbox.record_feedback("tally", "pick_used_mining", 1, W.type)
		depleted = TRUE
		update_icon_state()
		addtimer(CALLBACK(src, PROC_REF(regenerate_ore)), regeneration_time)

/// After the ore vein finishes its wait, we make the ore 'respawn' and return the ore to its original post-Initialize() icon_state.
/obj/structure/ore_vein/proc/regenerate_ore()
	depleted = FALSE
	update_icon_state()

/obj/structure/ore_vein/stone
	name = "大块岩石"
	desc = "各种高品质的石头，如果挖掘并提炼，很可能成为良好的建筑材料。"

/obj/structure/ore_vein/iron
	name = "锈蚀岩石"
	desc = "这些岩石上的锈褐色暴露了它们富含铁的事实！"
	icon_state = "iron1"
	base_icon_state = "iron"
	ore_descriptor = "iron"
	ore_type = /obj/item/stack/ore/iron

/obj/structure/ore_vein/silver
	name = "银蓝色岩石"
	desc = "这些岩石呈现出典型的蓝银色外观，嗯，就是原银的样子。"
	icon_state = "silver1"
	base_icon_state = "silver"
	ore_descriptor = "silver"
	ore_type = /obj/item/stack/ore/silver

/obj/structure/ore_vein/gold
	name = "金纹岩石"
	desc = "看起来相当普通的岩石……除了其中一些上面贯穿的闪亮金色条纹！"
	icon_state = "gold1"
	base_icon_state = "gold"
	ore_descriptor = "gold"
	ore_type = /obj/item/stack/ore/gold

/obj/structure/ore_vein/plasma
	name = "等离子富集岩石"
	desc = "几块岩石外部可见未精炼的等离子体……靠近这东西时务必小心明火。"
	icon_state = "plasma1"
	base_icon_state = "plasma"
	ore_descriptor = "plasma"
	ore_type = /obj/item/stack/ore/plasma

/obj/structure/ore_vein/diamond
	name = "钻石镶嵌岩石"
	desc = "虽然远没有你想象的那么稀有，但这些岩石上镶嵌的钻石仍然既实用又有价值。"
	icon_state = "diamond1"
	base_icon_state = "diamond"
	ore_descriptor = "diamond"
	ore_type = /obj/item/stack/ore/diamond
