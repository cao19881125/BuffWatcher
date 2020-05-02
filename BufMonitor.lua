

BufMonitor = {}

local function InArray(array,value)
    if(not array) then
        return false
    end
    for _,v in pairs(array) do
        if(v == value) then
            return true
        end
    end

    return false
end

-- 检查buf
--  allocation_data = {
--    PriestBlood = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    PriestSpirt = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    MageIntelli = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    DruidClaw = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    Knight = {["WangZhe"] = "张三",["ZhengJiu"]="李四",["GuangMing"]="王二",["LiLiang"]="..",["BiHu"] = "..",["ZhiHui"]=".."},
--    Warlock = {["LuMang"] = "..",["YuanSu"] = "..",["YuYan"] = "..",["AnYing"] = ".."}
--  }
--  players = {
--      [1] = {["张三"]=PlayerInfo,["李四"]=PlayerInfo,..}
--      [2] = {["张三"]=PlayerInfo,["李四"]=PlayerInfo,..}
--      ...
--      [8] = {["张三"]=PlayerInfo,["李四"]=PlayerInfo,..}
--  }
--  exception_players = {"张三","李四"}  --剔除名单，在此名单中的玩家不检查
-- return = {
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
--  {
--      需要点掉拯救的坦克列表
--  }

function BufMonitor:BufCheck(allocation_data,players,tanks,exception_players)
    local result = {
        PriestBlood = {},
        PriestSpirt = {},
        MageIntelli = {},
        DruidClaw   = {},
        WangZhe     = {},
        ZhengJiu    = {},
        GuangMing   = {},
        LiLiang     = {},
        BiHu        = {},
        ZhiHui      = {}
    }

    local tankHasZhengJiu = {}
    -- bufid
    -- 耐力:  小耐力：真言术：韧 10938   大耐力：坚韧祷言 21564
    -- 精神： 小精神：神圣之灵  27841    大精神：精神祷言 27681
    -- 智力： 小智力：奥术智慧 10157     大智力：奥术光辉 23028
    -- 爪子： 小爪子：野性印记 9885      大爪子：野性赐福 21850
    -- 王者： 小王者：王者祝福 20217     大王者：强效王者祝福 25898
    -- 力量： 小力量：力量祝福 19838     大力量：强效力量祝福 25782
    -- 拯救： 小拯救：拯救祝福 1038      大拯救：强效拯救祝福 25895
    -- 庇护： 小庇护：庇护祝福 20914     大庇护：强效庇护祝福 25899
    -- 光明： 小光明：光明祝福 19979     大光明：强效光明祝福 25890
    -- 智慧： 小智慧：智慧祝福 19854     大智慧：强效智慧祝福 25894
    local PlayerClassEnum = _G.PlayerClassEnum
    local function checkgroupbuf(buftype,bufid1,bufid2,exception_classs)
        for i = 1,8 do
            if(not result[buftype][i]) then
                result[buftype][i] = {BufPlayer = "",Lacker={}}
            end
            if(buftype == "PriestBlood" or buftype == "PriestSpirt" or buftype == "MageIntelli" or buftype == "DruidClaw") then
                result[buftype][i]["BufPlayer"] = allocation_data[buftype][i]
            else
                result[buftype][i]["BufPlayer"] = allocation_data.Knight[buftype]
            end
            for name,p in pairs(players[i]) do
                if(not InArray(exception_players,name)
                        and not p.isDead
                        and not p.bufs[bufid1]
                        and not p.bufs[bufid2]
                        and not InArray(exception_classs,p.class)
                        and result[buftype][i]["BufPlayer"]) then
                    --local str = "name:"..name .. " buftype:" .. buftype .. " class:"..p.class
                    --DEFAULT_CHAT_FRAME:AddMessage(str)
                    if(buftype == "LiLiang" and p.class == PlayerClassEnum["DRUID"] ) then
                        if(InArray(tanks,name)) then
                            result[buftype][i].Lacker[#result[buftype][i].Lacker + 1] = name
                        end
                    elseif(buftype == "ZhiHui" and p.class == PlayerClassEnum["DRUID"]) then
                        if(not InArray(tanks,name)) then
                            result[buftype][i].Lacker[#result[buftype][i].Lacker + 1] = name
                        end
                    elseif(buftype == "ZhengJiu") then
                        if(not InArray(tanks,name)) then
                            result[buftype][i].Lacker[#result[buftype][i].Lacker + 1] = name
                        end
                    else
                        result[buftype][i].Lacker[#result[buftype][i].Lacker + 1] = name
                    end
                end

                if(buftype == "ZhengJiu"
                        and InArray(tanks,name)
                        and not p.isDead) then
                    if(p.bufs[bufid1] or p.bufs[bufid2]) then
                        table.insert(tankHasZhengJiu,name)
                    end
                end
            end
        end
    end


    -- 检查牧师耐力
    checkgroupbuf("PriestBlood",10938,21564,nil)

    -- 检查牧师精神

    local exception_classs = {PlayerClassEnum["WARRIOR"],PlayerClassEnum["ROGUE"],PlayerClassEnum["HUNTER"]}
    checkgroupbuf("PriestSpirt",27841,27681,exception_classs)

    -- 检查法师智力
    exception_classs = {PlayerClassEnum["WARRIOR"],PlayerClassEnum["ROGUE"]}
    checkgroupbuf("MageIntelli",10157,23028,exception_classs)

    -- 检查小德爪子
    checkgroupbuf("DruidClaw",9885,21850,nil)

    -- 检查王者
    exception_classs = {PlayerClassEnum["SHAMAN"]}
    checkgroupbuf("WangZhe",20217,25898,exception_classs)

    -- 检查力量
    exception_classs = {PlayerClassEnum["MAGE"],PlayerClassEnum["PRIEST"],
                        PlayerClassEnum["WARLOCK"],PlayerClassEnum["HUNTER"],
                        PlayerClassEnum["PALADIN"],PlayerClassEnum["SHAMAN"]}
    checkgroupbuf("LiLiang",19838,25782,exception_classs)

    -- 检查拯救
    exception_classs = {PlayerClassEnum["SHAMAN"]}
    checkgroupbuf("ZhengJiu",1038,25895,exception_classs)

    -- 检查庇护
    exception_classs = {PlayerClassEnum["SHAMAN"]}
    checkgroupbuf("BiHu",20914,25899,exception_classs)

    -- 检查光明
    exception_classs = {PlayerClassEnum["SHAMAN"]}
    checkgroupbuf("GuangMing",19979,25890,exception_classs)

    -- 检查智慧
    exception_classs = {PlayerClassEnum["WARRIOR"],PlayerClassEnum["ROGUE"],PlayerClassEnum["SHAMAN"]}
    checkgroupbuf("ZhiHui",19854,25894,exception_classs)

    return result,tankHasZhengJiu
end

