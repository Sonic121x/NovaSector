// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/antag_spawner/nuke_ops/ed209_nukie
	name = "Syndicate ED209 Robot"
	desc = "A single-use beacon designed to quickly launch reinforcement operatives into the field."


/obj/item/antag_spawner/nuke_ops/ed209_nukie/attack_self(mob/user)
	if(!(check_usability(user)))
		return

	to_chat(user, span_notice(LANG("obj.74fad6c7e04fc96b", list(src))))
	drop_bot()
	do_sparks(4, TRUE, src)
	qdel(src)

/obj/item/antag_spawner/nuke_ops/ed209_nukie/proc/drop_bot()
	var/mob/living/basic/bot/secbot/ed209/nukie/nuclear_bot = new()
	var/obj/structure/closet/supplypod/pod = setup_pod()
	nuclear_bot.forceMove(pod)
	new /obj/effect/pod_landingzone(spawn_location ? spawn_location : get_turf(src), pod)
