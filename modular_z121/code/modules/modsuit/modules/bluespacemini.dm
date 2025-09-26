/datum/crafting_recipe/bluespace_mini
	name = "蓝空储存模块Mini"
	reqs = list(
		/obj/item/mod/module/storage/large_capacity = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
	)

	result = /obj/item/mod/module/storage/bluespace_mini
	category = CAT_CONTAINERS

/obj/item/mod/module/storage/bluespace_mini
	name = "蓝空储存模块 Mini"
	desc = "纳米传讯开发的储存系统,这个模块采用微型蓝空口袋,实现终极储存技术,无论物品重量\
	注:本模块为适用于空间站的Mini版本,容量有所降低"
	icon_state = "storage_bluespace"
	max_combined_w_class = 30
	max_items = 21
