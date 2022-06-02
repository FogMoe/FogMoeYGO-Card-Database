--闪星魔女
local m=17012
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,17000) 
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,17000),aux.NonTuner(nil),1,1)
	c:EnableReviveLimit() 
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.atkcon)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)   
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28265983,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.descon2)
	e3:SetTarget(cm.destg2)
	e3:SetOperation(cm.desop2)
	c:RegisterEffect(e3)  
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.atkop1)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
end
function cm.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler() then return end
	if re:GetHandler():GetControler() ~= c:GetControler() and c:IsOnField() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetAttack()>c:GetBaseAttack()
end
function cm.desfilter2(c,num)
	return c:IsFaceup() and c:IsAttackBelow(num)
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lp=c:GetAttack()-c:GetBaseAttack()
	e:SetLabel(lp)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter2,tp,0,LOCATION_MZONE,1,nil,lp) end
	local g=Duel.GetMatchingGroup(cm.desfilter2,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.gselect(g,num)
	return g:GetSum(Card.GetAttack)<=num
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local num=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(e:GetHandler():GetBaseAttack())
	e:GetHandler():RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(cm.desfilter2,tp,0,LOCATION_MZONE,nil,num)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:SelectSubGroup(tp,cm.gselect,false,1,#g,num)
	Duel.Destroy(dg,REASON_EFFECT)
end