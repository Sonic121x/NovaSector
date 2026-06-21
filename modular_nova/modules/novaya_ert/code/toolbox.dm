/obj/item/storage/toolbox/ammobox/full
	var/amount = 0 ///Amount of mags/casings/clips we spawn in.

/obj/item/storage/toolbox/ammobox/full/PopulateContents()
	if(!isnull(ammo_to_spawn))
		for(var/i in 1 to amount)
			new ammo_to_spawn(src)

/obj/item/storage/toolbox/ammobox/full/sakhno
	name = "弹药箱（萨赫诺）"
	desc = "如果标签准确，它可能装有萨赫诺精密步枪或其变种型号的桥夹。"
	ammo_to_spawn = /obj/item/ammo_box/speedloader/strilka310
	amount = 7

/obj/item/storage/toolbox/ammobox/full/lanca
	name = "弹药箱（兰卡）"
	desc = "如果标签准确，它应该装有兰卡战斗步枪的弹匣。"
	ammo_to_spawn = /obj/item/ammo_box/magazine/lanca
	amount = 7

/obj/item/storage/toolbox/ammobox/full/nri_smg
	name = "弹药箱（米耶奇）"
	desc = "如果标签准确，它应该装有米耶奇冲锋枪的弹匣。"
	ammo_to_spawn = /obj/item/ammo_box/magazine/miecz
	amount = 7

/obj/item/storage/toolbox/ammobox/full/l6_saw
	name = "弹药箱（L6 SAW）"
	desc = "如果标签准确，它应该装有L6班用自动武器的弹鼓。"
	ammo_to_spawn = /obj/item/ammo_box/magazine/m7mm
	amount = 7

/obj/item/storage/toolbox/ammobox/full/aps
	name = "弹药箱（斯捷奇金APS）"
	desc = "如果标签准确，它应该装有斯捷奇金APS冲锋手枪的弹匣。"
	ammo_to_spawn = /obj/item/ammo_box/magazine/m9mm_aps
	amount = 7
