--守城投石机
local m=95701
local cm=_G["c"..m]
function c95701.initial_effect(c)
		--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e3)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.atkval)
	e5:SetCondition(cm.indcon)
	c:RegisterEffect(e5)
end
function cm.indcon(e)
	return e:GetHandler():IsDefensePos()
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsPosition(POS_ATTACK)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.cfilter,c:GetControler(),0,LOCATION_MZONE,nil)*100
end
