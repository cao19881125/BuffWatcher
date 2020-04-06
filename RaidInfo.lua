
PlayerInfo = {}

PlayerClassEnum = {
    WARRIOR=1,      --战士
    ROGUE=2,          --盗贼
    MAGE=3,            --法师
    PRIEST=4,        --牧师
    WARLOCK=5,      --术士
    HUNTER=6,        --猎人
    --SHAMAN=7,        --萨满
    DRUID=8,          --德鲁伊
    PALADIN=9       --圣骑士
}

function PlayerInfo:new(name,subgroup,class)
    local o ={
        name = name,
        subgroup = subgroup,
        class = class,
        bufs = {} -- buf table,保存格式 {[10157]="奥术智慧",[10220]="冰甲术"}
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

            for j=1,40 do
                local name,_,_,_,_,_,_,_,_,spellId = UnitBuff("raid"..i,j)
                if(name) then
                    p.bufs[#p.bufs + 1] = spellId
                end
            end

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

    local function get_all_buf()
        return {
            [21564] = "坚韧祷言",
            [27681] = "精神祷言",
            [23028] = "奥术光辉",
            [21850] = "野性赐福",
            [25898] = "强效王者祝福",
            [25782] = "强效力量祝福",
            [25895] = "强效拯救祝福",
            [25899] = "强效庇护祝福",
            [25890] = "强效光明祝福",
            [25918] = "强效智慧祝福"
        }
    end

    local play_class = {  "WARRIOR","ROGUE","MAGE","PRIEST","WARLOCK", "HUNTER","DRUID","PALADIN"  }

    for i = 1,40 do

        local pc = play_class[math.fmod((i - 1),8) + 1]


        local groupid = math.modf((i - 1)/5) + 1

        local p = PlayerInfo:new(pc..i,groupid,PlayerClassEnum[pc])
        p.bufs = get_all_buf()
        RaidInfo.ByGroup[groupid].players[pc..i] = p
        RaidInfo.ByClass[pc][#RaidInfo.ByClass[pc] + 1] = p
    end



    RaidInfo.ByClass["WARRIOR"][1].bufs[25895] = nil
    RaidInfo.ByClass["ROGUE"][1].bufs[25895] = nil
    --RaidInfo.ByClass["HUNTER"][2].bufs[27681] = nil
    --RaidInfo.ByClass["WARLOCK"][3].bufs[25898] = nil

end



