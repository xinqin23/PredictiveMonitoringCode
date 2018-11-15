function [timeRecord, names] = expandFG(f,g)
% close all; 
% t = 0: 0.01:2;
% y = sin(2*pi*t);
% plot(t,y)

timeRecord = [];
names = [];
count = 1;
% for i = 0.1:0.1:0.5
%     for j = 0.1 : 0.1: 0.5
%        timeStep = i + j;
%        names = [names, "F" + num2str(i*10) + "G" + num2str(j*10)];
%        timeRecord(count) = timeStep;
%        count = count + 1;
%     end
% end
for i = 1:5
    for j = 1 : 5
       timeStep = i + j - 1;
       names = [names, "F" + num2str(i) + "G" + num2str(j)];
       timeRecord(count) = timeStep;
       count = count + 1;
    end
end

symbols = []
poly = " ( " + names(1);
len = length(names);
for index = 2:len
    poly = poly + " * " + names(index);
    if mod(index,5) ==0 
        if (index == len)
            poly = poly + " ) ";
        else
        poly = poly +  " ) " + " + " + " ( " + names(index +1);
        index = index + 1;
        end
    end
end

% syms ([s s1 s4])
% ps = ((s * s)+(s * s1 * s4))*s
% psq = expand(ps)
% 
% 
% a = "test"
% ab = sym(a)
% syms ([m b c])
% poly = " a1c + b + c * ( a + b + c )"
% p = poly
y = evalin(symengine, poly);
result = expand(y)

fileID = fopen('symExpandResult_FG.txt','w');
formatSpec = "%s"
nbytes = fprintf(fileID,formatSpec,result);
fclose(fileID);
end


