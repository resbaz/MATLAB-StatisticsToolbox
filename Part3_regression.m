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

%% LOGISTIC REGRESSION

% class 1
mu1 = 1;
sigma1 = 0.1;
% class 2
mu2 = 2;
sigma2 = 2;

x1 = mu1 + sigma1*randn(100,1);
x2 = mu2 + sigma2*randn(100,1);

% input
x = [x1 ; x2];

% randomly choose training data and test data from x
random_ind = randperm(length(x));
N = round(0.8 * length(x));
training_x = x(random_ind(1:N));
testing_x = x(random_ind(N+1:end));

% label
y = [zeros(size(x1)) ; ones(size(x2))];

log_model = glmfit(x,[y ones(size(y))], ...
    'binomial','link','logit');

% run the logistic regression classifier
input = log_model(1) + log_model(2) * x;

output = 1 ./ (1 + exp(-input));

figure;
% plot the classifier output
plot(x(output >= 0.5 & y == 1),'ro')
hold on;
plot(x(output < 0.5 & y == 0),'bo')

% incorrect classifications
plot(x(output >= 0.5 & y == 0),'bx')
plot(x(output < 0.5 & y ==1),'rx');
