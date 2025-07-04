/* ASM HEMT Model Version 101.5.0 released by Sourabh Khandelwal on 08-15-2024
Copyright 2024 Sourabh Khandelwal
Copyright 2023 Sourabh Khandelwal
Copyright 2022 Sourabh Khandelwal
Copyright 2021 Sourabh Khandelwal
Copyright 2020 Sourabh Khandelwal and Indian Institute of Technology Kanpur
Copyright 2019 Sourabh Khandelwal and Indian Institute of Technology Kanpur
Copyright 2018 Sourabh Khandelwal and Indian Institute of Technology Kanpur
Copyright 2014 Sourabh Khandelwal and Indian Institute of Technology Kanpur
Copyright 2013 Norwegian University of Science and Technology Trondheim and Indian Institute of Technology Kanpur
Copyright 2012 Norwegian University of Science and Technology Trondheim

Current Authors: Sourabh Khandelwal, Fredo Chavez, and Nikhil Reddy
Previous Developers: Aamir Hasan, Sudip Ghosh, Avirup Dasgupta, Yogesh Chauhan
Contact: sourabh.khandelwal@mq.edu.au, sourabhkhandelwal@gmail.com
*/
/*
ASM HEMT model is supported by the members of Silicon Integration Initiative's Compact Model Coalition. A link to the most recent version of this
standard can be found at: http://www.si2.org/cmc
*/
`include "disciplines.vams"
`include "constants.vams"

