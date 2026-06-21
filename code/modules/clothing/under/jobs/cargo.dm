/obj/item/clothing/under/rank/cargo
	icon = 'icons/obj/clothing/under/cargo.dmi'
	worn_icon = 'icons/mob/clothing/under/cargo.dmi'
	abstract_type = /obj/item/clothing/under/rank/cargo

/obj/item/clothing/under/rank/cargo/qm
	name = "军需官制服"
	desc = "一件棕色正装衬衫，搭配黑色西裤。专为防止因处理文书工作导致的背部损伤而设计。"
	icon_state = "qm"
	inhand_icon_state = "lb_suit"

/obj/item/clothing/under/rank/cargo/qm/skirt
	name = "quartermaster's skirt"
	desc = "一件棕色正装衬衫，搭配一条黑色百褶长裙。专为防止因处理文书工作导致的背部损伤而设计。"
	icon_state = "qm_skirt"
	inhand_icon_state = "lb_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/cargo/tech
	name = "cargo technician's uniform"
	desc = "一件棕色毛衣和黑色牛仔裤，因为说真的，谁喜欢短裤呢？"
	icon_state = "cargotech"
	inhand_icon_state = "lb_suit"

/obj/item/clothing/under/rank/cargo/tech/alt
	name = "cargo technician's shorts"
	desc = "我超喜欢短裤！它们又舒服又容易穿！"
	icon_state = "cargotech_alt"
	inhand_icon_state = "lb_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/cargo/tech/skirt
	name = "cargo technician's skirt"
	desc = "一件棕色毛衣和一条相配的黑色裙子。"
	icon_state = "cargo_skirt"
	inhand_icon_state = "lb_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/cargo/tech/skirt/alt
	name = "cargo technician's shortskirt"
	desc = "我超喜欢裙子！它们又舒服又容易穿！"
	icon_state = "cargo_skirt_alt"

/obj/item/clothing/under/rank/cargo/miner
	name = "竖井矿工连身衣"
	desc = "这是一件时髦的连身衣和一套结实的工装裤。它很脏。"
	icon_state = "miner"
	inhand_icon_state = null
	armor_type = /datum/armor/clothing_under/cargo_miner
	resistance_flags = NONE

/datum/armor/clothing_under/cargo_miner
	fire = 80
	wound = 10

/obj/item/clothing/under/rank/cargo/miner/lavaland
	name = "shaft miner's jumpsuit"
	desc = "一件用于在危险环境中作业的灰色制服。"
	icon_state = "explorer"
	inhand_icon_state = null

/obj/item/clothing/under/rank/cargo/bitrunner
	name = "bitrunner's jumpsuit"
	desc = "这是一件比特行者穿的皮质连体服。有点俗气，但长时间坐着穿很舒服。"
	icon_state = "bitrunner"
	inhand_icon_state = "w_suit"
