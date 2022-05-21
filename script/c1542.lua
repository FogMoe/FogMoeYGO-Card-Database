local m=1542
local cm=_G["c"..m]
cm.name="时天械八转填充"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.PGYcheck then
		cm.PGYcheck=true
		_PGYEnablePendulumAttribute=aux.EnablePendulumAttribute
		function aux.EnablePendulumAttribute(c,reg)
			local p=c:GetControler()
			if not aux.PendulumChecklist then
				aux.PendulumChecklist=0
				local ge1=Effect.GlobalEffect()
				ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
				ge1:SetOperation(aux.PendulumReset)
				Duel.RegisterEffect(ge1,0)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(1163)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC_G)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_PZONE)
			e1:SetCondition(cm.PendCondition(p))
			e1:SetOperation(cm.PendOperation(p))
			e1:SetValue(SUMMON_TYPE_PENDULUM)
			c:RegisterEffect(e1)
			--register by default
			if reg==nil or reg then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(1160)
				e2:SetType(EFFECT_TYPE_ACTIVATE)
				e2:SetCode(EVENT_FREE_CHAIN)
				e2:SetRange(LOCATION_HAND)
				c:RegisterEffect(e2)
			end
		end
	end
end
function cm.pfilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool) and c:IsSetCard(0x5f30)
		and not c:IsForbidden()
end
function cm.pcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function cm.PendCondition(tp)
	if Duel.GetFlagEffect(tp,1542)==0 then return aux.PendCondition() end
	return  function(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
		if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if rpz==nil or c==rpz then return false end
		local lscale=c:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return false end
		local g=nil
		if og then
			g=og:Filter(Card.IsLocation,nil,loc)
		else
			g=Duel.GetFieldGroup(tp,loc,0)
		end
		local ag=Group.CreateGroup()
		if Duel.GetFlagEffect(tp,1542)~=0 then
			ag=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x5f30)
		end
		g:Merge(ag)
		return g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
	end
end
function cm.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)) 
			or (c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x5f30) and Duel.GetFlagEffect(tp,1542)~=0))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (aux.PendulumChecklist&(0x1<<tp)==0 or aux.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function cm.PendOperation(tp)
	if Duel.GetFlagEffect(tp,1542)==0 then return aux.PendOperation() end
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		local lscale=c:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
		local tg=nil
		local loc=0
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
		local ft=Duel.GetUsableMZoneCount(tp)
		local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		if ect and ect<ft2 then ft2=ect end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 then ft1=1 end
			if ft2>0 then ft2=1 end
			ft=1
		end
		if ft1>0 then loc=loc|LOCATION_HAND end
		if ft2>0 then loc=loc|LOCATION_EXTRA end
		if og then
			tg=og:Filter(Card.IsLocation,nil,loc):Filter(cm.PConditionFilter,nil,e,tp,lscale,rscale,eset)
		else
			tg=Duel.GetMatchingGroup(cm.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
		end
		local ce=nil
		local b1=aux.PendulumChecklist&(0x1<<tp)==0
		local b2=#eset>0
		if b1 and b2 then
			local options={1163}
			for _,te in ipairs(eset) do
				table.insert(options,te:GetDescription())
			end
			local op=Duel.SelectOption(tp,table.unpack(options))
			if op>0 then
				ce=eset[op]
			end
		elseif b2 and not b1 then
			local options={}
			for _,te in ipairs(eset) do
				table.insert(options,te:GetDescription())
			end
			local op=Duel.SelectOption(tp,table.unpack(options))
			ce=eset[op+1]
		end
		if ce then
			tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
		end
		if Duel.GetFlagEffect(tp,1542)~=0 then
			local ag=Duel.GetMatchingGroup(c1542.pfilter,tp,LOCATION_GRAVE,0,nil,e,tp,lscale,rscale,eset)
			tg:Merge(ag)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
		local g=Group.CreateGroup()
		if Duel.GetFlagEffect(tp,1542)~=0 then
			g=tg:SelectSubGroup(tp,c1542.pcheck,true,1,math.min(#tg,ft))
		else
			g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
		end
		aux.GCheckAdditional=nil
		if not g then return end
		if ce then
			Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
			ce:UseCountLimit(tp)
		else
			aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
		end
		sg:Merge(g)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0x5f30)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5f30) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsType(TYPE_FLIP) and c:IsType(TYPE_MONSTER)
end
function cm.thfilter(c)
	return c:IsCode(1530,1540) and c:IsAbleToHand()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_PZONE,0,nil)
	local a0=(ct==0)
	local a1=(ct==1)
	local a2=(ct==2)
	local b0=(Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))
	local b1=(Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil))
	local b2=(Duel.GetFlagEffect(tp,1542)==0 and (aux.PendulumChecklist&(0x1<<tp)==0 or #eset~=0))
	return ((a0 and b0) or (a1 and b1) or (a2 and b2))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_PZONE,0,nil)
	local a0=(ct==0)
	local a1=(ct==1)
	local a2=(ct==2)
	local b0=(Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0)
	local b1=(Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil))
	local b2=(Duel.GetFlagEffect(tp,1542)==0 and (aux.PendulumChecklist&(0x1<<tp)==0 or #eset~=0))
	if a0 and b0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	end
	if a1 and b1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_PZONE,0,nil)
	local ct=g:GetCount()
	local a0=(ct==0)
	local a1=(ct==1)
	local a2=(ct==2)
	local b0=(Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0)
	local b1=(Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil))
	local b2=(Duel.GetFlagEffect(tp,1542)==0 and (aux.PendulumChecklist&(0x1<<tp)==0 or #eset~=0))
	if a0 and b0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 and tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	if a1 and b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if a2 and b2 then
		Duel.RegisterFlagEffect(tp,1542,RESET_PHASE+PHASE_END,0,1)
	end
end