//Not to be confused with /obj/item/reagent_containers/cup/glass/bottle

/obj/item/reagent_containers/cup/bottle
	name = "瓶子"
	desc = "一个小瓶子。"
	icon_state = "bottle"
	fill_icon_state = "bottle"
	inhand_icon_state = "atoxinbottle"
	worn_icon_state = "bottle"
	obj_flags = UNIQUE_RENAME | RENAME_NO_DESC
	possible_transfer_amounts = list(5, 10, 15, 25, 50)
	volume = 50
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)
	can_lid = TRUE
	assembly_pixel_y = 4

/obj/item/reagent_containers/cup/bottle/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "bottle"
	update_appearance()

/obj/item/reagent_containers/cup/bottle/epinephrine
	name = "肾上腺素瓶-'Epinephrine'"
	desc = "小瓶子。内含肾上腺素——用于稳定患者病情。"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30)

/obj/item/reagent_containers/cup/bottle/toxin
	name = "毒素瓶-'Toxin'"
	desc = "一小瓶有毒物质。切勿饮用，有毒。"
	list_reagents = list(/datum/reagent/toxin = 30)

/obj/item/reagent_containers/cup/bottle/cyanide
	name = "氰化物瓶-'Cyanide'"
	desc = "一小瓶氰化物。苦杏仁？"
	list_reagents = list(/datum/reagent/toxin/cyanide = 30)

/obj/item/reagent_containers/cup/bottle/anacea
	name = "anacea bottle"
	desc = "A small bottle of anacea."
	list_reagents = list(/datum/reagent/toxin/anacea = 30)

/obj/item/reagent_containers/cup/bottle/spewium
	name = "喷吐素瓶-'spewium'"
	desc = "一小瓶喷吐素。"
	list_reagents = list(/datum/reagent/toxin/spewium = 30)

/obj/item/reagent_containers/cup/bottle/syndol
	name = "syndol bottle"
	desc = "A small bottle of syndol."
	list_reagents = list(/datum/reagent/drug/syndol = 30)

/obj/item/reagent_containers/cup/bottle/morphine
	name = "吗啡瓶-'Morphine'"
	desc = "一小瓶吗啡。"
	icon = 'icons/obj/medical/chemical.dmi'
	list_reagents = list(/datum/reagent/medicine/morphine = 30)

/obj/item/reagent_containers/cup/bottle/chloralhydrate
	name = "chloral hydrate bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon_state = "bottle20"
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 15)

/obj/item/reagent_containers/cup/bottle/mannitol
	name = "甘露醇瓶-'Mannitol'"
	desc = "一小瓶甘露醇。用于治疗脑损伤。"
	list_reagents = list(/datum/reagent/medicine/mannitol = 30)

/obj/item/reagent_containers/cup/bottle/multiver
	name = "木太尔瓶-'Multiver'"
	desc = "一小瓶“木太尔”，它能清除血液中的毒素及其他化学物质，但会导致呼吸短促。所有效果均随患者体内该药剂的含量而增强。"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 30)

/obj/item/reagent_containers/cup/bottle/calomel
	name = "甘汞瓶-'Calomel'"
	desc = "A small bottle of calomel, a toxic drug which quickly removes chemicals from the bloodstream. Does not cause additional harm in heavily-injured people."
	list_reagents = list(/datum/reagent/medicine/calomel = 30)

/obj/item/reagent_containers/cup/bottle/phlogiston
	name = "Phlogiston bottle"
	desc = "一小瓶燃素，用了会把你点着的。"
	list_reagents = list(/datum/reagent/phlogiston = 30)

/obj/item/reagent_containers/cup/bottle/ammoniated_mercury
	name = "ammoniated mercury bottle"
	desc = "Quickly purges the body of toxic chemicals. Heals toxin damage when in a good condition someone has \
		no brute and fire damage. When hurt with brute or fire damage, it can deal a great amount of toxin damage. \
		When there are no toxins present, it starts slowly purging itself."
	list_reagents = list(/datum/reagent/medicine/ammoniated_mercury = 30)

