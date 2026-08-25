// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Tank holder item - Added to an object which can be added to a tank holder.
/datum/component/container_item/tank_holder
	var/tank_holder_icon_state
	var/make_density

/datum/component/container_item/tank_holder/Initialize(state, density = TRUE)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	tank_holder_icon_state = state
	make_density = density
	return ..()

/datum/component/container_item/tank_holder/try_attach(datum/source, obj/structure/tank_holder/container, mob/user)
	if(!container || !istype(container))
		return FALSE
	var/obj/item/I = parent
	if(container.contents.len)
		if(user)
			to_chat(user, span_warning(LANG("datum.b97c45332c564646", list(container))))
		return TRUE
	if(user)
		if(!user.transferItemToLoc(I, container))
			return TRUE
		to_chat(user, span_notice(LANG("datum.6635fb59f38784e0", list(I, container))))
	else
		I.forceMove(container)
	container.tank = I
	container.set_density(make_density)
	container.icon_state = tank_holder_icon_state
	return TRUE
