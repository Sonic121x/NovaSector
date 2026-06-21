/datum/opposing_force_equipment/implants
	category = OPFOR_EQUIPMENT_CATEGORY_IMPLANTS

//Skillchips
/datum/opposing_force_equipment/implants/engichip
	item_type = /obj/item/skillchip/job/engineer
	description = "一种技能芯片，安装后能让使用者一眼识别气闸门和APC的线路布局并理解其功能。极具价值且备受追捧。"

/datum/opposing_force_equipment/implants/roboticist
	item_type = /obj/item/skillchip/job/roboticist
	description = "一种技能芯片，安装后能让使用者一眼识别机械人的线路布局并理解其功能。"

//Implants
/datum/opposing_force_equipment/implants/nodrop
	item_type = /obj/item/autosurgeon/syndicate/nodrop
	name = "防掉落植入体"
	admin_note = "Allows the user to tighten their grip, their held items unable to be dropped by any cause. Hardstuns user for a longtime if hit with EMP."
	description = "一种植入物，可防止你非自愿地掉落手中的物品。预装在辛迪加自动手术器中。"

/datum/opposing_force_equipment/implants/hackerman
	item_type = /obj/item/autosurgeon/syndicate/hackerman
	name = "黑客手臂植入体"
	admin_note = "A simple tool arm, except it identifies all wire functions when hacking."
	description = "一种先进的手臂植入物，配备尖端黑客工具。专为赛博增强的线路跑者打造。"

/datum/opposing_force_equipment/implants/cns
	name = "中枢神经系统重启植入体"
	item_type = /obj/item/autosurgeon/syndicate/anti_stun
	description = "这种植入物会自动恢复你对中枢神经系统的控制，减少被击晕后的恢复时间。"

/datum/opposing_force_equipment/implants/reviver
	name = "复苏者植入体"
	item_type = /obj/item/autosurgeon/syndicate/reviver
	description = "这种植入物会在你失去意识时尝试将你复苏并治疗。为胆小者准备！"

/datum/opposing_force_equipment/implants/sad_trombone
	name = "悲伤长号植入体"
	item_type = /obj/item/implanter/sad_trombone

/datum/opposing_force_equipment/implants/toolarm
	name = "工具手臂植入体"
	admin_note = "Force 20 implanted combat knife on emag."
	item_type = /obj/item/autosurgeon/toolset

/datum/opposing_force_equipment/implants/surgery
	name = "外科手术手臂植入体"
	admin_note = "Force 20 implanted combat knife on emag."
	item_type = /obj/item/autosurgeon/surgery

/datum/opposing_force_equipment/implants/botany
	name = "植物学手臂植入物"
	admin_note = "Chainsaw arm on emag."
	item_type = /obj/item/autosurgeon/botany

/datum/opposing_force_equipment/implants/janitor
	name = "清洁工手臂植入物"
	item_type = /obj/item/autosurgeon/janitor

/datum/opposing_force_equipment/implants/armblade
	name = "刀刃手臂植入物"
	admin_note = "Force 30 IF emagged."
	item_type = /obj/item/autosurgeon/armblade

/datum/opposing_force_equipment/implants/muscle
	name = "肌肉手臂植入物"
	item_type = /obj/item/autosurgeon/muscle

/datum/opposing_force_equipment/implants_illegal
	category = OPFOR_EQUIPMENT_CATEGORY_IMPLANTS_ILLEGAL

/datum/opposing_force_equipment/implants_illegal/stealth
	name = "潜行植入物"
	item_type = /obj/item/implanter/stealth
	admin_note = "Allows the user to become completely invisible as long as they remain inside a cardboard box."
	description = "一个植入器，赋予你使用终极隐形箱技术的能力。最好配合播放《食蛇者》的磁带录音机使用。"

/datum/opposing_force_equipment/implants_illegal/radio
	name = "辛迪加无线电植入物"
	item_type = /obj/item/implanter/radio/syndicate
	description = "一个植入器，赋予你固有访问辛迪加无线电频道的权限，此外还能监听空间站上的所有频道。"

/datum/opposing_force_equipment/implants_illegal/storage
	name = "存储植入物"
	item_type = /obj/item/implanter/storage
	admin_note = "Allows user to stow items without any sign of having a storage item."
	description = "一个植入器，赋予你访问一小块蓝空口袋的能力，可以存放几件物品。"

/datum/opposing_force_equipment/implants_illegal/freedom
	name = "自由植入物"
	item_type = /obj/item/implanter/freedom
	admin_note = "Allows the user to break handcuffs or e-snares four times, after it will run out and become useless."
	description = "一个植入器，赋予你挣脱手铐一定次数的能力。"

/* TODO Removal pending replacement
/datum/opposing_force_equipment/implants_illegal/micro
	name = "Microbomb Implant"
	admin_note = "RRs the user."
	item_type = /obj/item/implanter/explosive
	description = "An implanter that will make you explode on death in a decent-sized explosion."
*/

/datum/opposing_force_equipment/implants_illegal/emp
	name = "EMP植入物"
	item_type = /obj/item/implanter/emp
	admin_note = "Gives the user a big EMP on an action button. Has three uses after which it becomes useless."
	description = "一个植入器，赋予你创造数次以你为中心的电磁脉冲的能力。"

/datum/opposing_force_equipment/implants_illegal/xray
	name = "X射线视觉"
	item_type = /obj/item/autosurgeon/syndicate/xray_eyes
	description = "这些电子眼将赋予你X射线视觉。眨眼是徒劳的。"

/datum/opposing_force_equipment/implants_illegal/thermal
	name = "热成像视觉"
	item_type = /obj/item/autosurgeon/syndicate/thermal_eyes
	description = "这些电子眼植入物将赋予你热成像视觉。包含垂直狭缝瞳孔。"

/datum/opposing_force_equipment/implants_illegal/armlaser
	name = "手臂激光植入物"
	item_type = /obj/item/autosurgeon/syndicate/laser_arm
	admin_note = "A basic laser gun, but no-drop."
	description = "一种臂炮植入物的变体，可发射致命激光束。炮管从使用者手臂伸出，不使用时缩回体内。"

/datum/opposing_force_equipment/implants_illegal/eswordarm
	name = "能量剑手臂植入物"
	item_type = /obj/item/autosurgeon/syndicate/esword_arm
	admin_note = "Force 30 no-drop, extremely robust."
	description = "这是一把能量剑，在你的手臂里。对于通过搜查和刺杀相当有用。还附带装载在辛迪加品牌自动手术器里！"

/datum/opposing_force_equipment/implants_illegal/baton
	name = "警棍手臂植入物"
	item_type = /obj/item/autosurgeon/syndicate/baton

/datum/opposing_force_equipment/implants_illegal/flash
	name = "闪光手臂植入物"
	item_type = /obj/item/autosurgeon/syndicate/flash

/datum/opposing_force_equipment/implants_illegal/blood_steal_nif
	name = "血液窃取NIF软件"
	item_type = /obj/item/disk/nifsoft_uploader/mil_grade/blood_steal

/datum/opposing_force_equipment/implants_illegal/thermal_nif
	name = "热成像镜片NIF软件"
	item_type = /obj/item/disk/nifsoft_uploader/mil_grade/thermal

/datum/opposing_force_equipment/implants_illegal/tools_nif
	name = "魔典操作NIF软件"
	item_type = /obj/item/disk/nifsoft_uploader/summoner/tools

/datum/opposing_force_equipment/implants_illegal/surgery_nif
	name = "魔典阿斯克勒庇俄斯NIF软件"
	item_type = /obj/item/disk/nifsoft_uploader/job/summoner/surgery
