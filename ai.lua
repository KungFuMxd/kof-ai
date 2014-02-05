
-- 人物出招的基本输入
-- 轻拳 1.1. 或者R1.     这个R1.也能输入，有点神奇
-- 轻腿 2.2.
-- 重拳 3.3.
-- 重腿 4.4.
-- 蹲A  D1.D1.D1.D1.D1.
-- 蹲B  D2.D2.D2.D2.D2.
-- 梦弹 R1.R1.R1.R1.R1.
-- 轰斧阴 "2.2.2.R2.R2.R2."
-- 鬼燃烧：→↓↘+A或C  "D.D.DR.DR.R1.R1."
-- 葵花：↓↙←+A或C  "D.D.DL.DL.L1.L1."
-- 小升龙 "R.R.R.R.DR.DR.D.D.D.DR.DR.R.R1.R1.R1.1.1.1.1"
Astr_a = "1.1."
Astr_b = "2.2."
Astr_c = "3.3."
Astr_d = "4.4."
Astr_2a = "D1.D1.D1.D1.D1.D."
Astr_2b = "D2.D2.D2.D2.D2.D."
Astr_6a = "R1.R1.R1.R1.R1.R1."
Astr_262a = "R.R.R.R.DR.DR.D.D.D.DR.DR.R.R1.R1.R1.1.1.1.1."
Astr_24a = "D.D.DL.DL.L1.L1."
Astr_24c = "D.D.DL.DL.L3.L3."
Astr_26a = "D.D.DR.DR.R1.R1."

-- 这个函数判断当前是否能出招攻击敌人
function canAttack( )
	local player = nil
	if isP1() then
		player = gameState.p1
	else
		player = gameState.p2
	end

	local act = player.ACT
	-- print("canAttack, act:", act)
	if act == 0 or act == 1 or act == 2 or act == 21 or act == 22 or act == 23 then
		return true
	elseif act >= 26 and act <= 37 then  -- 26 到37 都是防御动作
		if player.vibrateHS == 0xFF and player.backHS == 0xFF then  --当人物是防御动作时，如果振动硬直和后退硬直都是0xFF，则说明这时防御已完成，人物可以出招了
			return true
		end
	end
	return false
end

-- 小跳
function A_7d( )
	-- autoDirectAddControl("UR.UR.")
	astr = "UR.UR.W15.4."
	local maxFrameCount = 100
	print(maxFrameCount)
	autoDirectAddControl(astr)
	local framecount = 0

	-- 所以本次出招的可能ACT
	local actCountMap = {}
	actCountMap[0] = 0
	actCountMap[21] = 0
	actCountMap[7] = 0
	actCountMap[10] = 0
	actCountMap[18] = 0
	actCountMap[17] = 0
	actCountMap[112] = 0

	return	function( )
		print("gameState.p1.ACT:", gameState.p1.ACT)
		if actCountMap[gameState.p1.ACT] == nil then
		-- 说明这次出招中间遇到问题，交还A_stand()函数处理
			aiFunc = A_stand()
			return true
		end
		--act计数增加
		actCountMap[gameState.p1.ACT] = actCountMap[gameState.p1.ACT] + 1

		if actCountMap[10] >= 1 and gameState.p2.hits >= 1 then
			aiFunc = A_c()
		end

		if framecount >= maxFrameCount then
			cleanControlStream()
			aiFunc = A_stand()
			return true
		end
		framecount = framecount + 1
	end
end

-- 大跳
function A_77d( )
	autoDirectAddControl("UR.UR.")
end
-- 小影跳
function A_27d( )
	astr = "DL.DL.UR.UR.W15.4."
	local maxFrameCount = 100
	print(maxFrameCount)
	autoDirectAddControl(astr)
	local framecount = 0

	-- 所以本次出招的可能ACT
	local actCountMap = {}
	actCountMap[0] = 0
	actCountMap[21] = 0
	actCountMap[7] = 0
	actCountMap[10] = 0
	actCountMap[18] = 0
	actCountMap[17] = 0
	actCountMap[112] = 0

	return	function( )
		print("gameState.p1.ACT:", gameState.p1.ACT)
		if actCountMap[gameState.p1.ACT] == nil then
		-- 说明这次出招中间遇到问题，交还A_stand()函数处理
			aiFunc = A_stand()
			return true
		end
		--act计数增加
		actCountMap[gameState.p1.ACT] = actCountMap[gameState.p1.ACT] + 1

		if actCountMap[10] >= 1 and gameState.p2.hits >= 1 then
			aiFunc = A_c()
		end

		if framecount >= maxFrameCount then
			cleanControlStream()
			aiFunc = A_stand()
			return true
		end
		framecount = framecount + 1
	end
