timer = os.time()
starB = false
oldMagplantX = magplantX 
oldMagplantY = magplantY 
magplantCount = 1 
cheatFarm = true 
setCurrent = true 
buyLock = false 
autoDLock = false 
changeRemote = false 
player = GetLocal().name 
playerUserID = GetLocal().userid
currentGem = GetPlayerInfo().gems 
currentWorld = GetWorld().name 
jumlahbgems = 0

ChangeValue("[C] Modfly", true)

AddHook("onvariant", "mommy", function(var)
    if var[0] == "OnSDBroadcast" then 
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("add_player_info") then
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("Telephone") then
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("Blue Gem Lock") then
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("The BGL Bank") then
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("Diamond Lock") then
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("MAGPLANT 5000") then
        if var[1]:find("The machine is currently empty!") then
            changeRemote = true
            buyNow = false
        end
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("`bThe Black Backpack") then
        jumlahbgems = var[1]:match("You have (%d+)")
        return true
    end
    if var[0] == "OnConsoleMessage" then
        if var[1]:find("`oYour luck has worn off.") then
           autoClover = true
           autoSongpyeon = true
        elseif var[1]:find("`oYour stomach's rumbling.") then
           autoArroz = true
        end
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Disconnected?! Will attempt to reconnect...") then
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Where would you like to go?") then
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Applying cheats...") then
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Cheat Active") then
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Whoa, calm down toggling cheats on/off... Try again in a second!") then
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("You earned `$(%d+)`` in Tax Credits! You have `$(%d+) Tax Credits`` in total now.") then
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Xenonite") then
        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:match("`1O`2h`3, `4l`5o`6o`7k `8w`9h`ba`!t `$y`3o`2u`4'`ev`pe `#f`6o`8u`1n`7d`w!")  then
        return true
    end
    if var[0] == "OnTalkBubble" and var[2]:match("Xenonite") then
            return true
    end
    if var[0] == "OnTalkBubble" and var[2]:match("`1O`2h`3, `4l`5o`6o`7k `8w`9h`ba`!t `$y`3o`2u`4'`ev`pe `#f`6o`8u`1n`7d`w!") then
        return true
    end
    if var[0] == "OnTalkBubble" and var[2]:match("Collected") then
        if removeCollected then
            return true
        end
    end
    if var[0] == "OnTalkBubble" and var[2]:find("The MAGPLANT 5000 is empty.") then
        changeRemote = true
        buyNow = false
        return true
    end
    return false
end)

worldName = ""

if not cheatFarm and removeAnimation then
    removeAnimation = false
end

if worldName == "" or worldName == nil then
    worldName = string.upper(GetWorld().name)
end

AddHook("onprocesstankupdatepacket", "pussy", function(packet)
    if packet.type == 3 or packet.type == 8 or packet.type == 17 then
        if removeAnimation then
            return true
        end
    end
end)

