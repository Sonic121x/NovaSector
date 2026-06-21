/datum/opposing_force_equipment/ranged
	category = OPFOR_EQUIPMENT_CATEGORY_RANGED

/datum/opposing_force_equipment/ranged/riot_sol
	name = "M64霰弹枪"
	description = "一个箱子，内有一把十二号口径霰弹枪，下方有八发弹容，以及两盒15发的鹿弹。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/riot_sol

/obj/item/storage/toolbox/guncase/nova/opfor/riot_sol/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/riot/sol/evil(src)
	new /obj/item/ammo_box/advanced/s12gauge/buckshot(src)
	new /obj/item/ammo_box/advanced/s12gauge/buckshot(src)

/datum/opposing_force_equipment/ranged/sol_rifle
	name = "MMR-2543E突击步枪"
	description = "一个装有战术风格黑红配色重型突击步枪和两个弹匣的箱子。可兼容任何标准的太阳联邦步枪弹匣。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/sol_rifle

/obj/item/storage/toolbox/guncase/nova/opfor/sol_rifle/PopulateContents()
	new /obj/item/gun/ballistic/automatic/sol_rifle/evil(src)
	new /obj/item/ammo_box/magazine/c40sol_rifle/standard(src)
	new /obj/item/ammo_box/magazine/c40sol_rifle/standard(src)

/datum/opposing_force_equipment/ranged/miecz
	name = "'Miecz' Submachinegun"
	description = "A short barrel, further compacted conversion of the 'Lanca' rifle to fire pistol caliber cartridges."
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/miecz

/obj/item/storage/toolbox/guncase/nova/opfor/miecz/PopulateContents()
	new /obj/item/gun/ballistic/automatic/miecz(src)
	new /obj/item/ammo_box/magazine/miecz(src)
	new /obj/item/ammo_box/magazine/miecz(src)

/datum/opposing_force_equipment/ranged/pulse_rifle
	name = "'Žaibas'等离子脉冲投射器"
	description = "A high-capacity, hybrid assault rifle running on fifteen shot 'plugs' instead of conventional bullets; with three available per magazine."
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/pulse_rifle

/obj/item/storage/toolbox/guncase/nova/opfor/pulse_rifle/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pulse_rifle(src)
	new /obj/item/ammo_box/magazine/pulse(src)
	new /obj/item/ammo_box/magazine/pulse(src)

/datum/opposing_force_equipment/ranged/pulse_sniper
	name = "'Žaibas-A'狙击步枪"
	description = "A high-power, hybrid sniper rifle running on fifteen shot 'plugs' instead of conventional bullets; pulling three shots per use."
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/pulse_sniper

/obj/item/storage/toolbox/guncase/nova/opfor/pulse_sniper/PopulateContents()
	new /obj/item/gun/ballistic/rifle/pulse_sniper(src)
	new /obj/item/ammo_box/pulse_cargo_box(src)

/datum/opposing_force_equipment/ranged/kiboko
	name = "Kiboko榴弹发射器"
	description = "一把独特的发射.980榴弹的榴弹发射器。其激光瞄准系统允许使用者设定发射榴弹的引爆距离"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/kiboko

/obj/item/storage/toolbox/guncase/nova/opfor/kiboko/PopulateContents()
	new /obj/item/gun/ballistic/automatic/sol_grenade_launcher/evil(src)
	new /obj/item/ammo_box/magazine/c980_grenade/drum/thunderdome_shrapnel(src)
	new /obj/item/ammo_box/magazine/c980_grenade/drum/thunderdome_shrapnel(src)

/datum/opposing_force_equipment/ranged/amr
	name = "'Wyłom'反器材步枪"
	description = "一把庞大、过时的反器材步枪巨兽，曾为CIN军事力量所用。发射毁灭性的.60 Strela无壳弹，其严重过度的穿透力是此武器停产的原因。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/amr

/obj/item/storage/toolbox/guncase/nova/opfor/amr/PopulateContents()
	new /obj/item/gun/ballistic/automatic/wylom(src)
	new /obj/item/ammo_box/magazine/wylom(src)
	new /obj/item/ammo_box/magazine/wylom(src)

