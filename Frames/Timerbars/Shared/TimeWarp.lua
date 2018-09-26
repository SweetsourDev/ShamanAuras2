local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local TimeWarpBar = SSA.TimeWarpBar

-- Initialize Data Variables
TimeWarpBar.spellID = 80353
TimeWarpBar.start = 0
TimeWarpBar.duration = 40
TimeWarpBar.condition = function() return true end

TimeWarpBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0)) then
		Auras:RunTimerBarCode(self)
	end
end)

TimeWarpBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,true,CombatLogGetCurrentEventInfo())
end)