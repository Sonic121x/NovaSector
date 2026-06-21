#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

/*
	The damage modifiers here are modified to stay in line with teshari
	Although I'm not sure if it's redundant, better safe than sorry.

	Addendum: the limbs lack "limb_id = SPECIES_TESHARI". if this becomes a problem, just put those in xoxo -aKhro
 */

#define TESHARI_PUNCH_LOW 2
#define TESHARI_PUNCH_HIGH 6

#define BODYPART_ID_TESH_ROBOTIC "tesh_robotic"

//Teshari normal

/obj/item/bodypart/arm/left/robot/teshari
	name = "机械左猛禽前肢"
	desc = "一个由伪肌肉和膜状羽毛包裹的骨骼肢体，配有低导电性外壳。"
	icon = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	icon_static = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = 1
	burn_modifier = 0.9

/obj/item/bodypart/arm/right/robot/teshari
	name = "机械右猛禽前肢"
	desc = "一个由伪肌肉和膜状羽毛包裹的骨骼肢体，配有低导电性外壳。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = 1
	burn_modifier = 0.9

/obj/item/bodypart/leg/left/robot/teshari
	name = "机械左猛禽后肢"
	desc = "一个由伪肌肉和膜状羽毛包裹的骨骼肢体，配有低导电性外壳。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = 1
	burn_modifier = 0.9
	speed_modifier = -0.1

/obj/item/bodypart/leg/right/robot/teshari
	name = "机械右猛禽后肢"
	desc = "一个由伪肌肉和膜状羽毛包裹的骨骼肢体，配有低导电性外壳。"
	icon_static =  'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH
	speed_modifier = -0.1

	brute_modifier = 1
	burn_modifier = 0.9

/obj/item/bodypart/chest/robot/teshari
	name = "机械猛禽躯干"
	desc = "一个包含机械人逻辑板的重型加固外壳，留有标准电源单元的空间，表面覆盖着一层膜状羽毛。"
	icon_static =  'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	brute_modifier = 1
	burn_modifier = 0.9

	robotic_emp_paralyze_damage_percent_threshold = 0.5

/obj/item/bodypart/head/robot/teshari
	name = "机械猛禽头部"
	desc = "一个标准的强化脑壳，带有脊柱插接式神经接口和传感器万向节。一层膜状羽毛覆盖着裸露的金属。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = 1
	burn_modifier = 0.9

	head_flags = HEAD_EYESPRITES|HEAD_EYECOLOR
	eyes_icon = 'modular_nova/modules/organs/icons/teshari_eyes.dmi'

// teshari_ surplus

/obj/item/bodypart/arm/left/robot/teshari_surplus
	name = "左猛禽前肢义体"
	desc = "一副骨架般的机械翼。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2

	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/right/robot/teshari_surplus
	name = "右猛禽前肢义体"
	desc = "一副骨架般的机械翼。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2

	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/left/robot/teshari_surplus
	name = "左猛禽后肢义体"
	desc = "一副骨架般的机械后肢。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/right/robot/teshari_surplus
	name = "右猛禽后肢义体"
	desc = "一副骨架般的机械后肢。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/left/robot/teshari_surplus
	name = "左猛禽前肢义体"
	desc = "一副骨架般的机械翼。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2

	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/right/robot/teshari_surplus
	name = "右猛禽前肢义体"
	desc = "一副骨架般的机械翼。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2

	max_damage = LIMB_MAX_HP_PROSTHESIS

	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS


	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/left/robot/teshari_surplus
	name = "左猛禽后肢义体"
	desc = "一副骨架般的机械后肢。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_PROSTHESIS

	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/right/robot/teshari_surplus
	name = "右猛禽后肢义体"
	desc = "一副骨架般的机械后肢。已经过时且脆弱，但总比没有强。一层膜状羽毛掩盖了廉价的组装。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/surplus_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 0.3
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 0.5

	brute_modifier = 1.25
	burn_modifier = 1.2
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_PROSTHESIS
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_PROSTHESIS

	biological_state = (BIO_METAL|BIO_JOINTED)

// teshari_ advanced

/obj/item/bodypart/arm/left/robot/teshari_advanced
	name = "高级左猛禽前肢"
	desc = "一个先进的机器人后肢。这些设计通常为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 0.8
	burn_modifier = 1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/right/robot/teshari_advanced
	name = "高级右猛禽前肢"
	desc = "一个先进的机器人后肢。这些设计通常为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 0.8
	burn_modifier = 1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/left/robot/teshari_advanced
	name = "先进左猛禽后肢"
	desc = "一个先进的机器人后肢。这些设计通常为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 0.8
	burn_modifier = 1
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/right/robot/teshari_advanced
	name = "先进右猛禽后肢"
	desc = "一个高级机械后肢。这类设计通常专为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 0.8
	burn_modifier = 1
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/left/robot/teshari_advanced
	name = "高级左猛禽前肢"
	desc = "一个先进的机器人后肢。这些设计通常为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 1
	burn_modifier = 0.9

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/arm/right/robot/teshari_advanced
	name = "高级右猛禽前肢"
	desc = "一个先进的机器人后肢。这些设计通常为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 1
	burn_modifier = 0.9

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/left/robot/teshari_advanced
	name = "先进左猛禽后肢"
	desc = "一个先进的机器人后肢。这些设计通常为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 1
	burn_modifier = 0.9
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

/obj/item/bodypart/leg/right/robot/teshari_advanced
	name = "先进右猛禽后肢"
	desc = "一个高级机械后肢。这类设计通常专为那些仍在寻找阿瓦隆的人保留。"
	icon_static = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	icon = 'modular_nova/modules/tesh_augments/icons/advanced_augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = BODYPART_ID_TESH_ROBOTIC

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 1
	burn_modifier = 0.9
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_METAL|BIO_JOINTED)

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG

#undef TESHARI_PUNCH_LOW
#undef TESHARI_PUNCH_HIGH

#undef BODYPART_ID_TESH_ROBOTIC
