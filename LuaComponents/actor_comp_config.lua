local actorConst = require_ex("actor_const")
local transformCompModule = require_ex("luaComponents.transform_component")
local lifeComponentModule = require_ex("luaComponents.life_component")
local aiCompModule = require_ex("luaComponents.ai_component")

ACTOR_COMPONENTS = {
    [actorConst.ACTOR_TYPE_HERO] = {
        transformCompModule.TransformComponent,
        lifeComponentModule.LifeComponent,
    },
    [actorConst.ACTOR_TYPE_MONSTER] = {
        transformCompModule.TransformComponent,
        lifeComponentModule.LifeComponent,
        aiCompModule.AiComponent,
    },
}