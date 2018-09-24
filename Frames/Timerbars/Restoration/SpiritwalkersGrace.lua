local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SpiritwalkersGraceBar = SSA.SpiritwalkersGraceBar

SpiritwalkersGraceBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,3,79206)) then
		Auras:RunTimerBarCode(self)
	end
end)

SpiritwalkersGraceBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)