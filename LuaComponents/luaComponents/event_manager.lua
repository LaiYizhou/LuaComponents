local eventConst = require_ex("luaComponents.event_const")

local EventManager = DefineClass("EventManager")

function EventManager:ctor()
    self.eventListeners= {} -- {eventId -> {listener -> functionName} }
    self.callLayer = 0
    self.eventsToBeRemoved = {} -- {eventId -> {listener -> true} }
end

function EventManager:destroy()
    self.eventListeners = nil
    self.callLayer = 0
    self.eventsToBeRemoved = nil
end

function EventManager:registerEvent(eventId, listener, functionName)
    local funcs = self.eventListeners[eventId] or {}
    if funcs[listener] ~= nil then
        error("EventManager:registerEventListener already registered", eventId)
    end
    funcs[listener] = functionName
    self.eventListeners[eventId] = funcs
end

function EventManager:unregisterEvent(eventId, listener)
    if self.callLayer > 0 then
        local toBeRemoved = self.eventsToBeRemoved[eventId]
        toBeRemoved = toBeRemoved or {}
        toBeRemoved[listener] = true
        self.eventsToBeRemoved[eventId] = toBeRemoved
    else
        self:_realRemoveEventListener(eventId, listener)
    end
end

function EventManager:executeEvent(eventId, ...)
    self.callLayer = self.callLayer + 1
    if self.callLayer > 10 then
        error("event_manager.executeEvent recursive", eventId)
        self.callLayer = self.callLayer - 1
        return
    end
    local funcs = self.eventListeners[eventId] or {}
    for listener, funcName in pairs(funcs) do
        local removeEventFunc = self.eventsToBeRemoved[eventId]
        -- 如果excute执行过程中删掉了, 就不再执行了
        if funcName and not(removeEventFunc and removeEventFunc[listener]) then
            local func = listener[funcName]
            if func ~= nil then
                func(listener, ...)
            end
        end
    end
    self.callLayer = self.callLayer - 1
    if self.callLayer == 0 then
        self:_innerRemoveEventListener()
    end
end

function EventManager:_realRemoveEventListener(eventId, listener)
    local funcs = self.eventListeners[eventId] or {}
    if next(funcs) == nil then
        return
    end
    funcs[listener] = nil
end

function EventManager:_innerRemoveEventListener()
    if next(self.eventsToBeRemoved) then
        for eventId, toBeRemoved in pairs(self.eventsToBeRemoved) do
            if next(toBeRemoved) then
                for listener, _ in pairs(toBeRemoved) do
                    self:_realRemoveEventListener(eventId, listener)
                end
            end
        end
        self.eventsToBeRemoved = {}
    end
end