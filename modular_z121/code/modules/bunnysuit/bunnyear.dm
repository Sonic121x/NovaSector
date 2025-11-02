//ALL BUNNY STUFF BY DimWhat OF MONKEESTATION

/obj/item/clothing/head/playbunnyears
	name = "bunny ears headband"
	desc = "A pair of bunny ears attached to a headband. One of the ears is already crooked."
	icon = 'modular_z121/icons/obj/clothing/bunny/head/bunnyears.dmi'
	worn_icon = 'modular_z121/icons/mob/clothing/bunny/head/bunnyears.dmi'
	icon_state = "bar"

/obj/item/clothing/head/playbunnyears/greyscale
	name = "bunny ears headband"
	desc = "A pair of bunny ears attached to a headband. One of the ears is already crooked."
	icon_state = "playbunny_ears"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	greyscale_colors = "#39393f"
	greyscale_config = /datum/greyscale_config/playbunnyears
	greyscale_config_worn = /datum/greyscale_config/playbunnyears_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/playbunnyears/syndicate
	name = "blood-red bunny ears headband"
	desc = "An unusually suspicious pair of bunny ears attached to a headband. The headband looks reinforced with plasteel... but why?"
	icon_state = "syndibunny_ears"

/obj/item/clothing/head/playbunnyears/syndicate/real
	clothing_flags = SNUG_FIT
	armor_type = /datum/armor/head_helmet

/obj/item/clothing/head/playbunnyears/centcom
	name = "centcom bunny ears headband"
	desc = "A pair of very professional bunny ears attached to a headband. The ears themselves came from an endangered species of green rabbits."
	icon_state = "playbunny_ears_centcom"

/obj/item/clothing/head/playbunnyears/british
	name = "british bunny ears headband"
	desc = "A pair of classy bunny ears attached to a headband. Worn to honor the crown."
	icon_state = "playbunny_ears_brit"

/obj/item/clothing/head/playbunnyears/communist
	name = "really red bunny ears headband"
	desc = "A pair of red and gold bunny ears attached to a headband. Commonly used by any collectivizing bunny waiters."
	icon_state = "playbunny_ears_communist"

/obj/item/clothing/head/playbunnyears/usa
	name = "usa bunny ears headband"
	desc = "A pair of star spangled bunny ears attached to a headband. The headband of a true patriot."
	icon_state = "playbunny_ears_usa"

//CAPTAIN

/obj/item/clothing/head/hats/caphat/bunnyears_captain
	name = "captain's bunny ears"
	desc = "A pair of dark blue bunny ears attached to a headband. Worn in lieu of the more traditional bicorn hat."
	icon_state = "captain"
	inhand_icon_state = "that"
	icon = 'modular_z121/icons/obj/clothing/bunny/head/bunnyears.dmi'
	worn_icon = 'modular_z121/icons/mob/clothing/bunny/head/bunnyears.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	dog_fashion = null

//CARGO

/obj/item/clothing/head/playbunnyears/quartermaster
	name = "quartermaster's bunny ears"
	desc = "Brown and gray bunny ears attached to a headband. The brown headband denotes relative importance."
	icon_state = "qm"

/obj/item/clothing/head/playbunnyears/cargo
	name = "cargo bunny ears"
	desc = "Brown and gray bunny ears attached to a headband. The gray headband denotes relative unimportance."
	icon_state = "cargo_tech"

/obj/item/clothing/head/playbunnyears/miner
	name = "shaft miner's bunny ears"
	desc = "Muddy gray bunny ears attached to a headband. Has zero resistance against the hostile lavaland atmosphere."
	icon_state = "explorer"
	armor_type = /datum/armor/hooded_explorer

/obj/item/clothing/head/playbunnyears/mailman
	name = "mailman's bunny ears"
	desc = "Blue and red bunny ears attached to a headband. Shows everyone your commitment to speed and efficiency."
	icon_state = "mail"

/obj/item/clothing/head/playbunnyears/bitrunner
	name = "bunrunner's bunny ears"
	desc = "Black and gold with stains of space mountain. The official wear of the Carota E-Sports team."
	icon_state = "bitrunner"

//ENGI

/obj/item/clothing/head/playbunnyears/engineer
	name = "engineering bunny ears"
	desc = "Yellow and orange bunny ears attached to a headband. Likely to get caught in heavy machinery."
	icon_state = "engi"

