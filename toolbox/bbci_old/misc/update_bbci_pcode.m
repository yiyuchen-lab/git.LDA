filelist= [BCI_DIR 'toolbox/misc/include_pcode_bbcisvn.txt'];
excludelist= [BCI_DIR 'toolbox/misc/exclude_pcode_bbcisvn.txt'];
rootdir= BCI_DIR(1:end-1);
pcode_dir= [BCI_DIR(1:end-1) '_pcode'];

update_pcode_repository('filelist', filelist, ...
                        'rootdir', rootdir, ...
                        'pcode_dir', pcode_dir, ...
                        'exclude', excludelist);
