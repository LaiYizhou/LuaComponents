local eventMangerModules = require_ex("luaComponents.event_manager")

local ComponentOwner = DefineClass("ComponentOwner")

function ComponentOwner:ctor()
    self.__components = {}
    self._eventCenter = eventMangerModules.EventManager.new()
end

function ComponentOwner:addComponent(compClass, ...)
    local comp = compClass.new(self, ...)
    self.__components[#self.__components + 1] = comp

    assert(compClass._innerName ~= nil)
    local _innerName = compClass._innerName
    if self[_innerName] ~= nil and self[_innerName] ~= comp then
        error("ComponentContainer:addComponent error. inner name [", _innerName, "] exists on unit", self.id)
    end
    self[compClass._innerName] = comp
end

function ComponentOwner:initAllComponents()
    self:callAllComponentsFunc("_init")
    self:callAllComponentsFunc("setEnable", true)
end

function ComponentOwner:destroy()
    self:inverseCallAllComponentsFunc("setEnable", false)
    self:inverseCallAllComponentsFunc("destroy")
    self.__components = nil
    self._eventCenter:destroy()
end

function ComponentOwner:callAllComponentsFunc(func, ...)
    for i = 1, #self.__components do
        local _comp = self.__components[i]
        local _func = _comp[func]
        if _func then
            _func(_comp, ...)
        end
    end
end

function ComponentOwner:inverseCallAllComponentsFunc(func, ...)
    for i = #self.__components, 1, -1 do
        local _comp = self.__components[i]
        local _func = _comp[func]
        if _func then
            _func(_comp, ...)
        end
    end
end

function ComponentOwner:registerEvent(eventId, listener, functionName)
    self._eventCenter:registerEvent(eventId, listener, functionName)
end

function ComponentOwner:unregisterEvent(eventId, listener)
    self._eventCenter:unregisterEvent(eventId, listener)
end

function ComponentOwner:executeEvent(eventId, ...)
    self._eventCenter:executeEvent(eventId, ...)
end

function ComponentOwner:getComponentDebugInfo()
    local res = "{ "
    for _, component in ipairs(self.__components) do
        res = res .. tostring(component) .. " "
    end
    res = res .. "}"
    return res
end