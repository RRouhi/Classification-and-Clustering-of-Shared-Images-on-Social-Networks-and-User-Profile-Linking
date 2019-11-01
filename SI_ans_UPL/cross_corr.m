function NCC = cross_corr(X, Y, isNormalized, isMeaned) %#codegen
%CROSS_CORR calculates the normalized cross correlation (NCC) between column vectors pairwisely
%
% [ Syntax ]
%   - NCC = cross_corr(X);
%   - NCC = cross_corr(X, Y);
%   - NCC = cross_corr(X, Y, true);
%   - NCC = cross_corr(X, Y, true, true);
%
% [ Arguments ]
%   - X, Y:                the sample matrices. If Y is not specified, this function will calculate the 
%                          self-correlations of X.
%   - isNormalized:        indicates if each column has been normalized to
%                          zero mean and unit variance.
%   - isMeaned:            indicates if the mean of each column is zero.
%
% [ Description ]
%    - NCC = cross_corr(X, Y, isNormalized, isMeaned) Computes the NCC between
%      column vectors of X and Y pairwisely
%
%      Both X and Y are matrices with each column representing a 
%      sample. X and Y should have the same number of rows. Suppose
%      the size of X is d x nx, and the size of Y is d x ny. Then 
%      the output matrix ncc will be of size nx x ny, in which
%      NCC(i, j) is the NCC value between X(:,i) and Y(:,j). The other two
%      parameters isNormalized and isMeaned indicate if each column has
%      been normalized or zero-meaned, which can be used for speed up the
%      calculation
%
% [ Examples ]
%
%     % prepare sample matrix
%     X = randn(1000, 100, 'single');
%     Y = randn(1000, 150, 'single');
%
%     % compute the NCC between the samples in X and Y
%     NCC = slmetric_pw(X, Y);
%
% [ Vesions ]
%
%     Version 1.00: 23 July, 2018
%
% [ Author ]
%
%     Xufeng Lin, xlin@csu.edu.au


if nargin == 3
    isMeaned = false;
elseif nargin == 2
    isNormalized = false;
    isMeaned = false;
elseif nargin == 1
    X = bsxfun(@minus,X,mean(X));
    R = (X' * X) / size(X,1);
    D = sqrt(diag(R));
    R = bsxfun(@rdivide,R,D); NCC = bsxfun(@rdivide,R,D');
    return;
end

if ~isNormalized
    if isequal(X, Y)
        if ~isMeaned
            X = bsxfun(@minus, X, mean(X));
        end
        R = (X' * X) / size(X, 1);
        D = sqrt(diag(R));
        R = bsxfun(@rdivide, R, D); NCC = bsxfun(@rdivide, R, D');
    else
        if ~isMeaned
            X = bsxfun(@minus, X, mean(X));
            Y = bsxfun(@minus, Y, mean(Y));
        end
        R = (X' * Y) / size(X, 1);
        DX = sqrt(mean(X.*X));
        DY = sqrt(mean(Y.*Y));
        R = bsxfun(@rdivide, R, DX');
        NCC = bsxfun(@rdivide, R, DY);
    end
    
else % if normalized, the normalized correlation can be simplified
    if isequal(X, Y)
        NCC = (X' * X) / size(X, 1);
    else
        NCC = (X' * Y) / size(X, 1);
    end
    
end

end

