local componentModule = require_ex("luaComponents.base_component")
local eventConst      = require_ex("luaComponents.event_const")

local TransformComponent = DefineClass("TransformComponent", componentModule.BaseComponent)
TransformComponent._innerName = "transComp"

function TransformComponent:ctor(owner)
    componentModule.BaseComponent.ctor(self, owner)

    self.x = 100
    self.y = 100
    self.z = 100
end

function TransformComponent:_onEnable()
    componentModule.BaseComponent._onEnable(self)
    self:registerEvent(eventConst.UNIT_DIE, self, "_onUnitDie")
end

function TransformComponent:_onDisable()
    componentModule.BaseComponent._onDisable(self)
    self:unregisterEvent(eventConst.UNIT_DIE, self)
end

function TransformComponent:_onUnitDie()
    self.x = 0
    self.y = 0
    self.z = 0

    print("TransformComponent:_onUnitDie()")
end