/obj/structure/showcase/fake_cafe_console
	name = "民用控制台"
	desc = "一台固定式计算机。这台预装了通用程序。"
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"

/obj/structure/showcase/fake_cafe_console/rd
	name = "研发控制台"
	desc = "一台用于连接研发工具的控制台。"

/obj/structure/showcase/fake_cafe_console/rd/Initialize(mapload)
	. = ..()
	add_overlay("rdcomp")
	add_overlay("rd_key")

