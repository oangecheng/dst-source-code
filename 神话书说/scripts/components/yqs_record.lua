local __Q_O__0G_o_II1_L__=td1madao_sv()local QO0_GoI_I1_l={}QO0_GoI_I1_l[1]=__Q_O__0G_o_II1_L__({239,251,262,266})QO0_GoI_I1_l[2]=__Q_O__0G_o_II1_L__({233,265,248,250})__Q_O__0G_o_II1_L__=QO0_GoI_I1_l;local Q_O0__G__OI__I__1_l_=Class(function(self,__QO_0_GO__I_I__1L_)self[QO0_GoI_I1_l[1]]=__QO_0_GO__I_I__1L_;self[QO0_GoI_I1_l[2]]=false end)function Q_O0__G__OI__I__1_l_:IsFull()return self[QO0_GoI_I1_l[2]]end;function Q_O0__G__OI__I__1_l_:SetFull()self[QO0_GoI_I1_l[2]]=true end;function Q_O0__G__OI__I__1_l_:OnSave()return{full=self[QO0_GoI_I1_l[2]]}end;function Q_O0__G__OI__I__1_l_:OnLoad(Q__O_0_G__O__I__i__1__L_)if Q__O_0_G__O__I__i__1__L_ and Q__O_0_G__O__I__i__1__L_[QO0_GoI_I1_l[2]]then self[QO0_GoI_I1_l[2]]=Q__O_0_G__O__I__i__1__L_[QO0_GoI_I1_l[2]]end end;return Q_O0__G__OI__I__1_l_