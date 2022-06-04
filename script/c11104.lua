--水彩童话·圣诞快乐
function c11104.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11104,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11104+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11104.tg1)
	e1:SetOperation(c11104.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11104,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c11104.cost2)
	e2:SetOperation(c11104.op2)
	c:RegisterEffect(e2)
--
end
--
function c11104.tfilter1(c,e,tp)
	return c:IsSetCard(0x3e16) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11104.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c11104.tfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.RegisterFlagEffect(tp,11101,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11104.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11104.tfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c11104.cfilter2(c)
	return c:IsSetCard(0x3e16) and c:IsType(TYPE_LINK)
		and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c11104.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c11104.cfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.SelectMatchingCard(tp,c11104.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	mg:AddCard(e:GetHandler())
	Duel.Remove(mg,POS_FACEUP,REASON_COST)
end
function c11104.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,11104,0,0,0)
end
--
