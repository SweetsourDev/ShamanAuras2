local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local CloudburstTotemBar = SSA.CloudburstTotemBar

-- Initialize Data Variables
CloudburstTotemBar.spellID = 157153
CloudburstTotemBar.icon = 971076
CloudburstTotemBar.start = 0
CloudburstTotemBar.duration = 15
CloudburstTotemBar.condition = function()
	local _,_,_,selected = GetTalentInfo(6,3,1)
	
	return selected
end

CloudburstTotemBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

CloudburstTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)