/datum/nifsoft/hud
	name = "窥视透镜"
	program_desc = "An umbrella term for all sorts of NIFsofts dealing with heads-up displays, this sort of technology dates back almost to the beginning of NIFsoft development. These 'softs are commonly used in the civilian field for integration with all sorts of activities; piloting, swordplay, scientific research, or even AI copiloting for important social interactions. While normally the nanomachines involved in the program's operation are used as a sort of artificial contact lens over the user's visual organs, Nanotrasen regulations have bid these particular forks to instead integrate with glasses the user's already wearing."
	compatible_nifs = list(/obj/item/organ/cyberimp/brain/nif/standard)
	active_mode = TRUE
	active_cost = 0.5
	ui_icon = "eye"
	/// Do we need to check if the user is wearing compatible eyewear?
	var/eyewear_check = FALSE
	/// What kind of HUD are we adding when the NIFSoft is activated?
	var/hud_type
	/// What are the HUD traits we are adding when the NIFSoft is activated?
	var/list/hud_traits
	/// A list of traits that we want to add while the NIFSoft is active. This is here to emulate things like sci-goggles
	var/list/added_eyewear_traits = list()

/// Attemps to add the hud variables from the NIFSoft to the user.
/datum/nifsoft/hud/proc/add_huds()
	if(hud_type)
		var/datum/atom_hud/hud = GLOB.huds[hud_type]
		hud.show_to(linked_mob)

	for(var/trait in hud_traits)
		ADD_TRAIT(linked_mob, trait, TRAIT_NIFSOFT)

	for(var/trait in added_eyewear_traits)
		ADD_TRAIT(linked_mob, trait, TRAIT_NIFSOFT)

	linked_mob.update_sight()

/// Attempts to remove the HUDs given to the user by the NIFSoft
/datum/nifsoft/hud/proc/remove_huds()
	if(hud_type)
		var/datum/atom_hud/hud = GLOB.huds[hud_type]
		hud.hide_from(linked_mob)

	for(var/trait in hud_traits)
		REMOVE_TRAIT(linked_mob, trait, TRAIT_NIFSOFT)
	for(var/trait in added_eyewear_traits)
		REMOVE_TRAIT(linked_mob, trait, TRAIT_NIFSOFT)

	linked_mob.update_sight()
	return TRUE

/datum/nifsoft/hud/activate()
	var/obj/item/clothing/glasses/worn_glasses = linked_mob.get_item_by_slot(ITEM_SLOT_EYES)
	if(eyewear_check && !active && (!istype(worn_glasses) || !HAS_TRAIT(worn_glasses, TRAIT_NIFSOFT_HUD_GRANTER)))
		linked_mob.balloon_alert(linked_mob, "没有兼容的护目镜！")
		return FALSE

	. = ..() // active = !active
	if(!.)
		return FALSE

	if(!active)
		remove_huds()
		if(eyewear_check)
			if(!istype(worn_glasses)) // Really non-ideal situation, but it's better than a runtime.
				return FALSE

			UnregisterSignal(worn_glasses, COMSIG_ITEM_PRE_UNEQUIP)

		return TRUE

	add_huds()
	if(eyewear_check)
		RegisterSignal(worn_glasses, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(activate))

	return TRUE

/datum/element/nifsoft_hud/Attach(datum/target)
	. = ..()
	if(!istype(target, /obj/item/clothing/glasses))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	ADD_TRAIT(target, TRAIT_NIFSOFT_HUD_GRANTER, INNATE_TRAIT)

/// Adds text to the examine text of the parent item, explaining that the item can be used to enable the use of NIFSoft HUDs
/datum/element/nifsoft_hud/proc/on_examine(datum/source, mob/user, list/examine_text)
	SIGNAL_HANDLER

	examine_text += span_cyan_nova("将此物品佩戴在眼镜槽位将允许你使用 NIFSoft HUD。")

/datum/element/nifsoft_hud/Detach(datum/target)
	UnregisterSignal(target, COMSIG_ATOM_EXAMINE)
	REMOVE_TRAIT(target, TRAIT_NIFSOFT_HUD_GRANTER, INNATE_TRAIT)

	return ..()

/datum/nifsoft/hud/job
	mutually_exclusive_programs = list(/datum/nifsoft/hud/job) //We don't want people stacking job HUDs

//
// JOB NIFSOFT HUDS
//

/datum/nifsoft/hud/job/medical
	name = "医疗窥视透镜"
	ui_icon = "staff-snake"
	hud_traits = list(TRAIT_MEDICAL_HUD)

/datum/nifsoft/hud/job/diagnostic
	name = "诊断窥视透镜"
	ui_icon = "robot"
	hud_traits = list(TRAIT_DIAGNOSTIC_HUD)

/datum/nifsoft/hud/job/security
	name = "安保窥视透镜"
	ui_icon = "shield"
	hud_traits = list(TRAIT_SECURITY_HUD)

/datum/nifsoft/hud/job/cargo_tech
	name = "许可证窥视透镜"
	ui_icon = "gun"
	hud_traits = list(TRAIT_PERMIT_HUD)

/datum/nifsoft/hud/job/science
	name = "科研窥视透镜"
	ui_icon = "flask"
	added_eyewear_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)

/datum/nifsoft/hud/job/meson
	name = "介子窥视透镜"
	ui_icon = "radiation"
	added_eyewear_traits = list(TRAIT_MADNESS_IMMUNE, TRAIT_MESON_VISION)

//
// UPLOADER DISKS
//

/obj/item/disk/nifsoft_uploader/job/med_hud
	name = "医疗窥视透镜"
	loaded_nifsoft = /datum/nifsoft/hud/job/medical

/obj/item/disk/nifsoft_uploader/job/diag_hud
	name = "诊断窥视镜片"
	loaded_nifsoft = /datum/nifsoft/hud/job/diagnostic

/obj/item/disk/nifsoft_uploader/job/sec_hud
	name = "安保窥视镜片"
	loaded_nifsoft = /datum/nifsoft/hud/job/security

/obj/item/disk/nifsoft_uploader/job/permit_hud
	name = "许可窥视镜片"
	loaded_nifsoft = /datum/nifsoft/hud/job/cargo_tech

/obj/item/disk/nifsoft_uploader/job/sci_hud
	name = "科研窥视镜片"
	loaded_nifsoft = /datum/nifsoft/hud/job/science

/obj/item/disk/nifsoft_uploader/job/meson_hud
	name = "介子窥视镜片"
	loaded_nifsoft = /datum/nifsoft/hud/job/meson

//
// NIFSOFT HUD GLASSES
//

/obj/item/clothing/glasses/trickblindfold/obsolete/nif
	name = "现代化假眼罩"
	desc = "一种经过修复的旧式假眼罩版本，经过改装配备了适当的电子元件，可作为NIF平视显示器使用。"

/obj/item/clothing/glasses/trickblindfold/obsolete/nif/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/nifsoft_hud)

