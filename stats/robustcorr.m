function [r,p,df] = robustcorr(x,y)
% Calculate the robust correlation coefficient
% [r,p,df] = robustcorr(x);
% [r,p,df] = robustcorr(x,y);
%
% Note that this computes correlation between columns of X and 
% columns of Y, potentially resulting in asymmetric output
if nargin<2
    y = x;
end
x(~isfinite(x))=nan;
y(~isfinite(y))=nan;

if isequal(x(~isnan(x)),y(~isnan(y))) && isequal(isnan(x),isnan(y))
    symm=true;
else
    symm=false;
end

nx = size(x,2);
ny = size(y,2);

r = zeros(nx,ny);
df = zeros(nx,ny);

for i=1:nx
    for j=1:ny
        
        nanval = isnan(x(:,i)) | isnan(y(:,j));
        
        xdata = x(~nanval,i);
        ydata = y(~nanval,j);
        
        % Skip diagonal
        if all(xdata==ydata)
            r(i,j)=1;
            df(i,j)=sum(~nanval);
            continue;
        end
        
        % Take advantage of symmetry
        if symm && j<i
            r(i,j) = r(j,i);
            df(i,j) = df(j,i);
        end
        
        % Calculate robust r
        b1 = robustfit( xdata , ydata );
        b2 = robustfit( ydata , xdata );
        r(i,j) = sign(b1(end)+b2(end)) * sqrt(abs(b1(end)*b2(end)));
        df(i,j) = sum(~nanval)-2;

    end
end

% Calulate p-values
t = r .* sqrt(df./(1-r.^2));
p = 2*tcdf(-abs(t),df);

end
