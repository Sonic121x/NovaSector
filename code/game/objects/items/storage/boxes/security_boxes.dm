// This file contains everything used by security, or in other combat applications.

/obj/item/storage/box/flashbangs
	name = "震撼弹盒（警告）"
	desc = "<B>警告：这些装置极其危险，反复使用可能导致失明或失聪。</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/flashbangs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/flashbang(src)

/obj/item/storage/box/stingbangs
	name = "刺痛弹盒（警告）"
	desc = "<B>警告：这些装置极其危险，反复使用可能导致重伤或死亡。</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/stingbangs/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/box/flashes
	name = "闪光灯泡盒"
	desc = "<B>警告：闪光可能导致严重的眼部损伤，必须佩戴护目镜。</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/flashes/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/flash/handheld(src)

/obj/item/storage/box/wall_flash
	name = "壁挂式闪光装置套件"
	desc = "此盒包含构建壁挂式闪光装置所需的一切。<B>警告：闪光可能导致严重的眼部损伤，必须佩戴护目镜。</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/wall_flash/PopulateContents()
	var/id = rand(1000, 9999)
	// FIXME what if this conflicts with an existing one?

	new /obj/item/wallframe/button(src)
	new /obj/item/electronics/airlock(src)
	var/obj/item/assembly/control/flasher/remote = new(src)
	remote.id = id
	var/obj/item/wallframe/flasher/frame = new(src)
	frame.id = id
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/screwdriver(src)


/obj/item/storage/box/teargas
	name = "催泪瓦斯手榴弹盒（警告）"
	desc = "<B>警告：这些装置极其危险，可能导致失明和皮肤刺激。</B>"
	icon_state = "secbox"
	illustration = "grenade"

/obj/item/storage/box/teargas/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/teargas(src)

/obj/item/storage/box/emps
	name = "电磁脉冲手榴弹盒"
	desc = "一个装有5枚电磁脉冲手榴弹的盒子。"
	illustration = "emp"

/obj/item/storage/box/emps/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/prisoner
	name = "囚犯身份卡盒"
	desc = "夺走他们最后一丝尊严——他们的名字。"
	icon_state = "secbox"
	illustration = "id"

/obj/item/storage/box/prisoner/PopulateContents()
	..()
	new /obj/item/card/id/advanced/prisoner/one(src)
	new /obj/item/card/id/advanced/prisoner/two(src)
	new /obj/item/card/id/advanced/prisoner/three(src)
	new /obj/item/card/id/advanced/prisoner/four(src)
	new /obj/item/card/id/advanced/prisoner/five(src)
	new /obj/item/card/id/advanced/prisoner/six(src)
	new /obj/item/card/id/advanced/prisoner/seven(src)

/obj/item/storage/box/seccarts
	name = "PDA安保模块盒"
	desc = "一个装满安保部门使用的PDA模块的盒子。"
	icon_state = "secbox"
	illustration = "pda"

/obj/item/storage/box/seccarts/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/disk/computer/security(src)

/obj/item/storage/box/firingpins
	name = "标准撞针盒"
	desc = "一个装满标准撞针的盒子，用于让新开发的枪械能够操作。"
	icon_state = "secbox"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin(src)

/obj/item/storage/box/firingpins/paywall
	name = "付费墙撞针盒"
	desc = "一个装满付费墙撞针的盒子，用于让新开发的枪械在自定义设置的付费墙后操作。"

/obj/item/storage/box/firingpins/paywall/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin/paywall(src)

/obj/item/storage/box/firingpins/syndicate
	name = "辛迪加撞针盒"
	desc = "一个装满特殊辛迪加撞针的盒子，这些撞针只允许辛迪加特工使用装有此类撞针的武器。"

/obj/item/storage/box/firingpins/syndicate/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin/implant/pindicate(src)

/obj/item/storage/box/lasertagpins
	name = "激光标签撞针盒"
	desc = "一个装满激光标签撞针的盒子，用于让新开发的枪械要求使用者穿戴颜色鲜艳的塑料护甲后才能使用。"
	illustration = "firingpin"

