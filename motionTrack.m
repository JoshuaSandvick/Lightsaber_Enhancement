function motionTrack(im1, im2)
num = 5;
[reduced1, reduced2] = deal(cell(1,num));
reduced1{1} = double((im1));
reduced2{1} = double((im2));
for i=2:num
    reduced1{i} = imageReduce(reduced1{i-1});
    reduced2{i} = imageReduce(reduced2{i-1});
end
for i=num:-1:1
    aggregateFlowColor(reduced1{i}, reduced2{i});
    % TODO: more processing to track specific points
end