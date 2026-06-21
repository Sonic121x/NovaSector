/obj/machinery/door/puzzle/keycard/library
	name = "木门"
	desc = "一扇满是灰尘、有划痕的门，上面有一把厚厚的锁。"
	icon = 'icons/obj/doors/puzzledoor/wood.dmi'
	puzzle_id = "library"
	open_message = "The door opens with a loud creak."

/obj/machinery/door/puzzle/keycard/library/animation_length(animation)
	switch(animation)
		if(DOOR_OPENING_ANIMATION)
			return 1.2 SECONDS

/obj/machinery/door/puzzle/keycard/library/animation_segment_delay(animation)
	switch(animation)
		if(DOOR_OPENING_PASSABLE)
			return 1.0 SECONDS
		if(DOOR_OPENING_FINISHED)
			return 1.2 SECONDS

/obj/item/keycard/library
	name = "金钥匙"
	desc = "一把钝的金钥匙。"
	icon_state = "golden_key"
	puzzle_id = "library"

/obj/item/paper/crumpled/bloody/fluff/stations/lavaland/library/warning
	name = "古老的笔记"
	default_raw_text = "<b>此处安放着知晓万物者的浩瀚收藏。那些为寻求力量而窥探其知识者，必遭诅咒。</b>"

/obj/item/paper/crumpled/fluff/stations/lavaland/library/diary
	name = "日记条目13"
	default_raw_text = "图书馆被掩埋已有一周，我再也没见过那只猫头鹰。我饿得几乎无法集中精力思考，更别提写字了。那些知识探寻者们似乎不受影响。"

/obj/item/paper/crumpled/fluff/stations/lavaland/library/diary2
	name = "日记条目18"
	default_raw_text = "我已失去了时间概念。我虚弱得连从书架上拿起书的力气都没有。想想看，花了这么多时间寻找这座图书馆，我却将在触及它知识深度的皮毛之前死去。"

/obj/item/feather
	name = "羽毛"
	desc = "一根暗的、枯萎的羽毛。它似乎和时间一样古老。"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "feather"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
