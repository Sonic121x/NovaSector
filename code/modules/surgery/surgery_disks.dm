// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/disk/surgery
	name = "surgery procedure disk"
	desc = "A disk that contains advanced surgery procedures, must be loaded into an Operating Console."
	icon_state = "datadisk1"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass=SMALL_MATERIAL_AMOUNT)
	/// List of surgical operations contained on this disk
	var/list/surgeries

/obj/item/disk/surgery/debug
	name = "debug surgery disk"
	desc = "A disk that contains all existing surgery procedures."
	icon_state = "datadisk1"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass=SMALL_MATERIAL_AMOUNT)

/obj/item/disk/surgery/debug/Initialize(mapload)
	. = ..()
	surgeries = list()
	for(var/datum/surgery_operation/operation as anything in GLOB.operations.get_instances_from(subtypesof(/datum/surgery_operation)))
		surgeries += operation.type

/obj/item/disk/surgery/advanced_plastic_surgery
	name = "advanced plastic surgery disk"
	desc = "Provides instructions on how to perform more intricate plastic surgeries."

	surgeries = list(
		/datum/surgery_operation/limb/add_plastic,
	)

/obj/item/disk/surgery/advanced_plastic_surgery/examine(mob/user)
	. = ..()
	. += span_info(LANG("obj.372641a25ca2bbb5", list(/datum/surgery_operation/limb/add_plastic::name)))
	. += span_info(LANG("obj.f9b0b03c018136e9", list(/datum/surgery_operation/limb/plastic_surgery::name)))

/obj/item/disk/surgery/advanced_plastic_surgery/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/examine_lore, \
		lore = "Most forms of plastic surgery became obsolete due in no small part to advances in genetics technology. \
			Very basic methods still remain in use, but scarcely, and primarily to reverse a patient's disfigurements. \
			As a consequence, this item became an antique to many collectors - \
			though some back alley surgeons still seek one out for its now uncommon knowledge." \
	)

/obj/item/disk/surgery/brainwashing
	//name = "brainwashing surgery disk" // NOVA EDIT REMOVAL - Finally I can upload the funny surgery disk without letting everyone in the room know about it!
	desc = "The disk provides instructions on some kind of surgery, but the label has been scratched off..." //NOVA EDIT CHANGE: Moved to Special Desc - ORIGINAL: desc = "Provides instructions on how to impress an order on a brain, making it the primary objective of the patient."
	surgeries = list(
		/datum/surgery_operation/organ/brainwash,
		/datum/surgery_operation/organ/brainwash/mechanic,
	)
	// NOVA EDIT ADDITION START - Job specific descriptions
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list("Medical Doctor, Chief Medical Officer, Roboticist")
	special_desc = "The disk provides instructions on how to impress an order on a brain, making it the primary objective of the patient."
	// NOVA EDIT ADDITION END

/obj/item/disk/surgery/sleeper_protocol
	name = "suspicious surgery disk"
	desc = "Provides instructions on how to convert a patient into a sleeper agent for the Syndicate."
	surgeries = list(
		/datum/surgery_operation/organ/brainwash/sleeper,
		/datum/surgery_operation/organ/brainwash/sleeper/mechanic,
	)
