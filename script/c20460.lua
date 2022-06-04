--法则女神 姬氏
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetTarget(cm.tg)
	e4:SetCost(cm.cos)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.tg(e,te,tp)
	return te:GetHandler():IsType(TYPE_MONSTER) and te:GetHandler():IsAttribute(e:GetHandler():GetAttribute())
end
function cm.cos(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end