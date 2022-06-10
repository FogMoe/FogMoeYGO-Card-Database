--构现之智
function c11152.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,11152+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11152.con1)
	e1:SetOperation(c11152.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11152,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c11152.cost6)
	e6:SetTarget(c11152.tg6)
	e6:SetOperation(c11152.op6)
	c:RegisterEffect(e6)
--
end
--
function c11152.cfilter1(c)
	return c:IsSetCard(0x6e16) and c:IsAbleToDeckAsCost()
end
function c11152.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c11152.cfilter1,tp,LOCATION_HAND,0,1,nil)
end
function c11152.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c11152.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
--
function c11152.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11152.tg6(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,11165) end
end
function c11152.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11152,1))
	local sg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,11165)
	if sg:GetCount()>0 then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(sg:GetFirst(),SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
--
