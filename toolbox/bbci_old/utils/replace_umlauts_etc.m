function str= replace_umlauts_etc(str)

str= strrep(str, '�', 'ae');
str= strrep(str, '�', 'oe');
str= strrep(str, '�', 'ue');
str= strrep(str, '�', 'Ae');
str= strrep(str, '�', 'Oe');
str= strrep(str, '�', 'Ue');
str= strrep(str, '�', 'ss');

str= strrep(str, '�', 'a');
str= strrep(str, '�', 'a');
str= strrep(str, '�', 'a');
str= strrep(str, '�', 'a');
str= strrep(str, '�', 'e');
str= strrep(str, '�', 'e');
str= strrep(str, '�', 'e');
str= strrep(str, '�', 'i');
str= strrep(str, '�', 'i');
str= strrep(str, '�', 'i');
str= strrep(str, '�', 'o');
str= strrep(str, '�', 'o');
str= strrep(str, '�', 'o');
str= strrep(str, '�', 'o');
str= strrep(str, '�', 'u');
str= strrep(str, '�', 'u');
str= strrep(str, '�', 'u');
str= strrep(str, '�', 'n');
str= strrep(str, '�', 'c');

str= strrep(str, '�', 'A');
str= strrep(str, '�', 'A');
str= strrep(str, '�', 'A');
str= strrep(str, '�', 'A');
str= strrep(str, '�', 'E');
str= strrep(str, '�', 'E');
str= strrep(str, '�', 'E');
str= strrep(str, '�', 'I');
str= strrep(str, '�', 'I');
str= strrep(str, '�', 'I');
str= strrep(str, '�', 'O');
str= strrep(str, '�', 'O');
str= strrep(str, '�', 'O');
str= strrep(str, '�', 'O');
str= strrep(str, '�', 'U');
str= strrep(str, '�', 'U');
str= strrep(str, '�', 'U');
str= strrep(str, '�', 'N');
str= strrep(str, '�', 'C');

%% TODO: �, �, �, �, etc.
%% >> cc= char(64:256); cc(isletter(cc))
