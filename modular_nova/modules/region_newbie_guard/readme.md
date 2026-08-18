## 新人软管制（Region Newbie Guard）

Module ID: REGION_NEWBIE_GUARD

### Description:

对「账号游戏时长不足门槛 **且** 连接来源 IP 不在地区名单内」的玩家施加一组临时限制，而不是拒绝其连接。玩家在本回合存活满设定时间后限制自动解除，也可以就地提交申诉由管理员永久豁免。

限制内容：

- **和平化**：`TRAIT_PACIFISM`，无法主动攻击他人。
- **拆解**：无法用扳手、螺丝刀、剪线钳、焊枪、万用表拆解机器、电缆、格栅、窗户与墙。**撬棍刻意不在名单内**——被困住时撬门是新人自救的手段。
- **设施操作**：火警、空气警报、大气管道、气罐、APC、供电终端、电缆、按钮、闪光弹、重力发生器、发射器、超物质晶体、大气/通讯电脑、核弹与核磁盘。
- **爆破与快速施工**：手雷、气罐炸弹（transfer valve）、RCD、RPD。

**检查（Shift 点击）与指向（中键）永不拦截**——受管制的恰恰是最需要读环境的人。移动、对话、开门、使用电脑与工作台均不受影响。

#### 关键设计点

- **落点必须是 `COMSIG_MOB_CLICKON`**（`code/_onclick/click.dm:77`）。它在 `tool_act`、攻击链与机械交互之前触发。挂在更下游都不行：`base_item_interaction()` 会**先**跑 `tool_act()`，再发任何用户侧信号，所以 `COMSIG_USER_ITEM_INTERACTION` 拦不住工具拆解。
- **状态按 ckey 记，不按 mob 记**。存活进度因此能跨克隆、换体与灵魂转移保留。
- **所有提示都是私信 + 中英双语**：走 `MESSAGE_TYPE_ADMINPM` 频道（玩家的私聊标签页），整条 `boxed_message` 一次发出而不是十几条 `to_chat`——回合开始时聊天是一面文字墙，必须被读到的通知经不起打散。全部带 `skip_i18n_fallback = TRUE`，否则聊天层的 AC 兜底会把英文那一半也翻成中文。

#### 性能取舍

热路径是 `get_refusal()`：受管制玩家**每一次点击**都要过它。

- **用 `istype()` 链而不是 typecache**。`istype` 是原生类型比较，且不驻留内存；单一个 `typecacheof(/obj/machinery/atmospherics)` 就要 intern 约 900 条路径。代价是这串比较**顺序敏感**（`ismachinery()` 那道闸门挪位就会让机器类整片漏出判定，且游戏里不报任何错），由 `newbie_guard_refusal` 单测钉住。
- **顺序按命中率排**：一次 `ismachinery()` 就滤掉绝大多数点击（地板、mob、物品、墙）。
- **返回状态码而非字符串**。消息（连同两种语言）只在真要显示时才拼，被 `NEWBIE_GUARD_REFUSAL_COOLDOWN` 挡掉的那些一个字都不构造。
- **一个共享计时器**驱动全部受管制玩家，不是每人一个循环计时器；`GLOB.newbie_guard_active` 是活动组件的显式注册表，管理面板与总开关因此不必遍历 `GLOB.mob_living_list`（数千条，几乎全是简单动物）。
- **判定按 ckey 缓存整局**（`GLOB.newbie_guard_verdict`）。否则每次 Login 都可能再打一次阻塞的 `set_exp_from_db()`——而 Login 在克隆、换体、aghost 时都会触发，不只是加入回合时。改门槛或重载地区表会清掉这份缓存。
- **关闭功能时释放地区表**（`newbie_guard_unload_geoip`）：整国表是万级段数，没道理在关掉之后还占着整局。
- `newbie_guard_on_login()` 第一行就是配置开关检查——正常班次功能是关的，这条路径必须几乎零成本。
- **地区查表按首字节分桶**。BYOND 的 `num` 是单精度浮点（尾数 24 位），整条 IPv4（最大 4294967295）**存不下**。生成器把每个段按首字节切开、桶内只存低 24 位（最大 16777215，单精度可精确表示）。`newbie_guard_geoip` 单测锁住这条。
- **一切不确定都放行**（fail open）：数据表缺失/损坏、地址无法解析、回环与 RFC1918 内网，一律视为在地区内。一个因为数据文件没了就把所有人管制起来的闸门，比一个谁都不管的闸门坏得多。
- 管理员与 deadmin 永不受管制。

#### 使用

**开箱即用**：地区数据表（默认中国大陆，5358 段）已生成并提交在 `modular_nova/modules/region_newbie_guard/data/allowed_regions.json`，随仓库部署，无需任何额外步骤。管理员用 verb「切换新人软管制」（Server 分类，需要 `R_SERVER`）开启即可，开启时会依次询问时长门槛与存活解除时长。

「新人软管制名单」（Admin 分类）查看当前受管制玩家、存活进度与永久豁免名单，并可就地批准或撤销豁免。

玩家提交申诉后，管理员聊天频道会出现带【批准】【驳回】链接的消息。批准即永久豁免并写入 `data/newbie_guard_bypass.json`（保留天数由 `NEWBIE_GUARD_BYPASS_DAYS` 控制）。申诉有 5 分钟冷却，避免刷屏。

##### 更新地区数据表

表是**单一来源**：只有仓库里那一份，跟着仓库更新走，所有实例因此永远跑同一张表。拿一份 mihomo / v2ray 的 `geoip.dat`，或每行一条 CIDR 的纯文本：

```sh
node tools/geoip/mihomo-geoip.mjs --input geoip.dat --country CN
```

默认就写到上面那个提交路径，改完连同代码一起提交、照常部署即可。

**刻意没有 `data/` 覆盖路径。** `data/` 在 `.gitignore` 里（`/data/**/*`），放那儿的表既到不了别的实例，又会让"这台机器实际拦谁"和"仓库说它拦谁"悄悄对不上——排查时这种不一致比多跑一条命令贵得多。

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- `modular_nova/master_files/code/modules/mob/living/living.dm`: `/mob/living/Login()` 末尾调用 `newbie_guard_on_login(src)`（与既有的 `BAN_PACIFICATION` 落点同处）。

### Defines:

- `code/__DEFINES/~nova_defines/region_newbie_guard.dm`: `NEWBIE_GUARD_TRAIT`、`NEWBIE_GUARD_GEOIP_PATH`、`NEWBIE_GUARD_BYPASS_PATH`、`NEWBIE_GUARD_TICK`、`NEWBIE_GUARD_APPEAL_COOLDOWN`、`NEWBIE_GUARD_REFUSAL_COOLDOWN`、`NEWBIE_GUARD_REFUSE_NONE/ITEM/TARGET/TOOL`

### Included files that are not contained in this module:

- `tools/geoip/mihomo-geoip.mjs`：mihomo/v2ray geodata → 运行时查表的转换脚本。
- `code/modules/unit_tests/~nova/newbie_guard_geoip.dm`：地区查表的不变量测试。
- `code/modules/unit_tests/~nova/newbie_guard_refusal.dm`：点击判定表的正反面测试（含「撬棍刻意不拦」这类看着像遗漏的设计点）。
- `config/config.txt`：`NEWBIE_GUARD*` 配置项说明。

### Credits:

sernseek
