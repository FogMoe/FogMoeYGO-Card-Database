--水彩童话·女仆咖啡
function c11120.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11120,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e1:SetCost(c11120.cost1)
	e1:SetTarget(c11120.tg1)
	e1:SetOperation(c11120.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11120,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11120)
	e2:SetTarget(c11120.tg2)
	e2:SetOperation(c11120.op2)
	c:RegisterEffect(e2)
--
end
--
function c11120.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c11120.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return end
		return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_EXTRA,0,1,nil,0x3e16)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local mg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_EXTRA,0,1,1,nil,0x3e16)
	if mg:GetCount()<1 then return end
	if mg:GetFirst():IsAbleToGraveAsCost()
		and Duel.SelectYesNo(tp,aux.Stringid(11120,1)) then
		Duel.SendtoGrave(mg,REASON_COST)
	else
		Duel.ConfirmCards(1-tp,mg)
	end
	e:SetLabel(mg:GetFirst():GetAttribute())
end
function c11120.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1_1:SetValue(e:GetLabel())
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1_1)
	end
end
--
function c11120.tfilter2(c)
	return c:IsSetCard(0x3e16) and c:IsAbleToDeck()
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c11120.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c11120.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and g:GetClassCount(Card.GetCode)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11120.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local mg=Duel.GetOperatedGroup()
	if mg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if mg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--
