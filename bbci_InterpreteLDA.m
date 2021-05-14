
clear all
 
% swich from new bbci to old bbci for calculation
rmpath(genpath('toolbox/bbci_new/'))
addpath(genpath('toolbox/bbci_old'))

% load data samples and LDA weights
load('mat/epos.mat','epos_player')
load('mat/LDA_loss_and_weights.mat')

% correct labels
epos_labelfixed = cellfun(@(s) {setfield(s,'className',epos_player{1}.className([1,2,4,3]))}, epos_player);

% ERP component interval
components = {[170, 200], [240 290], [320 340],[440 520],[490,520]};

% locate corresponding ERP component timpoints indices in weights
weights_ival = epos_labelfixed{1}.t(ismember(epos_labelfixed{1}.t,(100:10:600)));
comp_idx     = cellfun(@(t) {find(ismember(weights_ival,(t(1):10:t(2))))}, components);
classPair    = combnk(epos_player{1}.className,2);

% some N numbers
n_classPair    = size(classPair,1);
n_chan         = size(epos_labelfixed{1}.x,2);
n_time_weights = length(weights_ival);
n_participants = length(epos_labelfixed);
n_components   = size(components,2);

% method
process             = 2; %[1,2]
norm_for_group_mean = 0;


% pre-allocate space for activation map
A_s    = zeros(n_classPair, n_components, n_chan, n_participants);

for cPair = 1:n_classPair
    
    for comp = 1: n_components
        
        epos_ival  = cellfun(@(s) {proc_selectIval(s,components{comp})}, epos_labelfixed);
        Xs         = [];
        for participant = 1: n_participants

            %% map the weight struct array (output of xvalidation function) 
            %% back to sensor space: [n_time, n_chan, 100].
            % weights{cPair}{participant}.C dimension： 
            % 1x100 (10_fold*10_repetition)
            classifiers   = {weights{cPair}{participant}.C} ;
            weights_cell  = cellfun(@(c) ...
                                   {reshape(c.w,[n_time_weights,n_chan])},...
                                   classifiers);

            % weights_array dimension: 
            % [n_time, n_chan, 100]
            weights_array = cat(3,weights_cell{:});
            
            
            % select weight within the ERP component time interval
            % and take mean across these timepoints
            W = weights_array(comp_idx{comp},:,:);
            
            
            %% normalize W and mean across time points
            % (adjust dimension for forward model calculation)
            if process == 1 
                W = normalize(W);
            end
            W_mean = squeeze(mean(W,1)); % W_mean: [n_chan, 100]
            % W_mean = squeeze(mean(W_mean,2)); % W_mean: [n_chan] 
            % mean across folds and repetitions on [W:weight] or on [A: 
            % activation map](noted by '***') doesn't make differences 
            % visually on plot.


            %% select binary class for X
            % epos dimension: n_time, n_chan, n_trials 
            epos    = proc_selectClasses(epos_ival{participant}, classPair(cPair,:));
            X       = mean(epos.x,3); % mean across trials

            %% compute forward model from LDA weights
            A = cov(X)*W_mean;
            
            % activation map dimension:  [n_chan, 100]
            A_mean = squeeze(mean(A,2)); % ***
            A_s(cPair,comp,:,participant) = A_mean;

                                
        end     
    end
end
save('mat/LDA_activation_map.mat','A_s','classPair')



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

% mean across participants
A_mean = squeeze(mean(A_s,4));
n_components = length(components);
n_classPair  = size(classPair,1);

figure;
tiledlayout(n_components, n_classPair, ...
            'Padding', 'none', ...
            'TileSpacing', 'compact'); 
for comp = 1:n_components
    for cPair = 1:n_classPair
        
       w_plot= squeeze(A_mean(cPair,comp,:));

       nexttile
       plot_scalp(mnt,w_plot,...
                'colormap',cmap_posneg(51),...
                'Extrapolation', 1, ...
                'extrapolateToMean', 1,...
                'ContourPolicy','withinrange',...%'markcontour_lineprop',{'LineWidth',3} ,...
                'scalePos','none');

    end
end

util_printFigure(['LDA_activation_map_process_' num2str(process) ...
                  '_normalized_for_group_mean_' num2str(norm_for_group_mean)  ],...
                  'Folder','fig/LDA_weights/',...
                  'format','pdf')
