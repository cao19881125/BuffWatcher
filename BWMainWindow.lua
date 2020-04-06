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
    }
}

local SCALE_LENGTH = 10


function BWMainWindow:ChangeFontSize(f,size)
    local Font, Height, Flags = f.text:GetFont()
    f.text:SetFont(Font, size, Flags)
end

function BWMainWindow:CreateMainWindow()
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("Buff监控")
    frame:SetLayout("List")
    frame:SetWidth(84*SCALE_LENGTH)
    frame:SetHeight(57*SCALE_LENGTH)
    --frame.frame:SetResizable(false)


    local FlowLayout1 = AceGUI:Create("SimpleGroup")
    FlowLayout1:SetLayout("Flow")
    FlowLayout1:SetWidth(84*SCALE_LENGTH)
    FlowLayout1:SetHeight(40*SCALE_LENGTH)
    frame:AddChild(FlowLayout1)


    local Flow1List1 = AceGUI:Create("SimpleGroup")
    Flow1List1:SetLayout("List")
    Flow1List1:SetWidth(32*SCALE_LENGTH)
    Flow1List1:SetHeight(40*SCALE_LENGTH)
    FlowLayout1:AddChild(Flow1List1)

    -- 牧师耐力
    local PriestBloodGroup,dropdownarray = BWMainWindow:CreateBufGroup("耐力")
    Flow1List1:AddChild(PriestBloodGroup)
    BWMainWindow.DropDownBox["PriestBlood"] = dropdownarray

    -- 牧师精神
    local PriestSpirtGroup,dropdownarray = BWMainWindow:CreateBufGroup("精神")
    Flow1List1:AddChild(PriestSpirtGroup)
    BWMainWindow.DropDownBox["PriestSpirt"] = dropdownarray



    local Flow1List2 = AceGUI:Create("SimpleGroup")
    Flow1List2:SetLayout("List")
    Flow1List2:SetWidth(32*SCALE_LENGTH)
    Flow1List2:SetHeight(40*SCALE_LENGTH)
    FlowLayout1:AddChild(Flow1List2)

    -- 法师智力
    local MageIntelliGroup,dropdownarray = BWMainWindow:CreateBufGroup("智力")
    Flow1List2:AddChild(MageIntelliGroup)
    BWMainWindow.DropDownBox["MageIntelli"] = dropdownarray

    -- 小德爪子
    local DruidClawGroup,dropdownarray = BWMainWindow:CreateBufGroup("爪子")
    Flow1List2:AddChild(DruidClawGroup)
    BWMainWindow.DropDownBox["DruidClaw"] = dropdownarray

    -- 骑士buf
    local KnightGroup,dropdownarray = BWMainWindow:CreateKnightBufGroup()
    FlowLayout1:AddChild(KnightGroup)
    BWMainWindow.DropDownBox["Knight"] = dropdownarray


    local FlowLayout2 = AceGUI:Create("SimpleGroup")
    FlowLayout2:SetLayout("Flow")
    FlowLayout2:SetWidth(84*SCALE_LENGTH)
    FlowLayout2:SetHeight(20*SCALE_LENGTH)
    frame:AddChild(FlowLayout2)

    local Flow2List1 = AceGUI:Create("SimpleGroup")
    Flow2List1:SetLayout("List")
    Flow2List1:SetWidth(32*SCALE_LENGTH)
    Flow2List1:SetHeight(20*SCALE_LENGTH)
    FlowLayout2:AddChild(Flow2List1)

    local WarlockGroup,dropdownarray = BWMainWindow:CreateWarlockGroup()
    Flow2List1:AddChild(WarlockGroup)
    BWMainWindow.DropDownBox["Warlock"] = dropdownarray

    local Flow2List2 = AceGUI:Create("SimpleGroup")
    Flow2List2:SetLayout("List")
    Flow2List2:SetWidth(32*SCALE_LENGTH)
    Flow2List2:SetHeight(20*SCALE_LENGTH)
    FlowLayout2:AddChild(Flow2List2)

    local TankGroup,dropdownarray = BWMainWindow:CreateTankGroup()
    Flow2List2:AddChild(TankGroup)
    BWMainWindow.DropDownBox["Tank"] = dropdownarray

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
    BloodGroup:SetHeight(20*SCALE_LENGTH)

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
    OneGroupDropDown:SetWidth(15*SCALE_LENGTH)
    OneGroupDropDown:SetHeight(SCALE_LENGTH)
    OneTwoGroup:AddChild(OneGroupDropDown)

    local TwoGroupDropDown = AceGUI:Create("Dropdown2")
    TwoGroupDropDown:SetLabel(label2)
    TwoGroupDropDown:SetWidth(15*SCALE_LENGTH)
    TwoGroupDropDown:SetHeight(SCALE_LENGTH)
    OneTwoGroup:AddChild(TwoGroupDropDown)

    return OneTwoGroup,OneGroupDropDown,TwoGroupDropDown
end

