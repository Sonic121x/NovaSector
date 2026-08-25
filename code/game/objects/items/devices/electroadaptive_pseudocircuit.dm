// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define MIN_ENERGY_COST (0.01 * STANDARD_CELL_CHARGE)
#define MAX_ENERGY_COST (0.5 * STANDARD_CELL_CHARGE)

//Used by engineering cyborgs in place of generic circuits.
/obj/item/electroadaptive_pseudocircuit
	name = "electroadaptive pseudocircuit"
	desc = "An all-in-one circuit imprinter, designer, synthesizer, outfitter, creator, and chef. It can be used in place of any generic circuit board during construction."
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "boris"
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 3)
	var/recharging = FALSE
	var/circuits = 5 //How many circuits the pseudocircuit has left
	var/static/recycleable_circuits = typecacheof(list(
		/obj/item/electronics/firelock,
		/obj/item/electronics/airalarm,
		/obj/item/electronics/firealarm,
		/obj/item/electronics/apc,
	))//A typecache of circuits consumable for material

/obj/item/electroadaptive_pseudocircuit/Initialize(mapload)
	. = ..()
	maptext = MAPTEXT(circuits)

/obj/item/electroadaptive_pseudocircuit/examine(mob/user)
	. = ..()
	if(iscyborg(user))
		// NOVA EDIT CHANGE START - I18N: 原本是 `. += A + "\n" + B + "\n" + C` 拼接链——整条抽出来是
		// `{0}\n{1}\n…` 的废键，逐段拆分又被整句闸挡掉前两句，于是只有第三句进了目录。逐句 LANG。
		// ORIGINAL: 三句 span_notice 用 + "\n" + 串起来，见 git 历史。
		. += "[span_notice(LANG("obj.7cc773b19af56485", list(circuits, circuits == 1 ? "" : "s")))]\n"+\
		"[span_notice(LANG("obj.35847d7e43c03f80", null))]\n"+\
		span_notice(LANG("obj.340338b019a2afbe", null))
		// NOVA EDIT CHANGE END

/obj/item/electroadaptive_pseudocircuit/proc/adapt_circuit(mob/living/silicon/robot/R, circuit_cost = 0)
	if(QDELETED(R) || !istype(R))
		return
	if(!R.cell)
		to_chat(R, span_warning(LANG("obj.e7e046594fe276e1", null)))
		return
	if(recharging)
		to_chat(R, span_warning(LANG("obj.fb922db994064a76", list(src))))
		return
	if(!R.cell.use(circuit_cost))
		to_chat(R, span_warning(LANG("obj.bf316d0764a6542d", list(display_energy(circuit_cost)))))
		return
	if(!circuits)
		to_chat(R, span_warning(LANG("obj.bbe5e976e12df3e9", list(src))))
		return
	playsound(R, 'sound/items/tools/rped.ogg', 50, TRUE)
	recharging = TRUE
	circuits--
	maptext = MAPTEXT(circuits)
	icon_state = "[initial(icon_state)]_recharging"
	var/recharge_time = (circuit_cost - MIN_ENERGY_COST) / (MAX_ENERGY_COST - MIN_ENERGY_COST)
	recharge_time = clamp(recharge_time, 0, 1)
	recharge_time = (5 SECONDS) + (55 SECONDS) * recharge_time //anywhere between 5 seconds to 1 minute
	addtimer(CALLBACK(src, PROC_REF(recharge)), ROUND_UP(recharge_time))
	return TRUE //The actual circuit magic itself is done on a per-object basis

/obj/item/electroadaptive_pseudocircuit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!is_type_in_typecache(interacting_with, recycleable_circuits))
		return NONE
	circuits++
	maptext = MAPTEXT(circuits)
	user.visible_message(
		span_notice(LANG("obj.c1c343c9b527437d", list(interacting_with, src))),
		span_notice(LANG("obj.3214e85792a02954", list(interacting_with, src, circuits)))
	)
	playsound(user, 'sound/items/deconstruct.ogg', 50, TRUE)
	qdel(interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/electroadaptive_pseudocircuit/proc/recharge()
	playsound(src, 'sound/machines/chime.ogg', 25, TRUE)
	recharging = FALSE
	icon_state = initial(icon_state)

#undef MIN_ENERGY_COST
#undef MAX_ENERGY_COST
