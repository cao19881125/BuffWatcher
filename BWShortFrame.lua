
BWShortFrame = {
    buflack = {}
}


local CreateFrame = CreateFrame

local LENGTH_SCAL = 8
local LABEL_SIZE = 12

local MoveRecordTmp = {
    p = "",
    x = 0,
    y = 0
}

local function Frame_OnMouseUp(frame,button)
    frame:StopMovingOrSizing()
    local point, relativeTo, relativePoint, xOfs, yOfs = BWShortFrame.frame:GetPoint()
    if(MoveRecordTmp.p == point and MoveRecordTmp.x == xOfs and MoveRecordTmp.y == yOfs) then
        OnButtonClick(frame,button)
    else
        --local str = "Frame_OnMouseUp " .. point .. " x:" .. xOfs .. " y:" .. yOfs
        --DEFAULT_CHAT_FRAME:AddMessage(str)
        --BWShortFrame.frame:SetPoint(point,xOfs,yOfs)
        if(BWShortFrame.MoveFinishCallback) then
            BWShortFrame.MoveFinishCallback(point,xOfs,yOfs)
        end
    end

end

local function Frame_OnMouseDown(frame,button)
    MoveRecordTmp.p,_,_,MoveRecordTmp.x,MoveRecordTmp.y = BWShortFrame.frame:GetPoint()
    frame:StartMoving()
end

