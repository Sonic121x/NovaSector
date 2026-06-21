/datum/outfit/centcom/spec_ops
	name = "特别行动官员"

	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/specops_officer
	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/space/officer
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/gun/energy/pulse/pistol/m1911
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	head = /obj/item/clothing/head/helmet/space/beret
	mask = /obj/item/cigarette/cigar/havana
	shoes = /obj/item/clothing/shoes/combat/swat
	r_pocket = /obj/item/lighter

/datum/outfit/centcom/spec_ops/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

	var/obj/item/radio/headset/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = RADIO_FREQENCY_LOCKED
	..()

/datum/outfit/space
	name = "标准太空装备"

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/space
	back = /obj/item/tank/jetpack
	head = /obj/item/clothing/head/helmet/space
	mask = /obj/item/clothing/mask/breath

/datum/outfit/tournament
	name = "锦标赛标准红色"

	uniform = /obj/item/clothing/under/color/red
	suit = /obj/item/clothing/suit/armor/vest
	head = /obj/item/clothing/head/helmet/thunderdome
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_hand = /obj/item/gun/energy/pulse/destroyer
	l_pocket = /obj/item/knife/kitchen
	r_pocket = /obj/item/grenade/smokebomb

/datum/outfit/tournament/green
	name = "锦标赛标准绿色"

	uniform = /obj/item/clothing/under/color/green

/datum/outfit/tournament/gangster
	name = "锦标赛黑帮"

	uniform = /obj/item/clothing/under/rank/security/detective
	suit = /obj/item/clothing/suit/toggle/jacket/det_trench
	glasses = /obj/item/clothing/glasses/thermal/monocle
	head = /obj/item/clothing/head/fedora/det_hat
	l_hand = /obj/item/gun/ballistic
	l_hand = null
	r_pocket = /obj/item/ammo_box/c10mm

/datum/outfit/tournament/janitor
	name = "清洁工比赛"

	uniform = /obj/item/clothing/under/rank/civilian/janitor
	suit = null
	back = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/stack/tile/iron/base = 6,
)
	head = null
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	r_hand = /obj/item/mop
	l_hand = /obj/item/reagent_containers/cup/bucket

/datum/outfit/tournament/janitor/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/reagent_containers/cup/bucket/bucket = H.get_item_for_held_index(1)
	bucket.reagents.add_reagent(/datum/reagent/water,70)

/datum/outfit/laser_tag
	name = "红镭射标记枪"

	uniform = /obj/item/clothing/under/color/red
	suit = /obj/item/clothing/suit/redtag
	suit_store = /obj/item/gun/energy/laser/redtag
	back = /obj/item/storage/backpack
	box = /obj/item/storage/box
	ears = /obj/item/radio/headset
	gloves = /obj/item/clothing/gloves/color/red
	head = /obj/item/clothing/head/helmet/taghelm/red
	shoes = /obj/item/clothing/shoes/sneakers/red

/datum/outfit/traitor_cutout
	name = "叛徒替身"

	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/armor/vest
	gloves = /obj/item/clothing/gloves/chief_engineer
	mask = /obj/item/clothing/mask/gas
	belt = /obj/item/storage/belt
	l_hand = /obj/item/melee/energy/sword/saber/red
	r_hand = /obj/item/gun/energy/recharge/ebow
	shoes = /obj/item/clothing/shoes/magboots/advance

/datum/outfit/heretic_hallucination
	name = "异教徒幻觉"

	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/hooded/cultrobes/eldritch/rust
	neck = /obj/item/clothing/neck/heretic_focus
	r_hand = /obj/item/melee/touch_attack/mansus_fist
	head = /obj/item/clothing/head/hooded/cult_hoodie/eldritch/rust
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/rev_cutout
	name = "革命者替身"

	uniform = /obj/item/clothing/under/color/grey
	back = /obj/item/storage/backpack
	gloves = /obj/item/clothing/gloves/color/yellow
	mask = /obj/item/clothing/mask/gas
	belt = /obj/item/storage/belt
	l_hand = /obj/item/melee/baton/security/cattleprod
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/laser_tag/blue
	name = "蓝镭射标记枪"

	uniform = /obj/item/clothing/under/color/blue
	suit = /obj/item/clothing/suit/bluetag
	suit_store = /obj/item/gun/energy/laser/bluetag
	gloves = /obj/item/clothing/gloves/color/blue
	head = /obj/item/clothing/head/helmet/taghelm/blue
	shoes = /obj/item/clothing/shoes/sneakers/blue

