
local lpeg = require "lpeg"

local space = lpeg.S(" \n\t")^0
local numeral = (lpeg.R("09")^1 / tonumber) * space 
local opA = lpeg.C(lpeg.S"+-") * space
local opM = lpeg.C(lpeg.S"*/%") * space
local opE = lpeg.C(lpeg.S"^") * space

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

local exp = space * lpeg.Ct(numeral * (opE * numeral)^0) / fold
local term = space * lpeg.Ct(exp * (opM * exp)^0) / fold
local sum = space * lpeg.Ct(term * (opA * term)^0) / fold * -1

local subject = "2 ^ 3 + 4 * 10 % 6"
print(subject)
print(sum:match(subject))


