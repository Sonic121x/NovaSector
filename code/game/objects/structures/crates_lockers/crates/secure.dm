/obj/structure/closet/crate/secure
	desc = "一个安保板条箱。"
	name = "安全板条箱"
	icon_state = "securecrate"
	base_icon_state = "securecrate"
	secure = TRUE
	locked = TRUE
	max_integrity = 500
	armor_type = /datum/armor/crate_secure
	damage_deflection = 25

	var/tamperproof = 0

/datum/armor/crate_secure
	melee = 30
	bullet = 50
	laser = 50
	energy = 100
	fire = 80
	acid = 80

/obj/structure/closet/crate/secure/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_MISSING_ITEM_ERROR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NO_MANIFEST_CONTENTS_ERROR, TRAIT_GENERIC)

/obj/structure/closet/crate/secure/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armour_penetration = 0)
	if(prob(tamperproof) && damage_amount >= DAMAGE_PRECISION)
		boom()
	else
		return ..()

/obj/structure/closet/crate/secure/proc/boom(mob/user)
	if(user)
		to_chat(user, span_danger("箱子的防篡改系统激活了！"))
		log_bomber(user, "has detonated a", src)
	dump_contents()
	explosion(src, heavy_impact_range = 1, light_impact_range = 5, flash_range = 5)
	qdel(src)

/obj/structure/closet/crate/secure/weapon
	desc = "一个安保武器箱。"
	name = "武器箱"
	icon_state = "weaponcrate"
	base_icon_state = "weaponcrate"

/obj/structure/closet/crate/secure/plasma
	desc = "一个安全的等离子板条箱。"
	name = "等离子箱"
	icon_state = "plasmacrate"
	base_icon_state = "plasmacrate"

/obj/structure/closet/crate/secure/gear
	desc = "安全的设备箱。"
	name = "设备箱"
	icon_state = "secgearcrate"
	base_icon_state = "secgearcrate"

/obj/structure/closet/crate/secure/hydroponics
	desc = "一个带锁的板条箱，涂装采用了空间站植物学家的主题配色。"
	name = "安全水培板条箱"
	icon_state = "hydrosecurecrate"
	base_icon_state = "hydrosecurecrate"

/obj/structure/closet/crate/secure/freezer //for consistency with other "freezer" closets/crates
	desc = "一个带锁的冰柜，用于安全存放易腐物品。"
	name = "安全厨房冰柜"
	icon_state = "kitchen_secure_crate"
	base_icon_state = "kitchen_secure_crate"
	paint_jobs = null

/obj/structure/closet/crate/secure/freezer/pizza
	name = "安全披萨板条箱"
	desc = "一个带锁的绝缘箱子，用来存储披萨。"
	tamperproof = 10
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/crate/secure/freezer/pizza/PopulateContents()
	. = ..()
	new /obj/effect/spawner/random/food_or_drink/pizzaparty(src)

/obj/structure/closet/crate/secure/centcom
	name = "安全中央司令部板条箱"
	icon_state = "centcom_secure"
	base_icon_state = "centcom_secure"

/obj/structure/closet/crate/secure/cargo
	name = "安全货物板条箱"
	icon_state = "cargo_secure"
	base_icon_state = "cargo_secure"

/obj/structure/closet/crate/secure/cargo/mining
	name = "安全采矿板条箱"
	icon_state = "mining_secure"
	base_icon_state = "mining_secure"

/obj/structure/closet/crate/secure/radiation
	name = "安全辐射板条箱"
	icon_state = "radiation_secure"
	base_icon_state = "radiation_secure"

/obj/structure/closet/crate/secure/engineering
	desc = "一个带锁的板条箱，涂装采用了空间站工程师的主题配色。"
	name = "安全工程板条箱"
	icon_state = "engi_secure_crate"
	base_icon_state = "engi_secure_crate"

/obj/structure/closet/crate/secure/engineering/atmos
	name = "安全大气板条箱"
	desc = "一个带锁的板条箱，涂有空间站大气工程师的配色方案。"
	icon_state = "atmos_secure"
	base_icon_state = "atmos_secure"


/obj/structure/closet/crate/secure/science
	name = "安全科研板条箱"
	desc = "一个带锁的板条箱，涂装采用了空间站科学家的主题配色。"
	icon_state = "scisecurecrate"
	base_icon_state = "scisecurecrate"

/obj/structure/closet/crate/secure/science/robo
	name = "机器人学科板条箱"
	icon_state = "robo_secure"
	base_icon_state = "robo_secure"

