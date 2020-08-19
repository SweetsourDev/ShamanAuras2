local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SkyfuryTotemBar = SSA.SkyfuryTotemBar

-- Initialize Data Variables
SkyfuryTotemBar.spellID = 204330
SkyfuryTotemBar.icon = 135829
SkyfuryTotemBar.start = 0
SkyfuryTotemBar.duration = 15
SkyfuryTotemBar.elapsed = 0
SkyfuryTotemBar.condition = function() 
	local spec = GetSpecialization()
	local spellID = (spec == 1 and 3488) or (spec == 2 and 3487) or (spec == 3 and 707)
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(spellID)
	--[[if (spec == 1) then
		spellID = 3488
	elseif (spec == 2) then
		spellID = 3487
	elseif (spec == 3) then
		spellID = 707
	end]]
	
	return selected and Auras:IsPvPZone()
end

SkyfuryTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

SkyfuryTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)