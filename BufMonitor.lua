

BufMonitor = {}



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
-- return = {
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
--  }

function BufMonitor:BufCheck(allocation_data,players)
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
    -- 智慧： 小智慧：智慧祝福 19854     大智慧：强效智慧祝福 25918

    local function checkgroupbuf(buftype,bufid1,bufid2)
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
                if(not p.bufs[bufid1] and not p.bufs[bufid2]) then
                    result[buftype][i].Lacker[#result[buftype][i].Lacker + 1] = name
                end
            end
        end
    end


    -- 检查牧师耐力
    checkgroupbuf("PriestBlood",10938,21564)
    DEFAULT_CHAT_FRAME:AddMessage(result["PriestBlood"][1].Lacker[1])

    -- 检查牧师精神
    checkgroupbuf("PriestSpirt",27841,27681)

    -- 检查法师智力
    checkgroupbuf("MageIntelli",10157,23028)

    -- 检查小德爪子
    checkgroupbuf("DruidClaw",9885,21850)

    -- 检查王者
    checkgroupbuf("WangZhe",20217,25898)

    -- 检查力量
    checkgroupbuf("LiLiang",19838,25782)

    -- 检查拯救
    checkgroupbuf("ZhengJiu",1038,25895)

    -- 检查庇护
    checkgroupbuf("BiHu",20914,25899)

    -- 检查光明
    checkgroupbuf("GuangMing",19979,25890)

    -- 检查智慧
    checkgroupbuf("ZhiHui",19854,25918)

    return result
end

