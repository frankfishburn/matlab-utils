function scores = fscore( labels , vectors )
if isequal( unique(labels) , [-1; 1] )
    labels = logical(labels./2 + .5 );
end
if ~isequal( unique(labels) , logical([0; 1]) )
    if ~isequal( unique(labels) , [0; 1] )
        error('Labels should be a binary vector');
    else
        labels = logical(labels);
    end
end

num_features = size(vectors,2);
num_instances = size(vectors,1);

if length(labels)~=num_instances
    error('Number of labels does not match number of instances');
end

mean_all = mean(vectors);
mean_pos = mean(vectors(labels,:));
mean_neg = mean(vectors(~labels,:));

var_pos = var(vectors(labels,:),0);
var_neg = var(vectors(~labels,:),0);

scores = ( (mean_pos-mean_all).^2 + (mean_neg-mean_all).^2 ) ./ (var_pos + var_neg);

end
