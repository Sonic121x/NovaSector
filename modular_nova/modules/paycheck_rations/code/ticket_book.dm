/obj/item/storage/ration_ticket_book
	name = "口粮票簿"
	desc = "一本可以收纳你所有口粮票的小册子。随着你的工资发放，这里会有更多票券可用。"
	icon = 'modular_nova/modules/paycheck_rations/icons/tickets.dmi'
	icon_state = "ticket_book"
	w_class = WEIGHT_CLASS_SMALL
	storage_type = /datum/storage/ration_ticket

/datum/storage/ration_ticket
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_slots = 4

/datum/storage/ration_ticket/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(/obj/item/paper/paperslip/ration_ticket)
