/obj/item/paper/fluff/bee_objectives
	name = "蜜蜂解放阵线特工目标"
	default_raw_text = "<b>目标 #1</b>. 解放NT运输船2416/B上的所有蜜蜂。<b>成功！</b>  <br><b>目标 #2</b>. 活着逃脱。<b>失败。</b>"

/obj/machinery/syndicatebomb/shuttle_loan
	add_boom_wires = FALSE

/obj/machinery/syndicatebomb/shuttle_loan/Initialize(mapload)
	. = ..()
	set_anchored(TRUE)
	timer_set = rand(480, 600) //once the supply shuttle docks (after 5 minutes travel time), players have between 3-5 minutes to defuse the bomb
	activate()
	update_appearance()

/obj/item/paper/fluff/cargo/bomb
	name = "匆忙涂写的便条"
	default_raw_text = "祝你好运！"

/obj/item/paper/fluff/cargo/bomb/allyourbase
	default_raw_text = "有人给我们设下了炸弹！"
