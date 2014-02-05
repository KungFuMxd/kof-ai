
function print( ... )
end

dofile("LuaScripts/kof-ai/gameInfo.lua")
dofile("LuaScripts/kof-ai/inputStream.lua")
dofile("LuaScripts/kof-ai/ai.lua")

emu.registerbefore(function ( )
	-- print("emu.registerbefore")
	-- showGameInfo()

	updateGameState()
	local table = takeOneFrame()
	joypad.set(table)
	
end)

emu.registerafter(function( )
	-- print("emu.registerafter")
	
	-- 如果aiFunc返回的是nil，说明不用下面的程序处理当前frame，如果是非nil，则说明要下面的程序处理当前frame
	while true do
		local re = aiFunc()
		if not re then
			break
		end
	end
end)

-- TODO 可能以后要处理有些按键没有释放的情况！有可能程序会出点小错，然后按键的消息就出错了。也许，如果有连续两帧都是"."时，发送消息，让所有的按键都Key_up
--AI的设计可以改为结合两种方式，在函数上增加一个参数即可，有参数的，即是还没有出招，等待出招中，没有参数的，则是己出招，在这里负责后面的处理。

bIsP1 = true
aiFunc = A_stand()
-- inputStreamStr = "D.D.D.D.UR.UR.UR.UR.UR.UR....................4."
-- aiFunc = A_24c_1()
-- aiFunc = A_crouchGuard()
-- inputStreamStr = "3.3.3."
-- inputStreamStr = "D2.D2.D2.D2.D2.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D1.D1.D1.D1.D1...........R1.R1.R1.R1.R1."
-- inputStreamStr = "4.4.4.4.4.4.4.4."
-- input.registerhotkey(1, function ( ) --"D.D.DL.DL.L3.L3."
	-- aiFunc = A_crouchGuard()
	-- aiFunc = A_c()
-- 	-- aiFunc = A_24c_1()
	-- aiFunc = A_277d()
-- 	-- autoDirectAddControl("123.W5.L1.")

-- end)