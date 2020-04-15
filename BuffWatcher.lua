BuffWatcher = LibStub("AceAddon-3.0"):NewAddon("BuffWatcher","AceConsole-3.0","AceComm-3.0", "AceTimer-3.0")


local BuffWatcher = _G.BuffWatcher
local BWMainWindow = _G.BWMainWindow
local BWCheckPlayerWindow = _G.BWCheckPlayerWindow
local RaidInfo = _G.RaidInfo
local PlayerClassEnum = _G.PlayerClassEnum
local Notifier = _G.Notifier
local BufMonitor = _G.BufMonitor

local CreateFrame = CreateFrame

local MonitorStat = 0  -- 自动监控状态，0 表示停止状态  1 表示启动状态
local last_update_time = GetTime()

BuffWatcher.events = CreateFrame("Frame")

local Default_Profile = {
    profile = {
        MainWindow = {
            Position = {
				point = "CENTER",
                x = 0,
                y = 0
			},
			NotifyBox = {
				RaidNotify = true,
				PersonNotify = false
			},
			AutoCheck = {
				Interval = 30
			}
        }
    }
}

BuffWatcher.events:SetScript("OnEvent", function(self, event, ...)
	if not BuffWatcher[event] then
		return
	end

	BuffWatcher[event](BuffWatcher, ...)
end)


function BuffWatcher:OnInitialize()
	local acedb = LibStub("AceDB-3.0")
	BWMainWindow.db = acedb:New("BuffWatcherDB",Default_Profile)

    BWMainWindow:CreateMainWindow()
	BWCheckPlayerWindow:CreateWindow()

    BWMainWindow:RegistButtonCallBack(BuffWatcher.OnInitButtonCallBack,
			BuffWatcher.OnNotifyButtonCallBack,
			BuffWatcher.OnAllocateButtonCallback,
			BuffWatcher.OnCheckButtonCallback,
			BuffWatcher.OnMonitorButtonCallback)
	BWMainWindow:RegistNotifyBoxCallBack(BuffWatcher.OnNotifyBoxCallBack)
	BWMainWindow:RegistAutocheckIntervalEditCallBack(BuffWatcher.OnAutocheckIntervalEditCallBack)
	BWMainWindow:SetNotifyInfo(BWMainWindow.db.profile.MainWindow.NotifyBox.RaidNotify,BWMainWindow.db.profile.MainWindow.NotifyBox.PersonNotify)
	BWMainWindow:SetAutoCheckInterval(BWMainWindow.db.profile.MainWindow.AutoCheck.Interval)
    BWMainWindow:Hide()
	BWCheckPlayerWindow:Hide()
	BuffWatcher.events:SetScript("OnUpdate",BuffWatcher.OnUpdate)
end

function BuffWatcher:SetupMinimapBtn()
	local LDB = LibStub("LibDataBroker-1.1", true)
	local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)

	local BufferWatcherMinimapBtn = LDB:NewDataObject("BuffWatcher", {
            type = "launcher",
			text = "BuffWatcher",
            icon = "Interface/Icons/ability_ambush.blp",
            OnClick = function(_, button)
                if button == "LeftButton" then
					BWMainWindow:Show()
				end
            end,
            OnTooltipShow = function(tt)
                tt:AddLine("BuffWatcher")
                tt:AddLine("自动分配全团buf，自动检测缺buf情况")
            end,
        })
	local btnpos = {}
	if LDBIcon then
            LDBIcon:Register("BuffWatcher", BufferWatcherMinimapBtn, btnpos)
	end
end

function BuffWatcher:OnEnable()

	BuffWatcher:SetupMinimapBtn()

end

function BuffWatcher:OnDisable()

end

function BuffWatcher:InitData()

end

function BuffWatcher:OnUpdate()
	if(MonitorStat ~= 1)then
		return
	end

	local current_time = GetTime()

	if((current_time - last_update_time) < BWMainWindow.db.profile.MainWindow.AutoCheck.Interval ) then
        return
    end

	BuffWatcher:OnCheckButtonCallback()

	last_update_time = current_time

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

