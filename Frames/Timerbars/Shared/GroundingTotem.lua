local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local GroundingTotemBar = SSA.GroundingTotemBar

GroundingTotemBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,"3620") or Auras:CharacterCheck(self,2,"3622") or Auras:CharacterCheck(self,3,"715")) then
		Auras:RunTimerBarCode(self)
	end
end)

--GroundingTotemBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
GroundingTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)