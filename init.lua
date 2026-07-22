----------------------------------------------------------------------------------------------------
-- author: zuorn
-- mail: zuorn@qq.com
-- github: https://github.com/zuorn/hammerspoon_config
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

utils = require("utils")
-- dkjson = require("dkjson")

----------------------------------------------------------------------------------------------------
------------------------------------------ 配置设置 -------------------------------------------------
-- 配置文件
-- 使用自定义配置 （如果存在的话）
----------------------------------------------------------------------------------------------------
custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
if custom_config then
	print("加载自定义配置文件。")
	dofile(os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
	privatepath = hs.fs.pathToAbsolute(hs.configdir .. "/private/config.lua")
	if privatepath then
		hs.alert("已发现你的私有配置，将优先使用它。")
	end
else
	-- 否则使用默认配置
	if not privatepath then
		privatepath = hs.fs.pathToAbsolute(hs.configdir .. "/private")
		-- 如果没有 `~/.hammerspoon/private` 目录，则创建它。
		hs.fs.mkdir(hs.configdir .. "/private")
	end
	privateconf = hs.fs.pathToAbsolute(hs.configdir .. "/private/config.lua")
	if privateconf then
		-- 加载自定义配置，如果存在的话
		print("加载自定义配置，如果存在的话")
		require("private/config")
	end
end

hsreload_keys = hsreload_keys or { { "cmd", "shift", "ctrl" }, "R" }
if string.len(hsreload_keys[2]) > 0 then
	hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "重新加载配置!", function()
		hs.reload()
	end)
	hs.alert.show("配置文件已经重新加载！ ")
end

----------------------------------------------------------------------------------------------------
---------------------------------------- Spoons 加载项 ----------------------------------------------
----------------------------------------------------------------------------------------------------
-- 加载 Spoon
----------------------------------------------------------------------------------------------------
hs.loadSpoon("ModalMgr")

-- 定义默认加载的 Spoons
if not hspoon_list then
	hspoon_list = {
		"AClock", -- 一个钟
		"ClipShow", -- 剪切板
		"VolumeScroll", -- 鼠标滚轮调节音量
		"PopupTranslateSelection", -- 翻译选中文本
		"SpeedMenu", -- 菜单栏显示网速
		"MountedVolumes", -- 显示已安装卷的饼图
		"HeadphoneAutoPause", -- 断开耳机自动暂停播放
		"HSearch",
		"KSheet", -- 快捷键
		"CountDown", -- 倒计时
		"WinWin", -- 窗口管理
	}
end

-- 加载 Spoons
for _, v in pairs(hspoon_list) do
	hs.loadSpoon(v)
end

local module_list = {
	-- "Network",
	-- "Music",
	-- "Window",
	-- "Space",
	-- "Spotlightlike",
	"IME",
	-- "AppKeyMap",
	-- "Hotkey",
	-- "DesktopWidget",
	-- "test",
}
for _, v in ipairs(module_list) do
	require("module." .. v)
	-- if v == "Network" or v == "Music" then
	--	if not string.find(owner, "mini") then
	--		require("module." .. v)
	--	end
	-- else
	--	require("module." .. v)
	-- end
end
----------------------------------------------------------------------------------------------------
--------------------------------------- appM 快速打开应用 ---------------------------------------------
-- appM 模式 快速打开应用
----------------------------------------------------------------------------------------------------
-- spoon.ModalMgr:new("appM")
-- local cmodal = spoon.ModalMgr.modal_list["appM"]
-- cmodal:bind("", "escape", "退出 ", function()
-- 	spoon.ModalMgr:deactivate({ "appM" })
-- end)
-- cmodal:bind("", "Q", "退出 ", function()
-- 	spoon.ModalMgr:deactivate({ "appM" })
-- end)
-- cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
-- if not hsapp_list then
-- 	hsapp_list = {
-- 		{ key = "f", name = "Finder" },
-- 		{ key = "s", name = "Safari" },
-- 		{ key = "t", name = "Terminal" },
-- 		{ key = "v", id = "com.apple.ActivityMonitor" },
-- 		{ key = "y", id = "com.apple.systempreferences" },
-- 	}
-- end
-- for _, v in ipairs(hsapp_list) do
-- 	if v.id then
-- 		local located_name = hs.application.nameForBundleID(v.id)
-- 		if located_name then
-- 			cmodal:bind("", v.key, located_name, function()
-- 				hs.application.launchOrFocusByBundleID(v.id)
-- 				spoon.ModalMgr:deactivate({ "appM" })
-- 			end)
-- 		end
-- 	elseif v.name then
-- 		cmodal:bind("", v.key, v.name, function()
-- 			hs.application.launchOrFocus(v.name)
-- 			spoon.ModalMgr:deactivate({ "appM" })
-- 		end)
-- 	end
-- end

----------------------------------------------------------------------------------------------------
-- 绑定快捷键
----------------------------------------------------------------------------------------------------
-- hsappM_keys = hsappM_keys or { "alt", "A" }
-- if string.len(hsappM_keys[2]) > 0 then
--	spoon.ModalMgr.supervisor:bind(
--		hsappM_keys[1],
--		hsappM_keys[2],
--		" 进入 AppM 模式，快速打开应用",
--		function()
--			spoon.ModalMgr:deactivateAll()
--			spoon.ModalMgr:activate({ "appM" }, "#FFBD2E", true)
--		end
--	)
-- end

