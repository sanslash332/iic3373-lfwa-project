function [Y,Sparse,Labels] = sparse_test(Partes,D)

    Y = [];
    Labels = zeros(length(Partes));
    Sparse = [];

    param.L          = 50;           % not more than L non-zeros coefficients
    param.eps        = 0;           % optional, threshold on the squared l2-norm of the residual, 0 by default
    param.numThreads = -1;          % number of processors/cores to use; the default choice is -1 (it selects all the available CPUs/cores)

    for k=1:length(Partes)


        Yk = [];
        Xk = [];

        if isempty(Partes{k})
            fprintf("Is empety, next \n");

        else
            fprintf("Processing %d/%d : %s\n", k, length(Partes), char(Partes{k}.filename));

            l_eye = im2double(Partes{k}.l_eye(:));
            r_eye = im2double(Partes{k}.r_eye(:));
            mouth = im2double(Partes{k}.mouth(:));
            nose = im2double(Partes{k}.nose(:));

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

    Labels = Logical(Labels);

end


