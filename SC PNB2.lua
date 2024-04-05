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
    ChangeValue("[C] Modfly", true)
    local AUTO_CONSUME = true
    local STAR_SMT = false
    local start = os.time()
    local NAME = GetLocal().name
    local WORLD_NAME = GetWorld().name
    local gems = GetPlayerInfo().gems
    local MULAI = false
    jumlahbgems = 0
    SUCK_MODE = false
    TAKE_MODE = true

    local function logText(text)
        packet = {}
        packet[0] = "OnConsoleMessage"
        packet[1] = "`^[Rab Store]`6 ".. text
        SendVariantList(packet)
    end

    SendPacket(2, "action|input\ntext|`^[Rab Store] `6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
    logText("Script is now running!")
    Sleep(1000)
    SendPacket(2, "action|input\ntext|`^[Rab Store] `6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
    logText("Turn on API List IO,OS, Make Request.")
    Sleep(1000)
    SendPacket(2, "action|input\ntext|`^[Rab Store] `6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
    logText("PNB Script by Rab Store.")
    Sleep(1000)
    SendPacket(2, "action|input\ntext|`^[Rab Store] `6[Premium Script by `b@4Rab`6] [DC : `5@4_rab`6]")
    logText("Checking User ID.")
    Sleep(1000) 

    function removeColorAndSymbols(str)
        local cleanedStr = string.gsub(str, "`(%S)", '')
        cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
        return cleanedStr
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

    function per(id)
    for _, inv in pairs(GetInventory()) do
    if inv.id == id then
    return inv.amount
    end
    end
    return 0
    end

    BGLSS = per(7188)
    GGLSS = per(11550)
    DLS = per(1796)
    WLS = per(242)
    BGLS = per(7188) * 100
    GGLS = per(11550) * 10000
    HARTAS = DLS+BGLS+GGLS

    function chek()
    SendPacket(2,"action|dialog_return\ndialog_name|popup\nbuttonClicked|bgems")
    end
    chek()

    function getWIBTime()
        local currentTimeUTC = os.time()
        local offsetToWIB = 7 * 60 * 60
        local currentTimeWIB = currentTimeUTC + offsetToWIB
        return currentTimeWIB
    end
    local wibTime = getWIBTime()
    function wh()
    chek()
    BGLS = per(7188)
    GGLS = per(11550)
    DL = per(1796)
    WL = per(242)
    BGL = per(7188) * 100
    GGL = per(11550) * 10000
    HARTA = DL+BGL+GGL
    DLPS = HARTA - HARTAS
        PGEMS = 0
        BGEMS = 0
        UWS = 0
        for _,object in pairs(GetObjectList()) do
                if object.id == 14420 then
        PGEMS = PGEMS + object.amount
        elseif object.id == 14668 then
        BGEMS = BGEMS + object.amount
        elseif object.id == 12600 then
        UWS = UWS + object.amount
        end
        end
        local ingfokan = GetPlayerInfo().gems - gems
        gems = GetPlayerInfo().gems
        MakeRequest(WEBHOOK_LINK,"POST",{["Content-Type"] = "application/json"}, [[
        {
        "username": "Rab Store ",
        "avatar_url": "https://cdn.discordapp.com/attachments/1193141414972899370/1198656133204811776/rs.png?ex=65c8ed04&is=65b67804&hm=26f0be87205a0f4a1af71df64258b463996e2dc38e2c4ec199d52c92df2261c9&",
        "embeds": [
            {
            "author": {
                "name": "",
                "icon_url": ""
            },
            "title": "<a:alert:1194823985628725428> **PNB Information** <a:alert:1194823985628725428>",
            "color": "]] ..math.random(1000000, 9999999).. [[",
            "fields": [
                {
                "name": "<:bot:1201730667281666078> Player Information",
                "value": "**Name :** ]]..  removeColorAndSymbols(NAME) ..[[\n**World :** ]].. WORLD_NAME ..[[",
                "inline": false
                },
                {
                "name": "<:gems:1194831751193825281> Gems Information",
                "value": "Owned Gems : **]].. FormatNumber(gems) ..[[** <:rgems:1225699132711243817>\n**]] .. FormatNumber(ingfokan) .. [[** Earned Gems In **]] .. WEBHOOK_DELAY .. [[** Seconds!",
                "inline": false
                },
                {
                "name": "<a:igl:1194820900026073149> Lock Information",
                "value": "**<:blgl:1194826207015997511> :  ]].. GGLSS.. [[ <:bugl:1194826224627888128> :  ]].. BGLSS ..[[ <:dl:1222850459430162493> :  ]].. DLS ..[[ <:wl:1222850479533588550> :  ]].. WLS ..[[**",
                "inline": false
                },
                {
                "name": "<:gs:1223097611846811869> Dropped Item Information",
                "value": "Black Gems : **]].. BGEMS .. [[**\nPink Gems : **]].. PGEMS .. [[**\nUltra World Spray : **]] .. UWS .. [[**",
                "inline": false
                },
                {
                "name": "<a:flash:1197511764603052102> Buff Information",
                "value": "Arroz Can Pollo : **]].. cek(4604) .. [[** <:taco:1178877190507614248>\nLucky Clover : **]].. cek(528) .. [[** <:four_leaf_clover:1178876649090076774>",
                "inline": false
                },
                {
                "name": "<:mp:1194831735666511912> Magplant Information",
                "value": "Magplant Stock : **]].. count .. [[** Mag Left !\nMagplant Position :  **]].. Mag[count].x ..[[, ]].. Mag[count].y ..[[**",
                "inline": false
                },
                {
                "name": "<:dl:1222850459430162493> Buy DL Mode",
                "value": "Fiture : **]].. MODEDL .. [[**\nTotal Purchases : **]].. FormatNumber(DLPS) ..[[** <:dl:1222850459430162493>!",
                "inline": false
                },
                {
                "name": "<:pog:1194831717442261022> Black Gems Mode",
                "value": "Fiture : **]].. MODE .. [[**",
                "inline": false
                }
            ],
        "thumbnail": {
            "url": "https://cdn.discordapp.com/attachments/1193141414972899370/1198656133204811776/rs.png?ex=65c8ed04&is=65b67804&hm=26f0be87205a0f4a1af71df64258b463996e2dc38e2c4ec199d52c92df2261c9&"
        },
        "image": {
            "url": ""
        },
        "footer": {
            "text": "Date: ]]..(os.date("!%A %b %d, %Y | Time: %I:%M %p ", os.time() + 8 * 60 * 60))..[[ | @4_rab",
            "icon_url": ""
        }
            }
        ]
        }]])
        end

    function cek(id)
        for _, item in pairs(GetInventory()) do
            if item.id == id then
                return item.amount
            end    
        end
        return 0
    end

    function cvtd(id)
    pkt = {}
    pkt.value = id
    pkt.type = 10
    SendPacketRaw(false, pkt)
    end





    nono = true -- DONT TOUCH
    local function main()

    local function consume(id, x, y)
        pkt = {}
        pkt.type = 3
        pkt.value = id
        pkt.px = math.floor(GetLocal().pos.x / 32 +x)
        pkt.py = math.floor(GetLocal().pos.y / 32 +y)
        pkt.x = GetLocal().pos.x
        pkt.y = GetLocal().pos.y
        SendPacketRaw(false, pkt)
    end

    local function ontext(str)
        SendVariantList({[0] = "OnTextOverlay", [1]  = str })
    end

    local function wrench()
        pkt = {}
        pkt.type = 3
        pkt.value = 32
        pkt.state = 8
        pkt.px = Mag[count].x
        pkt.py = Mag[count].y
        pkt.x = GetLocal().pos.x
        pkt.y = GetLocal().pos.y
        SendPacketRaw(false, pkt)
    end

    local function GetMagN()
        Mag = {}
        count = 0
        for _, tile in pairs(GetTiles()) do
            if (tile.fg == 5638) and (tile.bg == MAGPLANT_BACKGROUND) then
                count = count + 1
                Mag[count] = {x = tile.x, y = tile.y}
            end
        end
    end
    GetMagN()
    function ikang()
        Mag = {}
        count = 0
        for x = 199,0, -1 do
        for y = 199, 0 do
            tile = GetTile(x, y)
        if  (tile.fg == 5638) and (tile.bg == MAGPLANT_BACKGROUND) then
            count = count + 1
            Mag[count] = {x = tile.x, y = tile.y}
        end end end end
    local function scheat()
        if (cheats == true) and (GetLocal().pos.x//32 == xawal) and (GetLocal().pos.y//32 == yawal) then
    Sleep(500)
            if SUCK_MODE then
    SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|0")
    elseif TAKE_MODE then
    SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|1")
    end        Sleep(300)
            cheats = false
        end
    end

    local function fmag()
        if (findmag == true) then
            Sleep(200)
            FindPath(Mag[count].x , Mag[count].y - 1)
            ontext("`^[Rab Store] `6Checking `1Magplant")
            Sleep(300)
            findmag = false
            takeremote = true
    end
    end

    local function tremote()
        Sleep(500)
        if (takeremote  == true) then
            if GetLocal().pos.x//32 == Mag[count].x and GetLocal().pos.y//32 == Mag[count].y - 1 then
                Sleep(300)
                wrench()
                Sleep(100)
            if nono == false then
                ontext("`^[Rab Store] `6Take Remote `2Success")
                SendPacket(2,"action|dialog_return\ndialog_name|magplant_edit\nx|"..Mag[count].x.."|\ny|"..Mag[count].y.."|\nbuttonClicked|getRemote\n\n")
                takeremote = false
            elseif nono == true then
                ontext("`^[Rab Store] `6Thankyou for buying our script!")
                nono = false
                takeremote = false
                findmag = true
            end
            else
                SendVariantList({[0] = "OnTalkBubble", [1] = GetLocal().netid, [2] = "`4WARNING! PLEASE RERUN THE SCRIPT!!!\n`6Don't forget /ghost & Put the correct background\n`4UR WAY MAYBE BLOCKED/U PUT THE WRONG BACKGROUND"})
                takeremote = false
            end
        end
    end

    AddHook("onsendpacket", "Kaesde", function(type,str)
    if str:find("/suck") then
    logText("Auto Take Gems `4Deactive")
    logText("Auto Suck Black Gems `2Active")
    SUCK_MODE = true
    TAKE_MODE = false
    SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|0\n")
    return true
    end
    if str:find("/take") then
    logText("Auto Suck Black Gems `4Deactive")
    logText("Auto Take Gems `2Active")
    SUCK_MODE = false
    TAKE_MODE = true
    SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|1\n")
    return true
    end
    if str:find("/buydl") then
    ontext("`^[Rab Store] `6Buy `1DL `6Mode `2Active")
    BDL_MODE = true
    return true
    end
    if str:find("/stopdl") then
    ontext("`^[Rab Store] `6Buy `1DL `6Mode `4Deactive")
    BDL_MODE = false
    return true
    end
    if str:find("/buydelay (%d+)") then
    DelayBuyDL = str:match("/delaybuy (%d+)")
    ontext("`^[Rab Store] `6Delay `6Buy `1DLS `6 Has Set To `0"..DelayBuyDL.." Second!")
    return true
    end
    return false
    end)


    while true do
        Sleep(500)
        if count > 0 then
            if (getworld == true) then
                ontext("`^[Rab Store] `6Request to join world `2["..WORLD_NAME.."]")
                SendPacket(3, "action|join_request\nname|"..WORLD_NAME.."\ninvitedWORLD_NAME|0")
                Sleep(7000)
                getworld = false
            end
            if (delayed == true) then
    Sleep(500)
    delayed = false
                findmag = true
            end
            if (findmag == true) then
                Sleep(500)
                fmag()
            end
            if (cheats == true) then
                Sleep(500)
                scheat()
            end
            if (takeremote == true) then
                tremote()
                Sleep(500)
            end
            if (empty == true) then
                SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0")
                Sleep(500)
                count = count - 1
                empty = false
                findmag = true
            end
            if (nothing == true) then
                Sleep(500)
                count = count - 1
                nothing = false
                findmag = true
            end
        else
            ontext("`^[Rab Store] `6All `1Magplant `6Are `4Empty")
        end
        if (AUTO_CONSUME == true) then
    SendPacket(2,"action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0")
    Sleep(500)
            FindPath(xawal,yawal)
            Sleep(500)
            consume(528,0,0)
            ontext("`^[Rab Store] `6Eating `0Arroz Can Pollo")
        Sleep(500)
        consume(4604,0,0)
        ontext("`^[Rab Store] `6Eating `2Lucky Clover")
        Sleep(500)
        findmag = true
        AUTO_CONSUME = false
        end
    if BDL_MODE then
    MODEDL = "Auto Buy DL Every ".. DelayBuyDL .. " Seconds!"
        countdl = 0
    SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|".. xawal .."|\ny|".. yawal .."|\nbuttonClicked|dlconvert")
    Sleep(DelayBuyDL * 1000)
    countdl = countdl + 1
    if cek(1796) >= 100 then
    Sleep(500)
    SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|".. xawal .."|\ny|".. yawal .."|\nbuttonClicked|bglconvert")
    Sleep(100)
    end
    elseif not BDL_MODE then
    MODEDL = "Deactive"
    end
    if os.time() - start >= WEBHOOK_DELAY then
    STAR_SMT = true
    if SUCK_MODE then
        MODE = "Auto Suck Black Gems Every "..WEBHOOK_DELAY.." Seconds!"
    SendPacket(2,"action|dialog_return\ndialog_name|popup\nbuttonClicked|bgem_suckall")
    elseif not SUCK_MODE then
        MODE = "Deactive"
        BGEMS = 0
    end
    start = os.time()
    wh()
    Sleep(1000)
    STAR_SMT = false
    end
    if hitungdl then
    countdl = countdl + 1
    hitungdl = false
    end
    end
    end
    xawal = GetLocal().pos.x//32
    yawal = GetLocal().pos.y//32
    main()
else
    logText("`4Acces denied, User ID not registered.")
end
