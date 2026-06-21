///We can empty beakers in here and everything
/obj/machinery/plumbing/input
	name = "输入阀门"
	desc = "可以从容器中手动填充试剂。"
	icon_state = "pipe_input"
	pass_flags_self = PASSMACHINE | LETPASSTHROW // Small
	reagent_flags = /obj/machinery/plumbing::reagent_flags | REFILLABLE

/obj/machinery/plumbing/input/Initialize(mapload, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, layer)

///We can fill beakers in here and everything. we dont inheret from input because it has nothing that we need
/obj/machinery/plumbing/output
	name = "输出阀门"
	desc = "管道系统的手动输出口，用于将试剂直接导入容器。"
	icon_state = "pipe_output"
	pass_flags_self = PASSMACHINE | LETPASSTHROW // Small
	reagent_flags = /obj/machinery/plumbing::reagent_flags | DRAINABLE
	reagents = /datum/reagents

/obj/machinery/plumbing/output/Initialize(mapload, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_demand, layer, distinct_reagent_cap = 5)

///For pouring reagents from ducts directly into cups
/obj/machinery/plumbing/output/tap
	name = "饮水龙头"
	desc = "管道系统的手动输出口，用于将饮品直接导入玻璃杯。"
	icon_state = "tap_output"

///For storing large volume of reagents
/obj/machinery/plumbing/tank
	name = "化学储罐"
	desc = "一个巨大的化学储存罐。"
	icon_state = "tank"
	buffer = 400

/obj/machinery/plumbing/tank/Initialize(mapload, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/tank, layer)

///Layer manifold machine that connects a bunch of layers
/obj/machinery/plumbing/layer_manifold
	name = "层流歧管"
	desc = "用于处理流体分层的管道歧管。"
	icon_state = "manifold"
	density = FALSE

/obj/machinery/plumbing/layer_manifold/Initialize(mapload, layer)
	. = ..()

	AddComponent(/datum/component/plumbing/manifold, FIRST_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, SECOND_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, THIRD_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, FOURTH_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, FIFTH_DUCT_LAYER)
