//////
//
// NOVA Override - prevents people from using modular computers while they're in the ghost cafe
// Relies checking for the trait that's given by the spawner. If this ever changes, we'll need to update this.
//
//////
/obj/item/modular_computer/ui_interact(mob/user, datum/tgui/ui)
	if(HAS_TRAIT_FROM(user, TRAIT_FREE_GHOST, TRAIT_GHOSTROLE))
		if(ui)
			ui.close()
		balloon_alert(user, "幽灵咖啡馆访客无法使用此设备！")
		return
	return ..()
