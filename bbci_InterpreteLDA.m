
clear all
 
% swich from new bbci to old bbci for calculation
rmpath(genpath('toolbox/bbci_new/'))
addpath(genpath('toolbox/bbci_old'))

% load data samples and LDA weights
load('mat/epos.mat','epos_player')
%load('mat/LDA_loss_and_weights.mat')

% correct labels
epos = cellfun(@(s) {setfield(s,'className',epos_player{1}.className([1,2,4,3]))}, epos_player);

% ERP component interval
% components = {[170, 200], [240 290], [320 340],[440 520],[490,520]};
components = {[170, 200], [240 290], [320 340]};

% locate corresponding ERP component timpoints indices in weights
weights_ival = epos{1}.t(ismember(epos{1}.t,(100:10:600)));
comp_idx     = cellfun(@(t) {find(ismember(weights_ival,(t(1):10:t(2))))}, components);
classPair    = combnk(epos_player{1}.className,2);

% some N numbers
n_classPair    = size(classPair,1);
n_chan         = size(epos{1}.x,2);
n_time_weights = length(weights_ival);
n_participants = length(epos);
n_components   = size(components,2);

% method
process             = 2; %[1,2]
norm_for_group_mean = 0;


% pre-allocate space for activation map
A_s    = zeros(n_classPair, n_components, n_chan, n_participants);
for cPair = 1:size(classPair,1)
    pair_epos = cellfun(@(s) {proc_selectClasses(s,classPair(cPair,:))}, epos);
    for comp = 1%1:n_components
        for participant = 1:n_participants
            epo_comp = proc_selectIval(pair_epos{participant}, components{comp});
            [I,J] = max(epo_comp.x,[],1);
            center = proc_selectChannels(epo_comp)
        end
    end
end

%% train the whole dataset on LDA for each ERP component
    
for cPair = 1:size(classPair,1)

    pair_epos = cellfun(@(s) {proc_selectClasses(s,classPair(cPair,:))}, epos);

    for comp = 3%1:n_components

        for participant = 1:n_participants
            
            %  ===== prepare epo for training =====

            % select current ERP component interval
            epo_comp = proc_selectIval(pair_epos{participant}, components{comp});

            % reduce time dimension to single data point for current ERP component
            if comp ~= 3
                epos_jm  = proc_jumpingMeans(epo_comp, 2);
            else
                epos_jm = epo_comp;
            end


            %  =====  train LDA  =====

            fv = proc_flaten(epos_jm); % [30(ch) x n_trials]
            C  = train_RLDAshrink(fv.x, fv.y); 
            W  = C.w; % [30x1]  


            %  ===== caculate activation map =====

            % average across trials for X 
            % X  = mean(fv.x,2);  % [30x1]
            X  = mean(epos_jm.x,3);
            % activation map [30x1]
            A  = cov(X) * mean(reshape(W,size(epos_jm.x(:,:,1))),1)';

            % ===== store data for later visualization =====
            A_s(cPair,comp,:,participant) = A;
        end
    end
end
save('mat/LDA_activation_map_latest.mat','A_s','classPair')



