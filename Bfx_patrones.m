function [X,Xn] = Bfx_patrones(I,R,options)

options.R = Regions;


for k=1:length(Regions)
    Ik = imcrop(I,Regions(k));
    [Xk,Xnk] = Bfx_int(Ik,R,options);
    X = [X Xk];
    Xn = [Xn Xnk];
end

end