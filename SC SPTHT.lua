function IsReady(tile)
    if tile and tile.extra and tile.extra.progress and tile.extra.progress == 1.0 then
        return true
    end
    return false
end

AddHook("onvariant", "mommy", function(var)
    if var[0] == "OnSDBroadcast" then 
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("MAGPLANT 5000") then
        if var[1]:find("The machine is currently empty!") then
        end
        return true
    end
end)

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

local function TakeMagplant1()
        FindPath(magplantX1, magplantY1 - 1, 60)
        Sleep(100)
        wrench(0, 1)
        Sleep(100)
        SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. magplantX1 .."|\ny|".. magplantY1 .."|\nbuttonClicked|getRemote")
        Sleep(1000)
end

local function TakeMagplant2()
        FindPath(magplantX2, magplantY2 - 1, 60)
        Sleep(100)
        wrench(0, 1)
        Sleep(100)
        SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. magplantX2 .."|\ny|".. magplantY2 .."|\nbuttonClicked|getRemote")
        Sleep(1000)
end

function checkseed()
    local Ready = 0
    for y = y1, y2 do
        for x = 0, 199 do
            if IsReady(GetTile(x, y)) then
                Ready = Ready + 1
            end
        end
    end
    return Ready
end

function punch(x, y)
    local pkt = {}
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    SendPacketRaw(false, pkt)
end

function place(id, x, y)
    local pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

function plant1(startX, endX, stepX, startY, endY, stepY)
    if checkseed() < amtseed then
        for x = startX, endX, stepX do
            for y = startY, endY, stepY do
                if GetTile(x, y).fg == 0 then
                    FindPath(x, y, 50)
                    Sleep(delaypt)
                    place(5640, 0, 0)
                    Sleep(delaypt)
                end
            end
        end
    end
end

function plant2(startX, endX, stepX, startY, endY, stepY)
    if checkseed() < amtseed then
        for x = startX, endX, stepX do
            for y = startY, endY, stepY do
                if GetTile(x, y).fg == SeedID then
                    FindPath(x, y, 50)
                    Sleep(delaypt)
                    place(5640, 0, 0)
                    Sleep(delaypt)
                end
            end
        end
    end
end

function harvest()
    if checkseed() > 0 then
        for y = y2,y1,-1 do
            for x = 0,0 do
                if IsReady(GetTile(x,y)) then
                    FindPath(x,y,50)
                    Sleep(delayht)
                    punch(0,0)
                    Sleep(delayht)
                    end
                end
            end
        end
end

