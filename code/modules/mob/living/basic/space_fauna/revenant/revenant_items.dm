// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
//reforming
/obj/item/ectoplasm/revenant
	name = "glimmering residue"
	desc = "A pile of fine blue dust. Small tendrils of violet mist swirl around it."
	icon = 'icons/effects/effects.dmi'
	icon_state = "revenantEctoplasm"
	w_class = WEIGHT_CLASS_SMALL
	// Can the revenant reform?
	var/inert = FALSE

/obj/item/ectoplasm/revenant/Initialize(mapload, revenant)
	. = ..()
	inert = !revenant
	if(revenant)
		AddComponent(/datum/component/revenant_prison, revenant = revenant)
		addtimer(CALLBACK(src, PROC_REF(reform)), 1 MINUTES)

/obj/item/ectoplasm/revenant/Destroy()
	return ..()

/obj/item/ectoplasm/revenant/proc/check_for_mirrors(turf/location, radius)
	PRIVATE_PROC(TRUE)
	for(var/obj/structure/mirror/mirror in view(radius, location))
		if(mirror.cursable && !mirror.GetComponent(/datum/component/revenant_prison))
			return mirror
	return null

/obj/item/ectoplasm/revenant/attack_self(mob/user)
	if(inert)
		return ..()
	user.visible_message(
		span_notice(LANG("obj.e9f6fbdf45aeb349", list(user, src))),
		span_notice(LANG("obj.1da11af3f8a12741", list(src))),
	)
	var/obj/structure/mirror/nearby_mirror = check_for_mirrors(drop_location(), 5)
	if(nearby_mirror)
		transfer_to_mirror(nearby_mirror)
	user.dropItemToGround(src)
	qdel(src)

/obj/item/ectoplasm/revenant/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(inert)
		return
	var/obj/structure/mirror/nearby_mirror = check_for_mirrors(get_turf(hit_atom), 3)
	if(!nearby_mirror)
		visible_message(span_notice(LANG("obj.7b8abbca912ff196", list(src))))
	else
		transfer_to_mirror(nearby_mirror)
	qdel(src)

/obj/item/ectoplasm/revenant/proc/transfer_to_mirror(obj/structure/mirror/nearby_mirror)
	PRIVATE_PROC(TRUE)
	nearby_mirror.TakeComponent(GetComponent(/datum/component/revenant_prison))
	nearby_mirror.visible_message(span_revenwarning(LANG("obj.ff5c4cbb388dec83", list(src, nearby_mirror))))
	log_game("A revenant was trapped inside [nearby_mirror]")
	message_admins("A revenant was trapped inside [nearby_mirror] [ADMIN_JMP(nearby_mirror)]")

/obj/item/ectoplasm/revenant/examine(mob/user)
	. = ..()
	if(inert)
		. += span_revennotice(LANG("obj.2e85428ab0825bb4", null))
	else
		. += span_revenwarning(LANG("obj.d2af643f6133c14c", null))

/obj/item/ectoplasm/revenant/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.85ae4475dce343ee", list(user, src, user.p_theyre()))))
	qdel(src)
	return OXYLOSS

/// Actually moves the revenant out of ourself
/obj/item/ectoplasm/revenant/proc/reform()
	if(QDELETED(src) || inert)
		return
	if(!GetComponent(/datum/component/revenant_prison))
		return
	message_admins("Revenant ectoplasm was left undestroyed for 1 minute and is reforming into a new revenant.")
	SEND_SIGNAL(src, COMSIG_REVENANT_RELEASE, cause = "ectoplasm reforming")
	visible_message(span_revenboldnotice(LANG("obj.b6ecdf19bb4847d8", list(src))))
	qdel(src)
