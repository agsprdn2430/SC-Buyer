worldName = "" 
nowEnable = true 
isEnable = false 
ghostState = false 
wreckWrench = true 
changeRemote = false 
magplantX = magplantX - 1 
currentTime = os.time() 
player = GetLocal().name 
playerUserID = GetLocal().userid
previousGem = GetPlayerInfo().gems 
currentWorld = GetWorld().name

AddHook("onvariant", "mommy", function(var)
    if var[0] == "OnSDBroadcast" then 
        overlayText("`w[Rab Store] `4[Blocked SDB]")
        return true
    end
end)

if worldName == "" or worldName == nil then
    worldName = string.upper(GetWorld().name)
end

if GetWorld().name ~= string.upper(worldName) then
    for i = 1, 1 do
        Sleep(4500)
        RequestJoinWorld(worldName)
        Sleep(delayRecon)
    end
end

AddHook("onvariant", "mommy", function(var)
    if var[0] == "OnSDBroadcast" then 
        return true
    end

    if var[0] == "OnDialogRequest" and var[1]:find("MAGPLANT 5000") then
        return true
    end

    if var[0] == "OnTalkBubble" and var[2]:match("The MAGPLANT 5000 is empty.") then
        changeRemote = true
        return true
    end

    if var[0] == "OnTalkBubble" and var[2]:match("Collected") then
        return true
    end

    if var[0] == "OnDialogRequest" and var[1]:find("add_player_info") then
        if var[1]:find("|528|") then
            consumeClover = true
        else
            consumeClover = false
        end

        if var[1]:find("|4604|") then
            consumeArroz = true
        else
            consumeArroz = false
        end

        if var[1]:find("|290|") then
            ghostState = true
        else
            ghostState = false
        end

        return true
    end
    return false
end)

local function place(id, x, y)
    if GetWorld() == nil then
        return
    end

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
    if GetWorld() == nil then
        return
    end

    pkt = {}
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y 
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    SendPacketRaw(false, pkt)
end

local function wrench(x, y)
    if GetWorld() == nil then
        return
    end
    
    pkt = {}
    pkt.type = 3
    pkt.value = 32
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

local function isReady(tile)
    if GetWorld() == nil then
        return 
    end

    if tile and tile.extra and tile.extra.progress and tile.extra.progress == 1.0 then
        return true
    end
    return false
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

