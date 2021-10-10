local actorConst      = require_ex("actor_const")
local monsterModule   = require_ex("monster")
local heroModule      = require_ex("hero")
local actorCompConfig = require_ex("actor_comp_config")

local ActorManager = DefineClass("ActorManager")
ActorManager._actorIndex = 1

function ActorManager:ctor()
    self.actors = {}
end


function ActorManager:createActor(actorType)
    local actor
    if actorType == actorConst.ACTOR_TYPE_HERO then
        actor = heroModule.Hero.new()
    elseif actorType == actorConst.ACTOR_TYPE_MONSTER then
        actor = monsterModule.Monster.new()
    end
    self.actors[ActorManager._actorIndex] = actor
    actor.id = ActorManager._actorIndex
    ActorManager._actorIndex = ActorManager._actorIndex + 1
    self:assembleActor(actor, actorType)
    return actor
end


function ActorManager:destroyActor(id)
    local _actor = self.actors[id]
    if _actor then
        _actor:destroy()
        self.actors[id] = nil
    end
end

function ActorManager:assembleActor(actor, actorType)
    local compClasses = actorCompConfig.ACTOR_COMPONENTS[actorType]
    for _, compClass in ipairs(compClasses) do
        actor:addComponent(compClass)
    end
    actor:initAllComponents()
end