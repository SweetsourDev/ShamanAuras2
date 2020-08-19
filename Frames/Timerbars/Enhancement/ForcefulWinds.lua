local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local ForcefulWindsBar = SSA.ForcefulWindsBar

-- Initialize Data Variables
ForcefulWindsBar.spellID = 262652
ForcefulWindsBar.start = 0
ForcefulWindsBar.duration = 15
ForcefulWindsBar.elapsed = 0
ForcefulWindsBar.condition = function()
	local _,_,_,selected = GetTalentInfo(2,2,1)
	
	return selected
end

ForcefulWindsBar:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
			Auras:RunTimerBarCode(self)
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)

ForcefulWindsBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)