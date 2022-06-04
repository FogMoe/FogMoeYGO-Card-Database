local m=94020
local cm=_G["c"..m]
cm.name="贤者之石"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,94020)
	c:EnableCounterPermit(0xa95)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c94020.target)
	e2:SetOperation(cm.e2activate)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1)
	e4:SetCondition(c94020.drcon)
	e4:SetOperation(c94020.drop)
	c:RegisterEffect(e4)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c94020.conc)
	e3:SetOperation(c94020.counter)
	c:RegisterEffect(e3)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c94020.thtg)
	e5:SetOperation(c94020.thop)
	c:RegisterEffect(e5)
	--des
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c94020.indcon)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--cantbetarget
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c94020.indcon)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--maintain
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCountLimit(1)
	e9:SetOperation(cm.mtop)
	c:RegisterEffect(e9)

end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,300) then
		Duel.PayLPCost(tp,300)
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	end
end

function cm.e2activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0xa95,1)
end
function c94020.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xa95,1) and c:IsCode(94020)
end
function c94020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c94020.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0xa95,1,c) end
end
function c94020.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp and c:IsSetCard(0x9401)
end
function c94020.cfilterdraw(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp and c:IsSetCard(0x9401)
end
function c94020.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c94020.cfilterdraw,1,nil,tp)
end
function c94020.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c94020.sfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c94020.conc(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c94020.cfilter,1,nil,tp)
end
function c94020.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:GetCount()
	if ct>0 then
		e:GetHandler():AddCounter(0xa95,ct,true)
	end
end
function c94020.thfilter1(c,tp)
	local lv=c:GetLevel()*2
	return c:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and lv>0 and c:IsAbleToHand()and Duel.IsCanRemoveCounter(tp,1,0,0xa95,lv,REASON_COST) and c:IsSetCard(0x9401) and c:IsType(TYPE_MONSTER)
end
function c94020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94020.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c94020.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		
		   if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
		
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	if Duel.GetCounter(tp,1,0,0xa95)>=lv*2 then
		Duel.RemoveCounter(tp,1,0,0xa95,lv*2,REASON_COST)
	end
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c94020.thfilter2(c,lv)
	return c:IsLocation(LOCATION_DECK+LOCATION_GRAVE)
		and c:IsLevel(lv) and c:IsAbleToHand() and c:IsSetCard(0x9401)
end
function c94020.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c94020.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c94020.indcon(e)
	return e:GetHandler():GetCounter(0xa95)>0
end
