/turf/open/lava/fake
	name = "岩浆"
	desc = "来吧。踩进去。也许你会成为某种基于岩浆的耶稣。"
	planetary_atmos = TRUE
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	lava_damage = 0
	lava_firestacks = 0
	temperature_damage = 0
	immunity_trait = TRAIT_GHOSTROLE
	immunity_resistance_flags = LAVA_PROOF

/turf/open/floor/plating/vox
	name = "充氮地板"
	desc = "沃克斯盒认证。"
	initial_gas_mix = "n2=104;TEMP=293.15"

/turf/open/indestructible/bathroom
	icon = 'modular_nova/modules/ghostcafe/icons/floors.dmi';
	icon_state = "titanium_blue_old";
	name = "浴室地板"
	footstep = FOOTSTEP_FLOOR
	tiled_turf = FALSE

/turf/open/indestructible/carpet
	desc = "它真的很舒适！非常适合柔软的爪子！";
	icon = 'modular_nova/modules/ghostcafe/icons/carpet_royalblack.dmi';
	icon_state = "carpet";
	name = "柔软地毯"
	bullet_bounce_sound = null
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_turf = FALSE

/turf/open/water/hot_spring/cafe
	planetary_atmos = TRUE
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
