function [p,beta,R]=smdp_smartphone_init()

%% Initialize constant params
% initialize size of State, Action
s1=2;s2=3;s3=3;s4=10;
global sizeS
sizeS=[s1 s2 s3 s4];

a1=3;a2=5;
global sizeA
sizeA=[a1 a2];

% initialize power consumption
global power_base
global power_display
global power_gps
power_base=300;
power_display=[246 466 686];
power_gps=[370 144 72 24 12];

% initialize discount, param lambdas
global discount
global lambda_u
global lambda_l
global lambda_m
global lambda_e
discount=0.01;
lambda_u=1/60;
lambda_l=1/300;
lambda_m=1/300;
lambda_e=zeros(3,5);
for i=1:3
    for j=1:5
        lambda_e(i,j)=power_base+power_display(i)+power_gps(j);
    end
end
lambda_e=lambda_e/2872800;

% initialize experience table u_display and u_gps
global u_display
global u_gps
global r_outage
% u_display=[1 3 5];
u_display=zeros(2,3,3);
u_display(1,:,:)=[5,0,0; 5,0,0; 5,0,0];
u_display(2,:,:)=[5 5 5; 1 5 5; 1 3 5];
u_gps=[5 5 5;
    5 5 3;
    5 5 1;
    5 3 -100;
    5 1 -100];
r_outage=-50;



%% calculate p(j|i,a),beta(i,a,j),R(i,a)
% initialize p(j|i,a), size is S*S*A
tic;
disp('Starting calculating p(j|i,a)...');
p=zeros(prod(sizeS),prod(sizeS),prod(sizeA));
for i=1:prod(sizeS)
    for j=1:prod(sizeS)
        for k=1:prod(sizeA)
            p(i,j,k)=smdp_eval_p(i,j,k);
        end
    end
end
disp('Complete calculating p(j|i,a).');
toc;

% initialize beta(i,a,j), size is S*S*A
tic;
disp('Starting calculating Beta(i,a,j)...');
beta=zeros(prod(sizeS),prod(sizeS),prod(sizeA));
for i=1:prod(sizeS)
    for j=1:prod(sizeS)
        for k=1:prod(sizeA)
            beta(i,j,k)=smdp_eval_beta(i,j,k);
        end
    end
end
disp('Complete calculating Beta(i,a,j).');
toc;

% intialize Reward R, which is a S-by-A matrix
tic;
disp('Starting calculating R(i,a)...');
R=zeros(prod(sizeS),prod(sizeA));
for i=1:prod(sizeS)
    for j=1:prod(sizeA)
        R(i,j)=smdp_eval_reward(i,j,p);
    end
end
disp('Complete calculating R(i,a).');
toc;


end