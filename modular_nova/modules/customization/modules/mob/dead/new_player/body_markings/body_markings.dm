//This datum is quite close to the sprite accessory one, containing a bit of copy pasta code
//Those DO NOT have a customizable cases for rendering, or any special stuff, and are meant to be simpler than accessories
//One definition can stand for a whole set of accessories, make sure to set affected bodyparts
/datum/body_marking
	///The icon file the body markign is located in
	var/icon
	///The icon_state of the body marking
	var/icon_state
	///The preview name of the body marking. NEEDS A UNIQUE NAME
	var/name
	///The color the marking defaults to, important for randomisations. either a hex color ie."#FFFFFF" or a define like DEFAULT_PRIMARY
	var/default_color
	///Which bodyparts does the marking affect in BITFLAGS!! (HEAD, CHEST, ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT, LEG_RIGHT, LEG_LEFT)
	var/affected_bodyparts
	///Which species is this marking recommended to. Important for randomisations.
	var/list/recommended_species = list(SPECIES_MAMMAL = TRUE)
	///If this is on the color customization will show up despite the pref settings, it will also cause the marking to not reset colors to match the defaults
	var/always_color_customizable
	///Whether the body marking sprite is the same for both sexes or not. Only relevant for chest right now.
	var/gendered = TRUE

/datum/body_marking/New()
	if(!default_color)
		default_color = "#FFFFFF"
	if(recommended_species)
		recommended_species = string_assoc_list(recommended_species)

/datum/body_marking/proc/get_default_color(list/features, datum/species/species) //Needs features for the color information
	var/list/colors
	switch(default_color)
		if(DEFAULT_PRIMARY)
			colors = features[FEATURE_MUTANT_COLOR]
		if(DEFAULT_SECONDARY)
			colors = features[FEATURE_MUTANT_COLOR_TWO]
		if(DEFAULT_TERTIARY)
			colors = features[FEATURE_MUTANT_COLOR_THREE]
		if(DEFAULT_SKIN_OR_PRIMARY)
			if(species && !(TRAIT_USES_SKINTONES in species.inherent_traits))
				colors = features[FEATURE_SKIN_COLOR]
			else
				colors = features[FEATURE_MUTANT_COLOR]
		else
			colors = default_color

	return colors

//Use this one for things with pre-set default colors, I guess
/datum/body_marking/other
	icon = 'modular_nova/master_files/icons/mob/body_markings/other_markings.dmi'
	recommended_species = null

/datum/body_marking/other/eyebags
	name = "Eye Bags"
	icon = 'icons/mob/human/species/misc/bodypart_overlay_simple.dmi'
	icon_state = "bags"
	default_color = "#484848"
	affected_bodyparts = HEAD

/datum/body_marking/other/drake_bone
	name = "龙骸骨"
	icon_state = "drakebone"
	default_color = "#CCCCCC"
	affected_bodyparts = CHEST | HAND_LEFT | HAND_RIGHT
	gendered = FALSE

/datum/body_marking/other/tonage
	name = "身体色调"
	icon_state = "tonage"
	default_color = "#555555"
	affected_bodyparts = CHEST
	gendered = FALSE

/datum/body_marking/other/belly_slim_toned
	name = "纤腹（变体）+ 色调"
	icon_state = "bellyslimtoned"
	default_color = "#555555"
	affected_bodyparts = CHEST
	gendered = FALSE

/datum/body_marking/other/flushed_cheeks
	name = "红润脸颊"
	icon_state = "flushed_cheeks"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/cyclops
	name = "独眼巨人眼"
	icon_state = "cyclops"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/blank_face
	name = "空白圆脸（与怪物嘴部搭配使用）"
	icon_state = "blankface"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/blank_face2
	name = "空白圆脸，变体"
	icon_state = "blankface2"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/blank_face3
	name = "Blank Round Face, Flat"
	icon_state = "blankface3"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/monster_mouth
	name = "怪物嘴"
	icon_state = "monster"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/monster_mouth_white
	name = "怪物嘴（白色）"
	icon_state = "monster_white"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/monster_mouth_white2
	name = "怪物嘴（白色，兼容眼部）"
	icon_state = "monster_white2"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD
