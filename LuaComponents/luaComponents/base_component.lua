local BaseComponent = DefineClass("BaseComponent")

function BaseComponent:ctor(owner)
    assert(self._innerName ~= nil)
    self.owner = owner

    self.__enable = false
end

-- 此时单位身上的其他组件对象都已经有了
function BaseComponent:_init()
    print(string.format("%s _init()", self._innerName))
end

function BaseComponent:_onEnable()
    print(string.format("%s _onEnable()", self._innerName))
end

function BaseComponent:_onDisable()
    print(string.format("%s _onDisable()", self._innerName))
end

function BaseComponent:isEnable()
    return self.__enable
end

function BaseComponent:setEnable(enable)
    if self.__enable ~= enable then
        self.__enable = enable
        if enable then
            self:_onEnable()
        else
            self:_onDisable()
        end
    end
end

function BaseComponent:registerEvent(eventId, listener, functionName)
    self.owner:registerEvent(eventId, listener, functionName)
end

function BaseComponent:unregisterEvent(eventId, listener)
    self.owner:unregisterEvent(eventId, listener)
end

function BaseComponent:executeEvent(eventId, ...)
    self.owner:executeEvent(eventId, ...)
end

function BaseComponent:destroy()
    print(string.format("%s destroy()", self._innerName))
    self.owner[self._innerName] = nil
end

function BaseComponent:__tostring()
    return string.format("%s", self._innerName)
end
