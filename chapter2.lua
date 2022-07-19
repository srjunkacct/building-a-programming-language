local lpeg = require "lpeg"
local pt = require "pt"

-----------------------
local function node (number)
    return {tag = "number", val = tonumber(number)}
end



local space = lpeg.S(" \t\n")^0
local numeral = lpeg.R("09")^1 / node * space

local opA = lpeg.C(lpeg.S"+-") * space
local opM = lpeg.C(lpeg.S"*/") * space

local ops = { ["+"] = "add", ["-"] = "sub", ["*"] = "mul", ["/"] = "div" }
-- Convert a list (n1, "+", n2, "+", n3, ... into a tree

local function foldBin (lst)
    local tree = lst[1]
    for i = 2, #lst, 2 do
        tree = { tag = "binop", e1 = tree, op = lst[i], e2 = lst[i+1] }
    end
    return tree
end

local term = lpeg.V"term"
local exp = lpeg.V"exp"

grammar = lpeg.P{"exp",
    term = lpeg.Ct(numeral * (opM * numeral)^0) / foldBin,
    exp = lpeg.Ct(term * (opA * term)^0) / foldBin,

}

local function parse (input)
    return grammar:match(input)
end

-----------------------------

local function addCode (state, op)
    local code = state.code
    code[#code + 1] = op
end

local function codeExp (state, ast)
    print("Current tree is")
    print(pt.pt(ast))
    if ast.tag == "number" then
        addCode(state, "push")
        addCode(state, ast.val)
    elseif ast.tag == "binop" then
        codeExp(state, ast.e1)
        codeExp(state, ast.e2)
        addCode(state, ops[ast.op])
    else error("ERROR:  Invalid tree")
    end
end

local function compile (ast)
    local state = { code = {} }
    codeExp(state, ast)
    return state.code
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
        elseif instruction == "add" then
            stack[topStack - 1] = stack [topStack - 1] + stack[topStack]
            topStack = topStack - 1
        elseif instruction == "sub" then
            stack[topStack - 1] = stack [topStack - 1] - stack[topStack]
            topStack = topStack - 1
        elseif instruction == "mul" then
            stack[topStack - 1] = stack [topStack - 1] * stack[topStack]
            topStack = topStack - 1
        elseif instruction == "div" then
            stack[topStack - 1] = stack [topStack - 1] / stack[topStack]
            topStack = topStack - 1
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
