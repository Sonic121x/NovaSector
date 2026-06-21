//code & items for the hauntedtradingpost.dmm ruin
//CONTAINS: [Lore Papers],[Outpost ID Cards],[Gimmick Treasure],[Hazards & Traps],[Custom Turrets]

// [Lore Papers]
// clues to traps that exist in the ruin or just insights into the backstory of the place
/obj/item/paper/fluff/ruins/hauntedtradingpost/warning
	name = "最后警告"
	default_raw_text = "下一个用那些该死的玩具枪搞坏自动售货机的人，当场开除。试试看。我他妈受够了这破事。<BR><BR>签字，你他妈的上司（能他妈开除你的那位）"

/obj/item/paper/fluff/ruins/hauntedtradingpost/warning/turrets
	name = "警告！重要！阅读此内容！"
	default_raw_text = "泡沫飞镖不能放进防御炮塔！只能用实弹！"

/obj/item/paper/fluff/ruins/hauntedtradingpost/brainstorming
	name = "笔记"
	default_raw_text = "品牌：口袋披萨（检查焦点小组）<BR><BR>番茄马苏里拉罗勒<BR>等等<BR><BR>蜘蛛 17-02667 商店 31-00314<BR><BR>约 18,000 BSD<BR><BR>常见过敏原 - ？<BR><BR><BR>6127"

/obj/item/paper/fluff/ruins/hauntedtradingpost/brainstorming/eureka
	default_raw_text = "从蛾族贸易舰队弄到了一些原料，并用我们的可支配预算租用了一些工厂空间。原型产品在公众和员工中都反响良好。如果我们能让总部资助大规模生产，根据AI预测，我们将看到区域利润永久性增长18%。这*完美*契合了当地的早午餐市场。"

/obj/item/paper/fluff/ruins/hauntedtradingpost/brainstorming/eureka2
	default_raw_text = "完全无碳水配方的早期实验进展顺利。口味测试均为正面，只需要找到降低成本的方法。"

/obj/item/paper/fluff/ruins/hauntedtradingpost/brainstorming/eureka3
	default_raw_text = "项目：大块头<BR>研发部已准备好几个原型。<BR>测试将于本周末完成。"

/obj/item/paper/fluff/ruins/hauntedtradingpost/rpgclub
	name = "角色扮演俱乐部"
	default_raw_text = "角色扮演俱乐部每周四20:00至01:00举行。在此期间，休息室严格仅限受邀者进入。<BR> <BR> 我们对可能造成的不便表示歉意。"

/obj/item/paper/fluff/ruins/hauntedtradingpost/rpgrules
	name = "GM笔记"
	default_raw_text = "第4场NPC <BR> 暗影战士 <BR> S  A  T  C  H <BR> 40 65 40 15 10 <BR><BR>暗影氏族领主 <BR> S  A  T  C  H <BR> 40 65 40 15 10 <BR>注：拥有暗影魔法。<BR><BR><BR>凶暴柯基 <BR> S  A  T  C  H <BR> 60 25 65 25 12 <BR><BR>如果他们击败了这个，让他们在战利品表4上掷两次，但如果结果是65-70或15-30，则改为魔法靴子。"

/obj/item/paper/fluff/ruins/hauntedtradingpost/curatorsnote
	name = "致冒险者"
	default_raw_text = "The food court and the stalls are safe, everywhere else isn't. There's safes in the stalls and I didn't have a way to open them so if you can get whatever's inside, good for you. The employees area can be entered by tailing the bots, but security systems are active back there. I got shot by a turret taking a look, and when I stitched myself up and tried the other door I walked into a booby trap and nearly lost an arm.<BR><BR>If you're investigating this signal - BEWARE.<BR>For the record, I decided nothing in there's worth the risk. If you're braver than me, good luck.<BR>Signed, Curator P."

/obj/item/paper/fluff/ruins/hauntedtradingpost/officememo
	name = "备忘录"
	default_raw_text = "为保护公司财产，AI制导防御系统将无限期保持激活状态。请确保所有个人物品均已带离场所，若遗忘将无法找回。<BR><BR>Donk Co. 对个人财产损失或影响概不负责。"

