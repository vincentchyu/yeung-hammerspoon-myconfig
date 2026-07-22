hyper_oc = { "ctrl+cmd+alt+shift" }
local alert = require("hs.alert")
local k = require("hs.keycodes")
local ch_input = "com.apple.inputmethod.SCIM.ITABC"
local squirrel_input = "im.rime.inputmethod.Squirrel.Hans"
local jp_input = "com.apple.inputmethod.Kotoeri.Roman"
local eng_input = "com.apple.keylayout.ABC"
local imeAlertCanvas = nil
local imeAlertTimer = nil
local imeAlertTextSize = 16
local imeAlertPaddingX = 2
local imeAlertWidth = 35
local updateFocusAppInputMethod = nil

local imeDisplayNames = {
	[ch_input] = "拼",
	[squirrel_input] = "鼠",
	[jp_input] = "R",
	[eng_input] = "A",
}

local function currentAppBundleID()
	local win = hs.window.frontmostWindow()
	if win == nil then
		return nil
	end

	local app = win:application()
	if app == nil then
		return nil
	end

	return app:bundleID()
end

local function currentWindowFrame()
	local win = hs.window.frontmostWindow()
	if win ~= nil then
		return win:frame()
	end
	return hs.screen.mainScreen():frame()
end

local function imeAlertFrame()
	local winFrame = currentWindowFrame()
	local width = imeAlertWidth
	local height = 32
	local marginX = 12
	local marginY = 12

	return {
		x = winFrame.x + winFrame.w - width - marginX,
		y = winFrame.y + winFrame.h - height - marginY,
		w = width,
		h = height,
	}
end

local function showImeName(inputSourceID)
	local displayName = imeDisplayNames[inputSourceID] or inputSourceID
	local frame = imeAlertFrame()

	if imeAlertTimer ~= nil then
		imeAlertTimer:stop()
		imeAlertTimer = nil
	end
	if imeAlertCanvas ~= nil then
		imeAlertCanvas:delete()
		imeAlertCanvas = nil
	end

	imeAlertCanvas = hs.canvas.new(frame)
	imeAlertCanvas:level(hs.canvas.windowLevels.overlay)
	imeAlertCanvas:behavior({ "canJoinAllSpaces", "fullScreenAuxiliary" })
	imeAlertCanvas:clickActivating(false)
	imeAlertCanvas:mouseCallback(nil)
	imeAlertCanvas:replaceElements({
		type = "rectangle",
		action = "fill",
		roundedRectRadii = { xRadius = 8, yRadius = 8 },
		fillColor = { black = 0.58, alpha = 0.72 },
		strokeColor = { white = 1, alpha = 0.22 },
		strokeWidth = 1,
		frame = { x = 0, y = 0, w = "100%", h = "100%" },
	}, {
		type = "text",
		text = displayName,
		textSize = imeAlertTextSize,
		textColor = { white = 1, alpha = 0.94 },
		textAlignment = "center",
		frame = { x = imeAlertPaddingX, y = 5, w = frame.w - imeAlertPaddingX * 2, h = frame.h - 8 },
	})
	imeAlertCanvas:show()

	imeAlertTimer = hs.timer.doAfter(1.2, function()
		if imeAlertCanvas ~= nil then
			imeAlertCanvas:delete()
			imeAlertCanvas = nil
		end
		imeAlertTimer = nil
	end)
end

-- 判断英文输入法的种类
local roma = false
for _, value in pairs(k.methods()) do
	if value == "Romaji" then
		roma = true
	end
end
local eng = eng_input
if roma == true then
	eng = jp_input
end
-- 切换为拼音
function Chinese()
	-- k.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
	k.setMethod("Pinyin - Simplified")
	showImeName(ch_input)
end
-- 切换为英文
function English()
	if roma == true then
		k.setMethod("Romaji")
	else
		k.currentSourceID(eng)
	end
	showImeName(eng)
end
-- 切换为Squirrel
function Squirrel()
	k.setMethod("Squirrel - Simplified")
	showImeName(squirrel_input)
end