/obj/item/reagent_containers/cup/bottle/syriniver
	name = "塞维尔瓶-'Syriniver'"
	desc = "一小瓶塞维尔。"
	list_reagents = list(/datum/reagent/medicine/c2/syriniver = 30)

/obj/item/reagent_containers/cup/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "一小瓶不稳定的诱变剂。会随机改变任何接触者的DNA结构。"
	list_reagents = list(/datum/reagent/toxin/mutagen = 30)

/obj/item/reagent_containers/cup/bottle/plasma
	name = "液态等离子体瓶"
	desc = "一小瓶液态等离子体。剧毒，可与血液内的微生物发生反应。"
	list_reagents = list(/datum/reagent/toxin/plasma = 30)

/obj/item/reagent_containers/cup/bottle/synaptizine
	name = "synaptizine bottle"
	desc = "一瓶突触蛋白"
	list_reagents = list(/datum/reagent/medicine/synaptizine = 30)

/obj/item/reagent_containers/cup/bottle/ammonia
	name = "氨瓶"
	desc = "一小瓶氨。"
	list_reagents = list(/datum/reagent/ammonia = 30)

/obj/item/reagent_containers/cup/bottle/diethylamine
	name = "二乙胺瓶"
	desc = "一小瓶二乙胺。"
	list_reagents = list(/datum/reagent/diethylamine = 30)

/obj/item/reagent_containers/cup/bottle/facid
	name = "氟硫酸瓶"
	desc = "小瓶子。内含少量氟硫酸。"
	list_reagents = list(/datum/reagent/toxin/acid/fluacid = 30)

/obj/item/reagent_containers/cup/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "一个小瓶子。里面装着神明的精华液体。"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "holyflask"
	inhand_icon_state = "holyflask"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 30)

/obj/item/reagent_containers/cup/bottle/capsaicin
	name = "辣椒油瓶"
	desc = "一个小瓶子。里面装有辛辣的酱汁。"
	list_reagents = list(/datum/reagent/consumable/capsaicin = 30)

/obj/item/reagent_containers/cup/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "一个小瓶子。里面装有冰冷的酱汁。"
	list_reagents = list(/datum/reagent/consumable/frostoil = 30)

/obj/item/reagent_containers/cup/bottle/strange_reagent
	name = "Strange Reagent Bottle"
	desc = "A small bottle. May be used to revive people."
	list_reagents = list(/datum/reagent/medicine/strange_reagent = 30)

/obj/item/reagent_containers/cup/bottle/fishy_reagent
	name = "Fishy Reagent Bottle"
	desc = "A small bottle. May be used to revive fish."
	list_reagents = list(/datum/reagent/medicine/strange_reagent/fishy_reagent = 30)

/obj/item/reagent_containers/cup/bottle/traitor
	name = "syndicate bottle"
	desc = "一个小瓶子。里面装着一种随机的、令人不适（或有害）的化学品。"
	icon = 'icons/obj/medical/chemical.dmi'
	var/extra_reagent = null

/obj/item/reagent_containers/cup/bottle/traitor/Initialize(mapload)
	. = ..()
	extra_reagent = pick(/datum/reagent/toxin/polonium, /datum/reagent/toxin/histamine, /datum/reagent/toxin/formaldehyde, /datum/reagent/toxin/venom, /datum/reagent/toxin/fentanyl, /datum/reagent/toxin/cyanide)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/reagent_containers/cup/bottle/polonium
	name = "polonium bottle"
	desc = "小瓶装。含有钋。"
	list_reagents = list(/datum/reagent/toxin/polonium = 30)

/obj/item/reagent_containers/cup/bottle/magillitis
	name = "magillitis bottle"
	desc = "A small bottle. Contains a serum known only as 'magillitis'."
	list_reagents = list(/datum/reagent/magillitis = 5)

