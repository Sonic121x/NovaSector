// Note: Everyone knows what an emag is, both IC and OOC, they even make toy lookalikes.
/obj/item/card/emag
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "An specially modified ID card used to break machinery and disable safeties. Notoriously used by Syndicate agents."

// The 'closer inspection' extra desc for these goes in special_desc
/obj/item/card/emagfake
	desc = /obj/item/card/emag::desc
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE_TOY
	special_desc = "Closer inspection shows that this card is a poorly made replica, with a \"Donk Co.\" logo stamped on the back."

/obj/item/card/emag/doorjack
	desc = "这张看起来过时的ID卡显然被非法改装了额外的电路。类似于臭名昭著的\"emag\"。"
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "Identifies commonly as a \"doorjack\", this illegally modified ID card can disrupt airlock electronics. Has a self recharging cell. Used often by Syndicate agents."
