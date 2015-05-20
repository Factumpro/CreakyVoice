function output = medfilt1D(vector,window)

%% Window size
if nargin < 2
    window = [];
end
if isempty(window) % The default window size is three
    window = 3;
end
if rem(window, 2) == 1 % step for odd sized windows
    step = (window -1)/2;
else % step for paired window size
    step = window/2;
end
%% Search median
output = zeros(size(vector)); % original vector size
vectorLength = length(vector);
vector = reshape(vector, [1,vectorLength]); % reshape to vector-row for operations on vector
zerosEdges = zeros(1,step);                 % fill with zeros on the edges
sortvector = [zerosEdges vector zerosEdges];
for index = 1:vectorLength
    toIndex = index + window -1;
    output(index) = median( sortvector(index:toIndex) );
end