
///all the corpses meant as mob drops yes, these definitely could be sorted properly. i invite (you) to do it!!

/obj/effect/mob_spawn/corpse/human/syndicatesoldier
	name = "辛迪加行动队"
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	outfit = /datum/outfit/syndicatesoldiercorpse

/datum/outfit/syndicatesoldiercorpse
	name = "辛迪加行动队尸体"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/helmet/swat
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative

/obj/effect/mob_spawn/corpse/human/syndicatecommando
	name = "辛迪加敢死队"
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	outfit = /datum/outfit/syndicatecommandocorpse

/datum/outfit/syndicatecommandocorpse
	name = "辛迪加敢死队尸体"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/mod/control/pre_equipped/nuclear
	r_pocket = /obj/item/tank/internals/emergency_oxygen
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative

/obj/effect/mob_spawn/corpse/human/syndicatecommando/lessenedgear
	outfit = /datum/outfit/syndicatecommandocorpse/lessenedgear

/datum/outfit/syndicatecommandocorpse/lessenedgear
	name = "辛迪加突击队尸体（较少敌对装备）"
	gloves = /obj/item/clothing/gloves/tackler
	back = null
	id = null
	id_trim = null

/obj/effect/mob_spawn/corpse/human/syndicatecommando/soft_suit
	outfit = /datum/outfit/syndicatecommandocorpse/soft_suit

/datum/outfit/syndicatecommandocorpse/soft_suit
	name = "辛迪加突击队尸体（软式太空服）"
	suit = /obj/item/clothing/suit/space/syndicate/black
	head = /obj/item/clothing/head/helmet/space/syndicate/black
	gloves = /obj/item/clothing/gloves/color/black
	back = null
	id = null
	id_trim = null

/obj/effect/mob_spawn/corpse/human/syndicatestormtrooper
	name = "辛迪加突击队"
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	outfit = /datum/outfit/syndicatestormtroopercorpse

/datum/outfit/syndicatestormtroopercorpse
	name = "辛迪加突击队尸体"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/mod/control/pre_equipped/elite
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative

/obj/effect/mob_spawn/corpse/human/syndicatepilot
	name = "辛迪加飞行员"
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	outfit = /datum/outfit/syndicatepilotcorpse

/datum/outfit/syndicatepilotcorpse
	name = "辛迪加飞行员尸体"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/combat
	neck = /obj/item/clothing/neck/large_scarf/syndie
	glasses = /obj/item/clothing/glasses/cold
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/helmet/swat
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative

/obj/effect/mob_spawn/corpse/human/syndicatepilot/lessenedgear
	outfit = /datum/outfit/syndicatepilotcorpse/lessenedgear

/datum/outfit/syndicatepilotcorpse/lessenedgear
	name = "辛迪加飞行员尸体（较少敌对装备）"
	gloves = /obj/item/clothing/gloves/color/black
	id = /obj/item/card/id/advanced/black
	id_trim = /datum/id_trim/syndicom

/obj/effect/mob_spawn/corpse/human/tigercultist
	name = "虎盟邪教徒"
	outfit = /datum/outfit/tigercultcorpse

/datum/outfit/tigercultcorpse
	name = "虎盟尸体"
	uniform = /obj/item/clothing/under/rank/civilian/chaplain
	suit = /obj/item/clothing/suit/hooded/chaplain_hoodie
	shoes = /obj/item/clothing/shoes/laceup
	neck = /obj/item/clothing/neck/fake_heretic_amulet
	head = /obj/item/clothing/head/hooded/chaplain_hood
	back = /obj/item/storage/backpack/cultpack

/obj/effect/mob_spawn/corpse/human/pirate
	name = "海盗"
	skin_tone = "caucasian1" //all pirates are white because it's easier that way
	outfit = /datum/outfit/piratecorpse
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

/datum/outfit/piratecorpse
	name = "海盗尸体"
	uniform = /obj/item/clothing/under/costume/pirate
	shoes = /obj/item/clothing/shoes/jackboots

/obj/effect/mob_spawn/corpse/human/pirate/melee
	name = "海盗剑客"
	outfit = /datum/outfit/piratecorpse/melee

/datum/outfit/piratecorpse/melee
	name = "海盗剑客尸体"
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/costume/pirate/bandana/armored

/obj/effect/mob_spawn/corpse/human/pirate/melee/space
	name = "海盗剑客 - 太空"
	outfit = /datum/outfit/piratecorpse/melee/space

/datum/outfit/piratecorpse/melee/space
	name = "海盗剑客尸体 - 太空"
	suit = /obj/item/clothing/suit/space/pirate
	head = /obj/item/clothing/head/helmet/space/pirate/bandana
	back = /obj/item/tank/jetpack/carbondioxide

