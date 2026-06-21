/obj/structure/fluff/iced_abductor ///Unless more non-machine ayy structures made, it will stay in fluff.
	name = "神秘的冰块"
	desc = "一个人影躺在这块看起来很结实的冰块里。谁知道它是从哪里来的？"
	icon = 'icons/effects/freeze.dmi'
	icon_state = "ice_ayy"
	density = TRUE
	deconstructible = FALSE

/obj/structure/fluff/iced_abductor/Destroy()
	var/turf/T = get_turf(src)
	new /obj/effect/mob_spawn/corpse/human/abductor(T)
	. = ..()
