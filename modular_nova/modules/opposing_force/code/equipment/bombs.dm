/datum/opposing_force_equipment/bomb_chemical
	category = OPFOR_EQUIPMENT_CATEGORY_BOMB_CHEM

/datum/opposing_force_equipment/bomb_chemical/c4
	item_type = /obj/item/grenade/c4
	description = "一块塑胶炸药，用于炸开墙壁、门，或者必要时炸人。"

/datum/opposing_force_equipment/bomb_chemical/x4
	item_type = /obj/item/grenade/c4/x4
	description = "与C4类似，但爆炸威力更强，且是定向而非圆形爆炸。"

/datum/opposing_force_equipment/bomb_chemical/minibomb
	name = "辛迪加微型炸弹"
	item_type = /obj/item/grenade/syndieminibomb
	description = "迷你炸弹是一枚五秒引信的手榴弹。引爆时，除了对附近人员造成高额伤害外，还会造成一个小型船体破口。"

/datum/opposing_force_equipment/bomb_chemical/minibomb_cluster
	name = "辛迪加微型炸弹集束手雷"
	admin_note = "Devastating payload, equal explosion size to the average command bridge."
	item_type = /obj/item/grenade/clusterbuster/syndieminibomb

/datum/opposing_force_equipment/bomb_chemical/fragnade
	item_type = /obj/item/grenade/frag
	description = "一枚破片手榴弹，引爆后会释放弹片，造成最大程度的伤害。"

/datum/opposing_force_equipment/bomb_chemical/fire
	name = "燃烧手雷"
	admin_note = "Very mid despite having a scary name."
	item_type = /obj/item/grenade/chem_grenade/incendiary

/datum/opposing_force_equipment/bomb_chemical/fire_cluster
	name = "燃烧集束手雷"
	admin_note = "Room-filling plasmafire that lasts for about 10 seconds."
	item_type = /obj/item/grenade/clusterbuster/inferno

/datum/opposing_force_equipment/bomb_chemical/clf3
	name = "三氟化物手雷"
	admin_note = "In most cases you want to refer the player to the 'incendiary grenade' instead. This grenade has a huge scale, and spaces non-floored tiles."
	item_type = /obj/item/grenade/chem_grenade/clf3
/*
/datum/opposing_force_equipment/bomb_chemical/clf3_cluster //this fucking thing deletes your station
	name = "Trifluoride Cluster-Grenade"
	admin_note = ""
	item_type = /obj/item/grenade/clusterbuster/clf3
*/
/datum/opposing_force_equipment/bomb_chemical/facid
	name = "酸液手雷"
	admin_note = "This thing will remove most player's clothing."
	item_type = /obj/item/grenade/chem_grenade/facid
/*
/datum/opposing_force_equipment/bomb_chemical/facid_cluster //massive collateral. only uncomment if you're OK with all of crew becoming nude
	name = "Acid Cluster-Grenade"
	item_type = /obj/item/grenade/clusterbuster/facid
*/
/datum/opposing_force_equipment/bomb_chemical/radnade
	item_type = /obj/item/grenade/gluon
	description = "一种原型手榴弹，能冻结目标区域并释放致命的辐射波。"

/datum/opposing_force_equipment/bomb_chemical/henade
	item_type = /obj/item/grenade/syndieminibomb/concussion
	description = "一种旨在击晕和制服敌人的手榴弹。仍然相当具有爆炸性。"

/datum/opposing_force_equipment/bomb_chemical/anti_grav
	name = "反重力手榴弹"
	item_type = /obj/item/grenade/antigravity

/datum/opposing_force_equipment/bomb_chemical/emp
	name = "EMP手榴弹"
	item_type = /obj/item/grenade/empgrenade

/datum/opposing_force_equipment/bomb_chemical/flashbang
	name = "闪光弹"
	item_type = /obj/item/grenade/flashbang
	description = "一枚闪光震撼弹，可用于非致命性地制服人群。"

