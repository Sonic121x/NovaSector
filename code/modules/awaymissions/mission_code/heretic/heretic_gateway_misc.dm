/obj/item/keycard/heretic_entrance
	name = "secure storage keycard"
	desc = "A keycard that simply states, basic access."
	color = "#000000"
	puzzle_id = "heretic_gateway0"

/obj/machinery/door/puzzle/keycard/heretic_entrance
	name = "secure airlock"
	puzzle_id = "heretic_gateway0"

/obj/item/keycard/highsec_access
	name = "secure storage keycard"
	desc = "A keycard that simply states, 'only under exteme circumstances'."
	color = "#440000"
	puzzle_id = "heretic_gateway1"

/obj/machinery/door/puzzle/keycard/highsec_access
	name = "secure airlock"
	puzzle_id = "heretic_gateway1"

/obj/item/keycard/cbrn_area
	name = "CBRN storage keycard"
	desc = "A keycard that has a few weird logos and stickers on it all related to biohazards or radiation."
	color = "#80e71f"
	puzzle_id = "heretic_gateway2"

/obj/machinery/door/puzzle/keycard/cbrn_area
	name = "secure airlock"
	puzzle_id = "heretic_gateway2"

/obj/item/keycard/biological_anomalies
	name = "生物存储门禁卡"
	desc = "一张看起来像基础门禁卡的卡片，但上面印有生物危害警告。"
	color = "#357735"
	puzzle_id = "heretic_gateway3"

/obj/machinery/door/puzzle/keycard/biological_anomalies
	name = "安全气闸门"
	puzzle_id = "heretic_gateway3"

/obj/item/keycard/weapon_anomalies
	name = "武器存储门禁卡"
	desc = "一张看起来像基础门禁卡的卡片，但上面印有一把简单易识别的手枪图案。"
	color = "#4b4b4b"
	puzzle_id = "heretic_gateway4"

/obj/machinery/door/puzzle/keycard/weapon_anomalies
	name = "安全气闸门"
	puzzle_id = "heretic_gateway4"

/obj/item/keycard/misc_anomalies
	name = "杂项存储门禁卡"
	desc = "一张看起来像基础门禁卡的卡片，但上面印有一根法杖图案。"
	color = "#df2190"
	puzzle_id = "heretic_gateway5"

/obj/machinery/door/puzzle/keycard/misc_anomalies
	name = "安全气闸门"
	puzzle_id = "heretic_gateway5"

/obj/item/paper/fluff/awaymissions/heretic
	name = "一张提示"
	desc = "这个地方设计了许多安全措施来确保内部物品的安全"

/obj/item/paper/fluff/awaymissions/heretic/floorsafe
	default_raw_text = "<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  +  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li> \
	<li>X  X  X  X  X  X  X  X  X  X</li>"

/obj/item/paper/fluff/awaymissions/heretic/blackroomhint
	default_raw_text = "嘿，一个高级安保警卫来过，封锁了这里并让我们撤离，他们把进入设施的钥匙卡藏在这个房间的正确位置了。如果你能看到这个，应该就没事，记得检查墙壁来找钥匙卡。"

/obj/item/paper/fluff/awaymissions/heretic/gravehint
	default_raw_text = "办公室里流传着谣言，说沿着这条路下去的墓地里有一些假坟墓是空的，里面放着所谓的“保险”——不管那是什么意思。此致，杰拉米。"

/turf/open/misc/ashplanet/wateryrock/safeair
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/obj/machinery/mass_driver/feeder
	name = "质量驱动器"
	id = "MASSDRIVER_HERETIC"

/obj/machinery/computer/pod/old/mass_driver_controller/feeder
	id = "MASSDRIVER_HERETIC"
