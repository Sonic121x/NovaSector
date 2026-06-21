//banana flavored chaos and horror ahead

/obj/item/clothing/shoes/clown_shoes/banana_shoes
	name = "Mk-honk原型鞋"
	desc = "遗失的先进小丑技术原型。这双鞋以香蕉为动力，会留下混乱的痕迹。"
	icon_state = "clown_prototype_off"
	actions_types = list(/datum/action/item_action/toggle)
	/// Whether the clown shoes are active (spawning bananas)
	var/on = FALSE
	/// If TRUE, we will always have the noslip trait no matter whether they're on or off
	var/always_noslip = FALSE
	/// How many materials we consume per banana created
	var/material_per_banana = SMALL_MATERIAL_AMOUNT
	/// Typepath of created banana
	var/banana_type = /obj/item/grown/bananapeel/specialpeel
	/// Material container for bananium
	var/datum/material_container/bananium

/obj/item/clothing/shoes/clown_shoes/banana_shoes/Initialize(mapload)
	if(always_noslip)
		LAZYOR(clothing_traits, TRAIT_NO_SLIP_WATER)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	bananium = new (
		src, \
		list(/datum/material/bananium), \
		100 * SHEET_MATERIAL_AMOUNT, \
		MATCONTAINER_EXAMINE | MATCONTAINER_ANY_INTENT | MATCONTAINER_SILENT, \
		allowed_items = /obj/item/stack, \
	)
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 75, falloff_exponent = 20)
	RegisterSignal(src, COMSIG_SHOES_STEP_ACTION, PROC_REF(on_step))

/obj/item/clothing/shoes/clown_shoes/banana_shoes/Destroy()
	QDEL_NULL(bananium)
	return ..()

/obj/item/clothing/shoes/clown_shoes/banana_shoes/proc/toggle_clowning_action()
	on = !on
	update_appearance()
	if(always_noslip)
		return

	if(on)
		attach_clothing_traits(TRAIT_NO_SLIP_WATER)
	else
		detach_clothing_traits(TRAIT_NO_SLIP_WATER)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/proc/on_step()
	SIGNAL_HANDLER

	var/mob/wearer = loc
	if(!on || !istype(wearer))
		return

	if(bananium.use_amount_mat(material_per_banana, /datum/material/bananium))
		new banana_type(get_step(src, REVERSE_DIR(wearer.dir))) //honk
		return

	toggle_clowning_action()
	to_chat(wearer, span_warning("你的香蕉矿用完了！"))

/obj/item/clothing/shoes/clown_shoes/banana_shoes/attack_self(mob/user)
	var/sheet_amount = bananium.retrieve_all()
	if(sheet_amount)
		to_chat(user, span_notice("你从原型鞋中取出了[sheet_amount]张香蕉矿片。"))
	else
		to_chat(user, span_warning("你无法从原型鞋中取出任何香蕉矿！"))

/obj/item/clothing/shoes/clown_shoes/banana_shoes/examine(mob/user)
	. = ..()
	. += span_notice("The shoes are [on ? "enabled" : "disabled"].")

/obj/item/clothing/shoes/clown_shoes/banana_shoes/ui_action_click(mob/user)
	if(bananium.get_material_amount(/datum/material/bananium) >= material_per_banana)
		toggle_clowning_action()
		to_chat(user, span_notice("You [on ? "activate" : "deactivate"] the prototype shoes."))
	else
		to_chat(user, span_warning("你需要香蕉矿来启动这双原型鞋！"))

/obj/item/clothing/shoes/clown_shoes/banana_shoes/update_icon_state()
	icon_state = "clown_prototype_[on ? "on" : "off"]"
	return ..()
