local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local FlametongueBar = SSA.FlametongueBar

FlametongueBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,193796)) then
		Auras:RunTimerBarCode(self)
	end
end)

FlametongueBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end

	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)