function h = nirs_plotChannel(cnt, channel, varargin)
%
% nirs_plotChannel  - plots data in a single NIRS channel
%
% Synopsis:
%   h = nirs_plotChannel(cnt, channel, varargin);
%
% Arguments:
%   cnt      - continuous data (struct, see eegfile_loadBV,
%              eegfile_loadMatlab)
%   mrk      - struct for class markers (see mrk_defineClasses)
%   channel  - channel to be plotted, e.g. 'C3_Pz'
%
% Returns:
%   h        - axis handle
%
% Optional
%   .mrk     - plots markers
%   .pthresh - color coding the automatically determined pauses (default 0)
%              if distance between two markers exceeds 'pthres' a pause is
%              defined (see nirs_getPauses)
%   .optpl   - plot options in a cell array, e.g. {'FontSize', 12}
%
%
% See also: 
%
%
% Arne Ewald, mail@aewald.net, 2013


%% Default options

opt= propertylist2struct(varargin{:});

[opt, isdefault]= ...
    set_defaults(opt, ...
                 'mrk', 0, ...
                 'pthresh', 0, ...
                 'ltrs', 0, ...
                 'optpl', {'FontSize', 12});

mrk=opt.mrk;

if isfield(cnt, 'yUnit')&&( strcmp(cnt.yUnit, 'mmol/l'))
    hbdat=1;
else 
    hbdat=0;
end


%%



[nframes nch]=size(cnt.x);
t=((1:nframes)/cnt.fs)./60;

chind=(chanind(cnt.clab, channel));
if isempty(chind)
   error('bbci:chnf', 'Channel not found')
end     

if size(chind,2)==2
    if hbdat;
        plot(t,cnt.x(:,chind(1)),'-r');
        hold on
        plot(t,cnt.x(:,chind(2)),'-b');        
    else
        plot(t,cnt.x(:,chind(1)),'-b');
        hold on
        plot(t,cnt.x(:,chind(2)),'-r');
    end
else
    if size(chind,2)==1
        plot(t,cnt.x(:,chind(1)),'-b');
        hold on
    else 
        error('bbci:chnf', 'Channel not found')
    end
end


if isstruct(opt.mrk)
    for i=1:length(mrk.pos)
%         switch mrk.toe(i)
%             case {1,9}
%                 c='--r';
%             case {2,10}
%                 c='--g';
%             case {3,11}
%                 c='--b';
%             case {4,12}
%                 c='--k';
%         end
        c='--k'; % color
        vlinedl(mrk.pos(i)/cnt.fs/60, c)
    end
end

if opt.pthresh~=0
    pauses=nirs_getPauses(opt.mrk, opt.pthresh, opt.ltrs);
    [npauses dum]=size(pauses);

    yt=get(gca, 'YTick');
    for i=1:npauses
        h=fill([pauses(i,1) pauses(i,1) pauses(i,2) pauses(i,2)]/cnt.fs/60, [yt(1) yt(end) yt(end) yt(1)], ...
               'red','FaceColor',[0 0.5 0.5],'FaceAlpha',0.2); 
    end
end

title(['Channel: ' untex(channel) ], opt.optpl{:});
xlabel('time [min]', opt.optpl{:});

% Hb/HbO data or Raw data? 
if hbdat
    legend('Hb', 'HbO');
    ylabel('Hb/HbO [mmol/l]', opt.optpl{:})    
else
    ylabel('Raw Potential [Volt]', opt.optpl{:})
    if size(chind,2)==2
    legend([num2str(cnt.wavelengths(1)) ' nm'], [num2str(cnt.wavelengths(2)) ' nm']);
    else
        if size(chind,2)==1
            legend([num2str(cnt.wavelengths(1)) ' nm'], [num2str(cnt.wavelengths(2)) ' nm']);
        else 
            error('bbci:chnf', 'Channel not found')
        end
    end

end
%set(gca, 'xTick', t)
set(gca, opt.optpl{:}); 

hold off


h=gca; % axis handle