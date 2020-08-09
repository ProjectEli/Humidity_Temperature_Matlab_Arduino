% ref1: https://github.com/adafruit/DHT-sensor-library/blob/master/examples/DHTtester/DHTtester.ino
% ref2: https://circuitdigest.com/microcontroller-projects/matlab-data-logging-analysis-and-visualization-plotting-dht11-sensor-readings-on-matlab
% ref3: https://kr.mathworks.com/help/matlab/creating_plots/making-graphs-responsive-with-data-linking.html

%% Arduino temperature and humidity realtime plot
% Author: Jaehyeok Park (Eli)
% Date: 2020/06/20

%% 
close all; clear; clc;

%% 
s = serial('COM7');
timeout = 10;


fopen(s);
out = str2num(fscanf(s));
Temp(1) = out(1);
Humi(1) = out(2);
t=0;

figure(1);
subplot(211);
plot(t,Temp);
xlabel('Time (s)');
ylabel('Temperature (Celcius degree)');

subplot(212);
plot(t,Humi);
xlabel('Time (s)');
ylabel('Relative humidity (%)');

linkdata on;

for k = 2:timeout

    tmp = str2num(fscanf(s));
    t(k) = (k-1)*2;
    
    Temp(k) = tmp(1);
    Humi(k) = tmp(2);
    refreshdata;
    drawnow;

end

fclose(s);