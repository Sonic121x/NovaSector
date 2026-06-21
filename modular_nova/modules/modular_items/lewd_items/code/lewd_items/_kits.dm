
// Milking machine
/obj/item/storage/box/milking_kit
	name = "DIY挤奶机套件"
	desc = "包含了你建造自己的挤奶机所需的一切！"

/obj/item/storage/box/milking_kit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/construction_kit/milker = 1)
	generate_items_inside(items_inside, src)

// X-Stand
/obj/item/storage/box/xstand_kit
	name = "DIY X型支架套件"
	desc = "包含了你建造自己的X型支架所需的一切！"

/obj/item/storage/box/xstand_kit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/construction_kit/bdsm/x_stand = 1)
	generate_items_inside(items_inside, src)

// BDSM bed
/obj/item/storage/box/bdsmbed_kit
	name = "DIY BDSM床套件"
	desc = "包含了你建造自己的BDSM床所需的一切！"

/obj/item/storage/box/bdsmbed_kit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/construction_kit/bdsm/bed = 1)
	generate_items_inside(items_inside, src)

// Striptease pole
/obj/item/storage/box/strippole_kit
	name = "DIY脱衣舞钢管套件"
	desc = "包含了你建造自己的脱衣舞钢管所需的一切！"

/obj/item/storage/box/strippole_kit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/construction_kit/pole = 1)
	generate_items_inside(items_inside, src)

// Shibari stand
/obj/item/storage/box/shibari_stand
	name = "DIY缚绳架套件"
	desc = "包含了你建造自己的缚绳架所需的一切！"

/obj/item/storage/box/shibari_stand/PopulateContents()
	var/static/items_inside = list(
		/obj/item/construction_kit/bdsm/shibari = 1,
		/obj/item/paper/shibari_kit_instructions = 1)
	generate_items_inside(items_inside, src)

// Paper instructions for shibari kit

/obj/item/paper/shibari_kit_instructions
	default_raw_text = "你好！恭喜你购买了LustWish的缚绳套件！有些新手可能会对我们的绳子感到困惑，所以我们为你准备了一份简短的说明！首先，你需要一把扳手来组装支架本身。其次，你可以使用螺丝刀来改变你的缚绳架的颜色。只需更换塑料配件即可！第三，如果你想将某人绑在束缚架上，你需要完全绑住他们的身体，包括胯部和胸部！要做到这一点，你需要先用绳子绑住身体，然后再绑住角色的胯部，之后你就可以像对待任何椅子一样将他们扣在架子上了。别忘了手上要留一些绳子来真正把他们绑在架子上，因为套件里不包含绳子！就是这样！"
