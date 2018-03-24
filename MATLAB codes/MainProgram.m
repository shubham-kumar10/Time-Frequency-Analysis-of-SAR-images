%% Digital Signal Processing Project                                       
% * Authors: Shubham Kumar 1510110384,Sarthak Sharma 1510110342,Yatin
% Malhotra 1510110466
%% I.Reading the .gff Imagefile.
% After runnig the code select "TestImage.gff" from the folder
[Image,im_qp]=LoadImage(); % Function provied by Sandia.gov for reading it's gff file.
%% II.Contruction of Windows.
% No Sub band-N_k=3
% No Sub angles-N_t=3
n_k=3; 
n_t=3;
kmin=0;%Minimum frequency
kmax=2500;%Maximium frequency
thtamin=20;% minimum angle of illumination
thtamax=1600; % maximum angle of illumination                                                   
k=kmax-kmin;                        % Contruction of Domian Delta.
tta=thtamax-thtamin;                % to contruct delta matrix.
H=myfft2(Image,1638,2510);          % Calculation of 2D FFT of Image.
figure;imagesc(abs(H));             % Plotting the 2D FFT obtained.
phi=zeros(1638,2510);               % Definition & constuction of phi(n_k,n_t)-moving window on H
for l=1:n_k
   for m = 1:n_t
       phi=zeros(1638,2510);
        for y=1:2510
            for x=1:1638
                    if(x>=(kmin+((l-1)*k*(1/n_k)))&& x<=(kmin+(l*k*(1/n_k))))
                        if(y>=(thtamin+((m-1)*tta*(1/n_t))) && y<=(thtamin+m*tta*(1/n_t)))
                            phi(x,y)=1;
                        end
                    end
            end
        end
        figure;% Formation of Window of size(l,m).
        Y = abs(phi.*H);
        imagesc(Y); 
        title('phi');
        
        figure;% Inverse of Windowed FFT of signal.
        imagesc(abs(myifft2(phi.*H,1638,2510)));
        title('W(l,m)');
        %This gives us the points on the groud corresponding to that
        %frequencies in the SAR Image file.
    end
end
%{
*   USER DERINFED FUNCTION FOR TAKING 2D FFT
*   myfft2(Input,size1,size2)
        function [IN] = myfft2(inputData,N1-point,N2-point)
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
        D_H0 = conj(D50.');
        D_H1 = conj(D51.');
        IN = (D_H0*(inputData)*D_H1);
        end
   USER DERINFED FUNCTION FOR TAKING 2D iFFT 
* myifft2(Input,N1-point,N2-point)
        function [IN] = myifft2(inputData,N1,N2)
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
        IN = ((1/N1)*D50*(inputData))*D51*(1/N2);
        end
%}
       
