local AceGUI = LibStub("AceGUI-3.0")


BWMainWindow = {
    DropDownBox = {
        ["PriestBlood"] = {
            -- 牧师耐力  八个队伍的dropdown控件
            [1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil
        },
        ["PriestSpirt"] = {
            -- 牧师精神  八个队伍的dropdown控件
            [1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil
        },
        ["MageIntelli"] = {
            -- 法师智力  八个队伍的dropdown控件
            [1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil
        },
        ["DruidClaw"] = {
            -- 小德爪子  八个队伍的dropdown控件
            [1] = nil,[2] = nil,[3] = nil,[4] = nil,[5] = nil,[6] = nil,[7] = nil,[8] = nil
        },
        ["Knight"] = {
            -- 骑士
            ["WangZhe"] = nil,["ZhengJiu"] = nil,["GuangMing"] = nil,["LiLiang"] = nil,["BiHu"] = nil,["ZhiHui"] = nil
        },
        ["Warlock"] = {
            -- 术士
            ["LuMang"] = nil,["YuanSu"] = nil,["YuYan"] = nil,["AnYing"] = nil
        },
        ["Tank"] = {
            -- 坦克
            [1] = nil,[2] = nil,[3] = nil,[4] = nil
        }
    },
    Buttons = {
        RestButton = nil,
        NotifyButton = nil,
        AllocateButton = nil,
        MonitorButton = nil
    },
    Config = {
        NotifyCheckbox = {
            RaidBox = nil,
            PersonBox = nil
        },
        AutoCheck = {
            IntervalEditBox = nil
        }
    }
}

local SCALE_LENGTH = 10


function BWMainWindow:ChangeFontSize(fontString,size)
    local Font, Height, Flags = fontString:GetFont()
    fontString:SetFont(Font, size, Flags)
end

-- Factio :
--  Alliance : 联盟
--  Horde   : 部落
function BWMainWindow:CreateMainWindow(Faction)
    local frame = AceGUI:Create("NameFrame")
    frame:SetTitle("Buff监控")
    frame:SetStatusText("监控状态:停止")
    frame:SetLayout("List")
    frame:SetWidth(68*SCALE_LENGTH)

    if(Faction == "Alliance") then
        frame:SetHeight(65*SCALE_LENGTH)
    elseif(Faction == "Horde")   then
        frame:SetHeight(55*SCALE_LENGTH)
    end


    frame.frame:SetResizable(false)
    tinsert(UISpecialFrames, frame.frame:GetName());

    -- 牧师耐力精神
    local PriestBloodGroup,dropdownarray = BWMainWindow:CreateBufGroup("耐力精神")
    BWMainWindow.DropDownBox["PriestBlood"] = dropdownarray


    -- 小德爪子
    local DruidClawGroup,dropdownarray = BWMainWindow:CreateBufGroup("爪子")
    BWMainWindow.DropDownBox["DruidClaw"] = dropdownarray

    -- 法师智力
    local MageIntelliGroup,dropdownarray = BWMainWindow:CreateBufGroup("智力")
    BWMainWindow.DropDownBox["MageIntelli"] = dropdownarray

    -- 骑士buf
    local KnightGroup,dropdownarray = BWMainWindow:CreateKnightBufGroup()
    BWMainWindow.DropDownBox["Knight"] = dropdownarray


    -- 术士buf
    local WarlockGroup,dropdownarray = BWMainWindow:CreateWarlockGroup()
    BWMainWindow.DropDownBox["Warlock"] = dropdownarray


    --坦克列表
    local TankGroup,dropdownarray = BWMainWindow:CreateTankGroup()
    BWMainWindow.DropDownBox["Tank"] = dropdownarray


    -- layout
    local FlowLayout1 = AceGUI:Create("SimpleGroup")
    FlowLayout1:SetLayout("Flow")
    FlowLayout1:SetWidth(68*SCALE_LENGTH)
    FlowLayout1:SetHeight(40*SCALE_LENGTH)
    frame:AddChild(FlowLayout1)


    FlowLayout1:AddChild(PriestBloodGroup)
    FlowLayout1:AddChild(DruidClawGroup)


    local FlowLayout2 = AceGUI:Create("SimpleGroup")
    FlowLayout2:SetLayout("Flow")
    FlowLayout2:SetWidth(68*SCALE_LENGTH)
    FlowLayout2:SetHeight(40*SCALE_LENGTH)
    frame:AddChild(FlowLayout2)


    FlowLayout2:AddChild(MageIntelliGroup)
    if(Faction == "Alliance") then
        FlowLayout2:AddChild(KnightGroup)
    elseif(Faction == "Horde")   then
        WarlockGroup:SetHeight(17*SCALE_LENGTH)
        WarlockGroup.noAutoHeight = true
        FlowLayout2:AddChild(WarlockGroup)
    end


    local FlowLayout3 = AceGUI:Create("SimpleGroup")
    FlowLayout3:SetLayout("Flow")
    FlowLayout3:SetWidth(68*SCALE_LENGTH)
    FlowLayout3:SetHeight(20*SCALE_LENGTH)
    frame:AddChild(FlowLayout3)

    if(Faction == "Alliance") then
        FlowLayout3:AddChild(WarlockGroup)
        FlowLayout3:AddChild(TankGroup)
    elseif(Faction == "Horde")   then
    end


    local ConfigGroup = BWMainWindow:CreateConfigGroup()
    frame:AddChild(ConfigGroup)


    local ButtonGroup = BWMainWindow:CreateButtonGroup()
    frame:AddChild(ButtonGroup)

    BWMainWindow.frame = frame
end

function BWMainWindow:Show()
    BWMainWindow.frame:Show()
end

function BWMainWindow:Hide()
    BWMainWindow.frame:Hide()
end

function BWMainWindow:CreateBufGroup(bufname)
    local BloodGroup = AceGUI:Create("InlineGroup")
    BloodGroup:SetLayout("List")
    BloodGroup:SetTitle(bufname)
    BloodGroup:SetWidth(32*SCALE_LENGTH)
    BloodGroup:SetHeight(17*SCALE_LENGTH)
    BloodGroup.noAutoHeight = true

    local DropdownArray = {}

    local dropdownGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("一队","二队")
    BloodGroup:AddChild(dropdownGroup)
    DropdownArray[1] = dropdown1
    DropdownArray[2] = dropdown2

    dropdownGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("三队","四队")
    BloodGroup:AddChild(dropdownGroup)
    DropdownArray[3] = dropdown1
    DropdownArray[4] = dropdown2

    dropdownGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("五队","六队")
    BloodGroup:AddChild(dropdownGroup)
    DropdownArray[5] = dropdown1
    DropdownArray[6] = dropdown2

    dropdownGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("七队","八队")
    BloodGroup:AddChild(dropdownGroup)
    DropdownArray[7] = dropdown1
    DropdownArray[8] = dropdown2

    return BloodGroup,DropdownArray
end

function BWMainWindow:CreateTwoGroupGroupDown(label1,label2)
    local OneTwoGroup = AceGUI:Create("SimpleGroup")
    OneTwoGroup:SetLayout("Flow")
    OneTwoGroup:SetWidth(32*SCALE_LENGTH)
    OneTwoGroup:SetHeight(SCALE_LENGTH)

    local OneGroupDropDown = AceGUI:Create("Dropdown2")
    OneGroupDropDown:SetLabel(label1)
    OneGroupDropDown:SetText("<空>")
    OneGroupDropDown:SetWidth(15*SCALE_LENGTH)
    OneGroupDropDown:SetHeight(SCALE_LENGTH)
    OneTwoGroup:AddChild(OneGroupDropDown)


    local TwoGroupDropDown = AceGUI:Create("Dropdown2")
    TwoGroupDropDown:SetLabel(label2)
    TwoGroupDropDown:SetText("<空>")
    TwoGroupDropDown:SetWidth(15*SCALE_LENGTH)
    TwoGroupDropDown:SetHeight(SCALE_LENGTH)
    OneTwoGroup:AddChild(TwoGroupDropDown)

    return OneTwoGroup,OneGroupDropDown,TwoGroupDropDown
end

function BWMainWindow:CreateKnightBufGroup2()
    local BloodGroup = AceGUI:Create("InlineGroup")
    BloodGroup:SetLayout("List")
    BloodGroup:SetTitle("骑士")
    BloodGroup:SetWidth(32*SCALE_LENGTH)
    BloodGroup:SetHeight(17*SCALE_LENGTH)
    BloodGroup.noAutoHeight = true

    local DropdownArray = {}

    local dropdownGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("王者","力量")
    BloodGroup:AddChild(dropdownGroup)
    DropdownArray[1] = dropdown1
    DropdownArray[2] = dropdown2

    dropdownGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("拯救","智慧")
    BloodGroup:AddChild(dropdownGroup)
    DropdownArray[3] = dropdown1
    DropdownArray[4] = dropdown2

    dropdownGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("光明","庇护")
    BloodGroup:AddChild(dropdownGroup)
    DropdownArray[5] = dropdown1
    DropdownArray[6] = dropdown2




    return BloodGroup,DropdownArray
end

function BWMainWindow:CreateKnightBufGroup()
    local KnightGroup = AceGUI:Create("InlineGroup")
    KnightGroup:SetLayout("List")
    KnightGroup:SetTitle("骑士")
    KnightGroup:SetWidth(32*SCALE_LENGTH)
    KnightGroup:SetHeight(17*SCALE_LENGTH)
    KnightGroup.noAutoHeight = true


    local DropdownArray = {}

    local OneTwoGroup = AceGUI:Create("SimpleGroup")
    OneTwoGroup:SetLayout("Flow")
    OneTwoGroup:SetWidth(32*SCALE_LENGTH)
    OneTwoGroup:SetHeight(SCALE_LENGTH)
    KnightGroup:AddChild(OneTwoGroup)

    local WangZheDropDown = AceGUI:Create("Dropdown2")
    WangZheDropDown:SetLabel("王者")
    WangZheDropDown:SetText("<空>")
    WangZheDropDown:SetWidth(15*SCALE_LENGTH)
    WangZheDropDown:SetHeight(SCALE_LENGTH)
    --WangZheDropDown:SetText("MAGE11")
    --BWMainWindow:ChangeFontSize(WangZheDropDown,10)
    OneTwoGroup:AddChild(WangZheDropDown)
    DropdownArray["WangZhe"] = WangZheDropDown

    local ZhengJiuDropDown = AceGUI:Create("Dropdown2")
    ZhengJiuDropDown:SetLabel("拯救")
    ZhengJiuDropDown:SetText("<空>")
    ZhengJiuDropDown:SetWidth(15*SCALE_LENGTH)
    ZhengJiuDropDown:SetHeight(SCALE_LENGTH)
    OneTwoGroup:AddChild(ZhengJiuDropDown)
    DropdownArray["ZhengJiu"] = ZhengJiuDropDown


    local ThreeFourGroup = AceGUI:Create("SimpleGroup")
    ThreeFourGroup:SetLayout("Flow")
    ThreeFourGroup:SetWidth(32*SCALE_LENGTH)
    ThreeFourGroup:SetHeight(SCALE_LENGTH)
    KnightGroup:AddChild(ThreeFourGroup)

    local GuangMingDropDown = AceGUI:Create("Dropdown2")
    GuangMingDropDown:SetLabel("光明")
    GuangMingDropDown:SetText("<空>")
    GuangMingDropDown:SetWidth(15*SCALE_LENGTH)
    GuangMingDropDown:SetHeight(SCALE_LENGTH)
    ThreeFourGroup:AddChild(GuangMingDropDown)
    DropdownArray["GuangMing"] = GuangMingDropDown

    local LiLiangDropDown = AceGUI:Create("Dropdown2")
    LiLiangDropDown:SetLabel("力量")
    LiLiangDropDown:SetText("<空>")
    LiLiangDropDown:SetWidth(15*SCALE_LENGTH)
    LiLiangDropDown:SetHeight(SCALE_LENGTH)
    ThreeFourGroup:AddChild(LiLiangDropDown)
    DropdownArray["LiLiang"] = LiLiangDropDown


    local FiveSixGroup = AceGUI:Create("SimpleGroup")
    FiveSixGroup:SetLayout("Flow")
    FiveSixGroup:SetWidth(32*SCALE_LENGTH)
    FiveSixGroup:SetHeight(SCALE_LENGTH)
    KnightGroup:AddChild(FiveSixGroup)

    local ZhiHuiDropDown = AceGUI:Create("Dropdown2")
    ZhiHuiDropDown:SetLabel("智慧")
    ZhiHuiDropDown:SetText("<空>")
    ZhiHuiDropDown:SetWidth(15*SCALE_LENGTH)
    ZhiHuiDropDown:SetHeight(SCALE_LENGTH)
    FiveSixGroup:AddChild(ZhiHuiDropDown)
    DropdownArray["ZhiHui"] = ZhiHuiDropDown

    local BiHuDropDown = AceGUI:Create("Dropdown2")
    BiHuDropDown:SetLabel("庇护")
    BiHuDropDown:SetText("<空>")
    BiHuDropDown:SetWidth(15*SCALE_LENGTH)
    BiHuDropDown:SetHeight(SCALE_LENGTH)
    FiveSixGroup:AddChild(BiHuDropDown)
    DropdownArray["BiHu"] = BiHuDropDown



    return KnightGroup,DropdownArray
end

function BWMainWindow:CreateWarlockGroup()
    local WarlockGroup = AceGUI:Create("InlineGroup")
    WarlockGroup:SetLayout("List")
    WarlockGroup:SetTitle("术士")
    WarlockGroup:SetWidth(32*SCALE_LENGTH)
    WarlockGroup:SetHeight(17*SCALE_LENGTH)

    local DropdownArray = {}
    local OneTwoGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("鲁莽","元素")
    WarlockGroup:AddChild(OneTwoGroup)
    DropdownArray["LuMang"] = dropdown1
    DropdownArray["YuanSu"] = dropdown2


    local ThreeFourGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("语言","暗影")
    WarlockGroup:AddChild(ThreeFourGroup)
    DropdownArray["YuYan"] = dropdown1
    DropdownArray["AnYing"] = dropdown2

    return WarlockGroup,DropdownArray
end

function BWMainWindow:CreateTankGroup()
    local TankGroup = AceGUI:Create("InlineGroup")
    TankGroup:SetLayout("List")
    TankGroup:SetTitle("坦克")
    TankGroup:SetWidth(32*SCALE_LENGTH)
    TankGroup:SetHeight(20*SCALE_LENGTH)

    local DropdownArray = {}
    local OneTwoGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("一坦","二坦")
    TankGroup:AddChild(OneTwoGroup)
    DropdownArray[1] = dropdown1
    DropdownArray[2] = dropdown2

    local ThreeFourGroup,dropdown1,dropdown2 = BWMainWindow:CreateTwoGroupGroupDown("三坦","四坦")
    TankGroup:AddChild(ThreeFourGroup)
    DropdownArray[3] = dropdown1
    DropdownArray[4] = dropdown2

    return TankGroup,DropdownArray
end

function BWMainWindow:CreateConfigGroup()

    local FlowLayout3 = AceGUI:Create("SimpleGroup")
    FlowLayout3:SetLayout("Flow")
    FlowLayout3:SetWidth(84*SCALE_LENGTH)
    FlowLayout3:SetHeight(10*SCALE_LENGTH)

    local ConfigGroup = AceGUI:Create("InlineGroup")
    ConfigGroup:SetLayout("Flow")
    ConfigGroup:SetTitle("通报")
    ConfigGroup:SetWidth(20*SCALE_LENGTH)
    ConfigGroup:SetHeight(4*SCALE_LENGTH)
    FlowLayout3:AddChild(ConfigGroup)

    local NotifyGroup = AceGUI:Create("SimpleGroup")
    NotifyGroup:SetLayout("Flow")
    NotifyGroup:SetWidth(20*SCALE_LENGTH)
    NotifyGroup:SetHeight(4*SCALE_LENGTH)
    ConfigGroup:AddChild(NotifyGroup)


    local RaidCheckbox = AceGUI:Create("CheckBox")
    RaidCheckbox:SetLabel("团队")
    RaidCheckbox:SetWidth(8*SCALE_LENGTH)
    RaidCheckbox:SetHeight(4*SCALE_LENGTH)
    BWMainWindow:ChangeFontSize(RaidCheckbox.text,12)
    NotifyGroup:AddChild(RaidCheckbox)
    BWMainWindow.Config.NotifyCheckbox.RaidBox = RaidCheckbox
    --
    local PersonCheckbox = AceGUI:Create("CheckBox")
    PersonCheckbox:SetLabel("私聊")
    PersonCheckbox:SetWidth(8*SCALE_LENGTH)
    PersonCheckbox:SetHeight(4*SCALE_LENGTH)
    BWMainWindow:ChangeFontSize(PersonCheckbox.text,12)
    NotifyGroup:AddChild(PersonCheckbox)
    BWMainWindow.Config.NotifyCheckbox.PersonBox = PersonCheckbox

    local AutoCheckGroup = AceGUI:Create("InlineGroup")
    AutoCheckGroup:SetLayout("Flow")
    AutoCheckGroup:SetTitle("自动检查")
    AutoCheckGroup:SetWidth(13*SCALE_LENGTH)
    AutoCheckGroup:SetHeight(4*SCALE_LENGTH)
    FlowLayout3:AddChild(AutoCheckGroup)

    --local CheckIntervalLabel = AceGUI:Create("Label")
    --CheckIntervalLabel:SetText("间隔(秒)")
    --CheckIntervalLabel:SetJustifyV("MIDDLE")
    --BWMainWindow:ChangeFontSize(CheckIntervalLabel.label,12)
    --CheckIntervalLabel:SetWidth(3*SCALE_LENGTH)
    --CheckIntervalLabel:SetHeight(4*SCALE_LENGTH)
    --AutoCheckGroup:AddChild(CheckIntervalLabel)

    local AutoCheckEditBox = AceGUI:Create("EditBox")
    AutoCheckEditBox:SetLabel("间隔(秒)")
    BWMainWindow:ChangeFontSize(AutoCheckEditBox.label,12)
    AutoCheckEditBox:SetWidth(10*SCALE_LENGTH)
    AutoCheckEditBox:SetHeight(4*SCALE_LENGTH)
    AutoCheckGroup:AddChild(AutoCheckEditBox)
    BWMainWindow.Config.AutoCheck.IntervalEditBox = AutoCheckEditBox

    return FlowLayout3
end

function BWMainWindow:CreateButtonGroup()
    local ButtonGroup = AceGUI:Create("SimpleGroup")
    ButtonGroup:SetLayout("Flow")
    ButtonGroup:SetWidth(84*SCALE_LENGTH)
    ButtonGroup:SetHeight(10*SCALE_LENGTH)


    local RestButton = AceGUI:Create("Button")
    RestButton:SetText("初始化")
    RestButton:SetWidth(10*SCALE_LENGTH)
    ButtonGroup:AddChild(RestButton)
    BWMainWindow.Buttons.RestButton = RestButton


    local AllocateButton = AceGUI:Create("Button")
    AllocateButton:SetText("自动分配")
    AllocateButton:SetWidth(10*SCALE_LENGTH)
    ButtonGroup:AddChild(AllocateButton)
    BWMainWindow.Buttons.AllocateButton = AllocateButton

    local NotifyButton = AceGUI:Create("Button")
    NotifyButton:SetText("通报")
    NotifyButton:SetWidth(10*SCALE_LENGTH)
    ButtonGroup:AddChild(NotifyButton)
    BWMainWindow.Buttons.NotifyButton = NotifyButton

    local CheckConfigButton = AceGUI:Create("Button")
    CheckConfigButton:SetText("检查设置")
    CheckConfigButton:SetWidth(10*SCALE_LENGTH)
    ButtonGroup:AddChild(CheckConfigButton)
    CheckConfigButton:SetCallback("OnClick", BWMainWindow.OnCheckConfigButtonClick)
    BWMainWindow.Buttons.CheckConfigButton = CheckConfigButton

    local CheckButton = AceGUI:Create("Button")
    CheckButton:SetText("检查")
    CheckButton:SetWidth(10*SCALE_LENGTH)
    ButtonGroup:AddChild(CheckButton)
    BWMainWindow.Buttons.CheckButton = CheckButton


    local MonitorButton = AceGUI:Create("Button")
    MonitorButton:SetText("开启自动检查")
    BWMainWindow:ChangeFontSize(MonitorButton.text,12)
    MonitorButton:SetWidth(15*SCALE_LENGTH)
    ButtonGroup:AddChild(MonitorButton)
    BWMainWindow.Buttons.MonitorButton = MonitorButton

    return ButtonGroup
end


function BWMainWindow:OnCheckConfigButtonClick()
    _G.BWCheckPlayerWindow:Show()
end

-- 设置检查通知按钮值
-- RaidNotify: 团队通报 True/False
-- PersonNotify: 私聊通报   True/False
function BWMainWindow:SetNotifyInfo(RaidNotify,PersonNotify)
    BWMainWindow.Config.NotifyCheckbox.RaidBox:SetValue(RaidNotify)
    BWMainWindow.Config.NotifyCheckbox.PersonBox:SetValue(PersonNotify)
end

-- 获取检查通知选取结果
-- return RaidNotify,PersonNotify
function BWMainWindow:GetNotifyInfo()
    return BWMainWindow.Config.NotifyCheckbox.RaidBox:GetValue(),BWMainWindow.Config.NotifyCheckbox.PersonBox:GetValue()
end

-- 获取自动检查间隔值
function BWMainWindow:GetAutocheckIntervalEditText()
    return BWMainWindow.Config.AutoCheck.IntervalEditBox:GetText()
end

-- data: 包含所有职业名称的数据结构，如下
--data = {
--    PRIEST = {[1]="张三",[2]="李四"},     --牧师
--    PALADIN = {[1]="张三",[2]="李四"},     --骑士
--    WARLOCK = {[1]="张三",[2]="李四"},    --术士
--    MAGE = {[1]="张三",[2]="李四"},       --法师
--    DRUID = {[1]="张三",[2]="李四"},      --德鲁伊
--    WARRIOR = {[1]="张三",[2]="李四"}     --战士
--}

function BWMainWindow:SetAllDropDown(data)

    for _,value in pairs(data) do
        value[#value + 1] = "<空>"
    end

    -- 设置牧师，法师，小德列表
    for i =1,8 do
        BWMainWindow.DropDownBox.PriestBlood[i]:SetList(data["PRIEST"])
        --BWMainWindow.DropDownBox.PriestSpirt[i]:SetList(data["PRIEST"])
        BWMainWindow.DropDownBox.MageIntelli[i]:SetList(data["MAGE"])
        BWMainWindow.DropDownBox.DruidClaw[i]:SetList(data["DRUID"])
    end

    -- 设置骑士列表
    for key,value in pairs( BWMainWindow.DropDownBox.Knight) do
        value:SetList(data["PALADIN"])
    end

    -- 设置术士列表
    for key,value in pairs( BWMainWindow.DropDownBox.Warlock) do
        value:SetList(data["WARLOCK"])
    end

    -- 设置坦克列表
    local tanklist = {}
    for key,value in pairs(data["WARRIOR"]) do
        tanklist[#tanklist + 1] = value
    end

    for key,value in pairs(data["DRUID"]) do
        tanklist[#tanklist + 1] = value
    end

    for key,value in pairs( BWMainWindow.DropDownBox.Tank) do
        value:SetList(tanklist)
    end

end

-- 设置确切的buf
-- buftype:buf类型
--      PriestBlood:牧师耐力精神 MageIntelli:法师智力 DruidClaw:小德爪子
--      WangZhe:骑士王者 ZhengJiu:骑士拯救 GuangMing:骑士光明 LiLiang:骑士力量 BiHu:骑士庇护 ZhiHui:骑士智慧
--      LuMang:术士鲁莽  YuanSu:术士元素 YuYan:术士语言 AnYing:术士暗影
-- groupnum:小队  骑士和术士不需要设置
-- name:刷buf的责任人
function BWMainWindow:SetOneSureName(buftype,groupnum,name)
    if(buftype == "PriestBlood"
        or buftype == "MageIntelli" or buftype == "DruidClaw") then
        BWMainWindow.DropDownBox[buftype][groupnum]:SetText(name)
    elseif(buftype == "WangZhe" or buftype == "ZhengJiu" or buftype == "GuangMing"
            or buftype == "LiLiang" or buftype == "BiHu" or buftype == "ZhiHui") then
        BWMainWindow.DropDownBox.Knight[buftype]:SetText(name)
    elseif(buftype == "LuMang" or buftype == "YuanSu" or buftype == "YuYan" or buftype == "AnYing")  then
        BWMainWindow.DropDownBox.Warlock[buftype]:SetText(name)
    end

end

-- 获取所有的分配情况
-- result:
--result = {
--    PriestBlood = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    PriestSpirt = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    MageIntelli = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    DruidClaw = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    Knight = {["WangZhe"] = "张三",["ZhengJiu"]="李四",["GuangMing"]="王二",["LiLiang"]="..",["BiHu"] = "..",["ZhiHui"]=".."},
--    Warlock = {["LuMang"] = "..",["YuanSu"] = "..",["YuYan"] = "..",["AnYing"] = ".."}
--}
-- 注意，如果未设置任何值，则为nil，比如未选择一队耐力，则result.PriestBlood[1] = nil

function BWMainWindow:GetAllAllocation()

    local result = {}
    result["PriestBlood"] = {}
    result["PriestSpirt"] = {}
    result["MageIntelli"] = {}
    result["DruidClaw"] = {}
    for i = 1,8 do
        result["PriestBlood"][i] = BWMainWindow.DropDownBox.PriestBlood[i]:GetText()
        result["PriestSpirt"][i] = result["PriestBlood"][i]
        result["MageIntelli"][i] = BWMainWindow.DropDownBox.MageIntelli[i]:GetText()
        result["DruidClaw"][i] = BWMainWindow.DropDownBox.DruidClaw[i]:GetText()
    end

    result["Knight"] = {}
    for key,value in pairs(BWMainWindow.DropDownBox.Knight) do
        result["Knight"][key] = value:GetText()
    end

    result["Warlock"] = {}
    for key,value in pairs(BWMainWindow.DropDownBox.Warlock) do
        result["Warlock"][key] = value:GetText()
    end

    for _,bufarray in pairs(result) do
        for key,value in pairs(bufarray) do
            if(value == "<空>") then
                bufarray[key] = nil
            end
        end
    end

    return result
end

-- 获取坦克的选择情况
--result = {
--    [1] = "一坦",
--    [2] = "二坦",
--    [3] = "三坦",
--    [4] = "四坦",
--}

function BWMainWindow:GetTankAllocation()
    local result = {}

    for i = 1,4 do
        local name = BWMainWindow.DropDownBox.Tank[i]:GetText()
        if(name and name ~= "<空>") then
            result[i] = name
        end
    end

    return result
end

-- 设置自动监测状态的文字
-- stat: 1 启动状态  0停止状态
function BWMainWindow:SetMonitorStat(stat)
    if(stat == 1)then
        BWMainWindow.Buttons.MonitorButton:SetText("停止自动检查")
        BWMainWindow.frame:SetStatusText("监控状态:启动")
    elseif(stat == 0) then
        BWMainWindow.Buttons.MonitorButton:SetText("开启自动检查")
        BWMainWindow.frame:SetStatusText("监控状态:停止")
    end
end

function BWMainWindow:SetAutoCheckInterval(value)
    if(type(value) ~= "number") then
        return
    end
    BWMainWindow.Config.AutoCheck.IntervalEditBox:SetText(value)
end



function BWMainWindow:RegistButtonCallBack(InitCallback,NotifyCallback,AllocateCallback,CheckCallback,MonitorCallback)
    BWMainWindow.Buttons.RestButton:SetCallback("OnClick", InitCallback)
    BWMainWindow.Buttons.NotifyButton:SetCallback("OnClick", NotifyCallback)
    BWMainWindow.Buttons.AllocateButton:SetCallback("OnClick", AllocateCallback)
    BWMainWindow.Buttons.CheckButton:SetCallback("OnClick", CheckCallback)
    BWMainWindow.Buttons.MonitorButton:SetCallback("OnClick", MonitorCallback)
end

function BWMainWindow:RegistNotifyBoxCallBack(NotifyBoxCallBack)
    BWMainWindow.Config.NotifyCheckbox.RaidBox:SetCallback("OnValueChanged", NotifyBoxCallBack)
    BWMainWindow.Config.NotifyCheckbox.PersonBox:SetCallback("OnValueChanged", NotifyBoxCallBack)
end

function BWMainWindow:RegistAutocheckIntervalEditCallBack(AutocheckIntervalEditCallBack)
    BWMainWindow.Config.AutoCheck.IntervalEditBox:SetCallback("OnEnterPressed", AutocheckIntervalEditCallBack)
end

------------------ Test Function--------------------

function BWMainWindow:TestAddItem()

    -- 以下两种方法都可用

    -- 1 AddItem 方法
    BWMainWindow.DropDownBox.PriestBlood[1]:AddItem(1,"战1")
    BWMainWindow.DropDownBox.PriestBlood[1]:AddItem(2,"战2")

    -- 2 SetList 方法
    --BWMainWindow.DropDownBox.PriestBlood[1]:SetList({
    --    [1] = "战1",
    --    [2] = "战2",
    --    [3] = "战3",
    --    [4] = "战4",
    --})
    --
    --BWMainWindow.DropDownBox.PriestBlood[1]:SetValue(3)
    --
    --message(BWMainWindow.DropDownBox.PriestBlood[1].list[BWMainWindow.DropDownBox.PriestBlood[1]:GetValue(3)])

end

function BWMainWindow:TestSetAllDropDown()
    local data = {
        PRIEST = {[1]="张三",[2]="李四",[3]="王五"},     --牧师
        PALADIN = {[1]="张三",[2]="李四"},     --骑士
        WARLOCK = {[1]="张三丰",[2]="李四"},    --术士
        MAGE = {[1]="张三",[2]="李四四",[3]="王五2"},       --法师
        DRUID = {[1]="张三1",[2]="李四8"},      --德鲁伊
        WARRIOR = {[1]="张三",[2]="李四"}     --战士
    }

    BWMainWindow:SetAllDropDown(data)

end

function BWMainWindow:TestSetOneSureName()
    BWMainWindow:SetOneSureName("PriestBlood",1,"张三")
    BWMainWindow:SetOneSureName("PriestSpirt",2,"李四")
    BWMainWindow:SetOneSureName("MageIntelli",3,"张三3")
    BWMainWindow:SetOneSureName("DruidClaw",4,"张三4")


    BWMainWindow:SetOneSureName("WangZhe",0,"王尼玛")
    BWMainWindow:SetOneSureName("GuangMing",0,"王尼")
    BWMainWindow:SetOneSureName("BiHu",0,"尼玛")
    BWMainWindow:SetOneSureName("LuMang",0,"术士11")
    BWMainWindow:SetOneSureName("AnYing",0,"术士22")

    --message(BWMainWindow.DropDownBox.PriestBlood[1]:GetText())

    local result = BWMainWindow:GetAllAllocation()
    --local str = result["PriestBlood"][1] .. " " .. result["PriestSpirt"][1] .." " ..result["PriestSpirt"][2]
    --if(result["PriestSpirt"][1]) then
    --    message("yes")
    --else
    --    message("no")
    --end

    message(result.Knight.WangZhe)

end