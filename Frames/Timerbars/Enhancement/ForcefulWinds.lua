local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local ForcefulWindsBar = SSA.ForcefulWindsBar

-- Initialize Data Variables
ForcefulWindsBar.spellID = 262652
ForcefulWindsBar.start = 0
ForcefulWindsBar.duration = 15
ForcefulWindsBar.condition = function() return select(4,GetTalentInfo(2,2,1)) end

ForcefulWindsBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,2,2)) then
		Auras:RunTimerBarCode(self)
	end
end)

ForcefulWindsBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)