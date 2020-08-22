local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SpiritLinkTotemBar = SSA.SpiritLinkTotemBar

-- Initialize Data Variables
SpiritLinkTotemBar.spellID = 98008
SpiritLinkTotemBar.icon = 237586
SpiritLinkTotemBar.start = 0
SpiritLinkTotemBar.duration = 6
SpiritLinkTotemBar.elapsed = 0
SpiritLinkTotemBar.condition = function()
	return IsSpellKnown(98008)
end

SpiritLinkTotemBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

SpiritLinkTotemBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Totem(self,CombatLogGetCurrentEventInfo())
	end
end)