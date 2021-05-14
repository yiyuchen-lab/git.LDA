function [cnt mrk]=nirs_deletePauses(cnt, mrk, pthres, ltrs, varargin)
%
% nirs_deletePauses - Deletes experimental pauses from given marker structure
%                   - if distance between two markers exceeds 'pthres' a pause is
%                     defined (see nirs_getPauses)
%
% Synopsis:
%   [cnt mrk]=nirs_deletePauses(cnt, mrk, pthres, varargin);
%
% Arguments:
%   cnt      - continuous data (struct, see eegfile_loadBV,
%              eegfile_loadMatlab)
%   mrk      - struct for class markers (see mrk_defineClasses)
%   pthres   - threshold in samples
%   ltrs     - lenght of trial in seconds
%
% Returns:
%   pauses   - number of pauses X 2; start and end of each pause
%
% Optional
%   .plot    - show plots, if a channel is defined e.g. 'C3_Pz'
%              (default 0)
%
% See also: nirs_removePauses

%
% Arne Ewald, mail@aewald.net, 2013

opt= propertylist2struct(varargin{:});

[opt, isdefault]= ...
    set_defaults(opt, ...
                 'plot', 0);
             
%% 

[nsamps nch]=size(cnt.x);



pausesAll=nirs_getPauses(mrk, pthres, ltrs);
[npausesAll dum]=size(pausesAll);

mrk_og=mrk; % original marker

% the new data length is reduced by the sum of the lengths of the pauses
data=zeros(nsamps-sum(pausesAll(:,2)-pausesAll(:,1)), nch);

% for testing purposes
% chan=1;
% figure;
% nirs_plotChannel(cnt, cnt.clab(1), 'mrk', mrk, 'pthresh', pthres, 'ltrs', ltrs);

 
for chan=1:nch

    mrk=mrk_og;    
    % data of the channel
    dch=cnt.x(:,chan);
    
    for pp=1:npausesAll
        
        p=1;
        
        pausesLoc=nirs_getPauses(mrk, pthres, ltrs);

        %data mean
        md1=mean(dch(1:pausesLoc(p,1))); % mean of data before pause
        % md2=mean(dch(pausesLoc(p,2)+1:end)); % mean of data after pause
        if size(pausesLoc,1)>1
            md2=mean(dch(pausesLoc(p,2)+1:pausesLoc(p+1,1))); % mean of data of next block
        else
            md2=mean(dch(pausesLoc(p,2)+1:end)); % mean of data after pause
        end
        
        rd=((dch(pausesLoc(p,2)+1:end))/md2)*md1; % rescaling data after pause
        
        
        % length of pause
        pl=pausesLoc(p,2)-pausesLoc(p,1);
        % adjust all markers after the pause
        mrk.pos((mrk.pos>=pausesLoc(p,2)))=mrk.pos((mrk.pos>=pausesLoc(p,2)))-pl;
        
        % adjust data
        dtemp=[dch(1:pausesLoc(p,1))' rd']';
        
        dch=dtemp;
        if sum(chanind(cnt.clab, opt.plot)==chan)
            ctloc=[];
            ctloc.x=dch;
            ctloc.clab=cnt.clab(chan);
            ctloc.fs=mrk.fs;
            ctloc.wavelengths=cnt.wavelengths;

            figure;
            nirs_plotChannel(ctloc, ctloc.clab(1), 'mrk', mrk, 'pthresh', pthres, 'ltrs', ltrs);
        end
        
        
     end
   
   data(:,chan)=dch;
   
end
   
% check
% length(cnt.x)-length(data)==sum(npausesAll(:,2)-npausesAll(:,1));
   
cnt.x=data;

clear data;