/obj/item/reagent_containers/cup/bottle/venom
	name = "毒液瓶-'Venom'"
	desc = "一个小瓶子。里面装有毒液。"
	list_reagents = list(/datum/reagent/toxin/venom = 30)

/obj/item/reagent_containers/cup/bottle/fentanyl
	name = "芬太尼瓶-'fentanyl'"
	desc = "小瓶装。含有芬太尼。"
	list_reagents = list(/datum/reagent/toxin/fentanyl = 30)

/obj/item/reagent_containers/cup/bottle/formaldehyde
	name = "formaldehyde bottle"
	desc = "一个小瓶子，里面装有甲醛，一种具有防腐作用的化学物质。"
	list_reagents = list(/datum/reagent/toxin/formaldehyde = 30)

/obj/item/reagent_containers/cup/bottle/initropidril
	name = "initropidril bottle"
	desc = "一个小瓶子。包含心急停。"
	list_reagents = list(/datum/reagent/toxin/initropidril = 30)

/obj/item/reagent_containers/cup/bottle/pancuronium
	name = "pancuronium bottle"
	desc = "一个小瓶子。含有泮库溴铵"
	list_reagents = list(/datum/reagent/toxin/pancuronium = 30)

/obj/item/reagent_containers/cup/bottle/sodium_thiopental
	name = "sodium thiopental bottle"
	desc = "一瓶硫喷妥钠"
	list_reagents = list(/datum/reagent/toxin/sodium_thiopental = 30)

/obj/item/reagent_containers/cup/bottle/coniine
	name = "毒芹碱瓶-'coniine'"
	desc = "一瓶毒芹碱"
	list_reagents = list(/datum/reagent/toxin/coniine = 30)

/obj/item/reagent_containers/cup/bottle/curare
	name = "curare bottle"
	desc = "一瓶箭毒"
	list_reagents = list(/datum/reagent/toxin/curare = 30)

/obj/item/reagent_containers/cup/bottle/amanitin
	name = "鹅膏菌素瓶'amanitin'"
	desc = "一瓶鹅膏菌素"
	list_reagents = list(/datum/reagent/toxin/amanitin = 30)

/obj/item/reagent_containers/cup/bottle/histamine
	name = "histamine bottle"
	desc = "一瓶组胺"
	list_reagents = list(/datum/reagent/toxin/histamine = 30)

/obj/item/reagent_containers/cup/bottle/carnivorous_blood
	name = "carnivorous blood bottle"
	desc = "A small bottle. Contains carnivorous blood."
	list_reagents = list(/datum/reagent/toxin/carnivorousblood = 30)

/obj/item/reagent_containers/cup/bottle/diphenhydramine
	name = "antihistamine bottle"
	desc = "一瓶抗组胺"
	list_reagents = list(/datum/reagent/medicine/diphenhydramine = 30)

/obj/item/reagent_containers/cup/bottle/potass_iodide
	name = "防辐射瓶-'Potassium Iodide'"
	desc = "一小瓶碘化钾。"
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 30)

/obj/item/reagent_containers/cup/bottle/salglu_solution
	name = "saline-glucose solution bottle"
	desc = "一小瓶葡萄糖溶液。"
	list_reagents = list(/datum/reagent/medicine/salglu_solution = 30)

/obj/item/reagent_containers/cup/bottle/atropine
	name = "Atropine-阿托品瓶"
	desc = "一小瓶阿托品。"
	list_reagents = list(/datum/reagent/medicine/atropine = 30)

/obj/item/reagent_containers/cup/bottle/random_buffer
	name = "缓冲液瓶"
	desc = "一小瓶化学缓冲剂。"

/obj/item/reagent_containers/cup/bottle/random_buffer/Initialize(mapload)
	. = ..()
	if(prob(50))
		name = "酸性缓冲液瓶-'Acidic buffer'"
		desc = "一小瓶酸性缓冲液"
		reagents.add_reagent(/datum/reagent/reaction_agent/acidic_buffer, 30)
	else
		name = "基础碱缓冲液瓶-'Basic buffer'"
		desc = "一小瓶基础碱缓冲液"
		reagents.add_reagent(/datum/reagent/reaction_agent/basic_buffer, 30)

