function [y,outlags] = autocorr1(vector1,varargin)

%% check input variables
lags = 2*length(vector1) -1;
if nargin > 1
    if ischar(varargin{1})
        error('Unknown Input: %s',varargin{1});
    end
    lags = 2*abs(varargin{1}) +1;
    outlags = -abs(varargin{1}):abs(varargin{1});
end
if size(vector1,1) == 1 % vector-row
    n = 1;
    m = lags;
elseif size(vector1,2) == 1 % vector-column
    n = lags;
    m = 1;
    vector1 = vector1'; % size 1 x n
else
    error('Error. It"s not a vector.');
end
% P.?S. reshape(vector1, [1, length(vector1)]); % vector-row ...?
normCoeff = 1;
if nargin > 2
    if strcmp(varargin{2}, 'coeff')
        normCoeff = vector1*vector1';
    else
        error('Unknown Input: %s',varargin{2});
    end
end
%% Calculate the autocorrelation
nShift = ceil(lags/2);
vector1Shifted = vector1;
y = zeros(n,m);
y(nShift) = (vector1Shifted*vector1')/normCoeff; % central point
for iShift = nShift-1:-1:1 % N-1:step:1
    vector1Shifted(end) = 0;                          %shift 1 position down,
    vector1Shifted = circshift(vector1Shifted,[0,1]); %the last element (zero) is the first
    y(iShift) = (vector1Shifted*vector1')/normCoeff;
    y(end -iShift +1) = y(iShift);
end

