// LOADOUT ITEM DATUMS FOR THE UNDER (UNIFORM) SLOT

/datum/loadout_category/undersuit
	category_name = "Undersuit"
	category_ui_icon = FA_ICON_SHIRT
	type_to_generate = /datum/loadout_item/under
	tab_order = /datum/loadout_category/suits::tab_order + 1

/datum/loadout_item/under
	abstract_type = /datum/loadout_item/under

/datum/loadout_item/under/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.uniform))
		.. ()
		return TRUE

/datum/loadout_item/under/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.uniform)
			LAZYADD(outfit.backpack_contents, outfit.uniform)
		outfit.uniform = item_path
	else
		outfit.uniform = item_path
	outfit.modified_outfit_slots |= ITEM_SLOT_ICLOTHING

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/under/roman_costume
	name = "Roman Skirt"
	item_path = /obj/item/clothing/under/costume/roman
	group = "Costumes"

/*
 *	JUMPSUITS
 *	To cheat at alphabetization, these have extra spaces at the front of their name.
 *	In-game users won't see these spaces, but it'll still force these to sort as they appear below.
*/

/datum/loadout_item/under/jumpsuit
	abstract_type = /datum/loadout_item/under/jumpsuit

/datum/loadout_item/under/jumpsuit/greyscale
	name = "连体服（可着色）"
	item_path = /obj/item/clothing/under/color

/datum/loadout_item/under/jumpsuit/rainbow
	name = "连体服（彩虹色）"
	item_path = /obj/item/clothing/under/color/rainbow

/datum/loadout_item/under/jumpsuit/random
	name = "连体服 - 随机"
	item_path = /obj/item/clothing/under/color/random
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/under/jumpsuit/random/get_item_information()
	. = ..()
	.[FA_ICON_DICE] = TOOLTIP_RANDOM_COLOR

/datum/loadout_item/under/jumpsuit/greyscale_skirt
	name = "连体裙（可着色）"
	item_path = /obj/item/clothing/under/color/jumpskirt

/datum/loadout_item/under/jumpsuit/rainbow_skirt
	name = "连体裙（彩虹色）"
	item_path = /obj/item/clothing/under/color/jumpskirt/rainbow

/datum/loadout_item/under/jumpsuit/random_skirt
	name = "连体裙 - 随机"
	item_path = /obj/item/clothing/under/color/jumpskirt/random
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/under/jumpsuit/random_skirt/get_item_information()
	. = ..()
	.[FA_ICON_DICE] = TOOLTIP_RANDOM_COLOR

/*
 *	Unsorted
 *	For the love of god try to sort it first.
*/

/datum/loadout_item/under/jumpsuit/kim
	name = "气动服"
	item_path = /obj/item/clothing/under/rank/security/detective/kim

/datum/loadout_item/under/jumpsuit/frontier
	name = "边疆连体服"
	item_path = /obj/item/clothing/under/frontier_colonist

/datum/loadout_item/under/jumpsuit/refit_wetsuit
	name = "改装岸裙潜水服"
	item_path = /obj/item/clothing/under/akula_wetsuit/refit

/datum/loadout_item/under/miscellaneous //This needs to be removed whenever (ifever) loadout datums are actually cleaned.
	abstract_type = /datum/loadout_item/under/miscellaneous

/datum/loadout_item/under/miscellaneous/gear_harness
	name = "装备背带"
	item_path = /obj/item/clothing/under/misc/nova/gear_harness

/datum/loadout_item/under/miscellaneous/giant_scarf
	name = "巨型围巾"
	item_path = /obj/item/clothing/under/dress/nova/giant_scarf
	reskin_datum = /datum/atom_skin/giant_scarf

/datum/loadout_item/under/miscellaneous/playsuit
	name = "连体衣（可重着色）"
	item_path = /obj/item/clothing/under/greyscale/playsuit

/datum/loadout_item/under/jumpsuit/disco
	name = "超级明星警察制服"
	item_path = /obj/item/clothing/under/rank/security/detective/disco

/datum/loadout_item/under/miscellaneous/syndicate_unarmoured_skirt
	name = "可疑战术裙领衫（灰色）"
	item_path = /obj/item/clothing/under/syndicate/unarmoured/skirt

/datum/loadout_item/under/miscellaneous/syndicate_nova_unarmoured_skirt
	name = "可疑战术裙领衫（红色）"
	item_path = /obj/item/clothing/under/syndicate/nova/tactical/unarmoured/skirt

/datum/loadout_item/under/miscellaneous/syndicate_unarmoured
	name = "可疑战术高领衫（灰色）"
	item_path = /obj/item/clothing/under/syndicate/unarmoured