/datum/opposing_force_equipment/ranged/lmg
	name = "L6 SAW轻机枪"
	description = "一把经过大量改装的7毫米轻机枪，型号为'L6 SAW'。机匣下方型号处刻有'Aussec Armoury - 2531'字样。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/lmg

/obj/item/storage/toolbox/guncase/nova/opfor/lmg/PopulateContents()
	new /obj/item/gun/ballistic/automatic/l6_saw/unrestricted(src)
	new /obj/item/ammo_box/magazine/m7mm(src)
	new /obj/item/ammo_box/magazine/m7mm(src)

/datum/opposing_force_equipment/ranged/shitzu
	name = "Shitzu霰弹枪"
	description = "A modified magfed shotgun gun, designated 'Shitzu'."
	item_type = /obj/item/storage/toolbox/guncase/nova/syndicate/shitzu

/datum/opposing_force_equipment/ranged/hook_shotgun
	name = "胡克改装短管霰弹枪"
	description = "当你能把受害者拉到你面前时，射程就不是问题了。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/hook_shotgun

/obj/item/storage/toolbox/guncase/nova/opfor/hook_shotgun/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/hook(src)
	new /obj/item/ammo_box/advanced/s12gauge/buckshot(src)
	new /obj/item/ammo_box/advanced/s12gauge/buckshot(src)

/datum/opposing_force_equipment/ranged/rebar_crossbow
	name = "辛迪加钢筋弩"
	description = "The syndicate liked the bootleg rebar crossbow NT engineers made, so they showed what it could be if properly developed. \
			Holds three shots without a chance of exploding, and features a built in scope. Normally uses special syndicate jagged iron bars, but can be wrenched to shoot inferior normal ones."
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/rebar_crossbow

/obj/item/storage/toolbox/guncase/nova/opfor/rebar_crossbow/PopulateContents()
	new /obj/item/gun/ballistic/rifle/rebarxbow/syndie(src)
	new /obj/item/book/granter/crafting_recipe/dusting/rebarxbowsyndie_ammo(src)

//laser
/datum/opposing_force_equipment/ranged/ion
	name = "离子卡宾枪"
	description = "MK.II原型离子投射器是大型离子步枪的轻量化卡宾枪版本，专为人体工程学和高效能而设计。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/ion

/obj/item/storage/toolbox/guncase/nova/opfor/ion/PopulateContents()
	new /obj/item/gun/energy/ionrifle/carbine(src)
	new /obj/item/storage/box/syndie_kit/recharger(src)

/datum/opposing_force_equipment/ranged/carbine
	name = "激光卡宾枪"
	description = "一种经过改装的激光枪，射速极快，但每发子弹的伤害要低得多。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/carbine

/obj/item/storage/toolbox/guncase/nova/opfor/carbine/PopulateContents()
	new /obj/item/gun/energy/laser/carbine(src)
	new /obj/item/storage/box/syndie_kit/recharger(src)

/datum/opposing_force_equipment/ranged/carbines120
	name = "赛博阳光S-120"
	description = "一种主要由辛迪加安保人员使用的激光枪。它能快速喷射出低功率的等离子光束。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/carbines120

/obj/item/storage/toolbox/guncase/nova/opfor/carbines120/PopulateContents()
	new /obj/item/gun/energy/laser/cybersun/unrestricted(src)
	new /obj/item/storage/box/syndie_kit/recharger(src)

/datum/opposing_force_equipment/ranged/laser
	name = "激光枪"
	description = "一种基本的能量型激光枪，发射能穿透玻璃和薄金属的浓缩光束。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/laser

/obj/item/storage/toolbox/guncase/nova/opfor/laser/PopulateContents()
	new /obj/item/gun/energy/laser(src)
	new /obj/item/storage/box/syndie_kit/recharger(src)

//foamforce
/datum/opposing_force_equipment/ranged/foamforce_lmg
	name = "泡沫轻机枪"
	description = "一款经过大幅改装的玩具轻机枪，型号为'L6 SAW'。适合8岁及以上儿童。"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/foamforce_lmg

/obj/item/storage/toolbox/guncase/nova/opfor/foamforce_lmg/PopulateContents()
	new /obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot(src)
	new /obj/item/ammo_box/magazine/toy/m762/riot(src)
	new /obj/item/ammo_box/magazine/toy/m762/riot(src)