//you're welcome -- iska

/datum/body_marking/other/monster_mouth2
	name = "怪物嘴 2"
	icon_state = "monster2"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/nose_blemish
	name = "鼻部瑕疵"
	icon_state = "nose_blemish"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/brows
	name = "眉部"
	icon_state = "brows"
	affected_bodyparts = HEAD

/datum/body_marking/other/ears
	name = "耳部"
	icon_state = "ears"
	affected_bodyparts = HEAD

/datum/body_marking/other/insect_antennae
	name = "昆虫触角"
	icon_state = "insect_antennae"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/eyeliner
	name = "眼线"
	icon_state = "eyeliner"
	affected_bodyparts = HEAD

/datum/body_marking/other/clowncross
	name = "Clown Cross"
	icon_state = "clowncross"
	default_color = "#FFFF00"
	affected_bodyparts = HEAD

/datum/body_marking/other/clownlips
	name = "Clown Lips"
	icon_state = "clownlips"
	default_color = "#FF0033"
	affected_bodyparts = HEAD

/datum/body_marking/other/topscars
	name = "胸部手术疤痕"
	icon_state = "topscars"
	affected_bodyparts = CHEST

/datum/body_marking/other/weight
	name = "身体重量"
	icon_state = "weight"
	default_color = DEFAULT_PRIMARY
	affected_bodyparts = CHEST

/datum/body_marking/other/weight2
	name = "身体重量（灰阶）"
	icon_state = "weight2"
	default_color = DEFAULT_PRIMARY
	affected_bodyparts = CHEST

/datum/body_marking/other/pilot
	name = "飞行员"
	icon_state = "pilot"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT

/datum/body_marking/other/pilot_jaw
	name = "飞行员下颌"
	icon_state = "pilot_jaw"
	default_color = "#CCCCCC"
	affected_bodyparts = HEAD

/datum/body_marking/other/drake_eyes
	name = "龙眼"
	icon_state = "drakeeyes"
	default_color = "#FF0000"
	affected_bodyparts = HEAD
	always_color_customizable = TRUE

/datum/body_marking/other/big_ol_eyes
	name = "大眼睛"
	icon_state = "bigoleyes"
	default_color = "#FF0000"
	affected_bodyparts = HEAD
	always_color_customizable = TRUE

/datum/body_marking/other/three_eyes
	name = "三只眼"
	icon_state = "3eyes"
	default_color = "#FF0000"
	affected_bodyparts = HEAD
	always_color_customizable = TRUE

/datum/body_marking/other/four_eyes
	name = "四只眼"
	icon_state = "4eyes"
	default_color = "#FF0000"
	affected_bodyparts = HEAD
	always_color_customizable = TRUE

/datum/body_marking/other/sclera
	name = "巩膜"
	icon_state = "sclera"
	default_color = "#FF0000"
	affected_bodyparts = HEAD
	always_color_customizable = TRUE

/datum/body_marking/other/anime_inner
	name = "动漫眼（内部）"
	icon_state = "anime_inner"
	default_color = "#FF0000"
	affected_bodyparts = HEAD
	always_color_customizable = TRUE

/datum/body_marking/other/anime_outer
	name = "动漫眼（外圈）"
	icon_state = "anime_outer"
	default_color = "#FF0000"
	affected_bodyparts = HEAD
	always_color_customizable = TRUE

/datum/body_marking/other/claws
	name = "爪尖"
	icon_state = "claws"
	affected_bodyparts = HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT
	gendered = FALSE

/datum/body_marking/other/harpy_upper
	name = "哈比鸟人上腿部"
	icon_state = "harpy_upper"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT
	gendered = FALSE

/datum/body_marking/other/harpy_lower
	name = "哈比鸟人下腿部"
	icon_state = "harpy_lower"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT
	gendered = FALSE

/datum/body_marking/other/harpy_claws
	name = "哈比鸟人利爪"
	icon_state = "harpy_claws"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT
	gendered = FALSE

/datum/body_marking/other/critter_legs
	name = "小动物腿部"
	icon_state = "critterleg"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT
	gendered = FALSE


