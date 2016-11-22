function reduced = imageReduce(im)
a = .4;
rowMask = [.25-.5*a .25 a .25 .25-.5*a];
colMask = [.25-.5*a; .25; a; .25; .25-.5*a];

gaussIm = imfilter(im, rowMask,'replicate');
gaussIm = imfilter(gaussIm, colMask, 'replicate');
reduced = double(gaussIm(1:2:end, 1:2:end, :));
end

