/datum/blood_type/haemocyanin
	name = "Haemocyanin"
	color = "#3399FF"
	desc = "这种携氧大分子由铜而非铁构成（因此呈蓝色），在较低温度下其效率与血红蛋白相似。"
	restoration_chem = /datum/reagent/copper
	compatible_types = list(
		/datum/blood_type/haemocyanin,
	)

/datum/blood_type/chlorocruorin
	name = "Chlorocruorin"
	color = "#9FF73B"
	desc = "血绿蛋白分子相对于其他氧载体来说非常巨大，其绿色源于一种异常的血红素基团。"
	compatible_types = list(
		/datum/blood_type/chlorocruorin,
	)

/datum/blood_type/hemerythrin
	name = "Hemerythrin"
	color = "#C978DD"
	desc  = "粉红色的蚯蚓血红蛋白大分子实际上通过形成氢过氧化物来结合氧气，这是一种独特的血液携氧机制。"
	compatible_types = list(
		/datum/blood_type/hemerythrin,
	)

/datum/blood_type/pinnaglobin
	name = "Pinnaglobin"
	color = "#CDC020"
	restoration_chem = /datum/reagent/manganese
	desc = "与血蓝蛋白最为相似，羽扇豆蛋白以锰原子取代了铜原子，赋予其独特的颜色。"
	compatible_types = list(
		/datum/blood_type/pinnaglobin,
	)

/datum/blood_type/exotic
	name = "Exotic"
	color = "#333333"
	restoration_chem = /datum/reagent/sulfur
	compatible_types = list(
		/datum/blood_type/exotic,
	)
	desc = "这种血液颜色在自然界中似乎并不天然存在，但通过接触硫磺或其他基因工程或污染，或许有可能产生。"
