/obj/machinery/auto_cloner
	name = "神秘舱体"
	desc = "它装满了粘稠的液体，但看起来黑暗而寂静。同时也出人意料地轻。"
	icon = 'modular_nova/modules/xenoarchartifacts/icons/artifacts_64x32.dmi'
	icon_state = "autocloner_off"
	/// What mob are we spawning
	var/spawn_type
	/// Current progress
	var/time_spent_spawning = 0
	/// Required progress
	var/time_per_spawn = 0
	var/last_process= 0
	anchored = FALSE
	density = TRUE
	var/previous_power_state = 0
	use_power = IDLE_POWER_USE
	active_power_usage = 2000
	idle_power_usage = 1000

/obj/machinery/auto_cloner/Initialize(mapload)
	. = ..()
	time_per_spawn = rand(1200,3600)
	// 33% chance to spawn nasties
	if(prob(33))
		spawn_type = pick(
		/mob/living/basic/bear,
		/mob/living/basic/carp,
		/mob/living/basic/flesh_spider,
		/mob/living/basic/eyeball,
		/mob/living/basic/migo,
		/mob/living/basic/snake,
		/mob/living/basic/spider/giant/tank,
		/mob/living/basic/wumborian_fugu,
		/mob/living/basic/killer_tomato,
		/mob/living/basic/slime,
		/mob/living/basic/pet/cat/feral,
		/mob/living/basic/mining/basilisk,
		/mob/living/basic/mining/goliath,
		/mob/living/basic/mining/lobstrosity,
		/mob/living/basic/mining/watcher,
		/mob/living/basic/mega_arachnid,
		/mob/living/basic/leaper,
		/mob/living/basic/mining/wolf,
		/mob/living/basic/mining/ice_whelp,
		/mob/living/basic/alien,
		/mob/living/basic/alien/drone,
		/mob/living/basic/alien/queen,
		/mob/living/basic/alien/sentinel,
		/mob/living/basic/illusion,
		/mob/living/basic/mimic,
		/mob/living/basic/goose,
		/mob/living/basic/living_limb_flesh,
		/mob/living/basic/bee/toxin, // Be me. Me bee.
		/mob/living/basic/morph,
	)
	else
		spawn_type = pick( // Useful for DNA Bunker, I guess?
		/mob/living/basic/axolotl,
		/mob/living/basic/crab, // Look sir! Free crabs!
		/mob/living/basic/bat,
		/mob/living/basic/spider/maintenance,
		/mob/living/basic/pet/cat,
		/mob/living/basic/pet/cat/cak,
		/mob/living/basic/pet/dog/pug,
		/mob/living/basic/pet/dog/bullterrier,
		/mob/living/basic/pet/dog/breaddog,
		/mob/living/basic/parrot,
		/mob/living/basic/pet/fox,
		/mob/living/basic/pet/penguin,
		/mob/living/basic/sloth,
		/mob/living/basic/seedling,
		/mob/living/basic/chicken,
		/mob/living/basic/cow,
		/mob/living/basic/goat,
		/mob/living/basic/deer,
		/mob/living/basic/pig,
		/mob/living/basic/pony,
		/mob/living/basic/sheep,
		/mob/living/basic/alien/maid,
		/mob/living/carbon/human/species/monkey,
		/mob/living/basic/pet/cat/fennec,
		/mob/living/basic/slime/random, // Free slimes!
		/mob/living/basic/lightgeist,
		/mob/living/basic/mushroom,
		/mob/living/basic/mothroach,
	)

/obj/machinery/auto_cloner/process(seconds_per_tick)
	if(powered(power_channel))
		if(!previous_power_state)
			previous_power_state = 1
			icon_state = "autocloner_on"
			visible_message(
				span_notice("[src] 突然活过来了！"),
				blind_message = span_hear("你听见附近有液体晃动的声音。"),
			)

		// slowly grow a mob
		if(SPT_PROB(2.5, seconds_per_tick))
			visible_message(
				span_notice("[src] [pick("gloops", "glugs", "whirrs", "whooshes", "hisses", "purrs", "hums", "gushes")]。"),
				blind_message = span_hear("附近有什么东西[pick("gloops", "glugs", "whirrs", "whooshes", "hisses", "purrs", "hums", "gushes")]。"),
			)

		// if we've finished growing...
		if(time_spent_spawning >= time_per_spawn)
			time_spent_spawning = 0
			update_use_power(IDLE_POWER_USE)
			visible_message(
				span_notice("[src] 发出哔哔声！"),
				blind_message = span_hear("你听到哔哔声。"),
			)
			icon_state = "autocloner_on"
			desc = "它装满了冒泡的粘稠液体，并被一道神秘的光芒照亮。"
			if(spawn_type)
				new spawn_type(get_turf(src))

		// if we're getting close to finished, kick into overdrive power usage
		if(time_spent_spawning / time_per_spawn > 0.75)
			update_use_power(ACTIVE_POWER_USE)
			icon_state = "autocloner_process"
			desc = "它装满了冒泡的粘稠液体，并被一道神秘的光芒照亮。一个黑暗的形体似乎正在内部成形……"
		else
			update_use_power(IDLE_POWER_USE)
			icon_state = "autocloner_on"
			desc = "它装满了冒泡的粘稠液体，并被一道神秘的光芒照亮。"

		time_spent_spawning = time_spent_spawning + world.time - last_process
	else
		if(previous_power_state)
			previous_power_state = 0
			icon_state = "autocloner_off"
			visible_message(
				span_notice("[src] 突然关闭了。"),
				blind_message = span_hear("附近有什么东西关闭并停止了噪音。"),
			)

		// cloned mob slowly breaks down
		time_spent_spawning = max(time_spent_spawning + last_process - world.time, 0)

	last_process = world.time