/obj/item/reagent_containers/cup/bottle/acidic_buffer
	name = "酸性缓冲液瓶-'Acidic buffer'"
	desc = "一小瓶酸性缓冲液"
	list_reagents = list(/datum/reagent/reaction_agent/acidic_buffer = 30)

/obj/item/reagent_containers/cup/bottle/basic_buffer
	name = "基础碱缓冲液瓶-'Basic buffer'"
	desc = "一小瓶基础碱缓冲液"
	list_reagents = list(/datum/reagent/reaction_agent/basic_buffer = 30)

/obj/item/reagent_containers/cup/bottle/inversing_buffer
	name = "Chiral inversing buffer bottle"
	desc = "A small bottle of chiral inversing buffer."
	list_reagents = list(/datum/reagent/reaction_agent/inversing_buffer = 30)

/obj/item/reagent_containers/cup/bottle/romerol
	name = "romerol bottle"
	desc = "一小瓶罗梅罗。这才是真正的尸粉。"
	list_reagents = list(/datum/reagent/romerol = 30)

/obj/item/reagent_containers/cup/bottle/moltobeso
	name = "Molt'Obeso bottle"
	desc = "The revolutionary new sauce from Syndicate's culinary experts, designed to instantly reshape your figure! \
			The key to the effectiveness of this product lies in its unique formulation, which combines carefully selected ingredients to stimulate appetite and enhance the absorption of calories."
	list_reagents = list(/datum/reagent/consumable/moltobeso = 50)

/obj/item/reagent_containers/cup/bottle/random_virus
	name = "Experimental disease culture bottle"
	desc = "一个小合成血培养基。其中含有未经测试的病毒培养物。"
	spawned_disease = /datum/disease/advance/random

/obj/item/reagent_containers/cup/bottle/pierrot_throat
	name = "Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	spawned_disease = /datum/disease/pierrot_throat

/obj/item/reagent_containers/cup/bottle/cold
	name = "鼻病毒培养瓶-'Rhinovirus'"
	desc = "一个合成血培养基。含有xy -鼻病毒培养物。"
	spawned_disease = /datum/disease/advance/cold

/obj/item/reagent_containers/cup/bottle/flu_virion
	name = "流感病毒培养瓶-'Flu virion'"
	desc = "一个合成血培养基。含有H13N1流感病毒粒子培养物。"
	spawned_disease = /datum/disease/advance/flu

/obj/item/reagent_containers/cup/bottle/retrovirus
	name = "逆转录病毒培养瓶-'Retrovirus'"
	desc = "一个合成血培养基。含有逆转录病毒培养物。"
	spawned_disease = /datum/disease/dna_retrovirus

/obj/item/reagent_containers/cup/bottle/gbs
	name = "吉兰 - 巴雷综合征培养瓶-'GBS culture bottle'"
	desc = "一个合成血培养基。含有重力动力学双势SADS+培养物。"//Or simply - General BullShit
	amount_per_transfer_from_this = 5
	spawned_disease = /datum/disease/gbs

/obj/item/reagent_containers/cup/bottle/fake_gbs
	name = "吉兰 - 巴雷综合征培养瓶-'GBS culture bottle'"
	desc = "一个合成血培养基。含有重力动力学双势SADS+培养物。"//Or simply - General BullShit
	spawned_disease = /datum/disease/fake_gbs

/obj/item/reagent_containers/cup/bottle/brainrot
	name = "脑腐病培养瓶-'Brainrot'"
	desc = "一个合成血培养基。含有脑腐病菌。"
	icon_state = "bottle3"
	spawned_disease = /datum/disease/brainrot

