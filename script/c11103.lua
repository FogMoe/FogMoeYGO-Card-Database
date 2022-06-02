--水彩童话·幻想茶会
function c11103.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11103,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11103+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11103.tg1)
	e1:SetOperation(c11103.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11103,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(0)
	e2:SetCost(c11103.cost2)
	e2:SetTarget(c11103.tg2)
	e2:SetOperation(c11103.op2)
	c:RegisterEffect(e2)
--
end
--
function c11103.tfilter1(c)
	return c:IsSetCard(0x3e16) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11103.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11103.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.RegisterFlagEffect(tp,1175101,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11103.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c11103.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--
function c11103.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c11103.tfilter2(c)
	return c:IsSetCard(0x3e16) and c:IsType(TYPE_XYZ)
		and c:IsAbleToRemoveAsCost()
end
function c11103.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsAbleToRemoveAsCost()
			and Duel.IsExistingMatchingCard(c11103.tfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.SelectMatchingCard(tp,c11103.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if mg:GetCount()>0 then
		e:SetLabelObject(mg:GetFirst())
	end
	mg:AddCard(c)
	Duel.Remove(mg,POS_FACEUP,REASON_COST)
end
function c11103.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.RegisterFlagEffect(tp,tc:GetOriginalCode(),0,0,0)
end
--
