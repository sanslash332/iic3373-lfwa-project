%% Testing M�todo usando Sparse

load('cropped_parts.mat');
load('Indices.mat');
load('Dtrain.mat')
partes_test = cropped_parts(not(indice_training(1:4174)));
N = 50;  %N� de Sparse
Sparse = [];

param.L          = 500;           % not more than L non-zeros coefficients
param.eps        = 0;           % optional, threshold on the squared l2-norm of the residual, 0 by default
param.numThreads = -1;          % number of processors/cores to use; the default choice is -1 (it selects all the available CPUs/cores)

for k=40:50
    
    
    Yk = [];
    Xk = [];
    
    if isempty(partes_test{k})
        fprintf("Is empety, next \n");

        Xk = ones(5720,1);
        Sparse = [Sparse; Xk'];
        
    else
        fprintf("Processing %d/%d : %s\n", k, length(partes_test), char(partes_test{k}.filename));

        l_eye = im2double(partes_test{k}.l_eye(:));
        r_eye = im2double(partes_test{k}.r_eye(:));
        mouth = im2double(partes_test{k}.mouth(:));
        nose = im2double(partes_test{k}.nose(:));

        for ii=1:4

            if ii == 1

                Yk = [l_eye./norm(l_eye) ;zeros(length(r_eye) + size(mouth,1) + size(nose,1),1)];
                Xk = [Xk; full(mexOMP(Yk,D,param))'];
         

            elseif ii== 2

                Yk = [zeros(size(l_eye,1),1) ; r_eye./norm(r_eye) ; zeros(size(mouth,1) + size(nose,1),1)];
                Xk = [Xk; full(mexOMP(Yk,D,param))'];

            elseif ii == 3

                Yk = [zeros(2*size(l_eye,1),1) ; mouth./norm(mouth) ; zeros(size(nose,1),1)];
                Xk = [Xk; full(mexOMP(Yk,D,param))'];

            else

                Yk = [zeros(2*length(r_eye) + size(mouth,1),1); nose./norm(nose)];
                Xk = [Xk; full(mexOMP(Yk,D,param))'];
            end
        end
     Xk = sum(Xk);
     Sparse = [Sparse;Xk];
    end
    
    
end