end

-- 大影跳D
function A_277d( ... )
	-- 判断对方的高度，如果对方起跳，则出招打击，如果对方在地上，则打低点
	print("A_277d")
	astr = "DL.DL.UR.UR.UR.UR.UR.UR.W18.4."
	local maxFrameCount = 100
	autoDirectAddControl(astr)
	local framecount = 0

	-- 所以本次出招的可能ACT
	local actCountMap = {}
	actCountMap[0] = 0
	actCountMap[21] = 0
	actCountMap[7] = 0
	actCountMap[8] = 0
	actCountMap[9] = 0
	actCountMap[10] = 0
	actCountMap[112] = 0

	return	function( )
		print("gameState.p1.ACT:", gameState.p1.ACT)
		print("xxxxxxxxxxxxxxx")
		if actCountMap[gameState.p1.ACT] == nil then
		-- 说明这次出招中间遇到问题，交还A_stand()函数处理
			aiFunc = A_stand()
			return true
		end
		--act计数增加
		actCountMap[gameState.p1.ACT] = actCountMap[gameState.p1.ACT] + 1
		print("gameState.p2.hits:", gameState.p2.hits)
		if actCountMap[10] >= 1 and gameState.p2.hits >= 1 then
			print("-----------------------------")
			aiFunc = A_c()
		end

		if framecount >= maxFrameCount then
			cleanControlStream()
			aiFunc = A_stand()
			return true
		end
		framecount = framecount + 1
	end
end

function A_a()
	local framecount = 0
	autoDirectAddControl("1.1.")
	nextActCount = 10 --过多少帧开始执行下连技中的下一个动作
	maxBreakCount = 60 --最大超过15，必须要跳出这个AI处理函数

	return function( )
		if framecount >= nextActCount then
			if gameState.p2.hits >= 1 then
				aiFunc = A_6a()
			else
				cleanControlStream()
				aiFunc = A_stand()
			end
		end

		if framecount >= maxBreakCount then
			aiFunc = A_stand()
		end
		framecount = framecount + 1
	end
end

function A_c()
	print("A_c")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT == 98 then
			if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 8 then
				once = false
				if getMyInfo().nengLiang >= 1 then  --如果有能量则出大招
					if gameState.distance <= 50 then --如果距离够近，则出梦弹再接大招，这个距离很难介定，只能按大概测试的来个
						-- 也许改为压键更容易出
						autoDirectAddControl("R1.R1.R1.R1.R1.R1...." .. "D.DR.DR.DR.L1.L1.L1..")
					else
						autoDirectAddControl(Astr_24c)
					end
				else
					if gameState.distance <= 50 then --如果距离够近，则出梦弹再接葵花
						autoDirectAddControl("R1.R1.R1.R1.R1.R1....D.D.DL.DL.L3.L3.3.3.3.3.")
					else
						autoDirectAddControl(Astr_24c)
					end			
				end	
			end
		elseif p.ACT == 99 then
			if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 12 then
				once = false
				if getMyInfo().nengLiang >= 1 then  --如果有能量则出大招
					autoDirectAddControl( "." .. "D.DR.DR.DR.L1.L1.L1...")
				else
					autoDirectAddControl(Astr_24c)
				end	
			end			
		else
			print("p.ACT ~= 98 and p.ACT ~= 99")
			aiFunc = A_stand()
			return true
		end

	end	
end

function A_b()
	print("A_b")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 89 then
			print("p.ACT ~= 89")
			aiFunc = A_stand()
			return true
		end
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 10 then
			once = false
			if getMyInfo().nengLiang >= 1 then  --如果有能量则出大招
				autoDirectAddControl( "R1.R1.R1.R1.R1.R1...." .. "D.DR.DR.DR.L1.L1.L1....")
			else
				autoDirectAddControl("R1.R1.R1.R1.R1.R1....D.D.DL.DL.L3.L3.3.3.")
			end
		end
	end	
end

