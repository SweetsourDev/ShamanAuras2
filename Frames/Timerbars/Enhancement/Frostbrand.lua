local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FrostbrandBar = SSA.FrostbrandBar

FrostbrandBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,196834)) then
		Auras:RunTimerBarCode(self)
	end
end)

FrostbrandBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)