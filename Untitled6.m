%%
num =[];
contador=0;
L = L_test;
for k=1:length(L)-1
    aux = L(k);
    
    if aux == L(k+1)
        contador= contador +1;
    else
        contador = contador +1;
        num(end+1) = contador;
        contador=0;
    end
end

%%



