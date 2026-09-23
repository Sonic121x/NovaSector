# 汉化版更新日志

游戏内「更新日志」窗口的「汉化版更新」页签读取这里的 `archive/YYYY-MM.yml`。
这里只记录本汉化仓库自己的、玩家能感知到的改动；Nova Sector 上游的更新仍在 `html/changelogs/archive/`，两者互不干扰，同步上游不会冲突。

## 新增条目

1. 在本目录新建一个 `.yml`（文件名随意，`example` 与 `.` 开头的会被忽略），格式与 `html/changelogs/example.yml` 相同：

   ```yaml
   author: "sernseek"
   delete-after: True
   changes:
     - bugfix: "修复……"
     - rscadd: "新增……"
   ```

   可选字段 `date: YYYY-MM-DD` 用于把改动记到它实际上线的日期，不写则记为当天。
   条目类型与上游相同：`bugfix` `rscadd` `rscdel` `qol` `spellcheck` `balance` `code_imp` `refactor` `config` `admin` `server` `image` `sound` `map` 等。

2. 编译进月份文件（会删掉 `delete-after: True` 的源文件）：

   ```sh
   nix-shell -p 'python3.withPackages (ps: [ps.pyyaml])' --run 'python3 tools/i18n/compile-localization-changelog.py'
   ```

3. 连同 `archive/` 的改动一起提交。