function A_2b()
	print("A_2b")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 97 then
			print("p.ACT ~= 97")
			aiFunc = A_stand()
			return true
		end
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 16 then
			once = false
			-- 如果距离近，则出站B，如果远，则出2a，如再远，则不出招，
			if gameState.distance <= 45 then --如果距离够近，则出梦弹再接葵花
				autoDirectAddControl(Astr_b)
			else
				autoDirectAddControl(Astr_2a)
			end	
		end
	end	
end

--百合折
function A_baiHeZhe( )
	-- 183  184  24
	print("A_baiHeZhe")	
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 183 and p.ACT ~= 184 then
			print("p.ACT ~= 183 and p.ACT ~= 184 ")
			aiFunc = A_stand()
			return true
		end
		if once and p.ACT == 184 and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 1 then
			once = false
			autoDirectAddControl(Astr_2b)
		end
	end		
end

function A_2a()
	print("A_2a")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 88 then
			print("p.ACT ~= 88")
			aiFunc = A_stand()
			return true
		end
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 11 then
			once = false

			if getMyInfo().nengLiang >= 1 then  --如果有能量则出大招
				if gameState.distance <= 50 then --如果距离够近，则出梦弹再接大招，这个距离很难介定，只能按大概测试的来个
					-- 也许改为压键更容易出
					autoDirectAddControl("R1.R1.R1.R1.R1.R1...." .. "D.DR.DR.DR.L1.L1.L1..")
				else
					autoDirectAddControl(Astr_24a)
				end
			else
				if gameState.distance <= 50 then --如果距离够近，则出梦弹再接葵花
					autoDirectAddControl("R1.R1.R1.R1.R1.R1....D.D.DL.DL.L3.L3.3.3.3.3.")
				else
					autoDirectAddControl(Astr_24a)
				end			
			end	

			-- -- 如果距离近，则梦弹，再葵花，如果远则直接小葵花
			-- if gameState.distance <= 45 then --如果距离够近，则出梦弹再接葵花
			-- 	--                          "R1.R1.R1.R1.R1.R1....D.D.DL.DL.L3.L3.3.3.3.3."
			-- 	autoDirectAddControl("R1.R1.R1.R1.R1.R1....D.D.DL.DL.L3.L3.3.3.3.3.")
			-- else
			-- 	autoDirectAddControl(Astr_24a)
			-- end	
		end
	end	
end

function A_6a()
	print("A_6a")
	-- 6a 接葵花 R1.R1.R1.R1.R1.R1....D.D.DL.DL.L3.L3.
	return	function( )
	end
end

function A_24c_1( ) --大葵花一段
	print("A_24c_1")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 142 then
			print("p.ACT ~= 142")
			aiFunc = A_stand()
			return true
		end
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 13 then
			once = false
			autoDirectAddControl(Astr_24c)
		end
	end	
end

function A_24c_2( ) --大葵花二段
	print("A_24c_2")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 146 then
			print("p.ACT ~= 146")
			aiFunc = A_stand()
			return true
		end
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 13 then
			once = false
			autoDirectAddControl(Astr_24c)
		end
	end	
end

function A_24c_3( ) --大葵花三段
	return	function( )
	end	
end

function A_24a_1( )
	print("A_24a_1")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 141 then
			print("p.ACT ~= 141")
			aiFunc = A_stand()
			return true
		end
		-- TODO 这里可能还要做距离的判断，因为有些太远的话，小葵花第二式打不到，或者判断ACTrepeatCount在某一范围才出招
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 13 then
			once = false
			autoDirectAddControl(Astr_24c)
		end
	end	
end

function A_24a_2( )
	print("A_24a_2")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 145 then
			print("p.ACT ~= 145")
			aiFunc = A_stand()
			return true
		end
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 13 then
			once = false
			autoDirectAddControl(Astr_24c)
		end
	end	
end
-- TODO 完成没有击中时，后续的打击
-- 完成抓到时，后面的出招，是否要加上鬼步？
-- 真的有投技的判定框，看98的八神的抓失败动作就知道了
--跑抓，一直前跑，如果见到对方有出招的动作，则跳出，把控制对交给A_stand()
function paoZhua( )
	local actCountMap = {}
	actCountMap[0] = 0
	actCountMap[1] = 0
	actCountMap[98] = 0
	actCountMap[179] = 0
	-- R.R..R.R.LD.LD.LD.R.R3.R3.
	autoDirectAddControl("R.R..R.R.LD.LD.LD.R.")
	return function( )
		print("distance:", gameState.distance)
		if gameState.distance <= 70 then
			autoDirectAddControl("R3.R3.")
			aiFunc = A_stand()
		else
			autoDirectAddControl("R.")
		end
	end
