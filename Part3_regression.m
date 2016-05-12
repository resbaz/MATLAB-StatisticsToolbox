clear
close all
clc

load('C:\Users\pkaroly\Documents\GitHub\MATLAB-StatisticsToolbox\PedCounts.mat')

nans = find(isnan(Sensor_ID));

Sensor_ID(nans) = [];
Hourly_Counts(nans) = [];
Date_Time(nans) = [];

% get dates for bourke st north and south
Dates_BourkeN = Date_Time(Sensor_ID == 1);
Dates_BourkeS = Date_Time(Sensor_ID == 2);

% get counts for bourke st north and south
BourkeN = Hourly_Counts(Sensor_ID == 1);
BourkeS = Hourly_Counts(Sensor_ID == 2);

% find out whcih dates we have both measurements for
same_dateS = ismember(Dates_BourkeS,Dates_BourkeN);
same_dateN = ismember(Dates_BourkeN,Dates_BourkeS);

% let's select the data that is common to both
BourkeN = BourkeN(same_dateN);
BourkeS = BourkeS(same_dateS);

scatter(BourkeN,BourkeS)
corr(BourkeN,BourkeS)

[linear_coeff,~,stats] = glmfit(BourkeN,BourkeS);

hold on;
plot(BourkeN,linear_coeff(1) + ...
    linear_coeff(2) * BourkeN);