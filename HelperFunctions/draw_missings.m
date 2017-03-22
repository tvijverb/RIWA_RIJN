function [ ] = draw_missings( S )
%DRAW_MISSINGS Summary of this function goes here
%   Detailed explanation goes here
figure

[r,c] = size(S(5).X);

rectangle('Position',[1,1,r,c],'FaceColor',[0 .5 .5]);

for i = 1 : r
    for j = 1 : c
        if(isnan(S(5).X(i,j)))
            rectangle('Position',[i,j,1,1],'FaceColor',[0.5 .5 .5]);
        end
    end
end

end

