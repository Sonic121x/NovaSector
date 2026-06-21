/datum/round_event_control/mice_migration
	name = "老鼠迁移"
	typepath = /datum/round_event/mice_migration
	weight = 10
	category = EVENT_CATEGORY_ENTITIES
	description = "一大群老鼠抵达，甚至可能包括鼠王本尊。"

/datum/round_event/mice_migration
	var/minimum_mice = 5
	var/maximum_mice = 15

/datum/round_event/mice_migration/announce(fake)
	var/cause = pick("space-winter", "budget-cuts", "Ragnarok",
		"space being cold", "\[REDACTED\]", "climate change",
		"bad luck")
	var/plural = pick("a number of", "a horde of", "a pack of", "a swarm of",
		"a whoop of", "not more than [maximum_mice]")
	var/name = pick("啮齿动物", "老鼠", "吱吱叫的东西",
		"wire eating mammals", "\[REDACTED\]", "energy draining parasites")
	var/movement = pick("migrated", "swarmed", "stampeded", "descended")
	var/location = pick("maintenance tunnels", "maintenance areas",
		"\[REDACTED\]", "place with all those juicy wires")

	priority_announce("Due to [cause], [plural] [name] have [movement] \
		into the [location].", "迁徙警报",
		'sound/mobs/non-humanoids/mouse/mousesqueek.ogg')

/datum/round_event/mice_migration/start()
	SSminor_mapping.trigger_migration(rand(minimum_mice, maximum_mice))
