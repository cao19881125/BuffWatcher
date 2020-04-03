
PlayerInfo = {}

PlayerClassEnum = {
    WARRIOR=1,      --战士
    ROGUE=2,          --盗贼
    MAGE=3,            --法师
    PRIEST=4,        --牧师
    WARLOCK=5,      --术士
    HUNTER=6,        --猎人
    SHAMAN=7,        --萨满
    DRUID=8,          --德鲁伊
    PALADIN=9       --圣骑士
}

function PlayerInfo:new(name,subgroup,class)
    local o ={
        name = name,
        subgroup = subgroup,
        class = class
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

GroupInfo = {}

function GroupInfo:new()
    local o = {
        subnum = 0,
        players = {}
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

RaidInfo = {
    ByGroup = {},
    ByClass = {}
}


function RaidInfo:LoadAllMember()


    --local max_group_num = 0
    --if(IsInRaid())then
    --    max_group_num = 8
    --else
    --    max_group_num = 1
    --end

    for i=1,8 do
        RaidInfo.ByGroup[i] = GroupInfo:new()
        RaidInfo.ByGroup[i].subnum = i
    end

    for key,value in pairs(PlayerClassEnum) do
        RaidInfo.ByClass[key] = {}
    end
    for i = 1,40 do
        local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
        if(name)then
            local p = PlayerInfo:new(name,subgroup,PlayerClassEnum[class])
            RaidInfo.ByGroup[subgroup].players[name] = p
            RaidInfo.ByClass[class][#RaidInfo.ByClass[class] + 1] = p
        end
    end

end

function RaidInfo:GenerateTestData()
    for i=1,8 do
        RaidInfo.ByGroup[i] = GroupInfo:new()
        RaidInfo.ByGroup[i].subnum = i
    end
    for key,value in pairs(PlayerClassEnum) do
        RaidInfo.ByClass[key] = {}
    end

    for i=1,5 do
        for key,value in pairs(PlayerClassEnum) do
            local p = PlayerInfo:new(key..i,i,value)
            RaidInfo.ByGroup[i].players[key..i] = p
            RaidInfo.ByClass[key][i] = p
        end
    end
end