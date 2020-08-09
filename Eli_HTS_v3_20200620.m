% ref1: https://github.com/adafruit/DHT-sensor-library/blob/master/examples/DHTtester/DHTtester.ino
% ref2: https://circuitdigest.com/microcontroller-projects/matlab-data-logging-analysis-and-visualization-plotting-dht11-sensor-readings-on-matlab
% ref3: https://kr.mathworks.com/help/matlab/creating_plots/making-graphs-responsive-with-data-linking.html
% ref4: https://kr.mathworks.com/help/matlab/matlab_prog/timer-callback-functions.html

%% Arduino temperature and humidity realtime plot
% Author: Jaehyeok Park (Eli)
% Date: 2020/06/20

%% 
close all; clear; clc;

%% 
s = serialport('COM7',9600);
% s.Timeout = 1;
configureTerminator(s,"CR");
%timeout = 10;

%out = str2double(readline(s));
Temp =NaN;% out(1);
Humi =NaN;% out(2);
t = 0;

TMR = timer;
TMR.StartDelay = 2;
TMR.TimerFcn = {@HTSupdate,s,t,Temp,Humi};
TMR.Period = TMR.StartDelay;
TMR.StopFcn = @timerstop;
TMR.ExecutionMode = 'fixedRate';

figure(1);
subplot(211);
plot(t,Temp);
xlabel('Time (s)');
ylabel('Temperature (℃)');

subplot(212);
plot(t,Humi);
xlabel('Time (s)');
ylabel('Relative humidity (%)');

linkdata on;

start(TMR);

function HTSupdate(mTimer, ~,mSerialport,t,Temp,Humi)
    tmp = str2num(readline(mSerialport));
    if isfinite(tmp)
        t(end+1) = t(end)+mTimer.Period;
        Temp(end+1) = tmp(1);
        Humi(end+1) = tmp(2);
        refreshdata;
        drawnow;
%         FigureUpdate(mTimer);
        disp('Data read succeed');
    else
        disp('Data is NaN');
    end
end

function timerstop(mTimer, ~)
    disp('Timer stopped');
    delete(mTimer);
    %fclose(s);
end

function FigureUpdate(TMR)
%     figure(1);
%     subplot(211);
%     plot(TMR.UserData.t,TMR.UserData.Temp);
%     xlabel('Time (s)');
%     ylabel('Temperature (℃)');
% 
%     subplot(212);
%     plot(TMR.UserData.t,TMR.UserData.Humi);
%     xlabel('Time (s)');
%     ylabel('Relative humidity (%)');
    drawnow;
end