local FrameBackdrop = {
    --bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

function BWShortFrame:CreateMainWindow()



	local frame = CreateFrame("Button", nil,UIParent, "UIPanelButtonTemplate")
    frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(false)
    frame:SetToplevel(true)
	frame:SetBackdrop(FrameBackdrop)
	frame:SetWidth(100)
    frame:SetHeight(50)
	frame:SetPoint("CENTER")
    frame:SetScript("OnMouseDown", Frame_OnMouseDown)
    frame:SetScript("OnMouseUp", Frame_OnMouseUp)
    frame:SetScript("OnEnter",BWShortFrame.ToolTipShow)
    frame:SetScript("OnLeave",function()
        GameTooltip:Hide()
    end)
    --frame:RegisterForClicks("AnyDown")
    --frame:SetScript("OnClick", OnButtonClick)

	--local image = frame:CreateTexture(nil, "BACKGROUND")
	local image = frame:CreateTexture()
	image:SetPoint("TOPLEFT", 12, -10)
	image:SetPoint("BOTTOMRIGHT", -12, 10)
	image:SetColorTexture(0x00,0xff,0x00)
    frame.texture = image
    --
    local text = frame:GetFontString()
	text:SetJustifyV("MIDDLE")
    text:SetText("全部健康")
    text:SetTextColor(255,255,255)

	--frame:Show()

    BWShortFrame.frame = frame
    --BWShortFrame.backGround = image
end

function OnButtonClick(frame,button)
    DEFAULT_CHAT_FRAME:AddMessage("OnButtonClick")

    if button == "LeftButton" then
        DEFAULT_CHAT_FRAME:AddMessage("OnButtonClick 1")
        if(BWShortFrame.LeftButtonCallback) then
            DEFAULT_CHAT_FRAME:AddMessage("OnButtonClick 2")
            BWShortFrame.LeftButtonCallback()
        end
    elseif button == "RightButton" then
        DEFAULT_CHAT_FRAME:AddMessage("OnButtonClick 3")
        if(BWShortFrame.RightButtonCallback) then
            DEFAULT_CHAT_FRAME:AddMessage("OnButtonClick 4")
            BWShortFrame.RightButtonCallback()
        end
    end
end

function BWShortFrame:Show()
    BWShortFrame.frame:Show()
end

function BWShortFrame:Hide()
    BWShortFrame.frame:Hide()
end

function BWShortFrame:SetPosition(point,x,y)
    BWShortFrame.frame:SetPoint(point,x,y)

    --local point, relativeTo, relativePoint, xOfs, yOfs = BWShortFrame.frame:GetPoint()
    --local str = "Frame_OnMouseUp " .. point .. " x:" .. xOfs .. " y:" .. yOfs
	--message(str)
end

function BWShortFrame:RegistreMoveFinishCallback(MoveFinishCallback)
    BWShortFrame.MoveFinishCallback = MoveFinishCallback
end

function BWShortFrame:RegisterLeftButtonCallback(LeftButtonCallback)
    --frame:SetScript("OnClick", LeftButtonCallback)
    BWShortFrame.LeftButtonCallback = LeftButtonCallback
end

function BWShortFrame:RegisterRightButtonCallback(RightButtonCallback)
    BWShortFrame.RightButtonCallback = RightButtonCallback
end

function BWShortFrame:ToolTipShow()
    GameTooltip:SetOwner(BWShortFrame.frame, "ANCHOR_BOTTOMLEFT",200)
    GameTooltip:AddLine("左键通报，右键打开主界面",0xff,0xff,0xff)
    GameTooltip:AddLine("===>Buff缺失异常人数<===")

    local bufname_to_cn = {
        PriestBlood = "耐力",
        PriestSpirt = "精神",
        MageIntelli = "智力",
        DruidClaw   = "爪子",
        WangZhe     = "王者",
        ZhengJiu    = "拯救",
        GuangMing   = "光明",
        LiLiang     = "力量",
        BiHu        = "庇护",
        ZhiHui      = "智慧",
        TankZhengJiu = "坦克拯救"
    }

    local noproblem = true

    for bufe,bufc in pairs(bufname_to_cn) do
        if(BWShortFrame.buflack[bufe]) then
            local tmpstr = "[" .. bufc .. "]  " .. BWShortFrame.buflack[bufe]
            GameTooltip:AddLine(tmpstr)
            noproblem = false
        end
    end

    if(noproblem) then
        GameTooltip:AddLine("全部健康")
    end

    GameTooltip:Show()
end

-- buflack = {
--      缺buf的table
--    PriestBlood = {
--        [1] = {
--            ["BufPlayer"] = "张三",  --责任人,
--            ["Lacker"] = {"李四","王二"} --缺少此buf的玩家
--        },
--        [2] = {
--            ["BufPlayer"] = "张三",  --责任人,
--            ["Lacker"] = {"李四","王二"} --缺少此buf的玩家
--        }
--        ...
--        [8] = {
--            ...
--        }
--
--    }
--    PriestSpirt = {}
--    MageIntelli = {}
--    DruidClaw  = {}
--    WangZhe = {
--      [1] = {
--          ["BufPlayer"] = "张三",  --责任人,有可能为nil
--          ["Lacker"] = {"李四","王二"} --缺少此buf的玩家
--      }
--    }
--    ZhengJiu = {}
--    GuangMing = {}
--    LiLiang   = {}
--    BiHu      = {}
--    ZhiHui    = {}
--  },
-- tankHasZhengJiu = {
--      需要点掉拯救的坦克列表
--  }
function BWShortFrame:SetBufLackInfo(buflack,tankHasZhengJiu,totalPlayerNum)

    local buflackNum = 0

    BWShortFrame.buflack = {}

    for buftype,bufarray in pairs(buflack) do

        local curbufnum = 0
        for groupunm,grouparray in pairs(bufarray) do
            buflackNum = buflackNum + #grouparray["Lacker"]
            curbufnum = curbufnum + #grouparray["Lacker"]
        end

        if(curbufnum > 0) then
            BWShortFrame.buflack[buftype] = curbufnum
        end

    end

    buflackNum = buflackNum + #tankHasZhengJiu

    if(#tankHasZhengJiu > 0) then
        BWShortFrame.buflack["TankZhengJiu"] = #tankHasZhengJiu
    end

    BWShortFrame:SetFrameBgColor(buflackNum,totalPlayerNum)

end

function BWShortFrame:SetFrameBgColor(lacknum,totolnum)

    if(not totolnum or totolnum <= 0 ) then
        lacknum = 0
        totolnum = 10
    end

    local bgcolor = {}

    local lackpercent = lacknum*100/totolnum

    if(lackpercent <= 0) then
        bgcolor = {0x00,0xff,0x00}  -- green
    elseif(lackpercent <= 20) then
        bgcolor = {0xff,0xff,0x00}  -- yellow
    elseif(lackpercent <= 40) then
        bgcolor = {0x00,0x00,0xff}  -- blue
    else
        bgcolor = {0xff,0x00,0x00}  -- red
    end

    BWShortFrame.frame.texture:SetColorTexture(bgcolor[1],bgcolor[2],bgcolor[3])

    local text = BWShortFrame.frame:GetFontString()

    if(lacknum <= 0) then
        text:SetText("全部健康")
    else
        text:SetText(lacknum.."人异常")
    end

end

