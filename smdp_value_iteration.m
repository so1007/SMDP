function [policy, iter] = smdp_value_iteration(P,beta,R ,epsilon, max_iter, V0)

% mdp_value_iteration   Resolution of discounted MDP with value iteration algorithm 
% Arguments --------------------------------------------------------------
% Let S = number of states, A = number of actions
%   P(SxSxA)  = transition matrix 
%              P could be an array with 3 dimensions or 
%              a cell array (1xA), each cell containing a matrix (SxS) possibly sparse
%   R(SxSxA) or (SxA) = reward matrix
%              R could be an array with 3 dimensions (SxSxA) or 
%              a cell array (1xA), each cell containing a sparse matrix (SxS) or
%              a 2D array(SxA) possibly sparse  
%   discount  = discount rate in ]0; 1]
%               beware to check conditions of convergence for discount = 1.
%   epsilon   = epsilon-optimal policy search, upper than 0,
%               optional (default : 0.01)
%   max_iter  = maximum number of iteration to be done, upper than 0, 
%               optional (default : computed)
%   V0(S)     = starting value function, optional (default : zeros(S,1))
% Evaluation -------------------------------------------------------------
%   policy(S) = epsilon-optimal policy
%   iter      = number of done iterations
%   cpu_time  = used CPU time
%--------------------------------------------------------------------------
% In verbose mode, at each iteration, displays the variation of V
% and the condition which stopped iterations: epsilon-optimum policy found
% or maximum number of iterations reached.

% MDPtoolbox: Markov Decision Processes Toolbox
% Copyright (C) 2009  INRA
% Redistribution and use in source and binary forms, with or without modification, 
% are permitted provided that the following conditions are met:
%    * Redistributions of source code must retain the above copyright notice, 
%      this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright notice, 
%      this list of conditions and the following disclaimer in the documentation 
%      and/or other materials provided with the distribution.
%    * Neither the name of the <ORGANIZATION> nor the names of its contributors 
%      may be used to endorse or promote products derived from this software 
%      without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
% IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
% BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
% OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
% OF THE POSSIBILITY OF SUCH DAMAGE.

global sizeS
global mdp_VERBOSE

S=prod(sizeS);
% check of arguments
if nargin > 3 && (epsilon <= 0)
    disp('--------------------------------------------------------')
    disp('ERROR: epsilon must be upper than 0')
    disp('--------------------------------------------------------')
elseif nargin > 4 && max_iter <= 0
    disp('--------------------------------------------------------')
    disp('ERROR: The maximum number of iteration must be upper than 0')
    disp('--------------------------------------------------------')
elseif nargin > 5 && size(V0,1) ~= S
    disp('--------------------------------------------------------')
    disp('ERROR: V0 must have the same dimension as S')
    disp('--------------------------------------------------------')
else
    
    PR = mdp_computePR(P,R);
    
    % initialization of optional arguments
    if nargin < 6; V0 = zeros(S,1); end;
    if nargin < 4; epsilon = 0.01; end;
    % compute a bound for the number of iterations
    discount=mean(beta(:));
    computed_max_iter = mdp_value_iteration_bound_iter(P, R, discount, epsilon, V0);
    max_iter = computed_max_iter;
    
    
    % computation of threshold of variation for V for an epsilon-optimal policy
    if discount ~= 1
        thresh = epsilon * (1-discount)/discount;
    else 
        thresh = epsilon;
    end;
    
    
    if mdp_VERBOSE disp('  Iteration    V_variation'); end;
    
    iter = 0;
    V = V0;
    is_done = false;
    while ~is_done
        iter = iter + 1;
        Vprev = V;
        
        [V, policy] = smdp_bellman_operator(P,PR,beta,V);
        
        variation = mdp_span(V - Vprev);
        if mdp_VERBOSE; 
            disp(['      ' num2str(iter,'%5i') '         ' num2str(variation)]); 
        end;
        if variation < thresh 
            is_done = true; 
            if mdp_VERBOSE 
                disp('MDP Toolbox: iterations stopped, epsilon-optimal policy found')
            end;
        elseif iter == max_iter
            is_done = true; 
            if mdp_VERBOSE 
                disp('MDP Toolbox: iterations stopped by maximum number of iteration condition')
            end;
        end;
    end;
    
end;