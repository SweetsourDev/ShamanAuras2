local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthenSpikeBar = SSA.EarthenSpikeBar

EarthenSpikeBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,2,7,2)) then
		Auras:RunTimerBarCode(self)
	end
end)

EarthenSpikeBar:HookScript('OnEvent',function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then
		return
	end
	
	local spec = 2
	local timerbar = Auras.db.char.timerbars[spec].bars[self:GetName()]
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID = CombatLogGetCurrentEventInfo()
	
	if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player") and spellID == timerbar.data.spellID) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			timerbar.data.start = GetTime()
			self:Show()
		elseif (subevent == "SPELL_AURA_REMOVED") then
			timerbar.data.start = 0
		end
	end
end)