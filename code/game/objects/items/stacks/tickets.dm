/obj/item/stack/arcadeticket
	name = "街机奖券"
	desc = "哇！攒够这些，你就能买辆自行车了！……切，得了吧。"
	singular_name = "arcade ticket"
	icon_state = "arcade-ticket"
	inhand_icon_state = "tickets"
	w_class = WEIGHT_CLASS_TINY
	max_amount = 30
	merge_type = /obj/item/stack/arcadeticket

/obj/item/stack/arcadeticket/update_icon_state()
	. = ..()
	switch(get_amount())
		if(12 to INFINITY)
			icon_state = "arcade-ticket_4"
		if(6 to 12)
			icon_state = "arcade-ticket_3"
		if(2 to 6)
			icon_state = "arcade-ticket_2"
		else
			icon_state = "arcade-ticket"

/obj/item/stack/arcadeticket/thirty
	amount = 30
