bit = require("bit")

-- 游戏的一些相关的数据
--这里可能有些地址不太准，没有仔细校对过，可能相差1
game = {
		address = {
			p1x = 0x108118,
			p1y = 0x108126,
			p2x = 0x108318,
			p2y = 0x108326,

			p1CH = 0x108170,
			p2CH = 0x108370,

			p1ACT = 0x108172,
			p2ACT = 0x108372,

			p1hits = 0x1082b0,
			p2hits = 0x1084b0,	

			p1VibrateHS = 0x108224, --振动硬直
			p2VibrateHS = 0x108424,

			p1BackHS = 0x1081D2, --后退硬直
			p2BackHS = 0x1083D2,

			p1Pose = 0x1081E0, --人物的姿态
			p2Pose = 0x1083E0, --人物的姿态

			p1TenFrameNT = 0x1082D4, --10帧抗投，貌似这个数值要加1？
			p2TenFrameNT = 0x1084D4, --10帧抗投

			p1ChiXuJian = 0x10DA44,  --持续键值
			p1FuHeJian = 0x10DA4D,  --复合键值
			p1DanJian = 0x10DA4E,  --单键值

			p2ChiXuJian = 0x10DA5D,  --持续键值
			p2FuHeJian = 0x10DA64,  --复合键值
			p2DanJian = 0x10DA66,  --单键值	

			p1NengLiang = 0x1082E3,  --能量个数
			p2NengLiang = 0x1084E3,  --能量个数		
		},
}
--这个地址是EC地址
-- game = 
-- {		address = {
-- 			p1x = 0x008119,
-- 			p1y = 0x008127,
-- 			p2x = 0x008319,
-- 			p2y = 0x008327,

-- 			p1CH = 0x008170,
-- 			p2CH = 0x008370,

-- 			p1ACT = 0x008173,
-- 			p2ACT = 0x008373,

-- 			p1hits = 0x0082b1,
-- 			p2hits = 0x0084b1,

-- 			p1VibrateHS = 0x008225, --振动硬直
-- 			p2VibrateHS = 0x008425,

-- 			p1BackHS = 0x0081D2, --后退硬直
-- 			p2BackHS = 0x0083D2,

-- 			p1Pose = 0x0081E1, --人物的姿态
-- 			p2Pose = 0x0083E1, --人物的姿态

-- 			p1TenFrameNT = 0x0082D5, --10帧抗投，貌似这个数值要加1？
-- 			p2TenFrameNT = 0x0084D5, --10帧抗投

-- 			p1ChiXuJian = 0x00DA45,  --持续键值
-- 			p1FuHeJian = 0x00DA4D,  --复合键值
-- 			p1DanJian = 0x00DA4E,  --单键值

-- 			p2ChiXuJian = 0x00DA5D,  --持续键值
-- 			p2FuHeJian = 0x00DA65,  --复合键值
-- 			p2DanJian = 0x00DA66,  --单键值	

-- 			p1NengLiang = 0x0082E2,  --能量个数
-- 			p2NengLiang = 0x0084E2,  --能量个数
-- 		},
-- }
gameState = {
	p1 = {	x = 0, 
			y = 0, 
			CH = -1, 
			ACT = -1, 
			ACTrepeatCount = 0, --当前的这个ACT重复了多少帧了
			ACThistory = {}, --保存前60帧的ACT？
			hits = 0,
			vibrateHS = 0, --振动硬直
			backHS = 0, --后退硬直
			tenFrameNT = 0, --10帧抗投
			pose = 0,    --人物的姿态，如果是0，则站，是4则蹲，是2则在空中
			nengLiang = 0,  --能量的个数

		},
	p2 = {	x = 0, 
			y = 0, 
			CH = -1, 
			ACT = -1, 
			ACTrepeatCount = 0,
			ACThistory = {}, --保存前60帧的ACT？
			hits = 0,
			vibrateHS = 0,  --振动硬直
			backHS = 0, --后退硬直
			tenFrameNT = 0, --10帧抗投
			pose = 0,    --人物的姿态，如果是0，则站，是4则蹲，是2则在空中
			nengLiang = 0,  --能量的个数
		},
	time = 0,
	frame = 0,
	distance = 0,
}

function showGameInfo( )
	local p = gameState.p1
	local tempStr = ""
	tempStr = tempStr .. "inputStreamStr:" .. inputStreamStr .. "\r\n"
	tempStr = tempStr .. string.format("x:%d y:%d CH:%d ACT:%d ACTrepeatCount:%d hits:%d vibrateHS:%d backHS:%d tenFrameNT:%d pose:%d", 
		p.x, p.y, p.CH, p.ACT, p.ACTrepeatCount, p.hits, p.vibrateHS, p.backHS, p.tenFrameNT, p.pose)
	tempStr = tempStr .. "\r\n"
	p = gameState.p2
	tempStr = tempStr .. string.format("x:%d y:%d CH:%d ACT:%d ACTrepeatCount:%d hits:%d vibrateHS:%d backHS:%d tenFrameNT:%d pose:%d", 
		p.x, p.y, p.CH, p.ACT, p.ACTrepeatCount, p.hits, p.vibrateHS, p.backHS, p.tenFrameNT, p.pose)
	-- tempStr = tempStr .. "\r\n" .. allInputStreamStr
	-- show(tempStr)
