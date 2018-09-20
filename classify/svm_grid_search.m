function [curAcc,c,g,res] = svm_grid_search(y,X,N_density,K_folds,draw)
%% Perform a grid search for optimal C and G (libSVM)
% Usage: [acc,c,g,iter_accs] = svm_grid_search(y,X)
if nargin<5, draw = []; end
if nargin<4, K_folds = []; end
if nargin<3, N_density = []; end
if isempty(draw), draw = true; end
if isempty(K_folds), K_folds = 4; end
if isempty(N_density), N_density = 21; end

res = struct;

% Libsvm chooses bad thresholds for unbalanced datasets, so we have to do
% cross-validation manually
cv = cvpartition(length(y),'KFold',K_folds);

%% initial grid
max_iter = 10;
c_range = [-20 20];
g_range = [-20 20];
if length(N_density)==1, N_density(2)=N_density(1); end

iter = 0; prevAcc = -inf; curAcc = 0;
while iter<max_iter && (curAcc-prevAcc)>.005
    
    iter=iter+1;
    
    % Check if density is too low (via too small of change in the range)
    if iter>2
        
        delta_c = abs(min(res(iter-1).cs)-min(res(iter-2).cs)) + abs(max(res(iter-1).cs)-max(res(iter-2).cs));
        if delta_c<2, fprintf('Doubling C density.\n'); N_density(1) = N_density(1)*2; end

        delta_g = abs(min(res(iter-1).gs)-min(res(iter-2).gs)) + abs(max(res(iter-1).gs)-max(res(iter-2).gs));
        if delta_g<2,  fprintf('Doubling G density.\n'); N_density(2) = N_density(2)*2; end
        
    end

    [c_list,g_list] = generate_grids(c_range, g_range, N_density);

    fprintf('<strong>Working on grid %i (C: [%g, %g], G: [%g, %g])</strong>',iter,min(c_list),max(c_list),min(g_list),max(g_list));
    
    [acc,auc] = process_grid(y, X, c_list, g_list, cv);

    [c_range,g_range] = refresh_ranges(c_list, g_list, acc);
    
    if draw
        figure;
        imagesc(g_list,c_list,acc); ylabel('C'); xlabel('G'); title(sprintf('Iteration %i',iter));
        colorbar;
        hold on;
        plot([g_range(1) g_range(1)],[c_range(1) c_range(2)],'-r','linewidth',2);
        plot([g_range(2) g_range(2)],[c_range(1) c_range(2)],'-r','linewidth',2);
        plot([g_range(1) g_range(2)],[c_range(1) c_range(1)],'-r','linewidth',2);
        plot([g_range(1) g_range(2)],[c_range(2) c_range(2)],'-r','linewidth',2);
        hold off;
        drawnow;
    end

    prevAcc = curAcc;
    curAcc = max(acc(:));
    
    res(iter).acc = acc;
    res(iter).auc = auc;
    res(iter).cs = c_list;
    res(iter).gs = g_list;
    res(iter).best = curAcc;
    
    fprintf('<strong>completed. Accuracy = %4.4f (%+4.4g)</strong>\n',curAcc,curAcc-prevAcc);
    
    if N_density==1
        break;
    end
        
end

if curAcc<prevAcc
    bestind = iter - 1;
    curAcc = prevAcc;
else
    bestind = iter;
end

[I,J] = find(res(bestind).acc==max(res(bestind).acc(:)));
    
c = 2 .^ nanmean(res(bestind).cs(I));
g = 2 .^ nanmean(res(bestind).gs(J));

fprintf('<strong>Grid search complete. %i iterations. C = %g, G=%g, accuracy=%4.4f</strong>\n',iter,c,g,curAcc);

end

function [c_range,g_range] = refresh_ranges(c_list,g_list,acc)

distfrommax = (acc-max(acc(:)))./std(acc(:));
[I,J] = find(distfrommax>-.25);

c_unit = min(diff(c_list));
g_unit = min(diff(g_list));

c_range = [c_list(min(I))-2*c_unit , c_list(max(I))+2*c_unit];
g_range = [g_list(min(J))-2*g_unit , g_list(max(J))+2*g_unit];

end

function [c_list,g_list] = generate_grids(c_lim,g_lim,N)
if N==1
    nfeat = evalin('caller','size(X,2)');
    c_list = log2(1);
    g_list = log2(1/nfeat);
else
    c_list = linspace(c_lim(1),c_lim(2),N(1));
    g_list = linspace(g_lim(1),g_lim(2),N(2));
end
end

function [accmean,aucmean] = process_grid(y,X,c_list,g_list,cv)

accmean = nan(length(c_list),length(g_list));
aucmean = nan(length(c_list),length(g_list));

K = cv.NumTestSets;

% Apply a penalty to the more common label
[wpos,wneg] = rat(sum(y==1)/sum(y==-1));

for cidx = 1:length(c_list)
    c = 2 .^ c_list(cidx);
    
    fprintf('.');
    
    for gidx = 1:length(g_list)
        g = 2 .^ g_list(gidx);

        cmd = sprintf('-s 0 -t 2 -b 1 -c %.12g -g %.12g -q -w1 %i -w-1 %i',c,g,wpos,wneg);
        
        tmp_acc = nan(K,1);
        tmp_auc = nan(K,1);
        
        parfor kidx = 1:K
            
            train_inds = cv.training(kidx);
            test_inds = cv.test(kidx);
            model = svmtrain( y(train_inds) , X(train_inds,:) , cmd ); %#ok<*SVMTRAIN>
            [~,~,prob] = svmpredict( y(test_inds) , X(test_inds,:) , model  , '-q -b 1' );
            [fpr,tpr,~,tmp_auc(kidx)] = perfcurve( y(test_inds), prob(:,1), 1 );
            
            % Peak balanced accuracy (mean of TPR and TNR)
            tmp_acc(kidx) = 100 * max( (tpr+(1-fpr)) / 2 );
            
        end

        accmean(cidx,gidx) = nanmean(tmp_acc);
        aucmean(cidx,gidx) = nanmean(tmp_auc);
        
    end

end

end