/obj/effect/mob_spawn/corpse/human/pirate/ranged
	name = "海盗炮手"
	outfit = /datum/outfit/piratecorpse/ranged

/datum/outfit/piratecorpse/ranged
	name = "海盗炮手尸体"
	glasses = /obj/item/clothing/glasses/eyepatch
	suit = /obj/item/clothing/suit/costume/pirate/armored
	head = /obj/item/clothing/head/costume/pirate/armored

/obj/effect/mob_spawn/corpse/human/pirate/ranged/space
	name = "海盗炮手 - 太空"
	outfit = /datum/outfit/piratecorpse/ranged/space

/datum/outfit/piratecorpse/ranged/space
	name = "海盗炮手尸体 - 太空"
	suit = /obj/item/clothing/suit/space/pirate
	head = /obj/item/clothing/head/helmet/space/pirate
	back = /obj/item/tank/jetpack/carbondioxide

/obj/effect/mob_spawn/corpse/human/old_pirate_captain
	name = "海盗舰长骷髅"
	outfit = /datum/outfit/piratecorpse/captain
	mob_species = /datum/species/skeleton

/datum/outfit/piratecorpse/captain
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/costume/pirate
	suit = /obj/item/clothing/suit/costume/pirate

/obj/effect/mob_spawn/corpse/human/russian
	name = "俄罗斯人"
	outfit = /datum/outfit/russiancorpse
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

/datum/outfit/russiancorpse
	name = "俄罗斯人尸体"
	uniform = /obj/item/clothing/under/costume/soviet
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/costume/bearpelt
	gloves = /obj/item/clothing/gloves/color/black
	mask = /obj/item/clothing/mask/gas



/obj/effect/mob_spawn/corpse/human/russian/ranged
	outfit = /datum/outfit/russiancorpse/ranged

/datum/outfit/russiancorpse/ranged
	name = "远程俄军尸体"
	head = /obj/item/clothing/head/costume/ushanka


/obj/effect/mob_spawn/corpse/human/russian/ranged/trooper
	outfit = /datum/outfit/russiancorpse/ranged/trooper

/datum/outfit/russiancorpse/ranged/trooper
	name = "远程俄军士兵尸体"
	uniform = /obj/item/clothing/under/syndicate/camo
	suit = /obj/item/clothing/suit/armor/bulletproof
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/helmet/alt
	mask = /obj/item/clothing/mask/balaclava


/obj/effect/mob_spawn/corpse/human/russian/ranged/officer
	name = "俄军军官"
	outfit = /datum/outfit/russiancorpse/officer

/datum/outfit/russiancorpse/officer
	name = "俄军军官尸体"
	uniform = /obj/item/clothing/under/costume/russian_officer
	suit = /obj/item/clothing/suit/jacket/officer/tan
	shoes = /obj/item/clothing/shoes/combat
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/costume/ushanka


/obj/effect/mob_spawn/corpse/human/wizard
	name = "Space Wizard Corpse"
	outfit = /datum/outfit/wizardcorpse
	hairstyle = "Bald"
	facial_hairstyle = "Beard (Very Long)"
	facial_haircolor = COLOR_WHITE
	skin_tone = "caucasian1"

/obj/effect/mob_spawn/corpse/human/wizard/red
	outfit = /datum/outfit/wizardcorpse/red

/obj/effect/mob_spawn/corpse/human/wizard/yellow
	outfit = /datum/outfit/wizardcorpse/yellow

/obj/effect/mob_spawn/corpse/human/wizard/black
	outfit = /datum/outfit/wizardcorpse/black

/obj/effect/mob_spawn/corpse/human/wizard/marisa
	outfit = /datum/outfit/wizardcorpse/marisa

/obj/effect/mob_spawn/corpse/human/wizard/tape
	outfit = /datum/outfit/wizardcorpse/tape

/datum/outfit/wizardcorpse
	name = "太空巫师尸体"
	uniform = /obj/item/clothing/under/color/lightpurple
	suit = /obj/item/clothing/suit/wizrobe
	shoes = /obj/item/clothing/shoes/sandal/magic
	head = /obj/item/clothing/head/wizard

/datum/outfit/wizardcorpse/red
	suit = /obj/item/clothing/suit/wizrobe/red
	head = /obj/item/clothing/head/wizard/red

/datum/outfit/wizardcorpse/yellow
	suit = /obj/item/clothing/suit/wizrobe/yellow
	head = /obj/item/clothing/head/wizard/yellow

/datum/outfit/wizardcorpse/black
	suit = /obj/item/clothing/suit/wizrobe/black
	head = /obj/item/clothing/head/wizard/black

