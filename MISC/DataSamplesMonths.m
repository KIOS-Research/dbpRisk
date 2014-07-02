clear all; close all;

t=[89.53, 101.13, 84.54, 53.89, 72.69, 96.47, 42.09 ...
37.59, 90.32, 98.09, 76.49, 74.03, 62.84, 60.96 ...
49.21, 32.30, 70.45, 52.58, 12.20, 48.41, 80.31, 88.50, 60.01];
h=figure;
subplot(3,1,1,'Parent',h)
hist(t);
s=sprintf('THMs July, High, mean=%f ug/L',mean(t));
title(s);

% August
tt=[78.18, 62.62, 34.58, 55.23, 54.23, 66.16, 59.09, 77.18, 69.79 ...
60.29, 73.75, 101.11, 107.67, 54.57, 64.64, 81.69, 96.68 ...
54.57, 78.41, 83.48, 93.71, 104.14, 97.82, 58.03, 124.25];
figure(h)
subplot(3,1,2,'Parent',h)
hist(tt);
s=sprintf('THMs August, High, mean=%f ug/L',mean(tt));
title(s);

% September

ttt=[67.38, 100.05, 101.74, 84.67, 56.73, 79.80, 77.72, 97.82, 101.67 ...
100.23, 82.54, 59.91, 80.38, 83.56, 76.41, 63.56, 86.06, 92.68 ...
76.62, 109.26, 78.52, 61.98, 84.00, 104.40, 115.59, 61.21];
figure(h)
subplot(3,1,3,'Parent',h)
hist(ttt);
s=sprintf('THMs September, High, mean=%f ug/L',mean(ttt));
title(s);

%%
h7=figure;
t1=[t tt ttt];
hist(t1);
s=sprintf('THMs All, High, mean=%f ug/L',mean(t1));
title(s);


%% 
t=[52.62, 22.60, 86.30, 42.22, 53.67, 42.05, 23.83, 42.41, 42.08, 70.30 ...
57.08, 52.98, 63.46, 47.12, 55.93, 56.47, 49.17, 58.77, 23.89 ...
38.83, 8.66, 108.89, 85.87, 22.19, 36.76, 28.02, 37.48, 46.96, 55.03];
h2=figure;
subplot(3,1,1,'Parent',h2)
hist(t);
s=sprintf('THMs July, Low, mean=%f ug/L',mean(t));
title(s);

% September

ttt=[69.72, 70.00, 80.22, 67.16, 67.52, 27.19, 21.54, 61.06, 57.96, 38.63...
60.84, 72.36, 79.27, 53.03, 98.06, 69.09, 41.48, 51.45, 59.29, 79.59...
23.19, 58.15, 65.60, 70.43, 59.85, 48.50, 104.34, 8.18, 62.94...
66.10, 65.67, 78.39, 98.33, 60.82, 57.91, 77.98, 79.22, 52.83, 67.23...
102.51, 51.45, 61.77, 52.82, 49.56, 59.54, 8.75];
subplot(3,1,3,'Parent',h2)
hist(ttt);
s=sprintf('THMs September, Low, mean=%f ug/L',mean(ttt));
title(s);

%%
h6=figure;
t2=[t tt ttt];
hist(t2);
s=sprintf('THMs All, Low, mean=%f ug/L',mean(t2));
title(s);

%% Chlorine
c=[0.51, 0.58, 0.49, 0.26, 0.52, 0.46, 0.17, 0.51, 0.30, 0.25...
0.10, 0.52, 0.51, 0.37, 0.48, 0.33, 0.27, 0.15, 0.23...
0.38, 0.25, 0.58, 0.25];
hh=figure;
subplot(3,1,1,'Parent',hh)
hist(c);
s=sprintf('Chlorine July, High, mean=%f mg/L',mean(c));
title(s);

cc=[0.25, 0.23, 0.29, 0.23, 0.08, 0.18, 0.41, 0.40, 0.33, 0.13...
0.30, 0.32, 0.46, 0.32, 0.24, 0.36, 0.09, 0.27, 0.21, 0.06...
0.59, 0.30, 0.36, 0.37, 0.19];
subplot(3,1,2,'Parent',hh)
hist(cc);
s=sprintf('Chlorine August, High, mean=%f mg/L',mean(cc));
title(s);

ccc=[0.35, 0.22, 0.31, 0.29, 0.37, 0.41, 0.38, 0.32...
0.28, 0.39, 0.16, 0.45, 0.38, 0.37, 0.41, 0.13, 0.39...
0.24, 0.34, 0.35, 0.29, 0.38, 0.19, 0.45, 0.35, 0.06, 0.06];
subplot(3,1,3,'Parent',hh)
hist(ccc);
s=sprintf('Chlorine September, High, mean=%f mg/L',mean(ccc));
title(s);

%%
h5=figure;
c2=[c cc ccc];
hist(c2);
s=sprintf('Chlorine All, High, mean=%f mg/L',mean(c2));
title(s);

%% 
c=[0.08, 0.03, 0.17, 0.30, 0.38, 0.44, 0.04, 0.25, 0.02...
0.43, 0.06, 0.41, 0.08, 0.24, 0.29, 0.24, 0.27, 0.06, 0.53...
0.07, 0.02, 0.27, 0.56, 0.09, 0.33, 0.40, 0.21, 0.41, 0.46];

h3=figure;
subplot(3,1,1,'Parent',h3)
hist(c);
s=sprintf('Chlorine July, Low, mean=%f mg/L',mean(c));
title(s);

cc=[0.33, 0.41, 0.33, 0.28, 0.32, 0.02, 0.06, 0.30, 0.27...
0.41, 0.18, 0.48, 0.36, 0.38, 0.55, 0.22, 0.44, 0.43, 0.31...
0.38, 0.10, 0.39, 0.28, 0.33, 0.51, 0.38, 0.49, 0.09, 0.23...
0.14, 0.16, 0.68, 0.46, 0.38, 0.15, 0.56, 0.53, 0.29, 0.25...
0.26, 0.24, 0.33, 0.24, 0.25, 0.25, 0.05];
subplot(3,1,3,'Parent',h3)
hist(cc);
s=sprintf('Chlorine September, Low, mean=%f mg/L',mean(cc));
title(s);

%%
h4=figure;
c1=[c cc];
hist(c1);
s=sprintf('Chlorine All, Low, mean=%f mg/L',mean(c1));
title(s);


