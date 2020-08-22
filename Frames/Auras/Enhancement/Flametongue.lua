local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local Flametongue = SSA.Flametongue

-- Initialize Data Variables
Flametongue.spellID = 193796
Flametongue.pulseTime = 0
Flametongue.elapsed = 0
Flametongue.condition = function()
	return IsSpellKnown(193796)
end

Flametongue:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local _,_,_,_,buffDuration,expires = Auras:RetrieveAuraInfo('player',194084)
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				
				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,194084,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:SpellRangeCheck(self,self.spellID,true)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration)
				
				--[[if (buff) then
					local timer,seconds = Auras:parseTime((expires or 0) - GetTime(),false,true,groupID)
					
					if (seconds > Auras.db.char.settings[SSA.spec].flametongue) then
						Auras:ToggleOverlayGlow(self.glow,false)
					elseif (seconds <= Auras.db.char.settings[SSA.spec].flametongue and Auras:IsPlayerInCombat(true)) then
						Auras:ToggleOverlayGlow(self.glow,true)
					end
				end]]
				
				if (Auras:IsPlayerInCombat()) then
					self:SetAlpha(1)
				else
					Auras:NoCombatDisplay(self,groupID)
				end
			else
				Auras:ToggleAuraVisibility(self,false,'showhide')
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)