function BuffWatcher:SetCheckPlayerWindow()
	local partyArray = {}

	for gn,narray in pairs(RaidInfo.ByGroup) do
		partyArray[gn] = {}
		for name,_ in pairs(narray.players) do
			table.insert(partyArray[gn],name)
		end
	end

	BWCheckPlayerWindow:SetPartyNames(partyArray)
end

function BuffWatcher:OnInitButtonCallBack()
	--DEFAULT_CHAT_FRAME:AddMessage("OnInitButtonCallBack")
	RaidInfo:LoadAllMember()
	--RaidInfo:GenerateTestData()
	BuffWatcher:SetCheckPlayerWindow()
	BuffWatcher:SetMainwindowDropDown()
end

function BuffWatcher:OnNotifyButtonCallBack()
	--DEFAULT_CHAT_FRAME:AddMessage("Hello2")

	local allocate_result = BWMainWindow:GetAllAllocation()
	local raidNotify,personNotify = BWMainWindow:GetNotifyInfo()
	Notifier:NotifyToGrid(allocate_result,raidNotify,personNotify)

end

function BuffWatcher:OnCheckButtonCallback()
	BuffWatcher:CheckoutBuf()
end

function BuffWatcher:CheckoutBuf()

	RaidInfo:LoadAllMember()
	--RaidInfo:GenerateTestData()
	local allocation_data = BWMainWindow.GetAllAllocation()
	local players = {}
	for gn,gp in pairs(RaidInfo.ByGroup) do
		players[gn] = gp.players
	end
	local tanks = BWMainWindow:GetTankAllocation()
	local exception_players = BWCheckPlayerWindow:GetExceptionPlayers()
	local buflack = BufMonitor:BufCheck(allocation_data,players,tanks,exception_players)
	--DEFAULT_CHAT_FRAME:AddMessage(buflack["PriestBlood"][1].Lacker[1])

	local raidNotify,personNotify = BWMainWindow:GetNotifyInfo()
	Notifier:NotifyBufLack(buflack,tanks,raidNotify,personNotify)
end

function BuffWatcher:OnNotifyBoxCallBack(value)
	local raidNotify,personNotify = BWMainWindow:GetNotifyInfo()
	BWMainWindow.db.profile.MainWindow.NotifyBox.RaidNotify = raidNotify
	BWMainWindow.db.profile.MainWindow.NotifyBox.PersonNotify = personNotify
end

function BuffWatcher:OnAutocheckIntervalEditCallBack()
	local value = BWMainWindow:GetAutocheckIntervalEditText()
	local nv = tonumber(value)
	if(nv) then
		BWMainWindow.db.profile.MainWindow.AutoCheck.Interval = nv
	end
end

function BuffWatcher:AllocateCaculate(data,pn)

	-- 分配公式为，假设牧师为n个人，则需要8%n个人刷(8/n + 1)个队伍，需要(n - 8%n)个人刷(8/n)个队伍
	local result = {}

	if(not data) then
		return result
	end

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
	result.PriestSpirt = result.PriestBlood
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
	local allocate_result = BuffWatcher:AutoAllocate()
	for groupnum,name in pairs(allocate_result.PriestBlood) do
		BWMainWindow:SetOneSureName("PriestBlood",groupnum,name)
	end

	--for groupnum,name in pairs(allocate_result.PriestSpirt) do
	--	BWMainWindow:SetOneSureName("PriestSpirt",groupnum,name)
	--end

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
	if(MonitorStat == 0) then
		MonitorStat = 1
	elseif(MonitorStat == 1) then
		MonitorStat = 0
	end
	BWMainWindow:SetMonitorStat(MonitorStat)
end

function BuffWatcher:OnMainWindowMoved()
	local point, relativeTo, relativePoint, xOfs, yOfs = BuffWatcher.MainWindow.frame:GetPoint()
	--BWDataBase:SavePosition(point,xOfs,yOfs)
end