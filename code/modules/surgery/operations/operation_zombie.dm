// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/surgery_operation/limb/bionecrosis
	name = "induce bionecrosis"
	rnd_name = "Bionecroplasty (Necrotic Revival)"
	desc = "Inject reagents that stimulate the growth of a Romerol tumor inside the patient's brain."
	rnd_desc = "An experimental procedure which induces the growth of a Romerol tumor inside the patient's brain."
	implements = list(
		/obj/item/reagent_containers/syringe = 1,
		/obj/item/pen = 3.33,
	)
	time = 5 SECONDS
	operation_flags = OPERATION_MORBID | OPERATION_LOCKED | OPERATION_NOTABLE
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED
	any_surgery_states_blocked = SURGERY_VESSELS_UNCLAMPED
	var/list/zombie_chems = list(
		/datum/reagent/medicine/rezadone,
		/datum/reagent/toxin/zombiepowder,
	)

/datum/surgery_operation/limb/bionecrosis/get_default_radial_image()
	return image(get_dynamic_human_appearance(species_path = /datum/species/zombie))

/datum/surgery_operation/limb/bionecrosis/all_required_strings()
	. = ..()
	. += LANG("datum.5816f2fb34093d5f", null)

/datum/surgery_operation/limb/bionecrosis/any_required_strings()
	. = ..()
	for(var/datum/reagent/chem as anything in zombie_chems)
		. += LANG("datum.73dd224d14dff73f", list(chem::name))

/datum/surgery_operation/limb/bionecrosis/all_blocked_strings()
	. = ..()
	. += LANG("datum.e2a6f344e7c16779", null)

/datum/surgery_operation/limb/bionecrosis/state_check(obj/item/bodypart/limb)
	if(locate(/obj/item/organ/zombie_infection) in limb)
		return FALSE
	if(!(locate(/obj/item/organ/brain) in limb))
		return FALSE
	return TRUE

/datum/surgery_operation/limb/bionecrosis/snowflake_check_availability(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, operated_zone)
	for(var/chem in zombie_chems)
		if(tool.reagents?.get_reagent_amount(chem) > 1)
			return TRUE
		if(limb.owner.reagents?.get_reagent_amount(chem) > 1)
			return TRUE
	return FALSE

/datum/surgery_operation/limb/bionecrosis/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to grow a romerol tumor in [limb.owner]'s brain..."),
		span_notice("[surgeon] begins to tinker with [limb.owner]'s brain..."),
		span_notice("[surgeon] begins to perform surgery on [limb.owner]'s brain."),
	)
	display_pain(limb.owner, "Your head pounds with unimaginable pain!") // Same message as other brain surgeries

/datum/surgery_operation/limb/bionecrosis/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You succeed in growing a romerol tumor in [limb.owner]'s brain."),
		span_notice("[surgeon] successfully grows a romerol tumor in [limb.owner]'s brain!"),
		span_notice("[surgeon] completes the surgery on [limb.owner]'s brain."),
	)
	display_pain(limb.owner, "Your head goes totally numb for a moment, the pain is overwhelming!")
	if(locate(/obj/item/organ/zombie_infection) in limb) // they got another one mid surgery? whatever
		return
	var/obj/item/organ/zombie_infection/z_infection = new()
	z_infection.Insert(limb.owner)
	for(var/chem in zombie_chems)
		tool.reagents?.remove_reagent(chem, 1)
		limb.owner.reagents?.remove_reagent(chem, 1)