/datum/outfit/wizardcorpse/marisa
	suit = /obj/item/clothing/suit/wizrobe/marisa
	head = /obj/item/clothing/head/wizard/marisa
	shoes = /obj/item/clothing/shoes/sneakers/marisa

/datum/outfit/wizardcorpse/tape
	suit = /obj/item/clothing/suit/wizrobe/tape
	head = /obj/item/clothing/head/wizard/tape

/obj/effect/mob_spawn/corpse/human/wizard/dark
	name = "黑暗巫师尸体"
	outfit = /datum/outfit/wizardcorpse/dark

/datum/outfit/wizardcorpse/dark
	head = /obj/item/clothing/head/wizard/hood

/obj/effect/mob_spawn/corpse/human/wizard/paper
	name = "纸页巫师尸体"
	outfit = /datum/outfit/paper_wizard

/datum/outfit/paper_wizard
	name = "纸页巫师"
	uniform = /obj/item/clothing/under/color/white
	suit = /obj/item/clothing/suit/wizrobe/paper
	shoes = /obj/item/clothing/shoes/sandal/magic
	head = /obj/item/clothing/head/collectable/paper

/obj/effect/mob_spawn/corpse/human/nanotrasensoldier
	name = "\improper 纳米传讯私人安全官"
	outfit = /datum/outfit/nanotrasensoldiercorpse
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

/datum/outfit/nanotrasensoldiercorpse
	name = "\improper 纳米传讯私人安全官尸体"
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/security
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/corpse/private_security/tradepost_officer

/obj/effect/mob_spawn/corpse/human/nanotrasenassaultsoldier
	name = "\improper 纳米传讯突击干员尸体"
	outfit = /datum/outfit/nanotrasenassaultsoldiercorpse
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

/datum/outfit/nanotrasenassaultsoldiercorpse
	name = "\improper 纳米传讯突击官尸体"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/security
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/corpse/assault

/obj/effect/mob_spawn/corpse/human/nanotrasenelitesoldier
	name = "\improper 纳米传讯精英突击干员尸体"
	outfit = /datum/outfit/nanotrasenelitesoldiercorpse
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

/datum/outfit/nanotrasenelitesoldiercorpse
	name = "\improper NT精英突击干员尸体"
	uniform = /obj/item/clothing/under/rank/centcom/military
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	back = /obj/item/mod/control/pre_equipped/responsory/security
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/ert/security

/obj/effect/mob_spawn/corpse/human/cat_butcher
	name = "猫医生"
	hairstyle = "Cut Hair"
	facial_hairstyle = "Watson Mustache"
	skin_tone = "caucasian1"
	outfit = /datum/outfit/cat_butcher

/datum/outfit/cat_butcher
	name = "屠猫者制服"
	uniform = /obj/item/clothing/under/rank/medical/scrubs/green
	suit = /obj/item/clothing/suit/apron/surgical
	shoes = /obj/item/clothing/shoes/sneakers/white
	gloves = /obj/item/clothing/gloves/latex/nitrile
	ears = /obj/item/radio/headset
	back = /obj/item/storage/backpack/satchel/med
	id = /obj/item/card/id/advanced
	glasses = /obj/item/clothing/glasses/hud/health
	id_trim = /datum/id_trim/away/cat_surgeon

/obj/effect/mob_spawn/corpse/human/bee_terrorist
	name = "BLF特工"
	outfit = /datum/outfit/bee_terrorist

/datum/outfit/bee_terrorist
	name = "BLF 特工"
	uniform = /obj/item/clothing/under/color/yellow
	suit = /obj/item/clothing/suit/hooded/bee_costume
	shoes = /obj/item/clothing/shoes/sneakers/yellow
	gloves = /obj/item/clothing/gloves/color/yellow
	ears = /obj/item/radio/headset
	belt = /obj/item/storage/belt/fannypack/yellow/bee_terrorist
	id = /obj/item/card/id/advanced
	l_pocket = /obj/item/paper/fluff/bee_objectives
	mask = /obj/item/clothing/mask/animal/small/bee

/obj/effect/mob_spawn/corpse/human/generic_assistant
	name = "通用助手"
	hairstyle = "Short Hair"
	haircolor = COLOR_BLACK
	facial_hairstyle = "Shaved"
	skin_tone = "caucasian1"
	outfit = /datum/outfit/job/assistant/consistent

/obj/effect/mob_spawn/corpse/human/prey_pod
	husk = TRUE
	outfit = /datum/outfit/prey_pod_victim

/datum/outfit/prey_pod_victim
	name = "猎物舱受害者"
	uniform = /obj/item/clothing/under/rank/rnd/roboticist

/obj/effect/mob_spawn/corpse/human/cyber_police
	name = "网络警察尸体"
	outfit = /datum/outfit/cyber_police