function plantnormal()
    TakeMagplant1()
    plant1(0, 0, 1, y2, y1, -1)
    plant1(0, 0, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(0, 0, 1, y2, y1, -1)
    plant2(0, 0, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(10, 10, 1, y2, y1, -1)
    plant1(10, 10, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(10, 10, 1, y2, y1, -1)
    plant2(10, 10, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(20, 20, 1, y2, y1, -1)
    plant1(20, 20, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(20, 20, 1, y2, y1, -1)
    plant2(20, 20, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(30, 30, 1, y2, y1, -1)
    plant1(30, 30, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(30, 30, 1, y2, y1, -1)
    plant2(30, 30, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(40, 40, 1, y2, y1, -1)
    plant1(40, 40, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(40, 40, 1, y2, y1, -1)
    plant2(40, 40, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(50, 50, 1, y2, y1, -1)
    plant1(50, 50, 1, y2, y1, -1)
    TakeMagplant2()	
    plant2(50, 50, 1, y2, y1, -1)
    plant2(50, 50, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(60, 60, 1, y2, y1, -1)
    plant1(60, 60, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(60, 60, 1, y2, y1, -1)
    plant2(60, 60, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(70, 70, 1, y2, y1, -1)
    plant1(70, 70, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(70, 70, 1, y2, y1, -1)
    plant2(70, 70, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(80, 80, 1, y2, y1, -1)
    plant1(80, 80, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(80, 80, 1, y2, y1, -1)
    plant2(80, 80, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(90, 90, 1, y2, y1, -1)
    plant1(90, 90, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(90, 90, 1, y2, y1, -1)
    plant2(90, 90, 1, y2, y1, -1)
end

function plantisland()
    TakeMagplant1()
    plant1(0, 0, 1, y2, y1, -1)
    plant1(0, 0, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(0, 0, 1, y2, y1, -1)
    plant2(0, 0, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(10, 10, 1, y2, y1, -1)
    plant1(10, 10, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(10, 10, 1, y2, y1, -1)
    plant2(10, 10, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(20, 20, 1, y2, y1, -1)
    plant1(20, 20, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(20, 20, 1, y2, y1, -1)
    plant2(20, 20, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(30, 30, 1, y2, y1, -1)
    plant1(30, 30, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(30, 30, 1, y2, y1, -1)
    plant2(30, 30, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(40, 40, 1, y2, y1, -1)
    plant1(40, 40, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(40, 40, 1, y2, y1, -1)
    plant2(40, 40, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(50, 50, 1, y2, y1, -1)
    plant1(50, 50, 1, y2, y1, -1)
    TakeMagplant2()	
    plant2(50, 50, 1, y2, y1, -1)
    plant2(50, 50, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(60, 60, 1, y2, y1, -1)
    plant1(60, 60, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(60, 60, 1, y2, y1, -1)
    plant2(60, 60, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(70, 70, 1, y2, y1, -1)
    plant1(70, 70, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(70, 70, 1, y2, y1, -1)
    plant2(70, 70, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(80, 80, 1, y2, y1, -1)
    plant1(80, 80, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(80, 80, 1, y2, y1, -1)
    plant2(80, 80, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(90, 90, 1, y2, y1, -1)
    plant1(90, 90, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(90, 90, 1, y2, y1, -1)
    plant2(90, 90, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(100, 100, 1, y2, y1, -1)
    plant1(100, 100, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(100, 100, 1, y2, y1, -1)
    plant2(100, 100, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(110, 110, 1, y2, y1, -1)
    plant1(110, 110, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(110, 110, 1, y2, y1, -1)
    plant2(110, 110, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(120, 120, 1, y2, y1, -1)
    plant1(120, 120, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(120, 120, 1, y2, y1, -1)
    plant2(120, 120, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(130, 130, 1, y2, y1, -1)
    plant1(130, 130, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(130, 130, 1, y2, y1, -1)
    plant2(130, 130, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(140, 140, 1, y2, y1, -1)
    plant1(140, 140, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(140, 140, 1, y2, y1, -1)
    plant2(140, 140, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(150, 150, 1, y2, y1, -1)
    plant1(150, 150, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(150, 150, 1, y2, y1, -1)
    plant2(150, 150, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(160, 160, 1, y2, y1, -1)
    plant1(160, 160, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(160, 160, 1, y2, y1, -1)
    plant2(160, 160, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(170, 170, 1, y2, y1, -1)
    plant1(170, 170, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(170, 170, 1, y2, y1, -1)
    plant2(170, 170, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(180, 180, 1, y2, y1, -1)
    plant1(180, 180, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(180, 180, 1, y2, y1, -1)
    plant2(180, 180, 1, y2, y1, -1)
    TakeMagplant1()
    plant1(190, 190, 1, y2, y1, -1)
    plant1(190, 190, 1, y2, y1, -1)
    TakeMagplant2()
    plant2(190, 190, 1, y2, y1, -1)
    plant2(190, 190, 1, y2, y1, -1)
end

function uws()
   if autoUWS == 1 then
      SendPacket(2, "action|dialog_return\ndialog_name|ultraworldspray")
      Sleep(4000)
   else if autoUWS == 0 then
      Sleep(delaygrow)
end
end
end


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
logText("SPTHT Script by Rab Store.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)
SendPacket(2, "action|input\ntext|`6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
logText("Checking User ID.")
overlayText("`6Premium Script by `0[Rab Store]")
Sleep(1000)

load(MakeRequest("https://raw.githubusercontent.com/agsprdn2430/UID-Buyer/main/UID%20SPTHT.lua","GET").content)()

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
 if CONFIGURATION.WORLD == "normal" then
    harvest()
    Sleep(200)
    harvest()
    Sleep(1500)
    plantnormal()
    Sleep(1000)
    uws()
 elseif CONFIGURATION.WORLD == "island" then
    harvest()
    Sleep(200)
    harvest()
    Sleep(500)
    plantisland()
    Sleep(1000)
    uws()
 end
end

else
    logText("`4Acces denied, User ID not registered.")
end