function BWMainWindow:CreateKnightBufGroup()
    local KnightGroup = AceGUI:Create("InlineGroup")
    KnightGroup:SetLayout("List")
    KnightGroup:SetTitle("骑士")
    KnightGroup:SetWidth(15*SCALE_LENGTH)
    KnightGroup:SetHeight(40*SCALE_LENGTH)

    local DropdownArray = {}

    local WangZheDropDown = AceGUI:Create("Dropdown2")
    WangZheDropDown:SetLabel("王者")
    WangZheDropDown:SetWidth(15*SCALE_LENGTH)
    WangZheDropDown:SetHeight(5*SCALE_LENGTH)
    --WangZheDropDown:SetText("MAGE11")
    --BWMainWindow:ChangeFontSize(WangZheDropDown,10)
    KnightGroup:AddChild(WangZheDropDown)
    DropdownArray["WangZhe"] = WangZheDropDown

    local ZhengJiuDropDown = AceGUI:Create("Dropdown2")
    ZhengJiuDropDown:SetLabel("拯救")
    ZhengJiuDropDown:SetWidth(15*SCALE_LENGTH)
    ZhengJiuDropDown:SetHeight(5*SCALE_LENGTH)
    KnightGroup:AddChild(ZhengJiuDropDown)
    DropdownArray["ZhengJiu"] = ZhengJiuDropDown

    local GuangMingDropDown = AceGUI:Create("Dropdown2")
    GuangMingDropDown:SetLabel("光明")
    GuangMingDropDown:SetWidth(15*SCALE_LENGTH)
    GuangMingDropDown:SetHeight(5*SCALE_LENGTH)
    KnightGroup:AddChild(GuangMingDropDown)
    DropdownArray["GuangMing"] = GuangMingDropDown

    local LiLiangDropDown = AceGUI:Create("Dropdown2")
    LiLiangDropDown:SetLabel("力量")
    LiLiangDropDown:SetWidth(15*SCALE_LENGTH)
    LiLiangDropDown:SetHeight(5*SCALE_LENGTH)
    KnightGroup:AddChild(LiLiangDropDown)
    DropdownArray["LiLiang"] = LiLiangDropDown

    local ZhiHuiDropDown = AceGUI:Create("Dropdown2")
    ZhiHuiDropDown:SetLabel("智慧")
    ZhiHuiDropDown:SetWidth(15*SCALE_LENGTH)
    ZhiHuiDropDown:SetHeight(5*SCALE_LENGTH)
    KnightGroup:AddChild(ZhiHuiDropDown)
    DropdownArray["ZhiHui"] = ZhiHuiDropDown

    local BiHuDropDown = AceGUI:Create("Dropdown2")
    BiHuDropDown:SetLabel("庇护")
    BiHuDropDown:SetWidth(15*SCALE_LENGTH)
    BiHuDropDown:SetHeight(5*SCALE_LENGTH)
    KnightGroup:AddChild(BiHuDropDown)
    DropdownArray["BiHu"] = BiHuDropDown

    return KnightGroup,DropdownArray
end

function BWMainWindow:CreateWarlockGroup()
    local WarlockGroup = AceGUI:Create("InlineGroup")
    WarlockGroup:SetLayout("List")
    WarlockGroup:SetTitle("术士")
    WarlockGroup:SetWidth(32*SCALE_LENGTH)
    WarlockGroup:SetHeight(20*SCALE_LENGTH)

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

function BWMainWindow:CreateButtonGroup()
    local ButtonGroup = AceGUI:Create("SimpleGroup")
    ButtonGroup:SetLayout("Flow")
    ButtonGroup:SetWidth(84*SCALE_LENGTH)
    ButtonGroup:SetHeight(10*SCALE_LENGTH)

    local SpaceLabel = AceGUI:Create("Label")
    SpaceLabel:SetText("  ")
    SpaceLabel:SetWidth(30*SCALE_LENGTH)
    ButtonGroup:AddChild(SpaceLabel)


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

    local CheckButton = AceGUI:Create("Button")
    CheckButton:SetText("检查")
    CheckButton:SetWidth(10*SCALE_LENGTH)
    ButtonGroup:AddChild(CheckButton)
    BWMainWindow.Buttons.CheckButton = CheckButton


    local MonitorButton = AceGUI:Create("Button")
    MonitorButton:SetText("开启监测")
    MonitorButton:SetWidth(10*SCALE_LENGTH)
    ButtonGroup:AddChild(MonitorButton)
    BWMainWindow.Buttons.MonitorButton = MonitorButton

    return ButtonGroup
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

    -- 设置牧师，法师，小德列表
    for i =1,8 do
        BWMainWindow.DropDownBox.PriestBlood[i]:SetList(data["PRIEST"])
        BWMainWindow.DropDownBox.PriestSpirt[i]:SetList(data["PRIEST"])
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
--      PriestBlood:牧师耐力 PriestSpirt:牧师精神 MageIntelli:法师智力 DruidClaw:小德爪子
--      WangZhe:骑士王者 ZhengJiu:骑士拯救 GuangMing:骑士光明 LiLiang:骑士力量 BiHu:骑士庇护 ZhiHui:骑士智慧
--      LuMang:术士鲁莽  YuanSu:术士元素 YuYan:术士语言 AnYing:术士暗影
-- groupnum:小队  骑士和术士不需要设置
-- name:刷buf的责任人
function BWMainWindow:SetOneSureName(buftype,groupnum,name)
    if(buftype == "PriestBlood" or buftype == "PriestSpirt"
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
        result["PriestSpirt"][i] = BWMainWindow.DropDownBox.PriestSpirt[i]:GetText()
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
        result[i] = BWMainWindow.DropDownBox.Tank[i]:GetText()
    end

    return result
end


function BWMainWindow:RegistButtonCallBack(InitCallback,NotifyCallback,AllocateCallback,CheckCallback,MonitorCallback)
    BWMainWindow.Buttons.RestButton:SetCallback("OnClick", InitCallback)
    BWMainWindow.Buttons.NotifyButton:SetCallback("OnClick", NotifyCallback)
    BWMainWindow.Buttons.AllocateButton:SetCallback("OnClick", AllocateCallback)
    BWMainWindow.Buttons.CheckButton:SetCallback("OnClick", CheckCallback)
    BWMainWindow.Buttons.MonitorButton:SetCallback("OnClick", MonitorCallback)
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