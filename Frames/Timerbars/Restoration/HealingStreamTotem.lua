local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor

-- Cache Global Addon Variables
local HealingStreamTotemBarOne = SSA.HealingStreamTotemBarOne
local HealingStreamTotemBarTwo = SSA.HealingStreamTotemBarTwo

-- Initialize Data Variables
HealingStreamTotemBarOne.spellID = 5394
HealingStreamTotemBarOne.icon = 135127
HealingStreamTotemBarOne.start = 0
HealingStreamTotemBarOne.duration = 15
HealingStreamTotemBarOne.numTotems = 0
HealingStreamTotemBarOne.condition = function()
	return IsSpellKnown(5394)
end

HealingStreamTotemBarOne:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
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

	
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if (subevent == "SPELL_SUMMON" and srcGUID == UnitGUID("player") and spellID == self.spellID) then
		if (self.start == 0) then
			
			self.start = floor(GetTime())
			--print("SUMMON TOTEM ONE: "..streamOne.startTime)
			--SSA.activeTotems[streamOne.startTime] = self:GetName()
			SSA.activeTotems[self:GetName()] = self.start
			--streamOne.info.isActive = true
			self:Show()
		elseif (self.start > 0) then
			local streamTwoBar = SSA.HealingStreamTotemBarTwo
			
			streamTwoBar.start = floor(GetTime())
			--print("SUMMON TOTEM TWO:"..streamTwo.startTime)
			--SSA.activeTotems[streamTwo.startTime] = "HealingStreamTotemBarTwo"
			SSA.activeTotems["HealingStreamTotemBarTwo"] = streamTwoBar.start
			--streamTwo.info.isActive = true
			streamTwoBar:Show()
		end
		self.numTotems = self.numTotems + 1
	end
end)

-- Initialize Data Variables
HealingStreamTotemBarTwo.spellID = 5394
HealingStreamTotemBarTwo.icon = 135127
HealingStreamTotemBarTwo.start = 0
HealingStreamTotemBarTwo.duration = 15
HealingStreamTotemBarTwo.condition = function()
	return IsSpellKnown(5394)
end

HealingStreamTotemBarTwo:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
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