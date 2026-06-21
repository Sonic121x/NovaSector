/obj/item/keycard/meatderelict/director
	name = "主管门禁卡"
	desc = "一张花哨的门禁卡。很可能能打开主管办公室。姓名标签已经模糊不清了。"
	color = "#990000"
	puzzle_id = "md_director"

/obj/item/keycard/meatderelict/engpost
	name = "哨站门禁卡"
	desc = "一张花哨的门禁卡。上面有工程部门的徽记。"
	color = "#f0da12"
	puzzle_id = "md_engpost"

/obj/item/keycard/meatderelict/armory
	name = "军械库门禁卡"
	desc = "一张红色的门禁卡。上面有一把枪的酷炫图案。真花哨。"
	color = "#FF7276"
	puzzle_id = "md_armory"

/obj/item/paper/crumpled/bloody/fluff/meatderelict/directoroffice
	name = "主管便条"
	default_raw_text = "<i>研究进展顺利……但实验没有按计划进行。他抽搐着、尖叫着，慢慢变成了……那个东西。它开始到处蔓延，实验室外面也是。我们无法掩盖这里不是传送研究前哨站的事实，所以我封锁了实验室，但他们已经知道了。他们派了一个小队来营救我们，但是……</i>"

/obj/item/paper/crumpled/fluff/meatderelict/shieldgens
	name = "护盾门营销草图"
	default_raw_text = "<b>QR-109 护盾门</b>是一种坚固的硬光机器，能够产生强大的护盾以阻挡进入。通过控制面板集成，可以从任何地方启用或禁用它，例如舰桥、<b>工程舱</b>，或其他任何地方！<i>其余部分已褪色……</i>"

/obj/item/paper/crumpled/fluff/meatderelict
	name = "工程师便条"
	default_raw_text = "我已经超频了发电机，为实验提供所需的额外电力，不过它们有点不稳定。"

/obj/item/paper/crumpled/fluff/meatderelict/fridge
	name = "工程师投诉"
	default_raw_text = "不管是谁一直在偷我冰箱里的他妈冰淇淋，我发誓我真的会揍你。把这种美味的冰淇淋弄到这里可不便宜，也不是给你准备的。<b>还有，别碰我抽屉里的零食！</b>"

/obj/machinery/computer/terminal/meatderelict
	upperinfo = "COPYRIGHT 2500 NANOSOFT-TM - DO NOT REDISTRIBUTE - Now with audio!" //not that old
	content = list(
		"Experimental Test Satellite 37B<br/>Nanotrasen™️ approved deep space experimentation lab<br/><br/>Entry 1:<br/><br/>Subject - \[Species 501-C-12\]<br/>Date - \[REDACTED\]<br/>We have acquired a biological sample of unknown origins \[Species 501-C-12\] from an NT outpost on the far reaches. Initial experiments have determined the sample to be a creature never previously recorded. It weighs approximately 7 grams and seems to be docile. Initial examinations determine that it is an extremely fast replicating organism which can alter its physiology to take multiple differing shapes. \[Recording Terminated\]<br/>- Dr. Phil Cornelius",
		"Entry 2:<br/><br/>Subject - \[Species 501-C-12\]<br/>Date - \[REDACTED\]<br/>The creature responds to electrical stimuli. It has failed to respond to Light, Heat, Cold, Oxygen, Plasma, CO2, Nitrogen. It, within moments, seemed to have generated muscle tissue within its otherwise shapeless form and moved away from the source of electricity. Feeding the creature has been a simple matter, it consumed just about any form of protein. It appears to rapidly digest and convert forms of protein into more of itself. Any undigestible products are simply left alone. Will continue to monitor creature and provide reports to Nanotrasen Central Command. \[Recording Terminated\]<br/>- Dr. Phil Cornelius",
		"Entry 3:<br/><br/>Subject - \[Species 501-C-12\]<br/>Date - \[REDACTED\]<br/>Any attempts at contacting Nanotrasen has failed. I've never seen anything like it. I... I don't think I'm going to survive much longer, I can hear it pushing on my room door. If anyone reads this, let my family know that I- \[Loud crash\]<br/>GET BACK \[Gunshots\]<br/>AHHHHHHHHHHHH \[Recording Terminated\]<br/>- Dr. Phil Cornelius"
	)

/obj/machinery/door/puzzle/meatderelict
	name = "封锁门"
	desc = "一扇饱经风霜但仍坚固的门。对常规破坏方法免疫，附近一定有打开它的方法。"
	icon = 'icons/obj/doors/puzzledoor/danger.dmi'
	puzzle_id = "md_prevault"

