/obj/item/gun/energy/recharge/kinetic_accelerator/variant/machinegun
	name = "原动能机枪"
	desc = parent_type::desc + "这把变体结构上加装了连续脉冲系统，扣住扳机可以全自动射击"
	special_desc = "经过科学的研究表明，许多矿工在丧命之前都得过严重的腱鞘炎，这种病如果不及时治疗会严重影响矿工的采矿效率\
	研发团队为了解决这个问题，研制出了新型号的动能炮：原动能机炮！！！\
	这把原动能炮加装了连续脉冲系统，只要扣住扳机不放，炮就像是凶猛的太空虎一样咆哮，把这些地狱中的怪物通通撕碎！"
	icon = 'modular_z121/icons/obj/pka/machinegun_pka.dmi'
	icon_state = "kineticmachinegun"
	base_icon_state = "kineticmachinegun"
	inhand_icon_state = "kineticgun"
	recharge_time = 3 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/machinegun)
	max_mod_capacity = 65


/obj/item/gun/energy/recharge/kinetic_accelerator/variant/machinegun/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/machinegun/add_bayonet_point()
	return