/obj/item/reagent_containers/cup/bottle/magnitis
	name = "磁侵症培养瓶-'Magnitis'"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	spawned_disease = /datum/disease/magnitis

/obj/item/reagent_containers/cup/bottle/wizarditis
	name = "巫师培养瓶-'Wizarditis'"
	desc = "一个小小的瓶子。里面含有巫师综合症。"
	spawned_disease = /datum/disease/wizarditis

/obj/item/reagent_containers/cup/bottle/anxiety
	name = "Severe Anxiety culture bottle"
	desc = "A small bottle. Contains a sample of Lepidopticides."
	spawned_disease = /datum/disease/anxiety

/obj/item/reagent_containers/cup/bottle/beesease
	name = "Beesease culture bottle"
	desc = "A small bottle. Contains a sample of invasive Apidae."
	spawned_disease = /datum/disease/beesease

/obj/item/reagent_containers/cup/bottle/fluspanish
	name = "西班牙流感病毒培养瓶-'Spanish'"
	desc = "A small bottle. Contains a sample of Inquisitius."
	spawned_disease = /datum/disease/fluspanish

/obj/item/reagent_containers/cup/bottle/tuberculosis
	name = "Fungal Tuberculosis culture bottle"
	desc = "A small bottle. Contains a sample of Fungal Tubercle bacillus."
	spawned_disease = /datum/disease/tuberculosis

/obj/item/reagent_containers/cup/bottle/tuberculosiscure
	name = "真菌性结核病疫苗培养瓶-‘BVAK’"
	desc = "A small bottle containing Bio Virus Antidote Kit."
	list_reagents = list(/datum/reagent/vaccine/fungal_tb = 30)

//Oldstation.dmm chemical storage bottles

/obj/item/reagent_containers/cup/bottle/hydrogen
	name = "hydrogen bottle"
	list_reagents = list(/datum/reagent/hydrogen = 30)

/obj/item/reagent_containers/cup/bottle/lithium
	name = "lithium bottle"
	list_reagents = list(/datum/reagent/lithium = 30)

/obj/item/reagent_containers/cup/bottle/carbon
	name = "carbon bottle"
	list_reagents = list(/datum/reagent/carbon = 30)

/obj/item/reagent_containers/cup/bottle/nitrogen
	name = "nitrogen bottle"
	list_reagents = list(/datum/reagent/nitrogen = 30)

/obj/item/reagent_containers/cup/bottle/oxygen
	name = "oxygen bottle"
	list_reagents = list(/datum/reagent/oxygen = 30)

/obj/item/reagent_containers/cup/bottle/fluorine
	name = "fluorine bottle"
	list_reagents = list(/datum/reagent/fluorine = 30)

/obj/item/reagent_containers/cup/bottle/sodium
	name = "sodium bottle"
	list_reagents = list(/datum/reagent/sodium = 30)

/obj/item/reagent_containers/cup/bottle/aluminium
	name = "aluminium bottle"
	list_reagents = list(/datum/reagent/aluminium = 30)

/obj/item/reagent_containers/cup/bottle/silicon
	name = "silicon bottle"
	list_reagents = list(/datum/reagent/silicon = 30)

/obj/item/reagent_containers/cup/bottle/phosphorus
	name = "phosphorus bottle"
	list_reagents = list(/datum/reagent/phosphorus = 30)

/obj/item/reagent_containers/cup/bottle/sulfur
	name = "sulfur bottle"
	list_reagents = list(/datum/reagent/sulfur = 30)

/obj/item/reagent_containers/cup/bottle/chlorine
	name = "chlorine bottle"
	list_reagents = list(/datum/reagent/chlorine = 30)

/obj/item/reagent_containers/cup/bottle/potassium
	name = "potassium bottle"
	list_reagents = list(/datum/reagent/potassium = 30)

/obj/item/reagent_containers/cup/bottle/iron
	name = "Iron-铁瓶"
	list_reagents = list(/datum/reagent/iron = 30)

