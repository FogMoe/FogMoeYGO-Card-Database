--灵魂捕获
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tgf1(c,e,tp)
	return c:IsSummonPlayer(tp) and c:IsControlerCanBeChanged() and c:IsCanBeEffectTarget(e)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and cm.tgf1(chkc,e,1-tp) end
	if chk==0 then return eg:IsExists(cm.tgf1,1,nil,e,1-tp) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(cm.tgf1,nil,e,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.opf1(c,e,tp)
	return cm.tgf1(c,e,tp) and c:IsRelateToEffect(e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.opf1,nil,e,1-tp)
	local tc=g:GetFirst()
	if not tc then return end
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.GetControl(tc,tp,PHASE_END,1)
end
