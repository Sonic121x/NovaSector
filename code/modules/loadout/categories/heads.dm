/// Head Slot Items (Deletes overrided items)
/datum/loadout_category/head
	category_name = "Head"
	category_ui_icon = FA_ICON_HAT_COWBOY
	type_to_generate = /datum/loadout_item/head
	tab_order = 1

/datum/loadout_item/head
	abstract_type = /datum/loadout_item/head

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(equipper.dna?.species?.outfit_important_for_life)
		if(!visuals_only)
			to_chat(equipper, "由于你的种族套装，你的自定义头盔未能直接装备。")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.head = item_path

/* NOVA EDIT REMOVAL - Already exists in our loadout
/datum/loadout_item/head/beanie
	name = "Beanie (Colorable)"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/fancy_cap
	name = "Fancy Hat (Colorable)"
	item_path = /obj/item/clothing/head/costume/fancy

/datum/loadout_item/head/red_beret
	name = "Red Beret (Colorable)"
	item_path = /obj/item/clothing/head/beret
*/ // NOVA REMOVAL END

/datum/loadout_item/head/black_cap
	name = "帽子（黑色）"
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/blue_cap
	name = "帽子（蓝色）"
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/delinquent_cap
	name = "帽子（不良少年款）"
	item_path = /obj/item/clothing/head/costume/delinquent

/datum/loadout_item/head/green_cap
	name = "帽子（绿色）"
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/grey_cap
	name = "帽子（灰色）"
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/orange_cap
	name = "帽子（橙色）"
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/purple_cap
	name = "帽子（紫色）"
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/rainbow_cap
	name = "帽子（彩虹色）"
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/red_cap
	name = "帽子（红色）"
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/white_cap
	name = "帽子（白色）"
	item_path = /obj/item/clothing/head/soft/mime

/datum/loadout_item/head/yellow_cap
	name = "帽子（黄色）"
	item_path = /obj/item/clothing/head/soft/yellow

/datum/loadout_item/head/flatcap
	name = "帽子（平顶）"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/beige_fedora
	name = "软呢帽（米色）"
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/black_fedora
	name = "软呢帽（黑色）"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/white_fedora
	name = "软呢帽（白色）"
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/mail_cap
	name = "帽子（邮递员）"
	item_path = /obj/item/clothing/head/costume/mailman

/datum/loadout_item/head/kitty_ears
	name = "猫耳"
	item_path = /obj/item/clothing/head/costume/kitty

/datum/loadout_item/head/rabbit_ears
	name = "兔耳"
	item_path = /obj/item/clothing/head/costume/rabbitears

/datum/loadout_item/head/bandana
	name = "细头巾"
	item_path = /obj/item/clothing/head/costume/tmc

/datum/loadout_item/head/rastafarian
	name = "帽子（拉斯塔法里）"
	item_path = /obj/item/clothing/head/rasta

/datum/loadout_item/head/top_hat
	name = "高顶礼帽"
	item_path = /obj/item/clothing/head/hats/tophat

/datum/loadout_item/head/bowler_hat
	name = "圆顶硬礼帽"
	item_path = /obj/item/clothing/head/hats/bowler

/datum/loadout_item/head/bear_pelt
	name = "熊皮帽"
	item_path = /obj/item/clothing/head/costume/bearpelt

/datum/loadout_item/head/ushanka
	name ="乌什安卡帽"
	item_path = /obj/item/clothing/head/costume/ushanka

/* NOVA EDIT REMOVAL - Already exists in our loadout
/datum/loadout_item/head/plague_doctor
	name = "Cap (Plague Doctor)"
	item_path = /obj/item/clothing/head/bio_hood/plague
*/ // NOVA REMOVAL END

/datum/loadout_item/head/rose
	name = "玫瑰"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/sunflower
	name = "向日葵"
	item_path = /obj/item/food/grown/sunflower

/datum/loadout_item/head/poppy
	name = "罂粟花"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/lily
	name = "百合花"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/geranium
	name = "天竺葵"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/harebell
	name = "风铃草"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/wig
	name = "自然假发"
	item_path = /obj/item/clothing/head/wig/natural

/datum/loadout_item/head/santa
	name = "圣诞帽"
	item_path = /obj/item/clothing/head/costume/santa/gags
	required_holiday = FESTIVE_SEASON