/datum/body_marking/other/splotches
	name = "色斑"
	icon_state = "splotches"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/splotcheswap
	name = "色斑（交换）"
	icon_state = "splotcheswap"
	affected_bodyparts = HEAD

/datum/body_marking/other/bands
	name = "色带"
	icon_state = "bands"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/chitin
	name = "几丁质"
	icon_state = "chitin"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/bands_foot
	name = "色带（足部）"
	icon_state = "bands_foot"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/anklet
	name = "脚镯"
	icon_state = "anklet"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/legband
	name = "腿环"
	icon_state = "legband"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/protogenlegs
	name = "原型机腿部 - 趾行式"
	icon_state = "protogen"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/protogenarms
	name = "原型机手臂"
	icon_state = "protogen"
	affected_bodyparts = ARM_RIGHT | ARM_LEFT

/datum/body_marking/other/protogenchest
	name = "原型机胸部"
	icon_state = "protogen"
	affected_bodyparts = CHEST

/datum/body_marking/other/jackal_fur
	name = "豺狼背部皮毛"
	icon_state = "jackalfur"
	affected_bodyparts = CHEST | ARM_RIGHT | ARM_LEFT
	gendered = FALSE

/datum/body_marking/other/jackal_back
	name = "豺狼背部皮毛点缀"
	icon_state = "jackalback"
	affected_bodyparts = CHEST | ARM_RIGHT | ARM_LEFT
	gendered = FALSE

/datum/body_marking/other/sixnips
	name = "六点乳首"
	icon_state = "nips"
	affected_bodyparts = CHEST
	gendered = FALSE

/datum/body_marking/other/chemlight
	name = "条带与条纹"
	icon_state = "chemlight"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/other/back_stripe
	name = "背部条纹"
	icon_state = "backstripe"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary
	icon = 'modular_nova/master_files/icons/mob/body_markings/secondary_markings.dmi'
	default_color = DEFAULT_SECONDARY

/datum/body_marking/secondary/teshari
	name = "特莎瑞"
	icon_state = "teshari"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT

/datum/body_marking/secondary/teshari_plain
	name = "特莎瑞平原"
	icon_state = "teshari_plain"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/teshari_coat
	name = "特莎瑞毛皮"
	icon_state = "teshari_coat"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/teshari_underfluff
	name = "特莎瑞底绒"
	icon_state = "teshari_underfluff"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = HEAD | CHEST | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/teshari_short
	name = "特莎瑞短毛"
	icon_state = "teshari_short"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/teshari_feathers_male
	name = "特莎瑞羽毛（雄性）"
	icon_state = "teshari_feathers_male"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/teshari_feathers_female
	name = "特莎瑞羽毛（雌性）"
	icon_state = "teshari_feathers_female"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/teshari_lashes
	name = "特莎瑞睫毛"
	icon_state = "teshari_lashes"
	recommended_species = list(SPECIES_TESHARI = 1)
	affected_bodyparts = HEAD

/datum/body_marking/secondary/tajaran
	name = "塔亚兰"
	icon_state = "tajaran"
	affected_bodyparts = HEAD | CHEST //The legs were literally one pixel so I removed them

