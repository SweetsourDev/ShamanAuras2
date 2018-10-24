local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local AncestralProtectionTotemBar = SSA.AncestralProtectionTotemBar

-- Initialize Data Variables
AncestralProtectionTotemBar.spellID = 207399
AncestralProtectionTotemBar.icon = 136080
AncestralProtectionTotemBar.start = 0
AncestralProtectionTotemBar.duration = 30
AncestralProtectionTotemBar.condition = function() 
	local _,_,_,selected = GetTalentInfo(4,3,1)
	
	return selected
end

AncestralProtectionTotemBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self,spec,db)
	end
end)

AncestralProtectionTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
end)