/area/station/commons
	name = "\improper 船员生活区"
	icon_state = "commons"
	sound_environment = SOUND_AREA_STANDARD_STATION
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

/*
* Dorm Areas
*/

/area/station/commons/dorms
	name = "\improper 宿舍区"
	icon_state = "dorms"

/area/station/commons/dorms/room1
	name = "\improper 宿舍 1 号房"
	icon_state = "room1"

/area/station/commons/dorms/room2
	name = "\improper 宿舍 2 号房"
	icon_state = "room2"

/area/station/commons/dorms/room3
	name = "\improper 宿舍 3 号房"
	icon_state = "room3"

/area/station/commons/dorms/room4
	name = "\improper 宿舍房间 4"
	icon_state = "room4"

/area/station/commons/dorms/apartment1
	name = "\improper 宿舍公寓 1"
	icon_state = "apartment1"

/area/station/commons/dorms/apartment2
	name = "\improper 宿舍公寓 2"
	icon_state = "apartment2"

/area/station/commons/dorms/barracks
	name = "\improper 睡眠营房"

/area/station/commons/dorms/barracks/male
	name = "\improper 男性睡眠营房"
	icon_state = "dorms_male"

/area/station/commons/dorms/barracks/female
	name = "\improper 女性睡眠营房"
	icon_state = "dorms_female"

/area/station/commons/dorms/laundry
	name = "\improper 洗衣房"
	icon_state = "laundry_room"

/area/station/commons/toilet
	name = "\improper 宿舍厕所"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/commons/toilet/auxiliary
	name = "\improper 辅助卫生间"
	icon_state = "toilet"

/area/station/commons/toilet/locker
	name = "\improper 更衣室厕所"
	icon_state = "toilet"

/area/station/commons/toilet/restrooms
	name = "\improper 卫生间"
	icon_state = "toilet"

/area/station/commons/toilet/shower
	name = "\improper 淋浴间"
	icon_state = "shower"

/*
* Rec and Locker Rooms
*/

/area/station/commons/locker
	name = "\improper 更衣室"
	icon_state = "locker"

/area/station/commons/lounge
	name = "\improper 酒吧休息室"
	icon_state = "lounge"
	mood_bonus = 5
	mood_message = "I love being in the bar!"
	mood_trait = TRAIT_EXTROVERT
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	tacmap_color = TACMAP_AREA_SERVICE

/area/station/commons/fitness
	name = "\improper 健身房"
	icon_state = "fitness"

/area/station/commons/fitness/locker_room
	name = "\improper 无性别更衣室"
	icon_state = "locker"

/area/station/commons/fitness/locker_room/male
	name = "\improper 男性更衣室"
	icon_state = "locker_male"

/area/station/commons/fitness/locker_room/female
	name = "\improper 女性更衣室"
	icon_state = "locker_female"

/area/station/commons/fitness/recreation
	name = "\improper 娱乐区"
	icon_state = "rec"

/area/station/commons/fitness/recreation/entertainment
	name = "\improper 娱乐中心"
	icon_state = "entertainment"

/area/station/commons/fitness/recreation/pool
	name = "\improper 游泳池"
	icon_state = "pool"

/area/station/commons/fitness/recreation/lasertag
	name = "\improper 激光枪战竞技场"
	icon_state = "lasertag"

/area/station/commons/fitness/recreation/sauna
	name = "\improper 桑拿房"
	icon_state = "sauna"

/*
* Vacant Rooms
*/

/area/station/commons/vacant_room
	name = "\improper 空置房间"
	icon_state = "vacant_room"
	ambience_index = AMBIENCE_MAINT

/area/station/commons/vacant_room/office
	name = "\improper 空置办公室"
	icon_state = "vacant_office"

/area/station/commons/vacant_room/commissary
	name = "\improper 空置小卖部"
	icon_state = "vacant_commissary"

/*
* Storage Rooms
*/

/area/station/commons/storage
	name = "\improper 公共区储藏室"

/area/station/commons/storage/tools
	name = "\improper 辅助工具储藏室"
	icon_state = "tool_storage"

/area/station/commons/storage/primary
	name = "\improper 主要工具储藏室"
	icon_state = "primary_storage"

/area/station/commons/storage/art
	name = "\improper 美术用品储藏室"
	icon_state = "art_storage"

/area/station/commons/storage/emergency/starboard
	name = "\improper 右舷应急储藏室"
	icon_state = "emergency_storage"

/area/station/commons/storage/emergency/port
	name = "\improper 左舷应急储藏室"
	icon_state = "emergency_storage"

/area/station/commons/storage/mining
	name = "\improper 公共采矿储藏室"
	icon_state = "mining_storage"
