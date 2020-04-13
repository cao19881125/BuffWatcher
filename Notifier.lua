
Notifier = {}


--全团通知：
--BufferWatcher插件全团BUF通报:
--耐力: [牧师1 -> 1 2队] [牧师2 -> 3 4队] [牧师3 -> 5 6 7队] [牧师4 -> 8队]
--精神: [牧师1 -> 1 2队] [牧师2 -> 3 4队] [牧师3 -> 5 6 7队] [牧师4 -> 8队]
--智力: [法师1 -> 1 2队] [法师2 -> 3 4队] [法师3 -> 5 6 7队] [法师4 -> 8队]
--爪子: [小德1 -> 1 2队] [小德2 -> 3 4队] [小德3 -> 5 6 7队] [小德4 -> 8队]
--骑士: [骑士1 -> 王者] [骑士2 -> 力量] [骑士3 -> 智慧] [骑士4 -> 拯救] [骑士5 -> 庇护] [骑士6 -> 光明]
--术士: [鲁莽 -> 术士1] [元素 -> 术士2] [语言 -> 术士3] [暗影 -> 术士4]


-- 转换分配结果到以人为key的数据结构
-- allcate_data举例：
-- allcate_data举例 = {
--    PriestBlood = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    PriestSpirt = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    MageIntelli = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    DruidClaw = {[1] = "张三", [2] = "李四",..[8] = "王二"},
--    Knight = {["WangZhe"] = "张三",["ZhengJiu"]="李四",["GuangMing"]="王二",["LiLiang"]="..",["BiHu"] = "..",["ZhiHui"]=".."},
--    Warlock = {["LuMang"] = "..",["YuanSu"] = "..",["YuYan"] = "..",["AnYing"] = ".."}
--  }
-- result举例 = {
--      PriestBlood = {["张三"]={1,2},["李四"]={3,4,5},["王二"]={8}}
--      PriestSpirt = {["张三"]={1,2},["李四"]={3,4,5},["王二"]={8}}
--      MageIntelli = {["张三"]={1,2},["李四"]={3,4,5},["王二"]={8}}
--      DruidClaw   = {["张三"]={1,2},["李四"]={3,4,5},["王二"]={8}}
--      Knight      = {["张三"]={"WangZhe","ZhengJiu"},["李四"]={"GuangMing","力量"},["王二"]={"BiHu","ZhiHui"}}
--      Warlock     = {["张三"]={"LuMang","YuanSu"},["李四"]={"YuYan"},["王二"]={"AnYing"}}
--  }

