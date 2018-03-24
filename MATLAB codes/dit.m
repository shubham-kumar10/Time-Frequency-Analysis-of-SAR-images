function y = dit(x)                                          
p=nextpow2(length(x));                                                      
x=[x zeros(1,(2^p)-length(x))];                                             
N=length(x);                                                                
S=log2(N);                                                                  
Half=1;                                                                     
x=bitrevorder(x);                                                          
for stage=1:S;                                                              
    for index=0:(2^stage):(N-1);                                            
        for n=0:(Half-1);                                                   
            pos=n+index+1;                                                  
            pow=(2^(S-stage))*n;                                            
            w=exp((-1i)*(2*pi)*pow/N);                                      
            a=x(pos)+x(pos+Half).*w;                                        
            b=x(pos)-x(pos+Half).*w;                                        
            x(pos)=a;                                                       
            x(pos+Half)=b;                                                  
        end;
    end;
Half=2*Half;                                                                
end;
y=x;                                                                        
end