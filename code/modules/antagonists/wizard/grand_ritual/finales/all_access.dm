/// Open all of the doors
/datum/grand_finale/all_access
	name = "连接"
	desc = "你收集力量的终极运用！解锁他们拥有的每一扇门！现在没人能拦住你，其他人也一样！"
	icon = 'icons/mob/actions/actions_spells.dmi'
	icon_state = "knock"

/datum/grand_finale/all_access/trigger(mob/living/carbon/human/invoker)
	message_admins("[key_name(invoker)] removed all door access requirements")
	for(var/obj/machinery/door/target_door as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door))
		if(is_station_level(target_door.z))
			target_door.unlock()
			target_door.req_access = list()
			target_door.req_one_access = list()
			INVOKE_ASYNC(target_door, TYPE_PROC_REF(/obj/machinery/door/airlock, open))
			CHECK_TICK
	priority_announce("AULIE OXIN FIERA!!", null, 'sound/effects/magic/knock.ogg', sender_override = "[invoker.real_name]", color_override = "purple")