%% old script 
% for cPair = 1:n_classPair
%     
%     for comp = 1: n_components
%                 
%         for participant = 1: n_participants
% 
%             %% map the weight struct array (output of xvalidation function) 
%             %% back to sensor space: [n_time, n_chan, 100].
%             % weights{cPair}{participant}.C dimension： 
%             % 1x100 (10_fold*10_repetition)
%             classifiers   = {weights{cPair}{participant}.C} ;
%             weights_cell  = cellfun(@(c) ...
%                                    {reshape(c.w,[n_time_weights,n_chan])},...
%                                    classifiers);
% 
%             % weights_array dimension: 
%             % [n_time, n_chan, 100]
%             weights_array = cat(3,weights_cell{:});
%             
%             
%             % select weight within the ERP component time interval
%             % and take mean across these timepoints
%             W = weights_array(comp_idx{comp},:,:);
%             
%             
%             %% normalize W and mean across time points
%             % (adjust dimension for forward model calculation)
%             if process == 1 
%                 W = normalize(W);
%             end
%             W_mean = squeeze(mean(W,1)); % W_mean: [n_chan, 100]
%             % W_mean = squeeze(mean(W_mean,2)); % W_mean: [n_chan] 
%             % mean across folds and repetitions on [W:weight] or on [A: 
%             % activation map](noted by '***') doesn't make differences 
%             % visually on plot.
% 
% 
%             %% select ERP component interval and same binary classes for X
%             % epos dimension: n_time, n_chan, n_trials 
%             epo_comp = proc_selectIval(epos_labelfixed{participant},components{comp});
%             epos     = proc_selectClasses(epo_comp, classPair(cPair,:));
%             X        = mean(epos.x,3); % mean across trials
% 
%             %% compute forward model from LDA weights
%             A        = cov(X)*W_mean;
%             
%             % activation map dimension:  [n_chan, 100]
%             A_mean                     = squeeze(mean(A,2)); % ***
%             A_s(cPair,comp,:,partpant) = A_mean;
% 
%                                 
%         end     
%     end
% end



%% plot
% load('mat/LDA_activation_map.mat') uncomment if A is already calculated
% swich from old bbci to new bbci for plotting
% if using matlab version > 2014a
rmpath(genpath('toolbox/bbci_old/'))
addpath(genpath('toolbox/bbci_new'))
load('mat/mnt.mat')


global BTB
BTB.TypeChecking = 1;
BTB.History=[];

if norm_for_group_mean
    A_s=normalize(A_s); 
end

plot_individual = 0;
comp_name       = {'P200','N200','N300','LPP','Post-LPP'};
n_components    = length(components);
n_classPair     = size(classPair,1);

if ~plot_individual
    tiledlayout(n_components, n_classPair, ...
                'Padding', 'none', ...
                'TileSpacing', 'compact'); 
end 

h = zeros(n_components,n_classPair,n_chan);
p = zeros(n_components,n_classPair,n_chan);


figure;
tiledlayout(n_components, n_classPair, ...
          'Padding', 'none','TileSpacing', 'compact');         
for comp = 1:n_components
    for cPair = 1:n_classPair
       if plot_individual

          figure;
          tiledlayout(4, 6, 'Padding', 'none', 'TileSpacing', 'compact');  
          for participant = 1: n_participants
              a_plot = squeeze(A_s(cPair,comp,:,participant));
              nexttile
              plot_scalp(mnt,a_plot,...
                        'colormap',cmap_posneg(51),...
                        'Extrapolation', 1, ...
                        'extrapolateToMean', 1,...
                        'ContourPolicy','withinrange',...%'markcontour_lineprop',{'LineWidth',3} ,...
                        'scalePos','none');
          end
          util_printFigure(['LDA_activation_map_' ...
                            classPair{cPair,1},'_vs_', classPair{cPair,2},...
                            '_' comp_name{comp}],...
                            'Folder','fig/LDA_weights/individual/',...
                            'format','pdf')
          close all
       else

           A_mean = squeeze(mean(A_s,4));
           a_plot = squeeze(A_mean(cPair,comp,:));

           nexttile
           plot_scalp(mnt,a_plot,...
                    'colormap',cmap_posneg(51),...
                    'Extrapolation', 1, ...
                    'extrapolateToMean', 1,...
                    'ContourPolicy','withinrange',...%'markcontour_lineprop',{'LineWidth',3} ,...
                    'scalePos','none');
                
           A_for_stat = squeeze(A_s(cPair,comp,:,:));     
           for iChan = 1:n_chan
              group_val  = A_for_stat(iChan,:);
              [h(comp,cPair,iChan), p(comp,cPair,iChan)] = ttest(group_val,0,0.05/30); % test each channel separately
           end     
           
       end
        
    end
end

util_printFigure('LDA_activation_map_2',...
                 'Folder','fig/LDA_weights/',...
                 'format','pdf')
close all