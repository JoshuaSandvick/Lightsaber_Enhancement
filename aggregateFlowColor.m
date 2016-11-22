function [u,v] = aggregateFlowColor(image1, image2)
windowSz = 5;
center = floor(windowSz/2);

% x and y derivatives
Fx = -fspecial('sobel')'./8;
Fy = -fspecial('sobel')./8;

[fxIm, fyIm] = deal(zeros(size(image2)));
% derivative per color channel
for i=1:3
    fxIm(:,:,i) = imfilter(image2(:,:,i),Fx);
    fyIm(:,:,i) = imfilter(image2(:,:,i),Fy);
end

% precompute covariance calculation
fxIm2 = fxIm.^2;
fyIm2 = fyIm.^2;
fxfyIm = fxIm.*fyIm;

% t derivative
ft = image2-image1;
[u, v]=deal(zeros(size(image1,1),size(image1,2)));

% flow
for r=(1+center):(size(image1,1)-center)
    for c=(1+center):(size(image1,2)-center)
        A=zeros(6,2);
        B=zeros(6,1);
        % each color channel
        for i=1:3
            A((2*i)-1,1) = sum(sum(fxIm2(r-center:r+center,c-center:c+center,i)));
            [A((2*i)-1,2), A(2*i,1)] = deal(sum(sum(...
                fxfyIm(r-center:r+center,c-center:c+center,i))));
            A(2*i,2) = sum(sum(fyIm2(r-center:r+center,c-center:c+center,i)));
            B((2*i)-1,1) = sum(sum(fxIm(r-center:r+center,c-center:c+center,i).*...
                ft(r-center:r+center,c-center:c+center,i)));
            B(2*i,1) = sum(sum(fyIm(r-center:r+center,c-center:c+center).*...
                ft(r-center:r+center,c-center:c+center,i)));
            
        end
        % pseudo inverse
        result=pinv(A)*(-B);
        u(r,c)=result(1,1);
        v(r,c)=result(2,1);
    end
end
% plot optical flow vectors as arrows
quiver(u, v);
end