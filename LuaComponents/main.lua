require("luaCommon.__init__")

local actorManagerModule = require_ex("actor_manager")
local actorConst = require_ex("actor_const")

local actorManager = actorManagerModule.ActorManager.new()

local actor = actorManager:createActor(actorConst.ACTOR_TYPE_HERO)

local info = actor:getComponentDebugInfo()
print(actor.id, info)

actor:testFunction()
actor:destroy()