/datum/opposing_force_equipment/bomb_chemical/smoke
	name = "烟雾弹"
	item_type = /obj/item/grenade/smokebomb

/datum/opposing_force_equipment/bomb_chemical/soap
	name = "肥皂集束手榴弹"
	item_type = /obj/item/grenade/clusterbuster/soap

/datum/opposing_force_equipment/bomb_chemical/moustache
	name = "催泪胡子手榴弹"
	item_type = /obj/item/grenade/chem_grenade/teargas/moustache
	admin_note = "Puts mustaches on their victims that last for ten minutes."

/datum/opposing_force_equipment/bomb_chemical/carp
	name = "鲤鱼手榴弹"
	item_type = /obj/item/grenade/spawnergrenade/spesscarp

/datum/opposing_force_equipment/bomb_chemical/carp_cluster
	name = "鲤鱼集束手榴弹"
	item_type = /obj/item/grenade/clusterbuster/spawner_spesscarp

/datum/opposing_force_equipment/bomb_chemical/viscerator
	name = "内脏切割机投送手榴弹"
	item_type = /obj/item/grenade/spawnergrenade/manhacks
	description = "一种独特的手榴弹，激活后会部署一群切割者，它们会追捕并撕碎该区域内所有非特工人员。"

/datum/opposing_force_equipment/bomb_chemical/viscerator_cluster
	name = "内脏切割机投送集束手榴弹"
	item_type = /obj/item/grenade/clusterbuster/spawner_manhacks

/datum/opposing_force_equipment/bomb_chemical/nukedelivery
	name = "核弹投送手榴弹"
	item_type = /obj/item/grenade/spawnergrenade/therealnuke
	description = "一枚非常令人困惑的手榴弹，内含2名脱水的核弹特工。引爆时请退后。"

/datum/opposing_force_equipment/bomb_chemical/buzzkill
	name = "扫兴手榴弹"
	item_type = /obj/item/grenade/spawnergrenade/buzzkill
	description = "一枚激活后会释放一群愤怒蜜蜂的手榴弹。这些蜜蜂会无差别地用随机毒素攻击友军或敌人。由BLF和老虎合作社提供。"
	admin_note = "WARNING: The bee's from this grenade can have almost anything chem-wise into them, and just a few can make a massive swarm of bees(10 bees per!!)"

/datum/opposing_force_equipment/bomb_chemical/pizza
	name = "披萨炸弹"
	item_type = /obj/item/pizzabox/bomb
	description = "一个披萨盒，盒盖上巧妙地附着一枚炸弹。计时器需要通过打开盒子来设置；之后，在计时结束后再次打开盒子将触发爆炸。附赠免费披萨，供你或你的目标享用！"

/datum/opposing_force_equipment/bomb_payload
	category = OPFOR_EQUIPMENT_CATEGORY_BOMB_PAYLOAD

/datum/opposing_force_equipment/bomb_payload/syndicate
	name = "辛迪加炸弹"
	item_type = /obj/item/sbeacondrop/bomb
	description = "一个大型、威力强大的炸弹，可以用扳手固定并设置可变计时器来武装。"
	admin_note = "WARNING: This is a pretty big bomb, it can take out entire rooms."

/datum/opposing_force_equipment/bomb_payload/syndicate_emp
	name = "辛迪加EMP炸弹"
	item_type = /obj/item/sbeacondrop/emp
	description = "辛迪加炸弹的改良版本，会释放一个大型电磁脉冲。"

/datum/opposing_force_equipment/bomb_payload/syndicate_sink
	name = "辛迪加电力虹吸器"
	item_type = /obj/item/sbeacondrop/powersink

/datum/opposing_force_equipment/bomb_payload/syndicate_clown_bomb
	name = "辛迪加小丑炸弹"
	item_type = /obj/item/sbeacondrop/clownbomb
	admin_note = "Does not deal any damage, just spawns twenty passive simplemob clowns."
