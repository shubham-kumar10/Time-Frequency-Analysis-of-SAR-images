function [IN] = mydft(inputData)
for k=1:64
    for n=1:64
        D50(n,k)=exp(((2*pi*j)/64)*(k-1)*(n-1));
    end
end
D_H50 = conj(D50.');
IN = (D_H50*(inputData));
end