local function FormatNumber(num)
    num = math.floor(num + 0.5)

    local formatted = tostring(num)
    local k = 3
    while k < #formatted do
        formatted = formatted:sub(1, #formatted - k) .. "," .. formatted:sub(#formatted - k + 1)
        k = k + 4
    end

    return formatted
end

local function findItem(id)
    count = 0
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            count = count + inv.amount
        end
    end
    return count
end

local function removeColorAndSymbols(str)
    cleanedStr = string.gsub(str, "`(%S)", '')
    cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
    return cleanedStr
end

if GetWorld() == nil then
    username = removeColorAndSymbols(player)
else
    username = removeColorAndSymbols(GetLocal().name)
end

if GetWorld() == nil then
    playerUID = removeColorAndSymbols(playerUserID)
else
    playerUID = removeColorAndSymbols(GetLocal().userid)
end

time = os.time()
local function playerHook(info)  
    if whUse then
        oras = os.time() - time
        local script = [[
            $webHookUrl = "]].. whUrl ..[["
            $title = "<a:alert:1194823985628725428> **PNB Information** <a:alert:1194823985628725428>"
            $date = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), 'Singapore Standard Time').ToString('g')
            $cpu = (Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average).Average
            $RAM = Get-WMIObject Win32_PhysicalMemory | Measure -Property capacity -Sum | %{$_.sum/1Mb} 
            $ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
            $thumbnailObject = @{
                url = "https://cdn.discordapp.com/attachments/1193141414972899370/1198656133204811776/rs.png?ex=65c8ed04&is=65b67804&hm=26f0be87205a0f4a1af71df64258b463996e2dc38e2c4ec199d52c92df2261c9&"
            }
            $footerObject = @{
                text = "Date: ]]..(os.date("!%A %b %d, %Y | Time: %I:%M %p ", os.time() + 8 * 60 * 60))..[[ | @4rab."
            }
            
            $fieldArray = @(

            @{
                name = "<:mgp:1194831769858494464> Information"
                value = "World : **]].. currentWorld ..[[**
                Status : **]].. info ..[[**"
                inline = "false"
            }

            @{
                name = "<:bot:1201730667281666078> Player Information"
                value = "Username : **]].. username ..[[**
                User ID : **]].. playerUID ..[[**"
                inline = "false"
            }

            @{
                name = "<:gems:1194831751193825281> Gems Information"
                value = "Current Gems <:rgems:1225699132711243817>: **]].. FormatNumber(GetPlayerInfo().gems) ..[[**
                Earned Gems <:rgems:1225699132711243817>: **]].. FormatNumber(GetPlayerInfo().gems - currentGem) ..[[**"
                inline = "false"
            }

            @{
                name = "<a:flash:1197511764603052102> Buff Information"
                value = "<:four_leaf_clover:1178876649090076774> Clover Stock: **]].. math.floor(findItem(528)) ..[[**
                <:taco:1178877190507614248> Arroz Stock: **]].. math.floor(findItem(4604)) ..[[**"
                inline = "false"
            }
  
            @{
                name = "<:mp:1194831735666511912> Magplant Position"
                value = "Current Remote: (**]].. magplantX ..[[**, **]].. magplantY ..[[**)"
                inline = "false"
            }

            @{
                name = "<a:rg:1197369816403685396> PNB Up Time"
                value = "]].. math.floor(oras/86400) ..[[ Days ]].. math.floor(oras%86400/3600) ..[[ Hours ]].. math.floor(oras%86400%3600/60) ..[[ Minutes ]].. math.floor(oras%3600%60) ..[[ Seconds"
                inline = "false"
            }

          $Body = @{
          'content' = '<@]].. discordID ..[[>'
          }
      
          )
          $embedObject = @{
          title = $title
          description = $desc
          footer = $footerObject
          thumbnail = $thumbnailObject
          color = "]] ..math.random(1000000, 9999999).. [["
      
          fields = $fieldArray
      }
      $embedArray = @($embedObject)
      $payload = @{
      avatar_url = "https://cdn.discordapp.com/attachments/1193141414972899370/1198656133204811776/rs.png?ex=65c8ed04&is=65b67804&hm=26f0be87205a0f4a1af71df64258b463996e2dc38e2c4ec199d52c92df2261c9&"
      username = "PNB by Rab Store"
      content = "<a:verify1:1194823074810445935> <@]].. discordID ..[[>"
      embeds = $embedArray
      }
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
      ]]
      local pipe = io.popen("powershell -command -", "w")
      pipe:write(script)
      pipe:close()
    end
end

playerHook("**Script is now running!**")

local function overlayText(text)
    var = {}
    var[0] = "OnTextOverlay"
    var[1] = text
    SendVariantList(var)
end

local function logText(text)
    packet = {}
    packet[0] = "OnConsoleMessage"
    packet[1] = "`b[`#@4Rab`b]`6 ".. text
    SendVariantList(packet)
end

local function warnText(text)
    text = text
    packet = {}
    packet[0] = "OnAddNotification"
    packet[1] = "interface/atomic_button.rttex"
    packet[2] = text
    packet[3] = "audio/hub_open.wav"
    packet[4] = 0
    SendVariantList(packet)
    return true
end

SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4rab.`6]")
logText("Script is now running!")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4rab.`6]")
logText("Turn on API List IO,OS, Make Request.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4rab.`6]")
logText("PNB Script by Rab Store.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4rab.`6]")
logText("Checking User ID.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)

local function place(id, x, y)
    pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

local function punch(x, y)
    pkt = {}
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y 
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    SendPacketRaw(false, pkt)
end

function convert(id)
    pkt = {}
    pkt.value = id
    pkt.type = 10
    SendPacketRaw(false, pkt)
end

function split(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^".. sep .."]+)") do
        table.insert(t, str)
    end
    return t
end

local function wrench(x, y)
    pkt = {}
    pkt.type = 3
    pkt.value = 32
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

local function getRemote()
    if findItem(5640) == 0 or changeRemote then
        FindPath(magplantX, magplantY - 1, 100)
        Sleep(100)
        wrench(0, 1)
        Sleep(100)
        SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. magplantX .."|\ny|".. magplantY .."|\nbuttonClicked|getRemote")
        if findItem(5640) >= 1 then
            Sleep(100)
        end
    end
    nowBuy = true
    changeRemote = false
