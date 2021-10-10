local componentOwnerModule = require_ex("luaComponents.component_owner")

local Actor = DefineClass("Actor", componentOwnerModule.ComponentOwner)

function Actor:ctor()
    componentOwnerModule.ComponentOwner.ctor(self)
end

function Actor:getActorType()
    error("must be overrided by child classes")
end

function Actor:destroy()
    componentOwnerModule.ComponentOwner.destroy(self)
end