// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/disease/magnitis
	name = "Magnitis"
	max_stages = 4
	spread_text = "Airborne"
	cure_text = /datum/reagent/iron
	cures = list(/datum/reagent/iron)
	agent = "Fukkos Miracos"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	spreading_modifier = 0.75
	desc = "This disease disrupts the magnetic field of the subjects body, making it act as if a powerful magnet. \
		Injections of iron will help stabilize the field."
	severity = DISEASE_SEVERITY_MEDIUM
	infectable_biotypes = MOB_ORGANIC|MOB_ROBOTIC
	bypasses_immunity = TRUE
	process_dead = TRUE


/datum/disease/magnitis/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.a0c14b551ef62577", null)))
			if(SPT_PROB(1, seconds_per_tick))
				for(var/obj/nearby_object in orange(2, affected_mob))
					if(nearby_object.anchored || !(nearby_object.obj_flags & CONDUCTS_ELECTRICITY))
						continue
					var/move_dir = get_dir(nearby_object, affected_mob)
					nearby_object.Move(get_step(nearby_object, move_dir), move_dir)
				for(var/mob/living/silicon/nearby_silicon in orange(2, affected_mob))
					if(isAI(nearby_silicon))
						continue
					var/move_dir = get_dir(nearby_silicon, affected_mob)
					nearby_silicon.Move(get_step(nearby_silicon, move_dir), move_dir)
		if(3)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.60f88d8fa0aa86c7", null)))
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.dffdf60ee9ae2ee2", null)))
				for(var/obj/nearby_object in orange(4, affected_mob))
					if(nearby_object.anchored || !(nearby_object.obj_flags & CONDUCTS_ELECTRICITY))
						continue
					for(var/i in 1 to rand(1, 2))
						nearby_object.throw_at(affected_mob, 4, 3)
				for(var/mob/living/silicon/nearby_silicon in orange(4, affected_mob))
					if(isAI(nearby_silicon))
						continue
					for(var/i in 1 to rand(1, 2))
						nearby_silicon.throw_at(affected_mob, 4, 3)
		if(4)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.d05da4f52dabf7e1", null)))
			if(SPT_PROB(4, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.8b3e917bc1497be8", null)))
				for(var/obj/nearby_object in orange(6, affected_mob))
					if(nearby_object.anchored || !(nearby_object.obj_flags & CONDUCTS_ELECTRICITY))
						continue
					for(var/i in 1 to rand(1, 3))
						nearby_object.throw_at(affected_mob, 6, 5) // I really wanted to use addtimers to stagger out when everything gets thrown but it would probably cause a lot of lag.
				for(var/mob/living/silicon/nearby_silicon in orange(6, affected_mob))
					if(isAI(nearby_silicon))
						continue
					for(var/i in 1 to rand(1, 3))
						nearby_silicon.throw_at(affected_mob, 6, 5)
