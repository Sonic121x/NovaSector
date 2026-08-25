// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty wooden crate. You'll need a crowbar to get it open."
	icon_state = "largecrate"
	base_icon_state = "largecrate"
	density = TRUE
	pass_flags_self = PASSSTRUCTURE
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 4
	delivery_icon = "deliverybox"
	integrity_failure = 0 //Makes the crate break when integrity reaches 0, instead of opening and becoming an invisible sprite.
	open_sound = 'sound/machines/closet/wooden_closet_open.ogg'
	close_sound = 'sound/machines/closet/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	can_install_electronics = FALSE
	elevation = 22
	can_weld_shut = FALSE

	// Stops people from "diving into" a crate you can't open normally
	divable = FALSE

/obj/structure/closet/crate/large/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_MISSING_ITEM_ERROR, TRAIT_GENERIC)

/obj/structure/closet/crate/large/attack_hand(mob/user, list/modifiers)
	add_fingerprint(user)
	if(!tear_manifest(user))
		to_chat(user, span_warning(LANG("obj.310b3e222ee3c0e4", null)))

/obj/structure/closet/crate/large/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return ITEM_INTERACT_SKIP_TO_ATTACK //Stops it from opening and turning invisible when items are used on it.

	to_chat(user, span_warning(LANG("obj.310b3e222ee3c0e4", null)))
	return ITEM_INTERACT_BLOCKING //Just stop. Do nothing. Don't turn into an invisible sprite. Don't open like a locker.
								  //The large crate has no non-attack interactions other than the crowbar, anyway.

/obj/structure/closet/crate/large/crowbar_act(mob/living/user, obj/item/tool)
	if(manifest)
		tear_manifest(user)
	if(!open(user))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_notice(LANG("obj.5e000044b93769be", list(user, src))), \
						span_notice(LANG("obj.75ea16c7ae69c19c", list(src))), \
						span_hear(LANG("obj.5fcb16ad6c46c22a", null)))
	playsound(src.loc, 'sound/items/weapons/slashmiss.ogg', 75, TRUE)

	var/turf/dump = get_turf(src)
	for(var/i in 1 to material_drop_amount)
		new material_drop(src)
	for(var/atom/movable/stuff in contents)
		stuff.forceMove(dump)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/structure/closet/crate/large/hats/PopulateContents()
	..()
	for (var/i in 1 to 5)
		new /obj/effect/spawner/random/clothing/funny_hats(src)
	if(prob(1))
		var/our_contents = list()
		for(var/obj/item/clothing/head/any_hat in contents)
			our_contents[any_hat]++
		if(our_contents)
			var/obj/item/clothing/head/lucky_hat = pick(our_contents)
			lucky_hat.AddComponent(/datum/component/unusual_effect, color = "#FFEA0030", include_particles = TRUE)
			lucky_hat.name = "unusual [name]"
