local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local floor = math.floor
local pairs = pairs
local twipe = table.wipe

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local Enum = Enum
local GetSpellCooldown, GetSpellInfo = GetSpellCooldown, GetSpellInfo
local IsEquippedItem = IsEquippedItem
local UnitPower = UnitPower

-- Cache Global Addon Variables
local CrashLightning = SSA.CrashLightning

-- Initialize Data Variables
CrashLightning.spellID = 187874
CrashLightning.auraID = 242286
CrashLightning.pulseTime = 0
CrashLightning.elapsed = 0
CrashLightning.condition = function()
	return IsSpellKnown(187874)
end
CrashLightning.GetT21SetCount = function()
	local numSetPieces = 0
	local setPieces = {
		[147178] = true, -- Helm
		[147180] = true, -- Shoulders
		[147176] = true, -- Cloak
		[147175] = true, -- Chest
		[147177] = true, -- Hands
		[147179] = true, -- Legs
	}
	
	for setID in pairs(setPieces) do
		if (IsEquippedItem(setID)) then
			numSetPieces = numSetPieces + 1
		end
	end
	
	twipe(setPieces)
	
	return numSetPieces
end

CrashLightning:SetScript('OnUpdate', function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			--local power = UnitPower('player',Enum.PowerType.Maelstrom)
			local _,_,_,_,buffDuration,expires = Auras:RetrieveAuraInfo('player', 187878)
			local buff,_,count,_,dur,expire = Auras:RetrieveAuraInfo('player', self.auraID)
			
			if (self.GetT21SetCount() >= 4) then
				local name,_,icon = GetSpellInfo(self.auraID)
				
				if (not self.T21) then
					local T21Frame = CreateFrame('Frame','LightningCrash',self)
					T21Frame:SetFrameStrata('MEDIUM')
					T21Frame:SetWidth(smIcon)
					T21Frame:SetHeight(smIcon)
					T21Frame:SetPoint("CENTER",self,"TOPRIGHT",0,0)
					
					T21Frame.texture = T21Frame:CreateTexture(nil,'BACKGROUND')
					T21Frame.texture:SetTexture(icon)
					T21Frame.texture:SetAllPoints(T21Frame)
					
					T21Frame.CD = CreateFrame('Cooldown','LightningCrashCD',T21Frame,'CooldownFrameTemplate')
					T21Frame.CD:SetAllPoints(T21Frame)
					T21Frame.CD:SetHideCountdownNumbers(true)
					
					T21Frame.CD.text = T21Frame.CD:CreateFontString(nil,'MEDIUM','GameFontHighlightLarge')
					T21Frame.CD.text:SetAllPoints(T21Frame.CD)
					--T21Frame.CD.text:Set
					T21Frame.CD.text:SetTextColor(1,1,0,1)
					--T21Frame.CD.text:SetFont(LSM.MediaTable.font['PT Sans Narrow'] or LSM.DefaultMedia.font)
					
					T21Frame.glow = CreateFrame('Frame','LightningCrashGlow',T21Frame)
					T21Frame.glow:SetPoint("CENTER",0,0)
					T21Frame.glow:SetWidth(smGlow)
					T21Frame.glow:SetHeight(smGlow)
					
					
					T21Frame:Show()
					self.T21 = T21Frame
				else
					local size = floor(Auras.db.char.auras[2].groups[groupID].icon * 0.78125)
					
					self.T21:SetSize(size,size)
					self.T21.glow:SetSize((size+10),(size+10))
					
					if (dur or 0 > 2) then
						local strt = expire - dur
						--Auras:ExecuteCooldown(self.T21,strt,dur,true,true,2)
						--Auras:CooldownHandler(self,2,'primary',1,start,duration)
						self.T21.CD:SetCooldown(strt,dur)
						self.T21.CD.text:SetText(count)
						--self.T21.CD.text:SetText(11)
						Auras:ToggleOverlayGlow(self.T21.glow,true)
						self.T21:SetAlpha(1)
					else
						Auras:ToggleOverlayGlow(self.T21.glow,false)
						self.T21:SetAlpha(0)
					end
					
				end
			end
		
			Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,187878,"buff")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,start,duration)
			
			if (Auras:IsPlayerInCombat(true)) then
				self:SetAlpha(1)
				--[[local powerCost = GetSpellPowerCost(self.spellID)
				if (power >= powerCost[1].cost) then
					self:SetAlpha(1)
					--self.texture:SetVertexColor(1,1,1,1)
				else
					self:SetAlpha(0.5)
					--self.texture:SetVertexColor(1,1,1,0.5)
				end]]
			else
				Auras:NoCombatDisplay(self,groupID)
			end
		else
			Auras:ToggleAuraVisibility(self,false,'showhide')
		end
	else
		self.elapsed = self.elapsed + elapsed
	end
end)