local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetSpecialization = GetSpecialization

-- Cache Global Addon Variables
local CounterstrikeTotemBar = SSA.CounterstrikeTotemBar

-- Initialize Data Variables
CounterstrikeTotemBar.spellID = 204331
CounterstrikeTotemBar.icon = 511726
CounterstrikeTotemBar.start = 0
CounterstrikeTotemBar.duration = 15
CounterstrikeTotemBar.elapsed = 0
CounterstrikeTotemBar.condition = function()
	local spec = SSA.spec or GetSpecialization()
	local spellID = (spec == 1 and 3490) or (spec == 2 and 3489) or (spec == 3 and 708)
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(spellID)
	--[[if (spec == 1) then
		spellID = 3490
	elseif (spec == 2) then
		spellID = 3489
	elseif (spec == 3) then
		spellID = 708
	end]]
	
	return selected and Auras:IsPvPZone()
end

CounterstrikeTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

CounterstrikeTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)