-- 设置App对应的输入法
local App2ImeTable = {
	["com.apple.finder"] = squirrel_input,
	["com.apple.Photos"] = squirrel_input,
	["com.apple.MobileSMS"] = squirrel_input,
	["com.apple.Spotlight"] = eng_input,
	["com.apple.dt.Xcode"] = eng_input,
	["org.hammerspoon.Hammerspoon"] = squirrel_input,
	["com.apple.systempreferences"] = squirrel_input,
	["com.apple.Safari"] = ch_input,
	["com.apple.Notes"] = squirrel_input,
	["com.apple.Terminal"] = eng_input,
	["com.jetbrains.goland"] = eng_input,
	["com.googlecode.iterm2"] = eng_input,
	["com.apple.Music"] = squirrel_input,
	["com.tencent.xinWeChat"] = squirrel_input,
	["com.microsoft.Word"] = squirrel_input,
	["com.microsoft.Excel"] = squirrel_input,
	["com.kingsoft.wpsoffice.mac"] = squirrel_input,
	["com.google.GeminiMacOS"] = squirrel_input,
	["com.openai.codex"] = squirrel_input,
	["com.jetbrains.pycharm"] = eng_input,
	["com.coteditor.CotEditor"] = eng_input,
}

-- 自动获取当前程序 询问用户 设置什么样的输入法
-- 增加到 App2ImeTable 中
local objChooser = {}

-- Create a canvas and draw an emoji on it
local function createEmojiImage(emoji, size)
	local canvas = hs.canvas.new({ x = 0, y = 0, w = size, h = size })

	-- Draw the emoji in the center of the canvas
	canvas[1] = {
		type = "text",
		text = emoji,
		textSize = size * 0.8,
		textAlignment = "center",
		frame = { x = "0%", y = "0%", w = "100%", h = "100%" },
	}

	-- Convert the canvas to an image
	local image = canvas:imageFromCanvas()
	canvas:delete()

	return image
end

-- 定义split函数
local function split(inputstr, sep)
	local result = {} -- 创建一个空表来存储分割后的字符串
	if inputstr == "" or sep == "" then
		table.insert(result, inputstr) -- 如果输入为空或分隔符为空，直接返回原字符串作为唯一元素。
		return result
	end

	-- 使用 Lua 的 string API 来高效地处理字符串
	local from = 1
	local sep_length = #sep
	while true do
		local pos = string.find(inputstr, sep, from) -- 查找分隔符的位置
		if not pos then
			table.insert(result, string.sub(inputstr, from)) -- 如果没有找到分隔符，添加剩余部分到结果表中
			break
		end
		table.insert(result, string.sub(inputstr, from, pos - 1)) -- 添加分割后的子字符串到结果表中
		from = pos + sep_length -- 更新下一个搜索的位置
	end

	return result
end

-- 使用示例

local function completionFn(chosen)
	print("start.completionFn")
	-- 获取当前时间的时间戳
	-- local now = os.time()
	-- print("现在为: ", now)
	-- hs.timer.usleep(20000000)
	-- now = os.time()

	if chosen ~= nil then
		local strList = chosen["uuid"]
		-- print(strList)
		local fruits = split(strList, "|")
		local targetIme = ""
		local currenApp = ""
		for i, v in ipairs(fruits) do
			if i == 1 then
				targetIme = v
			elseif i == 2 then
				currenApp = v
			end
		end
		print(currenApp)
		-- hs.timer.usleep(20000000)
		-- local future_time = os.time()
		-- print("更新为: ", now)
		-- print("future_time: ", future_time)
		-- print("切割，两者的秒数差距：", os.difftime(future_time, now))
		local engtext = "英文Abc"
		local chtext = "中文简体拼音"
		local sqtext = "鼠须管输入法"
		local tmpText = ""
		local orgIme = App2ImeTable[currenApp]
		-- future_time = os.time()
		-- print("App2ImeTable获取，两者的秒数差距：", os.difftime(future_time, now))
		if orgIme == nil then
			App2ImeTable[currenApp] = targetIme
			if targetIme == eng_input then
				tmpText = engtext
				English()
			elseif targetIme == ch_input then
				tmpText = chtext
				Chinese()
			else
				tmpText = sqtext
				Squirrel()
			end
			-- future_time = os.time()
			-- print("App2ImeTable设置完成，两者的秒数差距：", os.difftime(future_time, now))
			alert.show("程序设置: 「" .. currenApp .. "」,完成「" .. tmpText .. "」")
		else
			if orgIme == eng_input then
				tmpText = engtext
			elseif orgIme == ch_input then
				tmpText = chtext
			else
				tmpText = sqtext
			end
			alert.show("程序设置:重复设置")
			-- alert.show("程序设置:默认输入法「"..tmpText.."」")
			alert.show("程序设置: 「" .. currenApp .. "」,默认输入法「" .. tmpText .. "」")
		end
	end
	-- local future_time = os.time()
	-- local time_difference_in_seconds = os.difftime(future_time, now)
	-- print("总，两者的秒数差距：", time_difference_in_seconds)
