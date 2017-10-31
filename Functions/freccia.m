function[]=freccia(p1, p2,s,d)
%p1 = [x1 y1]  p2=[x2 y2]
dp = p2-p1;                        
quiver(p1(1),p1(2),dp(1),dp(2),0)
text(p1(1),p1(2),s)
%text(d, sprintf('(%s)',p2))