end

local function remoteCheck()
    if GetWorld() == nil then
        -- test
        Sleep(delayErcon)
        RequestJoinWorld(worldName)
        overlayText("[Rab Store] `^Request to join world `2".. worldName.."")
        Sleep(1000)
        playerHook("Reconnected, looks like you were recently disconnected")
    else
        if findItem(5640) < 0 or findItem(5640) == 0 then
            Sleep(1000)
            getRemote()
        end
    end
end

local function reconnectPlayer()
    if GetWorld() == nil then
        -- test
        Sleep(delayErcon)
        RequestJoinWorld(worldName)
        overlayText("[Rab Store] `^Request to join world `2".. worldName.."")
        Sleep(1000)
        playerHook("Reconnected, looks like you were recently disconnected")
    else
        Sleep(1000)
        remoteCheck()
        if findItem(5640) >= 1 or findItem(5640) == 1 then
            Sleep(1000)
            if GetLocal().pos.x ~= positionX and GetLocal().pos.y ~= positionY then
                Sleep(100)
                FindPath(positionX, positionY, 100)
                Sleep(100)
            end
        end
    end
end

local function getPos()
    if setCurrent then
        positionX = math.floor(GetLocal().pos.x / 32)
        positionY = math.floor(GetLocal().pos.y / 32)
        currentGem = GetPlayerInfo().gems
        if setCurrent then
            setCurrent = false
        end
    end
end

load(MakeRequest("https://raw.githubusercontent.com/agsprdn2430/UID-Buyer/main/UID%20PNB.lua","GET").content)()

function isUserIdAllowed(userid)
    for _, allowedId in ipairs(allowedUserIds) do
        if userid == allowedId then
            return true
        end
    end
    return false
end

