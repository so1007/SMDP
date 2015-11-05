function [beta]=smdp_eval_beta(ind_s1,ind_s2,ind_a)


global sizeS
global sizeA
[u1,l1,m1,e1]=ind2sub(sizeS,ind_s1);
[u2,l2,m2,e2]=ind2sub(sizeS,ind_s2);
[a_display,a_gps]=ind2sub(sizeA,ind_a);

global discount
global lambda_u
global lambda_l
global lambda_m
global lambda_e

lambda=lambda_u+lambda_l+lambda_m+lambda_e(a_display,a_gps);
beta=lambda/(lambda+discount);
discount/lambda;

end