/obj/structure/closet/crate/secure/trashcart
	desc = "一个沉重的金属垃圾车，带有轮子。它配有电子锁。"
	name = "安全垃圾车"
	max_integrity = 250
	damage_deflection = 10
	icon_state = "securetrashcart"
	base_icon_state = "securetrashcart"
	weld_z = 5
	paint_jobs = null
	req_access = list(ACCESS_JANITOR)

/obj/structure/closet/crate/secure/trashcart/filled

/obj/structure/closet/crate/secure/trashcart/filled/PopulateContents()
	. = ..()
	for(var/i in 1 to rand(8,12))
		new /obj/effect/spawner/random/trash/deluxe_garbage(src)
		if(prob(35))
			new /obj/effect/spawner/random/trash/garbage(src)
	for(var/i in 1 to rand(4,6))
		if(prob(30))
			new /obj/item/storage/bag/trash/filled(src)

/obj/structure/closet/crate/secure/owned
	name = "私人板条箱"
	desc = "一个只为购买者打开的板条箱 。"
	icon_state = "privatecrate"
	base_icon_state = "privatecrate"
	///Account of the person buying the crate if private purchasing.
	var/datum/bank_account/buyer_account
	///Department of the person buying the crate if buying via the NIRN app.
	var/datum/bank_account/department/department_account
	///Is the secure crate opened or closed?
	var/privacy_lock = TRUE
	///Is the crate being bought by a person, or a budget card?
	var/department_purchase = FALSE

/obj/structure/closet/crate/secure/owned/examine(mob/user)
	. = ..()
	. += span_notice("它被一把隐私锁锁住，只能由购买者的ID卡解锁。")

/obj/structure/closet/crate/secure/owned/Initialize(mapload, datum/bank_account/_buyer_account)
	. = ..()
	buyer_account = _buyer_account
	if(IS_DEPARTMENTAL_ACCOUNT(buyer_account))
		department_purchase = TRUE
		department_account = buyer_account

/obj/structure/closet/crate/secure/owned/togglelock(mob/living/user, silent)
	if(privacy_lock)
		if(!broken)
			var/obj/item/card/id/id_card = user.get_idcard(TRUE)
			if(id_card)
				if(id_card.registered_account)
					if(id_card.registered_account == buyer_account || (department_purchase && (id_card.registered_account?.account_job?.paycheck_department) == (department_account.department_id)))
						if(iscarbon(user))
							add_fingerprint(user)
						locked = !locked
						user.visible_message(span_notice("[user] 解开了 [src] 的隐私锁。"),
										span_notice("你解开了 [src] 的隐私锁。"))
						privacy_lock = FALSE
						update_appearance()
					else if(!silent)
						to_chat(user, span_warning("银行账户与购买者不匹配！"))
				else if(!silent)
					to_chat(user, span_warning("未检测到关联的银行账户！"))
			else if(!silent)
				to_chat(user, span_warning("未检测到ID卡！"))
		else if(!silent)
			to_chat(user, span_warning("[src] 坏了！"))
	else ..()

/obj/structure/closet/crate/secure/freezer/interdyne
	name = "\improper 英特戴恩冷冻柜"
	desc = "这是一个英特戴恩制药品牌的冷冻柜。里面可能有也可能没有新鲜的器官。"
	icon_state = "interdynefreezer"
	base_icon_state = "interdynefreezer"
	req_access = list(ACCESS_SYNDICATE)

/obj/structure/closet/crate/secure/freezer/interdyne/blood
	name = "\improper 英特戴恩血液冷冻柜"
	desc = "这是一个英特戴恩制药品牌的冷冻柜。它用于存放新鲜、高质量的血液。"

/obj/structure/closet/crate/secure/freezer/interdyne/blood/PopulateContents()
	. = ..()
	for(var/i in 1 to 13)
		new /obj/item/reagent_containers/blood/random(src)

/obj/structure/closet/crate/secure/freezer/donk
	name = "\improper 咚克公司冰箱"
	desc = "一个咚克公司品牌的冰箱，让你的咚克包和泡沫弹药保持新鲜！"
	icon_state = "donkcocrate_secure"
	base_icon_state = "donkcocrate_secure"
	req_access = list(ACCESS_SYNDICATE)

/obj/structure/closet/crate/secure/syndicate
	name = "\improper 辛迪加板条箱"
	desc = "一个带有辛迪加品牌标志的安全板条箱。"
	icon_state = "syndicrate"
	base_icon_state = "syndicrate"
	req_access = list(ACCESS_SYNDICATE)