end

--倒地ab，进攻型AB是否另一个函数？
function ab( )
	
end

-- 极限发小波
-- 原理是判断发波的最后收招动作还余下多少帧，在这之前就先输入出招，最后才按a/c
function xiaoBoEndless( )
	--Astr_26a = "D.D.DR.DR.R1.R1."
	return function( )
		local me = getMyInfo()
		if me.ACT == 0 and me.ACTrepeatCount == 1 then
			autoDirectAddControl(Astr_26a)
		end
	end
end

--前跳落地动作
function qiangTiaoLuaDi( )
	print("qiangTiaoLuaDi")
	local once = true  --只能运行一次
	return	function( )
		local p = getMyInfo()
		if p.ACT ~= 10 then
			print("p.ACT ~= 145")
			aiFunc = A_stand()
			return true
		end
		if once and getOpponentInfo().hits >= 1 and p.ACTrepeatCount >= 1 then --如果空中出招有打到地上的人的话，接站C
			once = false
			autoDirectAddControl(Astr_c .. "........")
		end
	end	
end

aiFunc = function( )
end

-- accackActMap 存放ACT和处理这个ACT的ai function，这个ai function不一定只处理这个ACT，相关的ACT可能一并处理了
-- 当处理完后，再把控制权还给A_stand()函数
attackActMap = {}
attackActMap[10] = qiangTiaoLuaDi  --前跳落地动作
attackActMap[88] = A_2a
attackActMap[89] = A_b
attackActMap[97] = A_2b
attackActMap[98] = A_c
attackActMap[99] = A_c
attackActMap[141] = A_24a_1
attackActMap[145] = A_24a_2
attackActMap[142] = A_24c_1
attackActMap[146] = A_24c_2
attackActMap[183] = A_baiHeZhe

--应敌人出慢波的
function O_manBO( )
	print("O_manBO")
	--向前大影跳
	local pose = getMyInfo().pose
	print("pose:", pose)
	if pose == 4 then --如果是蹲姿，则先站起来，才能影跳
		autoDirectAddControl("..D.D.D.UR.UR.UR.UR.UR.UR....................4.")
	elseif pos == 0 then
		autoDirectAddControl("D.D.D.UR.UR.UR.UR.UR.UR....................4.")
	end

	-- autoDirectAddControl("D.D.D.UR.UR.UR.UR.UR.UR....................4.")

	local count = 1
	return function()
		count = count + 1
		if count > 20 then
			aiFunc = A_stand()
			return true
		end
	end
end
-- 敌人的动作和对应处理的函数
opponentActMap = {}
opponentActMap[153] = O_manBO

-- 约定所有的AI函数都要返回nil值，如果返回非nil，则表示本AI函数在本帧内没有做出处理，要下面的AI函数在本帧内做出处理。
function A_stand()
	return function( )
		-- 如果输入流中还有没完成的数据，则不处理
		if string.len(inputStreamStr) > 0 then
			return
		end

		-- 如果是处于攻击状态中，则继续处理
		local func = attackActMap[getMyInfo().ACT]
		if func ~= nil then
			aiFunc = func()
			return true
		end

		-- 如果可以攻击，则。。
		if canAttack() then
			local O_func = opponentActMap[getOpponentInfo().ACT]
			if O_func ~= nil and getOpponentInfo().ACTrepeatCount == 1 then
				aiFunc = O_manBO()
				return true
			end
		end

		print("A_stand, guard")
		-- 如果没有好的办法，则防御
		-- local p = getOpponentInfo()
		-- if p.y < 0x00D8 or getMyInfo().y > 0x00D8 then --对手在空中，则站防，或者自己在空中，则也同样拉后
		-- 	autoDirectAddControl("L.")
		-- else
		-- 	autoDirectAddControl("LD.")
		-- end

	end
end

A_crouchGuard = function ( )
	return function( )
	-- print("A_crouchGuard")
	-- print("gameState.p2.ACT :", gameState.p2.ACT )
	-- 	if gameState.p2.ACT == 80 then
	-- 		autoDirectAddControl("12.12.")
	-- 	end

		p = getOpponentInfo()
		if p.y < 0x00D8 then --对手在空中，则站防
			autoDirectAddControl("L.")
		else
			autoDirectAddControl("LD.")
		end

	end
end


