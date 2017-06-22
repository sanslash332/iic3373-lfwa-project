function [accuracy_classes] = Eval_class(Yreal,Ypredict)

        M = confusionmat(Yreal,Ypredict);
        D = diag(M);
        k=1:143;
        Classes_quantity = sum(Yreal == k);
        accuracy_classes = (D'./Classes_quantity).*100;
             
end
    
        