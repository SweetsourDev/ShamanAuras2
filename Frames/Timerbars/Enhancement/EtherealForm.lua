local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EtherealFormBar = SSA.EtherealFormBar

-- Initialize Data Variables
EtherealFormBar.spellID = 210918
EtherealFormBar.start = 0
EtherealFormBar.duration = 15
EtherealFormBar.condition = function()
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(1944)

	return selected and Auras:IsPvPZone()
end

EtherealFormBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

EtherealFormBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
end)