end
--输入的是不是1P
function isP1( )
	return bIsP1
end

-- 这个函数中的有些内容是否要精简？比如有些读内存的操作可以等到要用时再读，有些时候是用不到这些数据的。。
updateGameState = function (  )
	-- print("updateGameState")
	gameState.p1.x = memory.readword(game.address.p1x)
	gameState.p1.y = memory.readword(game.address.p1y)
	gameState.p1.CH = memory.readbyte(game.address.p1CH)

	local  act = -1
	act = memory.readword(game.address.p1ACT)
	if act == gameState.p1.ACT then
		gameState.p1.ACTrepeatCount = gameState.p1.ACTrepeatCount + 1
	else
		gameState.p1.ACTrepeatCount = 1 
	end
	gameState.p1.ACT = act

	gameState.p1.hits = memory.readbyte(game.address.p1hits)

	gameState.p2.x = memory.readword(game.address.p2x)
	gameState.p2.y = memory.readword(game.address.p2y)
	gameState.p2.CH = memory.readbyte(game.address.p2CH)

	act = memory.readword(game.address.p2ACT)
	if act == gameState.p2.ACT then
		gameState.p2.ACTrepeatCount = gameState.p2.ACTrepeatCount + 1
	else
		gameState.p2.ACTrepeatCount = 1 
	end
	gameState.p2.ACT = act
	gameState.p2.hits = memory.readbyte(game.address.p2hits)

	-- 得到两个玩家之间的距离
	local distance = gameState.p1.x - gameState.p2.x
	if distance > 0 then
		gameState.distance = distance
	else
		gameState.distance = -distance
	end

	-- 读取人物的硬直数据
	gameState.p1.vibrateHS = memory.readbyte(game.address.p1VibrateHS)
	gameState.p1.backHS = memory.readbyte(game.address.p1BackHS)
	gameState.p2.vibrateHS = memory.readbyte(game.address.p2VibrateHS)
	gameState.p2.backHS = memory.readbyte(game.address.p2BackHS)

	--读取人物的能量数据
	gameState.p1.nengLiang = memory.readbyte(game.address.p1NengLiang)
	gameState.p2.nengLiang = memory.readbyte(game.address.p2NengLiang)	


	-- 得到人物的pose数据，即在地上，下蹲，还是空中
	gameState.p1.pose = memory.readbyte(game.address.p1Pose)
	gameState.p2.pose = memory.readbyte(game.address.p2Pose)

	--得到敌方的输入？
	local input = 0
	if isP1() then
		input = memory.readbyte(game.address.p2ChiXuJian)
	else
		input = memory.readbyte(game.address.p1ChiXuJian)
	end
	gameState.opponentInput = {}
	if bit.band(input, 0x10) > 0 then
		gameState.opponentInput["A"] = true
	else
		gameState.opponentInput["A"] = false
	end
	if bit.band(input, 0x20) > 0 then
		gameState.opponentInput["B"] = true
	else
		gameState.opponentInput["B"] = false
	end	
	if bit.band(input, 0x30) > 0 then
		gameState.opponentInput["C"] = true
	else
		gameState.opponentInput["C"] = false
	end
	if bit.band(input, 0x40) > 0 then
		gameState.opponentInput["D"] = true
	else
		gameState.opponentInput["D"] = false
	end	
	if bit.band(input, 0x01) > 0 then
		gameState.opponentInput["Up"] = true
	else
		gameState.opponentInput["Up"] = false
	end		
	if bit.band(input, 0x02) > 0 then
		gameState.opponentInput["Down"] = true
	else
		gameState.opponentInput["Down"] = false
	end	
	if bit.band(input, 0x04) > 0 then
		gameState.opponentInput["Left"] = true
	else
		gameState.opponentInput["Left"] = false
	end		
	if bit.band(input, 0x08) > 0 then
		gameState.opponentInput["Right"] = true
	else
		gameState.opponentInput["Right"] = false
	end	
end

--得到对手的信息
function getOpponentInfo( )
	if isP1() then
		return gameState.p2
	else
		return gameState.p1
	end
end
--得到自己的信息
function getMyInfo( )
	if isP1() then
		return gameState.p1
	end
	return gameState.p2
end
-- 得到两个人的距离
function getDistance( )
	return gameState.distance
end

--得到己方的ACT
function getMyAct( )
	if isP1() then
		return gameState.p1.ACT
	else
		return gameState.p2.ACT
	end
end

--得到敌方的ACT
function getOpponentAct()
	if isP1() then
		return gameState.p2.ACT
	else
		return gameState.p1.ACT
	end
end

--得到敌方的输入的情况
function getOpponentInput( str )
	return gameState.opponentInput[str]
end

--得到己方的输入情况？？貌似这个函数没用
function getMyInput( )
	
end