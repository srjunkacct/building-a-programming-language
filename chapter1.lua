
local lpeg = require "lpeg"

local space = lpeg.S(" \n\t")^0
local numeral = (lpeg.R("09")^1 / tonumber) * space 
local opA = lpeg.C(lpeg.S"+-") * space
local opM = lpeg.C(lpeg.S"*/%") * space
local opE = lpeg.C(lpeg.S"^") * space

local OP = "(" * space
local CP = ")" * space

function fold(lst)
	local acc = lst[1]
	for i = 2, #lst, 2 do
		if lst[i] == "+" then
			acc = acc + lst[i+1]
		elseif lst[i] == "-" then
			acc = acc - lst[i+1]
		elseif lst[i] == "*" then
			acc = acc * lst[i+1]
		elseif lst[i] == "/" then
			acc = acc / lst[i+1]
		elseif lst[i] == "%" then
			acc = acc % lst[i+1]
		elseif lst[i] == "^" then
			acc = acc ^ lst[i+1]
		else
			error("Unknown operator")
		end
	end
	return acc
end

grammar = lpeg.P{
	[1] = "sum",
	primary = numeral + OP * lpeg.V"sum" * CP,
	exp = space * lpeg.Ct(lpeg.V"primary" * (opE * lpeg.V"primary")^0) / fold,
    term = space * lpeg.Ct(lpeg.V"exp" * (opM * lpeg.V"exp")^0) / fold,
    sum = space * lpeg.Ct(lpeg.V"term" * (opA * lpeg.V"term")^0) / fold
}

grammar = grammar * -1
local subject = "2 ^ ( 3 + 4 ) * 10 % 1000"
print(subject)
print(grammar:match(subject))


