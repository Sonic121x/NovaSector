/// Dorms Room Papers
/obj/item/paper/fluff/ruins/waystation/menu
	name = "本周食物菜单"
	default_raw_text = "这是公司这周给我们送来的东西，老样子。<BR><BR><B>周一</B> - 披萨和通心粉奶酪<BR><B>周二</B> - 太空鲤鱼刺身和寿司<BR><B>周三</B> - 蒜油尼扎亚和亨卡利<BR><B>周四</B> - QM生日，蛋糕和一堆糕点<BR><B>周五</B> - 炸鱼薯条<BR><BR>再加上技术员们设法从板条箱里\"意外\"偷来的任何种类的酒和食物（这是一个提醒）-厨师"

/obj/item/paper/fluff/ruins/waystation/toilet
	name = "提醒！！"
	default_raw_text = "我已经口头告诉过你们这些混蛋了，但你们没一个人听，上完厕所后给我冲水！<BR>我是这里唯一打扫卫生的人，你们得感激这一点！-格雷"

/// Cargo Bay Paper
/obj/item/paper/fluff/ruins/waystation/sop
	name = "S.O.P 提醒"
	default_raw_text= "Quick reminder for the new SOP guidelines.<BR>Please remember to haul all security-locked crates and other high-value items into secure storage. I don't care if you steal from the other crates, those paperwork is on you. Just don't steal anything that would get all of us in trouble, alright?"
/// Vault Paper
/obj/item/paper/fluff/ruins/waystation/memo
	name = "备忘录"
	default_raw_text= "请妥善保管来自故障穿梭机的文件，直到有人来取。我们真的不应该随身携带这种东西。"
/// Syndicate Holodisk
/obj/item/disk/holodisk/ruin/waystation
	name = "行动 NUCLEUS - 简报"
	preset_image_type = /datum/preset_holoimage/syndicatebattlecruisercaptain
	preset_record_text = {"
	NAME Raymond Johnson
	SAY All right boys, The mission is simple.
	DELAY 20
	SAY You will be breaching an distant waystation on the fringe of Nanotrasen territory.
	DELAY 25
	SAY Your main objective is to secure highly classified documents about recent Nanotrasen expansion in the Spinward sector.
	DELAY 20
	SAY The documents are located in the secure storage room.
	DELAY 25
	SAY As for getting there, you lot will be assault-podded from a smuggling ship.
	DELAY 30
	SAY Security there is lax, with just a single security officer guarding the entire station.
	DELAY 25
	SAY Once you've completed your objectives, Radio-in the smugglers for them to pick you up.
	DELAY 10
	SAY This should be a cakewalk, I have the utmost confidence that you will succeed with your objectives. Good luck.
	DELAY 25"}

// Outfits
/datum/outfit/waystation/
	name = "不合规的中转站服装"

/datum/outfit/waystation/cargohauler
	name = "中转站货运搬运工"
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/away/waystation/cargo_technician
	uniform = /obj/item/clothing/under/rank/cargo/tech
	belt = /obj/item/modular_computer/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/waystation/qm
	name = "中转站军需官"
	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/away/waystation/quartermaster
	uniform = /obj/item/clothing/under/rank/cargo/qm
	belt = /obj/item/modular_computer/pda/heads/quartermaster
	ears = /obj/item/radio/headset/headset_cargo
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/sneakers/brown

/datum/outfit/waystation/nanotrasenofficer
	name = "中转站安保干员"
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/away/waystation/security
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/security
	l_pocket = /obj/item/ammo_box/magazine/m45
// Corpse Spawner
/obj/effect/mob_spawn/corpse/human/waystation/cargo_technician
	name = "中转站货运搬运工"
	outfit = /datum/outfit/waystation/cargohauler

/obj/effect/mob_spawn/corpse/human/waystation/quartermaster
	name = "中转站军需官"
	outfit = /datum/outfit/waystation/qm

/obj/effect/mob_spawn/corpse/human/waystation/nanotrasenofficer
	name = "中转站安保干员"
	outfit = /datum/outfit/waystation/nanotrasenofficer
