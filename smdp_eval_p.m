function [prob]=smdp_eval_p(ind_s1,ind_s2,ind_a)
Pu=0.5; Pl=0.1; Pm=0.1; Pe=0.02;

global sizeS
global sizeA
[u1,l1,m1,e1]=ind2sub(sizeS,ind_s1);
[u2,l2,m2,e2]=ind2sub(sizeS,ind_s2);
[a_display,a_gps]=ind2sub(sizeA,ind_a);

prob=1;

global power_display
global power_gps
prob_display=power_display(a_display)/60000;
prob_gps=power_gps(a_gps)/40000;
if e1==e2 
    prob_e=1-Pe-prob_display-prob_gps;
elseif e1==e2+1 prob_e=Pe+prob_display+prob_gps;
else prob=0; return;
end

if u1==u2 
    prob_u=1-Pu;
else prob_u=Pu;
end

if l1==l2 
    prob_l=1-2*Pl;
else prob_l=Pl;
end

if m1==m2 
    prob_m=1-2*Pm;
else prob_m=Pm;
end


prob=prob_e*prob_u*prob_l*prob_m;

end