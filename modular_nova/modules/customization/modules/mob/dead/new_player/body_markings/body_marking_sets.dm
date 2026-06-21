/datum/body_marking_set
	///The preview name of the body marking set. HAS to be unique
	var/name
	///List of the body markings in this set
	var/body_marking_list
	///Which species is this marking recommended to. Important for randomisations.
	var/list/recommended_species = list(
		SPECIES_MAMMAL = TRUE,
		SPECIES_TAJARAN = TRUE,
		SPECIES_VULP = TRUE,
		SPECIES_AQUATIC = TRUE,
		SPECIES_AKULA = TRUE
	)

/datum/body_marking_set/New()
	. = ..()
	if(recommended_species)
		recommended_species = string_assoc_list(recommended_species)

/datum/body_marking_set/none
	name = SPRITE_ACCESSORY_NONE
	recommended_species = null

/datum/body_marking_set/tajaran
	name = "塔亚兰"
	body_marking_list = list("Tajaran")

/datum/body_marking_set/fox
	name = "狐狸"
	body_marking_list = list("Fox", "Fox Sock")

/datum/body_marking_set/sergal
	name = "塞尔加"
	body_marking_list = list("Sergal")

/datum/body_marking_set/husky
	name = "哈士奇"
	body_marking_list = list("Husky")

/datum/body_marking_set/fennec
	name = "耳廓狐"
	body_marking_list = list("Fennec")

/datum/body_marking_set/redpanda
	name = "小熊猫"
	body_marking_list = list("Red Panda", "Red Panda Head")

/datum/body_marking_set/dalmatian
	name = "斑点狗"
	body_marking_list = list("Dalmatian")

/datum/body_marking_set/shepherd
	name = "牧羊犬"
	body_marking_list = list("Shepherd", "Shepherd Spot")

/datum/body_marking_set/wolf
	name = "狼"
	body_marking_list = list("Wolf", "Wolf Spot")

/datum/body_marking_set/raccoon
	name = "浣熊"
	body_marking_list = list("Raccoon")

/datum/body_marking_set/bovine
	name = "牛科"
	body_marking_list = list("Bovine", "Bovine Spot")

/datum/body_marking_set/possum
	name = "负鼠"
	body_marking_list = list("Possum")

/datum/body_marking_set/corgi
	name = "柯基"
	body_marking_list = list("Corgi")

/datum/body_marking_set/skunk
	name = "臭鼬"
	body_marking_list = list("Skunk")

/datum/body_marking_set/panther
	name = "黑豹"
	body_marking_list = list("Panther")

/datum/body_marking_set/tiger
	name = "老虎"
	body_marking_list = list("Tiger Spot", "Tiger Stripe")

/datum/body_marking_set/otter
	name = "水獭"
	body_marking_list = list("Otter", "Otter Head")

/datum/body_marking_set/otie
	name = "奥提"
	body_marking_list = list("Otie", "Otie Spot")

/datum/body_marking_set/sabresune
	name = "Sabresune"
	body_marking_list = list("Sabresune")

/datum/body_marking_set/orca
	name = "Orca"
	body_marking_list = list("Orca")

/datum/body_marking_set/hawk
	name = "Hawk"
	body_marking_list = list("Hawk", "Hawk Talon")

/datum/body_marking_set/corvid
	name = "Corvid"
	body_marking_list = list("Corvid", "Corvid Talon")

/datum/body_marking_set/eevee
	name = "Eevee"
	body_marking_list = list("Eevee")

/datum/body_marking_set/deer
	name = "Deer"
	body_marking_list = list("Deer", "Deer Hoof")

/datum/body_marking_set/hyena
	name = "Hyena"
	body_marking_list = list("Hyena", "Hyena Side")

/datum/body_marking_set/dog
	name = "Dog"
	body_marking_list = list("Dog", "Dog Spot")

/datum/body_marking_set/bat
	name = "Bat"
	body_marking_list = list("Bat Mark", "Bat")

/datum/body_marking_set/goat
	name = "Goat"
	body_marking_list = list("Goat Hoof")

/datum/body_marking_set/floof
	name = "Floof"
	body_marking_list = list("Floof")

/datum/body_marking_set/floofer
	name = "Floofer"
	body_marking_list = list("Floof", "Floofer Sock")

/datum/body_marking_set/rat
	name = "Rat"
	body_marking_list = list("Rat Paw", "Rat Spot")

/datum/body_marking_set/sloth
	name = "Sloth"
	body_marking_list = list("Rat Paw", "Sloth Head") //Yes we're re-using the rat bits as they'd be identical

/datum/body_marking_set/scolipede
	name = "Scolipede"
	body_marking_list = list("Scolipede", "Scolipede Spikes")

/datum/body_marking_set/guilmon
	name = "Guilmon"
	body_marking_list = list("Guilmon", "Guilmon Mark")