/datum/opposing_force_equipment/ranged_stealth
	category = OPFOR_EQUIPMENT_CATEGORY_RANGED_STEALTH

/datum/opposing_force_equipment/ranged_stealth/rapid_syringe
	name = "紧凑型快速注射枪"
	description = "对注射枪设计的改进，使其更紧凑，并使用旋转弹巢储存最多六支注射器。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/rapid_syringe

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/rapid_syringe/PopulateContents()
	new /obj/item/gun/syringe/rapidsyringe(src)
	new /obj/item/storage/belt/medbandolier(src)
	new /obj/item/reagent_containers/syringe/piercing(src)
	new /obj/item/reagent_containers/syringe/piercing(src)
	new /obj/item/reagent_containers/syringe/piercing(src)
	new /obj/item/reagent_containers/syringe/piercing(src)

/datum/opposing_force_equipment/ranged_stealth/c20r
	name = "C-20r冲锋枪"
	description = "一款无托式三连发.45口径冲锋枪，型号为'C-20r'。枪托上印有'Scarborough Arms - Per falcis, per pravitas'字样。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/c20r

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/c20r/PopulateContents()
	new /obj/item/gun/ballistic/automatic/c20r/unrestricted(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)

/datum/opposing_force_equipment/ranged_stealth/sindano
	name = "辛达诺冲锋枪"
	description = "一款小型冲锋枪，涂有战术黑色。可兼容任何标准索尔手枪弹匣。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/sindano

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/sindano/PopulateContents()
	new /obj/item/gun/ballistic/automatic/sol_smg/evil(src)
	new /obj/item/ammo_box/magazine/c35sol_pistol/stendo(src)
	new /obj/item/ammo_box/magazine/c35sol_pistol/stendo(src)

/datum/opposing_force_equipment/ranged_stealth/alacran
	name = "Alacrán PDW"
	description = "A compact bullpup PDW chambered in .27-54 Cesarzowa, this one is painted in tacticool black. \
		Comes with three full forty-eight-round magazines."
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/alacran

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/alacran/PopulateContents()
	new /obj/item/gun/ballistic/automatic/sol_pdw/evil(src)
	new /obj/item/ammo_box/magazine/alacran_pdw(src)
	new /obj/item/ammo_box/magazine/alacran_pdw(src)
	new /obj/item/ammo_box/magazine/alacran_pdw(src)

/datum/opposing_force_equipment/ranged_stealth/wespe
	name = "韦斯佩手枪"
	description = "索尔联邦各军事部队的标准制式手枪。配有附装手电筒。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/wespe

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/wespe/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/sol/evil(src)
	new /obj/item/ammo_box/magazine/c35sol_pistol(src)
	new /obj/item/ammo_box/magazine/c35sol_pistol(src)

/datum/opposing_force_equipment/ranged_stealth/makarov
	name = "马卡洛夫手枪"
	description = "一款小巧、易于隐藏的9毫米手枪。这把配备了消音器。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/makarov

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/makarov/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol(src)
	new /obj/item/suppressor(src)
	new /obj/item/ammo_box/magazine/m9mm(src)
	new /obj/item/ammo_box/magazine/m9mm(src)

/datum/opposing_force_equipment/ranged_stealth/m1911
	name = "M1911手枪"
	description = "一款经典的.45口径手枪，弹匣容量较小。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/m1911

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/m1911/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/m1911(src)
	new /obj/item/ammo_box/magazine/m45(src)
	new /obj/item/ammo_box/magazine/m45(src)

/datum/opposing_force_equipment/ranged_stealth/plasma_pistol
	name = "'斯沃采'等离子投射器"
	description = "一款过时的副武器，偶尔可见于CIN部分成员使用。只要还有能量且扣动扳机，它就会从磁性枪管中喷出不精确的灼热等离子流。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/plasma_pistol

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/plasma_pistol/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/plasma_thrower(src)
	new /obj/item/ammo_box/magazine/recharge/plasma_battery(src)
	new /obj/item/ammo_box/magazine/recharge/plasma_battery(src)

/datum/opposing_force_equipment/ranged_stealth/plasma_marksman
	name = "'Gwiazda' Plasma Sharpshooter"
	description = "一种过时的副武器，鲜见于CIN部分成员使用。发射相对精准的灼热等离子团。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/plasma_marksman

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/plasma_marksman/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/plasma_marksman(src)
	new /obj/item/ammo_box/magazine/recharge/plasma_battery(src)
	new /obj/item/ammo_box/magazine/recharge/plasma_battery(src)

