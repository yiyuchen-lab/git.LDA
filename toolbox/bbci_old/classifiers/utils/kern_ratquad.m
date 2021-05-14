function [K,D] = kern_ratquad(X1,X2,varargin)
% kern_ratquad - Rational quadratic kernel
%
% Synopsis:
%   K = kern_ratquad(X1,X2)
%   K = kern_ratquad(X1,X2,'Property',Value,...)
%   
% Arguments:
%   X1: [d N1] matrix. Input data 1 for kernel matrix computation
%   X2: [d N2] matrix. Input data 2 for kernel matrix computation. If
%       left empty, X2==X1 will be assumed.
%   
% Returns:
%   K: [N1 N2] matrix with the evaluation of the kernel function for all
%      pairs of points X1 and X2.
%   
% Properties:
%   'inweights': Scalar or [1 d] vector. (Squared) weights for each input
%      dimension. This parameter is given on log-scale. Default:
%      log(1/d), where d is the number of input dimensions.
%   'degree': Scalar. Exponent in the expression (1+z)^(-degree). This
%      parameter is given on log-scale. Default: 0
%
% Description:
%   The rational quadratic kernel function is given by
%     k(x1,x2) = (1+z)^(-degree)
%   where z is the weighted distance between x1 and x2,
%     z = sum_{i=1}^d (x1(i)-x2(i))^2 * inweight(i)
%   
% See also: kernderiv_ratquad
% 

% Author(s): Anton Schwaighofer, Mar 2005
% $Id: kern_ratquad.m,v 1.2 2006/06/19 19:59:14 neuro_toolbox Exp $

error(nargchk(1, inf, nargin));
[ndims N1] = size(X1);
opt = propertylist2struct(varargin{:});
opt = set_defaults(opt, 'inweights', ones([1 ndims])*log(1/ndims), ...
                        'degree', 0);

% (1+tau)^(-degree) parametrization has problems in many applications: tau
% is getting tiny (tiny input weights) , degree large, indicating that the
% squared exponential kernel is the best solution
% Trying to re-parametrize the thing as (1+tau/degree)^(-degree):
% This does not improve numeric stability, but has the advantage that we
% can read off the length scale, see Rasmussen & Williams: They say that
% rbf: exp(-r^2/l^2) has lengthscale l
% ratquad: (1+r^2/(2*degree*l^2))^(-degree) has lengthscale l
% This is not true, the correct expression for ratquad is
% ratquad: (1+r^2/(degree*l^2))^(-degree) has lengthscale l
D = weightedDist(X1, X2, exp(opt.inweights-opt.degree-log(2)));
K = (D+1).^(-exp(opt.degree));
