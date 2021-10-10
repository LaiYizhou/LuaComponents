function simpleFunctor(self, funcName)
    return function(...)
        return self[funcName](self, ...)
    end
end

function argsFunctor(self, funcName, arg1)
    -- arg 为保留字，处理... 用的arg保留字
    return function(...)
        return self[funcName](self, arg1, ...)
    end
end

function varargCallback(self, funcName, ...)
    local nArgs = select("#", ...)

    -- 为避免创建table，在参数个数在一定范围内时，穷举各种参数个数的情况
    if nArgs == 0 then
        return function()
            return self[funcName](self)
        end
    elseif nArgs == 1 then
        local arg1 = select(1, ...)
        return function()
            return self[funcName](self, arg1)
        end
    elseif nArgs == 2 then
        local arg1, arg2 = select(1, ...)
        return function()
            return self[funcName](self, arg1, arg2)
        end
    elseif nArgs == 3 then
        local arg1, arg2, arg3 = select(1, ...)
        return function()
            return self[funcName](self, arg1, arg2, arg3)
        end
    elseif nArgs == 4 then
        local arg1, arg2, arg3, arg4 = select(1, ...)
        return function()
            return self[funcName](self, arg1, arg2, arg3, arg4)
        end
    elseif nArgs == 5 then
        local arg1, arg2, arg3, arg4, arg5 = select(1, ...)
        return function()
            return self[funcName](self, arg1, arg2, arg3, arg4, arg5)
        end
    elseif nArgs <= 7 then
        local arg1, arg2, arg3, arg4, arg5, arg6, arg7 = select(1, ...)
        return function()
            return self[funcName](self, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        end
    elseif nArgs <= 10 then
        local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 = select(1, ...)
        return function()
            return self[funcName](self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        end
    else
        local args = {...}
        return function()
            return self[funcName](self, unpack(args, 1, nArgs))
        end
    end
end

function argsClassMethodFunctor(cls, funcName, param)
    return function(...)
        return cls[funcName](param, ...)
    end
end

function classMethodFunctor(cls, funcName)
    return function(...)
        return cls[funcName](...)
    end
end

function twoArgsFunctor(self, funcName, arg1, arg2)
    -- 返回的函数使用时还能接受一个参数
    return function(args)
        return self[funcName](self, arg1, arg2, args)
    end
end