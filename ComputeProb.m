function Prob = ComputeProb(h,STLfunc,f,g)
addpath('uni_nonstationary','multi_nonstationary')


% h = 3; % number of prediction step
% STLfunc = "F"
% f = 3;g = 3;

[errorsCov,predictedSignal] = GetModelandErrorCov(h);
% errorsCov = eye(h);
% predictedSignal = zeros(1,h);
filename = "";
switch STLfunc
    case "FG"
        [times, names] = expandFG(f,g);
        filename = 'symExpandResult_FG.txt';
    case "XorFG"
        [times, names] = expandXorFG(f,g);
        filename = 'symExpandResult_XorFG.txt';
    case "GF"
        [times, names] = expandGF(f,g);
        filename = 'symExpandResult_GF.txt';
    case "XorF"
        [times, names] = expandXorF(f,g);
        filename = 'symExpandResult_XorF.txt';
    case "F"
        [times, names] = expandF(f,g);
        filename = 'symExpandResult_F.txt';
end

formatSpec = "%s";
fileID = fopen(filename,'r');
expr = fscanf(fileID,formatSpec);
fclose(fileID);
numItemOrEd= length(strfind(expr,'+')) + 1;

exprList = strsplit(expr,"+");



n =numItemOrEd;% n is total or 
Prob = 0;

varNumber = 1;

mu = zeros(1,h);
flag = -1;
for i = 1:n
    if (i > h)
        break
    end
    coefficient = combnk(1:min(n,h), i); % P(ai,aj,...,an) %changed n to h
    sign = (-1).^(i-1);
    margin = 0;
    [row, ~] = size(coefficient);
    for m = 1: row %number of row
       clow  = ones(varNumber,h)*(-Inf);
       cup = ones(varNumber,h)*Inf;
       co = coefficient(m,:);
       for mm = 1:i % the number chosen out
          exprGroup = char(exprList(co(mm)));
          exprAtom = strsplit(exprGroup,"*");
          for id = 1:length(exprAtom)
              proposition = exprAtom(id);
              if contains(proposition,"^")
                proposition = extractBefore(proposition,"^");  % intersected with it self. 
              end 
              idx = names==proposition;
              tdx = times(idx);
              tdxScaled = int64(tdx);
              if tdxScaled > h %can not delete
                if id == 1  % the first assignment is greater than h
                    flag = 1
                end
                break
              end
              clow(tdxScaled) = 50;
              cup(tdxScaled) = Inf;
          end
       end
       clow, cup
       if flag ~= 1
       [low, up] = CalIntervals(clow, cup,predictedSignal);
       guarantee = mvncdf(low,up,mu,errorsCov); %positive definate
       else
           guarantee = 0; %ignore the case when first assign is outside the prediction
       end
       flag = -1;
       margin = margin + guarantee;
    end
    Prob = Prob + sign*margin;
end
% predictedSignal;
% Prob
end