/obj/item/clothing/head/playbunnyears/atmos_tech
	name = "atmospheric technician's bunny ears"
	desc = "Yellow and blue bunny ears attached to a headband. Gives zero protection against both fires and extreme pressures."
	icon_state = "atmos"

/obj/item/clothing/head/playbunnyears/ce
	name = "chief engineer's bunny ears"
	desc = "Green and white bunny ears attached to a headband. Just keep them away from the supermatter."
	icon_state = "ce"

//MEDICAL

/obj/item/clothing/head/playbunnyears/doctor
	name = "medical bunny ears"
	desc = "White and blue bunny ears attached to a headband. Certainly cuter than a head mirror."
	icon_state = "doctor"

/obj/item/clothing/head/playbunnyears/paramedic
	name = "paramedic's bunny ears"
	desc = "Blue and white bunny ears attached to a headband. Marks you clearly as a bunny first responder, allowing you a high degree of respect and deference�� yeah right."
	icon_state = "paramedic"

/obj/item/clothing/head/playbunnyears/chemist
	name = "chemist's bunny ears"
	desc = "White and orange bunny ears attached to a headband. One of the ears is already crooked."
	icon_state = "chem"

/obj/item/clothing/head/playbunnyears/pathologist
	name = "pathologist's bunny ears"
	desc = "White and green bunny ears attached to a headband. This is not proper PPE gear."
	icon_state = "virologist"

/obj/item/clothing/head/playbunnyears/coroner
	name = "coroner's bunny ears"
	desc = "Black and white bunny ears attached to a headband. Please don't wear this to a funeral."
	icon_state = "coroner"

/obj/item/clothing/head/playbunnyears/cmo
	name = "chief medical officer's bunny ears"
	desc = "White and blue bunny ears attached to a headband. A headband that commands respect from the entire medical team."
	icon_state = "cmo"

//SCIENCE

/obj/item/clothing/head/playbunnyears/scientist
	name = "scientist's bunny ears"
	desc = "Purple and white bunny ears attached to a headband. Completes the look for lagomorphic studies."
	icon_state = "science"

/obj/item/clothing/head/playbunnyears/roboticist
	name = "roboticist's bunny ears"
	desc = "Black and red bunny ears attached to a headband. Installed with servos to imitate the movement of real bunny ears."
	icon_state = "roboticist"

/obj/item/clothing/head/playbunnyears/geneticist
	name = "geneticist's bunny ears"
	desc = "Blue and white bunny ears attached to a headband. For when you have no bunnies to splice your genes with."
	icon_state = "genetics"

/obj/item/clothing/head/playbunnyears/rd
	name = "research director's bunny ears"
	desc = "Purple and black bunny ears attached to a headband. Large amounts of funding went into creating a piece of headgear capable of increasing the wearers height, this is what was produced."
	icon_state = "rd"

//SECURITY

/obj/item/clothing/head/playbunnyears/security
	name = "security bunny ears"
	desc = "Red and black bunny ears attached to a headband. The band is made out of hardened steel."
	icon_state = "sec"
	clothing_flags = SNUG_FIT
	armor_type = /datum/armor/head_helmet


/obj/item/clothing/head/playbunnyears/security/assistant
	name = "security assistant's bunny ears"
	desc = "A pair of red and grey bunny ears attatched to a headband. Snugly fit, to keep it attatched during long distance tackles."
	icon_state = "sec_assistant"

//TODO: Find a way to add Warden stuff that isn't hack-y.

/obj/item/clothing/head/playbunnyears/warden
	name = "warden's bunny ears"
	desc = "Red and white bunny ears attached to a headband. Keeps the hair out of the face when checking on cameras."
	icon_state = "warden"
	clothing_flags = SNUG_FIT
	armor_type = /datum/armor/head_helmet

/obj/item/clothing/head/playbunnyears/brig_phys
	name = "brig physician's bunny ears"
	desc = "A pair of red and grey bunny ears attatched to a headband. Whoever's wearing these is surely a professional... right?"
	icon_state = "brig_phys"

/obj/item/clothing/head/playbunnyears/detective
	name = "detective's bunny ears"
	desc = "Brown bunny ears attached to a headband. Big ears for listening to calls from hysteric dames."
	icon_state = "detective"
	armor_type = /datum/armor/fedora_det_hat


/obj/item/clothing/head/playbunnyears/detective/noir
	name = "noir detective's bunny ears"
	desc = "Black bunny ears attached to a white headband. Big ears for listening to calls from hysteric dames. In glorious black and white!"
	icon_state = "detective_noir"

