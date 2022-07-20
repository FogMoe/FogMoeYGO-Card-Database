--守城士兵
local m=95700
local cm=_G["c"..m]
function c95700.initial_effect(c)
		--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.indtg)
	e3:SetValue(cm.valcon)
	c:RegisterEffect(e3)
	--defence atk
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DEFENSE_ATTACK)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--cannot direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function cm.indtg(e,c)
	return c:GetSequence()<5 and c:IsFaceup()
end
