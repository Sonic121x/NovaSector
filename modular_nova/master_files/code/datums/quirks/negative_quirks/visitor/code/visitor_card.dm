//the card
/obj/item/card/id/advanced/visitor
	name = "访客ID"
	icon_state = "visitor"
	icon = 'modular_nova/master_files/code/datums/quirks/negative_quirks/visitor/icons/card.dmi'
	assigned_icon_state = null
	desc = "一张发放给空间站访客的ID卡。它的外观令人不敢恭维，明摆着告诉你连官僚系统都懒得为你费心。"
	trim = /datum/id_trim/job/assistant/visitor
	trim_changeable = FALSE

/datum/id_trim/job/assistant/visitor
	trim_state = "trim_visitor"
	trim_icon = 'modular_nova/master_files/code/datums/quirks/negative_quirks/visitor/icons/card.dmi'
	sechud_icon_state = SECHUD_UNKNOWN

/obj/item/storage/box/visitor_ids
	name = "备用访客身份卡盒"
	desc = "有好多空白的身份卡。"
	illustration = "id"

/obj/item/storage/box/visitor_ids/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/advanced/visitor(src)

//design
/datum/design/id/visitor
	name = "访客ID卡"
	desc = "一种用于提供身份证明的卡片，尤其适用于空间站上的访客。"
	id = "idcard_guest"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/card/id/advanced/visitor