end

function ChoicesFn()
	-- ▪️中国🇨🇳🇺🇸
	local emojiList = { "🇺🇸", "🇨🇳", "🇨🇳" }
	local choiceList = { "英文Abc", "中文简体拼音", "鼠须管输入法" }
	local subTextList = {
		"设置当前焦点程序默认输入法到【英文Abc模式】",
		"设置当前焦点程序默认输入法到【中文简体拼音】",
		"设置当前焦点程序默认输入法到【鼠须管输入法】",
	}
	local inputList = { eng_input, ch_input, squirrel_input }
	local choices = {}
	for i, emoji in ipairs(emojiList) do
		local emojiImage = createEmojiImage(emoji, 64) -- create a 64x64 image
		table.insert(choices, {
			text = choiceList[i],
			subText = subTextList[i],
			image = emojiImage,
			uuid = inputList[i],
		})
	end
	local currentApp = currentAppBundleID()
	if currentApp == nil then
		return
	end
	print(currentApp)
	local currenTime = k.currentSourceID()
	for _, v in pairs(choices) do
		v["uuid"] = v["uuid"] .. "|" .. currentApp .. "|" .. currenTime
	end
	objChooser.chooser:choices(choices)
	objChooser.chooser:show()
end

function objChooser:init()
	objChooser.chooser = hs.chooser.new(completionFn)
end

objChooser.init()

-- 记录App输入法状态
local function imeStash(currentApp)
	if currentApp == nil then
		return nil
	end
	local currenTime = k.currentSourceID()
	if App2ImeTable[currentApp] == nil then
		App2ImeTable[currentApp] = currenTime
	end
	return App2ImeTable, currenTime
end

local delayTimer = nil
local function windowsHandler()
	if delayTimer ~= nil then
		delayTimer:stop()
		delayTimer = nil
	end
	delayTimer = hs.timer.doAfter(0.5, updateFocusAppInputMethod)
end

-- 自动切换输入法
function updateFocusAppInputMethod()
	local bundleID = currentAppBundleID()
	if bundleID == nil then
		return
	end
	if bundleID == "com.runningwithcrayons.Alfred" then
		-- print("特殊程序跳过")
		return
	end
	local app2ImeTable, currenTime = imeStash(bundleID)
	if app2ImeTable == nil then
		return
	end
	local extractedValue = app2ImeTable[bundleID] or "default value"
	-- print(currentime)
	-- print(extractedValue)
	hs.keycodes.currentMethod()
	print(hs.keycodes.currentMethod())
	if extractedValue == currenTime then
		print("设置内容一样")
		showImeName(extractedValue)
		return
	end
	if extractedValue == eng_input then
		-- delayTimer = hs.timer.doAfter(0.2, English)
		-- k.currentSourceID(eng)
		English()
	elseif extractedValue == ch_input then
		Chinese()
	elseif extractedValue == squirrel_input then
		-- delayTimer = hs.timer.doAfter(0.2, Chinese)
		-- k.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
		-- Chinese()
		Squirrel()
	else
		print("没有添加名单的程序使用中文输入法,当前输入法是" .. extractedValue .. "程序：" .. bundleID)
		-- delayTimer = hs.timer.doAfter(0.2, Chinese)
		showImeName(currenTime)
		return
	end
	print("切换为" .. extractedValue .. "程序：" .. bundleID)
end

-- 监视App启动或终止并切换输入法成对应方式
local function applicationWatcher(appName, eventType, appObject)
	if eventType == hs.application.watcher.activated then
		windowsHandler()
	end
end

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