/datum/body_marking/secondary/sergal
	name = "塞尔加尔"
	icon_state = "sergal"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/husky
	name = "哈士奇"
	icon_state = "husky"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/fennec
	name = "耳廓狐"
	icon_state = "fennec"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/redpanda
	name = "小熊猫"
	icon_state = "redpanda"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/dalmatian
	name = "斑点狗"
	icon_state = "dalmation"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/shepherd
	name = "牧羊犬"
	icon_state = "shepherd"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/wolf
	name = "狼"
	icon_state = "wolf"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/fox
	name = "狐狸"
	icon_state = "fox"
	affected_bodyparts = HEAD | CHEST | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/raccoon
	name = "浣熊"
	icon_state = "raccoon"
	affected_bodyparts = HEAD | CHEST | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/bovine
	name = "牛科"
	icon_state = "bovine"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/possum
	name = "负鼠"
	icon_state = "possum"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/corgi
	name = "柯基"
	icon_state = "corgi"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/leopard1
	name = "豹纹"
	icon_state = "leopard1"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/leopard2
	name = "豹纹（变体）"
	icon_state = "leopard2"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/skunk
	name = "臭鼬"
	icon_state = "skunk"
	affected_bodyparts = HEAD | CHEST | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/panther
	name = "黑豹"
	icon_state = "panther"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/tiger
	name = "虎斑"
	icon_state = "tiger"
	affected_bodyparts = HEAD | CHEST | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/otter
	name = "水獭"
	icon_state = "otter"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/otie
	name = "奥提"
	icon_state = "otie"
	affected_bodyparts = HEAD | CHEST | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/sabresune
	name = "剑狲"
	icon_state = "sabresune"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/orca
	name = "虎鲸"
	icon_state = "orca"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/hawk
	name = "鹰"
	icon_state = "hawk"
	affected_bodyparts = HEAD | CHEST | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/corvid
	name = "鸦科"
	icon_state = "corvid"
	affected_bodyparts = HEAD | CHEST | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/eevee
	name = "伊布"
	icon_state = "eevee"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/shark
	name = "鲨鱼"
	icon_state = "shark"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/deer
	name = "鹿"
	icon_state = "deer"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/hyena
	name = "鬣狗"
	icon_state = "hyena"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/dog
	name = "犬"
	icon_state = "dog"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/bat
	name = "蝙蝠"
	icon_state = "bat"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/floof
	name = "绒毛"
	icon_state = "floof"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/secondary/rat
	name = "鼠爪"
	icon_state = "rat"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/scolipede
	name = "蜈蚣王"
	icon_state = "scolipede"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/guilmon
	name = "基尔兽"
	icon_state = "guilmon"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/xeno
	name = "异形"
	icon_state = "xeno"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT
	recommended_species = list(SPECIES_XENO = 1)

/datum/body_marking/secondary/datashark
	name = "数据鲨"
	icon_state = "datashark"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/belly
	name = "腹部"
	icon_state = "belly"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/bellyslim
	name = "纤细腹部"
	icon_state = "bellyslim"
	affected_bodyparts = HEAD | CHEST | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/bellyslimalt
	name = "纤细腹部（变体）"
	icon_state = "bellyslim_alt"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/bellyandbutt
	name = "腹部与臀部"
	icon_state = "bellyandbutt"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/butt
	name = "臀部"
	icon_state = "butt"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/handsfeet
	name = "手足"
	icon_state = "handsfeet"
	affected_bodyparts = HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/frog
	name = "蛙类"
	icon_state = "frog"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/bee
	name = "蜂类"
	icon_state = "bee"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/gradient
	name = "渐变"
	icon_state = "gradient"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/harlequin
	name = "小丑"
	icon_state = "harlequin"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | HAND_LEFT | LEG_LEFT

/datum/body_marking/secondary/harlequin_reversed
	name = "小丑（反向）"
	icon_state = "harlequin_reversed"
	affected_bodyparts = HEAD | CHEST | ARM_RIGHT | HAND_RIGHT | LEG_RIGHT

/datum/body_marking/secondary/plain
	name = "素色"
	icon_state = "plain"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/upper_limb
	name = "上肢"
	icon_state = "upper_limb"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/lower_limb
	name = "下肢"
	icon_state = "lower_limb"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/secondary/insectoid
	name = "昆虫型"
	icon_state = "insect"
	affected_bodyparts = CHEST

/datum/body_marking/secondary/bellyoutline
	name = "腹部轮廓"
	icon_state = "chembelly_trim"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary
	icon = 'modular_nova/master_files/icons/mob/body_markings/tertiary_markings.dmi'
	default_color = DEFAULT_TERTIARY