local function playerHook(info)
    if whUse then
        oras = os.time() - currentTime
        local script = [[
            $webHookUrl = "]].. whUrl ..[["
            $title = "<a:alert:1194823985628725428> **PTHT Information** <a:alert:1194823985628725428>"
            $date = [System.currentTimeZoneInfo]::ConvertcurrentTimeBySystemcurrentTimeZoneId((Get-Date), 'Singapore Standard currentTime').ToString('g')
            $cpu = (Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average).Average
            $RAM = Get-WMIObject Win32_PhysicalMemory | Measure -Property capacity -Sum | %{$_.sum/1Mb} 
            $ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | Select-Object -ExpandProperty IPAddress
            $thumbnailObject = @{
                url = "https://cdn.discordapp.com/attachments/1193141414972899370/1198656133204811776/rs.png?ex=65c8ed04&is=65b67804&hm=26f0be87205a0f4a1af71df64258b463996e2dc38e2c4ec199d52c92df2261c9&"
            }
            $footerObject = @{
                text = "Date: ]]..(os.date("!%A %b %d, %Y | Time: %I:%M %p ", os.time() + 8 * 60 * 60))..[[ | @4_rab"
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
                name = "<:gems:1194831751193825281> Total Gems"
                value = "Current Gems: ]].. FormatNumber(GetPlayerInfo().gems) ..[["
                inline = "false"
            }

            @{
                name = "<:uws:1194831699859746867> Ultra World Spray Stock"
                value = "Spray Stock: ]].. math.floor(findItem(12600)) ..[["
                inline = "false"
            }
  
            @{
                name = "<:mp:1194831735666511912> Magplant Position"
                value = "Current Remote: (**]].. magplantX ..[[**, **]].. magplantY ..[[**)"
                inline = "false"
            }
  
            @{
                name = "<:stopwatch:1167910206647304334> PTHT Up Time"
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
          color = "]] ..math.random(1000000,9999999).. [["
      
          fields = $fieldArray
      }
      $embedArray = @($embedObject)
      $payload = @{
      avatar_url = "https://cdn.discordapp.com/attachments/1193141414972899370/1198656133204811776/rs.png?ex=65c8ed04&is=65b67804&hm=26f0be87205a0f4a1af71df64258b463996e2dc38e2c4ec199d52c92df2261c9&"
      username = "PTHT by Rab Store"
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

SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
logText("Script is now running!")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
logText("Turn on API List IO,OS, Make Request.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
logText("PTHT Script by Rab Store.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
logText("Checking User ID.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)

SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_gems|1\n")
Sleep(100)

local function hold()
    if GetWorld() == nil then
        return
    end
    
	local pkt = {}
	pkt.type = 0
	pkt.state = 16779296
	SendPacketRaw(pkt)
	Sleep(90)
end

local function countReady()
    readyTree = 0
    for _, tile in pairs(GetTiles()) do
        if tile.fg == itemID then
            if isReady(GetTile(tile.x, tile.y)) then
                readyTree = readyTree + 1
            end
        end
    end
    return readyTree
end

local function countTree()
    if GetWorld() == nil then
        return
    end

    countTrees = 0
    for _, tile in pairs(GetTiles()) do
        if GetTile(tile.x, tile.y).fg == itemID and not isReady(GetTile(tile.x, tile.y)) then
            countTrees = countTrees + 1
        end
    end
    return countTrees
end

local function cheatSetup()
    if GetWorld() == nil then
        return
    end
    
    if countTree() >= 1 then
        for _, tile in pairs(GetTiles()) do
            if tile.fg == itemID and GetTile(tile.x, tile.y).collidable then
                FindPath(tile.x, tile.y, 100)
                if nowEnable then
                    Sleep(1000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_gems|1")
                    isEnable = true
                    Sleep(1000)
                end
                if isEnable then
                    break
                end
            end
        end
        nowEnable = false
    end

    if countTree() == 0 then
        for _, tile in pairs(GetTiles()) do
            if tile.fg == 0 and GetTile(tile.x, tile.y).collidable then
                FindPath(tile.x, tile.y, 100)
                place(5640, 0, 0)
                if nowEnable then
                    Sleep(1000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_gems|1")
                    isEnable = true
                    Sleep(1000)
                end
                if isEnable then
                    break
                end
            end
        end
        nowEnable = false
    end
end

local function takeMagplant()
    if findItem(5640) == 0 or changeRemote then
        FindPath(magplantX, magplantY - 1, 60)
        Sleep(100)
        wrench(0, 1)
        Sleep(100)
        SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. magplantX .."|\ny|".. magplantY .."|\nbuttonClicked|getRemote")
        Sleep(1000)
    end
    if wreckWrench then
        cheatSetup()
    end
    wreckWrench = false
    changeRemote = false
end

local function remoteCheck()
    if GetWorld() == nil then
        return
    else
        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(1000)
            takeMagplant()
            Sleep(1000)
        end
    end
end

local function worldNot()
    if GetWorld().name ~= (worldName:upper()) then
        -- test
        for i = 1, 1 do
            Sleep(7000)
            overlayText("[Rab Store] `^Request to join world `2".. worldName.."")
            RequestJoinWorld(worldName)
            Sleep(1000)
            cheatSetup()
        end
        Sleep(delayRecon)
        playerHook("Reconnected, looks like you were recently disconnected")
    else
        Sleep(delayRecon)
        remoteCheck()
    end
end

local function reconnectPlayer()
    if GetWorld() == nil then
        for i = 1, 1 do
            Sleep(7000)
            overlayText("[Rab Store] `^Request to join world `2".. worldName.."")
            RequestJoinWorld(worldName)
            Sleep(1000)
            cheatSetup()
            Sleep(1000)
            nowEnable = true
            isEnable = false
        end
        Sleep(1000)
        remoteCheck()
		Sleep(1000)
        playerHook("Reconnected, looks like you were recently disconnected")
    else
        if GetWorld().name == (worldName:upper()) then
            Sleep(1000)
            remoteCheck()
            Sleep(1000)
        end
    end
end

local function wrenchMe()
    if GetWorld() == nil then
        Sleep(7000)
        reconnectPlayer()
    else
        SendPacket(2, "action|wrench\n|netid|".. GetLocal().netid)
    end
end

local function harvest()
    if autoHarvest then
        while countReady() > 0 do
            if findItem(itemID) >= 1 or findItem(itemID) == 1 then
                for y = y2, y1, - 1  do
                    for x = x1, x1 do
                        if isReady(GetTile(x,y)) then
                            FindPath(x, y, delayHarvest)
                            punch(0,0)
                        end

                        if GetWorld() == nil then
                            Sleep(delayRecon)
                            reconnectPlayer()
                            break
                        end
                    end
                end
            end

            if findItem(itemID) == 0 then
                for y = y2, y1, - 1 do
                    for x = x1, x1 do
                        if isReady(GetTile(x,y)) then
                            FindPath(x, y, delayHarvest)
                            punch(0, 0)
                            hold()
                        end
            
                        if GetWorld() == nil then
                            Sleep(1000)
                            reconnectPlayer()
                            break
                        end
                    end
                end
            end
        end
    end
end

local function plant()
    if autoPlant then
      playerHook("Plant")
        if countTree() < amtseed then

            for y = y2, y1, - 1 do  
               for x = x1, x2, 10 do
        
		            if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, delayPlant)
                            place(5640,0,0)
                        end
                    end

                    if GetWorld() == nil then
                        Sleep(delayRecon)
                        reconnectPlayer()
                        break
                    end

                    if changeRemote then
                        break
                    end
                end

                if GetWorld() == nil then
                    Sleep(delayRecon)
                    reconnectPlayer()
                    break
                end

                if changeRemote then
                    break
                end
            end
        end
    end
end

local function plantantimiss()
    if autoPlant then
        if countTree() < amtseed then
            for y = y2, y1, - 1 do  
                for x = x1, x2, 10 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 100)
                            place(5640,0,0)
                        end
                    end

                    if GetWorld() == nil then
                        Sleep(delayRecon)
                        reconnectPlayer()
                        break
                    end

                    if changeRemote then
                        break
                    end
                end

                if GetWorld() == nil then
                    Sleep(delayRecon)
                    reconnectPlayer()
                    break
                end

                if changeRemote then
                    break
                end
            end
        end

        if countTree() >= amtseed then
            if autoSpray then
                Sleep(1000)
                playerHook("Using Uws")
                SendPacket(2, "action|dialog_return\ndialog_name|ultraworldspray")
            end
        end
    end
    playerHook("Harvest")
    harvest()
    Sleep(1000)
end

ChangeValue("[C] Modfly", true)

load(MakeRequest("https://raw.githubusercontent.com/agsprdn2430/UID-Buyer/main/UID%20PTHT.lua","GET").content)()

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
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(1000)
            takeMagplant()
        end

        wrenchMe()
        Sleep(1000)
        if not ghostState then
            Sleep(1000)
            for i = 1, 1 do
                if autoGhost then
                    SendPacket(2, "action|input\ntext|/ghost")
                    break
                end
            end
        end
        
        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(1000)
            takeMagplant()
        end

        remoteCheck()
        harvest()
        plant()
        plantantimiss()
    end

else
    logText("`4Acces denied, User ID not registered.")
end
