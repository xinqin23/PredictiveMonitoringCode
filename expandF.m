function [timeRecord, names] = expandF(g,f)
% t = 0: 0.01:2;
% y = sin(2*pi*t);
% plot(t,y)

timeRecord = [];
names = [];
count = 1;


for j = 1 : 5
   timeStep = j; % 1 means self
   names = [names, "F" + num2str(j)];
   timeRecord(count) = timeStep;
   count = count + 1;
end

symbols = []
poly = " ( " + names(1);
len = length(names);
for index = 2:len
    poly = poly + " + " + names(index);
    if mod(index,5) ==0 
        if (index == len)
            poly = poly + " ) ";
        else
        poly = poly +  " ) " + " + " + " ( " + names(index +1);
        index = index + 1;
        end
    end
end

% names = [names, "Xt"]; % at x itself
% timeRecord(count) = 1;
% 
% poly = poly + " + " + " Xt "

y = evalin(symengine, poly);

result = expand(y)

fileID = fopen('symExpandResult_F.txt','w');
formatSpec = "%s";
nbytes = fprintf(fileID,formatSpec,result);
fclose(fileID);
end


