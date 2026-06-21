/obj/structure/chess
	anchored = FALSE
	density = FALSE
	icon = 'icons/obj/toys/chess.dmi'
	icon_state = "white_pawn"
	name = "\improper 可能是一只白卒"
	desc = "这很奇怪。请告知管理员你是如何获得这个父类象棋棋子的。谢谢！"
	max_integrity = 100
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/chess/wrench_act(mob/user, obj/item/tool)
	if(flags_1 & HOLOGRAM_1)
		balloon_alert(user, "它直接穿过去了！")
		return TRUE
	to_chat(user, span_notice("你开始拆解这个象棋棋子。"))
	if(!do_after(user, 0.5 SECONDS, target = src))
		return TRUE
	var/obj/item/stack/sheet/iron/metal_sheets = new (drop_location(), 2)
	if (!QDELETED(metal_sheets))
		metal_sheets.add_fingerprint(user)
	tool.play_tool_sound(src)
	qdel(src)
	return TRUE

/obj/structure/chess/whitepawn
	name = "\improper 白卒"
	desc = "一颗白棋子，在处决一名生病的路人时被指控作弊。"
	icon_state = "white_pawn"

/obj/structure/chess/whiterook
	name = "\improper 白战车"
	desc = "一块白色战车棋，也称为城堡，可以直线移动任意数量的瓷砖，它有一个叫做王车易位的特殊动作。"
	icon_state = "white_rook"

/obj/structure/chess/whiteknight
	name = "\improper 白骑士"
	desc = "白色骑士的棋子，它可以跳过其他棋子，以 L 形移动，一件白色的针织衫，哈！"
	icon_state = "white_knight"

/obj/structure/chess/whitebishop
	name = "\improper 白主教"
	desc = "白色主教棋子，它可以在对角线中移动任意数量的瓷砖。"
	icon_state = "white_bishop"

/obj/structure/chess/whitequeen
	name = "\improper 白皇后"
	desc = "一枚白色皇后棋子，它可以沿对角线和直线移动任意数量的瓷砖。"
	icon_state = "white_queen"

/obj/structure/chess/whiteking
	name = "\improper 白国王"
	desc = "一枚白色国王棋子。它可以向任意方向移动一格。"
	icon_state = "white_king"

/obj/structure/chess/blackpawn
	name = "\improper 黑卒"
	desc = "一颗黑色的棋子，在处决一名生病的路人时被指控作弊。"
	icon_state = "black_pawn"

/obj/structure/chess/blackrook
	name = "\improper 黑战车"
	desc = "一块黑色战车棋，也称为城堡，可以直线移动任意数量的瓷砖，它有一个叫做王车易位的特殊动作。"
	icon_state = "black_rook"

/obj/structure/chess/blackknight
	name = "\improper 黑骑士"
	desc = "一枚黑色骑士棋子，它可以跳过其他碎片，以L型移动。"
	icon_state = "black_knight"

/obj/structure/chess/blackbishop
	name = "\improper 黑主教"
	desc = "一枚黑色的主教棋子，它可以在对角线上移动任意数量的瓷砖。"
	icon_state = "black_bishop"

/obj/structure/chess/blackqueen
	name = "\improper 黑皇后"
	desc = "一枚黑色皇后棋子，它可以沿对角线和直线移动任意数量的瓷砖。"
	icon_state = "black_queen"

/obj/structure/chess/blackking
	name = "\improper 黑国王"
	desc = "一个黑色国王棋子，它可以在任何方向移动一个瓷砖。"
	icon_state = "black_king"

/obj/structure/chess/checker
	icon_state = "white_checker_man"
	name = "\improper 可能是个白色跳棋棋子"
	desc = "这很奇怪。请告知管理员你是如何获得这个父类跳棋棋子的。谢谢！"

/obj/structure/chess/checker/whiteman
	name = "\improper 白色跳棋棋子"
	desc = "一枚白色跳棋棋子。看起来可疑地像一个压扁了的国际象棋兵。"
	icon_state = "white_checker_man"

/obj/structure/chess/checker/whiteking
	name = "\improper 白色跳棋棋子"
	desc = "一枚白色跳棋棋子。它是叠起来的！"
	icon_state = "white_checker_king"

/obj/structure/chess/checker/blackman
	name = "\improper 黑色跳棋棋子"
	desc = "一枚黑色跳棋棋子。看起来可疑地像一个压扁了的国际象棋兵。"
	icon_state = "black_checker_man"

/obj/structure/chess/checker/blackking
	name = "\improper 黑色跳棋王"
	desc = "一枚黑色跳棋棋子。它是叠起来的！"
	icon_state = "black_checker_king"
