// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Changes a food item's food buff to something else when it has "love" reagent within
/datum/element/love_food_buff
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Buff typepath to add when our food has love within
	var/love_buff_type

/datum/element/love_food_buff/Attach(datum/target, love_buff_type)
	. = ..()
	if(!istype(target, /obj/item/food))
		return ELEMENT_INCOMPATIBLE
	var/obj/item/food/food = target
	if(isnull(food.reagents))
		return ELEMENT_INCOMPATIBLE

	src.love_buff_type = love_buff_type
	RegisterSignal(food.reagents, COMSIG_REAGENTS_HOLDER_UPDATED, PROC_REF(on_reagents_changed))
	RegisterSignal(food, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/element/love_food_buff/Detach(datum/source, ...)
	var/obj/item/food/food = source
	if(istype(food) && !isnull(food.reagents))
		UnregisterSignal(food.reagents, COMSIG_REAGENTS_HOLDER_UPDATED)
		UnregisterSignal(food, COMSIG_ATOM_EXAMINE)
	return ..()

/datum/element/love_food_buff/proc/on_reagents_changed(datum/reagents/source)
	SIGNAL_HANDLER

	var/obj/item/food/food = source.my_atom
	if(!istype(food))
		return

	food.crafted_food_buff = source.has_reagent(/datum/reagent/love) ? love_buff_type : initial(food.crafted_food_buff)

/datum/element/love_food_buff/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice(LANG("datum.c2e4acffbb0aca45", list(source, source.p_their())))
