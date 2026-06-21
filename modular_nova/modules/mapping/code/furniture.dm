/*
*	FURNITURE
*/

/obj/structure/decorative/shelf
	name = "架子"
	desc = "一个坚固的木制架子，用于存放各种物品。"
	icon = 'modular_nova/modules/mapping/icons/unique/furniture.dmi'
	icon_state = "empty_shelf_1"
	density = 0

/obj/structure/decorative/shelf/crates
	desc = "一个坚固的木架子，上面放着一堆板条箱。"
	icon_state = "shelf_1"

/obj/structure/decorative/shelf/milkjugs
	desc = "一个坚固的木架子，上面放着脱脂、半脱脂和全脂牛奶的壶和纸盒。"
	icon_state = "shelf_2"

/obj/structure/decorative/shelf/alcohol
	desc = "一个坚固的木架子，上面放着一堆可能是酒精饮料的东西。"
	icon_state = "shelf_3"

/obj/structure/decorative/shelf/soda
	desc = "一个坚固的木架子，上面放着一堆软饮料。这是这个星球的可口可乐版本吗？"
	icon_state = "shelf_4"

/obj/structure/decorative/shelf/soda_multipacks
	desc = "一个坚固的木架子，上面放着一堆多包装的软饮料。"
	icon_state = "shelf_5"

/obj/structure/decorative/shelf/crates1
	desc = "一个坚固的木架子，上面放着一堆板条箱。多么……普通？"
	icon_state = "shelf_6"

/obj/structure/decorative/shelf/soda_milk
	desc = "一个坚固的木架子，上面放着各种盒子。多包装软饮料和一些牛奶。"
	icon_state = "shelf_7"

/obj/structure/decorative/shelf/milk
	desc = "一个坚固的木架子，上面放着各种小盒牛奶。非常适合独居人士！"
	icon_state = "shelf_8"

/obj/structure/decorative/shelf/milk_big
	desc = "一个坚固的木架子，上面放着许多大盒牛奶。"
	icon_state = "shelf_9"

/obj/structure/decorative/shelf/alcohol_small
	desc = "一个坚固的木架子，上面放着许多酒。"
	icon_state = "shelf_10"

/obj/structure/decorative/shelf/alcohol_assortment
	desc = "一个坚固的木架子，上面放着各种品牌的酒精饮料。"
	icon_state = "shelf_11"

// Toilet with a snap pop.
/obj/structure/toilet/snappop
	contents = newlist(/obj/item/toy/snappop/phoenix)
