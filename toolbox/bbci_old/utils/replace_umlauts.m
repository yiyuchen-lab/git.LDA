function str= replace_umlauts(str)

str= strrep(str, '�', 'ae');
str= strrep(str, '�', 'oe');
str= strrep(str, '�', 'ue');
str= strrep(str, '�', 'Ae');
str= strrep(str, '�', 'Oe');
str= strrep(str, '�', 'Ue');
str= strrep(str, '�', 'ss');
