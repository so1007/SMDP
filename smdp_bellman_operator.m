function [V, policy] = smdp_bellman_operator(P, PR, Beta, Vprev)


% mdp_bellman_operator Applies the Bellman operator on the value function Vprev
%                      Returns a new value function and a Vprev-improving policy
% Arguments ---------------------------------------------------------------
% Let S = number of states, A = number of actions
%   P(SxSxA) = transition matrix
%              P could be an array with 3 dimensions or 
%              a cell array (1xA), each cell containing a matrix (SxS) possibly sparse
%   PR(SxA) = reward matrix
%              PR could be an array with 2 dimensions or 
%              a sparse matrix
%   Beta(SxSxA) = similar to discount rate
%   Vprev(S) = value function
% Evaluation --------------------------------------------------------------
%   V(S)   = new value function
%   policy(S) = Vprev-improving policy


if iscell(P); S = size(P{1},1); else S = size(P,1); end;
if size(Vprev,1) ~= S
    disp('--------------------------------------------------------')
    disp('ERROR: Vprev must have the same dimension as P')
    disp('--------------------------------------------------------')
else  
    A = size(P,3);
    for a=1:A
        Q(:,a) = PR(:,a) + Beta(:,:,a).*P(:,:,a)*Vprev;
    end
    
    [V, policy] = max(Q,[],2);
 
end; 

