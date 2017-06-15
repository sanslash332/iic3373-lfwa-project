function [X,Xn] = Bfx_patrones(I,R,options)

% Es una est

<<<<<<< HEAD

n = length(opf.b);
kg = 0;
ki = 0;
opg = [];
opi = [];

for i=1:n
    if opf.b(i).options.type == 1
        kg = kg+1;
        opg.b(kg) = opf.b(i);
    else
        ki = ki+1;
        opi.b(ki) = opf.b(i);
    end
end


X = [];
S = [];

if doseg
    if isfield(opf,'param')
        par = opf.param;
    else
        par = [];
    end
end

if isfield(opf,'intensity')
    inten = opf.intensity;
else
    inten = doseg;
end

ct = 'gRGBHSVLab12';
co = zeros(length(ct),1);

if isfield(opf,'channels')
    ch = opf.channels;
    if compare(class(ch),'char')==0
        colorstr = ch;
    else % cell
        colorstr = [];
        nx = length(ch);
        for i=1:nx
            chs = lower(char(ch(i)));
            switch chs
                case 'gray'
                    str = 'g';
                    
                case 'red'
                    str = 'R';
                    
                case 'green'
                    str = 'G';
                    
                case 'blue'
                    str = 'B';
                    
                case 'hue'
                    str = 'H';
                    
                case {'sat','saturation'}
                    str = 'S';
                    
                case {'value','val'}
                    str = 'V';
                    
                case {'l','l*'}
                    str = 'L';
                    
                case {'a','a*'}
                    str = 'a';
                    
                case {'b','b*'}
                    str = 'b';
                    
                case {'saliency_1','saliency_on'}
                    str = '1';
                    
                case {'saliency_2','saliency_off'}
                    str = '2';
            end
            colorstr = [colorstr str];
            
        end
        
    end
else
    colorstr = 'g';
end
nc = length(colorstr);
for i=1:nc
    opi.colstr = colorstr;
    ii = ct==colorstr(i);
    co(ii) = 1;
end
nc = sum(co);
if nc>0
    ff = Bio_statusbar('Feature Extraction');
    opf.channels = ct(co==1);
    for i=f.imgmin:f.imgmax
        ff = Bio_statusbar((i-f.imgmin)/(f.imgmax-f.imgmin+1),ff);
        Xi = [];
        Xn = [];
        [I,st] = Bio_loadimg(f,i);
        if labeling
            imshow(I(:,:,1),[])
        end
        [N,M,P] = size(I);
        IX = zeros(N,M,nc);
        
        if sum(co(2:4))>0
            XRGB = I;
        end
        if sum(co(5:7))>0
            XHSV = rgb2hsv(I);
        end
        if sum(co(8:10))>0
            
            if (exist('LAB.mat','file'))
                load LAB
                XLAB = Bim_rgb2lab(I,M);
            else
                disp('Warning: LAB.mat does not exist. CIE formulas will be used for L*a*b conversion');
                XLAB = Bim_rgb2lab0(I);
            end
        end
        if sum(co(11:12))>0
            [J_on,J_off] = Bim_cssalient(I,1,0);
        end
        
        k = 0;
        jj = find(co);
        for ji=1:length(jj)
            j = jj(ji);
            k = k + 1;
            switch j
                case 1 % Gray
                    if size(I,3)==3
                        IX(:,:,k) = rgb2gray(I/256)*256;
                    else
                        if max(I(:))>256
                            IX(:,:,k) = I/256;
                        else
                            IX(:,:,k) = I;
                        end
                    end
                case 2 % Red
                    IX(:,:,k) = XRGB(:,:,1);
                case 3 % Green
                    IX(:,:,k) = XRGB(:,:,2);
                case 4 % Blue
                    IX(:,:,k) = XRGB(:,:,3);
                case 5 % H
                    IX(:,:,k) = XHSV(:,:,1);
                case 6 % S
                    IX(:,:,k) = XHSV(:,:,2);
                case 7 % V
                    IX(:,:,k) = XHSV(:,:,3);
                case 8 % L*
                    IX(:,:,k) = XLAB(:,:,1);
                case 9 % a*
                    IX(:,:,k) = XLAB(:,:,2);
                case 10 % b*
                    IX(:,:,k) = XLAB(:,:,3);
                case 11 % Saliency on
                    IX(:,:,k) = J_on;
                case 12 % Saliency on
                    IX(:,:,k) = J_off;
            end
            
            %end
        end
        
        fprintf('\n--- processing image %s...\n',st);
        if doseg
            if ~isempty(par)
                Rg = feval(seg,I,par);
            else
                Rg = feval(seg,I);
            end
        else
            Rg = [];
        end
        if inten
            Ri = Rg;
        else
            Ri = [];
        end
        if ~isempty(opg)
            if ~isempty(opg.b)
                [Xgeo,Xng] = Bfx_geo(Rg,opg);
                Xi = [Xi Xgeo];
                Xn = [Xn;Xng];
            end
        end
        if ~isempty(opi)
            if ~isempty(opi.b)
                [Xint,Xni] = Bfx_int(IX,Ri,opi);
                Xi = [Xi Xint];
                Xn = [Xn;Xni];
            end
        end
        if labeling
            d(i-f.imgmin+1,1) = input('Label for this image? ');
        end
        X = [X;Xi];
        st = [st ones(1,200)*' '];
        S = [S;st(1:100)];
    end
    delete(ff);
else
    error('Bfx_files error: Colors %s are recognized',colorstr);
=======
for k=1:length(Regions)
    Ik = imcrop(I,Regions(k));
    [Xk,Xnk] = Bfx_int(Ik,R,options);
    X = [X Xk];
    Xn = [Xn Xnk];
end

>>>>>>> 8e0fb8d98bb3af33ff5cbbf29e04fe2105f82814
end