/obj/item/clothing/head/playbunnyears/prisoner
	name = "prisoner's bunny ears"
	desc = "Black and orange bunny ears attached to a headband. This outfit was long ago outlawed under the space geneva convention for being a cruel and unusual punishment."
	icon_state = "prisoner"

/obj/item/clothing/head/playbunnyears/hos
	name = "head of security's bunny ears"
	desc = "Red and gold bunny ears attached to a headband. Shows your authority over all bunny officers."
	icon_state = "hos"
	clothing_flags = SNUG_FIT
	armor_type = /datum/armor/hats_hos

//SERVICE

/obj/item/clothing/head/playbunnyears/hop
	name = "head of personnel's bunny ears"
	desc = "A pair of muted blue bunny ears attached to a headband. The preferred color of bunnycrats everywhere."
	icon_state = "hop"
	armor_type = /datum/armor/hats_hopcap

/obj/item/clothing/head/playbunnyears/janitor
	name = "janitor's bunny ears"
	desc = "A pair of purple bunny ears attached to a headband. Kept meticulously clean."
	icon_state = "janitor"

/obj/item/clothing/head/playbunnyears/bartender
	name = "bartender's bunny ears"
	desc = "A pair of classy black and white bunny ears attached to a headband. They smell faintly of alchohol."
	icon_state = "bar"

/obj/item/clothing/head/playbunnyears/cook
	name = "cook's bunny ears"
	desc = "A pair of white and red bunny ears attached to a headband. Helps keep hair out of the food."
	icon_state = "chef"

/obj/item/clothing/head/playbunnyears/botanist
	name = "botanist's bunny ears"
	desc = "A pair of green and blue bunny ears attached to a headband. Good for keeping the sweat out of your eyes during long days on the farm."
	icon_state = "botany"

/obj/item/clothing/head/playbunnyears/clown
	name = "clown's bunny ears"
	desc = "A pair of orange and pink bunny ears. They even squeak."
	icon_state = "clown"

/obj/item/clothing/head/playbunnyears/mime
	name = "mime's bunny ears"
	desc = "Red and black bunny ears attached to a headband. Great for street performers sick of the standard beret."
	icon_state = "mime"

/obj/item/clothing/head/playbunnyears/chaplain
	name = "chaplain's bunny ears"
	desc = "A pair of black and white bunny ears attached to a headband. Worn in worship of The Gardener of Carota."
	icon_state = "chaplain"

/obj/item/clothing/head/playbunnyears/curator_red
	name = "curator's red bunny ears"
	desc = "A pair of red and beige bunny ears attached to a headband. Marks you as an expert in all things bunny related."
	icon_state = "curator_red"

/obj/item/clothing/head/playbunnyears/curator_green
	name = "curator's green bunny ears"
	desc = "A pair of green and black bunny ears attached to a headband. Marks you as an expert in all things bunny related."
	icon_state = "curator_green"

/obj/item/clothing/head/playbunnyears/curator_teal
	name = "curator's teal bunny ears"
	desc = "A pair of teal bunny ears attached to a headband. Marks you as an expert in all things bunny related."
	icon_state = "curator_teal"

/obj/item/clothing/head/playbunnyears/lawyer_black
	name = "lawyer's black bunny ears"
	desc = "A pair of black bunny ears attached to a headband. The perfect headband to wear while negotiating a settlement."
	icon_state = "lawyer_black"

/obj/item/clothing/head/playbunnyears/lawyer_blue
	name = "lawyer's blue bunny ears"
	desc = "A pair of blue and white bunny ears attached to a headband. The perfect headband to wear while negotiating a settlement."
	icon_state = "lawyer_blue"

/obj/item/clothing/head/playbunnyears/lawyer_red
	name = "lawyer's red bunny ears"
	desc = "A pair of red and white bunny ears attached to a headband. The perfect headband to wear while negotiating a settlement."
	icon_state = "lawyer_red"

/obj/item/clothing/head/playbunnyears/lawyer_good
	name = "good lawyer's bunny ears"
	desc = "A pair of beige and blue bunny ears attached to a headband. The perfect headband to wear while negotiating a settlement."
	icon_state = "lawyer_good"

/obj/item/clothing/head/playbunnyears/psychologist
	name = "psychologist's bunny ears"
	desc = "A pair of black bunny ears. And how do they make you feel?"
	icon_state = "psychologist"

//BUNNY STUFF END, SPRITES BY DimWhat OF MONKE STATION