/obj/item/reagent_containers/cup/bottle/copper
	name = "copper bottle"
	list_reagents = list(/datum/reagent/copper = 30)

/obj/item/reagent_containers/cup/bottle/mercury
	name = "mercury bottle"
	list_reagents = list(/datum/reagent/mercury = 30)

/obj/item/reagent_containers/cup/bottle/radium
	name = "radium bottle"
	list_reagents = list(/datum/reagent/uranium/radium = 30)

/obj/item/reagent_containers/cup/bottle/water
	name = "water bottle"
	list_reagents = list(/datum/reagent/water = 30)

/obj/item/reagent_containers/cup/bottle/ethanol
	name = "ethanol bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol = 30)

/obj/item/reagent_containers/cup/bottle/sugar
	name = "sugar bottle"
	list_reagents = list(/datum/reagent/consumable/sugar = 30)

/obj/item/reagent_containers/cup/bottle/sacid
	name = "sulfuric acid bottle"
	list_reagents = list(/datum/reagent/toxin/acid = 30)

/obj/item/reagent_containers/cup/bottle/welding_fuel
	name = "WeldingFuel-焊料瓶"
	list_reagents = list(/datum/reagent/fuel = 30)

/obj/item/reagent_containers/cup/bottle/silver
	name = "silver bottle"
	list_reagents = list(/datum/reagent/silver = 30)

/obj/item/reagent_containers/cup/bottle/iodine
	name = "iodine bottle"
	list_reagents = list(/datum/reagent/iodine = 30)

/obj/item/reagent_containers/cup/bottle/bromine
	name = "bromine bottle"
	list_reagents = list(/datum/reagent/bromine = 30)

/obj/item/reagent_containers/cup/bottle/thermite
	name = "Thermite-铝热剂瓶"
	list_reagents = list(/datum/reagent/thermite = 50)

// Bottles for mail goodies.

/obj/item/reagent_containers/cup/bottle/clownstears
	name = "bottle of distilled clown misery"
	desc = "A small bottle. Contains a mythical liquid used by sublime bartenders; made from the unhappiness of clowns."
	list_reagents = list(/datum/reagent/consumable/nutriment/soup/clown_tears = 30)

/obj/item/reagent_containers/cup/bottle/saltpetre
	name = "saltpetre bottle"
	desc = "A small bottle. Contains saltpetre."
	list_reagents = list(/datum/reagent/saltpetre = 30)

/obj/item/reagent_containers/cup/bottle/flash_powder
	name = "闪光粉瓶"
	desc = "一个小瓶子。里面装有闪光粉。"
	list_reagents = list(/datum/reagent/flash_powder = 30)

/obj/item/reagent_containers/cup/bottle/exotic_stabilizer
	name = "exotic stabilizer bottle"
	desc = "A small bottle. Contains exotic stabilizer."
	list_reagents = list(/datum/reagent/exotic_stabilizer = 30)

/obj/item/reagent_containers/cup/bottle/leadacetate
	name = "lead acetate bottle"
	desc = "A small bottle. Contains lead acetate."
	list_reagents = list(/datum/reagent/toxin/leadacetate = 30)

/obj/item/reagent_containers/cup/bottle/caramel
	name = "一瓶焦糖"
	desc = "A bottle containing caramelized sugar, also known as caramel. Do not lick."
	list_reagents = list(/datum/reagent/consumable/caramel = 30)

/*
 *	Syrup bottles, basically a unspillable cup that transfers reagents upon clicking on it with a cup
 */

/obj/item/reagent_containers/cup/bottle/syrup_bottle
	name = "syrup bottle"
	desc = "A bottle with a syrup pump to dispense the delicious substance directly into your coffee cup."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "syrup"
	fill_icon_state = "syrup"
	fill_icon_thresholds = list(0, 20, 40, 60, 80, 100)
	possible_transfer_amounts = list(5, 10)
	amount_per_transfer_from_this = 5
	can_lid = FALSE

