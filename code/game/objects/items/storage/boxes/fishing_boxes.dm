/obj/item/storage/box/fishing_hooks
	name = "鱼钩套装"
	illustration = "fish"
	custom_price = PAYCHECK_CREW * 2

/obj/item/storage/box/fishing_hooks/PopulateContents()
	new /obj/item/fishing_hook/magnet(src)
	new /obj/item/fishing_hook/shiny(src)
	new /obj/item/fishing_hook/weighted(src)

/obj/item/storage/box/fishing_hooks/master/PopulateContents()
	. = ..()
	new /obj/item/fishing_hook/stabilized(src)
	new /obj/item/fishing_hook/jaws(src)

/obj/item/storage/box/fishing_lines
	name = "鱼线套装"
	illustration = "fish"
	custom_price = PAYCHECK_CREW * 2

/obj/item/storage/box/fishing_lines/PopulateContents()
	new /obj/item/fishing_line/bouncy(src)
	new /obj/item/fishing_line/reinforced(src)
	new /obj/item/fishing_line/cloaked(src)

/obj/item/storage/box/fishing_lines/master/PopulateContents()
	. = ..()
	new /obj/item/fishing_line/auto_reel(src)

///From the fishing mystery box. It's basically a lazarus and a few bottles of strange reagents.
/obj/item/storage/box/fish_revival_kit
	name = "鱼类复苏工具包"
	desc = "今日起成为一名鱼类医生。侧面的标签注明，根据体型大小，需要向鱼泼洒二至十个单位的试剂才能使其复活。"
	illustration = "fish"

/obj/item/storage/box/fish_revival_kit/PopulateContents()
	new /obj/item/lazarus_injector(src)
	new /obj/item/reagent_containers/cup/bottle/fishy_reagent(src)
	new /obj/item/reagent_containers/cup(src) //to splash the reagents on the fish.
	new /obj/item/storage/fish_case(src)
	new /obj/item/storage/fish_case(src)

/obj/item/storage/box/fishing_lures
	name = "鱼饵套装"
	desc = "一个小型钓具盒，内含你抑制随机性所需的所有鱼饵。"
	icon_state = "plasticbox"
	foldable_result = null
	illustration = "fish"
	custom_price = PAYCHECK_CREW * 9
	storage_type = /datum/storage/box/fishing_lures

/obj/item/storage/box/fishing_lures/PopulateContents()
	new /obj/item/paper/lures_instructions(src)
	var/list/typesof = subtypesof(/obj/item/fishing_lure)
	for(var/type in typesof)
		new type (src)

/obj/item/storage/box/aquarium_props
	name = "水族箱装饰盒"
	desc = "让你的水族箱看起来漂亮所需的一切。"
	illustration = "fish"
	custom_price = PAYCHECK_LOWER

/obj/item/storage/box/aquarium_props/PopulateContents()
	for(var/prop_type in subtypesof(/obj/item/aquarium_prop))
		new prop_type(src)
