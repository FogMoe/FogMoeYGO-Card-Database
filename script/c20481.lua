--无限皇帝之显现
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.tgf1(c,tp)
	if not (bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() 
		and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)) then return false end
	return Duel.GetReleaseGroup(tp,true):CheckWithSumGreater(Card.GetLevel,math.ceil(c:GetLevel()/2))
end
function cm.tgf2(c,mc)
	return bit.band(c:GetType(),0x82)==0x82 and aux.IsCodeListed(mc,c:GetCode())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local g=Duel.GetReleaseGroup(tp,true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=g:SelectWithSumGreater(tp,Card.GetLevel,math.ceil(tc:GetLevel()/2))
		if not g or #g==0 or Duel.Release(g,REASON_EFFECT)~=#g then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgf2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
		if #g>0 then
			g:AddCard(tc)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
