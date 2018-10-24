local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthenSpikeBar = SSA.EarthenSpikeBar

-- Initialize Data Variables
EarthenSpikeBar.spellID = 188089
EarthenSpikeBar.start = 0
EarthenSpikeBar.duration = 10
EarthenSpikeBar.condition = function()
	local _,_,_,selected = GetTalentInfo(7,2,1)
	
	return selected
end

EarthenSpikeBar:SetScript('OnUpdate',function(self)
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingTimerbar(self)) then
		Auras:RunTimerBarCode(self)
	end
end)

EarthenSpikeBar:HookScript('OnEvent',function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end

	local timerbar = Auras.db.char.timerbars[2].bars[self:GetName()]
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player") and spellID == self.spellID) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			self.start = GetTime()
			self:Show()
		elseif (subevent == "SPELL_AURA_REMOVED") then
			self.start = 0
		end
	end
end)