function cmap= cmap_posneg_widewhite(m, white_percent)
%CMAP_RAINBOW - Colormap going from red/yellow over white to cyan/blue
%
%Description:
%  This function returns a colormap. The colors goes from red to
%   yellow to white to cyan to blue.
%
%Usage:
%  MAP= cmap_rainbow(M, WHITE_PERCENT)
%
%Input:
%  M  : Size of the colormap (number of entries). Default value: Same size
%       as current colormap
%
%Output:
%  MAP: A colormap matrix of size [M 3]
%
%Example:
%  clf; 
%  colormap(cmap_posneg(65));
%  imagesc(toeplitz(1:65)); colorbar;
%
%See also COLORMAP, HSV2RGB, CMAP_HSV_FADE

if nargin<1 | isempty(m),
  m= size(get(gcf,'colormap'),1);
end
if nargin<2,
  white_percent= 15;
end

if mod(m,2)==0,
  warning('m should be odd -> using m+1');
  m= m+1;
end

ww= 2*floor(m*white_percent/100/2)+1;
wp= 1;
mb6= floor((m-ww)/(4+2*wp));
mq= m-ww - (4+2*wp)*mb6;
m1= mb6;
m2= mb6 + (mq>=2);
m3= wp*mb6 + (mq>=4);
map1= cmap_hsv_fade(m1+1, 0, 1, [0.5 1]);
map2= cmap_hsv_fade(m2+1, [0 1/6], 1, 1);
map3= cmap_hsv_fade(m3+1, 1/6, [1 0], 1);
mapw= ones(ww-1, 3);
map4= cmap_hsv_fade(m3+1, 3/6, [0 1], 1);
map5= cmap_hsv_fade(m2+1, [3/6 4/6], 1, 1);
map6= cmap_hsv_fade(m1+1, 4/6, 1, [1 0.5]);
cmap= [map1; map2(2:end,:); map3(2:end,:); mapw; ...
       map4(2:end,:); map5(2:end,:); map6(2:end,:)];
cmap= flipud(cmap);
