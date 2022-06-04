--粲辉魔女
local m=17000
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x373)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.addct)
	e1:SetOperation(cm.addc)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	--level
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_UPDATE_LEVEL)
	e11:SetValue(cm.lvval)
	c:RegisterEffect(e11)
	--search
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,0))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCountLimit(1,m)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCost(cm.cost)
	e12:SetTarget(cm.target)
	e12:SetOperation(cm.operation)
	c:RegisterEffect(e12)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
	   if tc:GetOriginalCode()==17000  then
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,0,0,1)
	   end
	   tc=eg:GetNext()
	end
end
function cm.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local ct=Duel.GetFlagEffect(tp,m)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x373)
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local ct=Duel.GetFlagEffect(tp,m)
	if e:GetHandler():IsRelateToEffect(e) and ct>0 then
		e:GetHandler():AddCounter(0x373,ct)
	end
end
function cm.lvval(e,c)
	local tp=c:GetControler()
	return e:GetHandler():GetCounter(0x373)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x373,1,REASON_COST) end
	local t={}
	local i=1
	for i=1,e:GetHandler():GetCounter(0x373) do t[i]=i end
	local a1=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(a1)
	e:GetHandler():RemoveCounter(tp,0x373,e:GetLabel(),REASON_COST)
end
function cm.filter(c)
	return c:IsCode(66917001) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end