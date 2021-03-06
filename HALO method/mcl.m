function m = mcl(m)
% test the explanations in stijn van dongens thesis.
%
% @author gregor :: arbylon . net

if nargin < 1
    % m contains T(G3 + I  ) as stochastic matrix
    load -ascii m.txt
end            


p=1;%(it seems for outlier) default:p=2; The parameter of inflation
minval = 0.0055;%more likely id for outlier than normal default: minval=0.001 parameter of prune

e=2;%(not so muc has a big impact) default:e=1
emax =0.3;%(for normal data) default:emax=0.001
while e > emax

    fprintf('iteration %i before expansion:\n', i);
    m;

    fprintf('iteration %i after expansion/before inflation:\n', i);
    m2 = expand(m);

    fprintf('inflation:\n')
    [m, e] = inflate(m2, p, minval);

    fprintf('residual energy: %f\n', e);

end % while e

end % mcl

% expand by multiplying m * m
% this preserves column (or row) normalisation
function m2 = expand(m)
    m2 = m * m;
end

% inflate by Hadamard potentiation
% and column re-normalisation
% prune elements of m that are below minval
function [m2, energy] = inflate(m, p, minval)
    % inflation
    m2 = m .^ p;
    % pruning
    m2(find(m2 < minval)) = 0;
    % normalisation
    dinv = diag(1./sum(m2));
    m2 = m2 * dinv;
    % calculate residual energy
    maxs = max(m2);
    sqsums = sum(m2 .^ 2);
    energy = max(maxs - sqsums);
end
