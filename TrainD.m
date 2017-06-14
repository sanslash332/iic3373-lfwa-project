%% Creación de Diccionario 
% Solo se crea con las del testing.

load('cropped_parts');
load('Indices.mat');
partes_training = cropped_parts(indice_training(1:4174));

D = [];

for k=1:length(partes_training)
    
    if isempty(partes_training{k})
        Dk = ones(2*length(l_eye) + size(mouth,1) + size(nose,1),4);
        D = [D Dk];
        
    else
        l_eye = im2double(partes_training{k}.l_eye(:));
        r_eye = im2double(partes_training{k}.r_eye(:));
        mouth = im2double(partes_training{k}.mouth(:));
        nose = im2double(partes_training{k}.nose(:));

        Dk = ones(2*length(l_eye) + size(mouth,1) + size(nose,1),4);

        for ii=1:4

            if ii == 1

                Dk(:,1) = [l_eye./norm(l_eye) ;zeros(length(r_eye) + size(mouth,1) + size(nose,1),1)];

            elseif ii== 2

                Dk(:,2) = [zeros(size(l_eye,1),1) ; r_eye./norm(r_eye) ; zeros(size(mouth,1) + size(nose,1),1)];

            elseif ii == 3

                Dk(:,3) = [zeros(2*size(l_eye,1),1) ; mouth./norm(mouth) ; zeros(size(nose,1),1)];

            else

                Dk(:,4) = [zeros(2*length(r_eye) + size(mouth,1),1); nose];
            end
        end
 
       D = [D Dk];
      
    end
end