/obj/item/storage/box/lasertagpins/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/firing_pin/tag/red(src)
		new /obj/item/firing_pin/tag/blue(src)

/obj/item/storage/box/handcuffs
	name = "备用束缚手铐盒"
	desc = "一个装满束缚手铐的盒子。"
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/handcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs(src)

/obj/item/storage/box/zipties
	name = "备用束线带盒"
	desc = "一个装满束线带的盒子。"
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/zipties/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/cable/zipties(src)

/obj/item/storage/box/alienhandcuffs
	name = "备用束缚手铐盒"
	desc = "一个装满束缚手铐的盒子。"
	icon_state = "alienbox"
	illustration = "handcuff"

/obj/item/storage/box/alienhandcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/alien(src)

/obj/item/storage/box/rubbershot
	name = "霰弹枪弹盒（低致命性 - 橡胶弹）"
	desc = "一个装满橡胶弹霰弹枪弹的盒子，专为霰弹枪设计。"
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/rubbershot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/box/lethalshot
	name = "霰弹枪弹盒（致命性）"
	desc = "一个装满致命性霰弹枪弹的盒子，专为霰弹枪设计。"
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/lethalshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/lethalshot/old

/obj/item/storage/box/lethalshot/old/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/buckshot/old(src)

/obj/item/storage/box/slugs
	name = "霰弹枪弹盒（致命性 - 独头弹）"
	desc = "一个装满致命性霰弹枪独头弹的盒子，专为霰弹枪设计。"
	icon_state = "breacher_box"
	illustration = null

/obj/item/storage/box/slugs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun(src)

/obj/item/storage/box/beanbag
	name = "霰弹枪弹盒（低致命性 - 豆袋弹）"
	desc = "一个装满豆袋弹的盒子，专为霰弹枪设计。"
	icon_state = "beanbagshot_box"
	illustration = null

/obj/item/storage/box/beanbag/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/box/breacherslug
	name = "破门霰弹盒"
	desc = "一个装满破门独头弹的盒子，专为快速突入设计，对其他目标效果甚微。"
	icon_state = "breacher_box"
	illustration = null

/obj/item/storage/box/breacherslug/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/breacher(src)

/obj/item/storage/box/large_dart
	name = "XL霰弹镖盒"
	desc = "一个装满化学储存容量提升的霰弹镖的盒子。"
	icon_state = "shotdart_box"
	illustration = null

/obj/item/storage/box/large_dart/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/dart/large(src)

/obj/item/storage/box/emptysandbags
	name = "空沙袋盒"
	illustration = "sandbag"

/obj/item/storage/box/emptysandbags/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/emptysandbag(src)

/obj/item/storage/box/holy_grenades
	name = "圣手榴弹盒"
	desc = "内含数枚用于快速净化异端的手榴弹。"
	illustration = "grenade"

/obj/item/storage/box/holy_grenades/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/holy(src)

/obj/item/storage/box/fireworks
	name = "烟花盒"
	desc = "内含各式烟花。"
	illustration = "sparkler"

/obj/item/storage/box/fireworks/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	new /obj/item/toy/snappop(src)

/obj/item/storage/box/fireworks/dangerous
	desc = "这个盒子上有个小标签，标明它来自戈勒克斯掠夺者。内含各式“烟花”。"

/obj/item/storage/box/fireworks/dangerous/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	if(prob(20))
		new /obj/item/grenade/frag(src)
	else
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/firecrackers
	name = "鞭炮盒"
	desc = "一个装满非法鞭炮的盒子。你想知道现在还有谁在生产这些东西。"
	icon_state = "syndiebox"
	illustration = "firecracker"

/obj/item/storage/box/firecrackers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/firecracker(src)

/obj/item/storage/box/sparklers
	name = "手持烟花盒"
	desc = "一盒纳米传讯品牌的手持烟花，即使在太空寒冬的严寒中也能炽热燃烧。"
	illustration = "sparkler"

/obj/item/storage/box/sparklers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/sparkler(src)

/obj/item/storage/box/evidence
	name = "证物袋盒"
	desc = "一个声称装有证物袋的盒子。"

/obj/item/storage/box/evidence/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/evidencebag(src)
