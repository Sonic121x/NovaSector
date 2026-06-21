/obj/item/petri_dish/oldstation
	name = "莫莉的活体组织切片"
	desc = "你能看到培养皿里有一块发霉的三明治。也许这有助于细菌保存这么久。"

/obj/item/petri_dish/oldstation/Initialize(mapload)
	. = ..()
	sample = new
	sample.GenerateSample(CELL_LINE_TABLE_COW, null, 1, 0)
	var/datum/biological_sample/contamination = new
	contamination.GenerateSample(CELL_LINE_TABLE_GRAPE, null, 1, 0)
	sample.Merge(contamination)
	sample.sample_color = COLOR_SAMPLE_BROWN
	update_appearance()

/obj/item/reagent_containers/cup/beaker/oldstation
	name = "培养液"
	amount_per_transfer_from_this = 50
	list_reagents = list(
		// Required for CELL_LINE_TABLE_COW
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/cellulose = 5,
		// Required for CELL_LINE_TABLE_GRAPE
		/datum/reagent/toxin/slimejelly = 5,
		/datum/reagent/yuck = 5,
		/datum/reagent/consumable/vitfro = 5,
		// Supplementary for CELL_LINE_TABLE_GRAPE
		/datum/reagent/consumable/liquidgibs = 5
	)
