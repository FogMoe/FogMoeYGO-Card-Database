function c53880.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c53880.target)
	e1:SetOperation(c53880.activate)
	c:RegisterEffect(e1)
end
function c53880.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c53880.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53880.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c53880.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c53880.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53880.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end
