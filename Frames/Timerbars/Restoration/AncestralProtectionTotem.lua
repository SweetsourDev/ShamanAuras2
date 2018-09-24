local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local AncestralProtectionTotemBar = SSA.AncestralProtectionTotemBar

AncestralProtectionTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,4,3)) then
		Auras:RunTimerBarCode(self,spec,db)
	end
end)

AncestralProtectionTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)