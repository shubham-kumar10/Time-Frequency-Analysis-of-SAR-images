function [IF] = myifft2(inputData,N1,N2)
D50=[zeros];D51=[zeros];
for k=1:N1
    for n=1:N1
        D50(n,k)=exp(((2*pi*1j)/N1)*(k-1)*(n-1));
    end
end
for k=1:N2
    for n=1:N2
        D51(n,k)=exp(((2*pi*1j)/N2)*(k-1)*(n-1));
    end
end
IF = ((1/N1)*D50*(inputData))*D51*(1/N2);
end