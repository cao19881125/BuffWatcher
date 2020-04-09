local AceGUI = LibStub("AceGUI-3.0")

BWCheckPlayerWindow = {
    PartyCheckBox = {

    }
}



local SCALE_LENGTH = 10

function ChangeFontSize(fontString,size)
    local Font, Height, Flags = fontString:GetFont()
    fontString:SetFont(Font, size, Flags)
end


function BWCheckPlayerWindow:CreateWindow()
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("检查玩家设置")
    frame:SetLayout("List")
    frame:SetWidth(52*SCALE_LENGTH)
    frame:SetHeight(58*SCALE_LENGTH)

    local FlowLayout1 = AceGUI:Create("SimpleGroup")
    FlowLayout1:SetLayout("Flow")
    FlowLayout1:SetWidth(52*SCALE_LENGTH)
    FlowLayout1:SetHeight(20*SCALE_LENGTH)
    frame:AddChild(FlowLayout1)

    for i = 1,4 do
        local partyGroup = BWCheckPlayerWindow:CreatePartyGroup(i)
        FlowLayout1:AddChild(partyGroup)
    end

    local FlowLayout2 = AceGUI:Create("SimpleGroup")
    FlowLayout2:SetLayout("Flow")
    FlowLayout2:SetWidth(52*SCALE_LENGTH)
    FlowLayout2:SetHeight(20*SCALE_LENGTH)
    frame:AddChild(FlowLayout2)

    for i = 5,8 do
        local partyGroup = BWCheckPlayerWindow:CreatePartyGroup(i)
        FlowLayout2:AddChild(partyGroup)
    end

    BWCheckPlayerWindow.frame = frame
end

function BWCheckPlayerWindow:CreatePartyGroup(partyId)

    BWCheckPlayerWindow.PartyCheckBox[partyId] = {}

    local PartyGroup = AceGUI:Create("InlineGroup")
    PartyGroup:SetLayout("Flow")
    PartyGroup:SetTitle(partyId .. "队")
    PartyGroup:SetWidth(12*SCALE_LENGTH)
    PartyGroup:SetHeight(20*SCALE_LENGTH)

    for i = 1,5 do
        local tmpCheckBox = AceGUI:Create("CheckBox")
        tmpCheckBox:SetLabel("<空>")
        tmpCheckBox:SetWidth(12*SCALE_LENGTH)
        tmpCheckBox:SetHeight(4*SCALE_LENGTH)
        ChangeFontSize(tmpCheckBox.text,10)
        PartyGroup:AddChild(tmpCheckBox)
        BWCheckPlayerWindow.PartyCheckBox[partyId][i] = tmpCheckBox
    end

    return PartyGroup
end


function BWCheckPlayerWindow:Show()
    BWCheckPlayerWindow.frame:Show()
end

function BWCheckPlayerWindow:Hide()
    BWCheckPlayerWindow.frame:Hide()
end

-- 设置所有checkbox的name
--partyArray = {
--    [1] = {"P1","P2","P3"},
--    [2] = {"P1","P2","P3","P4"},
--    ...
--    [8]
--}
function BWCheckPlayerWindow:SetPartyNames(partyArray)
    for i = 1,8 do
        for j = 1,5 do
            if(partyArray[i] and partyArray[i][j]) then
                BWCheckPlayerWindow.PartyCheckBox[i][j]:SetLabel(partyArray[i][j])
                BWCheckPlayerWindow.PartyCheckBox[i][j]:SetValue(true)
            else
                BWCheckPlayerWindow.PartyCheckBox[i][j]:SetLabel("<空>")
            end
        end
    end

end

-- 返回不需要检查的名单
-- return = {"P1","P2","P3"}
function BWCheckPlayerWindow:GetExceptionPlayers()
    local result = {}

    for i = 1,8 do
        for j = 1,5 do
            local checked = BWCheckPlayerWindow.PartyCheckBox[i][j]:GetValue()
            if(not checked) then
                local name = BWCheckPlayerWindow.PartyCheckBox[i][j].text:GetText()
                if(name ~= "<空>") then
                    table.insert(result,name)
                end
            end
        end
    end

    return result
end