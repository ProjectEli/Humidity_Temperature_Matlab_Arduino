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

TMR = timer;
TMR.StartDelay = 2;
TMR.TimerFcn = {@HTSupdate,s};
TMR.Period = TMR.StartDelay;
TMR.StopFcn = @timerstop;
TMR.ExecutionMode = 'fixedRate';

%out = str2double(readline(s));
TMR.UserData.Temp =NaN;% out(1);
TMR.UserData.Humi =NaN;% out(2);
TMR.UserData.t = 0;

figure(1);
subplot(211);
plot(TMR.UserData.t,TMR.UserData.Temp);
xlabel('Time (s)');
ylabel('Temperature (℃)');

subplot(212);
plot(TMR.UserData.t,TMR.UserData.Humi);
xlabel('Time (s)');
ylabel('Relative humidity (%)');

linkdata on;

start(TMR);

function HTSupdate(mTimer, ~,mSerialport)
    tmp = str2num(readline(mSerialport));
    if isfinite(tmp)
        mTimer.UserData.t(end+1) = mTimer.UserData.t(end)+mTimer.StartDelay;
        mTimer.UserData.Temp(end+1) = tmp(1);
        mTimer.UserData.Humi(end+1) = tmp(2);
        FigureUpdate(mTimer);
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