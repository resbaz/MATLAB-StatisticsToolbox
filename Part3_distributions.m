clear
close all
clc

x = -log(1-rand(100,1)) / 0.1;

plot(x);


exp_dist = fitdist(x,'exponential');
fitdist(x,'exponential')
histogram(x,0:5:max(x),'normalization','pdf');
hold on;
x_vals = 0:0.1:max(x);
% plot(x_vals,1/exp_dist.mu * ...
%     exp(-1/exp_dist.mu * x_vals));
plot(x_vals,pdf(exp_dist,x_vals));

%%

clear
close all
clc

load('PedCounts.mat')

nans = find(isnan(Sensor_ID));

Sensor_ID(nans) = [];
Hourly_Counts(nans) = [];
Date_Time(nans) = [];

Dates_Flinders = Date_Time(Sensor_ID == 6);
Weekday_Flinders = weekday(Dates_Flinders);
Count_Flinders = Hourly_Counts(Sensor_ID==6);

% convert dates to date-vectors
Dates_Flinders = datevec(Dates_Flinders);
Hour_Flinders = Dates_Flinders(:,4);

% count at 8 - 9am
Flinders8 = Count_Flinders(Hour_Flinders == 8);

% weekdays at FLinders at 8 in the morning
FlindersWeekday = Count_Flinders(Hour_Flinders == 8 ...
    & ismember(Weekday_Flinders,2:6));

FlindersWeekend = Count_Flinders(Hour_Flinders == 8 ...
    & ismember(Weekday_Flinders,[1,7]));

dist_wd = fitdist(FlindersWeekday,'normal');
dist_we = fitdist(FlindersWeekend,'normal');

% plot the histograms
histogram(FlindersWeekday,0:100:max(FlindersWeekday),...
    'normalization','pdf');
% leave the plot on
hold on
histogram(FlindersWeekend,0:100:max(FlindersWeekend),...
    'normalization','pdf');
% legend 
legend({'Weekday','Weekend'})
xlabel('Pedestrian Numbers')
ylabel('PDF')

% plot estimated distributions
plot(0:max(FlindersWeekday),...
    pdf(dist_wd,0:max(FlindersWeekday)),'color',[0 0 0])

plot(0:max(FlindersWeekday),...
    pdf(dist_we,0:max(FlindersWeekday)),'color',[0 0 0])
