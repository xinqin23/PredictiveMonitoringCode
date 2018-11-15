function Prob = ComputeProb()

h =10; % number of prediction step
[errorsCov,predictedSignal] = GetModelandErrorCov(h)
[times, names] = expand();

formatSpec = "%s";
fileID = fopen('symExpandResult.txt','r');
expr = fscanf(fileID,formatSpec)
fclose(fileID);
numItemOrEd= length(strfind(expr,'+')) + 1

exprList = strsplit(expr,"+")



n =numItemOrEd;% n is total or 
Prob = 0;

varNumber = 1;

mu = zeros(1,h);

for i = 1:n
    if (i > h)
        break
    end
    coefficient = combnk(1:n, i) % P(ai,aj,...,an)
    sign = (-1).^(i-1)
    margin = 0;
    [row, ~] = size(coefficient)
    for m = 1: row %number of row
       clow  = ones(varNumber,h)*(-Inf);
       cup = ones(varNumber,h)*Inf;
       co = coefficient(m,:)
       indexArray = zeros(1,n);
       for mm = 1:i % the number chosen out
          exprGroup = char(exprList(co(mm)));
          exprAtom = strsplit(exprGroup,"*");
          for id = 1:length(exprAtom)
          idx = names==exprAtom(id);
          tdx = times(idx);
          tdxScaled = int64(tdx*10);
          if tdxScaled <= h %can not delete
          clow(tdxScaled) = -Inf;
          cup(tdxScaled) = 0;
          end
          end
          indexArray(co(mm)) = 1;
       end
       clow, cup
       [low, up] = CalIntervals(clow, cup,predictedSignal)
       guarantee = mvncdf(low,up,mu,errorsCov) %positive definate
       margin = margin + guarantee
    end
    Prob = Prob + sign*margin
end
predictedSignal
Prob
end