function [Ypredict, Accuracy] = Predict_sparse(Ysparse,D,Sparse,Label)

    for k=1:size(Ysparse,2)
        
        fprintf('Clasificando %d/%d \n',k,size(Ysparse,2));
        Y_ideal = Ysparse(:,k);
        Error_k = [];
        Sparse_k = Sparse(:,k);
        
        for ii=1:143
            
            aux = size(D,2)/143;
            Dii = D(:,(aux*(ii-1) + 1: aux*ii));
            Sparseii = Sparse_k((aux*(ii-1) + 1: aux*ii));
            Error_k(ii) = sum((Y_ideal - Dii*Sparseii));
            
        end
        
        Ypredict(k) = find(Error_k == min(Error_k));
    end
    
    Accuracy = sum(Ypredict == Label)/length(Ypredict);
        
        
end