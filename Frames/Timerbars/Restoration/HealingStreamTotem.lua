local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor

-- Cache Global Addon Variables
local HealingStreamTotemBarOne = SSA.HealingStreamTotemBarOne
local HealingStreamTotemBarTwo = SSA.HealingStreamTotemBarTwo

HealingStreamTotemBarOne:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,5394)) then
		Auras:RunTimerBarCode(self)
	end
end)
--/script for i=1,4 do local _,_,start,duration = GetTotemInfo(i);local r = (start + duration) - GetTime();print(i..". "..r) end
--/script TotemFrameTotem1:HookScript("OnClick",function(self,button) print(_G[self:GetName().."IconTexture"]:GetTexture()) end)
--/script TotemFrameTotem2:HookScript("OnClick",function(self,button) for i=1,4 do local _,_,start,duration = GetTotemInfo(i) local r = (start + duration) - GetTime() print(i..". "..r) end end)
--/script TotemFrameTotem2:HookScript("OnMouseDown",function(self,button) for i=1,4 do local _,_,start,duration = GetTotemInfo(i) local r = (start + duration) - GetTime() print(i..". "..r) end end)
--/script TotemFrameTotem2:HookScript("OnMouseDown",function(self,button) for i=1,4 do local _,_,start = GetTotemInfo(i) print(i..". "..start) end end)
--/script TotemFrameTotem2:HookScript("OnMouseDown",function(self,button) print("HERE") end)
HealingStreamTotemBarOne:SetScript('OnEvent',function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	local streamOne = Auras.db.char.timerbars[3].bars[self:GetName()]
	local streamTwo = Auras.db.char.timerbars[3].bars.HealingStreamTotemBarTwo
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if (subevent == "SPELL_SUMMON" and srcGUID == UnitGUID("player") and spellID == streamOne.data.spellID) then
		if (streamOne.data.start == 0) then
			
			streamOne.data.start = floor(GetTime())
			--print("SUMMON TOTEM ONE: "..streamOne.startTime)
			--SSA.activeTotems[streamOne.startTime] = self:GetName()
			SSA.activeTotems[self:GetName()] = streamOne.data.start
			--streamOne.info.isActive = true
			self:Show()
		elseif (streamOne.data.start > 0) then
			streamTwo.data.start = floor(GetTime())
			--print("SUMMON TOTEM TWO:"..streamTwo.startTime)
			--SSA.activeTotems[streamTwo.startTime] = "HealingStreamTotemBarTwo"
			SSA.activeTotems["HealingStreamTotemBarTwo"] = streamTwo.data.start
			--streamTwo.info.isActive = true
			HealingStreamTotemBarTwo:Show()
		end
		streamOne.data.numTotems = streamOne.data.numTotems + 1
	end
end)

HealingStreamTotemBarTwo:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,5394)) then
		Auras:RunTimerBarCode(self)
	end
end)

--[[HealingStreamTotemBarTwo:SetScript('OnEvent',function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	local timerbar = Auras.db.char.timerbars[3][self:GetName()]
	local streamOne = Auras.db.char.timerbars[3].HealingStreamTotemBarOne
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if (subevent == "SPELL_SUMMON" and srcGUID == UnitGUID("player") and spellID == timerbar.spellID and streamOne.startTime > 0) then
		print("SUMMON TOTEM TWO")
		timerbar.startTime = math.floor(GetTime())
		timerbar.info.isActive = true
		self:Show()
	end
end)]]