/obj/item/paper/fluff/ruins/hauntedtradingpost/receipt
	name = "旧收据"
	desc = "一张印在廉价热敏纸上的破旧销售收据。"
	default_raw_text = "DONK CO 直销店 6013<BR>您今日的服务员是：COLM<BR><BR>2x DONKPOCKETPIZBOX    400<BR>1x CRYPTOGRAPHICSEQ    800<BR>2x CRYPTOGRAPHICTOY    200<BR>1x DONKPOCKETPLUSHY    120<BR><BR>总价                  1520<BR><BR>支付方式：现金"
	icon_state = "paperslip"

/obj/item/paper/fluff/ruins/hauntedtradingpost/receipt/alternate
	default_raw_text = "DONK CO 直销店 6013<BR>您今日的服务员是：VLAD<BR><BR>1x DONKPOCKETBERBOX    200<BR>1x GORLEXMODSUITRED    1400<BR>1x MODSUITMICROWAVE    200<BR><BR>总价                  1800<BR><BR>支付方式：现金"

/obj/item/paper/fluff/ruins/hauntedtradingpost/receipt/alternate_alt
	default_raw_text = "DONK CO 直销店 6013<BR>您今日的服务员是：COLM<BR><BR>10xDONKPOCKETORGBOX   2000<BR>4x GORLEXMODSUITRED    9600<BR>4x MODSUITMICROWAVE    800<BR><BR>总价                 13400<BR><BR>支付方式：刷卡"

/obj/item/paper/fluff/ruins/hauntedtradingpost/nomodsuits
	name = "通知"
	desc = "这张纸条上写着一堆字。这，就是未来。"
	default_raw_text = "我们已售罄所有模组防护服。"
	icon_state = "paperslip"

/obj/item/paper/fluff/ruins/hauntedtradingpost/oldnote
	name = "旧便条"
	default_raw_text = "记得在弹药装填进炮塔前检查口径。如果装错了口径，炮塔会故障。<BR>我们只使用9毫米弹药。"

/obj/item/paper/fluff/ruins/hauntedtradingpost/oldnote/aiclue
	name = "旧手写便条"
	default_raw_text = "所有电器现在都已连接到AI。如果有任何问题，请向赛博太阳公司代表（Satung先生）报告。"

// [Outpost ID Cards]
//ID cards for the space ruin
/obj/item/card/id/away/donk
	name = "\improper Donk Co. ID卡"
	desc = "一张塑料卡片，证明持有者是Donk Co.的员工。嵌有电子芯片，用于与气闸门及其他机器通信。上面没有附名字。"
	icon_state = "card_donk"
	trim = /datum/id_trim/away/hauntedtradingpost

/obj/item/card/id/away/donk/boss
	desc = "一张塑料卡片，证明持有者是Donk Co.的高级员工。嵌有电子芯片，用于与气闸门及其他机器通信。上面没有附名字。"
	icon_state = "card_donkboss"
	trim = /datum/id_trim/away/hauntedtradingpost/boss

// [Gimmick Treasure]
// loot & weird items that should only exist in hauntedtradingpost.dmm
//aquarium with two donkfish in it
/obj/structure/aquarium/donkfish
	name = "办公室水族箱"
	desc = "一个圈养鱼类的家。这个上面刻着'DONK CO'。"
	init_mode = AQUARIUM_MODE_SAFE

/obj/structure/aquarium/donkfish/Initialize(mapload)
	. = ..()
	new /obj/item/aquarium_prop/rocks(src)
	new /obj/item/aquarium_prop/seaweed(src)
	new /obj/item/fish/donkfish(src)
	new /obj/item/fish/donkfish(src)

