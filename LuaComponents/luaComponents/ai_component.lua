local componentModule = require_ex("luaComponents.base_component")

local AiComponent = DefineClass("AiComponent", componentModule.BaseComponent)
AiComponent._innerName = "aiComp"

function AiComponent:ctor(owner)
    componentModule.BaseComponent.ctor(self, owner)
end