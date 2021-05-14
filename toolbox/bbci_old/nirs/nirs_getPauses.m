function [pauses]=nirs_getPauses(mrk, pthres, ltrs, varargin)
%
% GET_PAUSES - Calculates experimental pauses from given marker structure
%            - if distance between two markers exceeds 'pthres' a pause is
%              defined
%
% Synopsis:
%   [pauses]=nirs_getPauses(mrk, pthres, varargin)
%
% Arguments:
%   mrk      -  marker structure
%   pthres:  -  threshold in samples
%   ltrs     -  lenght of trial in seconds
%
% Returns:
%   pauses: number of pauses X 2; start and end of each pause
%
% Optional
%   'offset: an additional offset
%
% See also: nirs_deletePauses

%
% Arne Ewald, mail@aewald.net, 2013

opt= propertylist2struct(varargin{:});

[opt, isdefault]= ...
    set_defaults(opt, ...
                 'offset', 0);


mkdiff=mrk.pos(2:end)-mrk.pos(1:end-1);
pauses=ceil([mrk.pos(find(mkdiff>pthres))' mrk.pos(find(mkdiff>pthres)+1)']);

pauses(:,1)=pauses(:,1)+ ceil(ltrs*mrk.fs) +1;

[npauses dum]=size(pauses);