/datum/loadout_item/under/miscellaneous/syndicate_nova_unarmoured
	name = "可疑战术高领衫（红色）"
	item_path = /obj/item/clothing/under/syndicate/nova/tactical/unarmoured

/datum/loadout_item/under/miscellaneous/syndicate_nova_overalls_unarmoured_skirt
	name = "可疑工装裙领衫"
	item_path = /obj/item/clothing/under/syndicate/nova/overalls/unarmoured/skirt

/datum/loadout_item/under/miscellaneous/syndicate_nova_overalls_unarmoured
	name = "可疑工装高领衫"
	item_path = /obj/item/clothing/under/syndicate/nova/overalls/unarmoured

/datum/loadout_item/under/miscellaneous/tactical_pants
	name = "战术长裤"
	item_path = /obj/item/clothing/under/pants/tactical

/datum/loadout_item/under/miscellaneous/taccas
	name = "战术休闲制服"
	item_path = /obj/item/clothing/under/misc/nova/taccas

/datum/loadout_item/under/miscellaneous/tactical_skirt
	name = "战术酷裙领衫"
	item_path = /obj/item/clothing/under/syndicate/tacticool/skirt

/datum/loadout_item/under/miscellaneous/tacticool_turtleneck
	name = "战术酷高领衫"
	item_path = /obj/item/clothing/under/syndicate/tacticool

/*
*	FORMAL UNDERSUITS
*/

/datum/loadout_item/under/formal
	abstract_type = /datum/loadout_item/under/formal
	group = "Formalwear"

/datum/loadout_item/under/formal/assistant
	name = "助手正装制服"
	item_path = /obj/item/clothing/under/misc/assistantformal

/datum/loadout_item/under/formal/amish_suit
	name = "纽扣西装（黑色）"
	item_path = /obj/item/clothing/under/costume/buttondown/slacks/service

/datum/loadout_item/under/formal/blue_suit
	name = "纽扣西装（蓝色）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit

/datum/loadout_item/under/formal/blue_suitskirt
	name = "纽扣西装（蓝色，裙装）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt

/datum/loadout_item/under/formal/recolorable_suit/casual
	name = "纽扣西装 - 有领"
	item_path = /obj/item/clothing/under/suit/nova/recolorable/casual

/datum/loadout_item/under/jumpsuit/hlscientist
	name = "纽扣衬衫 - 科研团队"
	item_path = /obj/item/clothing/under/rank/rnd/scientist/nova/hlscience
	group = "Formalwear" //This datum needs retyping to be /under/formal!

/datum/loadout_item/under/formal/executive_suit
	name = "行政西装"
	item_path = /obj/item/clothing/under/suit/black_really

/datum/loadout_item/under/formal/recolorable_suit/executive
	name = "行政西装（可着色）"
	item_path = /obj/item/clothing/under/suit/nova/recolorable/executive

/datum/loadout_item/under/formal/executive_suit_alt
	name = "行政西装 - 宽领"
	item_path = /obj/item/clothing/under/suit/nova/black_really_collared

/datum/loadout_item/under/formal/executive_skirt
	name = "行政西装裙"
	item_path = /obj/item/clothing/under/suit/black_really/skirt

/datum/loadout_item/under/formal/pencil/black_really
	name = "行政西装裙（可着色，铅笔裙）"
	item_path = /obj/item/clothing/under/suit/nova/pencil/black_really

/datum/loadout_item/under/formal/executive_skirt_alt
	name = "行政西装裙 - 宽领"
	item_path = /obj/item/clothing/under/suit/nova/black_really_collared/skirt

/datum/loadout_item/under/formal/red_gown
	name = "礼服裙"
	item_path = /obj/item/clothing/under/dress/eveninggown

/datum/loadout_item/under/formal/countessdress
	name = "礼服裙 - 女伯爵"
	item_path = /obj/item/clothing/under/dress/nova/countess

/datum/loadout_item/under/formal/formaldressred
	name = "礼服裙 - 深红"
	item_path = /obj/item/clothing/under/dress/nova/redformal

/datum/loadout_item/under/formal/sailor_skirt
	name = "礼服裙 - 水手"
	item_path = /obj/item/clothing/under/dress/sailor

/datum/loadout_item/under/formal/inferno
	name = "地狱火西装"
	item_path = /obj/item/clothing/under/suit/nova/inferno
	reskin_datum = /datum/atom_skin/inferno_suit

/datum/loadout_item/under/formal/inferno_skirt
	name = "地狱火西装裙"
	item_path = /obj/item/clothing/under/suit/nova/inferno/skirt
	reskin_datum = /datum/atom_skin/inferno_suitskirt

