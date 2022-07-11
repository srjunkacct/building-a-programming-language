local lpeg = require "lpeg"
local pt = require "pt"

-----------------------
local function node (number)
    return {tag = "number", val = tonumber(number)}
end



local space = lpeg.S(" \t\n")^0
local numeral = lpeg.R("09")^1 / node * space

local function parse (input)
    return numeral:match(input)
end

-----------------------------
local function compile (abstractSyntaxTree)
    if abstractSyntaxTree.tag == "number" then
        return {"push", abstractSyntaxTree.val}
    end
end

-----------------------------

local function run (code, stack)
    local programCounter = 1
    local topStack = 0
    while programCounter <= #code do
        local instruction = code[programCounter]
        if instruction == "push" then
            programCounter = programCounter + 1
            topStack = topStack + 1
            stack[topStack] = code[programCounter]
        else error("Error!  Unknown instruction.")
        end
        programCounter = programCounter + 1
    end

end


-------------------------------
local input = io.read("a")
local ast = parse(input)
print(pt.pt(ast))
local code = compile(ast)
print(pt.pt(code))
local stack = {}
run(code, stack)
print(stack[1])