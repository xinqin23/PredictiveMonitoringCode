function [low, up] = CalIntervals(clow, chigh,predictions)

low = predictions - chigh;
up = predictions - clow;


end