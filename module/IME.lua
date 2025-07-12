hyper_oc = {"ctrl+cmd+alt+shift"}
local alert = require("hs.alert")
local k = require("hs.keycodes")
local ch_input = "com.apple.inputmethod.SCIM.ITABC"
-- im.rime.inputmethod.Squirrel.Hans
local shuxuguan_input = "im.rime.inputmethod.Squirrel.Hans"
local jp_input = "com.apple.inputmethod.Kotoeri.Roman"
local eng_input = "com.apple.keylayout.ABC"

-- 判断英文输入法的种类
local roma = false
for key, value in pairs(k.methods()) do if value == "Romaji" then roma = true end end
if roma == true then
    eng = jp_input
    inputs = {"拼音 - 簡体字", "英字", "ひらがな"}
else
    eng = eng_input
    inputs = {"简体拼音", "ABC", "平假名"}
end
local script =
    [[tell application "System Events" to tell process "TextInputMenuAgent" to tell (1st menu bar item of menu bar 2) to {click (menu item "tomethod" of menu 1), click}]]
-- 切换为拼音
function Chinese()
    -- hs.osascript.applescript(script:gsub("tomethod",inputs[1]))
    -- k.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
    k.setMethod("Pinyin - Simplified")
end
-- 切换为日文
-- local function Japanese()
-- hs.osascript.applescript(script:gsub("tomethod",inputs[3]))
-- k.currentSourceID("com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese")
--	k.setMethod("Hiragana")
-- end
-- 切换为英文
function English()
    -- hs.osascript.applescript(script:gsub("tomethod",inputs[2]))
    if roma == true then
        k.setMethod("Romaji")
    else
        k.currentSourceID(eng)
    end
end
-- Squirrel - Simplified
-- 切换为英文
function Squirrel() k.setMethod("Squirrel - Simplified") end