userId = tostring(GetLocal().userid)
if isUserIdAllowed(userId) then
    logText("`2Access granted, User ID is registered.")
    while true do
        if GetWorld() == nil then
            -- test
            Sleep(1000)
            reconnectPlayer(worldName)
        end

        getPos()
    
        if changeRemote then
            for i = 1, 1 do
                if magplantX and magplantY and GetTile(magplantX + 1, magplantY).fg == 5638 then
                    magplantX = magplantX + 1
                    magplantCount = magplantCount + 1
                    warnText("`wMagplant `2#".. magplantCount - 1 .." `wis empty. Switching to Magplant `2#".. magplantCount)
                    playerHook("Magplant #".. magplantCount - 1 .." is empty. Switching to Magplant #".. magplantCount)
                else
                    warnText("`wMagplant `2#".. magplantCount .." `wis empty. Switching to Magplant `2#1")
                    playerHook("Magplant #".. magplantCount .." is empty. Switching to Magplant #1")
                    magplantCount = 1
                    magplantX = oldMagplantX
                end
                SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_lonely".. peopleHide .."\ncheck_gems|".. collectGem .."\ncheck_ignoref|".. ignorePeople)
                Sleep(1000)
            end
            getRemote()
            Sleep(1000)
        end
    
        getRemote()
        Sleep(1000)
        FindPath(positionX, positionY, 100)
        Sleep(1000)

        if cheatFarm then
            nowFarm = true
            playerHook("Farming")
            while nowFarm do
                if autoClover then
                    Sleep(1000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0")
                    Sleep(1000)
                    FindPath(positionX, positionY)
                    Sleep(1000)
                    place(528, 0, 0)
                    overlayText("`2Eating Lucky Clover, `9More Lucky!")
                    Sleep(1000)
                    autoClover = false
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_lonely|".. peopleHide .."\ncheck_gems|".. collectGem .."\ncheck_ignoref|".. ignorePeople)
                    Sleep(1000)
                end

                if autoArroz then
                    Sleep(1000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0")
                    Sleep(1000)
                    FindPath(positionX, positionY)
                    Sleep(1000)
                    place(4604, 0, 0)
                    overlayText("`2Eating Arroz Con Pollo, `9More Gems!")
                    Sleep(1000)
                    autoArroz = false
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_lonely|".. peopleHide .."\ncheck_gems|".. collectGem .."\ncheck_ignoref|".. ignorePeople)
                    Sleep(1000)
                end

                if autoSongpyeon then
                    Sleep(1000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0")
                    Sleep(1000)
                    FindPath(positionX, positionY)
                    Sleep(1000)
                    place(1056, 0, 0)
                    overlayText("`2Eating Songpyeon, `9More Lucky!")
                    Sleep(1000)
                    autoSongpyeon = false
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_lonely|".. peopleHide .."\ncheck_gems|".. collectGem .."\ncheck_ignoref|".. ignorePeople)
                    Sleep(1000)
                end

                for i = 1, 1 do
                    Sleep(4000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_lonely|".. peopleHide .."\ncheck_gems|".. collectGem .."\ncheck_ignoref|".. ignorePeople)
                end
    
                if GetWorld() == nil then
                    -- test
                    Sleep(1000)
                    reconnectPlayer()
                    Sleep(1000)
                    break
                end

                if nowBuy then  
                    if autoInvasion then
                        if GetPlayerInfo().gems >= 10000 then
                            buyLock = true
                            if buyLock then
                                SendPacket(2, "action|buy\nitem|buy_worldlockpack")
                                Sleep(100)
    
                                if GetWorld() == nil then
                                    -- test
                                    Sleep(1000)
                                    reconnectPlayer()
                                    Sleep(1000)
                                    break
                                end
                            end
                        end
        
                        if GetPlayerInfo().gems < 10000 then
                            buyLock = false
                            Sleep(100)
                        end
                
                        if findItem(242) >= 100 then
                            convert(242)
                            Sleep(100)
                        elseif findItem(1796) >= 100 then
                            Sleep(100)
                            SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|".. GetLocal().pos.x / 32 .."|\ny|".. GetLocal().pos.y / 32 .."|\nbuttonClicked|bglconvert")
                        end
    
                        if autoBank then
                            if findItem(7188) >= 1 then
                                SendPacket(2, "action|dialog_return\ndialog_name|bank_deposit\nbgl_count|".. findItem(7188))
                                Sleep(100)
                            end
                        end
                
                        if not autoBank then
                            if findItem(7188) >= 100 then
                                SendPacket(2, "action|dialog_return\ndialog_name|info_box\nbuttonClicked|make_bgl")
                                Sleep(100)
                            end
                        end
                    end
    
                    if autoTelephoneDL then
                        if GetPlayerInfo().gems >= 110000 then
                            autoDLock = true
                            if autoDLock then
                                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|".. GetLocal().pos.x / 32 .."|\ny|".. GetLocal().pos.y / 32 .."|\nbuttonClicked|dlconvert")
                                Sleep(100)
    
                                if GetWorld() == nil then
                                    -- test
                                    Sleep(1000)
                                    reconnectPlayer()
                                    Sleep(1000)
                                    break
                                end
                            end
                        end
        
                        if GetPlayerInfo().gems < 110000 then
                            autoDLock = false
                            Sleep(100)
                        end
                
                        if findItem(1796) >= 100 then
                            Sleep(100)
                            SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|".. GetLocal().pos.x / 32 .."|\ny|".. GetLocal().pos.y / 32 .."|\nbuttonClicked|bglconvert")
                            Sleep(100)
                        end
        
                        if autoBank then
                            if findItem(7188) >= 1 then
                                SendPacket(2, "action|dialog_return\ndialog_name|bank_deposit\nbgl_count|".. findItem(7188))
                                Sleep(100)
                            end
                        end
                
                        if not autoBank then
                            if findItem(7188) >= 100 then
                                SendPacket(2, "action|dialog_return\ndialog_name|info_box\nbuttonClicked|make_bgl")
                                Sleep(100)
                            end
                        end
                    end
                    if changeRemote then
                        nowBuy = false
                        Sleep(1000)
                        break
                    end
                end
    
                if GetWorld() == nil then
                    -- test
                    Sleep(1000)
                    reconnectPlayer()
                    Sleep(1000)
                    break
                end
    
                if changeRemote then
                    nowFarm = false
                    break
                end

                if os.time() - timer >= whDelay then
                    starB = true
                    if suckMode then
                        SendPacket(2, "action|wrench\n|netid|"..GetLocal().netid)
                        Sleep(200)
                        SendPacket(2, "action|dialog_return\ndialog_name|popup\nbuttonClicked|bgems")
                        Sleep(200)
                        SendPacket(2, "action|dialog_return\ndialog_name|popup\nbuttonClicked|bgem_suckall")
                        playerHook("Taking Dropped Black Gems every ".. whDelay .." Seconds!")
                        Sleep(200)
                    elseif not suckMode then
                        playerHook("Webhook PING! every ".. whDelay .." Seconds!")
                        Sleep(200)
                    end
                    timer = os.time()
                    Sleep(1000)
                    starB = false
                end
            end
        end
    end
else
    logText("`4Acces denied, User ID not registered.")
end
