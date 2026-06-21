/////////// cleric's den items.

//Primary reward: the cleric's mace design disk.
/obj/item/disk/design_disk/cleric_mace
	name = "圣父锻造磁盘"

/obj/item/disk/design_disk/cleric_mace/Initialize(mapload)
	. = ..()
	blueprints += new /datum/design/cleric_mace

/obj/item/paper/fluff/ruins/clericsden/contact
	default_raw_text = "奥雷利恩神父，仪式已经完成，很快我们在堡垒的兄弟们就会认识到我们的道路才是正确的。毕竟，一个机械之神或血神？荒谬。只有真正的神才应拥有如此伟力。签名，奥迪瓦卢斯神父。"

/obj/item/paper/fluff/ruins/clericsden/warning
	default_raw_text = "奥迪瓦卢斯神父，不要继续仪式。我们锚定的那颗小行星不稳定，你会摧毁空间站的。我希望这能及时送达。奥雷利恩神父。"
