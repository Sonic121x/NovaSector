/obj/item/reagent_containers/vapecart
	name = "电子烟弹"
	desc = "一个装满尼古丁的电子烟弹。"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "vapecart"
	fill_icon_state = "vapecart"
	volume = 50
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/nicotine = 50)
	fill_icon_thresholds = list(0, 5, 20, 40)
	custom_price = PAYCHECK_CREW

/obj/item/reagent_containers/vapecart/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/obj/item/vape/target_vape = interacting_with
	if(!istype(target_vape))
		return NONE
	if(target_vape.screw == TRUE && !target_vape.reagents.total_volume)
		src.reagents.trans_to(target_vape, src.volume, transferred_by = user)
		to_chat(user, span_notice("你将[src.name]插入了电子烟。"))
		qdel(src)
	else if(!target_vape.screw)
		to_chat(user, span_warning("你需要打开盖子才能这么做！"))
	else
		to_chat(user, span_warning("[target_vape]已经满了！"))
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/vapecart/empty
	name = "可定制电子烟弹"
	desc = "用你想要的任何危险化学混合物来填满它！"
	list_reagents = list()
	initial_reagent_flags = OPENCONTAINER
	var/labelled = FALSE

/obj/item/reagent_containers/vapecart/empty/attack_self(mob/user)
	if(reagents.total_volume > 0)
		to_chat(user, span_notice("你将[src]里的所有试剂都清空了。"))
		reagents.clear_reagents()

/obj/item/reagent_containers/vapecart/empty/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if (istype(attacking_item, /obj/item/pen) || istype(attacking_item, /obj/item/toy/crayon))
		if(!user.is_literate())
			to_chat(user, span_notice("你在电子烟弹的标签上胡乱涂鸦！"))
			return
		var/new_title = stripped_input(user, "你想给这个电子烟弹贴什么标签？", name, null, 53)
		if(!user.can_perform_action(src))
			return
		if(user.get_active_held_item() != attacking_item)
			return
		if(new_title)
			labelled = TRUE
			name = "[new_title]"
		else
			labelled = FALSE
			update_name()
	else
		return ..()

/obj/item/reagent_containers/vapecart/empty/update_name(updates)
	. = ..()
	if(labelled)
		return
	name = "可定制电子烟弹"

//thc carts
/obj/item/reagent_containers/vapecart/bluekush
	name = "\improper 布林博士的蓝色库什珍藏烟弹"
	desc = "Don't smoke the carts... They put something in it... t-to make you forget! I don't even remember how I got here..."
	list_reagents = list(/datum/reagent/drug/thc = 20, /datum/reagent/consumable/berryjuice = 10)
	custom_price = PAYCHECK_LOWER

/obj/item/reagent_containers/vapecart/reddiesel
	name = "\improper 抵抗组织红色柴油烟弹"
	desc = "似乎得到了真正的科学家认可！"
	list_reagents = list(/datum/reagent/drug/thc = 20, /datum/reagent/consumable/dr_gibb = 10)
	custom_price = PAYCHECK_LOWER

/obj/item/reagent_containers/vapecart/pwrgame
	name = "\improper Pwr Haze 烟弹"
	desc = "Pwr Game 什么时候开始做烟弹生意了？"
	list_reagents = list(/datum/reagent/drug/thc = 20, /datum/reagent/consumable/pwr_game = 10)
	custom_price = PAYCHECK_LOWER

/obj/item/reagent_containers/vapecart/cheese
	name = "\improper 芝士小丑 OG 库什烟弹"
	desc = "*不含真实奶酪。"
	list_reagents = list(/datum/reagent/drug/thc = 20, /datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3)
	custom_price = PAYCHECK_LOWER

/obj/item/reagent_containers/vapecart/syndicate
	name = "\improper 辛迪加-库什绿色裂纹烟弹"
	desc = "Green Crack 是一种苜蓿品种，并非真正的快克。"
	list_reagents = list(/datum/reagent/drug/thc = 20, /datum/reagent/medicine/stimulants = 10)
	custom_price = PAYCHECK_LOWER
