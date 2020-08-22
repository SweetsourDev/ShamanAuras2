local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local SpiritWalkBar = SSA.SpiritWalkBar

-- Initialize Data Variables
SpiritWalkBar.spellID = 58875
SpiritWalkBar.start = 0
SpiritWalkBar.duration = 8
SpiritWalkBar.elapsed = 0
SpiritWalkBar.condition = function()
	return IsSpellKnown(58875)
end

SpiritWalkBar:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.1,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
				Auras:RunTimerBarCode(self)
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

SpiritWalkBar:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerEvent_Aura(self,false,CombatLogGetCurrentEventInfo())
	end
end)