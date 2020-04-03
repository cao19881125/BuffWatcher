BuffWatcher = LibStub("AceAddon-3.0"):NewAddon("BuffWatcher","AceConsole-3.0","AceComm-3.0", "AceTimer-3.0")


local BuffWatcher = _G.BuffWatcher
local BWMainWindow = _G.BWMainWindow
local RaidInfo = _G.RaidInfo
local PlayerClassEnum = _G.PlayerClassEnum


local CreateFrame = CreateFrame

BuffWatcher.events = CreateFrame("Frame")

BuffWatcher.events:SetScript("OnEvent", function(self, event, ...)
	if not BuffWatcher[event] then
		return
	end

	BuffWatcher[event](BuffWatcher, ...)
end)

function BuffWatcher:OnInitialize()
    BWMainWindow:CreateMainWindow()
	BWMainWindow:RegistButtonCallBack(BuffWatcher.OnInitButtonCallBack,
			BuffWatcher.OnNotifyButtonCallBack,
			BuffWatcher.OnAllocateButtonCallback,
			BuffWatcher.OnMonitorButtonCallback)
    BWMainWindow:Show()
end

function BuffWatcher:OnEnable()

end

function BuffWatcher:OnDisable()

end

function BuffWatcher:InitData()

end

function BuffWatcher:SetMainwindowDropDown()

	local data = {}

	for key,value in pairs(RaidInfo.ByClass) do
		data[key] = {}
		for n,p in pairs(value) do
			data[key][n] = p.name
		end
	end

	BWMainWindow:SetAllDropDown(data)
end

function BuffWatcher:OnInitButtonCallBack()
	DEFAULT_CHAT_FRAME:AddMessage("OnInitButtonCallBack")
	RaidInfo:LoadAllMember()
	--RaidInfo:GenerateTestData()
	BuffWatcher:SetMainwindowDropDown()
end

function BuffWatcher:OnNotifyButtonCallBack()
	DEFAULT_CHAT_FRAME:AddMessage("Hello2")
end

function BuffWatcher:AllocateCaculate(data,pn)

	-- 分配公式为，假设牧师为n个人，则需要8%n个人刷(8/n + 1)个队伍，需要(n - 8%n)个人刷(8/n)个队伍
	local result = {}

	local n = #data
	if(n <= 0) then
		return result
	end
	for i = 1,pn%n do
		for j = 1,(pn/n + 1) do
			result[#result + 1] = data[i].name
		end
	end

	for i = pn%n+1,n do
		for j = 1,pn/n do
			result[#result + 1] = data[i].name
		end
	end

	return result
end

function BuffWatcher:AutoAllocate()
	local result = {
		PriestBlood = {},
		PriestSpirt = {},
		MageIntelli = {},
		DruidClaw = {},
		Knight = {},
		Warlock = {}
	}



	result.PriestBlood = BuffWatcher:AllocateCaculate(RaidInfo.ByClass["PRIEST"],8)
	result.PriestSpirt = BuffWatcher:AllocateCaculate(RaidInfo.ByClass["PRIEST"],8)
	result.MageIntelli = BuffWatcher:AllocateCaculate(RaidInfo.ByClass["MAGE"],8)
	result.DruidClaw = BuffWatcher:AllocateCaculate(RaidInfo.ByClass["DRUID"],8)

	local knight_result = BuffWatcher:AllocateCaculate(RaidInfo.ByClass["PALADIN"],6)
	if (#knight_result > 0) then
		result.Knight["WangZhe"] = knight_result[1]
		result.Knight["ZhengJiu"] = knight_result[2]
		result.Knight["GuangMing"] = knight_result[3]
		result.Knight["LiLiang"] = knight_result[4]
		result.Knight["BiHu"] = knight_result[5]
		result.Knight["ZhiHui"] = knight_result[6]
	end

	local warlock_result = BuffWatcher:AllocateCaculate(RaidInfo.ByClass["WARLOCK"],4)
	if(#warlock_result > 0) then
		result.Warlock["LuMang"] = warlock_result[1]
		result.Warlock["YuanSu"] = warlock_result[2]
		result.Warlock["YuYan"] = warlock_result[3]
		result.Warlock["AnYing"] = warlock_result[4]
	end

	return result
end

function BuffWatcher:OnAllocateButtonCallback()
	DEFAULT_CHAT_FRAME:AddMessage("Hello3")
	local allocate_result = BuffWatcher:AutoAllocate()
	for groupnum,name in pairs(allocate_result.PriestBlood) do
		BWMainWindow:SetOneSureName("PriestBlood",groupnum,name)
	end

	for groupnum,name in pairs(allocate_result.PriestSpirt) do
		BWMainWindow:SetOneSureName("PriestSpirt",groupnum,name)
	end

	for groupnum,name in pairs(allocate_result.MageIntelli) do
		BWMainWindow:SetOneSureName("MageIntelli",groupnum,name)
	end

	for groupnum,name in pairs(allocate_result.DruidClaw) do
		BWMainWindow:SetOneSureName("DruidClaw",groupnum,name)
	end

	for buftype,name in pairs(allocate_result.Knight) do
		BWMainWindow:SetOneSureName(buftype,0,name)
	end

	for buftype,name in pairs(allocate_result.Warlock) do
		BWMainWindow:SetOneSureName(buftype,0,name)
	end
end

function BuffWatcher:OnMonitorButtonCallback()
	DEFAULT_CHAT_FRAME:AddMessage("Hello4")
end

function BuffWatcher:OnMainWindowMoved()
	local point, relativeTo, relativePoint, xOfs, yOfs = BuffWatcher.MainWindow.frame:GetPoint()
	--BWDataBase:SavePosition(point,xOfs,yOfs)
end