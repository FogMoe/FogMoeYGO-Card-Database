function c10124.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10124)
	e1:SetCondition(c10124.spcon)
	e1:SetTarget(c10124.sptg)
	e1:SetOperation(c10124.spop)
	c:RegisterEffect(e1)
    	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c10124.atkval)
	c:RegisterEffect(e2)
    end
function c10124.spcfilter(c)
	return c:IsFaceup() and c:IsLevel(1) and c:IsRace(RACE_BEAST) and c:IsType(TYPE_NORMAL) and c:IsAbleToGraveAsCost()
end
function c10124.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sg=Duel.GetMatchingGroup(c10124.spcfilter,tp,LOCATION_MZONE,0,nil)
	return sg:CheckSubGroup(aux.mzctcheck,1,1,tp)
end
function c10124.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local sg=Duel.GetMatchingGroup(c10124.spcfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=sg:SelectSubGroup(tp,aux.mzctcheck,true,1,1,tp)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c10124.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function c10124.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x7f7)*-200
end