/mob/living/basic/meteor_heart/opens_puzzle_door
	///the puzzle id we send on death
	var/id
	///queue size, must match
	var/queue_size = 2

/mob/living/basic/meteor_heart/opens_puzzle_door/Initialize(mapload)
	. = ..()
	new /obj/effect/puzzle_death_signal_holder(loc, src, id, queue_size)

/obj/effect/puzzle_death_signal_holder // ok apparently registering signals on qdeling stuff is not very functional
	///delay
	var/delay = 2.5 SECONDS
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/puzzle_death_signal_holder/Initialize(mapload, mob/listened, id, queue_size = 2)
	. = ..()
	if(isnull(id))
		return INITIALIZE_HINT_QDEL
	RegisterSignal(listened, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	SSqueuelinks.add_to_queue(src, id, queue_size)

/obj/effect/puzzle_death_signal_holder/proc/on_death(datum/source)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(send_sig)), delay)

/obj/effect/puzzle_death_signal_holder/proc/send_sig()
	SEND_SIGNAL(src, COMSIG_PUZZLE_COMPLETED)
	qdel(src)

/obj/machinery/puzzle/button/meatderelict
	name = "封锁面板"
	desc = "一个控制该前哨站封锁状态的控制面板。"
	id = "md_prevault"

/obj/machinery/puzzle/button/meatderelict/on_puzzle_complete()
	. = ..()
	playsound(src, 'sound/effects/alert.ogg', 100, TRUE)
	visible_message(span_warning("[src] 在封锁解除时发出警报！"))

/obj/structure/puzzle_blockade/meat
	name = "肉与齿的聚合体"
	desc = "一团由肉和牙齿构成的可怕聚合体。它能看见你吗？你希望不能。它几乎坚不可摧，肯定有办法绕过去。"
	icon = 'icons/obj/structures.dmi'
	icon_state = "meatblockade"
	opacity = TRUE

/obj/structure/puzzle_blockade/meat/try_signal(datum/source)
	Shake(duration = 0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(open_up)), 0.5 SECONDS)

/obj/structure/puzzle_blockade/meat/proc/open_up()
	new /obj/effect/gibspawner/generic(drop_location())
	qdel(src)

/obj/lightning_thrower
	name = "过载的SMES"
	desc = "一个超频的SMES，充满了能量。"
	anchored = TRUE
	density = TRUE
	icon = 'icons/obj/machines/engine/other.dmi'
	icon_state = "smes"
	/// do we currently want to shock diagonal tiles? if not, we shock cardinals
	var/throw_diagonals = FALSE
	/// flags we apply to the shock
	var/shock_flags = SHOCK_KNOCKDOWN | SHOCK_NOGLOVES
	/// damage of the shock
	var/shock_damage = 20
	/// list of turfs that are currently shocked so we can unregister the signal
	var/list/signal_turfs = list()
	/// how long do we shock
	var/shock_duration = 0.5 SECONDS

/obj/lightning_thrower/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/lightning_thrower/Destroy()
	. = ..()
	clear_signals()
	signal_turfs = null
	STOP_PROCESSING(SSprocessing, src)

/obj/lightning_thrower/process(seconds_per_tick)
	var/list/dirs = throw_diagonals ? GLOB.diagonals : GLOB.cardinals
	throw_diagonals = !throw_diagonals
	playsound(src, 'sound/effects/magic/lightningbolt.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)
	if(length(signal_turfs))
		clear_signals()
	for(var/direction in dirs)
		var/victim_turf = get_step(src, direction)
		if(isclosedturf(victim_turf))
			continue
		Beam(victim_turf, icon_state="lightning[rand(1,12)]", time = shock_duration)
		RegisterSignal(victim_turf, COMSIG_ATOM_ENTERED, PROC_REF(shock_victim)) //we cant move anyway
		signal_turfs += victim_turf
		for(var/mob/living/victim in victim_turf)
			shock_victim(null, victim)
	addtimer(CALLBACK(src, PROC_REF(clear_signals)), shock_duration)

/obj/lightning_thrower/proc/clear_signals()
	for(var/turf in signal_turfs)
		UnregisterSignal(turf, COMSIG_ATOM_ENTERED)
		signal_turfs -= turf

/obj/lightning_thrower/proc/shock_victim(datum/source, mob/living/victim)
	SIGNAL_HANDLER
	if(!istype(victim))
		return
	victim.electrocute_act(shock_damage, src, flags = shock_flags)
