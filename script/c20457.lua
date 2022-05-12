--天生合拍
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.cf1,tp,LOCATION_HAND,0,1,nil) and Duel.CheckLPCost(tp,1000) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,cm.cf1,tp,LOCATION_HAND,0,1,1,nil)
		Duel.PayLPCost(tp,1000)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetLabelObject(g:GetFirst())
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetLabelObject()
		local mg=Duel.GetMatchingGroup(cm.cf11,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tc)
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end)
	c:RegisterEffect(e1)
end
function cm.cf1(c,tp)
	return not c:IsPublic() and Duel.IsExistingMatchingCard(cm.cf11,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.cf11(c,mc)
	return c:IsAbleToHand() and aux.IsCodeListed(mc,c:GetCode()) and aux.IsCodeListed(c,mc:GetCode())
end