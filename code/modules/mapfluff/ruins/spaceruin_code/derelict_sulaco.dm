/////////// derelictsulaco items

/obj/item/paper/crumpled/ruins/derelict_sulaco/captain
	name = "血迹斑斑的纸片"
	icon_state = "scrap_bloodied"
	default_raw_text = "我们已竭尽全力，却依然失败了。现在我们只是在等待自毁程序启动。但我有过一段美好的旅程。我们都有过。我曾领导并与我有幸结识的最勇敢、最真诚的人们并肩作战。<BR><BR>永远忠诚。<BR><BR>*舰长罗梅罗·埃尔南*"

/obj/item/paper/ruins/derelict_sulaco/birthday
	name = "致我们的舰长"
	desc = "虽然模糊，但你能在这张照片背面辨认出‘永远忠诚！’的字样。"
	icon = 'icons/obj/art/camera.dmi'
	icon_state = "photo"
	show_written_words = FALSE

	default_raw_text = "*This looks to be a photo of the captain's birthday, held in a festivized cafeteria. The crew's smiles and laughter beam through discolored film, where one staff officer has his superior enveloped in a warm hug. Everyone looks happy together. A gift is being forced into the captain's hands: some silly, mischievous-looking 'runner' plushie.*"

/obj/item/clothing/suit/armor/vest/marine/sulaco
	name = "损坏的战术装甲背心"
	desc = "一套老旧、磨损的、批量生产的、冲压成型的塑钢装甲中的精品。这件装备的大部分防护性能已随时间流逝而丧失，但对于向异形竖起中指来说，它仍然绰绰有余。"
	armor_type = /datum/armor/derelict_marine

/obj/item/clothing/head/helmet/marine/sulaco
	name = "损坏的战术作战头盔"
	desc = "一顶战术黑色头盔，仅靠一块玻璃板勉强密封以抵御外部危害，除此之外别无他物。防护性已不如从前，但功能依然完好。"
	armor_type = /datum/armor/derelict_marine

/datum/armor/derelict_marine
	melee = 20
	bullet = 20
	bio = 100
	fire = 40
	acid = 50
	wound = 20

/obj/machinery/computer/terminal/sulaco
	tguitheme = "abductor"

/obj/machinery/computer/terminal/sulaco/overwatch
	name = "监视控制台"
	desc = "用于一般监视目的的最先进机器。"
	upperinfo = "Bravo Overwatch Console"
	icon_screen = "explosive"
	content = list("<B>Operator:</B> Cas Ashpole <BR> <BR> <B><center>Squad Overwatch:</B> Cas Ashpole <BR> <BR> <b>Squad Leader Deployed</b> <BR> <b>Squad Smartgunners:</b> 1 Deployed <BR> <b>Squad Corpsmen:</b> 1 Deployed <BR> <b>Squad Engineers:</b> 2 Deployed <BR> <b>Squad Marines:</b> 4 Deployed <BR> <b>Total:</b> 9 Deployed <BR> <b>Marines Alive:</b> 0 <BR> <BR> <table>   <tr>     <th>Name</th>     <th>Role</th>     <th>State</th>     <th>Location</th>     <th>SL Distance</th>   </tr>   <tr>     <td>Chip Mello</td>     <td>Squad Leader</td>     <td>Dead</td>     <td>Self-Destruct Core Room</td>     <td> N/A </td>   </tr>   <tr>     <td>Sophie Knight</td>     <td>Squad Smartgunner</td>     <td>Dead</td>     <td>Self-Destruct Core Room</td>     <td>4</td>   </tr>   <tr>     <td>Marie Newman</td>     <td>Squad Corpsman</td>     <td>Dead</td>     <td>Unknown</td>     <td> N/A </td>   </tr>   <tr>     <td>Angelo Patton</td>     <td>Squad Engineer</td>     <td>Dead</td>     <td>Sulaco Maintenance</td>     <td>19</td>   </tr>   <tr>     <td>Marlon Foster</td>     <td>Squad Engineer</td>     <td>Dead</td>     <td>Sulaco Dropship Hangar</td>     <td>28</td>   </tr>   <tr>     <td>Doug Davidson</td>     <td>Squad Marine</td>     <td>Dead</td>     <td>Sulaco Hangar Workshop</td>     <td>33</td>   </tr>   <tr>     <td>Courtney Miller</td>     <td>Squad Marine</td>     <td>Dead</td>     <td>Sulaco Hangar Workshop</td>     <td>42</td>   </tr>   <tr>     <td>Cesar Jefferson</td>     <td>Squad Marine</td>     <td>Dead</td>     <td>Self-Destruct Core Room</td>     <td>14</td>   </tr> </table> <BR> <b>Primary Objective:</b> Defend the self-destruct core. <BR> <b>Secondary Objective:</b> Give them hell!</center>")

/obj/machinery/computer/terminal/sulaco/overwatch/main
	name = "主监视控制台"
	upperinfo = "Main Overwatch Console"
	icon_screen = "commsyndie"
	icon_keyboard = "syndie_key"
	content = list("<B>Main Operator:</B> Romero Hernan <BR> <BR> <center><B>Charlie Squad</B> <BR> <b>Leader:</b> Colin Norris <BR> <b>Squad Overwatch:</b> Cheryl Wade <BR> <BR> <B>Alpha Squad</B> <BR> <b>Leader</b>: NONE <BR> <b>Squad Overwatch:</b> NONE <BR> <BR> <B>Bravo Squad</B> <BR> <b>Leader</b>: Chip Mello <BR> <b>Squad Overwatch:</b> Cas Ashpole <BR> <BR> <B>Delta Squad</B> <BR> <b>Leader</b>: Scott Byrd <BR> <b>Squad Overwatch:</b> Casey Alle <BR> <BR> <BR> <b> Orbital Bombardment Cannon<BR> <BR>Current Cannon Status: </B> Unable to connect to the OBC! <BR> <b>Laser Targets:</b> None <BR> <b>Selected Targets:</b> None</center>")

/obj/machinery/computer/terminal/sulaco/helm
	name = "舵机电脑"
	desc = "苏拉科号的导航控制台。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	upperinfo = "Navigation"
	content = list("<center><b>Sulaco<BR><BR><BR>LOCATION UNKNOWN</b><BR><BR>Power Level: 0<BR>Engine status: N/A<BR><BR><b>Unable to change orbit.</b></center>")

/obj/machinery/computer/terminal/sulaco/map
	name = "地图桌"
	desc = "一张显示当前目标地点地图的桌子。"
	icon_screen = "mining"
	upperinfo = "LV-624"
	content = list("The display can barely output an image of a map, owing to its damage, but you can make out bits and pieces of something. It appears to be a satellite image of a colony located on a jungle planet. Lush and thick greenery covers the southern part, while the northern area is encompassed by mountainous rock.<BR><BR>A river flows through the colony, splitting it in two. In addition, several icons are scattered across the map, but you are sadly not able to make much sense of them.")
