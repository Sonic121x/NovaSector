
/obj/machinery/biogenerator/food_replicator
	name = "\improper Pioneer-Class Matter Resequencer"
	desc = "A modern Heliostatic Coalition resequencer unit, producing civilian necessities through controlled organic transmutation. Its streamlined \
	casing bears little resemblance to the original colonization era designs."
	icon = 'modular_nova/modules/food_replicator/icons/biogenerator.dmi'
	circuit = /obj/item/circuitboard/machine/biogenerator/food_replicator
	show_categories = list(
		RND_CATEGORY_HC_FOOD,
		RND_CATEGORY_HC_MEDICAL,
		RND_CATEGORY_HC_CLOTHING,
	)

/obj/machinery/biogenerator/food_replicator/examine_more(mob/user)
	. = ..()

	. += LANG("obj.4cdeddea55e3b2cb", null)

	. += LANG("obj.4aba111b42cbeaf2", null)

	return .

/obj/machinery/biogenerator/food_replicator/RefreshParts()
	. = ..()
	efficiency *= 0.75
	productivity *= 0.75

/obj/item/circuitboard/machine/biogenerator/food_replicator
	name = "Pioneer-Class Matter Resequencer"
	build_path = /obj/machinery/biogenerator/food_replicator

/obj/item/flatpack/food_replicator
	name = "pioneer matter resequencer"
	board = /obj/item/circuitboard/machine/biogenerator/food_replicator
