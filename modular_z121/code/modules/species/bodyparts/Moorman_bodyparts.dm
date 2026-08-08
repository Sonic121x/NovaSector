#define MOORMAN_PUNCH_LOW 7
#define MOORMAN_PUNCH_HIGH 15
#define MOORMAN_KICK_LOW 10
#define MOORMAN_KICK_HIGH 20
#define MOORMAN_BRUTE_MODIFIER 0.9

/obj/item/bodypart/head/moorman
	icon_greyscale = 'modular_z121/icons/mob/bodyparts/Moorman_parts_greyscale.dmi'
	limb_id = SPECIES_MOORMAN
	brute_modifier = MOORMAN_BRUTE_MODIFIER

/obj/item/bodypart/chest/moorman
	icon_greyscale = 'modular_z121/icons/mob/bodyparts/Moorman_parts_greyscale.dmi'
	limb_id = SPECIES_MOORMAN
	brute_modifier = MOORMAN_BRUTE_MODIFIER

/obj/item/bodypart/arm/left/moorman
	icon_greyscale = 'modular_z121/icons/mob/bodyparts/Moorman_parts_greyscale.dmi'
	limb_id = SPECIES_MOORMAN
	max_damage = 30
	unarmed_damage_low = MOORMAN_PUNCH_LOW
	unarmed_damage_high = MOORMAN_PUNCH_HIGH
	brute_modifier = MOORMAN_BRUTE_MODIFIER
	unarmed_attack_sound = 'sound/items/weapons/genhit1.ogg'

/obj/item/bodypart/arm/right/moorman
	icon_greyscale = 'modular_z121/icons/mob/bodyparts/Moorman_parts_greyscale.dmi'
	limb_id = SPECIES_MOORMAN
	max_damage = 30
	unarmed_damage_low = MOORMAN_PUNCH_LOW
	unarmed_damage_high = MOORMAN_PUNCH_HIGH
	brute_modifier = MOORMAN_BRUTE_MODIFIER
	unarmed_attack_sound = 'sound/items/weapons/genhit1.ogg'

/obj/item/bodypart/leg/left/moorman
	icon_greyscale = 'modular_z121/icons/mob/bodyparts/Moorman_parts_greyscale.dmi'
	limb_id = SPECIES_MOORMAN
	max_damage = 30
	unarmed_damage_low = MOORMAN_KICK_LOW
	unarmed_damage_high = MOORMAN_KICK_HIGH
	brute_modifier = MOORMAN_BRUTE_MODIFIER
	unarmed_attack_sound = 'sound/items/weapons/genhit1.ogg'

/obj/item/bodypart/leg/right/moorman
	icon_greyscale = 'modular_z121/icons/mob/bodyparts/Moorman_parts_greyscale.dmi'
	limb_id = SPECIES_MOORMAN
	max_damage = 30
	unarmed_damage_low = MOORMAN_KICK_LOW
	unarmed_damage_high = MOORMAN_KICK_HIGH
	brute_modifier = MOORMAN_BRUTE_MODIFIER
	unarmed_attack_sound = 'sound/items/weapons/genhit1.ogg'