/datum/loadout_item/under/formal/black_lawyer_suit
	name = "律师西装（黑色）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black

/datum/loadout_item/under/formal/black_lawyer_skirt
	name = "律师西装（黑色，裙装）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black/skirt

/datum/loadout_item/under/formal/blue_lawyer_suit
	name = "律师西装（蓝色）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue

/datum/loadout_item/under/formal/blue_lawyer_skirt
	name = "律师西装（蓝色，裙装）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue/skirt

/datum/loadout_item/under/formal/red_lawyer_suit
	name = "律师西装（红色）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red

/datum/loadout_item/under/formal/red_lawyer_skirt
	name = "律师西装（红色，裙装）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red/skirt

/datum/loadout_item/under/formal/pencil
	name = "铅笔裙"
	item_path = /obj/item/clothing/under/suit/nova/pencil

/datum/loadout_item/under/formal/pencil/checkered
	name = "铅笔裙（方格纹）" //This is recolorable, put it right after the base type
	item_path = /obj/item/clothing/under/suit/nova/pencil/checkered

/datum/loadout_item/under/formal/pencil/burgandy
	name = "铅笔裙（酒红色）"
	item_path = /obj/item/clothing/under/suit/nova/pencil/burgundy
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/under/formal/pencil/charcoal
	name = "铅笔裙（炭灰色）"
	item_path = /obj/item/clothing/under/suit/nova/pencil/charcoal
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/under/formal/pencil/green
	name = "铅笔裙（绿色）"
	item_path = /obj/item/clothing/under/suit/nova/pencil/green
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/under/formal/pencil/navy
	name = "铅笔裙（海军蓝）"
	item_path = /obj/item/clothing/under/suit/nova/pencil/navy
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/under/formal/pencil/tan
	name = "铅笔裙（棕褐色）"
	item_path = /obj/item/clothing/under/suit/nova/pencil/tan
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/under/formal/pencil/noshirt
	name = "铅笔裙 - 无衬衣"
	item_path = /obj/item/clothing/under/suit/nova/pencil/noshirt

/datum/loadout_item/under/formal/pencil/checkered/noshirt
	name = "铅笔裙 - 无衬衣（方格纹）"
	item_path = /obj/item/clothing/under/suit/nova/pencil/checkered/noshirt

/datum/loadout_item/under/formal/recolorable_suit
	name = "西装（可着色）"
	item_path = /obj/item/clothing/under/suit/nova/recolorable

/datum/loadout_item/under/formal/recolorable_suitskirt
	name = "西装（可着色，裙装）"
	item_path = /obj/item/clothing/under/suit/nova/recolorable/skirt

/datum/loadout_item/under/formal/beige_suit
	name = "西装（米色）"
	item_path = /obj/item/clothing/under/suit/beige

/datum/loadout_item/under/formal/black_suit
	name = "西装（黑色）"
	item_path = /obj/item/clothing/under/suit/black

/datum/loadout_item/under/formal/black_suitskirt
	name = "西装（黑色，裙装）"
	item_path = /obj/item/clothing/under/suit/black/skirt

/datum/loadout_item/under/formal/burgundy_suit
	name = "西装（酒红色）"
	item_path = /obj/item/clothing/under/suit/burgundy

/datum/loadout_item/under/formal/charcoal_suit
	name = "西装（炭灰色）"
	item_path = /obj/item/clothing/under/suit/charcoal

/datum/loadout_item/under/formal/checkered_suit
	name = "西装（方格纹）"
	item_path = /obj/item/clothing/under/suit/checkered

/datum/loadout_item/under/formal/navy_suit
	name = "西装（海军蓝）"
	item_path = /obj/item/clothing/under/suit/navy

/datum/loadout_item/under/formal/purple_suit
	name = "西装（紫色）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit

/datum/loadout_item/under/formal/purple_suitskirt
	name = "西装（紫色，裙装）"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt

/datum/loadout_item/under/formal/sensible_suit
	name = "西装（红色）"
	item_path = /obj/item/clothing/under/rank/civilian/curator

/datum/loadout_item/under/formal/sensible_skirt
	name = "西装（红色，裙装）"
	item_path = /obj/item/clothing/under/rank/civilian/curator/skirt

/datum/loadout_item/under/formal/white_suit
	name = "西装（白色）"
	item_path = /obj/item/clothing/under/suit/white

/datum/loadout_item/under/formal/tuxedo
	name = "燕尾服西装"
	item_path = /obj/item/clothing/under/suit/tuxedo

/datum/loadout_item/under/formal/waiter
	name = "侍者西装"
	item_path = /obj/item/clothing/under/suit/waiter