/datum/body_marking_set/xeno
	name = "Xeno"
	body_marking_list = list("Xeno", "Xeno Head")

/datum/body_marking_set/datashark
	name = "Datashark"
	body_marking_list = list("Datashark")

/datum/body_marking_set/shark
	name = "Shark"
	body_marking_list = list("Shark")

/datum/body_marking_set/belly
	name = "Belly"
	body_marking_list = list("Belly")

/datum/body_marking_set/belly_slim
	name = "腹部细纹"
	body_marking_list = list("Belly Slim")

/datum/body_marking_set/hands_feet
	name = "手足纹"
	body_marking_list = list("Hands Feet")

/datum/body_marking_set/frog
	name = "蛙纹"
	body_marking_list = list("Frog")

/datum/body_marking_set/bee
	name = "蜂纹"
	body_marking_list = list("Bee")

/datum/body_marking_set/gradient
	name = "渐变"
	body_marking_list = list("Gradient")

/datum/body_marking_set/harlequin
	name = "杂色"
	body_marking_list = list("Harlequin")

/datum/body_marking_set/harlequin_reversed
	name = "反向杂色"
	body_marking_list = list("Harlequin Reversed")

/datum/body_marking_set/plain
	name = "素色"
	body_marking_list = list("Plain")

/datum/body_marking_set/splotches
	name = "斑驳"
	body_marking_list = list("Splotches")

/datum/body_marking_set/chitin
	name = "甲壳纹"
	body_marking_list = list("Chitin")

//AKULA MARKINGS
/datum/body_marking_set/akula
	recommended_species = list(SPECIES_AKULA = 1)

/datum/body_marking_set/akula/akula
	name = "阿库拉纹"
	body_marking_list = list("Akula", "Akula Highlight")

//VOX MARKINGS
/datum/body_marking_set/vox
	recommended_species = list(SPECIES_VOX = 1)

/datum/body_marking_set/vox/vox
	name = "沃克斯纹"
	body_marking_list = list("Vox Talon")

/datum/body_marking_set/vox/vox_tiger
	name = "沃克斯虎纹"
	body_marking_list = list("Vox Talon", "Vox Tiger Tattoo")

/datum/body_marking_set/vox/vox_hive
	name = "沃克斯蜂巢纹"
	body_marking_list = list("Vox Talon", "Vox Hive Tattoo")

/datum/body_marking_set/vox/vox_nightling
	name = "沃克斯夜灵纹"
	body_marking_list = list("Vox Talon", "Vox Nightling Tattoo")

/datum/body_marking_set/vox/vox_heart
	name = "沃克斯心形纹"
	body_marking_list = list("Vox Talon", "Vox Heart Tattoo")

/datum/body_marking_set/synthliz
	recommended_species = list(SPECIES_SYNTH = 1)

/datum/body_marking_set/synthliz/scutes
	name = "合成鳞甲纹"
	body_marking_list = list("Synth Scutes")

/datum/body_marking_set/synthliz/pecs
	name = "合成胸甲纹"
	body_marking_list = list("Synth Pecs")

/datum/body_marking_set/synthliz/pecs_light
	name = "合成胸甲光纹"
	body_marking_list = list("Synth Pecs", "Synth Collar Lights")

//MOTH

/datum/body_marking_set/moth
	recommended_species = list(SPECIES_MOTH = 1)

/datum/body_marking_set/moth/reddish
	name = "微红"
	body_marking_list = list("Reddish")

/datum/body_marking_set/moth/royal
	name = "皇家"
	body_marking_list = list("Royal")

/datum/body_marking_set/moth/gothic
	name = "哥特"
	body_marking_list = list("Gothic")

/datum/body_marking_set/moth/whitefly
	name = "白蝇"
	body_marking_list = list("Whitefly")

/datum/body_marking_set/moth/burnt_off
	name = "烧蚀"
	body_marking_list = list("Burnt Off")

/datum/body_marking_set/moth/deathhead
	name = "死亡头"
	body_marking_list = list("Deathhead")

/datum/body_marking_set/moth/poison
	name = "毒物"
	body_marking_list = list("Poison")

/datum/body_marking_set/moth/ragged
	name = "褴褛"
	body_marking_list = list("Ragged")

/datum/body_marking_set/moth/moonfly
	name = "月蝇"
	body_marking_list = list("Moonfly")

/datum/body_marking_set/moth/oakworm
	name = "橡木虫"
	body_marking_list = list("Oakworm")

/datum/body_marking_set/moth/jungle
	name = "丛林"
	body_marking_list = list("Jungle")

/datum/body_marking_set/moth/witchwing
	name = "巫翼"
	body_marking_list = list("Witchwing")

/datum/body_marking_set/moth/lovers
	name = "恋人"
	body_marking_list = list("Lovers")

/datum/body_marking_set/moth/lightbearer
	name = "持光者"
	body_marking_list = list("Lightbearer")
