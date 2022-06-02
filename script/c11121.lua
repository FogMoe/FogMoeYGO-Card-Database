--水彩童话·灵魂绘曲
function c11121.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11121,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11121.con1)
	e1:SetOperation(c11121.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11121,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11121)
	e2:SetLabel(0)
	e2:SetCost(c11121.cost2)
	e2:SetTarget(c11121.tg2)
	e2:SetOperation(c11121.op2)
	c:RegisterEffect(e2)
--
end
--
function c11121.cfilter1(c)
	return c:IsSetCard(0x3e16) and c:IsAbleToGraveAsCost()
end
function c11121.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c11121.cfilter1,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c11121.cfilter1,tp,LOCATION_EXTRA,0,1,nil)
end
function c11121.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg1=Duel.SelectMatchingCard(tp,c11121.cfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local mg2=Duel.SelectMatchingCard(tp,c11121.cfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
	mg1:Merge(mg2)
	Duel.SendtoGrave(mg1,REASON_COST)
end
--
function c11121.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c11121.tfilter2(c)
	return c:IsSetCard(0x3e16) and c:GetType()==TYPE_SPELL
		and c:IsAbleToGraveAsCost()
end
function c11121.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c11121.tfilter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=Duel.SelectMatchingCard(tp,c11121.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if mg:GetCount()>0 then
		e:SetLabelObject(mg:GetFirst())
		Duel.SendtoGrave(mg,REASON_COST)
	end
end
function c11121.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:GetActivateEffect() then
		local te=tc:GetActivateEffect():Clone()
		te:SetType(EFFECT_TYPE_IGNITION)
		te:SetRange(LOCATION_MZONE)
		te:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		c:RegisterEffect(te)
	end
end
--