/datum/body_marking/tertiary/redpanda
	name = "小熊猫头部"
	icon_state = "redpanda"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/shepherd
	name = "牧羊犬斑点"
	icon_state = "shepherd"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/tertiary/wolf
	name = "狼斑点"
	icon_state = "wolf"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/fox
	name = "狐狸袜套"
	icon_state = "fox"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/goat
	name = "山羊蹄"
	icon_state = "goat"
	affected_bodyparts = HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/raccoon
	name = "浣熊斑点"
	icon_state = "raccoon"
	affected_bodyparts = HEAD | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/bovine
	name = "牛斑点"
	icon_state = "bovine"
	affected_bodyparts = HEAD | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/possum
	name = "负鼠袜套"
	icon_state = "possum"
	affected_bodyparts = HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/tiger
	name = "虎纹"
	icon_state = "tiger"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/otter
	name = "水獭头部"
	icon_state = "otter"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/otie
	name = "奥提斑点"
	icon_state = "otie"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/hawk
	name = "鹰爪"
	icon_state = "hawk"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/corvid
	name = "鸦爪"
	icon_state = "corvid"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/deer
	name = "鹿蹄"
	icon_state = "deer"
	affected_bodyparts = HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/hyena
	name = "鬣狗侧纹"
	icon_state = "hyena"
	affected_bodyparts = HEAD | CHEST

/datum/body_marking/tertiary/dog
	name = "狗斑点"
	icon_state = "dog"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/bat
	name = "蝙蝠标记"
	icon_state = "bat"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/floofer
	name = "绒毛袜套"
	icon_state = "floofer"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT | HAND_LEFT | HAND_RIGHT

/datum/body_marking/tertiary/rat
	name = "鼠斑点"
	icon_state = "rat"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/sloth
	name = "树懒头部"
	icon_state = "sloth"
	affected_bodyparts = HEAD

/datum/body_marking/tertiary/scolipede
	name = "蜈蚣王尖刺"
	icon_state = "scolipede"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/guilmon
	name = "基尔兽印记"
	icon_state = "guilmon"
	affected_bodyparts = HEAD | CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/xeno
	name = "异形头部"
	icon_state = "xeno"
	affected_bodyparts = HEAD
	recommended_species = list(SPECIES_XENO = 1)

/datum/body_marking/tertiary/dtiger
	name = "暗色虎纹身体"
	icon_state = "dtiger"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/ltiger
	name = "亮色虎纹身体"
	icon_state = "ltiger"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/lbelly
	name = "浅色腹部"
	icon_state = "lbelly"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/insectoid
	name = "昆虫状饰边"
	icon_state = "insect_trim"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | LEG_LEFT | LEG_RIGHT

/datum/body_marking/tertiary/chemlight
	name = "环带与条纹（变体）"
	icon_state = "chem_light"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tattoo
	icon = 'modular_nova/master_files/icons/mob/body_markings/tattoo_markings.dmi'
	recommended_species = null
	default_color = "#112222" //slightly faded ink.
	always_color_customizable = 1
	gendered = FALSE

/datum/body_marking/tattoo/heart
	name = "纹身 - 心形"
	icon_state = "tat_heart"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT

/datum/body_marking/tattoo/heart_groin
	name = "纹身 - 心形（腹股沟）"
	icon_state = "tat_heart_groin"
	affected_bodyparts = CHEST

/datum/body_marking/tattoo/hive
	name = "纹身 - 蜂巢"
	icon_state = "tat_hive"
	affected_bodyparts = CHEST
	gendered = TRUE

/datum/body_marking/tattoo/nightling
	name = "纹身 - 夜灵"
	icon_state = "tat_nightling"
	affected_bodyparts = CHEST

/datum/body_marking/tattoo/circuit
	name = "纹身 - 电路"
	icon_state = "tat_campbell"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tattoo/silverburgh //dunno what this is.
	name = "纹身 - 银堡"
	icon_state = "tat_silverburgh"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/tattoo/tiger
	name = "纹身 - 虎纹"
	icon_state = "tat_tiger"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT
	gendered = TRUE

/datum/body_marking/tattoo/tiger_groin
	name = "纹身 - 虎纹（腹股沟）"
	icon_state = "tat_tiger_groin"
	affected_bodyparts = CHEST

/datum/body_marking/tattoo/tiger_foot
	name = "纹身 - 虎纹（足部）"
	icon_state = "tat_tiger_foot"
	affected_bodyparts = LEG_RIGHT | LEG_LEFT

/datum/body_marking/tattoo/infinity
	name = "纹身 - 无限"
	icon_state = "tat_infinity"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tattoo/butterfly
	name = "纹身 - 蝴蝶"
	icon_state = "tat_butterfly"
	affected_bodyparts = CHEST
