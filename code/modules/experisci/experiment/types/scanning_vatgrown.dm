/datum/experiment/scanning/cytology
	name = "细胞学扫描实验"
	exp_tag = "Cytology Scan"

/datum/experiment/scanning/cytology/final_contributing_index_checks(datum/component/experiment_handler/experiment_handler, atom/target, typepath)
	return ..() && HAS_TRAIT(target, TRAIT_VATGROWN)

/datum/experiment/scanning/cytology/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Scan samples of \a vat-grown [initial(target.name)]", seen_instances.len, required_atoms[target])

/datum/experiment/scanning/cytology/slime
	name = "培养槽生长史莱姆扫描"
	description = "见过异种生物学围栏里的史莱姆吗？那是我们的研究员把一片发霉的面包片扔进培养槽后产生的。再培育一个并报告结果。"
	performance_hint = "Swab the slime cell lines from a moldy bread or take a biopsy sample of existing slime. And grow it in the vat."
	required_atoms = list(/mob/living/basic/slime = 1)