//gimmick ketchup bottle for healing minor injuries
/obj/item/reagent_containers/condiment/donksauce
	name = "\improper Donk Co. 秘制酱料"
	desc = "配方高度机密的著名番茄酱。"
	list_reagents = list(
		/datum/reagent/consumable/ketchup = 25,
		/datum/reagent/medicine/omnizine = 10,
		/datum/reagent/consumable/astrotame = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/bungojuice = 1,
		/datum/reagent/consumable/curry_powder = 1,
		/datum/reagent/consumable/soymilk = 1,
		/datum/reagent/consumable/tomatojuice = 1,
		/datum/reagent/consumable/vitfro = 1,
	)
	icon_state = "ketchup"
	fill_icon_thresholds = null

// [Hazards & Traps]
//cyborg holobarriers that die when the boss dies, how exciting
#define SELFDESTRUCT_QUEUE "hauntedtradingpost_sd" //make sure it matches the AI cores ID
/obj/structure/holosign/barrier/cyborg/cybersun_ai_shield
	desc = "由AI核心投射出的脆弱全息能量场。它将不受欢迎的人形生物保持在安全距离外。"

/obj/structure/holosign/barrier/cyborg/cybersun_ai_shield/Initialize(mapload)
	. = ..()
	if(mapload) //shouldnt queue when we arent even part of a ruin, probably admin shitspawned
		SSqueuelinks.add_to_queue(src, SELFDESTRUCT_QUEUE)

//smes that produces power, until the boss dies then it self destructs and you gotta make your own power
/obj/machinery/power/smes/magical/cybersun
	name = "赛博太阳牌电力储存单元"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. It looks like any other SMES unit, except this one says 'Cybersun' on it."
	//is this being used as part of the haunted trading post ruin? if true, will self destruct when boss dies
	var/donk_ai_slave = FALSE

/obj/machinery/power/smes/magical/cybersun/Initialize(mapload)
	. = ..()
	if(donk_ai_slave)
		SSqueuelinks.add_to_queue(src, SELFDESTRUCT_QUEUE)

//this is a trigger for traps involving doors and shutters
//doors get closed and bolted, shutters get cycled open/closed
/obj/machinery/button/door/invisible_tripwire
	name = "声波绊线"
	desc = "用于百叶窗和门的隐形触发器。当有人踏上该地砖时触发。"
	max_integrity = 50
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	//is this being used as part of the haunted trading post ruin? if true, will self destruct when boss dies
	var/donk_ai_slave = FALSE
	//can the trap trigger more than once?
	var/multiuse = FALSE
	//(if multiuse) how many times the trap can trigger. 0 or lower is infinite
	var/uses_remaining = 0
	//if true, the trap will unbolt all doors it bolted and cycle shutters a second time after a delay
	var/resets_self = FALSE
	//time before resets_self kicks in
	var/reset_timer = 1.8 SECONDS
	//when multiple tripwires are in the same suicide pact, they will all die when any of them die
	var/suicide_pact = FALSE
	//id of the suicide pact this tripwire is in
	var/suicide_pact_id

/obj/machinery/button/door/invisible_tripwire/Initialize(mapload)
	. = ..()
	if(donk_ai_slave)
		SSqueuelinks.add_to_queue(src, SELFDESTRUCT_QUEUE)
	if(suicide_pact && suicide_pact_id != null)
		SSqueuelinks.add_to_queue(src, suicide_pact_id)
		. = INITIALIZE_HINT_LATELOAD
	var/static/list/loc_connections = list(
	COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/button/door/invisible_tripwire/find_and_mount_on_atom(mark_for_late_init, late_init)
	return //these exist independently on an turf

/obj/machinery/button/door/invisible_tripwire/post_machine_initialize()
	. = ..()
	if(!suicide_pact || isnull(SSqueuelinks.queues[suicide_pact_id]))
		return // we got beat to it
	SSqueuelinks.pop_link(suicide_pact_id)

/obj/machinery/button/door/invisible_tripwire/MatchedLinks(id, list/partners)
	if(id != suicide_pact_id)
		return
	for(var/partner in partners)
		RegisterSignal(partner, COMSIG_PUZZLE_COMPLETED, TYPE_PROC_REF(/datum, selfdelete))

/obj/machinery/button/door/invisible_tripwire/proc/on_entered(atom/source, atom/movable/victim)
	SIGNAL_HANDLER
	if(!isliving(victim))
		return
	var/mob/living/target = victim
	if(target.stat != DEAD && target.mob_size == MOB_SIZE_HUMAN && target.mob_biotypes != MOB_ROBOTIC)
		tripwire_triggered(target)
		if(multiuse && uses_remaining < 1)
			uses_remaining--
		if(resets_self)
			addtimer(CALLBACK(src, PROC_REF(tripwire_triggered), victim), reset_timer)

/obj/machinery/button/door/invisible_tripwire/proc/tripwire_triggered(atom/victim)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, interact), victim)
	if(multiuse && uses_remaining != 1)
		return
	if(suicide_pact && suicide_pact_id)
		SEND_SIGNAL(src, COMSIG_PUZZLE_COMPLETED)
	qdel(src)

