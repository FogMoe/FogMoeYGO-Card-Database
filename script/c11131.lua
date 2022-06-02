--梦想绘卷·甜蜜少女
function c11131.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11131.MatFilter,3,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11131.con2)
	e2:SetOperation(c11131.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c11131.efilter4)
	c:RegisterEffect(e4)
--
end
--
function c11131.MatFilter(c)
	return c:IsFusionSetCard(0x3e16)
end
--
function c11131.cfilter2(c,fc)
	return c:IsSetCard(0x3e16) and c:IsAbleToDeckAsCost()
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function c11131.con2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(c11131.cfilter2,tp,LOCATION_HAND+LOCATION_EXTRA,0,3,nil,c)
end
function c11131.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11131.cfilter2,tp,LOCATION_HAND+LOCATION_EXTRA,0,3,3,nil,c)
	c:SetMaterial(sg)
	local lg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #lg>0 then Duel.ConfirmCards(1-tp,lg) end
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
--
function c11131.efilter4(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--