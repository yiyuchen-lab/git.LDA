function mrk= mrkodef_imag_arrow(mrko, varargin)

stimDef= {'S  1', 'S  2',  'S  3';
           'left', 'right', 'foot'};
miscDef= {'S100',    'S101',  'S249',        'S250',      'S252',  'S253';
          'cue off', 'cross', 'pause start', 'pause end', 'start', 'end'};

opt= propertylist2struct(varargin{:});
opt= set_defaults(opt, 'stimDef', stimDef, ...
                       'miscDef', miscDef);

mrk= mrk_defineClasses(mrko, opt.stimDef);
mrk.misc= mrk_defineClasses(mrko, opt.miscDef);
