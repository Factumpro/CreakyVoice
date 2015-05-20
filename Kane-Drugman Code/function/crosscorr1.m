function [y,rangeLags] = crosscorr1(vector1,vector2,varargin)

%% check input variables
narginchk(2,4);
% This function doesn't work with matrix
if ~isvector(vector1) || ~isvector(vector2)
    error('Error. vector1 or vector2 is matrix.');
end
% Set defaults
const_vect1Length = length(vector1);
const_vect2Length = length(vector2);
maxLength = max(const_vect1Length, const_vect2Length);
lags = 2*maxLength -1;
rangeLags = -maxLength:maxLength;
normalCoeff = 1;
% if the lags or 'coeff' specified
switch nargin,
    case 3, % lags or 'coeff'
        if ischar(varargin{1}) && strcmp(varargin{1}, 'coeff')
            sum_sqrV1 = sum(vector1.^2);
            sum_sqrV2 = sum(vector2.^2);
            normalCoeff = sqrt( sum_sqrV1*sum_sqrV2 );
        elseif isnumeric(varargin{1})
            lags = abs(varargin{1});
            lags = 2*lags +1;
            rangeLags = -lags:lags;
        else % error input variable argument
            error('Unknown Input variable: %s',varargin{1});
        end
    case 4, % lags and 'coeff'
        if isnumeric(varargin{1})
            lags = abs(varargin{1});
            lags = 2*lags +1;
            rangeLags = -lags:lags;
        else % error input variable argument
            error('Unknown Input variable: %s',varargin{1});
        end
        if ischar(varargin{2}) && strcmp(varargin{2}, 'coeff')
            sum_sqrV1 = sum(abs(vector1).^2);
            sum_sqrV2 = sum(abs(vector2).^2);
            normalCoeff = sqrt( sum_sqrV1*sum_sqrV2 );
        else % error input variable argument
            error('Unknown Input variable: %s%d',varargin{2} ,varargin{2});
        end
    otherwise,
        % defaults
end
%% reshape vectors
if isrow(vector1)
    y = zeros(1,lags);
else %iscolumn(vector1)
    y = zeros(lags,1);
    vector1 = reshape(vector1, [1, const_vect1Length]); % reshape to row
end
vector2 = reshape(vector2, [1, const_vect2Length]); % reshape to row
% length vector1 is bigger,
% need to align the length vector2, fill with zeros on the edge
if const_vect1Length > const_vect2Length
    zerosEdge = zeros(1, (const_vect1Length -const_vect2Length));
    vector2 = [vector2 zerosEdge];
else % similarly only for length vector1
    zerosEdge = zeros(1, (const_vect2Length -const_vect1Length));
    vector1 = [vector1 zerosEdge];
end
%% Calculate the autocorrelation
nShift = ceil(lags/2);
vect1Shifted_Left  = vector1;
vect1Shifted_Right = vector1;
y(nShift) = vector1*vector2'; % central point
for iShift = nShift-1:-1:1 % N-1:step:1
    vect1Shifted_Left(end)  = 0;
    vect1Shifted_Left  = circshift(vect1Shifted_Left, [0, 1]); % left-shift
    vect1Shifted_Right = circshift(vect1Shifted_Right,[0,-1]); % right-shift
    vect1Shifted_Right(end) = 0;
    y(iShift) = vect1Shifted_Left*vector2';
    y(end -iShift +1) = vect1Shifted_Right*vector2';
end
% normalization
y = y/normalCoeff;
