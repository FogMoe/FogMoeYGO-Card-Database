local m=94170
local cm=_G["c"..m]
cm.name="世界法则 轮回"
function cm.initial_effect(c)
	aux.AddCodeList(c,94020)
	c:SetUniqueOnField(1,0,m)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.con)
	e1:SetCountLimit(1)
	e1:SetCode(EFFECT_TO_DECK_REDIRECT)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)
end
function cm.allneedfilter(c)
	return c:IsFaceup() and c:IsCode(94020)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.allneedfilter,tp,LOCATION_ONFIELD,0,1,nil)
end