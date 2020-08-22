local SSA, Auras = unpack(select(2,...))

-- Totem Mastery Notification
local LightningShield = CreateFrame('Frame','LightningShield',SSA.AuraBase,BackdropTemplateMixin and "BackdropTemplate")
LightningShield:SetPoint('CENTER',0,-210)
LightningShield:SetWidth(300)
LightningShield:SetHeight(135)
LightningShield:SetFrameStrata('BACKGROUND')
LightningShield:RegisterForDrag('LeftButton')
LightningShield:SetAlpha(0)
LightningShield:Show()

LightningShield.header = LightningShield:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
LightningShield.header:SetFont([[Interface\AddOns\ShamanAuras2\Media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
LightningShield.header:SetPoint('TOPLEFT',LightningShield,"TOPLEFT",5,5)
LightningShield.header:SetTextColor(1,1,1,1)
LightningShield.header:SetText(GetSpellInfo(210643))
LightningShield.header:Hide()
				
LightningShield.texture = LightningShield:CreateTexture(nil,'LOW')
--LightningShield.texture:SetTexture([[Textures\SpellActivationOverlays\Echo_of_the_Elements]])
LightningShield.texture:SetTexture(467696)
LightningShield.texture:SetPoint('CENTER',LightningShield,'CENTER',0,10)
LightningShield.texture:SetWidth(LightningShield:GetHeight() * 2)
LightningShield.texture:SetHeight(LightningShield:GetWidth() * 0.6)
--LightningShield.texture:SetRotation(rad(-90))
LightningShield.texture:SetAlpha(0.7)

-- Animation for Totem Mastery Notification Texture
LightningShield.Flash = LightningShield.texture:CreateAnimationGroup()
LightningShield.Flash:SetLooping('BOUNCE')

LightningShield.Flash.fadeIn = LightningShield.Flash:CreateAnimation('Alpha')
LightningShield.Flash.fadeIn:SetFromAlpha(1)
LightningShield.Flash.fadeIn:SetToAlpha(0.4)
LightningShield.Flash.fadeIn:SetDuration(0.4)

LightningShield.Flash.fadeOut = LightningShield.Flash:CreateAnimation('Alpha')
LightningShield.Flash.fadeOut:SetFromAlpha(0.4)
LightningShield.Flash.fadeOut:SetToAlpha(1)
LightningShield.Flash.fadeOut:SetDuration(0.4)
LightningShield.Flash.fadeOut:SetEndDelay(0)

LightningShield:SetScript('OnUpdate',function(self)
	if (not Auras.db.char.isFirstEverLoad) then
		local spec = GetSpecialization()

		local remaining = 0
		local isRefresh = false
		--local buff = UnitBuff('player',Auras:GetSpellName(202192))
		local buff,_,_,_,_,expires = Auras:RetrieveAuraInfo("player", 192106)
		--local _,mainExpires,_,mainEnchantID,_,offExpires,_,offEnchantID = GetWeaponEnchantInfo()

		local db = Auras.db.char
	
		self:SetPoint(db.elements[spec].frames[self:GetName()].point,SSA[db.elements[spec].frames[self:GetName()].relativeTo],db.elements[spec].frames[self:GetName()].relativePoint,db.elements[spec].frames[self:GetName()].x,db.elements[spec].frames[self:GetName()].y)
		Auras:ToggleFrameMove(self,Auras.db.char.settings.move.isMoving)
		Auras:ToggleAuraVisibility(self,true,'showhide')

		remaining = (expires or 0) - GetTime()

		if ((remaining or 0) <= db.settings[spec].lightningShield) then
			isRefresh = true
		end

		if (((isRefresh or not buff) and db.elements[spec].frames.LightningShield.isEnabled and SSA.isFlametongue) or db.settings.move.isMoving) then
			self:SetAlpha(1)
			
			if (not self.Flash:IsPlaying()) then
				self.Flash:Play()
			end
			if (UnitAffectingCombat('player')) then
				self.Flash.fadeOut:SetToAlpha(0.6)
				self.Flash.fadeIn:SetFromAlpha(1)
			else
				self.Flash.fadeOut:SetToAlpha(0.3)
				self.Flash.fadeIn:SetFromAlpha(0.6)
			end
		else
			self:SetAlpha(0)
			
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
		end
		
		--Auras:ToggleFrameMove(self,db.elements[spec].isMoving)
	--else
		--Auras:ToggleAuraVisibility(self,false,'showhide')
	--end
	end
end)

LightningShield:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

LightningShield:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		local spec = GetSpecialization()

		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[spec].frames[self:GetName()])
	end
end)

_G["SSA_LightningShield"] = LightningShield