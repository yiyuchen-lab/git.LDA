function opt= defopt_scalp_erp2(varargin);
%DEFOPT_SCALP_ERP2 - Define
%


opt= propertylist2struct(varargin{:});
opt= set_defaults(opt, ...
                  'shading','interp', ...
                  'extrapolate',1, ...
                  'extrapolateToMean',0, ...
                  'resolution', 71, ...
                  'colAx','sym', ...
                  'shrinkColorbar', 0.2, ...
                  'colormap',jet(51), ...
                  'contour',5, ...
                  'lineWidth', 2, ...
                  'channelLineStyleOrder', {'thick','thin'}, ...
                  'ival_color', [0.8 0.8 0.8; 0.6 0.6 0.6], ...
                  'contour_policy','strict', ...
                  'contour_lineprop',{'LineWidth',0.3}, ...
                  'mark_properties',{'MarkerSize',6, 'LineWidth',1}, ...
                  'globalCLim',1, ...
                  'renderer', 'contourf', ...
                  'legend_pos','NorthWest');
