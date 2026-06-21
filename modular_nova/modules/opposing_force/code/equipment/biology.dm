/datum/opposing_force_equipment/language
	category = OPFOR_EQUIPMENT_CATEGORY_LANGUAGE
	item_type = /obj/effect/gibspawner/generic
	/// The language typepath to be given to the mind's language holder
	var/language

/datum/opposing_force_equipment/language/on_issue(mob/living/target)
	target.grant_language(language, source = LANGUAGE_MIND)

/datum/opposing_force_equipment/language/codespeak
	name = "密语语言"
	description = "辛迪加特工可以使用一系列暗语来传递复杂信息，对于窃听者来说，这些暗语听起来像是随机的概念和饮料名称。"
	language = /datum/language/codespeak

/datum/opposing_force_equipment/language/narsie
	name = "纳尔'西安语言"
	description = "纳尔西恩邪教徒古老、浸满鲜血、无比复杂的语言。"
	language = /datum/language/narsie

/datum/opposing_force_equipment/language/piratespeak
	name = "海盗语语言"
	description = "太空海盗的语言。"
	language = /datum/language/piratespeak

/datum/opposing_force_equipment/language/calcic
	name = "钙质语言"
	description = "等离子人那种断断续续、不连贯的语言。骷髅也能理解。"
	language = /datum/language/calcic

/datum/opposing_force_equipment/language/shadowtongue
	name = "暗影语语言"
	description = "多么宏大而令人陶醉的天真。"
	language = /datum/language/shadowtongue

/datum/opposing_force_equipment/language/buzzwords
	name = "流行语语言"
	description = "所有昆虫的通用语言，通过有节奏地拍打翅膀发出。"
	language = /datum/language/buzzwords

/datum/opposing_force_equipment/language/xenocommon
	name = "异形语言"
	description = "异形的通用语言。"
	language = /datum/language/xenocommon

/datum/opposing_force_equipment/language/monkey
	name = "黑猩猩语言"
	description = "Ook ook ook。"
	language = /datum/language/monkey

/datum/opposing_force_equipment/language/nekomimetic
	name = "猫娘语语言"
	description = "在普通观察者听来，这种语言是难以理解的破碎日语混杂体。但对猫人来说，它却莫名其妙地可以理解。"
	language = /datum/language/nekomimetic

/datum/opposing_force_equipment/language/mushroom
	name = "蘑菇语言"
	description = "一种由周期性释放充满孢子的空气所发出的声音构成的语言。"
	language = /datum/language/mushroom

/datum/opposing_force_equipment/language/drone
	name = "无人机语言"
	description = "一种经过高度编码的损害控制协调数据流，并带有特殊的帽子标识。"
	language = /datum/language/drone

/datum/opposing_force_equipment/language/beachbum
	name = "海滩语语言"
	description = "一种来自遥远海滩星球的古老语言。人们在太空药物的影响下会神奇地学会说它。"
	language = /datum/language/beachbum


/datum/opposing_force_equipment/organs
	category = OPFOR_EQUIPMENT_CATEGORY_ORGANS

/datum/opposing_force_equipment/organs/xeno
	name = "异形器官植入套件"
	description = "一个装满了非法获取的异形器官的器官植入套件。"
	admin_note = "Gives the ability to place resin structures, spit acid and melt station structures."
	item_type = /obj/item/storage/organbox/strange