//door button that destroys itself when it is pressed
/obj/machinery/button/door/selfdestructs
	icon_state= "button-warning"
	skin = "-warning"

/obj/machinery/button/door/selfdestructs/attempt_press(mob/user)
	. = ..()
	do_sparks(rand(1,3), src)
	playsound(src, SFX_SPARKS, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	qdel(src)

//trap that gloms onto the first machine it finds on its tile, and lives inside it
//then it zaps everyone who gets close. disarm by dissassembling the machine, or running out its charges
/obj/effect/overloader_trap
	name = "过载陷阱"
	desc = "一种通过过载机器来电击附近行人的陷阱。"
	alpha = 70
	max_integrity = 50
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/effects/effects.dmi'
	icon_state = "empdisable"
	//trap won't damage mobs in its faction. set this to null to make it attack everyone
	faction = list(ROLE_SYNDICATE)
	invisibility = INVISIBILITY_ABSTRACT
	plane = ABOVE_GAME_PLANE
	//datum we use to trigger when someones close
	var/datum/proximity_monitor/proximity_monitor
	// how close someone has to be to set the trap off
	var/trigger_range = 1
	// max range the trap can zap someone
	var/shock_range = 1
	/// damage from getting zapped by this trap
	var/shock_damage = 35
	// length of time target spends stunned
	var/stun_duration = 1.5 SECONDS
	// length of time targets spend jittery
	var/jitter_time = 5 SECONDS
	// length of time targets stutter
	var/stutter_time = 2 SECONDS
	//is this being used as part of the haunted trading post ruin? if true, will self destruct when boss dies
	var/donk_ai_slave = FALSE
	// machine that the trap inhabits
	var/obj/machinery/host_machine
	// turf that the trap is on
	var/turf/my_turf
	//how long until trap zaps everything, after it detects something
	var/trigger_delay = 0.7 SECONDS
	COOLDOWN_DECLARE(trigger_cooldown)
	//time until trap can be triggered again
	var/trigger_cooldown_duration = 4 SECONDS
	//max amount of times the trap can trigger
	var/uses_remaining = 4
	//amount of damage the trap does to the machine its on, when its triggered
	//this can kill the machine and if it does, the trap effectively disarms itself
	//so acts as a soft cap of sorts on number of trap activations
	var/machine_overload_damage = 80 //machine integrity is usually 200 or 300

/obj/effect/overloader_trap/Initialize(mapload)
	. = ..()
	proximity_monitor = new(src, 0)
	proximity_monitor?.set_range(trigger_range)
	my_turf = get_turf(src)
	host_machine = locate(/obj/machinery) in loc
	if(donk_ai_slave)
		SSqueuelinks.add_to_queue(src, SELFDESTRUCT_QUEUE)

/obj/effect/overloader_trap/HasProximity(mob/living/target as mob)
	if(!locate(host_machine) in loc) //muh machine's gone, delete myself because im disarmed
		qdel(src)
		return
	if(!isliving(target))
		return
	if(!COOLDOWN_FINISHED(src, trigger_cooldown)) //do nothing if we're on cooldown
		return
	if(uses_remaining == 0) //deletes trap if it triggers when it has no uses left. should only happen if var edited but lets just be safe
		qdel(src)
		return
	if (target.stat) //ensure the guy triggering us is alive
		return
	if (!faction_check_atom(target)) //and make sure it ain't someone on our team
		COOLDOWN_START(src, trigger_cooldown, 4 SECONDS)
		trap_alerted()

/obj/effect/overloader_trap/proc/trap_alerted()
	if(host_machine in loc) //if someone breaks or moves the machine before the trap goes off, this should fail to do anything
		visible_message(span_boldwarning("火花从[host_machine]中迸出，它剧烈地震动着！"))
		do_sparks(number = 3, source = host_machine)
		host_machine.Shake(2, 1, trigger_delay)
		addtimer(CALLBACK(src, PROC_REF(trap_effect)), trigger_delay)

/obj/effect/overloader_trap/proc/trap_effect()
	for(var/mob/living/living_mob in range(shock_range, src))
		if(faction_check_atom(living_mob))
			continue
		to_chat(living_mob, span_warning("你被一道电弧击中了！"))
		src.Beam(living_mob, icon_state = "lightning[rand(1,12)]", time = 0.5 SECONDS)
		living_mob.electrocute_act(shock_damage, host_machine, 1, SHOCK_NOGLOVES, stun_duration, jitter_time, stutter_time)
	for(var/obj/item/food/deadmouse in range(shock_range, src))
		src.Beam(deadmouse, icon_state = "lightning[rand(1,12)]", time = 0.5 SECONDS)
	do_sparks(number = 1, source = host_machine)
	host_machine.take_damage(machine_overload_damage, sound_effect = FALSE)
	uses_remaining--
	if(uses_remaining <= 0)
		qdel(src)

// [Custom Turrets]
//these are the non-mob defenders of the hauntedtradingpost.dmm ruin
//they are controlled with a syndicate ID and are hostile to anything non-syndicate by default

//donk turret - 9mm
/obj/machinery/porta_turret/syndicate/donk
	//Medium speed, medium damage, fragile. Does brute damage.
	name = "\improper 唐克公司防御炮塔"
	icon_state = "donk_lethal"
	max_integrity = 120
	base_icon_state = "donk"
	stun_projectile = /obj/projectile/bullet/foam_dart/riot
	lethal_projectile = /obj/projectile/bullet/c9mm/blunttip
	lethal_projectile_sound = 'sound/items/weapons/gun/pistol/shot.ogg'
	stun_projectile_sound = 'sound/items/weapons/gun/pistol/shot.ogg'
	desc = "一台带有唐克公司商标的弹道机枪自动炮塔。它使用9毫米子弹。"
	armor_type = /datum/armor/donk_turret
	scan_range = 6
	shot_delay = 1 SECONDS

/datum/armor/donk_turret
	melee = 20
	bullet = 20
	laser = 40
	energy = 40
	bomb = 20
	fire = 50
	acid = 100

/obj/projectile/bullet/c9mm/blunttip
	wound_bonus = -40 //this will still cause bleeding wounds, but less often.

//cybersun turret - plasma beam
/obj/machinery/porta_turret/syndicate/energy/cybersun
	//Slow speed, high damage. Does burn damage.
	name = "\improper 赛博阳光等离子体自动炮塔"
	icon_state = "red_lethal"
	base_icon_state = "red"
	stun_projectile = /obj/projectile/energy/electrode
	stun_projectile_sound = 'sound/items/weapons/taser.ogg'
	lethal_projectile = /obj/projectile/beam/laser/cybersun
	lethal_projectile_sound = 'sound/items/weapons/lasercannonfire.ogg'
	desc = "一台带有赛博太阳商标的能量枪自动炮塔。它发射高能等离子束，造成大量伤害，但可能相当缓慢。"
	armor_type = /datum/armor/syndicate_shuttle
	scan_range = 6
	shot_delay = 5 SECONDS
	always_up = FALSE
	has_cover = TRUE

/obj/projectile/beam/laser/cybersun
	name = "等离子束"
	desc = "一道巨大的红色等离子束，目前正在飞行中。"
	icon_state = "lava"
	light_color = COLOR_DARK_RED
	damage = 30
	wound_bonus = -50

#undef SELFDESTRUCT_QUEUE