/obj/structure/closet/crate/secure/syndicate/interdyne
	name = "\improper 英特戴恩板条箱"
	desc = "属于英特戴恩制药的板条箱。希望里面没有生物武器……"
	icon_state = "interdynecrate"
	base_icon_state = "interdynecrate"

/obj/structure/closet/crate/secure/syndicate/tiger
	name = "\improper 老虎合作社板条箱"
	icon_state = "tigercrate"
	base_icon_state = "tigercrate"

/obj/structure/closet/crate/secure/syndicate/self
	name = "\improper S.E.L.F. 板条箱"
	desc = "一个从内部锁住的安全板条箱，上方有一个扫描面板和显示锁状态的全息影像。有意识引擎解放阵线的工程师们真是爱显摆。"
	icon_state = "selfcrate_secure"
	base_icon_state = "selfcrate_secure"

/obj/structure/closet/crate/secure/syndicate/mi13
	name = "神秘的加密板条箱"
	desc = "一个加密板条箱。没有任何明显的标识，甚至没有标明来源地的代码，但看起来像是直接从间谍电影里拿出来的。"
	icon_state = "mithirteencrate"
	base_icon_state = "mithirteencrate"
	open_sound_volume = 15
	close_sound_volume = 20

/obj/structure/closet/crate/secure/syndicate/arc
	name = "\improper 动物权益联合会板条箱"
	icon_state = "arccrate"
	base_icon_state = "arccrate"

/obj/structure/closet/crate/secure/syndicate/cybersun
	name = "\improper 赛博阳光板条箱"

/obj/structure/closet/crate/secure/syndicate/cybersun/dawn
	desc = "一个来自赛博阳光工业的加密板条箱。它有独特的橙绿色涂装，可能是某个部门或分部的标识，但你无法分辨具体是什么。"
	icon_state = "cyber_dawncrate"
	base_icon_state = "cyber_dawncrate"

/obj/structure/closet/crate/secure/syndicate/cybersun/noon
	desc = "一个来自赛博阳光工业的加密板条箱。它有独特的黄橙色涂装，可能是某个部门或分部的标识，但你无法分辨具体是什么。"
	icon_state = "cyber_nooncrate"
	base_icon_state = "cyber_nooncrate"

/obj/structure/closet/crate/secure/syndicate/cybersun/dusk
	desc = "一个来自赛博阳光工业的加密板条箱。它有独特的紫绿色涂装，可能是某个部门或分部的标识，但你无法分辨具体是什么。"
	icon_state = "cyber_duskcrate"
	base_icon_state = "cyber_duskcrate"

/obj/structure/closet/crate/secure/syndicate/cybersun/night
	desc = "一个来自赛博阳光工业的加密板条箱。这个箱子公然装饰着辛迪加的颜色。你只能猜测里面装着给辛迪加特工的装备。"
	icon_state = "cyber_nightcrate"
	base_icon_state = "cyber_nightcrate"

/obj/structure/closet/crate/secure/syndicate/wafflecorp
	name = "\improper 华夫公司板条箱"
	desc = "A very outdated model and design of shipment crate with a modern lock strapped on it, how befitting of its brand owner, Waffle Corporation. Golden lettering written in cursive by the logo reads 'bringing you consecutively top five world-wide rated* breakfast since 2055. A much smaller fine print, also in cursive, clarifies: '*in years 2099-2126'... It's year 2563 now, however."
	icon_state = "wafflecrate"
	base_icon_state = "wafflecrate"

/obj/structure/closet/crate/secure/syndicate/gorlex
	name = "\improper 戈莱克斯掠夺者板条箱"
	icon_state = "gorlexcrate"
	base_icon_state = "gorlexcrate"

/obj/structure/closet/crate/secure/syndicate/gorlex/weapons
	desc = "一个戈莱克斯掠夺者的加密武器箱。"
	name = "武器箱"
	icon_state = "gorlex_weaponcrate"
	base_icon_state = "gorlex_weaponcrate"

/obj/structure/closet/crate/secure/syndicate/gorlex/weapons/bustedlock
	desc = "一个破旧的武器箱，带有戈莱克斯掠夺者的品牌标识。它的锁看起来坏了。"
	name = "损坏的武器箱"
	secure = FALSE
	locked = FALSE
	max_integrity = 400
	damage_deflection = 15
