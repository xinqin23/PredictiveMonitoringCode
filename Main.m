function Main()

h = 5;
f = 3;
g = 3;
STLS = ["FG", "GF", "XorFG", "XorF", "F"];
P = []

for i = 1:5
STL = STLS(i);
P(i) = ComputeProb(h,STL,f,g);
end

P

end