/datum/loadout_item/under/formal/midnight_gown
	name = "午夜礼服"
	item_path = /obj/item/clothing/under/dress/nova/midnight_gown
	reskin_datum = /datum/atom_skin/midnight_gown

/*
*	erp_item
*/

/datum/loadout_item/under/bunny
	abstract_type = /datum/loadout_item/under/bunny
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/black
	name = "Bunny Suit (Black)"
	item_path = /obj/item/clothing/under/costume/bunnylewd
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/white
	name = "兔女郎装（白色）"
	item_path = /obj/item/clothing/under/costume/bunnylewd/white
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/color
	name = "Bunny Suit (Colorable)"
	item_path = /obj/item/clothing/under/costume/playbunny/greyscale
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/wizard
	name = "Bunny Suit (Magician)"
	item_path = /obj/item/clothing/under/costume/playbunny/magician
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/centcom
	name = "Bunny Suit (Centcom)"
	item_path = /obj/item/clothing/under/costume/playbunny/centcom
	erp_item = TRUE
	group = "Bunny Suits"
	restricted_roles = list(ALL_JOBS_CC)

/datum/loadout_item/under/bunny/brit
	name = "Bunny Suit (British)"
	item_path = /obj/item/clothing/under/costume/playbunny/british
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/ussr
	name = "Bunny Suit (Communist)"
	item_path = /obj/item/clothing/under/costume/playbunny/communist
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/usa
	name = "Bunny Suit (USA)"
	item_path = /obj/item/clothing/under/costume/playbunny/usa
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/tailor
	name = "Bunny Suit (Tailormade)"
	item_path = /obj/item/clothing/under/costume/playbunny/custom_playbunny
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/mailman
	name = "Bunny Suit (Courier)"
	item_path = /obj/item/clothing/under/rank/cargo/mailman_bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/gamer
	name = "Bunny Suit (Gamer)"
	item_path = /obj/item/clothing/under/rank/cargo/bitrunner/bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/prisoner
	name = "Bunny Suit (Prisoner)"
	item_path = /obj/item/clothing/under/rank/security/prisoner_bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/janitor
	name = "Bunny Suit (Janitor)"
	item_path = /obj/item/clothing/under/rank/civilian/janitor/bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/bartender
	name = "Bunny Suit (Bartender)"
	item_path = /obj/item/clothing/under/rank/civilian/bartender_bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/chef
	name = "Bunny Suit (Cook)"
	item_path = /obj/item/clothing/under/rank/civilian/cook_bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/hydro
	name = "Bunny Suit (Botany)"
	item_path = /obj/item/clothing/under/rank/civilian/hydroponics/bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/chaplain
	name = "Bunny Suit (Chaplain)"
	item_path = /obj/item/clothing/under/rank/civilian/chaplain_bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/curatorred
	name = "Bunny Suit (Curator, Red)"
	item_path = /obj/item/clothing/under/rank/civilian/curator_bunnysuit_red
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/curatorgreen
	name = "Bunny Suit (Curator, Green)"
	item_path = /obj/item/clothing/under/rank/civilian/curator_bunnysuit_green
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/curatorteal
	name = "Bunny Suit (Curator, Teal)"
	item_path = /obj/item/clothing/under/rank/civilian/curator_bunnysuit_teal
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/lawyerblack
	name = "Bunny Suit (Lawyer, Black)"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer_bunnysuit_black
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/lawyerblue
	name = "Bunny Suit (Lawyer, Blue)"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer_bunnysuit_blue
	erp_item = TRUE
	group = "Bunny Suits"


/datum/loadout_item/under/bunny/lawyerred
	name = "Bunny Suit (Lawyer, Red)"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer_bunnysuit_red
	erp_item = TRUE
	group = "Bunny Suits"


/datum/loadout_item/under/bunny/lawyergood
	name = "Bunny Suit (Lawyer, Good)"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer_bunnysuit_good
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/bunny/psychologist
	name = "Bunny Suit (Lawyer, Good)"
	item_path = /obj/item/clothing/under/rank/civilian/psychologist_bunnysuit
	erp_item = TRUE
	group = "Bunny Suits"

/datum/loadout_item/under/miscellaneous/latex_catsuit
	name = "乳胶紧身衣"
	item_path = /obj/item/clothing/under/misc/latex_catsuit
	erp_item = TRUE
	group = "Costumes"

/datum/loadout_item/under/miscellaneous/stripper_outfit
	name = "可撕式服装"
	item_path = /obj/item/clothing/under/tearaway_garments
	erp_item = TRUE
	group = "Costumes"
