%% Testing M�todo usando Sparse

load('cropped_parts.mat');
load('Indices.mat');
load('Dtrain.mat')
partes_test = cropped_parts(not(indice_training(1:4174)));
N = 10;  %Nº de Sparse

Y = [];
Labels = zeros(length(partes_test),1);
Sparse = [];

param.L          = 50;           % not more than L non-zeros coefficients
param.eps        = 0;           % optional, threshold on the squared l2-norm of the residual, 0 by default
param.numThreads = -1;          % number of processors/cores to use; the default choice is -1 (it selects all the available CPUs/cores)

for k=1:length(partes_test)
    
    
    Yk = [];
    Xk = [];
    
    if isempty(partes_test{k})
        fprintf("Is empety, next \n");
        
    else
        fprintf("Processing %d/%d : %s\n", k, length(partes_test), char(partes_test{k}.filename));

        l_eye = im2double(partes_test{k}.l_eye(:));
        r_eye = im2double(partes_test{k}.r_eye(:));
        mouth = im2double(partes_test{k}.mouth(:));
        nose = im2double(partes_test{k}.nose(:));
        
        offset = [0,length(r_eye) , length(l_eye), size(mouth,1) ,size(nose,1)];
        offset = cumsum(offset)+1;
        
        Yk = zeros(2*length(r_eye) + numel(mouth) + numel(nose),1);
        
        Yk(offset(1):(offset(2)-1),1) = l_eye./norm(l_eye);
        Yk(offset(2):(offset(3)-1),1) = r_eye./norm(r_eye);
        Yk(offset(3):(offset(4)-1),1) = mouth./norm(mouth);  
        Yk(offset(4):(offset(5)-1),1) = nose./norm(nose);  
        
        Labels(k) = 1;
        Y = [Y,Yk(:)];
        Xk = full(mexOMP(Yk,D,param));
        Sparse = [Sparse,Xk(:)];
    end
     
end

Labels = logical(Labels);


save('Sparse_test.mat','Y','Sparse','Labels');
    