function Notifier:TransAllocationResultToByName(allcate_data)

    local result = {
        PriestBlood = {},
        PriestSpirt = {},
        MageIntelli = {},
        DruidClaw   = {},
        Knight      = {},
        Warlock     = {}
    }

    for _,buftype in pairs({"PriestBlood","PriestSpirt","MageIntelli","DruidClaw"}) do
        for gn,name in pairs(allcate_data[buftype]) do
            if (not result[buftype][name]) then
                result[buftype][name] = {}
            end
            result[buftype][name][#result[buftype][name] +1] = gn
        end
    end
    for buftype,name in pairs(allcate_data.Knight) do
        if(not result.Knight[name]) then
            result.Knight[name] = {}
        end
        result.Knight[name][#result.Knight[name] + 1] = buftype
    end
    for buftype,name in pairs(allcate_data.Warlock) do
        if(not result.Warlock[name]) then
            result.Warlock[name] = {}
        end
        result.Warlock[name][#result.Warlock[name] + 1] = buftype
    end
    return result
end

function Notifier:NotifyToGrid(allcate_data,raidNotify,personNotify)


    local SendChannel = "RAID"  -- 团队
    --local SendChannel = "GUILD" -- 公会

    local result_by_name = Notifier:TransAllocationResultToByName(allcate_data)

    -- result_by_name的结果是name做key的，按照name排序，这样会出现通报中3队在前1队再后的情况，此函数再纠正一下
    local function resort_by_group(array)
        local result = {}
        for name,groups in pairs(array) do
            if(groups[1])then
                table.insert(result,{["gn"]=groups[1],["name"]=name,["groups"]=groups})
            end
        end
        table.sort(result,function(a,b)
            return a.gn < b.gn
        end)
        return result
    end

    if(raidNotify) then
        _G.SendChatMessage("BufferWatcher插件全团BUF通报:",SendChannel,nil,nil)
    end


    local allbuf = {
        PriestBlood = "耐力精神",
        --PriestSpirt = "精神",
        MageIntelli = "智力",
        DruidClaw   = "爪子",
        Knight      = "骑士",
        Warlock     = "术士"
    }

    local knight_to_cn = {["WangZhe"]="王者",["ZhengJiu"]="拯救",["GuangMing"]="光明",["LiLiang"]="力量",["BiHu"]="庇护",["ZhiHui"]="智慧"}
    local warlock_to_cn = {["LuMang"]="鲁莽",["YuanSu"]="元素",["YuYan"]="语言",["AnYing"]="暗影"}

    for bufe,bufc in pairs(allbuf) do
        local str_to_raid = bufc .. ":"
        local sorted_array = resort_by_group(result_by_name[bufe])
        for _,ngarray in pairs(sorted_array) do
            local name = ngarray["name"]
            local garray = ngarray["groups"]
            local str_to_player = "BufferWatcher插件提示:" .. bufc .. " -> "
            str_to_raid = str_to_raid .. "[" ..name .. " -> "
            for _,gname in pairs(garray) do
                local rgname = ""
                if(bufe == "Knight") then
                    rgname = knight_to_cn[gname]
                elseif(bufe == "Warlock") then
                    rgname = warlock_to_cn[gname]
                else
                    rgname = gname
                end
                str_to_raid = str_to_raid .. rgname .. " "
                str_to_player = str_to_player .. rgname .. " "
            end
            str_to_raid = str_to_raid .. "]"
            --_G.SendChatMessage(str_to_player,"WHISPER",nil,name)
            --_G.SendChatMessage(str_to_player,"SAY",nil,nil)

            str_to_player = str_to_player .. "责任人:" .. name
            if(personNotify) then
                _G.SendChatMessage(str_to_player,"WHISPER",nil,name)
            end
        end

        if(raidNotify) then
            _G.SendChatMessage(str_to_raid,SendChannel,nil,nil)
        end
        --_G.SendChatMessage(str_to_raid,"GUILD",nil,nil)

    end
end

-- 通报buf缺少情况
-- 1. 有对应责任人的，私聊对应责任人
-- 2. 没有责任人的，在全团通报
-- buflack = {
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

function Notifier:NotifyBufLack(buflack,tanks,raidNotify,personNotify)

    local SendChannel = "RAID"  -- 团队
    --local SendChannel = "GUILD" -- 公会

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
        ZhiHui      = "智慧"
    }


    local function in_tanks(name)
        for _,n in pairs(tanks) do
            if(n == name) then
                return true
            end
        end
        return false
    end

    if(raidNotify) then
        _G.SendChatMessage("BufferWatcher插件全团BUF检查:",SendChannel,nil,nil)
    end
    local noProblem = true
    for i =1,8 do
        for bufe,bufc in pairs(bufname_to_cn) do
            while true do
                if (buflack[bufe] and #buflack[bufe][i]["Lacker"] > 0) then
                    local str = "[" .. bufc .. "]" .. " <" .. i .. "队> "
                    local n = 0
                    for _,name in pairs(buflack[bufe][i]["Lacker"]) do
                        if(bufe == "ZhengJiu" and in_tanks(name))then
                            -- 占位符
                        else
                            str = str .. name .. " "
                            n = n+1
                        end

                    end
                    if(n == 0) then
                        break
                    end
                    if(buflack[bufe][i]["BufPlayer"]) then
                        local whisper_str = str .. " 请刷buf"

                        if(personNotify)then
                            _G.SendChatMessage(whisper_str,"WHISPER",nil,buflack[bufe][i]["BufPlayer"])
                        end

                        --测试先发到公会频道
                        str = str .. " *责任人* " .. buflack[bufe][i]["BufPlayer"]
                        if(raidNotify) then
                            _G.SendChatMessage(str,SendChannel,nil,nil)
                        end
                        noProblem = false
                    else
                        --str = str .. " *未指定负责人*"
                        ----_G.SendChatMessage(str,"RAID",nil,nil)
                        --if(raidNotify) then
                        --    _G.SendChatMessage(str,"GUILD",nil,nil)
                        --end
                        --noProblem = false
                    end
                end
                break
            end
        end
    end

    local function in_array(array,name)
        for _,an in pairs(array) do
            if an == name then
                return true
            end
        end

        return false
    end

    for _,name in pairs(tanks) do
        local has_lack = false
        for gn,bufarray in pairs(buflack.ZhengJiu) do
            if(in_array(bufarray["Lacker"],name))then
                has_lack = true
            end
        end

        if(not has_lack)then
            local raidstr = name .. " 请点掉拯救"
            local whisperstr = "BuffWatcher插件提醒:" .. name .. " 请点掉拯救"
            if(raidNotify) then
                _G.SendChatMessage(raidstr,SendChannel,nil,nil)
            end

            if(personNotify)then
                _G.SendChatMessage(whisperstr,"WHISPER",nil,name)
            end

            noProblem = false
        end
    end

    if(noProblem and raidNotify) then
        _G.SendChatMessage("Buff全部正常",SendChannel,nil,nil)
    end


end