////////// Numerical and Physical Constants //////////
`define DOS 3.240e17           //Density of states, Reference M. Shur Plenum Press 1987, GaAs Device and Circuits
`define ep_psi 0.3             //Smoothing Constant
`define Oneby3 0.33333333333333333
`define Twoby3 0.66666666666666667
`define EXPL_THRESHOLD 80.0
`define MAX_EXPL 5.540622384e+34
`define MIN_EXPL 1.804851387e-35
`define KboQ 8.617087e-5       // J/deg
`define Dexp_lim 80.0
////////// Macros for the model/instance parameters //////////
/*
 MPRxx    model    parameter real
 MPIxx    model    parameter integer
 IPRxx    instance parameter real
 IPIxx    instance parameter integer
    ||
    cc    closed lower bound, closed upper bound
    oo    open   lower bound, open   upper bound
    co    closed lower bound, open   upper bound
    oc    open   lower bound, closed upper bound
    cz    closed lower bound=0, open upper bound=inf
    oz    open   lower bound=0, open upper bound=inf
    nb    no bounds
    ex    no bounds with exclude
    sw    switch(integer only, values  0=false  and  1=true)
    ty    switch(integer only, values -1=p-type and +1=n-type)

 IPM   instance parameter mFactor(multiplicity, implicit for LRM2.2)
 OPP   operating point parameter, includes units and description for printing
 */

`define OPP(nam,uni,des)               (*units=uni,                   desc=des*)           real    nam;
`define OPM(nam,uni,des)               (* desc=des, units=uni, multiplicity="multiply" *)  real    nam;
`define OPD(nam,uni,des)               (* desc=des, units=uni, multiplicity="divide"   *)  real    nam;
`define MPRnb(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter real    nam=def;
`define MPRex(nam,def,uni,exc,    des) (*units=uni,                   desc=des*) parameter real    nam=def exclude exc;
`define MPRcc(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter real    nam=def from[lwr:upr];
`define MPRoo(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter real    nam=def from(lwr:upr);
`define MPRco(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter real    nam=def from[lwr:upr);
`define MPRoc(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter real    nam=def from(lwr:upr];
`define MPRcz(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter real    nam=def from[  0:inf);
`define MPRoz(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter real    nam=def from(  0:inf);
`define MPInb(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter integer nam=def;
`define MPIex(nam,def,uni,exc,    des) (*units=uni,                   desc=des*) parameter integer nam=def exclude exc;
`define MPIcc(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter integer nam=def from[lwr:upr];
`define MPIoo(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter integer nam=def from(lwr:upr);
`define MPIco(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter integer nam=def from[lwr:upr);
`define MPIoc(nam,def,uni,lwr,upr,des) (*units=uni,                   desc=des*) parameter integer nam=def from(lwr:upr];
`define MPIcz(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter integer nam=def from[  0:inf);
`define MPIoz(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter integer nam=def from(  0:inf);
`define MPIsw(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter integer nam=def from[  0:  1];
`define MPIty(nam,def,uni,        des) (*units=uni,                   desc=des*) parameter integer nam=def from[ -1:  1] exclude 0;
`define IPRnb(nam,def,uni,        des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def ;
`define IPRex(nam,def,uni,exc,    des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def exclude exc;
`define IPRcc(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def from[lwr:upr];
`define IPRoo(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def from(lwr:upr);
`define IPRco(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def from[lwr:upr);
`define IPRoc(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def from(lwr:upr];
`define IPRcz(nam,def,uni,        des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def from[  0:inf);
`define IPRoz(nam,def,uni,        des) (*units=uni, type="instance",  desc=des*) parameter real    nam=def from(  0:inf);
`define IPInb(nam,def,uni,        des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def;
`define IPIex(nam,def,uni,exc,    des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def exclude exc;
`define IPIcc(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def from[lwr:upr];
`define IPIoo(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def from(lwr:upr);
`define IPIco(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def from[lwr:upr);
`define IPIoc(nam,def,uni,lwr,upr,des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def from(lwr:upr];
`define IPIcz(nam,def,uni,        des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def from[  0:inf);
`define IPIoz(nam,def,uni,        des) (*units=uni, type="instance",  desc=des*) parameter integer nam=def from(  0:inf);

/*
Not all Verilog-A compilers are able to properly collapse internal nodes. To ensure minimal node
count, comment out the following lines:
*/

`define __FP1MOD__
`define __FP2MOD__
`define __FP3MOD__
`define __FP4MOD__
`define __FP1SMOD__
`define __FP2SMOD__
`define __FP3SMOD__
`define __FP4SMOD__
////////// Function for VG0 Calculation //////////
`define VG0(l,w,Voff_dibl_temp,imin,Vgs,Vtv,Vg0) \
t0     = l/(2.0*w*`P_Q*`DOS*Vtv*Vtv); \
vgmin  = Voff_dibl_temp + Vtv*ln(t0*imin); \
vggmin = 0.5*((Vgs-vgmin) + sqrt((Vgs-vgmin)*(Vgs-vgmin) + 1.0e-4)) + vgmin; \
Vg0    = vggmin - Voff_dibl_temp;

////////// Function for PSIS Calculation //////////
`define PSIS(Cg,Vg0,GAMMA0Ival,GAMMA1Ival,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis) \
beta   = Cg/(`P_Q*`DOS*Vtv); \
ALPHAN = `M_E/beta; \
ALPHAD = 1.0/beta; \
Cch    = Cg/`P_Q; \
vgop   = 0.5*Vg0 + 0.5*sqrt(Vg0*Vg0 + 4.0*`ep_psi*`ep_psi); \
vgon   = vgop*ALPHAN/(sqrt(vgop*vgop + ALPHAN*ALPHAN)); \
vgod   = vgop*ALPHAD/(sqrt(vgop*vgop + ALPHAD*ALPHAD)); \
Hx     = (vgop + Vtv*(1.0-ln(beta*vgon)) - (GAMMA0Ival/3.0)*pow(Cch*vgop,`Twoby3))/(vgop*(1.0+(Vtv/vgod)) + ((2.0*GAMMA0Ival)/3.0)*pow(Cch*vgop,`Twoby3)); \
t0     = (Vg0/(2.0*Vtv)); \
if (t0 < 200.0) begin  \
    t1  = lexp(t0/4.0); \
    t2  = lexp(-3.0*t0/4.0); \
    nsx = (2.0*Vtv*(Cch)*((3.0*t0/4.0)+ln(t1 + t2)))/((1.0/Hx) + (Cch/`DOS)*lexp((-1.0*Vg0)/(2.0*Vtv))); \
end else begin  \
    nsx = (2.0*Vtv*(Cch)*((1.0*t0/1.0)))/((1.0/Hx) + (Cch/`DOS)*lexp((-1.0*Vg0)/(2.0*Vtv))); \
end \
ef1 = Vg0 - nsx/Cch; \
if (abs(ef1-Vg0) > 1.0e-19) begin \
    vgef1    = Vg0 - ef1; \
    vgef1    = 0.5*vgef1 + 0.5*sqrt(vgef1*vgef1 + 4.0*1.0e-9*1.0e-9); \
    t0       = pow(Cch,`Twoby3); \
    t1       = pow(vgef1,`Twoby3); \
    t2       = pow(vgef1,-`Oneby3); \
    vgef23g0 = GAMMA0Ival*t0*t1; \
    vgef23g1 = GAMMA1Ival*t0*t1; \
    tg0      = (ef1/Vtv) - (vgef23g0/Vtv); \
    tg1      = (ef1/Vtv) - (vgef23g1/Vtv); \
    t4       = Cch*vgef1 - `DOS*Vtv*ln_exp_plus_1(tg0) - `DOS*Vtv*ln_exp_plus_1(tg1); \
    vgefm13g0 = GAMMA0Ival*t0*t2; \
    vgefm13g1 = GAMMA1Ival*t0*t2; \
    t5ng0     = lexp(tg0)*`DOS*(1.0 + `Twoby3*vgefm13g0); \
    t5dg0     = 1.0 + lexp(tg0); \
    t5ng1     = lexp(tg1)*`DOS*(1.0 + `Twoby3*vgefm13g1); \
    t5dg1     = 1.0 + lexp(tg1); \
    t5        = -1.0*Cch - (t5ng0/t5dg0) - (t5ng1/t5dg1); \
    ef2       = ef1 - (t4/t5); \
    vgef2     = Vg0 - ef2; \
    vgef2     = 0.5*vgef2 + 0.5*sqrt(vgef2*vgef2 + 4.0*1.0e-9*1.0e-9); \
    t3        = pow(vgef2,-`Oneby3); \
    vgef223g0 = GAMMA0Ival*t0*pow(vgef2,`Twoby3); \
    vgef223g1 = GAMMA1Ival*t0*pow(vgef2,`Twoby3); \
    tg02      = (ef2/Vtv) - (vgef223g0/Vtv); \
    tg12      = (ef2/Vtv) - (vgef223g1/Vtv); \
    t42       = Cch*vgef2 - `DOS*Vtv*ln_exp_plus_1(tg02) - `DOS*Vtv*ln_exp_plus_1(tg12); \
    vgefm213g0 = GAMMA0Ival*t0*t3; \
    vgefm213g1 = GAMMA1Ival*t0*t3; \
    t5ng02     = lexp(tg02)*`DOS*(1.0 + `Twoby3*vgefm213g0); \
    t5dg02     = 1.0 + lexp(tg02); \
    t5ng12     = lexp(tg12)*`DOS*(1.0 + `Twoby3*vgefm213g1); \
    t5dg12     = 1.0 + lexp(tg12); \
    t52        = -1.0*Cch - (t5ng02/t5dg02) - (t5ng12/t5dg12); \
    ef3        = ef2 - (t42/t52); \
    psis       = ef3 ; \
end else begin \
    psis       = ef1 ; \
end

////////// Function for PSID Calculation //////////
`define PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,U0val,ute,VSATval,at,Cg,psis,Vg0,Vbs,ua,ub,uc,l,Vds,GAMMA0Ival, GAMMA1Ival,   mulf_tdev,Vdeff,psid) \
mulf_tdev = U0val*pow((Tdev/Tnom),ute); \
vsat_tdev = VSATval*pow((Tdev/Tnom),at); \
t0        = (Cg/epsilon)*abs(Vg0 - psis); \
t1        = (Cepi/epsilon)*abs(Vbs - psis); \
mu_eff    = mulf_tdev/(1.0 + ua*(t0) + ub*(t0*t0) + uc*(t1)); \
t0        = 2.0*vsat_tdev/mu_eff; \
t1        = 0.5*Vg0 + 0.5*sqrt(Vg0*Vg0 + 4.0*`ep_psi*`ep_psi); \
Vdsat     = t0*l*t1/(t0*l + t1 ); \
t0        = pow(Vds/Vdsat, delta); \
t1        = pow(1.0 + t0,-1.0/delta); \
Vdeff     = Vds * t1; \
Vgdeff    = Vg0 - Vdeff; \
vgod      = Vgdeff; \
vgodp     = 0.5*vgod + 0.5*sqrt(vgod*vgod + 4.0*`ep_psi*`ep_psi); \
vgop      = vgodp ; \
dvgon     = vgop*ALPHAN/(sqrt(vgop*vgop + ALPHAN*ALPHAN)); \
dvgod     = vgop*ALPHAD/(sqrt(vgop*vgop + ALPHAD*ALPHAD)); \
Hx        = (vgop + Vtv*(1.0-ln(beta*dvgon)) - (GAMMA0Ival/3.0)*pow(Cch*vgop,`Twoby3))/(vgop*(1.0+(Vtv/dvgod)) + ((2.0*GAMMA0Ival)/3.0)*pow(Cch*vgop,`Twoby3)); \
t0        = (vgod/(2.0*Vtv)); \
if (t0 < 200.0) begin  \
    t1 = lexp(t0/4.0); \
    t2 = lexp(-3.0*t0/4.0); \
    ndx = (2.0*Vtv*(Cch)*((3.0*t0/4.0)+ln(t1 + t2)))/((1.0/Hx) + (Cch/`DOS)*lexp((-1.0*vgod)/(2.0*Vtv))); \
end else begin  \
    ndx = (2.0*Vtv*(Cch)*((1.0*t0/1.0)))/((1.0/Hx) + (Cch/`DOS)*lexp((-1.0*vgod)/(2.0*Vtv))); \
end \
ef1 = vgod - ndx/Cch; \
if (abs(ef1-vgod)>1.0e-19) begin \
    vgef1 = vgod - ef1; \
    vgef1 = 0.5*vgef1 + 0.5*sqrt(vgef1*vgef1 + 4.0*1.0e-9*1.0e-9); \
    t0    = pow(Cch,`Twoby3) ; \
    t1    = pow(vgef1,`Twoby3) ; \
    t2    = pow(vgef1,-`Oneby3) ; \
    vgef23g0 = GAMMA0Ival*t0*t1; \
    vgef23g1 = GAMMA1Ival*t0*t1; \
    tg0      = (ef1/Vtv) - (vgef23g0/Vtv); \
    tg1      = (ef1/Vtv) - (vgef23g1/Vtv); \
    t4       = Cch*vgef1 - `DOS*Vtv*ln_exp_plus_1(tg0) - `DOS*Vtv*ln_exp_plus_1(tg1); \
    vgefm13g0 = GAMMA0Ival*t0*t2; \
    vgefm13g1 = GAMMA1Ival*t0*t2; \
    t5ng0     = lexp(tg0)*`DOS*(1.0 + `Twoby3*vgefm13g0); \
    t5dg0     = 1.0 + lexp(tg0); \
    t5ng1     = lexp(tg1)*`DOS*(1.0 + `Twoby3*vgefm13g1); \
    t5dg1     = 1.0 + lexp(tg1); \
    t5        = -1.0*Cch - (t5ng0/t5dg0) - (t5ng1/t5dg1); \
    ef2       = ef1 - (t4/t5); \
    vgef2     = vgod - ef2; \
    vgef2     = 0.5*vgef2 + 0.5*sqrt(vgef2*vgef2 + 4.0*1.0e-9*1.0e-9); \
    vgef223g0 = GAMMA0Ival*t0*pow(vgef2,`Twoby3); \
    vgef223g1 = GAMMA1Ival*t0*pow(vgef2,`Twoby3); \
    tg02      = (ef2/Vtv) - (vgef223g0/Vtv); \
    tg12      = (ef2/Vtv) - (vgef223g1/Vtv); \
    t42       = Cch*vgef2 - `DOS*Vtv*ln_exp_plus_1(tg02) - `DOS*Vtv*ln_exp_plus_1(tg12); \
    vgefm213g0 = GAMMA0Ival*t0*pow(vgef2,-`Oneby3); \
    vgefm213g1 = GAMMA1Ival*t0*pow(vgef2,-`Oneby3); \
    t5ng02     = lexp(tg02)*`DOS*(1.0 + `Twoby3*vgefm213g0); \
    t5dg02     = 1.0 + lexp(tg02); \
    t5ng12     = lexp(tg12)*`DOS*(1.0 + `Twoby3*vgefm213g1); \
    t5dg12     = 1.0 + lexp(tg12); \
    t52        = -1.0*Cch - (t5ng02/t5dg02) - (t5ng12/t5dg12); \
    ef3        = ef2 - (t42/t52); \
    psid       = ef3 + Vdeff ; \
end else begin \
    psid       = ef1 + Vdeff ; \
end


////// Function for Surface potential calculation

`define Surface_potential(Tdev, Tnom, epsilon, delta, beta, ALPHAN, ALPHAD, Vtv, Cch, Cepi, u0, u0glag, ute, vsat, vsatglag, at, Cg, psis, Vg0, Vbs, ua, ub, uc, l, Vds, gamma0i, gamma1i, mulf_tdev, Vdeff, psid, Vdsx, w, nf, asl, kasl, nsl, knsl, bvdsl, kbvdsl, Vdsx_bv, kt1, voff_trap, voff_cap, mult_i, sigvds, gdsmin_t, di, si, Ids, isl) \
	begin \
		real u0_i = u0 - u0glag; \
		real vsat_i = vsat - vsatglag; \
		`PSID(Tdev, Tnom, epsilon, delta, beta, ALPHAN, ALPHAD, Vtv, Cch, Cepi, u0_i, ute, vsat_i, at, Cg, psis, Vg0, Vbs, ua, ub, uc, l, Vds, gamma0i, gamma1i, mulf_tdev, Vdeff, psid) \
		real psim = 0.5 * (psis + psid); \
		real psisd = psid - psis; \
		`IDS(Vg0, psim, psisd, Cg, Cepi, l, Vdsx, w, nf, Vtv, mulf_tdev, Vdeff, Ids) \
		real aslt = asl * (1.0 + kasl * ((Tdev / Tnom) - 1.0)); \
		real nslt = nsl * (1.0 + knsl * ((Tdev / Tnom) - 1.0)); \
		real bvdslt = bvdsl * (1.0 + kbvdsl * ((Tdev / Tnom) - 1.0)); \
		`IDIO(aslt, nslt, 1.0, (Vdsx_bv - bvdslt), isl) \
		I(di, si) <+ mult_i * sigvds * Ids + mult_i * gdsmin_t * V(di, si); \
		I(d, s) <+ mult_i * sigvds * (w * nf * isl); \
	end

////////// Function for IDS Calculation //////////
`define IDS(Vg0,psim,psisd,Cg,Cepi,l,Vdsx,w,nf,Vtv,mulf_tdev,Vdeff,   Ids) \
ids0   = (Vg0 - psim + Vtv)*(psisd); \
t0     = (Cg/epsilon)*abs(Vg0 - psim); \
t1        = (Cepi/epsilon)*abs(Vbs - psis); \
mu_eff = mulf_tdev/(1.0 + ua*(t0) + (ub*t0*t0) + uc*t1) ; \
Geff   = (mu_eff*Cg*w*nf)/(l); \
Geff_clm = Geff*(1.0 + lambda*(Vdsx-Vdeff)); \
vf       = sqrt(1.0 + thesat*thesat*psisd*psisd) ; \
G_vf     = Geff_clm/vf; \
Ids      = G_vf*(ids0);

////////// Function for QGI Calculation //////////
`define QGI(Vg0,psis,psid,psim,Cg,l,QM0Ival,BDOSIval,ADOSIval,TBARval,Vtv,w,nf,   Cg_qme,qgint) \
t1 = psid - psis; \
t2 = Vg0 + Vtv - psim; \
t3 = (Cg*w*nf*l)*(Vg0 - psim + 0.5*t1*t1/(6.0*t2)); \
T0 = 1.0e+26 * (t3/QM0Ival); \
T1 = 1.0 + pow(T0, BDOSIval); \
XDCinv = ADOSIval / T1; \
Cg_qme = epsilon/(TBARval + XDCinv); \
qgint = (Cg_qme*w*nf*l)*(Vg0 - psim + 0.5*t1*t1/(6.0*t2));

////////// Function for QDI Calculation //////////
`define QDI(Vg0,psim,psis,psid,psisd,l,Vtv,w,nf,Cg_qme,   qdint) \
t0 = Vg0 + Vtv - psim ; \
t1 = (psis + 2.0*psid)/3.0 ; \
t2 = (1.0/12.0)*(psisd*psisd)/t0 ; \
t3 = (1.0/120.0)*(psisd*psisd*psisd)/(t0*t0) ; \
qdint = -(Cg_qme*w*l*nf*0.5)*(Vg0 - t1 + t2 + t3) ;

`define ISL(Vdsx,Vth,w,nf,asl,nsl,bvdsl,  isl) \
t0 = lexp((Vdsx-bvdsl)/(nsl*Vth)); \
t1 = lexp((-bvdsl)/(nsl*Vth)); \
isl = w*nf*asl*(t0 - t1);

//////// Function for parameter calculation ////////////
`define PCAL(vinp,vmax,pin,ptune, pout)   \  //Hars  used in the trap 
t0 = vinp*vmax; \
t1 = sqrt(vinp*vinp + vmax*vmax); \
pout = abs(ptune*pin)*(t0/t1);    \


//////// Function for saturation effect modeling in non-linear access region resistance ////////
`define isat(Ids,isatacc,ar, idseff) \
tmp=1.0+(ar); \
kv=sqrt(tmp)*(Ids); \
kvv=kv/(isatacc); \
kvv2=kvv*2.0; \
tmp=tmp+kvv*kvv; \
tmp=sqrt(tmp-kvv2)+sqrt(tmp+kvv2); \
idseff=kv*2.0/tmp;

////////// Hars: Capacitance calculation
`define DEVICE_MODEL_CALCS(Vdsx, cdscd, cdscd_trap, Tdev,voff, voffdlag, voffglag, eta0, eta0_trap, eta0_cap, vdscale,Tnom, gdsmin, tgdsmin, kt1, voff_trap, voff_cap, Vbs, asub, \
                            Cg, Cepi, cdsc, Vtv, Voff_dibl, tempr, gdsmin_t, Voff_dibl_temp) \
    Cg = epsilon / tbar; \
    Cepi = epsilon / tepi; \
    cdsc = 1.0 + nfactor + (cdscd + cdscd_trap) * Vdsx; \
    Vtv = `KboQ * Tdev * cdsc; \
    Voff_dibl = voff + voffdlag + voffglag - (eta0 + eta0_trap - eta0_cap) * \
                (Vdsx * vdscale) / sqrt(Vdsx * Vdsx + vdscale * vdscale); \
    tempr = Tdev / Tnom; \
    gdsmin_t = gdsmin - tgdsmin * (tempr - 1.0); \
    Voff_dibl_temp = Voff_dibl - (tempr - 1.0) * kt1 + voff_trap + voff_cap +(Cepi / (Cepi + Cg)) * asub * Vbs;


//////// Function for diode current gatemod=3 ///////////////////////////////////////////////////

`define IDIO3(isat,nn,an,ud,vbi,rnn,ebreak,risat,  id) \
if (isat > 0.0) begin \
    mud  = hypmax(ud,0.0,0.001); \
    if (ud > 0) begin \
        arg = pow(ud,an)/(nn*Vth); \
    end else begin \
        arg = ud/(nn*Vth); \
    end \
    if (arg > `Dexp_lim) begin \
        le = (1.0 + (arg - `Dexp_lim)); \
        arg = `Dexp_lim; \
    end else begin \
        le = 1.0; \
    end \
    le = le*exp(arg); \
    id = isat*(le-1.0)*exp(-vbi/(nn*Vth)); \
    mud  = hypmax(-ud,0.0,0.001); \
    narg = (sqrt(mud)+ebreak)/(rnn*Vth); \
    if (narg > `Dexp_lim) begin \
        nle = (1.0 + (narg - `Dexp_lim)); \
        narg = `Dexp_lim; \
    end else begin \
        nle = 1.0; \
    end \
    nle = 1.0 + mud*risat*nle*exp(narg); \
    id = id*nle; \
end else begin \
    id = 0.0; \
end

`define IDIO(isat,nn,an,ud,  id) \
if (isat > 0.0) begin \
    if (ud > 0) begin \
        arg = pow(ud,an)/(nn*Vth); \
        if (arg > `Dexp_lim) begin \
            le = (1.0 + (arg - `Dexp_lim)); \
            arg = `Dexp_lim; \
        end else begin \
            le = 1.0; \
        end \
        le = le*exp(arg); \
        id = isat*(le-1.0); \
    end else begin \
        arg = ud/(nn*Vth); \
        if (arg > `Dexp_lim) begin \
            le = (1.0 + (arg - `Dexp_lim)); \
            arg = `Dexp_lim; \
        end else begin \
            le = 1.0; \
        end \
        le = le*exp(arg); \
        id = isat*(le-1.0); \
    end \
end else begin \
    id = 0.0; \
end
/*
Model Schematic:


                                                               O (g) Gate
                                                               |
                                                           Gate Resistor
                                                               |
                                                               O (gi)           Source (s) connected
                                                               |                        O
                                                        |---------------|               |
                                                        |               |               |
                                                    |-------|       |-------|       |-------|
                                                    |       |       |       |       |       |
                          O--------/\/\/\/\----O----|       |---O---|       |---O---|       |---O------/\/\/\/\----------O
                  Source (s)       S ACC RES  (si)  MAIN HEMT  (di)    FP1    (fp1)    FP2    (fp2)   D ACC RES         (d) Drain
                                                        |
                                                        |
                                                        O (b) Substrate



*/

module asmhemt(d, g1, g2, s1, s2, b1, b2, dt); //Hars
    inout d, g1, g2, s1, s2, b1, b2, dt; //Hars
    electrical d, g1, g2, s1, s2, b1, b2; //Hars
    electrical trap1_1, trap2_1, trap1_2, trap2_2; //Hars
    electrical di, si_1, si_2, gi_1, gi_2, gin; //Hars
    electrical n1, nt, n2, ntg; //Hars
    thermal dt1; //Hars


////////// Node Conditioning For Field-plates //////////
    `ifdef __FP1MOD__
        electrical fp1;
    `endif

    `ifdef __FP1MOD__
        `define IntrinsicDrain_fp1 fp1
    `else
        `define IntrinsicDrain_fp1 di
    `endif
///////////////////////////////
    `ifdef __FP2MOD__
        electrical fp2;
    `endif

    `ifdef __FP2MOD__
        `define IntrinsicDrain_fp2 fp2
    `else
        `define IntrinsicDrain_fp2 `IntrinsicDrain_fp1
    `endif
//////////////////////////////
    `ifdef __FP3MOD__
        electrical fp3;
    `endif

    `ifdef __FP3MOD__
        `define IntrinsicDrain_fp3 fp3
    `else
        `define IntrinsicDrain_fp3 `IntrinsicDrain_fp2
    `endif
//////////////////////////////
    `ifdef __FP4MOD__
        electrical fp4;
    `endif

    `ifdef __FP4MOD__
        `define IntrinsicDrain_fp4 fp4
    `else
        `define IntrinsicDrain_fp4 `IntrinsicDrain_fp3
    `endif
/////////////////////////////////////////////////////
    `ifdef __FP1SMOD__
        electrical fp1s;
    `endif

    `ifdef __FP1SMOD__
        `define IntrinsicSource_fp1s fp1s
    `else
        `define IntrinsicSource_fp1s si
    `endif
/////////////////////////////////////////////////////
    `ifdef __FP2SMOD__
        electrical fp2s;
    `endif

    `ifdef __FP2SMOD__
        `define IntrinsicSource_fp2s fp2s
    `else
        `define IntrinsicSource_fp2s `IntrinsicSource_fp1s
    `endif
//////////////////////////////////////////////////////
    `ifdef __FP3SMOD__
        electrical fp3s;
    `endif

    `ifdef __FP3SMOD__
        `define IntrinsicSource_fp3s fp3s
    `else
        `define IntrinsicSource_fp3s `IntrinsicSource_fp2s
    `endif
    //////////////////////////////////////////////////////
    `ifdef __FP4SMOD__
        electrical fp4s;
    `endif

    `ifdef __FP4SMOD__
        `define IntrinsicSource_fp4s fp4s
    `else
        `define IntrinsicSource_fp4s `IntrinsicSource_fp3s
    `endif
////////// Clamped Exponential Function //////////
    analog function real lexp;
        input x;
        real x;
        begin
            if (x > `EXPL_THRESHOLD) begin
                lexp = `MAX_EXPL * (1.0+(x)-`EXPL_THRESHOLD);
            end else if (x < -`EXPL_THRESHOLD) begin
                lexp = `MIN_EXPL;
            end else begin
                lexp = exp(x);
            end
        end
    endfunction

////////// Hyperbolic Smoothing Functions (max) //////////
    analog function real hypmax;
        input x , xmin, c;
        real x , xmin, c;
        begin
            hypmax  = xmin + x - 0.5 * (xmin + x - sqrt((x-xmin)*(x-xmin)+c));
        end
    endfunction

////////// Smoothing Function To Fix A Minimum Value //////////
    analog function real smoothminx;
        input x, x0, dx;
        real x, x0, dx;
        begin
            smoothminx = 0.5*(x + x0 + sqrt((x - x0)*(x - x0) + 0.25*dx*dx));
        end
    endfunction

////////// Smoothing Function To Fix A Maximum Value //////////
    analog function real smoothmax;
        input x, x0, dx;
        real x, x0, dx;
        begin
            smoothmax = 0.5*(x + x0 - sqrt((x - x0)*(x - x0) + dx*dx)-(x0 - sqrt(x0*x0 + dx*dx)));
        end
    endfunction
/////////// ln(lexp(arg) + 1) function /////////////////////////
    analog function real ln_exp_plus_1;
        input x; real x;
        begin
            if (x >= 37) begin
                ln_exp_plus_1 = x;
            end else if (x <= -37) begin
                ln_exp_plus_1 = 0;
            end else begin
                ln_exp_plus_1 = ln(exp(x) + 1);
            end
        end
    endfunction
////////// Branches Self-heating //////////
    branch (dt) rth;
    branch (dt) ith;

////////// List Of Model Parameters //////////
    `MPRco(tnom           ,27.0           ,"deg C"       ,-`P_CELSIUS0,inf         ,"Nominal Temperature in degree Celsius")
    `MPRco(tbar           ,2.5e-8         ,"m"           ,0.1e-9      ,inf         ,"Barrier layer thickness")
    `MPRco(tepi           ,1.64e-6        ,"m"           ,0.1e-9      ,inf         ,"GaN epi layer thickness")
    `IPRco(l              ,0.25e-6        ,"m"           ,20e-9       ,inf         ,"Channel Length")
    `IPRco(w              ,200.0e-6       ,"m"           ,20e-9       ,inf         ,"Channel Width of a finger")
    `IPIco(nf             ,1              ,""            ,1.0         ,inf         ,"Number of fingers")
    `IPRco(mult_i         ,1.0            ,""            ,0.0         ,inf         ,"MULT factor for current")
    `IPRco(mult_q         ,1.0            ,""            ,0.0         ,inf         ,"MULT factor for charge")
    `IPRco(mult_fn        ,mult_i         ,""            ,0.0         ,inf         ,"MULT factor for noise")
    `MPRoo(epsilon        ,10.66e-11      ,"F/m"         ,0.0         ,inf         ,"Dielectric Permittivity of AlGaN layer")
    `MPRcc(voff           ,-2.0           ,"V"           ,-100.0      ,5           ,"Cut-off voltage")
    `MPRcc(asub           ,0.0            ,"V/V"         ,-100.0      ,100         ,"Parameter for substrate coupling effects")
    `MPRoo(ksub           ,0.0            ,"V/V"         ,-inf        ,inf         ,"Parameter for substrate coupling effects")
    `MPRco(u0             ,170.0e-3       ,"m^2/(V * s)" ,0.0         ,inf         ,"Low field mobility")
    `MPRco(ua             ,0.0e-9         ,"V^-1"        ,0.0         ,inf         ,"Mobility Degradation coefficient first order")
    `MPRco(ub             ,0.0e-18        ,"V^-2"        ,0.0         ,inf         ,"Mobility Degradation coefficient second order")
    `MPRco(uc             ,0.0e-9         ,"V^-1"        ,0.0         ,inf         ,"Mobility Degradation coefficient with Vb")
    `MPRco(vsat           ,1.9e5          ,"m/s"         ,1.0e3       ,inf         ,"Saturation Velocity")
    `MPRco(delta          ,2.0            ,""            ,2.0         ,inf         ,"Exponent for Vdeff")
    `MPRoo(at             ,0.0            ,""            ,-inf        ,inf         ,"Temperature Dependence for saturation velocity")
    `MPRcc(ute            ,-0.5           ,""            ,-10.0       ,0           ,"Temperature dependence of mobility")
    `MPRco(lambda         ,0.0            ,"V^-1"        ,0.0         ,inf         ,"Channel Length Modulation Coefficient")
    `MPRco(eta0           ,1.0e-9         ,""            ,0.0         ,inf         ,"DIBL Parameter")
    `MPRoo(vdscale        ,5.0            ,"V"           ,0.0         ,inf         ,"DIBL Scaling VDS")
    `MPRoo(kt1            ,0.0e-3         ,""            ,-inf        ,inf         ,"Temperature Dependence for Voff")
    `MPRco(thesat         ,1.0            ,"V^-2"        ,1.0         ,inf         ,"Velocity Saturation Parameter")
    `MPRco(nfactor        ,0.5            ,""            ,0.0         ,inf         ,"Sub-voff Slope parameters")
    `MPRco(cdscd          ,1.0e-3         ,""            ,0.0         ,inf         ,"Sub-voff Slope Change due to Drain Voltage")
    `MPRcc(gamma0i        ,2.12e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter")
    `MPRcc(gamma1i        ,3.73e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter")
    `MPRoo(imin           ,1.0e-15        ,"A"           ,0.0         ,inf         ,"Minimum Drain Current")
////////// Self Heating Model Parameters //////////
    `MPIsw(shmod          ,1              ,""                                      ,"Switch to turn on and off self-heating model")
    `MPRco(rth0           ,5.0            ,"K/w"         ,0.0         ,inf         ,"Thermal Resistance")
    `MPRco(cth0           ,1.0e-9         ,"s*w/K"       ,0.0         ,inf         ,"Thermal Capacitance")
////////// Access Region Resistance Model Parameters //////////
    `MPIsw(rdsmod         ,0              ,""                                      ,"Switch for external source and drain resistances")
    `MPRoo(vsataccs       ,50.0e3         ,"cm/s"        ,0.0         ,inf         ,"Saturation Velocity for access region: Source Side")
    `MPRco(ns0accs        ,5.0e17         ,"C/m^-2"      ,1.0e5       ,inf         ,"2-DEG Charge Density in per square meter in Source access region")
    `MPRco(ns0accd        ,5.0e17         ,"C/m^-2"      ,1.0e5       ,inf         ,"2-DEG Charge Density in per square meter in Drain access region")
    `MPRco(k0accs         ,0.0            ,""            ,0.0         ,inf         ,"Vg dependence parameter of source side access region 2-DEG charge density")
    `MPRco(k0accd         ,0.0            ,""            ,0.0         ,inf         ,"Vg dependence parameter of drain side access region 2-DEG charge density")
    `MPRoo(u0accs         ,155e-3         ,"m^2/(V * s)" ,0.0         ,inf         ,"Access region mobility source-side")
    `MPRoo(u0accd         ,155e-3         ,"m^2/(V * s)" ,0.0         ,inf         ,"Access region mobility drain-side")
    `MPRoo(mexpaccs       ,2.0            ,""            ,0.0         ,inf         ,"Exponent for access region resistance model")
    `MPRoo(mexpaccd       ,2.0            ,""            ,0.0         ,inf         ,"Exponent for access region resistance model")
    `MPRoo(ard            ,1.0            ,""            ,0.0         ,inf         ,"Saturation tuning for access region resistance model")
    `MPRoo(ars            ,1.0            ,""            ,0.0         ,inf         ,"Saturation tuning for access region resistance model")
    `MPRco(lsg            ,1.0e-6         ,"m"           ,0.0         ,inf         ,"Length of Source-Gate Access Region")
    `MPRco(ldg            ,1.0e-6         ,"m"           ,0.0         ,inf         ,"Length of Drain-Gate Access Region or Length of drain side access region")
    `MPRco(rsc            ,1.0e-4         ,"ohm*m"       ,0.0         ,inf         ,"Source Contact Resistance")
    `MPRco(rdc            ,1.0e-4         ,"ohm*m"       ,0.0         ,inf         ,"Drain Contact Resistance")
    `MPRco(kns0           ,0.0            ,""            ,0.0         ,inf         ,"Temperature Dependence for 2-DEG charge density at access region")
    `MPRoo(ats            ,0.0            ,""            ,-inf        ,inf         ,"Temperature Dependence for saturation velocity at access region")
    `MPRoo(utes           ,0.0            ,""            ,-inf        ,inf         ,"Temperature dependence of mobility at access region: Source Side")
    `MPRoo(uted           ,0.0            ,""            ,-inf        ,inf         ,"Temperature dependence of mobility at access region: Drain Side")
    `MPRco(krsc           ,0.0            ,""            ,0.0         ,inf         ,"Temperature dependence of Source Contact Resistance")
    `MPRco(krdc           ,0.0            ,""            ,0.0         ,inf         ,"Temperature dependence of Drain Contact Resistance")
    `MPIcc(gatemod        ,0              ,""            ,0           ,3           ,"Model Switch to turn on and off the gate current formulations")
////////// Gate current Model Parameters (MOD) //////////
    `MPRoo(njgs           ,2.5            ,""            ,0.0         ,50.0        ,"Gate-source junction diode current ideality factor")
    `MPRoo(ags            ,1.0            ,""            ,0.0         ,50.0        ,"GATEMOD=3 parameter for ideality factor change with bias G-S diode")
    `MPRoo(agd            ,1.0            ,""            ,0.0         ,50.0        ,"GATEMOD=3 parameter for ideality factor change with bias G-D diode")
    `MPRoo(njgd           ,2.5            ,""            ,0.0         ,50.0        ,"Gate-drain junction diode current ideality factor")
    `MPRoo(rnjgs          ,80.0           ,""            ,0.0         ,inf         ,"Gate-source junction diode rev. current slope factor")
    `MPRoo(rnjgd          ,80.0           ,""            ,0.0         ,inf         ,"Gate-drain junction diode rev. current slope factor")
    `MPRco(igsdio         ,1.0e-12        ,"A/m^2"       ,0.0         ,inf         ,"Gate-source junction diode saturation current")
    `MPRco(igddio         ,1.0e-12        ,"A/m^2"       ,0.0         ,inf         ,"Gate-drain junction diode saturation current")
    `MPRco(rigsdio        ,1.0e-15        ,"A/m^2"       ,0.0         ,inf         ,"Gate-source junction diode rev. current frenkel-poole multiplier")
    `MPRco(rigddio        ,1.0e-15        ,"A/m^2"       ,0.0         ,inf         ,"Gate-drain junction diode  rev. current frenkel-poole multiplier")
    `MPRoo(vbis           ,1e-4           ,"V"           ,0.0         ,inf         ,"Gate-source junction diode built-in voltage")
    `MPRoo(vbid           ,1e-4           ,"V"           ,0.0         ,inf         ,"Gate-drain junction diode built-in voltage")
    `MPRco(ebreaks        ,0.0            ,"V^0.5"       ,0.0         ,inf         ,"Fitting parameter for large rev bias gate current")
    `MPRco(ebreakd        ,0.0            ,"V^0.5"       ,0.0         ,inf         ,"Fitting parameter for large rev bias gate current")
    `MPRoo(ktgs           ,0.0            ,""            ,-inf        ,inf         ,"Temperature co-efficient of gate-source junction diode current")
    `MPRoo(ktgd           ,0.0            ,""            ,-inf        ,inf         ,"Temperature coefficient of gate-drain junction diode current")
    `MPRoo(rktgs          ,0.0            ,""            ,-inf        ,inf         ,"Temperature co-efficient of reverse gate-source junction diode current")
    `MPRoo(rktgd          ,0.0            ,""            ,-inf        ,inf         ,"Temperature coefficient of reverse gate-drain junction diode current")
    `MPRoo(ktvbis         ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient for built-in voltage source side")
    `MPRoo(ktvbid         ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient for built-in voltage drain side")
    `MPRoo(ktnjgs         ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient forward slope source-side")
    `MPRoo(ktnjgd         ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient forward slope drain-side")
    `MPRoo(ktrnjgs        ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient reverse slope source-side")
    `MPRoo(ktrnjgd        ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient reverse slope drain-side")
    `MPIcc(trapmod        ,0              ,""            ,0            ,5          ,"Model Switch to turn on and off the dynamic trapping effects")
////////// Trap Model For RF trapmod=4 //////////
    `MPRoo(remi           ,1.0            ,""            ,0.0         ,inf         ,"Drain lag emission resistance")
    `MPRoo(cglag          ,10.0e-6        ,""            ,0.0         ,inf         ,"Gate lag trapping capacitance")
    `MPRoo(remig          ,1.0            ,""            ,0.0         ,inf         ,"Gate lag trapping resistance")
    `MPRoo(arcap          ,0.0            ,""            ,-inf        ,inf         ,"Drain lag trap potential tuning parameter")
    `MPRoo(brcap          ,0.5            ,""            ,0.0         ,inf         ,"Drain lag trap potential tuning parameter")
    `MPRoo(arcapg         ,0.0            ,""            ,-inf        ,inf         ,"Gate lag trap potential tuning parameter")
    `MPRoo(brcapg         ,0.5            ,""            ,0.0         ,inf         ,"Gate lag trap potential tuning parameter")
    `MPRoo(vdlmax         ,20.0           ,""            ,0.0         ,inf         ,"Drain lag parameter for limiting parameter change")
    `MPRoo(vglmax         ,5.0            ,""            ,0.0         ,inf         ,"Gate lag parameter for limiting parameter change")
    `MPRoo(dlvoff         ,0e-4           ,""            ,-inf        ,inf         ,"Voff tuning due to drain lag")
    `MPRoo(glvoff         ,0e-4           ,""            ,-inf        ,inf         ,"Voff tuning due to gate lag")
    `MPRoo(glu0           ,0e-4           ,""            ,-inf        ,inf         ,"U0 tuning due to drain lag")
    `MPRoo(glvsat         ,0e-4           ,""            ,-inf        ,inf         ,"VSAT tuning due to gate lag")
    `MPRoo(dlns0s         ,0e-4           ,""            ,-inf        ,inf         ,"Source-side 2-deg tune due to drain lag")
    `MPRoo(dlns0d         ,0e-4           ,""            ,-inf        ,inf         ,"Drain-side 2-deg tune due to gate-lag")
////////// Trap model parameters for trapmod=4 and trapmod=1
    `MPRoo(cdlag          ,1.0e-6         ,""            ,0.0         ,inf         ,"Trap Network capacitance, shared parameter trapmod=1 and 4")
    `MPRoo(rdlag          ,1.0e6          ,""            ,0.0         ,inf         ,"Trap Network resistance, shared parameter trapmod=1 and 4")
/////////  Trap model parameters for trapmod=1
    `MPRoo(idio           ,1.0e0          ,"A"           ,0.0         ,inf         ,"Saturation Current parameter for trap model")
    `MPRoo(atrapvoff      ,0.1            ,""            ,-inf        ,inf         ,"Voff change due to trapping effects")
    `MPRoo(btrapvoff      ,0.3            ,""            ,-inf        ,inf         ,"Voff change with input power due to trapping effects")
    `MPRoo(atrapeta0      ,0              ,""            ,-inf        ,inf         ,"DIBL change due to trapping effects")
    `MPRoo(btrapeta0      ,0.05           ,""            ,-inf        ,inf         ,"DIBL change with input power due to trapping effects")
    `MPRoo(atraprs        ,0.1            ,""            ,-inf        ,inf         ,"Rs change due to trapping effects")
    `MPRoo(btraprs        ,0.6            ,""            ,-inf        ,inf         ,"Rs change with input power due to trapping effects")
    `MPRoo(atraprd        ,0.5            ,""            ,-inf        ,inf         ,"Rd change due to trapping effects")
    `MPRoo(btraprd        ,0.6            ,""            ,-inf        ,inf         ,"Rd change with input power due to trapping effects")
////////// Trap Model Parameters for Pulse IV trapmod=2 //////////
    `MPRoo(rtrap1         ,1.0            ,"ohm"         ,0.0         ,inf         ,"Trap Network1 Resistance")
    `MPRoo(rtrap2         ,1.0            ,"ohm"         ,0.0         ,inf         ,"Trap Network2 Resistance")
    `MPRco(ctrap1         ,10.0e-6        ,"F"           ,0.0         ,inf         ,"Trap Network1 Capacitance")
    `MPRco(ctrap2         ,1.0e-6         ,"F"           ,0.0         ,inf         ,"Trap Network2 Capacitance")
    `MPRoo(a1             ,0.1            ,""            ,-inf        ,inf         ,"Multiplication factor [1st network]")
    `MPRoo(vofftr         ,1.0e-9         ,""            ,-inf        ,inf         ,"Trap contribution to voff [2nd network]")
    `MPRoo(cdscdtr        ,1.0e-15        ,""            ,-inf        ,inf         ,"Trap contribution to cdscd [2nd network]")
    `MPRoo(eta0tr         ,1.0e-15        ,""            ,-inf        ,inf         ,"Trap contribution to DIBL [2nd network]")
    `MPRoo(rontr1         ,1.0e-12        ,""            ,-inf        ,inf         ,"Trap contribution to RON [1st network]")
    `MPRoo(rontr2         ,1.0e-13        ,""            ,-inf        ,inf         ,"Trap contribution to RON [2nd network]")
    `MPRoo(rontr3         ,1.0e-13        ,""            ,-inf        ,inf         ,"Trap contribution to RON")
////////// Trap Model Parameters Dynamic On Resistance For Power Devices trapmod=3 //////////
    `MPRoo(rtrap3         ,1.0            ,"ohm"         ,0.0         ,inf         ,"Trap Network Resistance")
    `MPRco(ctrap3         ,1.0e-4         ,"F"           ,0.0         ,inf         ,"Trap Network Capacitance")
    `MPRoo(vatrap         ,10.0           ,""            ,0.0         ,inf         ,"Division factor for V[trap1]")
    `MPRoo(sct            ,1.0            ,""            ,0.0         ,inf         ,"Slope parameter for ct variation with Vgs")
    `MPRoo(wd             ,0.016          ,""            ,-inf        ,inf         ,"Weak dependence of vdlr1 on Vdg")
    `MPRoo(vdlr1          ,2.0            ,""            ,-inf        ,inf         ,"Slope for region one")
    `MPRoo(vdlr2          ,20.0           ,""            ,-inf        ,inf         ,"Slope for region two")
    `MPRoo(talpha         ,1.0            ,""            ,-inf        ,inf         ,"Temperature dependence Coefficient")
    `MPRco(vtb            ,250.0          ,"V"           ,0.0         ,inf         ,"Break Point for Vdg effect on Von")
    `MPRco(deltax         ,0.01           ,""            ,0.0         ,inf         ,"Smoothing parameter")
///////// Trap model TRAPMOD=5 parameters                                          ////////////
    `MPRoo(alphax         ,0.0            ,""           ,-inf         ,inf         ,"Vgs dependence of trapping")
    `MPRoo(alphaxd        ,0.0            ,""           ,-inf         ,inf         ,"Vgd dependence of trapping")
    `MPRoo(betax          ,0.05           ,""           ,-inf         ,inf         ,"Vd dependence of trapping")
    `MPRoo(gammax         ,0.0            ,""           ,-inf         ,inf         ,"Steady state trapping voltage parameter")
    `MPRoo(etax           ,0.0            ,""           ,-inf         ,inf         ,"Steady state trapping voltage parameter")
    `MPRoo(eno            ,1.0e4          ,""           ,-inf         ,inf         ,"Time dependence of trapping")
    `MPRoo(cx             ,1e-7            ,""          ,-inf         ,inf         ,"Time dependence of trapping")
    `MPRoo(vxmax          ,0.5            ,""           ,-inf         ,inf         ,"Max limit for trapping voltage")
    `MPRoo(ea             ,0.5            ,""           ,-inf         ,inf         ,"Trap activation energy in eV")
    `MPRoo(alphay         ,0.0            ,""           ,-inf         ,inf         ,"Vgs dependence of 2nd trapping model")
    `MPRoo(alphayd        ,0.0            ,""           ,-inf         ,inf         ,"Vgd dependence of 2nd trapping model")
    `MPRoo(betay          ,0.05           ,""           ,-inf         ,inf         ,"Vd dependence of 2nd trapping model")
    `MPRoo(gammay         ,0.0            ,""           ,-inf         ,inf         ,"Steady state trapping voltage parameter for 2nd trap model")
    `MPRoo(etay           ,0.0            ,""           ,-inf         ,inf         ,"Steady state trapping voltage parameter for 2nd trap model")
    `MPRoo(eno1           ,1.0e4          ,""           ,-inf         ,inf         ,"Time dependence of trapping of 2nd trap model")
    `MPRoo(cy             ,1e-7           ,""           ,-inf         ,inf         ,"Time dependence of trapping of 2nd trap model")
    `MPRoo(vymax          ,0.5            ,""           ,-inf         ,inf         ,"Max limit for trapping voltage of 2nd trap model")
    `MPRoo(ea1            ,0.5            ,""           ,-inf         ,inf         ,"Trap activation energy in eV for 2nd trap model")
    `MPRoo(glns0s         ,0e-4           ,""           ,-inf         ,inf         ,"Source-side 2-deg tune with trap potential trapmod=5")
    `MPRoo(glns0d         ,0e-4           ,""           ,-inf         ,inf         ,"Drain-side 2-deg tune with trap potential trapmod=5")
////////// Field Plate Region Parameters //////////
    `MPIcc(fastfpmod      ,0              ,""            ,0           ,1           ,"Fast field-plate model formulations [0:Conventional FP model; 1: Fast model calculations]")
    `MPIcc(fp1mod         ,0              ,""            ,0           ,2           ,"Drain-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPIcc(fp1smod        ,0              ,""            ,0           ,2           ,"Source-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPIcc(fp2mod         ,0              ,""            ,0           ,2           ,"Drain-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPIcc(fp2smod        ,0              ,""            ,0           ,2           ,"Source-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPIcc(fp3mod         ,0              ,""            ,0           ,2           ,"Drain-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPIcc(fp3smod        ,0              ,""            ,0           ,2           ,"Source-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPIcc(fp4mod         ,0              ,""            ,0           ,2           ,"Drain-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPIcc(fp4smod        ,0              ,""            ,0           ,2           ,"Source-side Field Plate Model Selector [0:No FP; 1:Gate FP; 2:Source FP;]")
    `MPRoo(iminfp1        ,1.0e-15        ,"A"           ,0.0         ,inf         ,"Minimum Drain Current FP1 region")
    `MPRcc(vofffp1        ,-25.0          ,"V"           ,-500.0      ,5           ,"voff for FP1")
    `IPRco(dfp1           ,50.0e-9        ,"m"           ,0.1e-9      ,inf         ,"Distance of FP1 from 2-DEG Charge")
    `IPRoo(lfp1           ,1.0e-6         ,"m"           ,0.0         ,inf         ,"Length of FP1")
    `MPRoo(ktfp1          ,50.0e-3        ,""            ,-inf        ,inf         ,"Temperature Dependence for vofffp1")
    `MPRco(u0fp1          ,100e-3         ,"m^2/(V * s)" ,0.0         ,inf         ,"FP1 region mobility")
    `MPRco(vsatfp1        ,100e+3         ,"m/s"         ,0.0         ,inf         ,"Saturation Velocity of FP1 region")
    `MPRco(nfactorfp1     ,0.5            ,""            ,0.0         ,inf         ,"Sub-voff Slope parameters for FP1")
    `MPRco(cdscdfp1       ,0.0            ,""            ,0.0         ,inf         ,"Sub-voff Slope Change due to Drain Voltage for FP1")
    `MPRco(eta0fp1        ,1.0e-9         ,""            ,0.0         ,inf         ,"DIBL Parameter for FP1")
    `MPRoo(vdscalefp1     ,10.0           ,"V"           ,0.0         ,inf         ,"DIBL Scaling VDS for FP1")
    `MPRcc(gamma0fp1      ,2.12e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP1")
    `MPRcc(gamma1fp1      ,3.73e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP1")
    `MPRoo(iminfp2        ,1.0e-15        ,"A"           ,0.0         ,inf         ,"Minimum Drain Current FP2 region")
    `MPRcc(vofffp2        ,-80.0          ,"V"           ,-100.0      ,5           ,"voff for FP2")
    `IPRco(dfp2           ,100.0e-9       ,"m"           ,0.1e-9      ,inf         ,"Distance of FP2 from 2-DEG Charge")
    `IPRoo(lfp2           ,1.0e-6         ,"m"           ,0.0         ,inf         ,"Length of FP2")
    `MPRoo(ktfp2          ,50.0e-3        ,""            ,-inf        ,inf         ,"Temperature Dependence for vofffp2")
    `MPRco(u0fp2          ,100e-3         ,"m^2/(V * s)" ,0.0         ,inf         ,"Carrier mobility of FP2 region")
    `MPRco(vsatfp2        ,100e+3         ,"m/s"         ,0.0         ,inf         ,"Saturation velocity of FP2 region")
    `MPRco(nfactorfp2     ,0.5            ,""            ,0.0         ,inf         ,"Sub-voff Slope parameters for FP2")
    `MPRco(cdscdfp2       ,0.0            ,""            ,0.0         ,inf         ,"Sub-voff Slope Change due to Drain Voltage for FP2")
    `MPRco(eta0fp2        ,1.0e-9         ,""            ,0.0         ,inf         ,"DIBL Parameter for FP2")
    `MPRoo(vdscalefp2     ,10.0           ,"V"           ,0.0         ,inf         ,"DIBL Scaling VDS for FP2")
    `MPRcc(gamma0fp2      ,2.12e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP2")
    `MPRcc(gamma1fp2      ,3.73e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP2")
    `MPRoo(iminfp3        ,1.0e-15        ,"A"           ,0.0         ,inf         ,"Minimum Drain Current FP3 region")
    `MPRcc(vofffp3        ,-75.0          ,"V"           ,-500.0      ,5           ,"voff for FP3")
    `IPRco(dfp3           ,150.0e-9       ,"m"           ,0.1e-9      ,inf         ,"Distance of FP3 from 2-DEG Charge")
    `IPRoo(lfp3           ,1.0e-6         ,"m"           ,0.0         ,inf         ,"Length of FP3")
    `MPRoo(ktfp3          ,50.0e-3        ,""            ,-inf        ,inf         ,"Temperature Dependence for vofffp3")
    `MPRco(u0fp3          ,100e-3         ,"m^2/(V * s)" ,0.0         ,inf         ,"FP3 region mobility")
    `MPRco(vsatfp3        ,100e+3         ,"m/s"         ,0.0         ,inf         ,"Saturation Velocity of FP3 region")
    `MPRco(nfactorfp3     ,0.5            ,""            ,0.0         ,inf         ,"Sub-voff Slope parameters for FP3")
    `MPRco(cdscdfp3       ,0.0            ,""            ,0.0         ,inf         ,"Sub-voff Slope Change due to Drain Voltage for FP3")
    `MPRco(eta0fp3        ,1.0e-9         ,""            ,0.0         ,inf         ,"DIBL Parameter for FP3")
    `MPRoo(vdscalefp3     ,10.0           ,"V"           ,0.0         ,inf         ,"DIBL Scaling VDS for FP3")
    `MPRcc(gamma0fp3      ,2.12e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP3")
    `MPRcc(gamma1fp3      ,3.73e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP3")
    `MPRoo(iminfp4        ,1.0e-15        ,"A"           ,0.0         ,inf         ,"Minimum Drain Current FP4 region")
    `MPRcc(vofffp4        ,-100.0         ,"V"           ,-500.0      ,5           ,"voff for FP4")
    `IPRco(dfp4           ,200.0e-9       ,"m"           ,0.1e-9      ,inf         ,"Distance of FP4 from 2-DEG Charge")
    `IPRoo(lfp4           ,1.0e-6         ,"m"           ,0.0         ,inf         ,"Length of FP4")
    `MPRoo(ktfp4          ,50.0e-3        ,""            ,-inf        ,inf         ,"Temperature Dependence for vofffp4")
    `MPRco(u0fp4          ,100e-3         ,"m^2/(V * s)" ,0.0         ,inf         ,"FP4 region mobility")
    `MPRco(vsatfp4        ,100e+3         ,"m/s"         ,0.0         ,inf         ,"Saturation Velocity of FP4 region")
    `MPRco(nfactorfp4     ,0.5            ,""            ,0.0         ,inf         ,"Sub-voff Slope parameters for FP4")
    `MPRco(cdscdfp4       ,0.0            ,""            ,0.0         ,inf         ,"Sub-voff Slope Change due to Drain Voltage for FP4")
    `MPRco(eta0fp4        ,1.0e-9         ,""            ,0.0         ,inf         ,"DIBL Parameter for FP4")
    `MPRoo(vdscalefp4     ,10.0           ,"V"           ,0.0         ,inf         ,"DIBL Scaling VDS for FP4")
    `MPRcc(gamma0fp4      ,2.12e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP4")
    `MPRcc(gamma1fp4      ,3.73e-12       ,""            ,0.0         ,1.0         ,"Schrodinger-Poisson solution parameter for FP4")
////////// Capacitance Parameters //////////
    `MPRco(cgso           ,10.0e-15       ,"F"           ,0.0         ,inf         ,"Gate-source overlap capacitance")
    `MPRco(cgdo           ,10.0e-15       ,"F"           ,0.0         ,inf         ,"Gate-drain overlap capacitance")
    `MPRco(cdso           ,10.0e-15       ,"F"           ,0.0         ,inf         ,"Cds capacitance parameter")
    `MPRco(cgdl           ,0.0e-15        ,"F"           ,0.0         ,inf         ,"Vds bias dependence of parasitic gate drain overlap capacitance")
    `MPRoo(vdsatcv        ,100.0          ,"V"           ,0.0         ,inf         ,"Saturation voltage on drain side in CV Model")
    `MPRco(cbdo           ,0.0e-15        ,"F"           ,0.0         ,inf         ,"Substrate capacitance parameter")
    `MPRco(cbso           ,0.0e-15        ,"F"           ,0.0         ,inf         ,"Substrate capacitance parameter")
    `MPRco(cbgo           ,0.0e-15        ,"F"           ,0.0         ,inf         ,"Substrate capacitance parameter")
    `MPRco(cfg            ,0.0e-18        ,"F"           ,0.0         ,inf         ,"Fringing capacitance parameter")
    `MPRco(cfd            ,0.0e-18        ,"F"           ,0.0         ,inf         ,"Fringing capacitance parameter")
    `MPRco(cfgd           ,0.0e-13        ,"F"           ,0.0         ,inf         ,"Fringing capacitance parameter")
    `MPRco(cfgdsm         ,1.0e-24        ,"F"           ,0.0         ,inf         ,"Capacitance smoothing parameter")
    `MPRco(cfgd0          ,0.0e-12        ,"F"           ,0.0         ,inf         ,"Fringing capacitance parameter")
    `MPRco(cj0            ,0.0e-15        ,"F"           ,0.0         ,inf         ,"Zero bias depletion capacitance")
    `MPRoo(vbi            ,0.9            ,"V"           ,0.0         ,inf         ,"Built in potential")
    `MPRco(ktvbi          ,0.0            ,""            ,0.0         ,inf         ,"Temperature dependence of built in potential")
    `MPRco(ktcfg          ,0.0e-3         ,""            ,0.0         ,inf         ,"Temperature dependence of Fringing capacitance")
    `MPRco(ktcfgd         ,0.0e-3         ,""            ,0.0         ,inf         ,"Temperature dependence of Fringing capacitance")
    `MPRoo(mz             ,0.5            ,""            ,0.0         ,1.0         ,"Grading factor of depletion capacitance")
    `MPRoo(aj             ,100.0e-3       ,""            ,0.0         ,inf         ,"Limiting factor of depletion capacitance in forward bias region")
    `MPRco(dj             ,1.0            ,""            ,0.0         ,2.0         ,"Fitting parameter")
////////// Quantum Mechanical Effects //////////
    `MPRco(adosi          ,0.0            ,""            ,0           ,inf         ,"Quantum mechanical effect pre-factor cum switch in inversion")
    `MPRco(bdosi          ,1.0            ,""            ,0           ,inf         ,"Charge centroid parameter - slope of CV curve under QME in inversion")
    `MPRoo(qm0i           ,1.0e-3         ,""            ,0           ,inf         ,"Charge centroid parameter - starting point for QME in inversion")
    `MPRco(adosfp1        ,0.0            ,""            ,0           ,inf         ,"Quantum mechanical effect pre-factor cum switch in inversion")
    `MPRco(bdosfp1        ,1.0            ,""            ,0           ,inf         ,"Charge centroid parameter - slope of CV curve under QME in inversion")
    `MPRoo(qm0fp1         ,1.0e-3         ,""            ,0           ,inf         ,"Charge centroid parameter - starting point for QME in inversion")
    `MPRco(adosfp2        ,0.0            ,""            ,0           ,inf         ,"Quantum mechanical effect pre-factor cum switch in inversion")
    `MPRco(bdosfp2        ,1.0            ,""            ,0           ,inf         ,"Charge centroid parameter - slope of CV curve under QME in inversion")
    `MPRoo(qm0fp2         ,1.0e-3         ,""            ,0           ,inf         ,"Charge centroid parameter - starting point for QME in inversion")
    `MPRco(adosfp3        ,0.0            ,""            ,0           ,inf         ,"Quantum mechanical effect pre-factor cum switch in inversion")
    `MPRco(bdosfp3        ,1.0            ,""            ,0           ,inf         ,"Charge centroid parameter - slope of CV curve under QME in inversion")
    `MPRoo(qm0fp3         ,1.0e-3         ,""            ,0           ,inf         ,"Charge centroid parameter - starting point for QME in inversion")
    `MPRco(adosfp4        ,0.0            ,""            ,0           ,inf         ,"Quantum mechanical effect pre-factor cum switch in inversion")
    `MPRco(bdosfp4        ,1.0            ,""            ,0           ,inf         ,"Charge centroid parameter - slope of CV curve under QME in inversion")
    `MPRoo(qm0fp4         ,1.0e-3         ,""            ,0           ,inf         ,"Charge centroid parameter - starting point for QME in inversion")
////////// Cross Coupling Capacitance Parameters //////////
    `MPRco(cfp1scale      ,0.0            ,""            ,0           ,inf         ,"Coupling of charge under FP1")
    `MPRco(cfp2scale      ,0.0            ,""            ,0           ,inf         ,"Coupling of charge under FP2")
    `MPRco(cfp3scale      ,0.0            ,""            ,0           ,inf         ,"Coupling of charge under FP3")
    `MPRco(cfp4scale      ,0.0            ,""            ,0           ,inf         ,"Coupling of charge under FP4")
    `MPRco(csubscalei     ,0.0            ,""            ,0           ,inf         ,"Sub Capacitance scaling parameter")
    `MPRco(csubscale1     ,0.0            ,""            ,0           ,inf         ,"Sub Capacitance scaling parameter")
    `MPRco(csubscale2     ,0.0            ,""            ,0           ,inf         ,"Sub Capacitance scaling parameter")
    `MPRco(csubscale3     ,0.0            ,""            ,0           ,inf         ,"Sub Capacitance scaling parameter")
    `MPRco(csubscale4     ,0.0            ,""            ,0           ,inf         ,"Sub Capacitance scaling parameter")
////////// Gate Resistance Parameters //////////
    `MPIcc(rgatemod       ,0              ,""            ,0           ,2           ,"Model Switch to turn on and off the gate resistance")
    `MPRco(xgw            ,0.0            ,"m"           ,0           ,inf         ,"Distance from gate contact centre to dev edge")
    `IPIcc(ngcon          ,1              ,""            ,1           ,2           ,"Number of gate contacts")
    `MPRco(rshg           ,1.0e-3         ,"ohm/square"  ,1e-3        ,inf         ,"Gate sheet resistance")
////////// Noise Model Parameters //////////
    `MPIsw(fnmod          ,0              ,""                                      ,"Switch to turn Flicker Noise Model  ON [fnmod=1] or OFF [fnmod=0]")
    `MPIsw(tnmod          ,0              ,""                                      ,"Switch to turn Thermal Noise Model  ON [tnmod=1] or OFF [tnmod=0]")
    `MPRoo(noia           ,15.0e-12       ,""            ,-inf        ,inf         ,"Flicker Noise parameter")
    `MPRco(noib           ,0.0            ,""            ,0           ,inf         ,"Flicker Noise parameter")
    `MPRco(noic           ,0.0            ,""            ,0           ,inf         ,"Flicker Noise parameter")
    `MPRoo(ef             ,1              ,""            ,0           ,inf         ,"Exponent of frequency---Determines slope in log plot")
    `MPRoo(tnsc           ,1.0e27         ,""            ,0           ,inf         ,"Thermal noise scaling parameter")
////////// gdsmin For drain-source leakage resistance //////////
    `MPRoo(gdsmin         ,1.0e-12        ,"S"           ,0           ,inf          ,"Shunt conductance across channel and all field plates")
    `MPRco(tgdsmin        ,0.0            ,""            ,0           ,inf          ,"Temperature dependence for gdsmin")
/////////  Breakdown model parameters
    `MPRco(bvdsl          ,200.0          ,"V"           ,10          ,inf          ,"Drain-source breakdown due to punch-through")
    `MPRco(asl            ,0.0            ,"A/m"         ,0.0         ,inf          ,"Breakdown model multiplier parameter")
    `MPRco(nsl            ,10.0           ,""            ,1.0         ,inf          ,"Exponent in the breakdown model")
    `MPRoo(kasl           ,0.0            ,""            ,-inf        ,inf          ,"Temperature Dependence for asl parameters in breakdown")
    `MPRoo(knsl           ,0.0            ,""            ,-inf        ,inf          ,"Temperature Dependence for nsl parameters in breakdown")
    `MPRoo(kbvdsl         ,0.0            ,""            ,-inf        ,inf          ,"Temperature Dependence for bvdsl parameters in breakdown")
//////////// Device variability handles ////////////
    `IPRoo(dtemp          ,0.0            ,""            ,-inf        ,inf          ,"Temperature variability parameter")
//////////// Substrate current parameters //////////
    `MPRoo(nsb            ,100             ,""           ,0.0         ,5000.0      ,"Source-substrate junction leakage current ideality factor")
    `MPRoo(ndb            ,100             ,""           ,0.0         ,5000.0      ,"Drain-substrate junction leakage current ideality factor")
    `MPRco(isbl           ,0.0e-25        ,"A/m^2"       ,0.0         ,inf         ,"Source-substrate junction saturation current parameter")
    `MPRco(idbl           ,0.0e-25        ,"A/m^2"       ,0.0         ,inf         ,"Drain-substrate junction saturation current parameter")
    `MPRco(vbisb          ,50             ,"V"           ,0.0         ,inf         ,"Source-substrate junction built-in voltage parameter")
    `MPRco(vbidb          ,50             ,"V"           ,0.0         ,inf         ,"Drain-substrate junction diode built-in voltage parameter")
    `MPRoo(ktisb          ,0.0            ,""            ,-inf        ,inf         ,"Temperature co-efficient of source-sub junction diode current")
    `MPRoo(ktidb          ,0.0            ,""            ,-inf        ,inf         ,"Temperature coefficient of drain-sub junction diode current")
    `MPRoo(ktnsb          ,0.0            ,""            ,-inf        ,inf         ,"Temperature co-efficient of source-sub current exponent")
    `MPRoo(ktndb          ,0.0            ,""            ,-inf        ,inf         ,"Temperature coefficient of drain-sub current current")
    `MPRoo(ktvbisb        ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient for built-in voltage source side")
    `MPRoo(ktvbidb        ,0.0            ,"V"           ,-inf         ,inf        ,"Temperature coefficient for built-in voltage drain side")
////////// Operating Point Variables //////////
    `OPM(idisi, "A", "Intrinsic drain-to-source current")
    `OPP(vdisi, "V", "Intrinsic drain-to-source voltage")
    `OPP(vgisi, "V", "Intrinsic drain-to-source voltage")
    `OPM(gmi,   "A/V", "Intrinsic trans-conductance")
    `OPM(gdsi,  "A/V", "Intrinsic output conductance")
    `OPM(gmbi,  "A/V", "Intrinsic bulk trans-conductance")
    `OPM(igs,   "A", "Gate to source current")
    `OPM(igd,   "A", "Gate to source current")
    `OPM(qgi,   "C", "Intrinsic gate charge")
    `OPM(qdi,   "C", "Intrinsic drain charge")
    `OPM(qsi,   "C", "Intrinsic source charge")
    `OPM(qbi,   "C", "Intrinsic bulk charge")
    `OPM(cggi,  "F", "Intrinsic gate capacitance")
    `OPM(cgsi,  "F", "Intrinsic gate-to-source capacitance")
    `OPM(cgdi,  "F", "Intrinsic gate-to-drain capacitance")
    `OPM(cgbi,  "F", "Intrinsic gate-to-bulk capacitance")
    `OPM(cddi,  "F", "Intrinsic drain capacitance")
    `OPM(cdgi,  "F", "Intrinsic drain-to-gate capacitance")
    `OPM(cdsi,  "F", "Intrinsic drain-to-source capacitance")
    `OPM(cdbi,  "F", "Intrinsic drain-to-bulk capacitance")
    `OPM(cssi,  "F", "Intrinsic source capacitance")
    `OPM(csgi,  "F", "Intrinsic source-to-gate capacitance")
    `OPM(csdi,  "F", "Intrinsic source-to-drain capacitance")
    `OPM(csbi,  "F", "Intrinsic source-to-bulk capacitance")
    `OPM(cbbi,  "F", "Intrinsic bulk capacitance")
    `OPM(cbsi,  "F", "Intrinsic bulk-to-source capacitance")
    `OPM(cbdi,  "F", "Intrinsic bulk-to-drain capacitance")
    `OPM(cbgi,  "F", "Intrinsic bulk-to-gate capacitance")
    `OPP(t_total_k, "K", "Device temperature in Kelvin")
    `OPP(t_total_c, "deg C", "Device temperature in Celsius")
    `OPP(t_delta_sh, "K", "Increase in device temperature due to self-heating")
    `OPD(rd,   "Ohm", "Drain resistance")
    `OPD(rs,   "Ohm", "Source resistance")
    `OPM(cgs,  "F", "Total gate-to-source capacitance")
    `OPM(cgd,  "F", "Total gate-to-drain capacitance")
///////////////////////////////////////////////////////////////////

    analog begin
        begin : voltages
            real Tnom, Vth;
            real Vg0, Vds_1, Vds_2, Vgdeff, Vgs_1, Vgs_2, sigvds_1, sigvds_2, Vds_noswap_1, Vds_noswap_2, Vgs_noswap_1, Vgs_noswap_2, Vgd_noswap_1, Vgd_noswap_2, Vbs_1, Vbs_2, Vbs_noswap_1, Vbs_noswap_2, Vbd_noswap_1, Vbd_noswap_2;    //Hars
            real sigvdsfp1, Vds_noswapfp1, Vgs_noswapfp1, Vgd_noswapfp1;
            real sigvdsfp1s, Vds_noswapfp1s, Vgs_noswapfp1s, Vgd_noswapfp1s;
            real sigvdsfp2, Vds_noswapfp2, Vgs_noswapfp2, Vgd_noswapfp2;
            real sigvdsfp2s, Vds_noswapfp2s, Vgs_noswapfp2s, Vgd_noswapfp2s;
            real sigvdsfp3, Vds_noswapfp3, Vgs_noswapfp3, Vgd_noswapfp3;
            real sigvdsfp3s, Vds_noswapfp3s, Vgs_noswapfp3s, Vgd_noswapfp3s;
            real sigvdsfp4, Vds_noswapfp4, Vgs_noswapfp4, Vgd_noswapfp4;
            real sigvdsfp4s, Vds_noswapfp4s, Vgs_noswapfp4s, Vgd_noswapfp4s;
            real Cg, Cepi, Tdev, Vtv, beta, Vdsat, Vdeff, Voff_dibl, Voff_dibl_temp, vsat_tdev ;
            real t1, t2, vf, G_vf, Ids, mu_eff, Geff, mulf_tdev, Geff_clm;
            real Cch, ef1, vgef1, vgef23g0, vgef23g1, tg0, tg1;
            real t4, vgefm13g0, vgefm13g1, t5ng0,t5dg0, t5ng1, t5dg1, t5, ef2, vgef2, vgef223g0, vgef223g1, tg02, tg12, t42, vgefm213g0, vgefm213g1;
            real t5ng02, t5dg02, t5ng12, t5dg12, t52, ef3, psis, vgod, vgodp, psid, psim, psisd, ids0;
            real t0, t3, qd, qs, Vdsx_1, Vdsx_2, Vdsx_bv_1, Vdsx_2, gdpr, gspr, Rdrain, Rsource, cdsc;  //Hars
            real vdg, vdgeff, ct;
            real ALPHAN, ALPHAD, Hx, nsx, vgop, vgon, ndx, dvgon, dvgod ;
            real vgmin, vggmin ;
            real qgint_1, qgint_2, qsov, qdov, qdsov, qdint_1,qdint_2 , qsint_1, qsint_2, cgdvar, VdseffCV, cgdl_l;   //Hars
            real rsbias, rdbias, qsacc, isatacc, rd0, rs0 ;
            real vsataccs_t, ns0_t, rsc_t, rdc_t, u0accs_t, u0accd_t, cr, crm;
            real Rtrap, Rtrap_t, vcap, vgopacc;
            real T0, T1, XDCinv, Cg_qme, t6, t8, Qdep, qfr, qfr2, qfr3;
            real Pf, Kr, FNint1, FNint2, FNint3, FNint4, FNat1Hz;
            real ThSid;
            real Igs, Igd;
            real vdgeff1, voff_trap, ron_trap, cdscd_trap, eta0_trap;
            real voff_cap, rs_cap, rd_cap, eta0_cap;
            real qdp, qsp, qbdov, qbsov, qbgov;
            real Vg0_fp1, Cg_fp1, psis_fp1, psid_fp1, psim_fp1, psisd_fp1, qg_fp1, qd_fp1, Vgs_fp1, Vds_fp1, Vdsx_fp1, qs_fp1, Ids_fp1;
            real Vg0_fp1s, Cg_fp1s, psis_fp1s, psid_fp1s, psim_fp1s, psisd_fp1s, qg_fp1s, qd_fp1s, Vgs_fp1s, Vds_fp1s, Vdsx_fp1s, qs_fp1s, Ids_fp1s;
            real Vg0_fp2, Cg_fp2, psis_fp2, psid_fp2, psim_fp2, psisd_fp2, qg_fp2, qd_fp2, Vgs_fp2, Vds_fp2, Vdsx_fp2, qs_fp2, Ids_fp2;
            real Vg0_fp2s, Cg_fp2s, psis_fp2s, psid_fp2s, psim_fp2s, psisd_fp2s, qg_fp2s, qd_fp2s, Vgs_fp2s, Vds_fp2s, Vdsx_fp2s, qs_fp2s, Ids_fp2s;
            real Vg0_fp3, Cg_fp3, psis_fp3, psid_fp3, psim_fp3, psisd_fp3, qg_fp3, qd_fp3, Vgs_fp3, Vds_fp3, Vdsx_fp3, qs_fp3, Ids_fp3;
            real Vg0_fp3s, Cg_fp3s, psis_fp3s, psid_fp3s, psim_fp3s, psisd_fp3s, qg_fp3s, qd_fp3s, Vgs_fp3s, Vds_fp3s, Vdsx_fp3s, qs_fp3s, Ids_fp3s;
            real Vg0_fp4, Cg_fp4, psis_fp4, psid_fp4, psim_fp4, psisd_fp4, qg_fp4, qd_fp4, Vgs_fp4, Vds_fp4, Vdsx_fp4, qs_fp4, Ids_fp4;
            real Vg0_fp4s, Cg_fp4s, psis_fp4s, psid_fp4s, psim_fp4s, psisd_fp4s, qg_fp4s, qd_fp4s, Vgs_fp4s, Vds_fp4s, Vdsx_fp4s, qs_fp4s, Ids_fp4s;
            real Grgeltd, Grgeltd1, Grgeltd2;
            real mvgs, efield, mvgd, rigsdio_t, rigddio_t, vbis_t, vbid_t, njgs_t, njgd_t, rnjgs_t, rnjgd_t;
            real isl,aslt,tempr,nslt,bvdslt;
            real vaux, Rnon, voffdlag, ns0sdlag, ns0ddlag;
            real vauxg, Rnong, voffglag, u0glag, vsatglag, u0_i, vsat_i;
            real idseff,tmp,kv,kvv,kvv2;
            real arg,le,mud,narg,nle;
            integer ars_chk, ard_chk, rdsmod_i;
            real phixn, en, vauy, ns0sglag, ns0dglag, en1, phiyn;
            real Idb, Isb, Vbdl, Vbsl;
            real nsb_t, ndb_t, vbisb_t, vbidb_t, isb_t, idb_t;
            real gdsmin_t;
			
			// Hars: Declarations for Trap Model variables
			// Trap Mode 1
			real vcap_1, vcap_2, voff_cap_1, voff_cap_2, rs_cap_1, rs_cap_2, rd_cap_1, rd_cap_2, eta0_cap_1, eta0_cap_2;
			// Trap Mode 2
			real vdgeff1_1, vdgeff1_2, voff_trap_1, voff_trap_2, ron_trap_1, ron_trap_2, cdscd_trap_1, cdscd_trap_2, eta0_trap_1, eta0_trap_2;
			// Trap Mode 3
			real vdg_1, vdg_2, t0_1, t0_2, t1_1, t1_2, t2_1, t2_2, vdgeff_1, vdgeff_2, ct_1, ct_2, Rtrap_1, Rtrap_2, Rtrap_t_1, Rtrap_t_2;
			// Trap Mode 4
			real Rnon_1, Rnon_2, Rnong_1, Rnong_2, vaux_1, vaux_2, vauxg_1, vauxg_2;
			// Trap Mode 5
			real phixn_1, phixn_2, phiyn_1, phiyn_2, en_1, en_2, en1_1, en1_2, vaux_tr1, vaux_tr2, vauy_tr1, vauy_tr2;
			//Capacitance cal for MOSFET 1
			real Cg_1, Cepi_1, cdsc_1, Vtv_1, Voff_dibl_1, gdsmin_t_1, Voff_dibl_temp_1;
			// Capacitance calu for MOSFET2
			real Cg_2, Cepi_2, cdsc_2, Vtv_2, Voff_dibl_2, gdsmin_t_2, Voff_dibl_temp_2;
			 

////////// Variable initialization //////////
            t6 = 0.0; t8 = 0.0; Qdep = 0.0; qfr = 0.0; qfr2 = 0.0; qfr3 = 0.0;
            vcap = 1.0;
            voff_cap = 0.0; rs_cap = 0.0; rd_cap = 0.0; eta0_cap = 0.0; Ids = 0.0;
            voff_trap = 0.0; ron_trap= 0.0; cdscd_trap=0.0; eta0_trap=0.0; Rtrap_t = 0.0 ;
            Vg0_fp1 = 0.0; Cg_fp1 = 0.0; psis_fp1 = 0.0; psid_fp1 = 0.0; psim_fp1 = 0.0; psisd_fp1 = 0.0; qg_fp1 = 0.0; qd_fp1 = 0.0;
            qs_fp1 = 0.0; Vgs_fp1 = 0.0; Vds_fp1 = 0.0; Ids_fp1 = 0.0;
            Vg0_fp1s = 0.0; Cg_fp1s = 0.0; psis_fp1s = 0.0; psid_fp1s = 0.0; psim_fp1s = 0.0; psisd_fp1s = 0.0; qg_fp1s = 0.0; qd_fp1s = 0.0;
            qs_fp1s = 0.0; Vgs_fp1s = 0.0; Vds_fp1s = 0.0; Ids_fp1s = 0.0;
            Vg0_fp2 = 0.0; Cg_fp2 = 0.0; psis_fp2 = 0.0; psid_fp2 = 0.0; psim_fp2 = 0.0; psisd_fp2 = 0.0; qg_fp2 = 0.0; qd_fp2 = 0.0;
            qs_fp2 = 0.0; Vgs_fp2 = 0.0; Vds_fp2 = 0.0; Ids_fp2 = 0.0;
            Vg0_fp2s = 0.0; Cg_fp2s = 0.0; psis_fp2s = 0.0; psid_fp2s = 0.0; psim_fp2s = 0.0; psisd_fp2s = 0.0; qg_fp2s = 0.0; qd_fp2s = 0.0;
            qs_fp2s = 0.0; Vgs_fp2s = 0.0; Vds_fp2s = 0.0; Ids_fp2s = 0.0;
            Vg0_fp3 = 0.0; Cg_fp3 = 0.0; psis_fp3 = 0.0; psid_fp3 = 0.0; psim_fp3 = 0.0; psisd_fp3 = 0.0; qg_fp3 = 0.0; qd_fp3 = 0.0;
            qs_fp3 = 0.0; Vgs_fp3 = 0.0; Vds_fp3 = 0.0; Ids_fp3 = 0.0;
            Vg0_fp3s = 0.0; Cg_fp3s = 0.0; psis_fp3s = 0.0; psid_fp3s = 0.0; psim_fp3s = 0.0; psisd_fp3s = 0.0; qg_fp3s = 0.0; qd_fp3s = 0.0;
            qs_fp3s = 0.0; Vgs_fp3s = 0.0; Vds_fp3s = 0.0; Ids_fp3s = 0.0;
            Vg0_fp4 = 0.0; Cg_fp4 = 0.0; psis_fp4 = 0.0; psid_fp4 = 0.0; psim_fp4 = 0.0; psisd_fp4 = 0.0; qg_fp4 = 0.0; qd_fp4 = 0.0;
            qs_fp4 = 0.0; Vgs_fp4 = 0.0; Vds_fp4 = 0.0; Ids_fp4 = 0.0;
            Vg0_fp4s = 0.0; Cg_fp4s = 0.0; psis_fp4s = 0.0; psid_fp4s = 0.0; psim_fp4s = 0.0; psisd_fp4s = 0.0; qg_fp4s = 0.0; qd_fp4s = 0.0;
            qs_fp4s = 0.0; Vgs_fp4s = 0.0; Vds_fp4s = 0.0; Ids_fp4s = 0.0;
            Igs = 0.0; Igd = 0.0;
            cr = 0.01;
            crm = 0.01;
            Rdrain = 0.0; Rsource = 0.0; gdpr = 0.0; gspr = 0.0;
            sigvdsfp1 = 1.0;
            sigvdsfp2 = 1.0;
            sigvdsfp3 = 1.0;
            sigvdsfp4 = 1.0;
            sigvdsfp1s = 1.0;
            sigvdsfp2s = 1.0;
            sigvdsfp3s = 1.0;
            sigvdsfp4s = 1.0;
            mvgs = 0.0; mvgd = 0.0; efield=0.0; rigsdio_t = 0.0; rigddio_t = 0.0;
            vbis_t=0.0; vbid_t = 0.0;
            njgs_t=1.0;
            njgd_t=1.0;
            Grgeltd=1.0e3;
            Grgeltd1=1.0e3;
            Grgeltd2=1.0e3;
            voffdlag=0.0; voffglag=0.0; u0glag=0.0; ns0ddlag=0.0; ns0sdlag=0.0; vsatglag=0.0; ns0dglag=0.0; ns0sglag=0.0;

            if ($port_connected(dt) == 0) begin
                if (shmod == 0 || rth0 == 0.0) begin
                    Temp(dt) <+ 0.0;
                end else begin
                    $strobe("5 terminal Module, while 't' node is not connected, SH is activated.");
                end
            end
            rdsmod_i = rdsmod;
            if (fastfpmod == 1) begin
                if (rdsmod_i == 0) begin
                    $strobe("Warning: fastfpmod=1 and rdsmod=0 is not a valid combination. rdsmod is reset to 1.");
                    rdsmod_i = 1;
                end
            end
////////// Temperature Conversion From Celsius To Kelvin //////////
            Tnom = tnom + `P_CELSIUS0;

////////// Terminal Voltage Conditioning - MOSFET 1 ////////// //Hars
            Vds_noswap_1 = V(di, si_1); //Hars
            Vgs_noswap_1 = V(gi_1, si_1); //Hars
            Vgd_noswap_1 = V(gi_1, di); //Hars
            Vbs_noswap_1 = V(b1, si_1); //Hars
            Vbd_noswap_1 = V(b1, di); //Hars
            sigvds_1 = 1.0; //Hars
            if (Vds_noswap_1 < 0.0) begin //Hars
                sigvds_1 = -1.0; //Hars
                Vds_1 = sigvds_1 * Vds_noswap_1; //Hars
                Vgs_1 = Vgd_noswap_1; //Hars
                Vbs_1 = Vbd_noswap_1; //Hars
            end else begin //Hars
                Vds_1 = Vds_noswap_1; //Hars
                Vgs_1 = Vgs_noswap_1; //Hars
                Vbs_1 = Vbs_noswap_1; //Hars
            end //Hars
            Vdsx_1 = sqrt(Vds_1 * Vds_1 + 0.01) - 0.1; //Hars
            Vdsx_bv_1 = sqrt(V(d, s1) * V(d, s1) + 0.01) - 0.1; //Hars
			
////////// Terminal Voltage Conditioning - MOSFET 2 ////////// //Hars
            Vds_noswap_2 = V(di, si_2); //Hars
            Vgs_noswap_2 = V(gi_2, si_2); //Hars
            Vgd_noswap_2 = V(gi_2, di); //Hars
            Vbs_noswap_2 = V(b2, si_2); //Hars
            Vbd_noswap_2 = V(b2, di); //Hars
            sigvds_2 = 1.0; //Hars
            if (Vds_noswap_2 < 0.0) begin //Hars
                sigvds_2 = -1.0; //Hars
                Vds_2 = sigvds_2 * Vds_noswap_2; //Hars
                Vgs_2 = Vgd_noswap_2; //Hars
                Vbs_2 = Vbd_noswap_2; //Hars
            end else begin //Hars
                Vds_2 = Vds_noswap_2; //Hars
                Vgs_2 = Vgs_noswap_2; //Hars
                Vbs_2 = Vbs_noswap_2; //Hars
            end //Hars
            Vdsx_2 = sqrt(Vds_2 * Vds_2 + 0.01) - 0.1; //Hars
            Vdsx_bv_2 = sqrt(V(d, s2) * V(d, s2) + 0.01) - 0.1; //Hars
			Tdev = $temperature + Temp(rth) + dtemp;
            Vth  = `KboQ * Tdev ;

✅
////////// Trap Models //////////
            case (trapmod)
                0:begin
                    V(trap1) <+ 0.0;
                    V(trap2) <+ 0.0;
                    V(nt)  <+ 0.0;
                    V(ntg) <+ 0.0;
                    V(n1)  <+ 0.0;
                    V(n2)  <+ 0.0;
                end
                1:begin
				
				//MOSFTE_1    //Hars
                    V(trap2_1) <+ Vds_1 * Vds_1;
					I(trap2_1, trap1_1) <+ idio * (lexp(V(trap2_1, trap1_1)/10.0) - 1.0);
					I(trap1_1) <+ cdlag * ddt(V(trap1_1)) + V(trap1_1)/rdlag;
					I(trap1_1) <+ V(trap1)/rdlag;
					vcap_1 = smoothminx(V(trap1_1), Vth, deltax);
					voff_cap_1 = atrapvoff + btrapvoff * lexp(-1.0 / vcap_1);
					rs_cap_1 = atraprs + btraprs * lexp(-1.0 / vcap_1);
					rd_cap_1 = atraprd + btraprd * lexp(-1.0 / vcap_1);
					eta0_cap_1 = atrapeta0 + btrapeta0 * lexp(-1.0 / vcap_1);
					
					
		        // MOSFET_2   //Hars
					V(trap2_2) <+ Vds_2 * Vds_2;
					I(trap2_2, trap1_2) <+ idio * (lexp(V(trap2_2, trap1_2)/10.0) - 1.0);
					I(trap1_2) <+ cdlag * ddt(V(trap1_2)) + V(trap1_2)/rdlag;
					vcap_2 = smoothminx(V(trap1_2), Vth, deltax);
					voff_cap_2 = atrapvoff + btrapvoff * lexp(-1.0 / vcap_2);
					rs_cap_2 = atraprs + btraprs * lexp(-1.0 / vcap_2);
					rd_cap_2 = atraprd + btraprd * lexp(-1.0 / vcap_2);
					eta0_cap_2 = atrapeta0 + btrapeta0 * lexp(-1.0 / vcap_2);
                    V(nt)  <+ 0.0;
                    V(ntg) <+ 0.0;
                    V(n1)  <+ 0.0;
                    V(n2)  <+ 0.0;
                end
				
				
                2:begin
				
				//MOSFET 1     //Hars
                    vdgeff1_1 = lexp(a1 * (-V(g1, s1)));
                    I(trap1) <+ V(trap1)/rtrap1;
                    I(trap1_1) <+ V(trap1_1)/rtrap1 - vdgeff1_1 + ctrap1 * ddt(V(trap1_1));
					I(trap2_1) <+ V(trap2_1)/rtrap2 - V(d1, s1) + ctrap2 * ddt(V(trap2_1));
					voff_trap_1 = vofftr * V(trap2_1);
					ron_trap_1 = -rontr1 * V(trap1_1) + rontr2 * V(trap2_1) + rontr3;
					cdscd_trap_1 = cdscdtr * V(trap2_1);
					eta0_trap_1 = eta0tr * V(trap2_1);
					
					
				//MOSFET_2   //Hars
				
					vdgeff1_2 = lexp(a1 * (-V(g2, s2)));
					I(trap1_2) <+ V(trap1_2)/rtrap1 - vdgeff1_2 + ctrap1 * ddt(V(trap1_2));
					I(trap2_2) <+ V(trap2_2)/rtrap2 - V(d2, s2) + ctrap2 * ddt(V(trap2_2));
					voff_trap_2 = vofftr * V(trap2_2);
					ron_trap_2 = -rontr1 * V(trap1_2) + rontr2 * V(trap2_2) + rontr3;
					cdscd_trap_2 = cdscdtr * V(trap2_2);
					eta0_trap_2 = eta0tr * V(trap2_2);
                    V(nt)  <+ 0.0;
                    V(ntg) <+ 0.0;
                    V(n1)  <+ 0.0;
                    V(n2)  <+ 0.0;
                end
				
				
                3:begin
				
				//MOSFET_1   //Hars
					vdg_1 = V(d1, g1);
					t1_1 = (vdlr1 / (1.0 + vdg_1 * wd)) * vdg_1;
					t2_1 = vdlr2 * (vdg_1 - vtb);
					vdgeff_1 = 0.5 * (t1_1 + t2_1 + sqrt((t1_1 - t2_1)**2 + 0.25 * deltax**2));
					t0_1 = exp(-2.0 * (V(g1, s1) - voff) / sct);
					ct_1 = 1.0e-9 + (ctrap3 - 1.0e-9) * 0.5 * (1.0 + (1.0 - t0_1)/(1.0 + t0_1));
					I(trap1_1) <+ V(trap1_1)/rtrap3 - vdgeff_1 + ct_1 * ddt(V(trap1_1));
					Rtrap_1 = V(trap1_1)/vatrap;
					Rtrap_t_1 = Rtrap_1 * pow((Tdev/Tnom), talpha);
					
				//MOSFET_2     //Hars
				
					vdg_2 = V(d2, g2);
					t1_2 = (vdlr1 / (1.0 + vdg_2 * wd)) * vdg_2;
					t2_2 = vdlr2 * (vdg_2 - vtb);
					vdgeff_2 = 0.5 * (t1_2 + t2_2 + sqrt((t1_2 - t2_2)**2 + 0.25 * deltax**2));
					t0_2 = exp(-2.0 * (V(g2, s2) - voff) / sct);
					ct_2 = 1.0e-9 + (ctrap3 - 1.0e-9) * 0.5 * (1.0 + (1.0 - t0_2)/(1.0 + t0_2));
					I(trap1_2) <+ V(trap1_2)/rtrap3 - vdgeff_2 + ct_2 * ddt(V(trap1_2));
					Rtrap_2 = V(trap1_2)/vatrap;
					Rtrap_t_2 = Rtrap_2 * pow((Tdev/Tnom), talpha);	
                    
                    V(nt)  <+ 0.0;
                    V(ntg) <+ 0.0;
                    V(n1)  <+ 0.0;
                    V(n2)  <+ 0.0;
                end
				
				
                4: begin
				
				//MOSFET_1    //Hars
                    V(trap1_1) <+ 0.0;
					V(trap2_1) <+ 0.0;
					t0_1 = abs(V(d_1,s_1));
					V(n1_1) <+ t0_1;
					Rnon_1 = remi / (1 + arcap * exp(V(n1_1,nt_1)/brcap));
					I(n1_1,nt_1) <+ V(n1_1,nt_1)/Rnon_1;
					I(nt_1) <+ cdlag * ddt(V(nt_1)) + 1.0e-12 * V(nt_1);
					t1_1 = abs(V(g_1,s_1));
					V(n2_1) <+ t1_1;
					Rnong_1 = remig / (1 + arcapg * exp(V(n2_1,ntg_1)/brcapg));
					I(n2_1,ntg_1) <+ V(n2_1,ntg_1)/Rnong_1;
					I(ntg_1) <+ cglag * ddt(V(ntg_1)) + 1.0e-12 * V(ntg_1);
					vaux_1 = V(nt_1) - abs(V(d_1,s_1));
					vaux_1 = smoothminx(vaux_1, 0.0, 1.0e-30);
					vauxg_1 = V(ntg_1) - abs(V(g_1,s_1));
					vauxg_1 = smoothminx(vauxg_1, 0.0, 1.0e-30);
					`PCAL(vaux_1, vdlmax, voff, dlvoff, voffdlag)
					`PCAL(vauxg_1, vglmax, voff, glvoff, voffglag)
					`PCAL(vauxg_1, vglmax, u0, glu0, u0glag)
					`PCAL(vauxg_1, vglmax, vsat, glvsat, vsatglag)
					`PCAL(vaux_1, vdlmax, ns0accs, dlns0s, ns0sdlag)
					`PCAL(vaux_1, vdlmax, ns0accd, dlns0d, ns0ddlag)
					
					
				//MOSFET_2    //Hars
				
					V(trap1_2) <+ 0.0;
					V(trap2_2) <+ 0.0;
					t0_2 = abs(V(d_2,s_2));
					V(n1_2) <+ t0_2;
					Rnon_2 = remi / (1 + arcap * exp(V(n1_2,nt_2)/brcap));
					I(n1_2,nt_2) <+ V(n1_2,nt_2)/Rnon_2;
					I(nt_2) <+ cdlag * ddt(V(nt_2)) + 1.0e-12 * V(nt_2);
					t1_2 = abs(V(g_2,s_2));
					V(n2_2) <+ t1_2;
					Rnong_2 = remig / (1 + arcapg * exp(V(n2_2,ntg_2)/brcapg));
					I(n2_2,ntg_2) <+ V(n2_2,ntg_2)/Rnong_2;
					I(ntg_2) <+ cglag * ddt(V(ntg_2)) + 1.0e-12 * V(ntg_2);
					vaux_2 = V(nt_2) - abs(V(d_2,s_2));
					vaux_2 = smoothminx(vaux_2, 0.0, 1.0e-30);
					vauxg_2 = V(ntg_2) - abs(V(g_2,s_2));
					vauxg_2 = smoothminx(vauxg_2, 0.0, 1.0e-30);
					`PCAL(vaux_2, vdlmax, voff, dlvoff, voffdlag)
					`PCAL(vauxg_2, vglmax, voff, glvoff, voffglag)
					`PCAL(vauxg_2, vglmax, u0, glu0, u0glag)
					`PCAL(vauxg_2, vglmax, vsat, glvsat, vsatglag)
					`PCAL(vaux_2, vdlmax, ns0accs, dlns0s, ns0sdlag)
					`PCAL(vaux_2, vdlmax, ns0accd, dlns0d, ns0ddlag)
                end
                5:begin
                   
				//MOSFET_1 

					phixn_1 = ln(exp(alphax*V(g_1,s_1) + alphaxd*V(g_1,d_1) + betax*abs(V(d_1,s_1)) + gammax) + etax);
					en_1 = eno * exp((ea/(`KboQ*Tdev)) - (ea/(`KboQ*Tnom)));
					I(trap1_1) <+ -cx * en_1 * (vxmax - V(trap1_1)) * (exp(2.0 * phixn_1) - 1) * 0.5;
					I(trap1_1) <+ cx * en_1 * V(trap1_1);
					I(trap1_1) <+ cx * ddt(V(trap1_1));
					phiyn_1 = ln(exp(alphay*V(g_1,s_1) + alphayd*V(g_1,d_1) + betay*abs(V(d_1,s_1)) + gammay) + etay);
					en1_1 = eno1 * exp((ea1/(`KboQ*Tdev)) - (ea1/(`KboQ*Tnom)));
					I(trap2_1) <+ -cy * en1_1 * (vymax - V(trap2_1)) * (exp(2.0 * phiyn_1) - 1) * 0.5;
					I(trap2_1) <+ cy * en1_1 * V(trap2_1);
					I(trap2_1) <+ cy * ddt(V(trap2_1));
                    vaux_tr1 = V(trap1);
                    vauy_tr1 = V(trap2);
                    `PCAL(vaux,vdlmax,voff,dlvoff, voffdlag)
                    `PCAL(vaux,vdlmax,ns0accs,dlns0s, ns0sdlag)
                    `PCAL(vaux,vdlmax,ns0accd,dlns0d, ns0ddlag)
                    `PCAL(vauy,vglmax,voff,glvoff, voffglag)
                    `PCAL(vauy,vglmax,ns0accs,glns0s, ns0sglag)
                    `PCAL(vauy,vglmax,ns0accd,glns0d, ns0dglag)
					
					
				//MOSFET2      //Hars
				
					phixn_2 = ln(exp(alphax*V(g_2,s_2) + alphaxd*V(g_2,d_2) + betax*abs(V(d_2,s_2)) + gammax) + etax);
					en_2 = eno * exp((ea/(`KboQ*Tdev)) - (ea/(`KboQ*Tnom)));
					I(trap1_2) <+ -cx * en_2 * (vxmax - V(trap1_2)) * (exp(2.0 * phixn_2) - 1) * 0.5;
					I(trap1_2) <+ cx * en_2 * V(trap1_2);
					I(trap1_2) <+ cx * ddt(V(trap1_2));
					phiyn_2 = ln(exp(alphay*V(g_2,s_2) + alphayd*V(g_2,d_2) + betay*abs(V(d_2,s_2)) + gammay) + etay);
					en1_2 = eno1 * exp((ea1/(`KboQ*Tdev)) - (ea1/(`KboQ*Tnom)));
					I(trap2_2) <+ -cy * en1_2 * (vymax - V(trap2_2)) * (exp(2.0 * phiyn_2) - 1) * 0.5;
					I(trap2_2) <+ cy * en1_2 * V(trap2_2);
					I(trap2_2) <+ cy * ddt(V(trap2_2));
					vaux_tr2 = V(trap1_2);
					vauy_tr2 = V(trap2_2);
                    V(nt)  <+ 0.0;
                    V(ntg) <+ 0.0;
                    V(n1)  <+ 0.0;
                    V(n2)  <+ 0.0;
                end
            endcase
////////// End of Trap Models //////////

////////// Calculation For Physical Quantities Required In SP Calculation //////////		
			`DEVICE_MODEL_CALCS(Vdsx_1, cdscd, cdscd_trap_1, Tdev,voff, voffdlag_1, voffglag_1, eta0, eta0_trap_1, eta0_cap_1, vdscale, Tnom, gdsmin, tgdsmin, kt1, voff_trap_1, voff_cap_1, Vbs_1, asub, \
                    Cg_1, Cepi_1, cdsc_1, Vtv_1, Voff_dibl_1, tempr, gdsmin_t_1, Voff_dibl_temp_1)   //Hars
					
			`DEVICE_MODEL_CALCS(Vdsx_2, cdscd, cdscd_trap_2, Tdev, voff, voffdlag_2, voffglag_2, eta0, eta0_trap_2, eta0_cap_2, vdscale, Tnom, gdsmin, tgdsmin, kt1, voff_trap_2, voff_cap_2, Vbs_2, asub, \
                    Cg_2, Cepi_2, cdsc_2, Vtv_2, Voff_dibl_2, tempr, gdsmin_t_2, Voff_dibl_temp_2)   //Hars

////////// VGMin and VG0 Calculation //////////    //Hars
			`VG0(l,w,Voff_dibl_temp_2,imin,Vgs_2,Vtv_2,Vg0)   //Hars
			`VG0(l,w,Voff_dibl_temp_1,imin,Vgs_1,Vtv_1,Vg0)   //Hars

////////// Surface Potential Calculation Source Side //////////
            `PSIS(Cg_1,Vg0,gamma0i,gamma1i,Vtv_1,  beta,ALPHAN,ALPHAD,Cch,psis)  //Hars
			`PSIS(Cg_2,Vg0,gamma0i,gamma1i,Vtv_2,  beta,ALPHAN,ALPHAD,Cch,psis)  //Hars

////////// Surface Potential Drain Side //////////
			
			`Surface_potential(Tdev, Tnom, epsilon, delta, beta, ALPHAN, ALPHAD, Vtv1, Cch, Cepi1, u01, u0glag1, ute, vsat1, vsatglag1, at, Cg1, psis1, 
              Vg01, Vbs1, ua, ub, uc, l1, Vds1, gamma0i, gamma1i, mulf_tdev, Vdeff1, psid1, Vdsx1, w1, nf1, asl, kasl, nsl, knsl, bvdsl, kbvdsl, 
              Vdsx_bv1, kt1, voff_trap1, voff_cap1, mult_i1, sigvds1, gdsmin_t1, di1, si1, Ids1, isl1)    //Hars
			  
			`Surface_potential(Tdev, Tnom, epsilon, delta, beta, ALPHAN, ALPHAD, Vtv2, Cch, Cepi2, u02, u0glag2, ute, vsat2, vsatglag2, at, Cg2, psis2, 
              Vg02, Vbs2, ua, ub, uc, l2, Vds2, gamma0i, gamma1i, mulf_tdev, Vdeff2, psid2, Vdsx2, w2, nf2, asl, kasl, nsl, knsl, bvdsl, kbvdsl, 
              Vdsx_bv2, kt1, voff_trap2, voff_cap2, mult_i2, sigvds2, gdsmin_t2, di2, si2, Ids2, isl2)   //Hars
 

////////// Terminal Charge Equations //////////
            `QGI(Vg0,psis,psid,psim,Cg_1,l,qm0i,bdosi,adosi,tbar,Vtv_1,w,nf,Cg_qme,qgint_1)     //Hars: MOSFET1
			`QGI(Vg0,psis,psid,psim,Cg_2,l,qm0i,bdosi,adosi,tbar,Vtv_2,w,nf,Cg_qme,qgint_2)     //Hars: MOSFET2
            `QDI(Vg0,psim,psis,psid,psisd,l,Vtv_1,w,nf,Cg_qme,qdint_1)        //Hars: MOSFET1
			`QDI(Vg0,psim,psis,psid,psisd,l,Vtv_2,w,nf,Cg_qme,qdint_2)        //Hars: MOSFET2
			
			
			////hars:   MOSFET 1    
            qsint_1 = -1.0*qgint_1 -1.0*qdint_1; //Source Charge
            if (sigvds_1 < 0.0) begin
                t1_1 = qsint_1;
                qsint_1 = qdint_1;
                qdint_1 = t1_1;
            end
			///Hars:      MOSFET 2
			qsint_2 = -1.0*qgint_2 -1.0*qdint_2; //Source Charge
            if (sigvds_2 < 0.0) begin
                t1_2 = qsint_2;
                qsint_2 = qdint_2;
                qdint_2 = t1_2;
            end

////////// Gate Current Model //////////
            case (gatemod)
                0:begin
                    
					Igs_1 = 0.0; Igd_1 = 0.0;
					Igs_2 = 0.0; Igd_2 = 0.0;
                end
                1:begin
                    //  MOSFET 1					
					t0_1 = V(gi_1, si_1) / (njgs * `KboQ * Tdev);
					t3_1 = igsdio + (Tdev / Tnom - 1.0) * ktgs;
					Igs_1 = w * l * nf * abs(t3_1) * (lexp(t0_1) - 1.0);
					t0_1 = V(gi_1, di_1) / (njgd * `KboQ * Tdev);
					t3_1 = igddio + (Tdev / Tnom - 1.0) * ktgd;
					Igd_1 = w * l * nf * abs(t3_1) * (lexp(t0_1) - 1.0);
					
					 // MOSFET 2
					t0_2 = V(gi_2, si_2) / (njgs * `KboQ * Tdev);
					t3_2 = igsdio + (Tdev / Tnom - 1.0) * ktgs;
					Igs_2 = w * l * nf * abs(t3_2) * (lexp(t0_2) - 1.0);
					t0_2 = V(gi_2, di_2) / (njgd * `KboQ * Tdev);
					t3_2 = igddio + (Tdev / Tnom - 1.0) * ktgd;
					Igd_2 = w * l * nf * abs(t3_2) * (lexp(t0_2) - 1.0);

                end
                2:begin
                  	// MOSFET 1 
					vbis_t_1 = vbis + (Tdev / Tnom - 1) * ktvbis;
					njgs_t_1 = njgs + (Tdev / Tnom - 1) * ktnjgs;
					rnjgs_t_1 = rnjgs + (Tdev / Tnom - 1) * ktrnjgs;
					t0_1 = (V(gi_1, si_1) - vbis_t_1) / (njgs_t_1 * `KboQ * Tnom);
					t3_1 = igsdio * exp(ktgs * (Tdev / Tnom - 1));
					Igs_1 = w * l * nf * abs(t3_1) * (lexp(t0_1) - 1.0);
					mvgs_1 = hypmax(-V(gi_1, si_1), 0.0, 0.001);
					efield_1 = mvgs_1 / tbar;
					t0_1 = sqrt(mvgs_1) + ebreaks;
					t1_1 = t0_1 / (rnjgs_t_1 * `KboQ * Tnom);
					rigsdio_t_1 = rigsdio * exp(rktgs * (Tdev / Tnom - 1));
					Igs_1 = Igs_1 * (1.0 + efield_1 * rigsdio_t_1 * lexp(t1_1));
					vbid_t_1 = vbid + (Tdev / Tnom - 1) * ktvbid;
					njgd_t_1 = njgd + (Tdev / Tnom - 1) * ktnjgd;
					rnjgd_t_1 = rnjgd + (Tdev / Tnom - 1) * ktrnjgd;
					t0_1 = (V(gi_1, di_1) - vbid_t_1) / (njgd_t_1 * `KboQ * Tnom);
					t3_1 = igddio * exp(ktgd * (Tdev / Tnom - 1));
					Igd_1 = w * l * nf * abs(t3_1) * (lexp(t0_1) - 1.0);
					mvgd_1 = hypmax(-V(gi_1, di_1), 0.0, 0.001);
					efield_1 = mvgd_1 / tbar;
					t0_1 = sqrt(mvgd_1) + ebreakd;
					t0_1 = t0_1 / (rnjgd_t_1 * `KboQ * Tnom);
					rigddio_t_1 = rigddio * exp(rktgd * (Tdev / Tnom - 1));
					Igd_1 = Igd_1 * (1.0 + efield_1 * rigddio_t_1 * lexp(t0_1));
					
					 // MOSFET 2
					vbis_t_2 = vbis + (Tdev / Tnom - 1) * ktvbis;
					njgs_t_2 = njgs + (Tdev / Tnom - 1) * ktnjgs;
					rnjgs_t_2 = rnjgs + (Tdev / Tnom - 1) * ktrnjgs;
					t0_2 = (V(gi_2, si_2) - vbis_t_2) / (njgs_t_2 * `KboQ * Tnom);
					t3_2 = igsdio * exp(ktgs * (Tdev / Tnom - 1));
					Igs_2 = w * l * nf * abs(t3_2) * (lexp(t0_2) - 1.0);
					mvgs_2 = hypmax(-V(gi_2, si_2), 0.0, 0.001);
					efield_2 = mvgs_2 / tbar;
					t0_2 = sqrt(mvgs_2) + ebreaks;
					t1_2 = t0_2 / (rnjgs_t_2 * `KboQ * Tnom);
					rigsdio_t_2 = rigsdio * exp(rktgs * (Tdev / Tnom - 1));
					Igs_2 = Igs_2 * (1.0 + efield_2 * rigsdio_t_2 * lexp(t1_2));
					vbid_t_2 = vbid + (Tdev / Tnom - 1) * ktvbid;
					njgd_t_2 = njgd + (Tdev / Tnom - 1) * ktnjgd;
					rnjgd_t_2 = rnjgd + (Tdev / Tnom - 1) * ktrnjgd;
					t0_2 = (V(gi_2, di_2) - vbid_t_2) / (njgd_t_2 * `KboQ * Tnom);
					t3_2 = igddio * exp(ktgd * (Tdev / Tnom - 1));
					Igd_2 = w * l * nf * abs(t3_2) * (lexp(t0_2) - 1.0);
					mvgd_2 = hypmax(-V(gi_2, di_2), 0.0, 0.001);
					efield_2 = mvgd_2 / tbar;
					t0_2 = sqrt(mvgd_2) + ebreakd;
					t0_2 = t0_2 / (rnjgd_t_2 * `KboQ * Tnom);
					rigddio_t_2 = rigddio * exp(rktgd * (Tdev / Tnom - 1));
					Igd_2 = Igd_2 * (1.0 + efield_2 * rigddio_t_2 * lexp(t0_2));
                end
				
                3: begin
				
					 // MOSFET 1
					vbis_t_1 = vbis + (Tdev / Tnom - 1) * ktvbis;
					njgs_t_1 = njgs + (Tdev / Tnom - 1) * ktnjgs;
					rnjgs_t_1 = rnjgs + (Tdev / Tnom - 1) * ktrnjgs;
					rigsdio_t_1 = rigsdio * exp(rktgs * (Tdev / Tnom - 1));
					t3_1 = w * l * nf * igsdio * exp(ktgs * (Tdev / Tnom - 1));
					`IDIO3(t3_1, njgs_t_1, ags, V(gi_1, si_1), vbis_t_1, rnjgs_t_1, ebreaks, rigsdio_t_1, Igs_1)

					vbid_t_1 = vbid + (Tdev / Tnom - 1) * ktvbid;
					njgd_t_1 = njgd + (Tdev / Tnom - 1) * ktnjgd;
					rnjgd_t_1 = rnjgd + (Tdev / Tnom - 1) * ktrnjgd;
					rigddio_t_1 = rigddio * exp(rktgd * (Tdev / Tnom - 1));
					t3_1 = w * l * nf * igddio * exp(ktgd * (Tdev / Tnom - 1));
					`IDIO3(t3_1, njgd_t_1, agd, V(gi_1, di_1), vbid_t_1, rnjgd_t_1, ebreakd, rigddio_t_1, Igd_1);

					// MOSFET 2
					vbis_t_2 = vbis + (Tdev / Tnom - 1) * ktvbis;
					njgs_t_2 = njgs + (Tdev / Tnom - 1) * ktnjgs;
					rnjgs_t_2 = rnjgs + (Tdev / Tnom - 1) * ktrnjgs;
					rigsdio_t_2 = rigsdio * exp(rktgs * (Tdev / Tnom - 1));
					t3_2 = w * l * nf * igsdio * exp(ktgs * (Tdev / Tnom - 1));
					`IDIO3(t3_2, njgs_t_2, ags, V(gi_2, si_2), vbis_t_2, rnjgs_t_2, ebreaks, rigsdio_t_2, Igs_2);

					vbid_t_2 = vbid + (Tdev / Tnom - 1) * ktvbid;
					njgd_t_2 = njgd + (Tdev / Tnom - 1) * ktnjgd;
					rnjgd_t_2 = rnjgd + (Tdev / Tnom - 1) * ktrnjgd;
					rigddio_t_2 = rigddio * exp(rktgd * (Tdev / Tnom - 1));
					t3_2 = w * l * nf * igddio * exp(ktgd * (Tdev / Tnom - 1));
					`IDIO3(t3_2, njgd_t_2, agd, V(gi_2, di_2), vbid_t_2, rnjgd_t_2, ebreakd, rigddio_t_2, Igd_2);
                end
            endcase
            I(gi_1,si_1) <+ mult_i1*Igs_1;    //Hars
			I(gi_2,si_2) <+ mult_i2*Igs_2;    //Hars
            I(gi_2,di) <+ mult_i2*Igd_2;      //Hars
			I(gi_1,di) <+ mult_i1*Igd_1;      //Hars
////////// Access Region Non-linear Resistance Model //////////
            ars_chk = $param_given(ars);
            ard_chk = $param_given(ard);
            vgopacc = vgop;
			
			// Sourrce resistance calculation    //Hars
            if (rdsmod_i == 1) begin
				ns0_t_1 = ns0accs*(1.0 - kns0*(Tdev/Tnom-1.0)) - ns0sdlag - ns0sglag + (ksub/`P_Q)*Vbs*Cepi;
				ns0_t_1 = hypmax(ns0_t_1, 1.0, 1.0e-3);
				qsacc_1 = `P_Q * ns0_t_1 * (1.0 + k0accs * vgopacc);
				vsataccs_t = vsataccs * pow((Tdev / Tnom), ats); // Vsat Temperature Dependence
				isatacc_1 = w * nf * qsacc_1 * vsataccs_t;
				u0accs_t = u0accs * pow((Tdev / Tnom), utes);    // Mobility Temperature Dependence
				rs0_1 = lsg / (w * nf * qsacc_1 * u0accs_t);

				if (ars_chk != 0) begin
					`isat(Ids_1, isatacc_1, ars, idseff_1)
					t2_1 = 1.0 - (idseff_1 / isatacc_1);
				end else begin
					cr_1  = abs(Ids_1 / isatacc_1);
					crm_1 = smoothmax(cr_1, 0.9, 0.1);
					t0_1 = pow(crm_1, mexpaccs);
					t1_1 = 1.0 - t0_1;
					t2_1 = pow(t1_1, 1.0 / mexpaccs);
				end
				rsbias_1 = rs0_1 / t2_1;
				rsc_t = rsc * (1.0 + krsc * (Tdev / Tnom - 1.0));
				Rsource_1 = rsc_t / (w * nf) + rsbias_1 + rs_cap;

				// --- Drain Resistance Calculation ---
				ns0_t_1 = ns0accd*(1.0 - kns0*(Tdev/Tnom-1.0)) - ns0ddlag - ns0dglag + (ksub/`P_Q)*Vbs*Cepi;
				ns0_t_1 = hypmax(ns0_t_1, 1.0, 1.0e-3);
				qsacc_1 = `P_Q * ns0_t_1 * (1.0 + k0accd * vgopacc);
				isatacc_1 = w * nf * qsacc_1 * vsataccs_t;
				u0accd_t = u0accd * pow((Tdev / Tnom), uted);
				rd0_1 = ldg / (w * nf * qsacc_1 * u0accd_t);

				if (ard_chk != 0) begin
					`isat(Ids_1, isatacc_1, ard, idseff_1)
					t2_1 = 1.0 - (idseff_1 / isatacc_1);
				end else begin
					cr_1  = abs(Ids_1 / isatacc_1);
					crm_1 = smoothmax(cr_1, 0.9, 0.1);
					t0_1 = pow(crm_1, mexpaccd);
					t1_1 = 1.0 - t0_1;
					t2_1 = pow(t1_1, 1.0 / mexpaccd);
				end
				rdbias_1 = rd0_1 / t2_1;
				rdc_t = rdc * (1.0 + krdc * (Tdev / Tnom - 1.0));
				Rdrain_1 = rdc_t / (w * nf) + rdbias_1 + Rtrap_t + ron_trap + rd_cap;

				gdpr_1 = 1.0 / Rdrain_1;
				gspr_1 = 1.0 / Rsource_1;

				if (fastfpmod == 0) begin
					I(d_1, `IntrinsicDrain_fp4) <+ mult_i * gdpr_1 * V(d_1, `IntrinsicDrain_fp4);
					I(`IntrinsicSource_fp4s, s_1) <+ mult_i * gspr_1 * V(`IntrinsicSource_fp4s, s_1);
				end else begin
					I(d_1, di_1) <+ mult_i * gdpr_1 * V(d_1, di_1);
					I(si_1, s_1) <+ mult_i * gspr_1 * V(si_1, s_1);
				end

				// --- MOSFET 2 ---
				ns0_t_2 = ns0accs*(1.0 - kns0*(Tdev/Tnom-1.0)) - ns0sdlag - ns0sglag + (ksub/`P_Q)*Vbs*Cepi;
				ns0_t_2 = hypmax(ns0_t_2, 1.0, 1.0e-3);
				qsacc_2 = `P_Q * ns0_t_2 * (1.0 + k0accs * vgopacc);
				isatacc_2 = w * nf * qsacc_2 * vsataccs_t;
				rs0_2 = lsg / (w * nf * qsacc_2 * u0accs_t);

				if (ars_chk != 0) begin
					`isat(Ids_2, isatacc_2, ars, idseff_2)
					t2_2 = 1.0 - (idseff_2 / isatacc_2);
				end else begin
					cr_2  = abs(Ids_2 / isatacc_2);
					crm_2 = smoothmax(cr_2, 0.9, 0.1);
					t0_2 = pow(crm_2, mexpaccs);
					t1_2 = 1.0 - t0_2;
					t2_2 = pow(t1_2, 1.0 / mexpaccs);
				end
				rsbias_2 = rs0_2 / t2_2;
				Rsource_2 = rsc_t / (w * nf) + rsbias_2 + rs_cap;

				ns0_t_2 = ns0accd*(1.0 - kns0*(Tdev/Tnom-1.0)) - ns0ddlag - ns0dglag + (ksub/`P_Q)*Vbs*Cepi;
				ns0_t_2 = hypmax(ns0_t_2, 1.0, 1.0e-3);
				qsacc_2 = `P_Q * ns0_t_2 * (1.0 + k0accd * vgopacc);
				isatacc_2 = w * nf * qsacc_2 * vsataccs_t;
				rd0_2 = ldg / (w * nf * qsacc_2 * u0accd_t);

				if (ard_chk != 0) begin
					`isat(Ids_2, isatacc_2, ard, idseff_2)
					t2_2 = 1.0 - (idseff_2 / isatacc_2);
				end else begin
					cr_2  = abs(Ids_2 / isatacc_2);
					crm_2 = smoothmax(cr_2, 0.9, 0.1);
					t0_2 = pow(crm_2, mexpaccd);
					t1_2 = 1.0 - t0_2;
					t2_2 = pow(t1_2, 1.0 / mexpaccd);
				end
				rdbias_2 = rd0_2 / t2_2;
				Rdrain_2 = rdc_t / (w * nf) + rdbias_2 + Rtrap_t + ron_trap + rd_cap;

				gdpr_2 = 1.0 / Rdrain_2;
				gspr_2 = 1.0 / Rsource_2;

				if (fastfpmod == 0) begin
					I(d_2, `IntrinsicDrain_fp4) <+ mult_i * gdpr_2 * V(d_2, `IntrinsicDrain_fp4);
					I(`IntrinsicSource_fp4s, s_2) <+ mult_i * gspr_2 * V(`IntrinsicSource_fp4s, s_2);
				end else begin
					I(d_2, di_2) <+ mult_i * gdpr_2 * V(d_2, di_2);
					I(si_2, s_2) <+ mult_i * gspr_2 * V(si_2, s_2);
				end

			end else begin
				if (fastfpmod == 1) begin
					V(d_1, `IntrinsicDrain_fp4) <+ 0.0;
					V(s_1, `IntrinsicSource_fp4s) <+ 0.0;
					V(d_2, `IntrinsicDrain_fp4) <+ 0.0;
					V(s_2, `IntrinsicSource_fp4s) <+ 0.0;
				end else begin
					V(d_1, di_1) <+ 0.0;
					V(si_1, s_1) <+ 0.0;
					V(d_2, di_2) <+ 0.0;
					V(si_2, s_2) <+ 0.0;
				end
			end
//////////  Noise Modeling  //////////

////////// Thermal Noise Model //////////
            if (tnmod==1) begin
                ThSid = (tnsc/(max(Ids,1e-10)*l*l))*(4.0*`KboQ*`P_Q*Tdev*`P_Q*w*nf*Cg*`P_Q*w*nf*Cg)*((mu_eff/vf)*(mu_eff/vf))*(Vg0*Vg0*psisd+((psid*psid*psid-psis*psis*psis)/3)-Vg0*(psid*psid-psis*psis)); //Channel Thermal Noise PSD
                I(di, si) <+ white_noise(ThSid * mult_i, "ids");
                if (rdsmod_i==1) begin
                    if (fastfpmod == 0) begin
                        I(d, `IntrinsicDrain_fp4) <+ white_noise(4.0 * Vth * `P_Q * gdpr * mult_i, "rd");
                        I(s, `IntrinsicSource_fp4s) <+ white_noise(4.0 * Vth * `P_Q * gspr * mult_i, "rs");
                    end else begin
                        I(d, di) <+ white_noise(4.0 * Vth * `P_Q * gdpr * mult_i, "rd");
                        I(s, si) <+ white_noise(4.0 * Vth * `P_Q * gspr * mult_i, "rs");
                    end
                end
            end
////////// Shot Noise Model ///////////
            if (gatemod!= 0) begin
                I(gi, si) <+ white_noise(2.0 * `P_Q * abs(Igs) * mult_i, "igs");
                I(gi, di) <+ white_noise(2.0 * `P_Q * abs(Igd) * mult_i, "igd");
            end
////////// FP1 Current Model //////////
            `ifdef __FP1MOD__
                if (fastfpmod == 0) begin
                    if (fp1mod != 0) begin
                        Vds_noswapfp1 = V(fp1,di);
                        if (fp1mod == 1) begin
                            Vgs_noswapfp1 = V(gi,di);
                            Vgd_noswapfp1 = V(gi,fp1);
                        end else begin
                            Vgs_noswapfp1 = V(s,di);
                            Vgd_noswapfp1 = V(s,fp1);
                        end
                        sigvdsfp1 = 1.0;
                        if (Vds_noswapfp1 < 0.0) begin
                            sigvdsfp1 = -1.0;
                            Vds_fp1 = sigvdsfp1*Vds_noswapfp1 ;
                            Vgs_fp1 = Vgd_noswapfp1 ;
                        end else begin
                            Vds_fp1 = Vds_noswapfp1 ;
                            Vgs_fp1 = Vgs_noswapfp1 ;
                        end
                        Vdsx_fp1 = sqrt(Vds_fp1*Vds_fp1 + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp1 + cdscdfp1*Vdsx_fp1; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp1 + (Tdev/Tnom - 1.0)*ktfp1 - (eta0fp1)*(Vdsx_fp1*vdscalefp1)/sqrt(Vdsx_fp1*Vdsx_fp1 + vdscalefp1*vdscalefp1);
                        Cg_fp1 = epsilon/dfp1;
                        `VG0(lfp1,w,Voff_dibl_temp,iminfp1,Vgs_fp1,Vtv,Vg0_fp1)
                        `PSIS(Cg_fp1,Vg0_fp1,gamma0fp1,gamma1fp1,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp1)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp1,ute,vsatfp1,at,Cg_fp1,psis_fp1,Vg0_fp1,Vbs,ua,ub,uc,lfp1,Vds_fp1,gamma0fp1,gamma1fp1,   mulf_tdev,Vdeff,psid_fp1)
                        psim_fp1 = 0.5*(psis_fp1 + psid_fp1);
                        psisd_fp1 = psid_fp1 - psis_fp1;
                        `IDS(Vg0_fp1,psim_fp1,psisd_fp1,Cg_fp1,Cepi,lfp1,Vdsx_fp1,w,nf,Vtv,mulf_tdev,Vdeff,   Ids_fp1)
                        I(fp1,di) <+ mult_i*sigvdsfp1*Ids_fp1 + mult_i*gdsmin_t*V(fp1,di);
                        `QGI(Vg0_fp1,psis_fp1,psid_fp1,psim_fp1,Cg_fp1,lfp1,qm0fp1,bdosfp1,adosfp1,dfp1,Vtv,w,nf,   Cg_qme,qg_fp1)
                        `QDI(Vg0_fp1,psim_fp1,psis_fp1,psid_fp1,psisd_fp1,lfp1,Vtv,w,nf,Cg_qme,   qd_fp1)
                        qs_fp1 = -1.0*qg_fp1 -1.0*qd_fp1;
                        if (sigvdsfp1 < 0.0) begin
                            t1 = qd_fp1;
                            qd_fp1 = qs_fp1;
                            qs_fp1 = t1;
                        end
                    end else begin
                        V(fp1,di) <+ 0.0;
                        qg_fp1 = 0;
                        qd_fp1 = 0;
                    end
                end else begin
                    V(fp1,di) <+ 0.0;
                    if (fp1mod != 0) begin
                        if (fp1mod == 1) begin
                            Vgs_noswapfp1 = V(gi,di);
                        end else begin
                            Vgs_noswapfp1 = V(s,di);
                        end
                        Vgs_fp1 = Vgs_noswapfp1;
                        cdsc = 1.0 + nfactorfp1 ; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp1 + (Tdev/Tnom - 1.0)*ktfp1 ;
                        Cg_fp1 = epsilon/dfp1;
                        `VG0(lfp1,w,Voff_dibl_temp,iminfp1,Vgs_fp1,Vtv,Vg0_fp1)
                        `PSIS(Cg_fp1,Vg0_fp1,gamma0fp1,gamma1fp1,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp1)
                        Vds_fp1 = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp1,ute,vsatfp1,at,Cg_fp1,psis_fp1,Vg0_fp1,Vbs,ua,ub,uc,lfp1,Vds_fp1,gamma0fp1,gamma1fp1,   mulf_tdev,Vdeff,psid_fp1)
                        psim_fp1 = 0.5*(psis_fp1 + psid_fp1);
                        psisd_fp1 = psid_fp1 - psis_fp1;
                        `QGI(Vg0_fp1,psis_fp1,psid_fp1,psim_fp1,Cg_fp1,lfp1,qm0fp1,bdosfp1,adosfp1,dfp1,Vtv,w,nf,   Cg_qme,qg_fp1)
                        `QDI(Vg0_fp1,psim_fp1,psis_fp1,psid_fp1,psisd_fp1,lfp1,Vtv,w,nf,Cg_qme,   qd_fp1)
                        qs_fp1 = -1.0*qg_fp1 -1.0*qd_fp1;
                    end else begin
                        qg_fp1 = 0;
                        qd_fp1 = 0;
                    end
                end
            `endif
///////////// FP1 Source side current model //////////////////////////////////////////////
            `ifdef __FP1SMOD__
                if (fastfpmod == 0) begin
                    if (fp1smod != 0) begin
                        Vds_noswapfp1s = V(si,fp1s);
                        if (fp1smod == 1) begin
                            Vgs_noswapfp1s = V(gi,fp1s);
                            Vgd_noswapfp1s = V(gi,si);
                        end else begin
                            Vgs_noswapfp1s = V(s,fp1s);
                            Vgd_noswapfp1s = V(s,si);
                        end
                        sigvdsfp1s = 1.0;
                        if (Vds_noswapfp1s < 0.0) begin
                            sigvdsfp1s = -1.0;
                            Vds_fp1s = sigvdsfp1s*Vds_noswapfp1s ;
                            Vgs_fp1s = Vgd_noswapfp1s ;
                        end else begin
                            Vds_fp1s = Vds_noswapfp1s ;
                            Vgs_fp1s = Vgs_noswapfp1s ;
                        end
                        Vdsx_fp1s = sqrt(Vds_fp1s*Vds_fp1s + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp1 + cdscdfp1*Vdsx_fp1s; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp1 + (Tdev/Tnom - 1.0)*ktfp1 - (eta0fp1)*(Vdsx_fp1s*vdscalefp1)/sqrt(Vdsx_fp1s*Vdsx_fp1s + vdscalefp1*vdscalefp1);
                        Cg_fp1s = epsilon/dfp1;
                        `VG0(lfp1,w,Voff_dibl_temp,iminfp1,Vgs_fp1s,Vtv,Vg0_fp1s)
                        `PSIS(Cg_fp1s,Vg0_fp1s,gamma0fp1,gamma1fp1,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp1s)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp1,ute,vsatfp1,at,Cg_fp1s,psis_fp1s,Vg0_fp1s,Vbs,ua,ub,uc,lfp1,Vds_fp1s,gamma0fp1,gamma1fp1,   mulf_tdev,Vdeff,psid_fp1s)
                        psim_fp1s = 0.5*(psis_fp1s + psid_fp1s);
                        psisd_fp1s = psid_fp1s - psis_fp1s;
                        `IDS(Vg0_fp1s,psim_fp1s,psisd_fp1s,Cg_fp1s,Cepi,lfp1,Vdsx_fp1s,w,nf,Vtv,mulf_tdev,Vdeff,   Ids_fp1s)
                        I(si,fp1s) <+ mult_i*sigvdsfp1s*Ids_fp1s + mult_i*gdsmin_t*V(si,fp1s);
                        `QGI(Vg0_fp1s,psis_fp1s,psid_fp1s,psim_fp1s,Cg_fp1s,lfp1,qm0fp1,bdosfp1,adosfp1,dfp1,Vtv,w,nf,   Cg_qme,qg_fp1s)
                        `QDI(Vg0_fp1s,psim_fp1s,psis_fp1s,psid_fp1s,psisd_fp1s,lfp1,Vtv,w,nf,Cg_qme,   qd_fp1s)
                        qs_fp1s = -1.0*qg_fp1s -1.0*qd_fp1s;
                        if (sigvdsfp1s < 0.0) begin
                            t1 = qd_fp1s;
                            qd_fp1s = qs_fp1s;
                            qs_fp1s = t1;
                        end
                    end else begin
                        V(si,fp1s) <+ 0.0;
                        qg_fp1s = 0;
                        qd_fp1s = 0;
                    end
                end else begin
                    V(si,fp1s) <+ 0.0;
                    if (fp1smod != 0) begin
                        if (fp1smod == 1) begin
                            Vgs_noswapfp1s = V(gi,si);
                        end else begin
                            Vgs_noswapfp1s = V(s,si);
                        end
                        Vg0_fp1s = Vgs_noswapfp1s;
                        cdsc = 1.0 + nfactorfp1; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp1 + (Tdev/Tnom - 1.0)*ktfp1;
                        Cg_fp1s = epsilon/dfp1;
                        `VG0(lfp1,w,Voff_dibl_temp,iminfp1,Vgs_fp1s,Vtv,Vg0_fp1s)
                        `PSIS(Cg_fp1s,Vg0_fp1s,gamma0fp1,gamma1fp1,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp1s)
                        Vds_fp1s = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp1,ute,vsatfp1,at,Cg_fp1s,psis_fp1s,Vg0_fp1s,Vbs,ua,ub,uc,lfp1,Vds_fp1s,gamma0fp1,gamma1fp1,   mulf_tdev,Vdeff,psid_fp1s)
                        psim_fp1s = 0.5*(psis_fp1s + psid_fp1s);
                        psisd_fp1s = psid_fp1s - psis_fp1s;
                        `QGI(Vg0_fp1s,psis_fp1s,psid_fp1s,psim_fp1s,Cg_fp1s,lfp1,qm0fp1,bdosfp1,adosfp1,dfp1,Vtv,w,nf,   Cg_qme,qg_fp1s)
                        `QDI(Vg0_fp1s,psim_fp1s,psis_fp1s,psid_fp1s,psisd_fp1s,lfp1,Vtv,w,nf,Cg_qme,   qd_fp1s)
                        qs_fp1s = -1.0*qg_fp1s -1.0*qd_fp1s;
                    end else begin
                        qg_fp1s = 0;
                        V(si,fp1s) <+ 0.0;
                        qd_fp1s = 0;
                    end
                end
            `endif
////////// FP2 Current Model //////////
            `ifdef __FP2MOD__
                if (fastfpmod == 0) begin
                    if (fp2mod != 0) begin
                        Vds_noswapfp2 = V(fp2,`IntrinsicDrain_fp1);
                        if (fp2mod == 1) begin
                            Vgs_noswapfp2 = V(gi,`IntrinsicDrain_fp1);
                            Vgd_noswapfp2 = V(gi,fp2);
                        end else begin
                            Vgs_noswapfp2 = V(s,`IntrinsicDrain_fp1);
                            Vgd_noswapfp2 = V(s,fp2);
                        end
                        sigvdsfp2 = 1.0;
                        if (Vds_noswapfp2 < 0.0) begin
                            sigvdsfp2 = -1.0;
                            Vds_fp2 = sigvdsfp2*Vds_noswapfp2 ;
                            Vgs_fp2 = Vgd_noswapfp2 ;
                        end else begin
                            Vds_fp2 = Vds_noswapfp2 ;
                            Vgs_fp2 = Vgs_noswapfp2 ;
                        end

                        Vdsx_fp2 = sqrt(Vds_fp2*Vds_fp2 + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp2 + cdscdfp2*Vdsx_fp2; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp2 - (Tdev/Tnom - 1.0)*ktfp2 - (eta0fp2)*(Vdsx_fp2*vdscalefp2)/sqrt(Vdsx_fp2*Vdsx_fp2 + vdscalefp2*vdscalefp2);
                        Cg_fp2 = epsilon/(dfp2);
                        `VG0(lfp2,w,Voff_dibl_temp,iminfp2,Vgs_fp2,Vtv,Vg0_fp2)
                        `PSIS(Cg_fp2,Vg0_fp2,gamma0fp2,gamma1fp2,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp2)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp2,ute,vsatfp2,at,Cg_fp2,psis_fp2,Vg0_fp2,Vbs,ua,ub,uc,lfp2,Vds_fp2,gamma0fp2,gamma1fp2,   mulf_tdev,Vdeff,psid_fp2)
                        psim_fp2 = 0.5*(psis_fp2 + psid_fp2);
                        psisd_fp2 = psid_fp2 - psis_fp2 ;
                        `IDS(Vg0_fp2,psim_fp2,psisd_fp2,Cg_fp2,Cepi,lfp2,Vdsx_fp2,w,nf,Vtv,mulf_tdev,Vdeff,   Ids_fp2)
                        I(fp2,`IntrinsicDrain_fp1) <+ mult_i*sigvdsfp2*Ids_fp2 + mult_i*gdsmin_t*V(fp2,`IntrinsicDrain_fp1);
                        `QGI(Vg0_fp2,psis_fp2,psid_fp2,psim_fp2,Cg_fp2,lfp2,qm0fp2,bdosfp2,adosfp2,dfp2,Vtv,w,nf,   Cg_qme,qg_fp2)
                        `QDI(Vg0_fp2,psim_fp2,psis_fp2,psid_fp2,psisd_fp2,lfp2,Vtv,w,nf,Cg_qme,   qd_fp2)
                        qs_fp2 = -1.0*qg_fp2 -1.0*qd_fp2;
                        if (sigvdsfp2 < 0.0) begin
                            t1 = qd_fp2;
                            qd_fp2 = qs_fp2;
                            qs_fp2 = t1;
                        end
                    end else begin
                        V(fp2,`IntrinsicDrain_fp1) <+ 0.0;
                        qg_fp2 = 0;
                        qd_fp2 = 0;
                    end
                end else begin
                    V(fp2,di) <+ 0.0;
                    if (fp2mod != 0) begin
                        if (fp2mod == 1) begin
                            Vgs_noswapfp2 = V(gi,di);
                        end else begin
                            Vgs_noswapfp2 = V(s,di);
                        end
                        Vgs_fp2 = Vgs_noswapfp2;
                        cdsc = 1.0 + nfactorfp2; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp2 - (Tdev/Tnom - 1.0)*ktfp2 ;
                        Cg_fp2 = epsilon/(dfp2);
                        `VG0(lfp2,w,Voff_dibl_temp,iminfp2,Vgs_fp2,Vtv,Vg0_fp2)
                        `PSIS(Cg_fp2,Vg0_fp2,gamma0fp2,gamma1fp2,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp2)
                        Vds_fp2 = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp2,ute,vsatfp2,at,Cg_fp2,psis_fp2,Vg0_fp2,Vbs,ua,ub,uc,lfp2,Vds_fp2,gamma0fp2,gamma1fp2,   mulf_tdev,Vdeff,psid_fp2)
                        psim_fp2 = 0.5*(psis_fp2 + psid_fp2);
                        psisd_fp2 = psid_fp2 - psis_fp2 ;
                        `QGI(Vg0_fp2,psis_fp2,psid_fp2,psim_fp2,Cg_fp2,lfp2,qm0fp2,bdosfp2,adosfp2,dfp2,Vtv,w,nf,   Cg_qme,qg_fp2)
                        `QDI(Vg0_fp2,psim_fp2,psis_fp2,psid_fp2,psisd_fp2,lfp2,Vtv,w,nf,Cg_qme,   qd_fp2)
                        qs_fp2 = -1.0*qg_fp2 -1.0*qd_fp2;
                    end else begin
                        qg_fp2 = 0;
                        qd_fp2 = 0;
                    end
                end
            `endif
///////////// FP2 Source side current model //////////////////////////////////////////////
            `ifdef __FP2SMOD__
                if (fastfpmod == 0) begin
                    if (fp2smod != 0) begin
                        Vds_noswapfp2s = V(`IntrinsicSource_fp1s,fp2s);
                        if (fp2smod == 1) begin
                            Vgs_noswapfp2s = V(gi,fp2s);
                            Vgd_noswapfp2s = V(gi,`IntrinsicSource_fp1s);
                        end else begin
                            Vgs_noswapfp2s = V(s,fp2s);
                            Vgd_noswapfp2s = V(s,`IntrinsicSource_fp1s);
                        end
                        sigvdsfp2s = 1.0;
                        if (Vds_noswapfp2s < 0.0) begin
                            sigvdsfp2s = -1.0;
                            Vds_fp2s = sigvdsfp2s*Vds_noswapfp2s ;
                            Vgs_fp2s = Vgd_noswapfp2s ;
                        end else begin
                            Vds_fp2s = Vds_noswapfp2s ;
                            Vgs_fp2s = Vgs_noswapfp2s ;
                        end

                        Vdsx_fp2s = sqrt(Vds_fp2s*Vds_fp2s + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp2 + cdscdfp2*Vdsx_fp2s; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp2 + (Tdev/Tnom - 1.0)*ktfp2 - (eta0fp2)*(Vdsx_fp2s*vdscalefp2)/sqrt(Vdsx_fp2s*Vdsx_fp2s + vdscalefp2*vdscalefp2);
                        Cg_fp2s = epsilon/dfp2;
                        `VG0(lfp2,w,Voff_dibl_temp,iminfp2,Vgs_fp2s,Vtv,Vg0_fp2s)
                        `PSIS(Cg_fp2s,Vg0_fp2s,gamma0fp2,gamma1fp2,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp2s)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp2,ute,vsatfp2,at,Cg_fp2s,psis_fp2s,Vg0_fp2s,Vbs,ua,ub,uc,lfp2,Vds_fp2s,gamma0fp2,gamma1fp2,   mulf_tdev,Vdeff,psid_fp2s)
                        psim_fp2s = 0.5*(psis_fp2s + psid_fp2s);
                        psisd_fp2s = psid_fp2s - psis_fp2s;
                        `IDS(Vg0_fp2s,psim_fp2s,psisd_fp2s,Cg_fp2s,Cepi,lfp2,Vdsx_fp2s,w,nf,Vtv,mulf_tdev,Vdeff,   Ids_fp2s)
                        I(`IntrinsicSource_fp1s,fp2s) <+ mult_i*sigvdsfp2s*Ids_fp2s + mult_i*gdsmin_t*V(`IntrinsicSource_fp1s,fp2s);
                        `QGI(Vg0_fp2s,psis_fp2s,psid_fp2s,psim_fp2s,Cg_fp2s,lfp2,qm0fp2,bdosfp2,adosfp2,dfp2,Vtv,w,nf,   Cg_qme,qg_fp2s)
                        `QDI(Vg0_fp2s,psim_fp2s,psis_fp2s,psid_fp2s,psisd_fp2s,lfp2,Vtv,w,nf,Cg_qme,   qd_fp2s)
                        qs_fp2s = -1.0*qg_fp2s -1.0*qd_fp2s;
                        if (sigvdsfp2s < 0.0) begin
                            t1 = qd_fp2s;
                            qd_fp2s = qs_fp2s;
                            qs_fp2s = t1;
                        end
                    end else begin
                        V(`IntrinsicSource_fp1s,fp2s) <+ 0.0;
                        qg_fp2s = 0;
                        qd_fp2s = 0;
                    end
                end else begin
                    V(si,fp2s) <+ 0.0;
                    if (fp2smod != 0) begin
                        if (fp2smod == 1) begin
                            Vgs_noswapfp2s = V(gi,si);
                        end else begin
                            Vgs_noswapfp2s = V(s,si);
                        end
                        Vgs_fp2s = Vgs_noswapfp2s;
                        cdsc = 1.0 + nfactorfp2 ; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp2 + (Tdev/Tnom - 1.0)*ktfp2 ;
                        Cg_fp2s = epsilon/dfp2;
                        `VG0(lfp2,w,Voff_dibl_temp,iminfp2,Vgs_fp2s,Vtv,Vg0_fp2s)
                        `PSIS(Cg_fp2s,Vg0_fp2s,gamma0fp2,gamma1fp2,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp2s)
                        Vds_fp2s = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp2,ute,vsatfp2,at,Cg_fp2s,psis_fp2s,Vg0_fp2s,Vbs,ua,ub,uc,lfp2,Vds_fp2s,gamma0fp2,gamma1fp2,   mulf_tdev,Vdeff,psid_fp2s)
                        psim_fp2s = 0.5*(psis_fp2s + psid_fp2s);
                        psisd_fp2s = psid_fp2s - psis_fp2s;
                        `QGI(Vg0_fp2s,psis_fp2s,psid_fp2s,psim_fp2s,Cg_fp2s,lfp2,qm0fp2,bdosfp2,adosfp2,dfp2,Vtv,w,nf,   Cg_qme,qg_fp2s)
                        `QDI(Vg0_fp2s,psim_fp2s,psis_fp2s,psid_fp2s,psisd_fp2s,lfp2,Vtv,w,nf,Cg_qme,   qd_fp2s)
                        qs_fp2s = -1.0*qg_fp2s -1.0*qd_fp2s;
                    end else begin
                        qg_fp2s = 0;
                        V(si,fp2s) <+ 0.0;
                        qd_fp2s = 0;
                    end
                end
            `endif
////////// FP3 Current Model //////////
            `ifdef __FP3MOD__
                if (fastfpmod == 0) begin
                    if (fp3mod != 0) begin
                        Vds_noswapfp3 = V(fp3,`IntrinsicDrain_fp2);
                        if (fp3mod == 1) begin
                            Vgs_noswapfp3 = V(gi,`IntrinsicDrain_fp2);
                            Vgd_noswapfp3 = V(gi,fp3);
                        end else begin
                            Vgs_noswapfp3 = V(s,`IntrinsicDrain_fp2);
                            Vgd_noswapfp3 = V(s,fp3);
                        end
                        sigvdsfp3 = 1.0;
                        if (Vds_noswapfp3 < 0.0) begin
                            sigvdsfp3 = -1.0;
                            Vds_fp3 = sigvdsfp3*Vds_noswapfp3 ;
                            Vgs_fp3 = Vgd_noswapfp3 ;
                        end else begin
                            Vds_fp3 = Vds_noswapfp3 ;
                            Vgs_fp3 = Vgs_noswapfp3 ;
                        end

                        Vdsx_fp3 = sqrt(Vds_fp3*Vds_fp3 + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp3 + cdscdfp3*Vdsx_fp3; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp3 - (Tdev/Tnom - 1.0)*ktfp3 - (eta0fp3)*(Vdsx_fp3*vdscalefp3)/sqrt(Vdsx_fp3*Vdsx_fp3 + vdscalefp3*vdscalefp3);
                        Cg_fp3 = epsilon/(dfp3);
                        `VG0(lfp3,w,Voff_dibl_temp,iminfp3,Vgs_fp3,Vtv,Vg0_fp3)
                        `PSIS(Cg_fp3,Vg0_fp3,gamma0fp3,gamma1fp3,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp3)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp3,ute,vsatfp3,at,Cg_fp3,psis_fp3,Vg0_fp3,Vbs,ua,ub,uc,lfp3,Vds_fp3,gamma0fp3,gamma1fp3,    mulf_tdev,Vdeff,psid_fp3)
                        psim_fp3 = 0.5*(psis_fp3 + psid_fp3);
                        psisd_fp3 = psid_fp3 - psis_fp3 ;
                        `IDS(Vg0_fp3,psim_fp3,psisd_fp3,Cg_fp3,Cepi,lfp3,Vdsx_fp3,w,nf,Vtv,mulf_tdev,Vdeff,   Ids_fp3)
                        I(fp3,`IntrinsicDrain_fp2) <+ mult_i*sigvdsfp3*Ids_fp3 + mult_i*gdsmin_t*V(fp3,`IntrinsicDrain_fp2);
                        `QGI(Vg0_fp3,psis_fp3,psid_fp3,psim_fp3,Cg_fp3,lfp3,qm0fp3,bdosfp3,adosfp3,dfp3,Vtv,w,nf,   Cg_qme,qg_fp3)
                        `QDI(Vg0_fp3,psim_fp3,psis_fp3,psid_fp3,psisd_fp3,lfp3,Vtv,w,nf,Cg_qme,   qd_fp3)
                        qs_fp3 = -1.0*qg_fp3 -1.0*qd_fp3;
                        if (sigvdsfp3 < 0.0) begin
                            t1 = qd_fp3;
                            qd_fp3 = qs_fp3;
                            qs_fp3 = t1;
                        end
                    end else begin
                        V(fp3,`IntrinsicDrain_fp2) <+ 0.0;
                        qg_fp3 = 0;
                        qd_fp3 = 0;
                    end
                end else begin
                    V(fp3,di) <+ 0.0;
                    if (fp3mod != 0) begin
                        if (fp3mod == 1) begin
                            Vgs_noswapfp3 = V(gi,di);
                        end else begin
                            Vgs_noswapfp3 = V(s,di);
                        end
                        Vgs_fp3 = Vgs_noswapfp3;
                        cdsc = 1.0 + nfactorfp3 ; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp3 - (Tdev/Tnom - 1.0)*ktfp3 ;
                        Cg_fp3 = epsilon/(dfp3);
                        `VG0(lfp3,w,Voff_dibl_temp,iminfp3,Vgs_fp3,Vtv,Vg0_fp3)
                        `PSIS(Cg_fp3,Vg0_fp3,gamma0fp3,gamma1fp3,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp3)
                        Vds_fp3 = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp3,ute,vsatfp3,at,Cg_fp3,psis_fp3,Vg0_fp3,Vbs,ua,ub,uc,lfp3,Vds_fp3,gamma0fp3,gamma1fp3,    mulf_tdev,Vdeff,psid_fp3)
                        psim_fp3 = 0.5*(psis_fp3 + psid_fp3);
                        psisd_fp3 = psid_fp3 - psis_fp3 ;
                        `QGI(Vg0_fp3,psis_fp3,psid_fp3,psim_fp3,Cg_fp3,lfp3,qm0fp3,bdosfp3,adosfp3,dfp3,Vtv,w,nf,   Cg_qme,qg_fp3)
                        `QDI(Vg0_fp3,psim_fp3,psis_fp3,psid_fp3,psisd_fp3,lfp3,Vtv,w,nf,Cg_qme,   qd_fp3)
                        qs_fp3 = -1.0*qg_fp3 -1.0*qd_fp3;
                    end else begin
                        qg_fp3 = 0;
                        qd_fp3 = 0;
                    end
                end
            `endif
//////////// FP3 Source side current model //////////////////////////////////////////////
            `ifdef __FP3SMOD__
                if (fastfpmod == 0) begin
                    if (fp3smod != 0) begin
                        Vds_noswapfp3s = V(`IntrinsicSource_fp2s,fp3s);
                        if (fp3smod == 1) begin
                            Vgs_noswapfp3s = V(gi,fp3s);
                            Vgd_noswapfp3s = V(gi,`IntrinsicSource_fp2s);
                        end else begin
                            Vgs_noswapfp3s = V(s,fp3s);
                            Vgd_noswapfp3s = V(s,`IntrinsicSource_fp2s);
                        end
                        sigvdsfp3s = 1.0;
                        if (Vds_noswapfp3s < 0.0) begin
                            sigvdsfp3s = -1.0;
                            Vds_fp3s = sigvdsfp3s*Vds_noswapfp3s ;
                            Vgs_fp3s = Vgd_noswapfp3s ;
                        end else begin
                            Vds_fp3s = Vds_noswapfp3s ;
                            Vgs_fp3s = Vgs_noswapfp3s ;
                        end

                        Vdsx_fp3s = sqrt(Vds_fp3s*Vds_fp3s + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp3 + cdscdfp3*Vdsx_fp3s; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp3 + (Tdev/Tnom - 1.0)*ktfp3 - (eta0fp3)*(Vdsx_fp3s*vdscalefp3)/sqrt(Vdsx_fp3s*Vdsx_fp3s + vdscalefp3*vdscalefp3);
                        Cg_fp3s = epsilon/dfp3;
                        `VG0(lfp3,w,Voff_dibl_temp,iminfp3,Vgs_fp3s,Vtv,Vg0_fp3s)
                        `PSIS(Cg_fp3s,Vg0_fp3s,gamma0fp3,gamma1fp3,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp3s)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp3,ute,vsatfp3,at,Cg_fp3s,psis_fp3s,Vg0_fp3s,Vbs,ua,ub,uc,lfp3,Vds_fp3s,gamma0fp3,gamma1fp3,   mulf_tdev,Vdeff,psid_fp3s)
                        psim_fp3s = 0.5*(psis_fp3s + psid_fp3s);
                        psisd_fp3s = psid_fp3s - psis_fp3s;
                        `IDS(Vg0_fp3s,psim_fp3s,psisd_fp3s,Cg_fp3s,Cepi,lfp3,Vdsx_fp3s,w,nf,Vtv,mulf_tdev,Vdeff,   Ids_fp3s)
                        I(`IntrinsicSource_fp2s,fp3s) <+ mult_i*sigvdsfp3s*Ids_fp3s + mult_i*gdsmin_t*V(`IntrinsicSource_fp2s,fp3s);
                        `QGI(Vg0_fp3s,psis_fp3s,psid_fp3s,psim_fp3s,Cg_fp3s,lfp3,qm0fp3,bdosfp3,adosfp3,dfp3,Vtv,w,nf,   Cg_qme,qg_fp3s)
                        `QDI(Vg0_fp3s,psim_fp3s,psis_fp3s,psid_fp3s,psisd_fp3s,lfp3,Vtv,w,nf,Cg_qme,   qd_fp3s)
                        qs_fp3s = -1.0*qg_fp3s -1.0*qd_fp3s;
                        if (sigvdsfp3s < 0.0) begin
                            t1 = qd_fp3s;
                            qd_fp3s = qs_fp3s;
                            qs_fp3s = t1;
                        end
                    end else begin
                        V(`IntrinsicSource_fp2s,fp3s) <+ 0.0;
                        qg_fp3s = 0;
                        qd_fp3s = 0;
                    end
                end else begin
                    V(si,fp3s) <+ 0.0;
                    if (fp3smod != 0) begin
                        if (fp3smod == 1) begin
                            Vgs_noswapfp3s = V(gi,si);
                        end else begin
                            Vgs_noswapfp3s = V(s,si);
                        end
                        Vgs_fp3s = Vgs_noswapfp3s;
                        cdsc = 1.0 + nfactorfp3 ; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp3 + (Tdev/Tnom - 1.0)*ktfp3 ;
                        Cg_fp3s = epsilon/dfp3;
                        `VG0(lfp3,w,Voff_dibl_temp,iminfp3,Vgs_fp3s,Vtv,Vg0_fp3s)
                        `PSIS(Cg_fp3s,Vg0_fp3s,gamma0fp3,gamma1fp3,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp3s)
                        Vds_fp3s = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp3,ute,vsatfp3,at,Cg_fp3s,psis_fp3s,Vg0_fp3s,Vbs,ua,ub,uc,lfp3,Vds_fp3s,gamma0fp3,gamma1fp3,   mulf_tdev,Vdeff,psid_fp3s)
                        psim_fp3s = 0.5*(psis_fp3s + psid_fp3s);
                        psisd_fp3s = psid_fp3s - psis_fp3s;
                        `QGI(Vg0_fp3s,psis_fp3s,psid_fp3s,psim_fp3s,Cg_fp3s,lfp3,qm0fp3,bdosfp3,adosfp3,dfp3,Vtv,w,nf,   Cg_qme,qg_fp3s)
                        `QDI(Vg0_fp3s,psim_fp3s,psis_fp3s,psid_fp3s,psisd_fp3s,lfp3,Vtv,w,nf,Cg_qme,   qd_fp3s)
                        qs_fp3s = -1.0*qg_fp3s -1.0*qd_fp3s;
                    end else begin
                        qg_fp3s = 0;
                        V(si,fp3s) <+ 0.0;
                        qd_fp3s = 0;
                    end
                end
            `endif
////////// FP4 Current Model //////////
            `ifdef __FP4MOD__
                if (fastfpmod == 0) begin
                    if (fp4mod != 0) begin
                        Vds_noswapfp4 = V(fp4,`IntrinsicDrain_fp3);
                        if (fp4mod == 1) begin
                            Vgs_noswapfp4 = V(gi,`IntrinsicDrain_fp3);
                            Vgd_noswapfp4 = V(gi,fp4);
                        end else begin
                            Vgs_noswapfp4 = V(s,`IntrinsicDrain_fp3);
                            Vgd_noswapfp4 = V(s,fp4);
                        end
                        sigvdsfp4 = 1.0;
                        if (Vds_noswapfp4 < 0.0) begin
                            sigvdsfp4 = -1.0;
                            Vds_fp4 = sigvdsfp4*Vds_noswapfp4 ;
                            Vgs_fp4 = Vgd_noswapfp4 ;
                        end else begin
                            Vds_fp4 = Vds_noswapfp4 ;
                            Vgs_fp4 = Vgs_noswapfp4 ;
                        end

                        Vdsx_fp4 = sqrt(Vds_fp4*Vds_fp4 + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp4 + cdscdfp4*Vdsx_fp4; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp4 - (Tdev/Tnom - 1.0)*ktfp4 - (eta0fp4)*(Vdsx_fp4*vdscalefp4)/sqrt(Vdsx_fp4*Vdsx_fp4 + vdscalefp4*vdscalefp4);
                        Cg_fp4 = epsilon/(dfp4);
                        `VG0(lfp4,w,Voff_dibl_temp,iminfp4,Vgs_fp4,Vtv,Vg0_fp4)
                        `PSIS(Cg_fp4,Vg0_fp4,gamma0fp4,gamma1fp4,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp4)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp4,ute,vsatfp4,at,Cg_fp4,psis_fp4,Vg0_fp4,Vbs,ua,ub,uc,lfp4,Vds_fp4,gamma0fp4,gamma1fp4,   mulf_tdev,Vdeff,psid_fp4)
                        psim_fp4 = 0.5*(psis_fp4 + psid_fp4);
                        psisd_fp4 = psid_fp4 - psis_fp4;
                        `IDS(Vg0_fp4,psim_fp4,psisd_fp4,Cg_fp4,Cepi,lfp4,Vdsx_fp4,w,nf,Vtv,mulf_tdev,Vdeff,  Ids_fp4)
                        I(fp4,`IntrinsicDrain_fp3) <+ mult_i*sigvdsfp4*Ids_fp4 + mult_i*gdsmin_t*V(fp4,`IntrinsicDrain_fp3);
                        `QGI(Vg0_fp4,psis_fp4,psid_fp4,psim_fp4,Cg_fp4,lfp4,qm0fp4,bdosfp4,adosfp4,dfp4,Vtv,w,nf,   Cg_qme,qg_fp4)
                        `QDI(Vg0_fp4,psim_fp4,psis_fp4,psid_fp4,psisd_fp4,lfp4,Vtv,w,nf,Cg_qme,   qd_fp4)
                        qs_fp4 = -1.0*qg_fp4 -1.0*qd_fp4;
                        if (sigvdsfp4 < 0.0) begin
                            t1 = qd_fp4;
                            qd_fp4 = qs_fp4;
                            qs_fp4 = t1;
                        end
                    end else begin
                        V(fp4,`IntrinsicDrain_fp3) <+ 0.0;
                        qg_fp4 = 0;
                        qd_fp4 = 0;
                    end
                end else begin
                    V(fp4,di) <+ 0.0;
                    if (fp4mod != 0) begin
                        if (fp4mod == 1) begin
                            Vgs_noswapfp4 = V(gi,di);
                        end else begin
                            Vgs_noswapfp4 = V(s,di);
                        end
                        Vgs_fp4 = Vgs_noswapfp4;
                        cdsc = 1.0 + nfactorfp4 ; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp4 - (Tdev/Tnom - 1.0)*ktfp4 ;
                        Cg_fp4 = epsilon/(dfp4);
                        `VG0(lfp4,w,Voff_dibl_temp,iminfp4,Vgs_fp4,Vtv,Vg0_fp4)
                        `PSIS(Cg_fp4,Vg0_fp4,gamma0fp4,gamma1fp4,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp4)
                        Vds_fp4 = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp4,ute,vsatfp4,at,Cg_fp4,psis_fp4,Vg0_fp4,Vbs,ua,ub,uc,lfp4,Vds_fp4,gamma0fp4,gamma1fp4,   mulf_tdev,Vdeff,psid_fp4)
                        psim_fp4 = 0.5*(psis_fp4 + psid_fp4);
                        psisd_fp4 = psid_fp4 - psis_fp4;
                        `QGI(Vg0_fp4,psis_fp4,psid_fp4,psim_fp4,Cg_fp4,lfp4,qm0fp4,bdosfp4,adosfp4,dfp4,Vtv,w,nf,   Cg_qme,qg_fp4)
                        `QDI(Vg0_fp4,psim_fp4,psis_fp4,psid_fp4,psisd_fp4,lfp4,Vtv,w,nf,Cg_qme,   qd_fp4)
                        qs_fp4 = -1.0*qg_fp4 -1.0*qd_fp4;
                    end else begin
                        qg_fp4 = 0;
                        qd_fp4 = 0;
                    end
                end
            `endif
//////////// FP4 Source side current model //////////////////////////////////////////////
            `ifdef __FP4SMOD__
                if (fastfpmod == 0) begin
                    if (fp4smod != 0) begin
                        Vds_noswapfp4s = V(`IntrinsicSource_fp3s,fp4s);
                        if (fp4smod == 1) begin
                            Vgs_noswapfp4s = V(gi,fp4s);
                            Vgd_noswapfp4s = V(gi,`IntrinsicSource_fp3s);
                        end else begin
                            Vgs_noswapfp4s = V(s,fp4s);
                            Vgd_noswapfp4s = V(s,`IntrinsicSource_fp3s);
                        end
                        sigvdsfp4s = 1.0;
                        if (Vds_noswapfp4s < 0.0) begin
                            sigvdsfp4s = -1.0;
                            Vds_fp4s = sigvdsfp4s*Vds_noswapfp4s ;
                            Vgs_fp4s = Vgd_noswapfp4s ;
                        end else begin
                            Vds_fp4s = Vds_noswapfp4s ;
                            Vgs_fp4s = Vgs_noswapfp4s ;
                        end
                        Vdsx_fp4s = sqrt(Vds_fp4s*Vds_fp4s + 0.01) - 0.1;
                        cdsc = 1.0 + nfactorfp4 + cdscdfp4*Vdsx_fp4s; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp4 + (Tdev/Tnom - 1.0)*ktfp4 - (eta0fp4)*(Vdsx_fp4s*vdscalefp4)/sqrt(Vdsx_fp4s*Vdsx_fp4s + vdscalefp4*vdscalefp4);
                        Cg_fp4s = epsilon/dfp4;
                        `VG0(lfp4,w,Voff_dibl_temp,iminfp4,Vgs_fp4s,Vtv,Vg0_fp4s)
                        `PSIS(Cg_fp4s,Vg0_fp4s,gamma0fp4,gamma1fp4,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp4s)
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp4,ute,vsatfp4,at,Cg_fp4s,psis_fp4s,Vg0_fp4s,Vbs,ua,ub,uc,lfp4,Vds_fp4s,gamma0fp4,gamma1fp4,   mulf_tdev,Vdeff,psid_fp4s)
                        psim_fp4s = 0.5*(psis_fp4s + psid_fp4s);
                        psisd_fp4s = psid_fp4s - psis_fp4s;
                        `IDS(Vg0_fp4s,psim_fp4s,psisd_fp4s,Cg_fp4s,Cepi,lfp4,Vdsx_fp4s,w,nf,Vtv,mulf_tdev,Vdeff,   Ids_fp4s)
                        I(`IntrinsicSource_fp3s,fp4s) <+ mult_i*sigvdsfp4s*Ids_fp4s + mult_i*gdsmin_t*V(`IntrinsicSource_fp3s,fp4s);
                        `QGI(Vg0_fp4s,psis_fp4s,psid_fp4s,psim_fp4s,Cg_fp4s,lfp4,qm0fp4,bdosfp4,adosfp4,dfp4,Vtv,w,nf,   Cg_qme,qg_fp4s)
                        `QDI(Vg0_fp4s,psim_fp4s,psis_fp4s,psid_fp4s,psisd_fp4s,lfp4,Vtv,w,nf,Cg_qme,   qd_fp4s)
                        qs_fp4s = -1.0*qg_fp4s -1.0*qd_fp4s;
                        if (sigvdsfp4s < 0.0) begin
                            t1 = qd_fp4s;
                            qd_fp4s = qs_fp4s;
                            qs_fp4s = t1;
                        end
                    end else begin
                        V(`IntrinsicSource_fp3s,fp4s) <+ 0.0;
                        qg_fp4s = 0;
                        qd_fp4s = 0;
                    end
                end else begin
                    V(si,fp4s) <+ 0.0;
                    if (fp4smod != 0) begin
                        if (fp4smod == 1) begin
                            Vgs_noswapfp4s = V(gi,si);
                        end else begin
                            Vgs_noswapfp4s = V(s,si);
                        end
                        Vgs_fp4s = Vgs_noswapfp4s;
                        cdsc = 1.0 + nfactorfp4; //Sub-threshold Slope
                        Vtv = `KboQ*Tdev*cdsc;
                        Voff_dibl_temp = vofffp4 + (Tdev/Tnom - 1.0)*ktfp4 ;
                        Cg_fp4s = epsilon/dfp4;
                        `VG0(lfp4,w,Voff_dibl_temp,iminfp4,Vgs_fp4s,Vtv,Vg0_fp4s)
                        `PSIS(Cg_fp4s,Vg0_fp4s,gamma0fp4,gamma1fp4,Vtv,   beta,ALPHAN,ALPHAD,Cch,psis_fp4s)
                        Vds_fp4s = 0.0;
                        `PSID(Tdev,Tnom,epsilon,delta,beta,ALPHAN,ALPHAD,Vtv,Cch,Cepi,u0fp4,ute,vsatfp4,at,Cg_fp4s,psis_fp4s,Vg0_fp4s,Vbs,ua,ub,uc,lfp4,Vds_fp4s,gamma0fp4,gamma1fp4,   mulf_tdev,Vdeff,psid_fp4s)
                        psim_fp4s = 0.5*(psis_fp4s + psid_fp4s);
                        psisd_fp4s = psid_fp4s - psis_fp4s;
                        `QGI(Vg0_fp4s,psis_fp4s,psid_fp4s,psim_fp4s,Cg_fp4s,lfp4,qm0fp4,bdosfp4,adosfp4,dfp4,Vtv,w,nf,   Cg_qme,qg_fp4s)
                        `QDI(Vg0_fp4s,psim_fp4s,psis_fp4s,psid_fp4s,psisd_fp4s,lfp4,Vtv,w,nf,Cg_qme,   qd_fp4s)
                        qs_fp4s = -1.0*qg_fp4s -1.0*qd_fp4s;
                    end else begin
                        qg_fp4s = 0;
                        qd_fp4s = 0;
                        V(si,fp4s) <+ 0.0;
                    end
                end
            `endif
////////// Gate Resistance //////////
            if (rgatemod == 1) begin
                Grgeltd = rshg * (xgw + w / 3.0 / ngcon)/ ( ngcon * nf * (l));
                if (Grgeltd > 0.0) begin
                    Grgeltd = 1.0 / Grgeltd;
                end else begin
                    Grgeltd = 1.0/$simparam("minr",1.0e-3);
                end
                I(g,gi) <+ mult_i*Grgeltd * V(g,gi);
                V(gin,gi) <+ 0.0;
            end else if (rgatemod == 2) begin
                Grgeltd1 = rshg * (xgw + w / 3.0 / ngcon)/ ( ngcon * nf * (l));
                Grgeltd2 = rshg * (2.0 * w / 3.0 / ngcon)/ ( ngcon * nf * (l));
                if (Grgeltd1 > 0.0) begin
                    Grgeltd1 = 1.0 / Grgeltd1;
                end else begin
                    Grgeltd1 = 1.0/$simparam("minr",1.0e-3);
                end
                I(g,gin) <+ mult_i*Grgeltd1 * V(g,gin);
                if (Grgeltd2 > 0.0) begin
                    Grgeltd2 = 1.0 / Grgeltd2;
                end else begin
                    Grgeltd2 = 1.0/$simparam("minr",1.0e-3);
                end
                I(gin,gi) <+ mult_i*Grgeltd2 * V(gin,gi);
            end else begin
                V(g, gin) <+ 0.0;
                V(gin, gi) <+ 0.0;
            end
////////// Parasitic Charges //////////
            if (rgatemod == 2) begin
                qsov = w*nf*cgso*V(gin,s);
                VdseffCV = V(d,s)*vdsatcv/sqrt(V(d,s)*V(d,s) + vdsatcv*vdsatcv);
                cgdl_l = min(cgdl,cgdo/(2*vdsatcv));
                cgdvar  = w*nf*cgdo - w*nf*cgdl_l*VdseffCV;
                qdov = max(cgdvar,0.0)*V(gin,d);
            end else begin
                qsov = w*nf*cgso*V(g,s);
                VdseffCV = V(d,s)*vdsatcv/sqrt(V(d,s)*V(d,s) + vdsatcv*vdsatcv);
                cgdl_l = min(cgdl,cgdo/(2*vdsatcv));
                cgdvar  = w*nf*cgdo - w*nf*cgdl_l*VdseffCV;
                qdov = max(cgdvar,0.0)*V(g,d);
            end
            qdsov = w*nf*cdso*V(d,s);
            qdp = - qdov + qdsov;
            qsp = - qsov - qdsov;
            qd = qdint + qdp;
            qs = qsint + qsp;
            qbdov = w*nf*cbdo*V(b,d);
            qbsov = w*nf*cbso*V(b,s);
            qbgov = w*nf*cbgo*V(b,g);
/////////// Substrate current /////////////

            vbisb_t = vbisb + (Tdev/Tnom-1)*ktvbisb;
            nsb_t = nsb + (Tdev/Tnom-1)*ktnsb;
            isb_t = isbl*exp(ktisb*(Tdev/Tnom-1));
            vbidb_t = vbidb + (Tdev/Tnom-1)*ktvbidb;
            ndb_t = ndb + (Tdev/Tnom-1)*ktndb;
            idb_t = idbl*exp(ktidb*(Tdev/Tnom-1));
            t3 = w*nf*idb_t;
            Vbdl = max((V(d,b)-vbidb_t),0.0);
            `IDIO(t3,ndb_t,1.0,Vbdl,  Idb)
            Vbsl = max((V(s,b)-vbisb_t),0.0);
            t3 = w*nf*isb_t;
            `IDIO(t3,nsb_t,1.0,Vbsl,  Isb)
            I(d,b) <+ mult_i * Idb;
            I(s,b) <+ mult_i * Isb;
////////// Flicker Noise Model //////////
            if (fnmod==1) begin
                Kr  =  l/((Vg0-psim+Vtv)*max(psisd,1.0e-12));
                Pf  =  Vtv*`P_Q*`P_Q*`P_Q/(w*nf*l*l);
                FNint1  = noia*Vtv*Cg*(1.0/(max(qd,1.0e-22)))*(1.0-(qd/(max(qs,1.0e-22))));
                FNint2  = (noia+noib*Vtv*Cg)*ln(max(qd,1.0e-22)/max(qs,1.0e-22));
                FNint3  = (noib+noic*Vtv*Cg)*(qs-qd);
                FNint4  = (noic/2.0)*(qd*qd-qs*qs);
                FNat1Hz = Pf*(Ids*Ids)*(Kr/(Cg*Cg))*(FNint1+FNint2+FNint3+FNint4); //PSD of the flicker noise without the frequency component
                if (sigvds < 0) begin
                    FNat1Hz = -FNat1Hz;
                end
                I(di,si) <+ flicker_noise(FNat1Hz * mult_fn, ef, "flicker");
            end
////////// Capacitance Contributions //////////
            I(di,si) <+ mult_q*ddt(qdint);
            I(gi,si) <+ mult_q*ddt(qgint);
            if (rgatemod == 2) begin
                I(gin,s) <+ mult_q*ddt(qsov);
                I(gin,d) <+ mult_q*ddt(qdov);
            end else begin
                I(g,s) <+ mult_q*ddt(qsov);
                I(g,d) <+ mult_q*ddt(qdov);
            end
            I(d,s) <+ mult_q*ddt(qdsov);
            I(b,d) <+ mult_q*ddt (qbdov);
            I(b,s) <+ mult_q*ddt (qbsov);
            I(b,g) <+ mult_q*ddt (qbgov);
            I(b,si) <+ mult_q*ddt(csubscalei*qgint);
            `ifdef __FP1MOD__
                if (fastfpmod == 0) begin
                    if (fp1mod!=0) begin
                        I(fp1,di) <+ mult_q*ddt(qd_fp1);
                        if (fp1mod == 1) begin
                            I(gi, di) <+ mult_q*ddt(qg_fp1) ;
                            I(s,di) <+ mult_q*ddt(qg_fp1)*cfp1scale ;
                        end else begin
                            I(s,di) <+ mult_q*ddt(qg_fp1) ;
                            I(gi, di) <+ mult_q*ddt(qg_fp1)*cfp1scale ;
                        end
                        I(b,di) <+ mult_q*ddt(csubscale1*qg_fp1);
                    end
                end else begin
                    if (fp1mod!=0) begin
                        I(d,di) <+ mult_q*ddt(qd_fp1);
                        if (fp1mod == 1) begin
                            I(gi, di) <+ mult_q*ddt(qg_fp1) ;
                            I(s,di) <+ mult_q*ddt(qg_fp1)*cfp1scale ;
                        end else begin
                            I(s,di) <+ mult_q*ddt(qg_fp1) ;
                            I(gi, di) <+ mult_q*ddt(qg_fp1)*cfp1scale ;
                        end
                        I(b,di) <+ mult_q*ddt(csubscale1*qg_fp1);
                    end
                end
            `endif
            `ifdef __FP1SMOD__
                if (fastfpmod == 0) begin
                    if (fp1smod!=0) begin
                        I(si,fp1s) <+ mult_q*ddt(qd_fp1s);
                        if (fp1smod == 1) begin
                            I(gi, fp1s) <+ mult_q*ddt(qg_fp1s) ;
                            I(s,fp1s) <+ mult_q*ddt(qg_fp1s)*cfp1scale ;
                        end else begin
                            I(s,fp1s) <+ mult_q*ddt(qg_fp1s) ;
                            I(gi,fp1s) <+ mult_q*ddt(qg_fp1s)*cfp1scale ;
                        end
                        I(b,fp1s) <+ mult_q*ddt(csubscale1*qg_fp1s);
                    end
                end else begin
                    if (fp1smod!=0) begin
                        I(si,s) <+ mult_q*ddt(qd_fp1s);
                        if (fp1smod == 1) begin
                            I(gi, si) <+ mult_q*ddt(qg_fp1s) ;
                            I(s,si) <+ mult_q*ddt(qg_fp1s)*cfp1scale ;
                        end else begin
                            I(s,si) <+ mult_q*ddt(qg_fp1s) ;
                            I(gi,si) <+ mult_q*ddt(qg_fp1s)*cfp1scale ;
                        end
                        I(b,si) <+ mult_q*ddt(csubscale1*qg_fp1s);
                    end
                end
            `endif
            `ifdef __FP2MOD__
                if (fastfpmod == 0) begin
                    if (fp2mod!=0) begin
                        I(fp2, `IntrinsicDrain_fp1) <+ mult_q*ddt(qd_fp2);
                        if (fp2mod == 1) begin
                            I(gi,`IntrinsicDrain_fp1)<+ mult_q*ddt(qg_fp2);
                            I(s,`IntrinsicDrain_fp1)<+ mult_q*cfp2scale*ddt(qg_fp2) ;
                        end else begin
                            I(s,`IntrinsicDrain_fp1)<+ mult_q*ddt(qg_fp2);
                            I(gi,`IntrinsicDrain_fp1) <+  mult_q*cfp2scale*ddt(qg_fp2) ;
                        end
                        I(b,fp1) <+ mult_q*ddt(csubscale2*qg_fp2);
                    end
                end else begin
                    if (fp2mod!=0) begin
                        I(d, di) <+ mult_q*ddt(qd_fp2);
                        if (fp2mod == 1) begin
                            I(gi,di)<+ mult_q*ddt(qg_fp2);
                            I(s,di)<+ mult_q*cfp2scale*ddt(qg_fp2) ;
                        end else begin
                            I(s,di)<+ mult_q*ddt(qg_fp2);
                            I(gi,di) <+  mult_q*cfp2scale*ddt(qg_fp2) ;
                        end
                        I(b,di) <+ mult_q*ddt(csubscale2*qg_fp2);
                    end
                end
            `endif
            `ifdef __FP2SMOD__
                if (fastfpmod == 0) begin
                    if (fp2smod!=0) begin
                        I(si,fp2s) <+ mult_q*ddt(qd_fp2s);
                        if (fp2smod == 1) begin
                            I(gi, fp2s) <+ mult_q*ddt(qg_fp2s) ;
                            I(s,fp2s) <+ mult_q*ddt(qg_fp2s)*cfp2scale ;
                        end else begin
                            I(s,fp2s) <+ mult_q*ddt(qg_fp2s) ;
                            I(gi,fp2s) <+ mult_q*ddt(qg_fp2s)*cfp2scale ;
                        end
                        I(b,fp2s) <+ mult_q*ddt(csubscale2*qg_fp2s);
                    end
                end else begin
                    if (fp2smod!=0) begin
                        I(si,s) <+ mult_q*ddt(qd_fp2s);
                        if (fp2smod == 1) begin
                            I(gi, si) <+ mult_q*ddt(qg_fp2s) ;
                            I(s,si) <+ mult_q*ddt(qg_fp2s)*cfp2scale ;
                        end else begin
                            I(s,si) <+ mult_q*ddt(qg_fp2s) ;
                            I(gi,si) <+ mult_q*ddt(qg_fp2s)*cfp2scale ;
                        end
                        I(b,si) <+ mult_q*ddt(csubscale2*qg_fp2s);
                    end
                end
            `endif
            `ifdef __FP3MOD__
                if (fastfpmod == 0) begin
                    if (fp3mod!=0) begin
                        I(fp3, `IntrinsicDrain_fp2) <+ mult_q*ddt(qd_fp3);
                        if (fp3mod == 1) begin
                            I(gi,`IntrinsicDrain_fp2)<+ mult_q*ddt(qg_fp3);
                            I(s,`IntrinsicDrain_fp2)<+ mult_q*ddt(qg_fp3)*cfp3scale;
                        end else begin
                            I(s,`IntrinsicDrain_fp2)<+ mult_q*ddt(qg_fp3);
                            I(gi,`IntrinsicDrain_fp2)<+ mult_q*ddt(qg_fp3)*cfp3scale;
                        end
                        I(b,fp2) <+ mult_q*ddt(csubscale3*qg_fp3);
                    end
                end else begin
                    if (fp3mod!=0) begin
                        I(d, di) <+ mult_q*ddt(qd_fp3);
                        if (fp3mod == 1) begin
                            I(gi,di)<+ mult_q*ddt(qg_fp3);
                            I(s,di)<+ mult_q*ddt(qg_fp3)*cfp3scale;
                        end else begin
                            I(s,di)<+ mult_q*ddt(qg_fp3);
                            I(gi,di)<+ mult_q*ddt(qg_fp3)*cfp3scale;
                        end
                        I(b,di) <+ mult_q*ddt(csubscale3*qg_fp3);
                    end
                end
            `endif
            `ifdef __FP3SMOD__
                if (fastfpmod == 0) begin
                    if (fp3smod!=0) begin
                        I(si,fp3s) <+ mult_q*ddt(qd_fp3s);
                        if (fp3smod == 1) begin
                            I(gi, fp3s) <+ mult_q*ddt(qg_fp3s) ;
                            I(s,fp3s) <+ mult_q*ddt(qg_fp3s)*cfp3scale ;
                        end else begin
                            I(s,fp3s) <+ mult_q*ddt(qg_fp3s) ;
                            I(gi,fp3s) <+ mult_q*ddt(qg_fp3s)*cfp3scale ;
                        end
                        I(b,fp3s) <+ mult_q*ddt(csubscale3*qg_fp3s);
                    end
                end else begin
                    if (fp3smod!=0) begin
                        I(si,s) <+ mult_q*ddt(qd_fp3s);
                        if (fp3smod == 1) begin
                            I(gi, s) <+ mult_q*ddt(qg_fp3s) ;
                            I(s,si) <+ mult_q*ddt(qg_fp3s)*cfp3scale ;
                        end else begin
                            I(s,si) <+ mult_q*ddt(qg_fp3s) ;
                            I(gi,si) <+ mult_q*ddt(qg_fp3s)*cfp3scale ;
                        end
                        I(b,si) <+ mult_q*ddt(csubscale3*qg_fp3s);
                    end
                end
            `endif
            `ifdef __FP4MOD__
                if (fastfpmod == 0) begin
                    if (fp4mod!=0) begin
                        I(fp4, `IntrinsicDrain_fp3) <+ mult_q*ddt(qd_fp4);
                        if (fp4mod == 1) begin
                            I(gi,`IntrinsicDrain_fp3)<+ mult_q*ddt(qg_fp4);
                            I(s,`IntrinsicDrain_fp3)<+ mult_q*ddt(qg_fp4)*cfp4scale;
                        end else begin
                            I(s,`IntrinsicDrain_fp3)<+ mult_q*ddt(qg_fp4);
                            I(gi,`IntrinsicDrain_fp3)<+ mult_q*ddt(qg_fp4)*cfp4scale;
                        end
                        I(b,fp3) <+ mult_q*ddt(csubscale4*qg_fp4);
                    end
                end else begin
                    if (fp4mod!=0) begin
                        I(d, di) <+ mult_q*ddt(qd_fp4);
                        if (fp4mod == 1) begin
                            I(gi,di)<+ mult_q*ddt(qg_fp4);
                            I(s,di)<+ mult_q*ddt(qg_fp4)*cfp4scale;
                        end else begin
                            I(s,di)<+ mult_q*ddt(qg_fp4);
                            I(gi,di)<+ mult_q*ddt(qg_fp4)*cfp4scale;
                        end
                        I(b,di) <+ mult_q*ddt(csubscale4*qg_fp4);
                    end
                end
            `endif
            `ifdef __FP4SMOD__
                if (fastfpmod == 0) begin
                    if (fp4smod!=0) begin
                        I(si,fp4s) <+ mult_q*ddt(qd_fp4s);
                        if (fp4smod == 1) begin
                            I(gi, fp4s) <+ mult_q*ddt(qg_fp4s) ;
                            I(s,fp4s) <+ mult_q*ddt(qg_fp4s)*cfp4scale ;
                        end else begin
                            I(s,fp4s) <+ mult_q*ddt(qg_fp4s) ;
                            I(gi,fp4s) <+ mult_q*ddt(qg_fp4s)*cfp4scale ;
                        end
                        I(b,fp4s) <+ mult_q*ddt(csubscale4*qg_fp4s);
                    end
                end else begin
                    if (fp4smod!=0) begin
                        I(si,s) <+ mult_q*ddt(qd_fp4s);
                        if (fp4smod == 1) begin
                            I(gi, s) <+ mult_q*ddt(qg_fp4s) ;
                            I(s,si) <+ mult_q*ddt(qg_fp4s)*cfp4scale ;
                        end else begin
                            I(s,si) <+ mult_q*ddt(qg_fp4s) ;
                            I(gi,si) <+ mult_q*ddt(qg_fp4s)*cfp4scale ;
                        end
                        I(b,si) <+ mult_q*ddt(csubscale4*qg_fp4s);
                    end
                end
            `endif
////////// Fringe Capacitance For Additional Tuning //////////
            qfr = cfgd0 - (cfgd + (Tdev/Tnom - 1.0)* ktcfgd) * V(d,s);
            qfr = w*nf*hypmax(qfr,1.0e-25,cfgdsm);
            I(g,d) <+ mult_q*ddt(qfr);
            I(g,s) <+ mult_q*ddt(w*nf*cfgd*V(g,s));
            t0 = smoothminx(cfg-((Tdev/Tnom - 1.0)*ktcfg), 1.0e-18, 0.1e-18);
            qfr2 = w*nf*t0*V(gi, s);
            I(gi, s) <+ mult_q*ddt(qfr2);
            qfr3 = w*nf*cfd*V(s,d);
            I(s,d) <+ mult_q*ddt(qfr3);

////////// Depletion Capacitance Model //////////
            t0 = (vbi - (Tdev/Tnom - 1.0)*ktvbi)*(1.0-lexp(-ln(aj)/mz));
            t1 = (t0-V(s,d))/Vth;
            t2 = sqrt(dj*t1*t1+ 1.92);
            t3 = (t1+t2)*0.5;
            t4 = t0-Vth*t3;
            t6 = ln(1.0-t4/vbi);
            t8 = cj0*(vbi - (Tdev/Tnom - 1.0)*ktvbi)*(1.0-lexp(t6*(1.0-mz)))/(1.0-mz);
            Qdep = w*nf*(t8+aj*cj0*(V(s,d)-t4));
            I(s,d) <+ mult_q*ddt(Qdep);  //

////////// Self-Heating Effect //////////
            if (shmod == 1 && rth0>0) begin
                Pwr(ith) <+ -1.0*Ids*Vds-1.0*Ids_fp1*Vds_fp1-1.0*Ids_fp2*Vds_fp2-1.0*Ids_fp3*Vds_fp3-1.0*Ids_fp4*Vds_fp4;
                Pwr(rth) <+ Temp(rth)/rth0;
                Pwr(rth) <+ ddt(Temp(rth)*cth0);
            end else begin
                Temp(dt) <+ 0.0 ;
            end
/////////  Output info variables
            idisi = mult_i*I(di,si);
            vdisi = V(di,si);
            vgisi = V(gi,si);
            gmi   = mult_i*sigvds * ddx(Ids,V(gi));
            gmbi  = mult_i*0.0; // sigvds * ddx(Ids,V(b)) if Vb dependence is added;
            if (sigvds > 0) begin
                gdsi  = mult_i*ddx(Ids,V(di));
            end else begin
                gdsi  = mult_i*ddx(Ids,V(si));
            end
            igs   = mult_i*Igs;
            igd   = mult_i*Igd;
            qgi   = mult_q*qgint;
            qdi   = mult_q*qdint;
            qsi   = mult_q*qsint;
            qbi   = mult_q*csubscalei*qgint;
            cggi  = mult_q*ddx(qgi,V(gi));
            cgsi  = mult_q*-ddx(qgi,V(si));
            cgdi  = mult_q*-ddx(qgi,V(di));
            cgbi  = mult_q*0.0; // -ddx(qgi,V(b)) if Vb dependence is added;
            cddi  = mult_q*ddx(qdi,V(di));
            cdgi  = mult_q*-ddx(qdi,V(gi));
            cdsi  = mult_q*-ddx(qdi,V(si));
            cdbi  = mult_q*0.0; //-ddx(qdi,V(b)) if Vb dependence is added;
            cssi  = mult_q*ddx(qsi,V(si));
            csgi  = mult_q*-ddx(qsi,V(gi));
            csdi  = mult_q*-ddx(qsi,V(di));
            csbi  = mult_q*0.0; // -ddx(qsi,V(b)) if Vb dependence is added;
            cbbi  = mult_q*0.0; // ddx(qbi,V(b)) if Vb dependence is added;
            cbgi  = mult_q*-ddx(qbi,V(gi));
            cbdi  = mult_q*-ddx(qbi,V(di));
            cbsi  = mult_q*-ddx(qbi,V(si));
            t_total_k  = Tdev;
            t_total_c  = Tdev - `P_CELSIUS0;
            t_delta_sh = Temp(dt);
            rd         = Rdrain;
            rs         = Rsource;
            cgs        = mult_q*cgsi + mult_q*(-ddx(qsov,V(s)));
            cgd        = mult_q*cgdi + mult_q*(-ddx(qdov,V(d)));
        end
    end
endmodule
