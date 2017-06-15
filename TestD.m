%% Testing Método usando Sparse

load('cropped_parts.mat');
load('Indices.mat');
load('Dtrain.mat')
partes_test = cropped_parts(not(indice_training(1:4174)));
N = 50;  %N° de Sparse
Sparse = [];

for k=1:2
    
    fprintf("Processing %d/%d : %s\n", k, length(partes_test), char(partes_test{k}.filename));

    
    Yk = [];
    Xk = [];
    
    if isempty(partes_test{k})
        Xk = ones(2*length(l_eye) + size(mouth,1) + size(nose,1),4);
        Sparse = [Sparse; Xk];
        
    else
        l_eye = im2double(partes_test{k}.l_eye(:));
        r_eye = im2double(partes_test{k}.r_eye(:));
        mouth = im2double(partes_test{k}.mouth(:));
        nose = im2double(partes_test{k}.nose(:));

        for ii=1:4

            if ii == 1

                Yk = [l_eye./norm(l_eye) ;zeros(length(r_eye) + size(mouth,1) + size(nose,1),1)];
                Xk = [Xk; omp(D,Yk,N)];
         

            elseif ii== 2

                Yk = [zeros(size(l_eye,1),1) ; r_eye./norm(r_eye) ; zeros(size(mouth,1) + size(nose,1),1)];
                Xk = [Xk; omp(D,Yk,N)];

            elseif ii == 3

                Yk = [zeros(2*size(l_eye,1),1) ; mouth./norm(mouth) ; zeros(size(nose,1),1)];
                Xk = [Xk; omp(D,Yk,N)];

            else

                Yk = [zeros(2*length(r_eye) + size(mouth,1),1); nose./norm(nose)];
                Xk = [Xk; omp(D,Yk,N)];
            end
        end
     Xk = sum(Xk);
     Sparse = [Sparse;Xk];
    end
    
    
end