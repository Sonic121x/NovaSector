/obj/structure/closet/crate/secure/loot/luna_energy_upgrade
	name = "\improper B&C锁高安保板条箱"
	desc = "用这种巧妙的“新”方法保护您的研究材料：一个公牛与母牛的游戏。保证您多看它一眼就会爆炸！"
	icon_state = "scisecurecrate"
	base_icon_state = "scisecurecrate"

/obj/structure/closet/crate/secure/loot/luna_energy_upgrade/spawn_loot()
	new /obj/item/luna_fragment/energy_retrofit(src)
	spawned_loot = TRUE