-- 设置App对应的输入法
local App2ImeTable = {
    ["com.apple.finder"] = ch_input,
    ["com.apple.Photos"] = ch_input,
    ["com.apple.MobileSMS"] = ch_input,
    ["com.apple.Spotlight"] = eng_input,
    ["com.apple.dt.Xcode"] = eng_input,
    ["org.hammerspoon.Hammerspoon"] = ch_input,
    ["com.apple.systempreferences"] = ch_input,
    ["com.apple.Safari"] = ch_input,
    ["com.apple.Notes"] = ch_input,
    ["com.apple.Terminal"] = eng_input,
    ["com.jetbrains.goland"] = eng_input,
    ["com.googlecode.iterm2"] = eng_input,
    ["com.apple.Music"] = ch_input,
    ["com.tencent.xinWeChat"] = ch_input,
    ["com.microsoft.Word"] = ch_input,
    ["com.microsoft.Excel"] = ch_input,
    ["com.kingsoft.wpsoffice.mac"] = ch_input,
    ["com.jetbrains.pycharm"] = eng_input
}
local App2Ime = {
    {"com.apple.finder", "com.apple.keylayout.ABC"},
    {"com.apple.Photos", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.apple.MobileSMS", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.apple.Spotlight", "com.apple.keylayout.ABC"},
    {"org.hammerspoon.Hammerspoon", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.apple.systempreferences", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.apple.Safari", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.apple.Notes", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.apple.Terminal", "com.apple.keylayout.ABC"},
    {"com.jetbrains.goland", "com.apple.keylayout.ABC"},
    {"com.googlecode.iterm2", "com.apple.keylayout.ABC"},
    {"com.apple.Music", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.tencent.xinWeChat", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.microsoft.Word", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.microsoft.Excel", "com.apple.inputmethod.SCIM.ITABC"},
    {"com.kingsoft.wpsoffice.mac", "com.apple.inputmethod.SCIM.ITABC"}
}

-- 自动获取当前程序 询问用户 设置什么样的输入法
-- 增加到 App2ImeTable 中
local objChooser = {}

-- Create a canvas and draw an emoji on it
local function createEmojiImage(emoji, size)
    local canvas = hs.canvas.new({x = 0, y = 0, w = size, h = size})

    -- Draw the emoji in the center of the canvas
    canvas[1] = {
        type = "text",
        text = emoji,
        textSize = size * 0.8,
        textAlignment = "center",
        frame = {x = "0%", y = "0%", w = "100%", h = "100%"}
    }

    -- Convert the canvas to an image
    local image = canvas:imageFromCanvas()
    canvas:delete()

    return image
end

-- 定义split函数
function split(inputstr, sep)
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
        targetIme = ""
        currenApp = ""
        currenIme = ""
        chosen["uuid"] = target
        for i, v in ipairs(fruits) do
            if i == 1 then
                targetIme = v
            elseif i == 2 then
                currenApp = v
            else
                currenIme = v
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
        local tmpText = ""
        local orgIme = App2ImeTable[currenApp]
        -- future_time = os.time()
        -- print("App2ImeTable获取，两者的秒数差距：", os.difftime(future_time, now))
        if orgIme == nil then
            App2ImeTable[currenApp] = targetIme
            if targetIme == eng_input then
                tmpText = engtext
                English()
            else
                tmpText = chtext
                Squirrel()
            end
            -- future_time = os.time()
            -- print("App2ImeTable设置完成，两者的秒数差距：", os.difftime(future_time, now))
            alert.show("程序设置: 「" .. currenApp .. "」,完成「" ..
                           tmpText .. "」")
        else
            if orgIme == eng_input then
                tmpText = engtext
            else
                tmpText = chtext
            end
            alert.show("程序设置:重复设置")
            -- alert.show("程序设置:默认输入法「"..tmpText.."」")
            alert.show("程序设置: 「" .. currenApp ..
                           "」,默认输入法「" .. tmpText .. "」")
        end
    end
    -- local future_time = os.time()
    -- local time_difference_in_seconds = os.difftime(future_time, now)
    -- print("总，两者的秒数差距：", time_difference_in_seconds)
end

function ChoicesFn()
    -- ▪️中国🇨🇳🇺🇸
    local emojiList = {"🇺🇸", "🇨🇳", "🇨🇳"}
    local choiceList = {"英文Abc", "中文简体拼音", "鼠须管输入法"}
    local subTextList = {
        "设置当前焦点程序默认输入法到【英文Abc模式】",
        "设置当前焦点程序默认输入法到【中文简体拼音】",
        "设置当前焦点程序默认输入法到【鼠须管输入法】"
    }
    local inputList = {eng_input, ch_input, shuxuguan_input}
    local choices = {}
    for i, emoji in ipairs(emojiList) do
        local emojiImage = createEmojiImage(emoji, 64) -- create a 64x64 image
        table.insert(choices, {
            text = choiceList[i],
            subText = subTextList[i],
            image = emojiImage,
            uuid = inputList[i]
        })
    end
    if hs.window.frontmostWindow() ~= nil then
        if hs.window.frontmostWindow():application() ~= nil then
            currentapp = hs.window.frontmostWindow():application():bundleID()
            if currentapp == nil then return end
        else
            return
        end
    else
        return
    end
    print(currentapp)
    local currentime = k.currentSourceID()
    for index, v in pairs(choices) do
        v["uuid"] = v["uuid"] .. "|" .. currentapp .. "|" .. currentime
    end
    objChooser.chooser:choices(choices)
    objChooser.chooser:show()
end

function objChooser:init() objChooser.chooser = hs.chooser.new(completionFn) end

objChooser.init()

-- 记录App输入法状态
function imeStash()
    -- local imehistory = {}
    if hs.window.frontmostWindow() ~= nil then
        if hs.window.frontmostWindow():application() ~= nil then
            currentapp = hs.window.frontmostWindow():application():bundleID()
            -- currentapp = hs.window.frontmostWindow():application():bundleID()
            if currentapp == nil then return end
        end
    end
    local currentime = k.currentSourceID()
    -- if #imehistory > 50 then
    --	table.remove(App2ImeTable)
    -- end
    -- print(imehistory)
    local imetable = {currentapp, currentime}
    if App2ImeTable[currentapp] == nil then
        table.insert(App2ImeTable, imetable)
    end
    return App2ImeTable, currentime
end

function windowsHander()
    delayTimer = hs.timer.doAfter(0.5, updateFocusAppInputMethod)
end

-- 自动切换输入法
function updateFocusAppInputMethod()
    if hs.window.frontmostWindow() ~= nil then
        if hs.window.frontmostWindow():application() ~= nil then
            -- focusAppPath = hs.window.frontmostWindow():application():path()
            app = hs.window.frontmostWindow():application()
            -- print(app)
            bundleID = app:bundleID()
            -- print(focusAppPath)
            -- print(bundleID)
        end
    end
    if bundleID == "com.runningwithcrayons.Alfred" then
        -- print("特殊程序跳过")
        return
    end
    local app2ImeTable, currentime = imeStash()
    local extractedValue = app2ImeTable[bundleID] or "default value"
    -- print(currentime)
    -- print(extractedValue)
    hs.keycodes.currentMethod()
    print(hs.keycodes.currentMethod())
    if extractedValue == currentime then
        -- print("一样")
        return
    end
    if extractedValue == eng_input then
        -- delayTimer = hs.timer.doAfter(0.2, English)
        -- k.currentSourceID(eng)
        English()
    elseif extractedValue == ch_input or extractedValue == shuxuguan_input then
        -- delayTimer = hs.timer.doAfter(0.2, Chinese)
        -- k.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
        -- Chinese()
        Squirrel()
    else
        print(
            "没有添加名单的程序使用中文输入法,当前输入法是" ..
                extractedValue)
        -- delayTimer = hs.timer.doAfter(0.2, Chinese)
        -- Chinese()
    end
end

-- 监视App启动或终止并切换输入法成对应方式
function applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then windowsHander() end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
