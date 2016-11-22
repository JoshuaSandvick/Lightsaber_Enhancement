function [u,v] = aggregateFlow(image1, image2)
windowSz = 5;
center = floor(windowSz/2);
% x and y derivatives
Fx = -fspecial('sobel')'./8;
fxIm = imfilter(image2,Fx);
Fy = -fspecial('sobel')./8;
fyIm = imfilter(image2,Fy);

fxIm2 = fxIm.^2;
fyIm2 = fyIm.^2;
fxfyIm = fxIm.*fyIm;

% t derivative
ft = image2-image1;
[u, v]=deal(zeros(size(image1))); 
% flow
for r=(1+center):(size(image1,1)-center)
    disp(r);
    for c=(1+center):(size(image1,2)-center)
        A=zeros(2,2);
        B=zeros(2,1);
        A(1,1) = sum(sum(fxIm2(r-center:r+center,c-center:c+center)));
        [A(1,2), A(2,1)] = deal(sum(sum(fxfyIm(r-center:r+center,c-center:c+center))));
        A(2,2) = sum(sum(fyIm2(r-center:r+center,c-center:c+center)));
        B(1,1) = sum(sum(fxIm(r-center:r+center,c-center:c+center).*...
            ft(r-center:r+center,c-center:c+center)));
        B(2,1) = sum(sum(fyIm(r-center:r+center,c-center:c+center).*...
            ft(r-center:r+center,c-center:c+center)));
        %Pseudo inverse
        result=pinv(A)*(-B);
        u(r,c)=result(1,1);
        v(r,c)=result(2,1);
    end
end
figure(2);
quiver(u, v); %plot optical flow vectors as arrows
end