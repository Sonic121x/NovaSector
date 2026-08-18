/// 新人软管制的地区查表：位宽、分桶边界与「不确定时放行」三条不变量。
///
/// 这三条都是**跑起来才看得见**的类型：
/// ① BYOND 的 num 是单精度浮点，尾数只有 24 位。整条 IPv4（最大 4294967295）存不下，
///    所以生成器按首字节分桶、桶内只存低 24 位（最大 16777215，单精度可精确表示）。
///    哪天有人「顺手」把它改回整条 32 位，查表不会报错，只会开始悄悄放错人。
/// ② 跨首字节的段必须由生成器切开。桶内二分查的是 24 位值，跨桶段没切开就会漏判。
/// ③ 表缺失/地址不可解析/内网地址一律**放行**。一个因为数据文件没了就把所有人管制起来的
///    闸门，比一个谁都不管的闸门坏得多。
/datum/unit_test/newbie_guard_geoip

/datum/unit_test/newbie_guard_geoip/Run()
	var/list/saved_buckets = GLOB.newbie_guard_geo_buckets
	var/saved_loaded = GLOB.newbie_guard_geo_loaded
	var/saved_ranges = GLOB.newbie_guard_geo_ranges

	// ③ 表不可用时必须放行。
	GLOB.newbie_guard_geo_buckets = list()
	GLOB.newbie_guard_geo_loaded = TRUE
	GLOB.newbie_guard_geo_ranges = 0
	TEST_ASSERT(newbie_guard_address_in_region("8.8.8.8"), "地区表为空时必须放行（fail open）")

	// 合成表：1.0.1.0-1.0.3.255（桶 1，24 位 256-1023），36.0.0.0/6 切成 36/37/38/39 四个满桶。
	GLOB.newbie_guard_geo_buckets = list(
		"1" = list(256, 1023),
		"36" = list(0, 16777215),
		"37" = list(0, 16777215),
		"38" = list(0, 16777215),
		"39" = list(0, 16777215),
	)
	GLOB.newbie_guard_geo_ranges = 5

	// ① 桶内边界：低 24 位的上下沿都要精确命中，不能因为浮点抖动漏掉端点。
	TEST_ASSERT(newbie_guard_address_in_region("1.0.1.0"), "段起点 1.0.1.0 应在表内")
	TEST_ASSERT(newbie_guard_address_in_region("1.0.3.255"), "段终点 1.0.3.255 应在表内")
	TEST_ASSERT(newbie_guard_address_in_region("1.0.2.77"), "段中间 1.0.2.77 应在表内")
	TEST_ASSERT(!newbie_guard_address_in_region("1.0.0.255"), "段起点前一位 1.0.0.255 不应在表内")
	TEST_ASSERT(!newbie_guard_address_in_region("1.0.4.0"), "段终点后一位 1.0.4.0 不应在表内")

	// ① 24 位上沿：39.255.255.255 的桶内键正好是 16777215，单精度的精确表示边界。
	TEST_ASSERT(newbie_guard_address_in_region("39.255.255.255"), "24 位上沿 39.255.255.255 应在表内")

	// ② 跨首字节的段必须每个桶都命中，且桶外一位就要落空。
	TEST_ASSERT(newbie_guard_address_in_region("36.0.0.0"), "跨桶段首 36.0.0.0 应在表内")
	TEST_ASSERT(newbie_guard_address_in_region("38.1.2.3"), "跨桶段中 38.1.2.3 应在表内")
	TEST_ASSERT(!newbie_guard_address_in_region("35.255.255.255"), "桶 35 未登记，不应在表内")
	TEST_ASSERT(!newbie_guard_address_in_region("40.0.0.0"), "桶 40 未登记，不应在表内")

	// 完全没登记的桶走的是「bounds 为空」这条短路，与二分查找失败是两条不同的路径。
	TEST_ASSERT(!newbie_guard_address_in_region("223.5.5.5"), "未登记桶 223 不应在表内")

	// ③ 内网与本机永远放行——否则本地测试和局域网管理员会被自己的闸门挡在外面。
	TEST_ASSERT(newbie_guard_address_in_region("127.0.0.1"), "回环地址必须放行")
	TEST_ASSERT(newbie_guard_address_in_region("10.1.2.3"), "10/8 内网必须放行")
	TEST_ASSERT(newbie_guard_address_in_region("192.168.1.1"), "192.168/16 内网必须放行")
	TEST_ASSERT(newbie_guard_address_in_region("172.20.0.1"), "172.16/12 内网必须放行")
	TEST_ASSERT(!newbie_guard_address_in_region("172.32.0.1"), "172.32 不在 RFC1918 范围内，不应因内网规则放行")

	// ③ 解析不出四段点分十进制就不猜（本地客户端、IPv6、空值）。
	TEST_ASSERT(newbie_guard_address_in_region(null), "空地址必须放行")
	TEST_ASSERT(newbie_guard_address_in_region(""), "空串必须放行")
	TEST_ASSERT(newbie_guard_address_in_region("::1"), "IPv6 必须放行")
	TEST_ASSERT(newbie_guard_address_in_region("1.0.1"), "残缺地址必须放行")
	TEST_ASSERT(newbie_guard_address_in_region("1.0.1.999"), "越界字节必须放行")

	// ④ 仓库自带的那张真表必须能装载并给出正确判定。
	//
	// 前面几条全是合成表——合成数据证明得了算法，证明不了**随仓库发出去的那个文件**还在、
	// 还是合法 JSON、还是本模块认得的形状。这一类失效恰恰是静默的：功能开不起来，或者更糟，
	// 表空了之后 fail-open 把所有人放行，而日志里一个字都没有。所以这条测真文件。
	newbie_guard_load_geoip(force = TRUE)
	TEST_ASSERT(GLOB.newbie_guard_geo_ranges > 0, "仓库自带的地区表必须能装载（[GLOB.newbie_guard_geo_source]）")

	// 抽样断言。选的都是极稳定的骨干段，不是会随数据源版本漂移的边缘分配。
	TEST_ASSERT(newbie_guard_address_in_region("223.5.5.5"), "阿里公共 DNS 223.5.5.5 应判为境内")
	TEST_ASSERT(newbie_guard_address_in_region("114.114.114.114"), "114 DNS 应判为境内")
	TEST_ASSERT(newbie_guard_address_in_region("202.96.128.86"), "电信 DNS 202.96.128.86 应判为境内")
	TEST_ASSERT(!newbie_guard_address_in_region("8.8.8.8"), "Google DNS 8.8.8.8 应判为境外")
	TEST_ASSERT(!newbie_guard_address_in_region("1.1.1.1"), "Cloudflare DNS 1.1.1.1 应判为境外")
	TEST_ASSERT(!newbie_guard_address_in_region("104.16.0.1"), "Cloudflare 104.16/12 应判为境外")

	GLOB.newbie_guard_geo_buckets = saved_buckets
	GLOB.newbie_guard_geo_loaded = saved_loaded
	GLOB.newbie_guard_geo_ranges = saved_ranges
