
/obj/item/poster/random_abductor
	name = "随机绑架者海报"
	poster_type = /obj/structure/sign/poster/abductor/random
	icon = 'icons/obj/poster.dmi'
	icon_state = "rolled_abductor"

/obj/structure/sign/poster/abductor
	icon = 'icons/obj/poster.dmi'
	poster_item_name = "abductor poster"
	poster_item_desc = "A sheet of holofiber resin, with a nanospike perforation on the back end for maximum adhesion."
	poster_item_icon_state = "rolled_abductor"

/obj/structure/sign/poster/abductor/tear_poster(mob/user)
	if(!isabductor(user))
		balloon_alert(user, "它纹丝不动！")
		return
	return ..()

/obj/structure/sign/poster/abductor/attackby(obj/item/tool, mob/user, list/modifiers, list/attack_modifiers)
	if(tool.toolspeed >= 0.2)
		balloon_alert(user, "工具太弱了！")
		return FALSE
	return ..()

/obj/structure/sign/poster/abductor/random
	name = "随机绑架者海报"
	icon_state = "random_abductor"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/abductor

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/random, 32)

/obj/structure/sign/poster/abductor/ayylian
	name = "艾利安"
	desc = "伙计，伊恩最近看起来可真奇怪。"
	icon_state = "ayylian"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayylian, 32)

/obj/structure/sign/poster/abductor/ayy
	name = "绑架者"
	desc = "嘿，那可不是蜥蜴！"
	icon_state = "ayy"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy, 32)

/obj/structure/sign/poster/abductor/ayy_over_tizira
	name = "提兹拉上空的绑架者"
	desc = "一张关于人类-蜥蜴战争电影实验性改编版的海报。由于主演二人拒绝念任何台词，制作过程受到了极大阻碍。"
	icon_state = "ayy_over_tizira"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_over_tizira, 32)

/obj/structure/sign/poster/abductor/ayy_recruitment
	name = "绑架者招募"
	desc = "今天就加入母舰探测部门吧！"
	icon_state = "ayy_recruitment"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_recruitment, 32)

/obj/structure/sign/poster/abductor/ayy_cops
	name = "绑架者警察"
	desc = "一张宣传备受争议的《绑架者警察》系列的海报。一些评论家声称它让他们震惊，而另一些人则说它让他们昏昏欲睡。"
	icon_state = "ayyce_cops"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_cops, 32)

/obj/structure/sign/poster/abductor/ayy_no
	name = "Uayy No"
	desc = "这东西全是日文，而且他们把海报上的动漫女孩去掉了。太离谱了。"
	icon_state = "ayy_no"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_no, 32)

/obj/structure/sign/poster/abductor/ayy_piping
	name = "安全绑架者 - 管道"
	desc = "安全绑架者无话可说。不是因为它不会说话，而是因为绑架者不需要处理大气相关的东西。"
	icon_state = "ayy_piping"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_piping, 32)

/obj/structure/sign/poster/abductor/ayy_fancy
	name = "时髦绑架者"
	desc = "绑架者做什么都是最棒的。这包括看起来很棒！"
	icon_state = "ayy_fancy"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_fancy, 32)
