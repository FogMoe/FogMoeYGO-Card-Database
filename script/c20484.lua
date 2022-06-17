--侵袭浪潮
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() end
	return a
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetAttackTarget()
	cm.add(Duel.GetAttacker(),e,Duel.GetAttacker():GetControler())
	cm.add(b,e,b and b:GetControler())
end
function cm.add(c,e,tp)
	if not (c and c:IsRelateToBattle(e) and c:IsLevelAbove(1) and c:IsFaceup()) then return end
	local n=c:GetLevel()
	n = n>6 and 3 or (n<5 and 1) or 2
	n = Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>n and n or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.ConfirmDecktop(tp,n)
	n=Duel.GetDecktopGroup(tp,n):FilterCount(Card.IsType,nil,TYPE_MONSTER)
	e=Effect.CreateEffect(e:GetHandler())
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetCode(EFFECT_UPDATE_ATTACK)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e:SetValue(n*300)
	e:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e)
	Duel.ShuffleDeck(tp)
end