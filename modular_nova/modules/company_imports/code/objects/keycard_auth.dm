/proc/toggle_permit_pins()
	GLOB.permit_pin_unrestricted = !GLOB.permit_pin_unrestricted
	minor_announce(LANG("_root.4c0b08acc6d91ce9", list(GLOB.permit_pin_unrestricted ? "removed" : "reinstated")), "Weapons Systems Update:")
	SSblackbox.record_feedback("nested tally", "keycard_auths", 1, list("permit-locked pins", GLOB.permit_pin_unrestricted ? "unlocked" : "locked"))
