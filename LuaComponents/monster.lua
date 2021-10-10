local actorModule = require_ex("actor")
local actorConst = require_ex("actor_const")

local Monster = DefineClass("Monster", actorModule.Actor)

function Monster:ctor()
    actorModule.Actor.ctor(self)
end

function Monster:getActorType()
    return actorConst.ACTOR_TYPE_MONSTER
end