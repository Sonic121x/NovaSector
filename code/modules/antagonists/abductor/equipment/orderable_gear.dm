GLOBAL_LIST_INIT(abductor_gear, subtypesof(/datum/abductor_gear))

#define CATEGORY_BASIC_GEAR "Basic Gear"
#define CATEGORY_ADVANCED_GEAR "Advanced Gear"
#define CATEGORY_MISC_GEAR "Miscellaneous Gear"

/datum/abductor_gear
	/// Name of the gear
	var/name = "劫持者通用套件"
	/// Description of the gear
	var/description = "Generic description."
	/// Unique ID of the gear
	var/id = "abductor_generic"
	/// Credit cost of the gear
	var/cost = 1
	/// Build path of the gear itself
	var/build_path = null
	/// Category of the gear
	var/category = CATEGORY_BASIC_GEAR

/datum/abductor_gear/agent_helmet
	name = "特工头盔"
	description = "Abduct with style - spiky style. Prevents digital tracking."
	id = "agent_helmet"
	build_path = list(/obj/item/clothing/head/helmet/abductor = 1)

/datum/abductor_gear/agent_vest
	name = "特工背心"
	description = "A vest outfitted with advanced stealth technology. It has two modes - combat and stealth."
	id = "agent_vest"
	build_path = list(/obj/item/clothing/suit/armor/abductor/vest = 1)

/datum/abductor_gear/radio_silencer
	name = "无线电消音器"
	description = "A compact device used to shut down communications equipment."
	id = "radio_silencer"
	build_path = list(/obj/item/abductor/silencer = 1)

/datum/abductor_gear/science_tool
	name = "科学工具"
	description = "A dual-mode tool for retrieving specimens and scanning appearances. Scanning can be done through cameras."
	id = "science_tool"
	build_path = list(/obj/item/abductor/gizmo = 1)

/datum/abductor_gear/advanced_baton
	name = "异星电棍"
	description = "A quad-mode baton used for incapacitation and restraining of specimens."
	id = "advanced_baton"
	cost = 2
	build_path = list(/obj/item/melee/baton/abductor = 1)

/datum/abductor_gear/superlingual_matrix
	name = "超语言矩阵"
	description = "A mysterious structure that allows for instant communication between users. Using it inhand will attune it to your mothership's channel. Pretty impressive until you need to eat something."
	id = "superlingual_matrix"
	build_path = list(/obj/item/organ/tongue/abductor = 1)
	category = CATEGORY_MISC_GEAR

/datum/abductor_gear/mental_interface
	name = "思维接口设备"
	description = "A dual-mode tool for directly communicating with sentient brains. It can be used to send a direct message to a target, \
				or to send a command to a test subject with a charged gland."
	id = "mental_interface"
	cost = 2
	build_path = list(/obj/item/abductor/mind_device = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/reagent_synthesizer
	name = "试剂合成器"
	description = "Synthesizes a variety of reagents using proto-matter."
	id = "reagent_synthesizer"
	cost = 2
	build_path = list(/obj/item/abductor_machine_beacon/chem_dispenser = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/shrink_ray
	name = "缩小射线炮"
	description = "This is a piece of frightening alien tech that enhances the magnetic pull of atoms in a localized space to temporarily make an object shrink. \
				That or it's just space magic. Either way, it shrinks stuff."
	id = "shrink_ray"
	cost = 2
	build_path = list(/obj/item/gun/energy/shrink_ray = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/omnitool
	name = "外星万能工具"
	description = "A handheld device with an absurd number of integrated tools. Can be used as a convenient tool replacement for either role. \
				Right-click it to switch between medical and hacking toolsets."
	id = "omnitool"
	cost = 2
	build_path = list(/obj/item/abductor/alien_omnitool = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/cow
	name = "备用奶牛"
	description = "送来一份早期绑架行动中剩余的样本。"
	id = "cow"
	build_path = list(/mob/living/basic/cow = 1, /obj/item/food/grown/wheat = 3)
	category = CATEGORY_MISC_GEAR

/datum/abductor_gear/posters
	name = "装饰海报"
	description = "一些海报，用来装饰母舰（甚至空间站）的墙壁。"
	id = "poster"
	build_path = list(/obj/item/poster/random_abductor = 2)
	category = CATEGORY_MISC_GEAR

#undef CATEGORY_BASIC_GEAR
#undef CATEGORY_ADVANCED_GEAR
#undef CATEGORY_MISC_GEAR