/datum/outfit/tunnel_clown
	name = "隧道小丑"

	id = /obj/item/card/id/advanced/gold
	id_trim = /datum/id_trim/tunnel_clown
	uniform = /obj/item/clothing/under/rank/civilian/clown
	suit = /obj/item/clothing/suit/hooded/chaplain_hoodie
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/monocle
	gloves = /obj/item/clothing/gloves/color/black
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	l_pocket = /obj/item/food/grown/banana
	r_pocket = /obj/item/bikehorn
	l_hand = /obj/item/fireaxe

/datum/outfit/tunnel_clown/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/psycho
	name = "蒙面杀手"

	uniform = /obj/item/clothing/under/misc/overalls
	suit = /obj/item/clothing/suit/apron
	shoes = /obj/item/clothing/shoes/sneakers/white
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/monocle
	gloves = /obj/item/clothing/gloves/latex
	head = /obj/item/clothing/head/utility/welding
	mask = /obj/item/clothing/mask/surgical
	l_pocket = /obj/item/knife/kitchen
	r_pocket = /obj/item/scalpel
	l_hand = /obj/item/fireaxe

/datum/outfit/psycho/post_equip(mob/living/carbon/human/H)
	for(var/obj/item/carried_item in H.get_equipped_items(INCLUDE_POCKETS | INCLUDE_ACCESSORIES))
		carried_item.add_mob_blood(H)//Oh yes, there will be blood...
	for(var/obj/item/I in H.held_items)
		I.add_mob_blood(H)
	H.regenerate_icons()

/datum/outfit/assassin
	name = "刺客"

	id = /obj/item/card/id/advanced/chameleon/elite/black
	id_trim = /datum/id_trim/reaper_assassin
	uniform = /obj/item/clothing/under/costume/buttondown/slacks/service
	neck = /obj/item/clothing/neck/tie/red/hitman/tied
	belt = /obj/item/modular_computer/pda/heads
	ears = /obj/item/radio/headset
	gloves = /obj/item/clothing/gloves/color/black
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/melee/energy/sword/saber
	l_hand = /obj/item/storage/briefcase/secure

/datum/outfit/assassin/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	var/obj/item/clothing/under/U = H.w_uniform
	U.attach_accessory(new /obj/item/clothing/accessory/waistcoat(H))

	if(visuals_only)
		return

	//Could use a type
	var/obj/item/storage/briefcase/secure/sec_briefcase = H.get_item_for_held_index(1)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i = 3 to 0 step -1)
		sec_briefcase.contents += new /obj/item/stack/spacecash/c1000
	sec_briefcase.contents += new /obj/item/gun/energy/recharge/ebow
	sec_briefcase.contents += new /obj/item/gun/ballistic/revolver/mateba
	sec_briefcase.contents += new /obj/item/ammo_box/speedloader/c357
	sec_briefcase.contents += new /obj/item/grenade/c4/x4

	var/obj/item/modular_computer/pda/heads/pda = H.belt
	pda.imprint_id(H.real_name, "Reaper")

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/centcom/commander
	name = "中央指挥司令"

	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/commander
	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/centcom_formal
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/gun/ballistic/revolver/mateba
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	head = /obj/item/clothing/head/hats/centhat
	mask = /obj/item/cigarette/cigar/cohiba
	shoes = /obj/item/clothing/shoes/combat/swat
	l_pocket = /obj/item/ammo_box/speedloader/c357
	r_pocket = /obj/item/lighter

/datum/outfit/centcom/commander/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	..()

/datum/outfit/centcom/commander/mod
	name = "中央指挥司令（模块服）"

	suit_store = /obj/item/tank/internals/oxygen
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	back = /obj/item/mod/control/pre_equipped/corporate
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/ghost_cultist
	name = "血教幽灵"

	uniform = /obj/item/clothing/under/color/black/ghost
	suit = /obj/item/clothing/suit/hooded/cultrobes/alt/ghost
	shoes = /obj/item/clothing/shoes/cult/alt/ghost
	l_hand = /obj/item/melee/cultblade/ghost

/datum/outfit/cult_cutout
	name = "邪教徒替身"

	uniform = /obj/item/clothing/under/rank/civilian/chaplain
	suit = /obj/item/clothing/suit/hooded/cultrobes/hardened
	shoes = /obj/item/clothing/shoes/cult/alt
	back = /obj/item/storage/backpack/cultpack
	r_hand = /obj/item/melee/cultblade/dagger

/datum/outfit/wizard
	name = "蓝巫师"

	uniform = /obj/item/clothing/under/color/lightpurple
	suit = /obj/item/clothing/suit/wizrobe
	back = /obj/item/storage/backpack
	backpack_contents = list(
		/obj/item/spellbook = 1,
	)
	box = /obj/item/storage/box/survival
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/wizard
	shoes = /obj/item/clothing/shoes/sandal/magic
	r_pocket = /obj/item/teleportation_scroll
	l_hand = /obj/item/staff

