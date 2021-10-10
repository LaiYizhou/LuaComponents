-- OrderedTable 按照key进行排序，ipairs或者pairs时的遍历顺序都按照key从小到大的顺序
-- 虽然使用了二分查找，但是在插入或者删除时因为有对于数组的操作，因此时间复杂度依然是O(n)。
-- 可以考虑使用红黑树来实现更高效的数据结构。
-- 注意：遍历过程中如果有插入或者删除操作，则可能会导致不确定的逻辑错误（比如被遍历多次，或者遗漏遍历）。
-- 性能和实用性考虑，目前未支持自定义比较函数。
-- @Author dongxi

local ceil = math.ceil
local tinsert, tremove = table.insert, table.remove

-- 二分查找函数
local function bsearch(t,v)
    local left = 1;
    local right = #t
    local mid = ceil((left + right)/2)
    while left ~= mid do
        if t[mid] == v then
            break;
        elseif t[mid] < v then
            left = mid + 1
        else
            right = mid -1
        end

        mid = ceil((left + right)/2)
    end
    return mid, t[mid]
end

local ParisIterCache = {}
ParisIterCache.cache = {}

local pairsIterMt = {}
function pairsIterMt.__call(tbl, iterTbl, key)
    while true  do
        tbl.curIndex = tbl.curIndex + 1
        local k = iterTbl._keys[tbl.curIndex]
        local v = nil
        if k ~= nil then
            v = iterTbl._values[k]
        end
        if nil~=v then
            return k, v
        elseif k ~= nil and not v then
        else
            -- 这里如果在for循环中被break，会有不返回给池子的情况，但是应该会被GC处理
            -- 如果要优化，可以处理的方式是假设paris的操作在一帧内完成，那么分配出去的迭代器也由cache管理，在帧结束做统一的回收。
            ParisIterCache:releaseIter(tbl)
            return
        end
    end
end


function ParisIterCache:fetchIter()
    if #self.cache == 0 then
        local instance = {curIndex = 0}
        setmetatable(instance, pairsIterMt)
        return instance
    else
        return tremove(self.cache)
    end
end

function ParisIterCache:releaseIter(iter)
    iter.curIndex = 0
    tinsert(self.cache, iter)
end


local mt = {
}

function mt.__index(tbl, key)
    local vals = tbl._values
    return vals[key]
end

function mt.__newindex(tbl, key, value)
    local vals = tbl._values
    local keys = tbl._keys
    if vals[key] ~= nil then
        if value == nil then
            -- 元素存在，但是设置值为nil，表示要删除
            local idx = bsearch(keys, key)
            tremove(keys, idx)
        end
    else
        if value ~= nil then
            -- 元素原本不存在，同时不是删除，则要添加key
            local idx, ret = bsearch(keys, key)
            if ret and ret < key then
                idx = idx + 1
            end
            tinsert(keys, idx, key)
        end
    end
    vals[key] = value
end

local function stateless_iter(iterTbl, i)
    i = i + 1
    local k = iterTbl._keys[i]
    local v = nil
    if k ~= nil then
        v = iterTbl._values[k]
    end
    if nil~=v then return i, v end
  end

function mt.__ipairs(tbl)
      return stateless_iter, tbl, 0
end

function mt.__pairs(tbl)
    return ParisIterCache:fetchIter(), tbl, nil
end

local OrderedTable = {}
function OrderedTable.new()
    local instance = {}
    instance._keys = {}
    instance._values = {}
    instance.__cname = "OrderedTable"
    setmetatable(instance, mt)
    return instance
end

function OrderedTable.count(tbl)
    return #tbl._keys
end

---@class OrderedTable
return OrderedTable