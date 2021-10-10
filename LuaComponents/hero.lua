local actorModule = require_ex("actor")
local actorConst = require_ex("actor_const")

local Hero = DefineClass("Hero", actorModule.Actor)

function Hero:ctor()
    actorModule.Actor.ctor(self)
end

function Hero:getActorType()
    return actorConst.ACTOR_TYPE_HERO
end

function Hero:testFunction()
    if self.lifeComp then
        self.lifeComp:die()
    end
end