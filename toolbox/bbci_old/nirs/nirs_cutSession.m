function [cnt mrk] = nirs_cutSession(cnt, mrk, stimdur, dpkeep,  varargin)
%
% nirs_cutSession - Deletes all data points before "first marker - dpkeep(1)"
%                   and after "last marker + stimdur + dpkeep(2)", 
%                   i.e. before the first marker and the last marker pluse the 
%                   stimulus duration and and additional offset. 
%
% Synopsis:
%   [cnt mrk] = nirs_cutSession(cnt, mrk, stimdur, dpkeep,  varargin)
%
% Arguments:
%   cnt      - continuous data (struct, see eegfile_loadBV,
%              eegfile_loadMatlab)
%   mrk      - struct for class markers (see mrk_defineClasses)
%   stimdur  - stimulus duration or lenght of trial in seconds
%   dpkeep   - [dpk_before dpk_after]; data points to keep before first
%              marker and after 'last marker + stimulus duration'
%
% Returns:
%   Updated CNT and MRK strucure 
%
% Optional:
%   
%
% See also: 
% 
%
% ToDo: 
%            - checking the inputs
%            - plotting capabilites
%  
% Ver 1.0.: Arne Ewald, mail@aewald.net, 2013


% delete data before first marker
start_fr=mrk.pos(1)-dpkeep(1);

% adjusting the marker structure
mrk.pos=mrk.pos-start_fr;

% deleting everything before the first marker
cnt.x(1:start_fr,:)=[];

% delete data after 'last marker' + 'stimulus duration' + 'offset'
stimdur_frames=ceil(stimdur*cnt.fs)-1;
last_frame=mrk.pos(end)+stimdur_frames+dpkeep(2);
cnt.x(last_frame:end,:)=[];

