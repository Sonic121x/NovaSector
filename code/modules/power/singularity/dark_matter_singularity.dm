// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// bonus probability to chase the target granted by eating a supermatter
#define DARK_MATTER_SUPERMATTER_CHANCE_BONUS 10

/// This type of singularity cannot grow as big, but it constantly hunts down living targets.
/obj/singularity/dark_matter
	name = "dark matter singularity"
	desc = "<i>\"It is both beautiful and horrifying, \
		a cosmic paradox that defies all logic. I can't \
		take my eyes off it, even though I know it could \
		devour us all in an instant.\
		\"</i><br>- Chief Engineer Tenshin Nakamura"
	ghost_notification_message = "IT'S HERE"
	icon_state = "dark_matter_s1"
	singularity_icon_variant = "dark_matter"
	maximum_stage = STAGE_FOUR
	energy = 250
	singularity_component_type = /datum/component/singularity/bloodthirsty
	///to avoid cases of the singuloth getting blammed out of existence by the very meteor it rode in on...
	COOLDOWN_DECLARE(initial_explosion_immunity)

/obj/singularity/dark_matter/Initialize(mapload, starting_energy)
	. = ..()
	COOLDOWN_START(src, initial_explosion_immunity, 5 SECONDS)
	var/datum/component/singularity/resolved_singularity = singularity_component.resolve()
	resolved_singularity.chance_to_move_to_target = 100
	addtimer(CALLBACK(src, PROC_REF(normalize_tracking)), 20 SECONDS)

/obj/singularity/dark_matter/examine(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, initial_explosion_immunity))
		. += span_warning(LANG("obj.52056b49331aec82", list(src, DisplayTimeText(COOLDOWN_TIMELEFT(src, initial_explosion_immunity)))))
	if(consumed_supermatter)
		. += span_userdanger(LANG("obj.aad79db2c6a2eed4", null))
	else
		. += span_warning(LANG("obj.f9560945677625e7", null))

/obj/singularity/dark_matter/ex_act(severity, target)
	if(!COOLDOWN_FINISHED(src, initial_explosion_immunity))
		return FALSE
	return ..()

/obj/singularity/dark_matter/supermatter_upgrade()
	var/datum/component/singularity/resolved_singularity = singularity_component.resolve()
	resolved_singularity.chance_to_move_to_target += DARK_MATTER_SUPERMATTER_CHANCE_BONUS
	name = "Dark Lord Singuloth"
	desc = LANG("obj.262052f467bf7257", null)
	consumed_supermatter = TRUE

///For 20 seconds, the singularity has buffed tracking to ensure it actually makes its way to the station, normalizes after 20 seconds
/obj/singularity/dark_matter/proc/normalize_tracking()
	var/datum/component/singularity/resolved_singularity = singularity_component.resolve()
	resolved_singularity.chance_to_move_to_target = consumed_supermatter ? initial(resolved_singularity.chance_to_move_to_target) + DARK_MATTER_SUPERMATTER_CHANCE_BONUS : initial(resolved_singularity.chance_to_move_to_target)

#undef DARK_MATTER_SUPERMATTER_CHANCE_BONUS
