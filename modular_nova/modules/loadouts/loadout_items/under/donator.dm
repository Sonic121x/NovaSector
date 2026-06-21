/datum/loadout_item/under/jumpsuit/donator
	abstract_type = /datum/loadout_item/under/jumpsuit/donator
	donator_only = TRUE

/datum/loadout_item/under/jumpsuit/donator/enclavesergeant
	name = "英克雷 - 中士"
	item_path = /obj/item/clothing/under/syndicate/nova/enclave
	group = "Costumes"

/datum/loadout_item/under/jumpsuit/donator/enclaveofficer
	name = "英克雷 - 军官"
	item_path = /obj/item/clothing/under/syndicate/nova/enclave/officer
	group = "Costumes"

/datum/loadout_item/under/jumpsuit/donator/blondie
	name = "金发牛仔制服"
	item_path = /obj/item/clothing/under/rank/security/detective/cowboy/armorless
	group = "Costumes"

/datum/loadout_item/under/donator
	abstract_type = /datum/loadout_item/under/donator
	donator_only = TRUE

/datum/loadout_item/under/donator/captain_black
	name = "舰长的黑色制服"
	item_path = /obj/item/clothing/under/rank/captain/nova/black
	restricted_roles = list(JOB_CAPTAIN)
	group = "Job-Locked"
