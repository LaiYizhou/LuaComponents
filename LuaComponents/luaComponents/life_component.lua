local componentModule = require_ex("luaComponents.base_component")
local eventConst = require_ex("luaComponents.event_const")

local LifeComponent = DefineClass("LifeComponent", componentModule.BaseComponent)
LifeComponent._innerName = "lifeComp"

function LifeComponent:ctor(owner)
    componentModule.BaseComponent.ctor(self, owner)
end

function LifeComponent:die()
    print("LifeComponent:die()")
    self:executeEvent(eventConst.UNIT_DIE)
end