/obj/item/reagent_containers/cup/bottle/syrup_bottle/Initialize(mapload)
	. = ..()
	register_context()
	// this is not done via initial_reagent_flags because it represents state
	update_container_flags(SEALED_CONTAINER | TRANSPARENT)

/obj/item/reagent_containers/cup/bottle/syrup_bottle/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click to toggle the pump cap.")
	. += span_notice("Use a pen on it to rename it.")

/obj/item/reagent_containers/cup/bottle/syrup_bottle/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	context[SCREENTIP_CONTEXT_ALT_LMB] = (is_open_container() ? "Add Pump Cap" : "Remove Pump Cap")
	if(IS_WRITING_UTENSIL(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Write Label"
	else if(is_open_container() && held_item?.is_refillable())
		context[SCREENTIP_CONTEXT_LMB] = "Use Pump"

	return CONTEXTUAL_SCREENTIP_SET

//when you attack the syrup bottle with a container it refills it
/obj/item/reagent_containers/cup/bottle/syrup_bottle/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(is_open_container() && tool.is_refillable())
		return refillable_act(user, tool)
	return ..()

/obj/item/reagent_containers/cup/bottle/syrup_bottle/nameformat(input, user)
	playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
	return "[input? "[input] " : null]bottle"


/obj/item/reagent_containers/cup/bottle/syrup_bottle/proc/refillable_act(mob/user, obj/item/tool)
	if(!reagents.total_volume)
		balloon_alert(user, "瓶子空了！")
		return ITEM_INTERACT_BLOCKING
	if(tool.reagents.holder_full())
		balloon_alert(user, "容器已满！")
		return ITEM_INTERACT_BLOCKING

	var/transfer_amount = round(reagents.trans_to(tool, amount_per_transfer_from_this, transferred_by = user), CHEMICAL_VOLUME_ROUNDING)
	if(transfer_amount)
		balloon_alert(user, "转移了[transfer_amount] unit\s 单位")
	flick("syrup_anim",src)
	tool.update_appearance()
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/cup/bottle/syrup_bottle/update_icon_state()
	. = ..()
	if(is_open_container())
		icon_state = "syrup_open"
	else
		icon_state = "syrup"

/obj/item/reagent_containers/cup/bottle/syrup_bottle/click_alt(mob/user)
	if(is_open_container())
		balloon_alert(user, "装上泵盖")
		update_container_flags(SEALED_CONTAINER | TRANSPARENT)
	else
		balloon_alert(user, "移除了泵盖")
		reset_container_flags()

	update_appearance()
	return CLICK_ACTION_SUCCESS

//types of syrups

/obj/item/reagent_containers/cup/bottle/syrup_bottle/caramel
	name = "bottle of caramel syrup"
	desc = "A pump bottle containing caramelized sugar, also known as caramel. Do not lick."
	list_reagents = list(/datum/reagent/consumable/caramel = 50)

/obj/item/reagent_containers/cup/bottle/syrup_bottle/liqueur
	name = "bottle of coffee liqueur syrup"
	desc = "A pump bottle containing mexican coffee-flavoured liqueur syrup. In production since 1936, HONK."
	list_reagents = list(/datum/reagent/consumable/ethanol/kahlua = 50)

/obj/item/reagent_containers/cup/bottle/syrup_bottle/korta_nectar
	name = "bottle of korta syrup"
	desc = "A pump bottle containing korta syrup. A sweet, sugary substance made from crushed sweet korta nuts."
	list_reagents = list(/datum/reagent/consumable/korta_nectar = 50)

//secret syrup
/obj/item/reagent_containers/cup/bottle/syrup_bottle/laughsyrup
	name = "bottle of laugh syrup"
	desc = "A pump bottle containing laugh syrup. The product of juicing Laughin' Peas. Fizzy, and seems to change flavour based on what it's used with!"
	list_reagents = list(/datum/reagent/consumable/laughsyrup = 50)
