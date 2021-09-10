clc; clear; close all;

%% Loading data
filename = 'data/clean_csv/1.csv'; % Change file name
var = dlmread(filename,',',[1 0 25*60*60 0]);

%% Local Binary Pattern
pt = 750-1; % 30sec
data_raw = var(1:pt);
data_LBF = zeros(size(data_raw));
P = 8;
bin = zeros(P,1);


for i=1:pt
   bin = zeros(P,1);
   dec = 0;
   mid = data_raw(i);

   if (i<=P/2 || i>= (pt-P/2) )
      % data_LBF(i) = 0;
   else
       % Thresholding
       for j = 1:P/2
          bin(j) = data_raw(j) > mid;
          bin(j+P/2) = data_raw(j+P/2) > mid;
       end
       
       % Binary to Decimal
       for j = 0:7
            dec = dec + pow2(7-j)*bin(j+1);
       end
   end   
   
   % Final Range: 0-255
   data_LBF(i) = dec;
end

figure
subplot(1,2,1);
plot(data_raw);
xlabel('Sample Number'); title('A segment of NPress');
subplot(1,2,2);
plot(data_LBF);
xlabel('Sample Number'); title('LBF applied signal');
