function feature_inds = select_features(y,X,proportion)
% Keep features that account for a specfied percentage of total F-score
% features_inds = select_features( labels , data , proportion );
%
% labels        - [ observation x 1 ] vector
% data          - [ observation x feature ] matrix
% feature_inds  - array of surviving feature indices
if nargin<3
    proportion = .95;
end
if iscell(y)
    y = strcmp(y,y{1});
end
F = fscore( y , X );
F(isnan(F))=0;
Fsorted = sort(F,'descend');
percent_fscore = cumsum(Fsorted) ./ sum(F);
min_F = Fsorted(find(percent_fscore>=proportion,1,'first'));
feature_inds = find(F>=min_F);
end