/datum/outfit/wizard/post_equip(mob/living/carbon/human/wizard, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/spellbook/new_spellbook = locate() in wizard.back
	if(new_spellbook)
		new_spellbook.owner = wizard.mind

/datum/outfit/wizard/bookless
	name = "巫师 - 无书"
	backpack_contents = list()

/datum/outfit/wizard/bookless/post_equip(mob/living/carbon/human/wizard, visuals_only)
	return

/datum/outfit/wizard/apprentice
	name = "巫师学徒"

	r_pocket = /obj/item/teleportation_scroll/apprentice
	r_hand = null
	l_hand = null
	backpack_contents = list()

/datum/outfit/wizard/red
	name = "红巫师"

	suit = /obj/item/clothing/suit/wizrobe/red
	head = /obj/item/clothing/head/wizard/red

/datum/outfit/wizard/weeb
	name = "魔理沙"

	suit = /obj/item/clothing/suit/wizrobe/marisa
	head = /obj/item/clothing/head/wizard/marisa
	shoes = /obj/item/clothing/shoes/sneakers/marisa

/datum/outfit/wizard/academy
	name = "巫师学院"
	r_pocket = null
	r_hand = null
	suit = /obj/item/clothing/suit/wizrobe/red
	head = /obj/item/clothing/head/wizard/red
	backpack_contents = list()

/datum/outfit/centcom/soviet
	name = "苏联上将"

	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/admiral
	uniform = /obj/item/clothing/under/costume/soviet
	suit = /obj/item/clothing/suit/costume/pirate/captain
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/gun/ballistic/revolver/mateba
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	head = /obj/item/clothing/head/costume/pirate/captain
	shoes = /obj/item/clothing/shoes/combat

/datum/outfit/centcom/soviet/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id

	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	..()

/datum/outfit/mobster
	name = "黑帮分子"

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/mobster
	uniform = /obj/item/clothing/under/suit/black_really
	neck = /obj/item/clothing/neck/tie/red/tied
	ears = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/fedora
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/gun/ballistic/automatic/tommygun

/datum/outfit/mobster/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/chrono_agent
	name = "时间线根除特工"

	uniform = /obj/item/clothing/under/color/white
	suit_store = /obj/item/tank/internals/oxygen
	mask = /obj/item/clothing/mask/breath
	back = /obj/item/mod/control/pre_equipped/chrono

/datum/outfit/chrono_agent/post_equip(mob/living/carbon/human/agent, visuals_only)
	. = ..()
	var/obj/item/mod/control/mod = agent.back
	if(!istype(mod))
		return
	var/obj/item/mod/module/eradication_lock/lock = locate(/obj/item/mod/module/eradication_lock) in mod.modules
	lock.true_owner_ckey = agent.ckey

/datum/outfit/debug //Debug objs plus MODsuit
	name = "Debug套装"

	id = /obj/item/card/id/advanced/debug
	uniform = /obj/item/clothing/under/misc/patriotsuit
	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/debug
	backpack_contents = list(
		/obj/item/melee/energy/axe = 1,
		/obj/item/storage/part_replacer/bluespace/AdminDebug = 1,
		/obj/item/gun/magic/wand/resurrection/debug = 1,
		/obj/item/gun/magic/wand/death/debug = 1,
		/obj/item/debug/human_spawner = 1,
		/obj/item/debug/omnitool = 1,
)
	belt = /obj/item/storage/belt/utility/full/powertools
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/debug
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/welding/up
	shoes = /obj/item/clothing/shoes/magboots/advance

	box = /obj/item/storage/box/debugtools
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/debug/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/admin //for admeem shenanigans and testing things that arent related to equipment, not a subtype of debug just in case debug changes things
	name = "Admin outfit-管理员装备"

	id = /obj/item/card/id/advanced/debug
	uniform = /obj/item/clothing/under/misc/patriotsuit
	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/administrative
	backpack_contents = list(
		/obj/item/melee/energy/axe = 1,
		/obj/item/storage/part_replacer/bluespace/AdminDebug = 1,
		/obj/item/gun/magic/wand/resurrection/debug = 1,
		/obj/item/gun/magic/wand/death/debug = 1,
		/obj/item/debug/human_spawner = 1,
		/obj/item/debug/omnitool = 1,
		/obj/item/storage/box/stabilized = 1,
)
	belt = /obj/item/storage/belt/utility/full/powertools
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/debug
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/welding/up
	shoes = /obj/item/clothing/shoes/magboots/advance

	box = /obj/item/storage/box/debugtools
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/admin/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
