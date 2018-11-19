function data = decorrelate(data,stddev)
% Decorrelate the columns of the input matrix while maintaining original 
% mean and (optionally) standard deviation
if nargin<2 || isempty(stddev)
    stddev = false;
end
mu = mean(data);
if stddev
    sigma = std(data);
else
    sigma = 1;
end
data = (data-mu)./sigma;
data = whiten_data(data,'ZCA');
data = data.*sigma+mu;
end