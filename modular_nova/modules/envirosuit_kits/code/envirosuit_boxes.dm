/// Orange

/obj/item/storage/box/envirosuit
	name = "橙色环境防护服套装"
	desc = "一个装有全套等离子体人环境防护服的盒子，颜色是俗气的橙色。专为最普通的骨头准备。"

/obj/item/storage/box/envirosuit/PopulateContents()
	new /obj/item/clothing/under/plasmaman(src)
	new /obj/item/clothing/head/helmet/space/plasmaman(src)
	new /obj/item/clothing/gloves/color/plasmaman(src)

/// Slacks

/obj/item/storage/box/envirosuit/slacks
	name = "环境正装套装"
	desc = "一个装有全套等离子体人正装的盒子。专为最时髦的骨头准备。"

/obj/item/storage/box/envirosuit/slacks/PopulateContents()
	new /obj/item/clothing/under/plasmaman/enviroslacks(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/white(src)
	new /obj/item/clothing/gloves/color/plasmaman/white(src)

/// White

/obj/item/storage/box/envirosuit/white
	name = "白色环境防护服套装"
	desc = "一个装有全套白色等离子体人环境防护服的盒子。专为最闪亮的骨头准备。"

/obj/item/storage/box/envirosuit/white/PopulateContents()
	new /obj/item/clothing/under/plasmaman/white(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/white(src)
	new /obj/item/clothing/gloves/color/plasmaman/white(src)

/// Black

/obj/item/storage/box/envirosuit/black
	name = "黑色环境防护服套装"
	desc = "一个装有全套黑色等离子体人环境防护服的盒子。专为最酷炫的骨头准备。"

/obj/item/storage/box/envirosuit/black/PopulateContents()
	new /obj/item/clothing/under/plasmaman/black(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/black(src)
	new /obj/item/clothing/gloves/color/plasmaman/black(src)

/// Khaki

/obj/item/storage/box/envirosuit/khaki
	name = "卡其色环境防护服套装"
	desc = "一个装有全套卡其色等离子体人环境防护服的盒子。专为最爱冒险的骨头准备。"

/obj/item/storage/box/envirosuit/khaki/PopulateContents()
	new /obj/item/clothing/under/plasmaman/khaki(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/khaki(src)
	new /obj/item/clothing/gloves/color/plasmaman/explorer(src)

/// Prototype

/obj/item/storage/box/envirosuit/prototype
	name = "原型环境防护服套装"
	desc = "一个装有全套原型等离子体人环境防护服的盒子。专为最怀旧的骨头准备。"

/obj/item/storage/box/envirosuit/prototype/PopulateContents()
	new /obj/item/clothing/under/plasmaman/prototype(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/prototype(src)
	new /obj/item/clothing/gloves/color/plasmaman/prototype(src)

/// Security

/obj/item/storage/box/envirosuit/security
	name = "安保环境防护服替代套装"
	desc = "一个装有完整安保等离子人环境防护服替代套装的盒子。献给那些骨头里都透着施虐欲的家伙。"

/obj/item/storage/box/envirosuit/security/PopulateContents()
	new /obj/item/clothing/under/plasmaman/security/nova(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/security/nova(src)

/obj/item/storage/box/envirosuit/security_warden
	name = "典狱长环境防护服替代套装"
	desc = "一个装有完整典狱长等离子人环境防护服替代套装的盒子。献给那些骨头里都透着保护欲的家伙。"

/obj/item/storage/box/envirosuit/security_warden/PopulateContents()
	new /obj/item/clothing/under/plasmaman/security/nova/warden(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/security/nova/warden(src)

/obj/item/storage/box/envirosuit/security_hos
	name = "安全主管环境防护服替代套装"
	desc = "一个装有完整安全主管等离子人环境防护服替代套装的盒子。献给那些骨头里都透着权威感的家伙。"

/obj/item/storage/box/envirosuit/security_hos/PopulateContents()
	new /obj/item/clothing/under/plasmaman/security/nova/head_of_security(src)
	new /obj/item/clothing/head/helmet/space/plasmaman/security/nova/head_of_security(src)
