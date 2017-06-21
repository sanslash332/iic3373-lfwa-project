%% Extraccion de Features de los parches

b(1).name = 'lbp';
b(1).options.type = 2;
b(1).options.vdiv = 1;                  % one vertical divition
b(1).options.hdiv = 1;                  % one horizontal divition
b(1).options.semantic = 0;              % classic LBP
b(1).options.samples  = 8;              % number of neighbor samples
b(1).options.mappingtype = 'u2';  

b(2).name = 'haralick';
b(2).options.type = 2;
b(2).options.dharalick = 1;
b(2).options.show = 0; 

b(3).name = 'haralick';
b(3).options.type = 2;
b(3).options.dharalick = 2;
b(3).options.show = 0; 

b(4).name = 'hog';
b(4).options.type = 2;
b(4).options.nj = 10;
b(4).options.ni = 5;
b(4).options.B = 9;
b(4).options.show = 0;


b(5).name = 'gabor';
b(5).options.type = 2;
b(5).options.Lgabor  = 8;                 % number of rotations
b(5).options.Sgabor  = 8;                 % number of dilations (scale)
b(5).options.fhgabor = 2;                 % highest frequency of interest
b(5).options.flgabor = 0.1;               % lowest frequency of interest
b(5).options.Mgabor  = 21;                % mask size
b(5).options.show    = 0;     

% b(6).name = 'haar';
% b(6).options.type = 2;
% b(6).options.

opf.b = b;
opf.colstr = 'i'; 

load('all_data.mat');

X_parches = [];

%Aqui hago trampa

for k=1:length(all_data)
    
    fprintf("Processing %d/%d : %s\n", k, length(all_data), char(all_data{k}.filename));
    
    if all_data{k}.success == 1
        
        [X_Leye,Xn_Leye] = Bfx_int(all_data{k}.data{1},opf); 
        [X_Reye,Xn_Reye] = Bfx_int(all_data{k}.data{2},opf); 
        [X_nose,Xn_nose] = Bfx_int(all_data{k}.data{3},opf); 
        [X_mouth,Xn_mouth] = Bfx_int(all_data{k}.data{4},opf); 
        
    else
        
        [X_Leye,Xn_Leye] = Bfx_int(all_data{k-1}.data{1},opf); 
        [X_Reye,Xn_Reye] = Bfx_int(all_data{k-1}.data{2},opf); 
        [X_nose,Xn_nose] = Bfx_int(all_data{k-1}.data{3},opf); 
        [X_mouth,Xn_mouth] = Bfx_int(all_data{k-1}.data{4},opf); 
        
    end
    
    X_parches = [X_parches ; X_Leye X_Reye X_nose X_mouth];
       
end

save('X_parches.mat','X_parches');
