function BG = ReadUserData()
name = './GenedData/BGTrace.txt';
BG = textread(name,' %f ')
T = length(BG)

t = 1:15:T*15;
plot(t,BG);
% formatSpec = "%f,%f";
% fileID = fopen('./GenedData/BGDiabeteTrace.txt','r');
% expr = fscanf(fileID,formatSpec)
% fclose(fileID);

end