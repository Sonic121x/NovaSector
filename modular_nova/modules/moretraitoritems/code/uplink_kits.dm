/obj/item/storage/box/syndie_kit/cultkitsr
	name = "邪教构造体工具包"
	desc = "一个光滑、坚固的盒子，内部蕴含着不祥的黑暗能量。哎呀。"

/obj/item/storage/box/syndie_kit/cultkitsr/PopulateContents()
	new /obj/item/storage/belt/soulstone/full/purified(src)
	new /obj/item/sbeacondrop/constructshell(src)
	new /obj/item/sbeacondrop/constructshell(src)

/obj/item/sbeacondrop/constructshell
	desc = "上面的标签写着：<i>警告：激活此设备将向您的位置发送一个纳尔之嗣构造体外壳</i>。"
	droptype = /obj/structure/constructshell

/obj/item/storage/belt/soulstone/full/purified/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/soulstone/anybody/purified(src)
