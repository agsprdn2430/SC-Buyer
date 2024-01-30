worldName = "" 
nowEnable = true 
isEnable = false 
ghostState = false 
wreckWrench = true 
changeRemote = false 
magplantX = magplantX - 1 
currentTime = os.time() 
player = GetLocal().name 
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
    Sleep(40)
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
    Sleep(40)
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
                name = "<:bot:1201730667281666078> Player Name"
                value = "]].. username ..[["
                inline = "false"
            }
  
            @{
                name = "<:gems:1194831751193825281> Total Gems"
                value = "Current Gems: ]].. FormatNumber(GetPlayerInfo().gems) ..[["
                inline = "false"
            }

            @{
                name = "<:gems:1194831751193825281> Previous Earned From The PTHT"
                value = "Previous Earned: ]].. FormatNumber(GetPlayerInfo().gems - previousGem) ..[["
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
                name = "<:stopwatch:1167910206647304334> PTHT UpcurrentTime"
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
logText("PNB Script by Rab Store.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
logText("Checking User ID.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)

SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_gems|1\n")
Sleep(100)

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
                FindPath(tile.x, tile.y, 60)
                if nowEnable then
                    Sleep(1000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|1\ncheck_gems|1")
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
                FindPath(tile.x, tile.y, 60)
                place(5640, 0, 0)
                if nowEnable then
                    Sleep(1000)
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|1\ncheck_gems|1")
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
        playerHook("Disconnected")
        for i = 1, 1 do
            Sleep(5000)
            RequestJoinWorld(worldName)
            Sleep(5000)
            cheatSetup()
        end
        Sleep(delayRecon)
        playerHook("Reconnected")
    else
        Sleep(delayRecon)
        remoteCheck()
    end
end

local function reconnectPlayer()
    if GetWorld() == nil then
        for i = 1, 1 do
            Sleep(5000)
            RequestJoinWorld(worldName)
            Sleep(5000)
            cheatSetup()
            Sleep(1000)
            nowEnable = true
            isEnable = false
        end
        Sleep(1000)
        remoteCheck()
		Sleep(1000)
        playerHook("Reconnected")
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
        Sleep(1000)
        reconnectPlayer()
    else
        SendPacket(2, "action|wrench\n|netid|".. GetLocal().netid)
    end
end

local function harvest()
        if autoHarvest then
                    for y = 0, 199  do
                        for x = x1, x1 do
                            if isReady(GetTile(x,y)) then
                                FindPath(x,y,50)
                                Sleep(delayHarvest)
                                punch(0,0)
                                Sleep(delayHarvest)
                            end

                            if GetWorld() == nil then
                                Sleep(delayRecon)
                                reconnectPlayer()
                                break
                            end
                        end
                    end
        end
end

function htantimiss()
 	harvest()
    Sleep(1000)
    previousGem = GetPlayerInfo().gems
end

local function plant()
    if autoPlant then
      playerHook("Plant")
        if countTree() < amtseed then
               for x = x1,x1 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant2()
    if autoPlant then
        if countTree() < amtseed then
            for x = 10,10 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant3()
    if autoPlant then
        if countTree() < amtseed then
               for x = 20,20 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant4()
    if autoPlant then
        if countTree() < amtseed then
            for x = 30,30 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant5()
    if autoPlant then
        if countTree() < amtseed then
               for x = 40,40 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant6()
    if autoPlant then
        if countTree() < amtseed then
            for x = 50,50 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant7()
    if autoPlant then
        if countTree() < amtseed then
               for x = 60,60 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant8()
    if autoPlant then
        if countTree() < amtseed then
            for x = 70,70 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant9()
    if autoPlant then
        if countTree() < amtseed then
               for x = 80,80 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant10()
    if autoPlant then
        if countTree() < amtseed then
            for x = 90,90 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant11()
    if autoPlant then
        if countTree() < amtseed then
               for x = 100,100 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant12()
    if autoPlant then
        if countTree() < amtseed then
            for x = 110,110 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant13()
    if autoPlant then
        if countTree() < amtseed then
               for x = 120,120 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant14()
    if autoPlant then
        if countTree() < amtseed then
            for x = 130,130 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant15()
    if autoPlant then
        if countTree() < amtseed then
               for x = 140,140 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant16()
    if autoPlant then
        if countTree() < amtseed then
            for x = 150,150 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant17()
    if autoPlant then
        if countTree() < amtseed then
               for x = 160,160 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant18()
    if autoPlant then
        if countTree() < amtseed then
            for x = 170,170 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant19()
    if autoPlant then
        if countTree() < amtseed then
               for x = 180,180 do
                   for y = y2,y1,-1 do    
                    
		    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function plant20()
    if autoPlant then
        if countTree() < amtseed then
            for x = 190,190 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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
        playerHook("Nambal")
        if countTree() < amtseed then
            for x = 0,199 do
		for y = y1,y2 do
                    
                    if GetWorld() == nil then
                        return
                    else
                        if GetTile(x, y).fg == 0 and GetTile(x, y + 1).fg == platformID then
                            FindPath(x, y, 50)
			    Sleep(delayPlant)
                            place(5640,0,0)
			    Sleep(delayPlant)
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

local function uws()
    if countTree() >= amtseed then
        if autoSpray then
            Sleep(1000)
            SendPacket(2, "action|dialog_return\ndialog_name|ultraworldspray")
        end
    end
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
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
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

        remoteCheck()---
        harvest()---
        htantimiss()---
        Sleep(1000)

        plant()--------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant()
        end

        plant2()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant2()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant2()
        end

        plant3()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant3()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant3()
        end

        plant4()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant4()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant4()
        end

        plant5()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant5()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant5()
        end

        plant6()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant6()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant6()
        end

        plant7()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant7()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant7()
        end

        plant8()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant8()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant8()
        end

        plant9()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant9()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant9()
        end

        plant10()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant10()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant10()
        end

        plant11()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant11()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant11()
        end

        plant12()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant12()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant12()
        end

        plant13()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant13()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant13()
        end

        plant14()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant14()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant14()
        end

        plant15()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant15()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant15()
        end

        plant16()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant16()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant166()
        end

        plant17()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant17()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant17()
        end

        plant18()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant18()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant18()
        end

        plant19()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant19()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant19()
        end

        plant20()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plant20()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plant20()
        end

        plantantimiss()-------------------------------------------------
        if GetWorld() == nil then
            playerHook("Disconnected")
            Sleep(delayRecon)
            reconnectPlayer()
            Sleep(delayRecon)
        end

        if GetWorld().name == (worldName:upper()) then
            Sleep(delayRecon)
        else
            playerHook("Disconnected")
            Sleep(delayRecon)
            worldNot()
            Sleep(delayRecon)
        end
        
        if changeRemote then
            for i = 1, 1 do
                magplantX = magplantX + 1
            end
            Sleep(100)
            takeMagplant()
        plantantimiss()
        end

        if findItem(5640) == 0 or findItem(5640) < 0 then
            Sleep(100)
            takeMagplant()
        plantantimiss()
        end

        Sleep(2000)
        uws()
        Sleep(4000)
    end

else
    logText("`4Acces denied, User ID not registered.")
end
