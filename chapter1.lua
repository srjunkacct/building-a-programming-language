
local lpeg = require "lpeg"

function sumCaptures(string)
	local digit = lpeg.R("09")^1
	local whitespace = lpeg.P(" ")^0
	local whitespaceDigit = whitespace * digit * whitespace
	local plus = lpeg.P("+")
        local sign = lpeg.S("+-")^0
	local whitespaceDigitSign = sign * whitespaceDigit
	local endString = -lpeg.P(1)
	local sumCapturePattern = lpeg.C(whitespaceDigitSign) * ( lpeg.Cp() * plus * lpeg.C(whitespaceDigitSign) ) ^ 0 * endString
	return sumCapturePattern:match(string)
end

print(sumCaptures("12+-13++25"))

