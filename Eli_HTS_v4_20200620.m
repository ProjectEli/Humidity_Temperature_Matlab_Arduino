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

Temp =NaN;% out(1);
Humi =NaN;% out(2);
t = 0;

TMR = timer;
TMR.StartDelay = 2;
TMR.StartFcn = @timerstart;
TMR.TimerFcn = {@HTSupdate,s};
TMR.Period = TMR.StartDelay;
TMR.StopFcn = @timerstop;
TMR.ExecutionMode = 'fixedRate';

%out = str2double(readline(s));
TMR.UserData.Temp =Temp;% out(1);
TMR.UserData.Humi =Humi;% out(2);
TMR.UserData.t = t;

figure(1);
subplot(211);
plot(t,Temp,'-o','XDataSource','t','YDataSource','Temp'); % https://kr.mathworks.com/matlabcentral/answers/296304-linkdata-to-structured-data
xlabel('Time (s)');
ylabel('Temperature (℃)');

subplot(212);
plot(t,Humi,'-o','XDataSource','t','YDataSource','Humi');
xlabel('Time (s)');
ylabel('Relative humidity (%)');

linkdata on;

start(TMR);

function timerstart(mTimer,~)
    mTimer.UserData.StartTime = datetime('now');
    disp(mTimer.UserData.StartTime);
end

function HTSupdate(mTimer, ~,mSerialport)
    tmp = str2num(readline(mSerialport));
    if isfinite(tmp)
        mTimer.UserData.t(end+1) = mTimer.UserData.t(end)+mTimer.StartDelay;
        mTimer.UserData.Temp(end+1) = tmp(1);
        mTimer.UserData.Humi(end+1) = tmp(2);
        FigureUpdate();
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

function FigureUpdate()
    evalin('base','Temp=TMR.UserData.Temp;');
    evalin('base','Humi=TMR.UserData.Humi;');
    evalin('base','t=TMR.UserData.t;');
end