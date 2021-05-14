function [min_value,min_param] = plot_memo_ms(ms_memo,lims)
% function [min_value] = plot_memo_ms(ms_memo,lims)
%
% Visualizes the grid search of bbci model selection for one or two
% parameters.
%
% If the model selection is used in combination with xvalidation, you
% have to visualize each outer fold individually. Select ms_memo for wanted
% fold with: memo(outer_fold_idx).ms_memo, where memo is an an output from
% xvalidation
%
%
% inputs
% ms_memo: struct from model seletion
% lims: (optional) scaling [max_loss min_loss]
%
% output
% min_value: best performance in grid
% min_param: best parameters
%
%
% Nov. 2012, janne.hahne@tu-berlin.de
%


nParameters = length(ms_memo.mesha);


switch nParameters
    case 1 % 1 parameter case:
        
        plot_y = ms_memo.EE(:,1);
        plot_x = ms_memo.mesha{1}(:,1);
        
        plot(plot_x,plot_y);
        
        if nargin == 2
            ylim(lims);
        end
        
        [min_val,index] = min(plot_y);
        
        min_param = plot_x(index);
        
        hold on;
        line([1 1]*min_param,get(gca,'ylim'),'Color','k');
        hold off;
        
        if isfield(ms_memo.model.param(1),'string')
            xlab = ms_memo.model.param(1).string;
        else
            xlab = 'param 1';
        end
        
        if strcmp(ms_memo.model.param(1).scale,'log')
            xlab = [xlab ' 10^'];
        end
        
        xlabel(xlab, 'Interpreter', 'none');
        title(['Lowest error: ' num2str(min_val)], 'Interpreter', 'none');
        colorbar;
        
        
    case 2 % 2 parameter case:
        
        [Np1 Np2] = size(ms_memo.mesha{1});
        err_grid_2d = reshape( ms_memo.EE(:,1),Np1,Np2);
        
        if nargin < 2
            imagesc(err_grid_2d')
        else
            imagesc(err_grid_2d',lims)
        end
        
        [min_value,index1] = min(err_grid_2d',[],2);
        [min_value,index2] = min(min_value);
        hold on;
        plot(index1(index2),index2,'x');
        line([1 1]*index1(index2),[1 Np2],'Color',[1 1 1]);
        line([1 Np1],[1 1]*index2,'Color',[1 1 1]);
        hold off;
        set(gca,'Xtick',1:length(ms_memo.mesha{1}(:,1)))
        set(gca,'Ytick',1:length(ms_memo.mesha{2}(1,:)))
        set(gca,'XtickLabel',ms_memo.mesha{1}(:,1))
        set(gca,'YtickLabel',ms_memo.mesha{2}(1,:))
        
        min_param = [ms_memo.mesha{1}(index1(index2),1) ms_memo.mesha{2}(1,index2)];
        
        if isfield(ms_memo.model.param(1),'string')
            xlab = ms_memo.model.param(1).string;
            ylab = ms_memo.model.param(2).string;
        else
            xlab = 'param 1';
            ylab = 'param 2';
        end
        
        if strcmp(ms_memo.model.param(1).scale,'log')
            xlab = [xlab ' 10^'];
            min_param(1) = 10^min_param(1);
        end
        
        if strcmp(ms_memo.model.param(2).scale,'log')
            ylab = [ylab ' 10^'];
            min_param(2) = 10^min_param(2);
        end
        
        xlabel(xlab, 'Interpreter', 'none');
        ylabel(ylab, 'Interpreter', 'none')
        title(['Lowest error: ' num2str(min_value)], 'Interpreter', 'none');
        colorbar;
        
    otherwise
        warning('Visualisation for more than 2 parameters not implemented yet!')
        disp('Visualisation will be screwed up....');
        
                [Np1 Np2] = size(ms_memo.mesha{1});
        err_grid_2d = reshape( ms_memo.EE(:,1),Np1,Np2);
        
        if nargin < 2
            imagesc(err_grid_2d')
        else
            imagesc(err_grid_2d',lims)
        end
        
        [min_value,index1] = min(err_grid_2d',[],2);
        [min_value,index2] = min(min_value);
        hold on;
        plot(index1(index2),index2,'x');
        line([1 1]*index1(index2),[1 Np2],'Color',[1 1 1]);
        line([1 Np1],[1 1]*index2,'Color',[1 1 1]);
        hold off;
        set(gca,'Xtick',1:length(ms_memo.mesha{1}(:,1)))
        set(gca,'Ytick',1:length(ms_memo.mesha{2}(1,:)))
        set(gca,'XtickLabel',ms_memo.mesha{1}(:,1))
        set(gca,'YtickLabel',ms_memo.mesha{2}(1,:))
        
        min_param = [ms_memo.mesha{1}(index1(index2),1) ms_memo.mesha{2}(1,index2)];
        
        if isfield(ms_memo.model.param(1),'string')
            xlab = ms_memo.model.param(1).string;
            ylab = ms_memo.model.param(2).string;
        else
            xlab = 'param 1';
            ylab = 'param 2';
        end
        
        if strcmp(ms_memo.model.param(1).scale,'log')
            xlab = [xlab ' 10^'];
            min_param(1) = 10^min_param(1);
        end
        
        if strcmp(ms_memo.model.param(2).scale,'log')
            ylab = [ylab ' 10^'];
            min_param(2) = 10^min_param(2);
        end
        
        xlabel(xlab, 'Interpreter', 'none');
        ylabel(ylab, 'Interpreter', 'none')
        title(['Lowest error: ' num2str(min_value)], 'Interpreter', 'none');
        colorbar;
end