/datum/opposing_force_equipment/ranged_stealth/syndie_revolver
	name = "辛迪加左轮手枪"
	description = "一款斯卡伯勒公司制造的现代化7发左轮手枪。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/syndie_revolver

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/syndie_revolver/PopulateContents()
	new /obj/item/gun/ballistic/revolver/badass(src)
	new /obj/item/ammo_box/speedloader/c357(src)
	new /obj/item/ammo_box/speedloader/c357(src)

/datum/opposing_force_equipment/ranged_stealth/ocelot
	name = "柯尔特和平缔造者左轮手枪"
	admin_note = "Is packed with peacemaker .357, which deals significantly less damage but has a cool ricochet!"
	description = "一款改装过的和平缔造者左轮手枪，使用.357弹药。威力不如常规.357，但跳弹次数多得多。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/ocelot

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/ocelot/PopulateContents()
	new /obj/item/gun/ballistic/revolver/ocelot(src)
	new /obj/item/ammo_box/speedloader/c357/peacemaker(src)
	new /obj/item/ammo_box/speedloader/c357/peacemaker(src)

/datum/opposing_force_equipment/ranged_stealth/ansem
	name = "安瑟姆手枪箱"
	description = "A small, easily concealable handgun that uses 10mm auto rounds in 8-round magazines and is compatible \
			with suppressors. Comes with three spare magazines."
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/ansem

/obj/item/gun/ballistic/automatic/pistol/clandestine/unrestricted
	pin = /obj/item/firing_pin

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/ansem/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/clandestine/unrestricted(src)
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/ammo_box/magazine/m10mm(src)

/datum/opposing_force_equipment/ranged/rpg
	name = "达尔多-RE火箭推进榴弹发射器"
	description = "A reusable rocket propelled grenade launcher preloaded with a low-yield 84mm HE round. \
			Guaranteed to take your target out with a bang, or your money back! Comes with a bouquet of additional rockets!"
	item_type = /obj/item/storage/toolbox/guncase/nova/opfor/rpg

/obj/item/gun/ballistic/rocketlauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/storage/toolbox/guncase/nova/opfor/rpg/PopulateContents()
	new /obj/item/gun/ballistic/rocketlauncher/unrestricted(src)
	new /obj/item/ammo_box/rocket(src)

//foamforce
/datum/opposing_force_equipment/ranged_stealth/foamforce_smg
	name = "唐克软冲锋枪"
	description = "一款无托式三连发玩具冲锋枪，型号为'C-20r'。适合8岁及以上年龄。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/foamforce_smg

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/foamforce_smg/PopulateContents()
	new /obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot(src)
	new /obj/item/ammo_box/magazine/toy/smgm45/riot(src)
	new /obj/item/ammo_box/magazine/toy/smgm45/riot(src)

/datum/opposing_force_equipment/ranged_stealth/foamforce_smg_basic
	name = "泡沫部队冲锋枪"
	description = "一款原型三连发玩具冲锋枪。适合8岁及以上年龄。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/foamforce_smg_basic

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/foamforce_smg_basic/PopulateContents()
	new /obj/item/gun/ballistic/automatic/toy(src)
	new /obj/item/ammo_box/magazine/toy/smg/riot(src)
	new /obj/item/ammo_box/magazine/toy/smg/riot(src)

//laser
/datum/opposing_force_equipment/ranged_stealth/fisher
	item_type = /obj/item/gun/ballistic/automatic/pistol/clandestine/fisher

/datum/opposing_force_equipment/ranged_stealth/ebow
	item_type = /obj/item/gun/energy/recharge/ebow

/datum/opposing_force_equipment/ranged_stealth/egun_mini
	name = "微型能量枪"
	description = "一款小型、手枪尺寸的能量枪，内置手电筒。有两种设置：失能与击杀。"
	item_type = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/egun_mini

/obj/item/storage/toolbox/guncase/nova/pistol/opfor/egun_mini/PopulateContents()
	new /obj/item/gun/energy/e_gun/mini(src)
	new /obj/item/storage/box/syndie_kit/recharger(src)