----------------------------------------------------------------------------------------------------
---------------------------------------- clipshowM 配置 ---------------------------------------------
----------------------------------------------------------------------------------------------------
-- if spoon.ClipShow then
--	spoon.ModalMgr:new("clipshowM")
--	local cmodal = spoon.ModalMgr.modal_list["clipshowM"]
--	cmodal:bind("", "escape", "退出 剪切板", function()
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--	cmodal:bind("", "Q", "退出 剪切板", function()
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--	cmodal:bind("", "N", "保存此会话", function()
--		spoon.ClipShow:saveToSession()
--	end)
--	cmodal:bind("", "R", "恢复上一个会话", function()
--		spoon.ClipShow:restoreLastSession()
--	end)
--	cmodal:bind("", "B", "在浏览器中打开", function()
--		spoon.ClipShow:openInBrowserWithRef()
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--	cmodal:bind("", "S", "用百度搜索", function()
--		spoon.ClipShow:openInBrowserWithRef("https://www.baidu.com/search?q=")
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--	cmodal:bind("", "F", "保存到桌面", function()
--		spoon.ClipShow:saveToFile()
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--	cmodal:bind("", "H", "在 Github 中搜索", function()
--		spoon.ClipShow:openInBrowserWithRef("https://github.com/search?q=")
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--	cmodal:bind("", "G", "使用 Google 搜索", function()
--		spoon.ClipShow:openInBrowserWithRef("https://www.google.com/search?q=")
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--	cmodal:bind("", "L", "用 Sublime Text 打开", function()
--		spoon.ClipShow:openWithCommand("/usr/local/bin/subl")
--		spoon.ClipShow:toggleShow()
--		spoon.ModalMgr:deactivate({ "clipshowM" })
--	end)
--
--	-- 绑定功 clipshowM 快捷键
--	hsclipsM_keys = hsclipsM_keys or { "alt", "C" }
--	if string.len(hsclipsM_keys[2]) > 0 then
--		spoon.ModalMgr.supervisor:bind(hsclipsM_keys[1], hsclipsM_keys[2], "打开剪切板面板", function()
--			spoon.ClipShow:toggleShow()
--			if spoon.ClipShow.canvas:isShowing() then
--				spoon.ModalMgr:deactivateAll()
--				spoon.ModalMgr:activate({ "clipshowM" })
--			end
--		end)
--	end
-- end

----------------------------------------------------------------------------------------------------
-- 绑定 AClock 快捷键
----------------------------------------------------------------------------------------------------
-- if spoon.AClock then
--	hsaclock_keys = hsaclock_keys or { "alt", "T" }
--	if string.len(hsaclock_keys[2]) > 0 then
--		spoon.ModalMgr.supervisor:bind(hsaclock_keys[1], hsaclock_keys[2], "时钟", function()
--			spoon.AClock:toggleShow()
--		end)
--	end
-- end
--
----------------------------------------------------------------------------------------------------
--  绑定 PopupTranslateSelection 快捷键
----------------------------------------------------------------------------------------------------
-- 弹出选中词的翻译面板
-- esc 退出翻译面板
-- return 键复制翻译结果

----------------------------------------------------------------------------------------------------
-- 粘贴浏览器最前置的标题和地址
----------------------------------------------------------------------------------------------------
-- hstype_keys = hstype_keys or { "alt", "V" }
-- if string.len(hstype_keys[2]) > 0 then
--	spoon.ModalMgr.supervisor:bind(
--		hstype_keys[1],
--		hstype_keys[2],
--		"粘贴浏览器最前置页面标题和地址",
--		function()
--			local safari_running = hs.application.applicationsForBundleID("com.apple.Safari")
--			local chrome_running = hs.application.applicationsForBundleID("com.google.Chrome")
--			if #safari_running > 0 then
--				local stat, data = hs.applescript(
--					'tell application "Safari" to get {URL, name} of current tab of window 1'
--				)
--				if stat then
--					hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")")
--				end
--			elseif #chrome_running > 0 then
--				local stat, data = hs.applescript(
--					'tell application "Google Chrome" to get {URL, title} of active tab of window 1'
--				)
--				if stat then
--					hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")")
--				end
--			end
--		end
--	)
-- end

----------------------------------------------------------------------------------------------------
-- Hammerspoon 搜索
----------------------------------------------------------------------------------------------------
-- if spoon.HSearch then
--	hsearch_keys = hsearch_keys or { "alt", "G" }
--	if string.len(hsearch_keys[2]) > 0 then
--		spoon.ModalMgr.supervisor:bind(hsearch_keys[1], hsearch_keys[2], "启动 Hammerspoon 搜索", function()
--			spoon.HSearch:toggleShow()
--		end)
--	end
-- end

----------------------------------------------------------------------------------------------------
-- 定义各种模式快捷键绑定
----------------------------------------------------------------------------------------------------
-- 定义 windowHints 快捷键
----------------------------------------------------------------------------------------------------
-- hswhints_keys = hswhints_keys or { "alt", "tab" }
-- if string.len(hswhints_keys[2]) > 0 then
-- 	spoon.ModalMgr.supervisor:bind(hswhints_keys[1], hswhints_keys[2], "WindowHints 快速切换应用", function()
-- 		spoon.ModalMgr:deactivateAll()
-- 		hs.hints.windowHints()
-- 	end)
-- end

----------------------------------------------------------------------------------------------------
-- 快捷显示 Hammerspoon 控制台
----------------------------------------------------------------------------------------------------
--hsconsole_keys = hsconsole_keys or { { "alt", "shift" }, "C" }
--if string.len(hsconsole_keys[2]) > 0 then
--	spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "打开 Hammerspoon 控制台", function()
--		hs.toggleConsole()v
--	end)
--end

----------------------------------------------------------------------------------------------------
-- 在浏览器中打开 Hammerspoon API 手册
----------------------------------------------------------------------------------------------------
--hsman_keys = hsman_keys or { { "alt", "shift" }, "A" }
-- hsman_keys = hsman_keys or { { "alt", "shift" }, "A" }
--if string.len(hsman_keys[2]) > 0 then
--	spoon.ModalMgr.supervisor:bind(hsman_keys[1], hsman_keys[2], "查看 Hammerspoon 手册", function()
--		hs.doc.hsdocs.forceExternalBrowser(true)
--	hs.doc.hsdocs.moduleEntitiesInSidebar(true)
--	hs.doc.hsdocs.help()
--end)
--end

----------------------------------------------------------------------------------------------------
-- countdownM 倒计时配置
----------------------------------------------------------------------------------------------------
if spoon.CountDown then
	spoon.ModalMgr:new("countdownM")
	local cmodal = spoon.ModalMgr.modal_list["countdownM"]
	cmodal:bind("", "escape", "退出面板", function()
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	cmodal:bind("", "Q", "退出面板", function()
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	-- cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
	cmodal:bind("", "0", "1 分钟", function()
		spoon.CountDown:startFor(1)
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	for i = 1, 9 do
		cmodal:bind("", tostring(i), string.format("%s 分钟", 10 * i), function()
			spoon.CountDown:startFor(10 * i)
			spoon.ModalMgr:deactivate({ "countdownM" })
		end)
	end
	cmodal:bind("", "return", "25 分钟 ", function()
		spoon.CountDown:startFor(25)
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)
	cmodal:bind("", "space", "暂停和恢复倒计时", function()
		spoon.CountDown:pauseOrResume()
		spoon.ModalMgr:deactivate({ "countdownM" })
	end)

	-- 定义打开倒计时面板快捷键
	hscountdM_keys = hscountdM_keys or { "alt", "I" }
	if string.len(hscountdM_keys[2]) > 0 then
		spoon.ModalMgr.supervisor:bind(hscountdM_keys[1], hscountdM_keys[2], "进入倒计时面板", function()
			spoon.ModalMgr:deactivateAll()
			-- 显示倒计时面板
			spoon.ModalMgr:activate({ "countdownM" }, "#FF6347", true)
		end)
	end
end

----------------------------------------------------------------------------------------------------
-- 锁屏
----------------------------------------------------------------------------------------------------
-- hslock_keys = { "cmd", "L" }
-- if string.len(hslock_keys[2]) > 0 then
--	spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "锁屏", function()
--		hs.caffeinate.lockScreen()
--	end)
-- end

----------------------------------------------------------------------------------------------------
-- 窗口管理
----------------------------------------------------------------------------------------------------
if spoon.WinWin then
	print("WinWine load")
	spoon.ModalMgr:new("resizeM")
	local cmodal = spoon.ModalMgr.modal_list["resizeM"]
	cmodal:bind("", "escape", "退出 ", function()
		spoon.ModalMgr:deactivate({ "resizeM" })
	end)
	cmodal:bind("", "Q", "退出", function()
		spoon.ModalMgr:deactivate({ "resizeM" })
	end)
	cmodal:bind("", "tab", "键位提示", function()
		spoon.ModalMgr:toggleCheatsheet()
	end)

	cmodal:bind(
		"",
		"A",
		"向左移动",
		function()
			spoon.WinWin:stepMove("left")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("left")
		end
	)
	cmodal:bind(
		"",
		"D",
		"向右移动",
		function()
			spoon.WinWin:stepMove("right")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("right")
		end
	)
	cmodal:bind(
		"",
		"W",
		"向上移动",
		function()
			spoon.WinWin:stepMove("up")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("up")
		end
	)
	cmodal:bind(
		"",
		"S",
		"向下移动",
		function()
			spoon.WinWin:stepMove("down")
		end,
		nil,
		function()
			spoon.WinWin:stepMove("down")
		end
	)

	cmodal:bind("", "H", "左半屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfleft")
	end)
	cmodal:bind("", "L", "右半屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfright")
	end)
	cmodal:bind("", "K", "上半屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfup")
	end)
	cmodal:bind("", "J", "下半屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("halfdown")
	end)

	cmodal:bind("", "Y", "屏幕左上角", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerNW")
	end)
	cmodal:bind("", "O", "屏幕右上角", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerNE")
	end)
	cmodal:bind("", "U", "屏幕左下角", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerSW")
	end)
	cmodal:bind("", "I", "屏幕右下角", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("cornerSE")
	end)

	cmodal:bind("", "F", "全屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("fullscreen")
	end)
	cmodal:bind("", "C", "居中", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("center")
	end)
	cmodal:bind("", "G", "左三分之二屏居中分屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("centermost")
	end)
	cmodal:bind("", "Z", "展示显示", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("show")
	end)
	cmodal:bind("", "V", "编辑显示", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("shows")
	end)

	cmodal:bind("", "X", "进入我要的模式", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("center-2")
	end)
	cmodal:bind("", "9", "进入我缩小要的模式", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("center-3")
	end)

	cmodal:bind(
		"",
		"=",
		"窗口放大",
		function()
			spoon.WinWin:moveAndResize("expand")
		end,
		nil,
		function()
			spoon.WinWin:moveAndResize("expand")
		end
	)
	cmodal:bind(
		"",
		"-",
		"窗口缩小",
		function()
			spoon.WinWin:moveAndResize("shrink")
		end,
		nil,
		function()
			spoon.WinWin:moveAndResize("shrink")
		end
	)

	cmodal:bind(
		"ctrl",
		"H",
		"向左收缩窗口",
		function()
			spoon.WinWin:stepResize("left")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("left")
		end
	)
	cmodal:bind(
		"ctrl",
		"L",
		"向右扩展窗口",
		function()
			spoon.WinWin:stepResize("right")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("right")
		end
	)
	cmodal:bind(
		"ctrl",
		"K",
		"向上收缩窗口",
		function()
			spoon.WinWin:stepResize("up")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("up")
		end
	)
	cmodal:bind(
		"ctrl",
		"J",
		"向下扩镇窗口",
		function()
			spoon.WinWin:stepResize("down")
		end,
		nil,
		function()
			spoon.WinWin:stepResize("down")
		end
	)

	cmodal:bind("", "left", "窗口移至左边屏幕", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("left")
	end)
	cmodal:bind("", "right", "窗口移至右边屏幕", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("right")
	end)
	cmodal:bind("", "up", "窗口移至上边屏幕", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("up")
	end)
	cmodal:bind("", "down", "窗口移动下边屏幕", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("down")
	end)
	cmodal:bind("", "space", "窗口移至下一个屏幕", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveToScreen("next")
	end)
	cmodal:bind("", "B", "撤销最后一个窗口操作", function()
		spoon.WinWin:undo()
	end)
	cmodal:bind("", "R", "重做最后一个窗口操作", function()
		spoon.WinWin:redo()
	end)

	cmodal:bind("", "[", "左三分之二屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("mostleft")
	end)
	cmodal:bind("", "]", "右三分之二屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("mostright")
	end)
	cmodal:bind("", ",", "左三分之一屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("lesshalfleft")
	end)
	cmodal:bind("", ".", "中分之一屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("onethird")
	end)
	cmodal:bind("", "/", "右三分之一屏", function()
		spoon.WinWin:stash()
		spoon.WinWin:moveAndResize("lesshalfright")
	end)

	cmodal:bind("", "t", "将光标移至所在窗口中心位置", function()
		spoon.WinWin:centerCursor()
	end)

	-- 定义窗口管理模式快捷键
	hsresizeM_keys = hsresizeM_keys or { "ctl", "shift", "W" }
	if string.len(hsresizeM_keys[2]) > 0 then
		spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "进入窗口管理模式", function()
			spoon.ModalMgr:deactivateAll()
			-- 显示状态指示器，方便查看所处模式
			spoon.ModalMgr:activate({ "resizeM" }, "#B22222")
		end)
	end
end

----------------------------------------------------------------------------------------------------
-- 绑定 KSheet 面板 快捷键
----------------------------------------------------------------------------------------------------
if spoon.KSheet then
	spoon.ModalMgr:new("cheatsheetM")
	local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
	cmodal:bind("", "escape", "Deactivate cheatsheetM", function()
		spoon.KSheet:hide()
		spoon.ModalMgr:deactivate({ "cheatsheetM" })
	end)
	cmodal:bind("", "Q", "Deactivate cheatsheetM", function()
		spoon.KSheet:hide()
		spoon.ModalMgr:deactivate({ "cheatsheetM" })
	end)

	-- 定义快捷键
	hscheats_keys = hscheats_keys or { "alt", "H" }
	if string.len(hscheats_keys[2]) > 0 then
		spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "显示应用快捷键", function()
			spoon.KSheet:show()
			spoon.ModalMgr:deactivateAll()
			spoon.ModalMgr:activate({ "cheatsheetM" })
		end)
	end
end

----------------------------------------------------------------------------------------------------
-- 初始化 modalMgr
----------------------------------------------------------------------------------------------------

spoon.ModalMgr.supervisor:enter()

----------------------------------------------------------------------------------------------------
-------------------------------------------- vincnet.yeung -----------------------------------------
----------------------------------------------------------------------------------------------------

-- Set hyper to ctrl + alt + cmd + shift
-- local hyper      = {'ctrl', 'cmd', 'alt', 'shift'}
-- local hyper = {'cmd'}
-- hyper:https://zhuanlan.zhihu.com/p/71141438?utm_source=wechat_session&utm_medium=social&utm_oi=832042857366982656
local hyper = hyper
local cmd = cmd

-- Move Mouse to center of next Monitor
-- 快捷键：cmd+· 选择下一个屏幕
function fMoveMouseToCenterOfNextMonitor()
	local screen = hs.mouse.getCurrentScreen()
	local nextScreen = screen:next()
	local rect = nextScreen:fullFrame()
	local center = hs.geometry.rectMidPoint(rect)
	local absolutePosition = hs.mouse.absolutePosition(center)

	-- 左键点击
	hs.eventtap.leftClick(absolutePosition)

	-- spoon.WinWin:centerCursor()
	-- local frontmostWindow = hs.window.focusedWindow()
	-- local focus = frontmostWindow:focus()
	-- hs.alert(focus)
	-- local focusApplication = frontmostWindow:application()
	-- hs.alert("切换指针到下个屏幕")
	-- hs.alert("选中软件")
	-- hs.alert(focusApplication:name())
end

-- 将屏幕分为上下左右四个布局
-- 快捷键：cmd+3 建立屏幕布局于快捷键的绑定，鼠标定位，hyper + a 回到主屏幕，hyper + up 回到主屏幕上的一个屏幕，hyper + down 回到主屏幕下的一个屏幕，hyper + left 回到主屏幕左边的屏幕，hyper + right 回到主屏幕右边的屏幕，
local screenMap = {}
function getScreens()
	-- master/上/左/右/map
	master, up, left, right, down = "master", "w", "a", "d", "z"
	textScreens = "当前Mac连接的显示器有："
	screenCount = 0
	local position = hs.screen.screenPositions()
	if position ~= "nil" then
		for hsScreenObj, positionVaule in pairs(position) do
			print(positionVaule["x"] .. "<x y>" .. positionVaule["y"])
			screenCount = screenCount + 1
			if positionVaule["x"] == 0 and positionVaule["y"] == 0 then
				textScreens = textScreens .. master .. ", "
				screenMap[master] = hsScreenObj
			elseif positionVaule["x"] == 0 and positionVaule["y"] == -1 then
				textScreens = textScreens .. up .. ", "
				screenMap[up] = hsScreenObj
			elseif positionVaule["x"] == 0 and positionVaule["y"] == 1 then
				textScreens = textScreens .. down .. ", "
				screenMap[down] = hsScreenObj
				-- elseif( positionVaule["x"]==-1 and positionVaule["y"]==0 )
			elseif positionVaule["x"] == -1 then
				textScreens = textScreens .. left .. ", "
				screenMap[left] = hsScreenObj
				-- elseif( positionVaule["x"]==1 and positionVaule["y"]==0 )
			elseif positionVaule["x"] == 1 then
				textScreens = textScreens .. right .. ", "
				screenMap[right] = hsScreenObj
			else
				print("xxxxxscreen")
			end
		end
	end

	for key, screen in pairs(screenMap) do
		if key == master then
			hs.hotkey.bind(hyper, "s", function()
				local rect = screen:fullFrame()
				local center = hs.geometry.rectMidPoint(rect)
				local absolutePosition = hs.mouse.absolutePosition(center)
				-- 左键点击
				hs.eventtap.leftClick(absolutePosition)
			end)
		else
			hs.hotkey.bind(hyper, key, function()
				local rect = screen:fullFrame()
				local center = hs.geometry.rectMidPoint(rect)
				local absolutePosition = hs.mouse.absolutePosition(center)
				-- 左键点击
				hs.eventtap.leftClick(absolutePosition)
			end)
		end
	end
	textScreens = textScreens
		.. "共计:"
		.. screenCount
		.. "块屏幕."
		.. "\n                            绑定键位加载完成。。"
	hs.alert(textScreens)
end

function getaVailableModes()
	-- master/上/左/右/map
	--	master, up, left, right, down = "master", "w", "a", "d", "z"
	--	textScreens = "当前Mac连接的显示器有："
	screenCount = 1
	local plhDisplay = {}
	uuid = "B14185A3-6ADA-4DF8-A5BD-7916E668998B"
	id = 3
	local screenMap = hs.screen.screenPositions()
	if screenMap ~= "nil" then
		for hsScreenObj, positionVaule in pairs(screenMap) do
			print(positionVaule["x"] .. "<x y>" .. positionVaule["y"])
			print("uuid:" .. hsScreenObj:getUUID())
			print("id:" .. hsScreenObj:id())
			print(screenCount .. "screen")
			if hsScreenObj:getUUID() == uuid then
				plhDisplay = hsScreenObj
			end
			if hsScreenObj:id() == id then
				plhDisplay = hsScreenObj
			end
			local screenModeMap = hsScreenObj:availableModes()
			for k, v in pairs(screenModeMap) do
				print(k)
				print(v)
				for key, value in pairs(v) do
					print(key)
					print(value)
				end
				print("================")
			end
			screenCount = screenCount + 1
		end
		local plhDisplayModeMap = plhDisplay:currentMode()
		print("飞利浦屏幕当前参数" .. plhDisplay:name())
		local width = 0
		local height = 0
		local scale = 0
		local frequency = 0
		local depth = 0
		for keyp, valuep in pairs(plhDisplayModeMap) do
			print(keyp)
			print(valuep)
			if keyp == "w" then
				width = valuep
			end
			if keyp == "h" then
				height = valuep
			end
			if keyp == "scale" then
				scale = valuep
			end
			if keyp == "freq" then
				frequency = valuep
			end
			if keyp == "depth" then
				depth = valuep
			end
		end
		print("设置当前屏幕参数")
		print(width .. scale .. height .. depth .. frequency)
		-- local result = plhDisplay:setMode(width, height, scale, frequency, depth)
		-- print(result)
	end
end

-- 获取显示的基本参数
-- hs.hotkey.bind(cmd, "4", function()
-- 	getaVailableModes()
-- end)

-- local testCallbackFn = function(result)
-- 	print("回调结果: " .. result)
-- end
-- --hs.dialog.alert(100,100,testCallbackFn,"消息","信息文本","按钮"","按钮二","NSCriticalAlertStyle")
-- --hs.dialog.alert(200, 200, testCallbackFn, "Message", "Informative Text", "Single Button")
-- testCallbackFn = function(result)
-- 	print("Callback Result: " .. result)
-- end
-- testWebviewA = hs.webview.newBrowser(hs.geometry.rect(250, 250, 250, 250)):show()
-- testWebviewB = hs.webview.newBrowser(hs.geometry.rect(450, 450, 450, 450)):show()
-- hs.dialog.webviewAlert(testWebviewA, testCallbackFn, "Message", "Informative Text", "Button One", "Button Two", "warning")
-- hs.dialog.webviewAlert(testWebviewB, testCallbackFn, "Message", "Informative Text", "Single Button")
-- hs.hotkey.bind(cmd, "5", function()
-- 	--hs.dialog.alert(200, 200, testCallbackFn, "Message", "Informative Text", "Single Button")
-- 	--hs.dialog.alert(100, 100, testCallbackFn, "显示器", "帧率选择", "144hz", "120hz", "NSCriticalAlertStyle")
-- 	hs.dialog.webviewAlert(
-- 		testWebviewA,
-- 		testCallbackFn,
-- 		"Message",
-- 		"Informative Text",
-- 		"Button One",
-- 		"Button Two",
-- 		"NSCriticalAlertStyle"
-- 	)
-- end)
-- 增加自己窗口模式

function windowMy()
	spoon.WinWin:stash()
	spoon.WinWin:moveAndResize("center-2")
end

function nextDisplayWindowMy()
	spoon.WinWin:stash()
	spoon.WinWin:moveToScreen("next")
	spoon.WinWin:moveAndResize("center-2")
end

function windowMax()
	spoon.WinWin:stash()
	spoon.WinWin:moveAndResize("fullscreen")
end

function windowHalfleft()
	spoon.WinWin:stash()
	spoon.WinWin:moveAndResize("halfleft")
end

function windowhalfright()
	spoon.WinWin:stash()
	spoon.WinWin:moveAndResize("halfright")
end

-- Press Cmd+Q twice to quit
local quitModal = hs.hotkey.modal.new(hDPressCmdQTwiceToQuitKeys[1], hDPressCmdQTwiceToQuitKeys[2])
function quitModal:entered()
	hs.alert.show("再次键入Cmd+Q退出程序", 1)
	hs.timer.doAfter(1, function()
		quitModal:exit()
	end)
end

local function doQuit()
	local app = hs.application.frontmostApplication()
	app:kill()
end
quitModal:bind("", "escape", function()
	quitModal:exit()
end)

-- keymap('i', 'ctrl+cmd+alt+shift', 'home', '')
-- keymap('k', 'ctrl+cmd+alt+shift', 'end', '')
-- keymap('o', 'ctrl+cmd+alt+shift', 'pageup', '')
-- keymap('l', 'ctrl+cmd+alt+shift', 'pagedown', '')
-- keymap('j', 'ctrl+cmd+alt+shift', 'delete', '')
-- keymap('0', 'ctrl+cmd+alt+shift', 'PLAY', nil, NO_REPEAT)

-- Set hyper to ctrl + alt + cmd + shift
-- local hyperex = require('hyperex')
-- local hx = hyperex.new('capslock')
-- local rightCmd = hyperex.new('rightctrl')

-- hx:mod({'cmd', 'shift','alt','ctrl'}):to('3','4')

-- rightCmd:bind('j'):to('delete')
-- rightCmd:bind('i'):to('home')
-- rightCmd:bind('k'):to('end')
-- rightCmd:bind('o'):to('pageup')
-- rightCmd:bind('l'):to('pagedown')
-- rightCmd:bind('j'):to('forwarddelete')
-- function() hs.eventtap.keyStroke({}, 'h') end

-- hs.hotkey.bind(hyper, "i", function()
-- 	print("kaishizhixing")
-- 	hs.eventtap.keyStroke({}, 'home',0)
-- end)

-- hs.hotkey.bind(hyper, "k", function()
-- 	hs.eventtap.keyStroke({}, 'end',0)
-- end)

local REPEAT_FASTER = 600

local function keyStrokeSystem(key, repeatDelay)
	hs.eventtap.event.newSystemKeyEvent(key, true):post()
	if repeatDelay <= 0 then
		repeatDelay = REPEAT_FASTER
	end
	hs.timer.usleep(repeatDelay)
	hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

local function keyStroke(mod, key, repeatDelay)
	hs.eventtap.event.newKeyEvent(mod, key, true):post()
	if repeatDelay <= 0 then
		repeatDelay = REPEAT_FASTER
	end
	hs.timer.usleep(repeatDelay)
	hs.eventtap.event.newKeyEvent(mod, key, false):post()
end

function pauseMusic()
	print("暂停音乐")
	local key = "PLAY"
	local repeatDelay = -1
	hs.alert("播放/暂停")
	keyStrokeSystem(key, repeatDelay)
end

function beforeMusic()
	print("后退音乐")
	local key = "REWIND"
	local repeatDelay = -1
	hs.alert("上一首")
	keyStrokeSystem(key, repeatDelay)
end

function afterMusic()
	print("前进音乐")
	local key = "FAST"
	local repeatDelay = -1
	hs.alert("下一首")
	keyStrokeSystem(key, repeatDelay)
end

-- hs.hotkey.bind(hyper, "i", function()
-- 	print("home")
-- 	local key = 'home'
-- 	local repeatDelay = -1
--    	keyStroke({},key,repeatDelay)
-- end)

-- hs.hotkey.bind(hyper, "k", function()
-- 	print("end")
-- 	local key = 'end'
-- 	local repeatDelay = -1
--    	keyStroke({},key,repeatDelay)
-- end)

-- local deletefn = function()
-- 	print("forwarddelete")
-- 	local key = 'forwarddelete'
-- 	local repeatDelay = -1
--    	keyStroke({},key,repeatDelay)
--    	fn = hs.fnutils.partial(keyStroke, {}, key, repeatDelay)
--    	return fn
-- end

-- hs.hotkey.bind('ctrl+shift+alt+cmd', "j", deletefn,nil,nil)

-- hs.hotkey.bind(hyper, "o", function()
-- 	print("o")
-- 	local key = 'pageup'
-- 	local repeatDelay = -1
--    	keyStroke({},key,repeatDelay)
-- end)
-- ctrlDoublePress = require("ctrlDoublePress")
-- hs.hotkey.bind(hyper, "l", function()
-- 	print("l")
-- 	local key = 'pagedown'
-- 	local repeatDelay = -1
--    	keyStroke({},key,repeatDelay)
-- end)
-- 毫秒是一种较为微小的时间单位，符号为ms，1秒= 10分秒；1分秒= 10厘秒；1厘秒= 10 毫秒；1 毫秒= 1000微秒；1微秒= 1000纳秒；1纳秒= 1000皮秒。
-- 双击cmd切换输入法
-- local function ctrlDoublePressKeyStroke(mod, key, repeatDelay)
--     hs.eventtap.event.newKeyEvent(mod, key, true):post()
--    if repeatDelay <= 0 then
--         repeatDelay = REPEAT_FASTER
--     end
--     --usleep 微秒计算
--     hs.timer.usleep(repeatDelay)
--     hs.eventtap.event.newKeyEvent(mod, key, false):post()
-- end
-- ctrlDoublePress.timeFrame = 1
-- ctrlDoublePress.action = function()
--    	print("ctrlDoublePress")
-- 	local key = 'space'
-- 	local repeatDelay = 50000
--    	ctrlDoublePressKeyStroke({"ctrl"},key,repeatDelay)
-- end
local changingNetwork = false

local logger = hs.logger.new("==logger==", "info")

local function getCurrentWiFiNetwork()
	local networkInfo, success, _ = hs.execute("/usr/sbin/networksetup -getairportnetwork en0")
	local result = networkInfo
	logger.d("1", success, "1")
	logger.d("2", result, "2")
	-- print("命令输出：", networkInfo) -- 打印命令输出内容，以便查看实际内容
	if success then
		local currentNetwork = networkInfo:match("Current Wi%-Fi Network:%s*(.-)%s*$")
		return currentNetwork
	else
		return nil
	end
end

local function handleSW()
	local success, result = pcall(function()
		-- 可能会抛出异常的代码块
		-- local currentNetwork = hs.wifi.currentNetwork()
		local currentNetwork = getCurrentWiFiNetwork()
		logger.d("当前网络为:", currentNetwork)
		-- 这里可以添加连接时执行的操作"Automatic|GFW公司|GFW家"
		if currentNetwork ~= nil then
			logger.i("Wi-Fi connected")
			changingNetwork = true
			hs.timer.doAfter(1.5, function()
				-- local cmd = "/usr/sbin/networksetup -getcurrentlocation"
				-- local handle = io.popen(cmd)
				-- local result = handle:read("*a")
				-- handle:close()

				local tcurrentlocation, success, _ = hs.execute("/usr/sbin/networksetup -getcurrentlocation")
				local trimmedResult = tcurrentlocation:match("^%s*(.-)%s*$") -- 修剪字符串
				logger.i("当前网络位置:" .. trimmedResult)
				if currentNetwork == "FLOWES" then
					if trimmedResult == "GFW家" then
						hs.execute("networksetup -switchtolocation 'Automatic'")
						logger.i("networksetup -switchtolocation 'Automatic'")
						hs.alert.show("网络配置，已切换到『自动』")
					elseif trimmedResult == "Automatic" then
						hs.execute("networksetup -switchtolocation 'GFW家'")
						logger.i("networksetup -switchtolocation 'GFW家'")
						hs.alert.show("网络配置，已切换到『GFW家』")
					else
						hs.execute("networksetup -switchtolocation 'Automatic'")
						logger.i("networksetup -switchtolocation 'Automatic'")
						hs.alert.show("网络配置，已切换到『自动』")
					end
				elseif currentNetwork == "TT-QuWan-Staff" then
					if trimmedResult == "GFW公司" then
						hs.execute("networksetup -switchtolocation 'Automatic'")
						logger.i("networksetup -switchtolocation 'Automatic'")
						hs.alert.show("网络配置，已切换到『自动』")
					elseif trimmedResult == "Automatic" then
						hs.execute("networksetup -switchtolocation 'GFW公司'")
						logger.i("networksetup -switchtolocation 'GFW公司'")
						hs.alert.show("网络配置，已切换到『GFW公司』")
					else
						hs.execute("networksetup -switchtolocation 'Automatic'")
						logger.i("networksetup -switchtolocation 'Automatic'")
						hs.alert.show("网络配置，已切换到『自动』")
					end
				else
					if trimmedResult ~= "Automatic" then
						hs.execute("networksetup -switchtolocation 'Automatic'")
						logger.i("networksetup -switchtolocation 'Automatic'")
						hs.alert.show("网络配置，已切换到『自动』")
					end
				end
				-- 重置标志位，允许下一次网络变化时执行
				changingNetwork = false
			end)
		end
	end)

	if success then
		logger.d("wifi监控执行成功:")
	else
		logger.e("wifi监控执行出错:", result)
	end
end

hs.hotkey.bind("ctrl+cmd+alt+shift", "w", function()
	hs.alert.show("切换『网络位置配置』中")
	handleSW()
end)

local wifiWatcher = nil

local function startWifiWatcher()
	local success, result = pcall(function()
		logger.d("开始执行")
		wifiWatcher = hs.wifi.watcher.new(function(watcher, message, interface)
			handleSW()
		end)
	end)

	if success then
		logger.i("监控器执行成功")
	else
		logger.e("监控器执行出错:", result)
	end

	wifiWatcher:start()
end
-- 执行开始
-- startWifiWatcher()

local function restartWifiWatcher()
	logger.i("重置监控器开始")
	if wifiWatcher then
		logger.i("重置监控器...")
		wifiWatcher:stop()
		wifiWatcher = nil
	end
	startWifiWatcher() -- 重新启动观察器
	logger.i("重置监控器完成")
end

-- 每隔一段时间重新启动观察器
-- hs.timer.doEvery(60 * 60, function() -- 每隔一小时
--	restartWifiWatcher()
-- end)

----------------------------------------------------------------------------------------------------
------------------------------------------ 配置设置 -------------------------------------------------
-- 快捷键
--
---------------------------------------------------------------------------------------------------

-- 快捷键：alt+shift + / 查看快捷键设置
-- 快捷键：cmd+· 选择下一个屏幕
spoon.ModalMgr.supervisor:bind(
	hDisplayBindKeys[1],
	hDisplayBindKeys[2],
	"快捷键：cmd+· 选择下一个屏幕",
	getScreens
)
-- 获取全部显示器并绑定快捷键（生成绑定快捷键关系），用于鼠标指针快速定位到当前屏幕
hs.hotkey.bind(
	hMoveMouseToCenterOfNextMonitorKeys[1],
	hMoveMouseToCenterOfNextMonitorKeys[2],
	"获取全部显示器并绑定快捷键",
	fMoveMouseToCenterOfNextMonitor
)
-- 设置程序默认输入法
local choicesFn = function() end
hs.hotkey.bind(hSetDefaultInputKeys[1], hSetDefaultInputKeys[2], ChoicesFn)
spoon.ModalMgr.supervisor:bind(
	hSetDefaultInputKeys[1],
	hSetDefaultInputKeys[2],
	"设置程序默认输入法",
	choicesFn
)
-- 切换输入法快捷键
-- local chinese = function() end
-- hs.hotkey.bind(hyper_oc, "up", Chinese)
-- hs.hotkey.bind(hSetChInputKeys[1], hSetChInputKeys[2], Chinese)
-- spoon.ModalMgr.supervisor:bind(hSetChInputKeys[1], hSetChInputKeys[2], "切换简体拼音", chinese)
-- hs.hotkey.bind(hyper_oc, "down", English)
-- local english = function() end
-- hs.hotkey.bind(hSetEngInputKeys[1], hSetEngInputKeys[2], English)
-- spoon.ModalMgr.supervisor:bind(hSetEngInputKeys[1], hSetEngInputKeys[2], "切换英文abc", english)
-- hs.hotkey.bind(hyper_oc, '.', Japanese)
-- 我的窗口模式
hs.hotkey.bind(hWindowMyKeys[1], hWindowMyKeys[2], windowMy)
local windowMy1 = function() end
spoon.ModalMgr.supervisor:bind(hWindowMyKeys[1], hWindowMyKeys[2], "我的窗口模式", windowMy1)
-- 移动下个屏幕我的窗口
hs.hotkey.bind(hNextDisplayWindowMyKeys[1], hNextDisplayWindowMyKeys[2], nextDisplayWindowMy)
local nextDisplayWindowMy1 = function() end
spoon.ModalMgr.supervisor:bind(
	hNextDisplayWindowMyKeys[1],
	hNextDisplayWindowMyKeys[2],
	"移动下个屏幕我的窗口",
	nextDisplayWindowMy1
)
-- 窗口最大化
hs.hotkey.bind(hWindowMaxKeys[1], hWindowMaxKeys[2], windowMax)
local windowMax1 = function() end
spoon.ModalMgr.supervisor:bind(hWindowMaxKeys[1], hWindowMaxKeys[2], "窗口最大化", windowMax1)
-- 窗口移动左面
hs.hotkey.bind(hWindowHalfleftKeys[1], hWindowHalfleftKeys[2], windowHalfleft)
local windowHalfleft1 = function() end
spoon.ModalMgr.supervisor:bind(hWindowHalfleftKeys[1], hWindowHalfleftKeys[2], "窗口移动左面", windowHalfleft1)
-- 窗口移动右面
hs.hotkey.bind(hWindowHalfrightKeys[1], hWindowHalfrightKeys[2], windowhalfright)
local windowhalfright1 = function() end
spoon.ModalMgr.supervisor:bind(hWindowHalfrightKeys[1], hWindowHalfrightKeys[2], "窗口移动右面", windowhalfright1)
-- 双击两次cmd+q退出
-- quitModal:bind(hDPressCmdQTwiceToQuitKeys[1], hDPressCmdQTwiceToQuitKeys[2], doQuit)
spoon.ModalMgr.supervisor:bind(
	hDPressCmdQTwiceToQuitKeys[1],
	hDPressCmdQTwiceToQuitKeys[2],
	"双击两次cmd+q退出",
	doQuit
)
-- 音乐暂停
hs.hotkey.bind(hPauseMusicKeys[1], hPauseMusicKeys[2], pauseMusic)
spoon.ModalMgr.supervisor:bind(hPauseMusicKeys[1], hPauseMusicKeys[2], "音乐暂停", pauseMusic)
-- 音乐上一首
hs.hotkey.bind(hBeforeMusicKeys[1], hBeforeMusicKeys[2], beforeMusic)
-- spoon.ModalMgr.supervisor:bind(hBeforeMusicKeys[1], hBeforeMusicKeys[2], "音乐上一首", beforeMusic)
-- 音乐下一首
hs.hotkey.bind(hAfterMusicKeys[1], hAfterMusicKeys[2], afterMusic)
-- spoon.ModalMgr.supervisor:bind(hAfterMusicKeys[1], hAfterMusicKeys[2], "音乐下一首", afterMusic)

----------------------------------------------------------------------------------------------------
-------------------------------------------- End ---------------------------------------------------
----------------------------------------------------------------------------------------------------
