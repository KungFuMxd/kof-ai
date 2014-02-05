--把输入流当作一个字符串，只做简单的解析，每一帧都检查这个输入流的字符串还有没有字符，如果没有，则不处理
--只支持很简单的，每一个"."就是一帧。

inputStreamStr = ""
allInputStreamStr = ""

-- 改变控制字符串的方向，即把'R'，改为'L'，'L'改为'R'
function changeContorlStrDirect( s )
	local ss = ""
	local len = string.len(s)
	for i = 1, len do
		local c = string.sub(s, i, i)
		if c == 'R' or c == 'r' then
			c = 'L'
		elseif c == 'L' or c == 'l' then
			c = 'R'
		end
		ss = ss .. c
	end
	return ss
end

function addControl( inputStr )
	if inputStr == nil then
		return
	end
	inputStreamStr = inputStreamStr .. inputStr
end

last_oneframe_str = nil
--分析输入字符串，得到一帧的输入，返回一个jpypad的状态
function takeOneFrame( )
	-- print("inputStreamStr:", inputStreamStr)
	local start, index = string.find(inputStreamStr, "%.")
	if not start then
		return {}
	end
	local inputTable = {}
	-- print("start:", start, ",index:", index)
	local str = string.sub(inputStreamStr, 1, start)
	inputStreamStr = string.sub(inputStreamStr, str:len() + 1)
	-- print("str:", str)
	-- print("inputStreamStr:", inputStreamStr)
	local len = string.len(str)

	local pXStr = "P1 "
	if not isP1() then
		pXStr = "P2 "
	end

	-- print("pXStr:", pXStr)
	for i = 1, len do --去掉最后一个'.'
		--改进为用一个map，减少比较次数？
		local char = string.sub(str, i, i)
		-- print("char:", char)
		if char == "U" or char == "u" then
			inputTable[pXStr .. "Up"] = true
		elseif char == "D" or char == "d" then
			inputTable[pXStr .. "Down"] = true
		elseif char == "L" or char == "l" then
			inputTable[pXStr .. "Left"] = true
		elseif char == "R" or char == "r" then
			inputTable[pXStr .. "Right"] = true
		elseif char == "1" then
			inputTable[pXStr .. "Button A"] = true
		elseif char == "2" then
			inputTable[pXStr .. "Button B"] = true			
		elseif char == "3" then
			inputTable[pXStr .. "Button C"] = true
		elseif char == "4" then
			inputTable[pXStr .. "Button D"] = true
		elseif char == "W" or char == "w" then
			emptyFrameCount = tonumber(str:sub(2, len - 1))
			-- print("emptyFrameCount:", emptyFrameCount)
			local tempStr = ""
			for j = 1, emptyFrameCount do
				tempStr = tempStr .. "."
			end
			inputStreamStr = "." .. tempStr .. inputStreamStr
			-- print("inputStreamStr:", inputStreamStr)
			break;
		end
	end
	-- print("TTTTTTTTTTTTTTT:", tostring(inputTable))
	return inputTable
end

-- 清空控制流
function cleanControlStream(  )
	inputStreamStr = ""
end

-- 智能判断方向，修改控制字符串的中的方向为正确的方向
-- 比如控制的是1P，而现在1P在右边，那么出招要更改
-- 如26a，应当输入24a。
function autoDirectAddControl( controlstr )
	if controlstr == nil then
		return
	end
	-- allInputStreamStr = allInputStreamStr .. controlstr
	-- TODO 这里要判断两人的位置关系
	local bShouldChange = false
	print("gameState.p1.x:", gameState.p1.x, "  ,gameState.p2.x:", gameState.p2.x)
	if isP1() then
		if gameState.p1.x > gameState.p2.x then
			bShouldChange = true
		end
	else
		if gameState.p1.x < gameState.p2.x then
			bShouldChange = true
		end
	end

	if bShouldChange then
		local tempStr = ""
		local len = string.len(controlstr)
		for i = 1, len do
			c = string.sub(controlstr, i, i)
			if c == 'R' or c == 'r' then
				tempStr = tempStr .. "L"
			elseif c == 'L' or c == 'l' then
				tempStr = tempStr .. "R"
			else
				tempStr = tempStr .. c
			end
		end
		addControl(tempStr)
	else
		addControl(controlstr)
	end
end