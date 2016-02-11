function  [delta, lambda, costs] = test_robust_allocation(C)

% Data: p(1), p(2), ..., p(T+1)

% Expected output:
% lambda_rob =
% 
%     0.5350
% 
% 
% delta_rob =
% 
%     0.1000
%     0.3953
%     0.1000
%     0.3393
%     0.1945
%     0.1000
%     0.5960
%     0.1000
%     0.5962
%     0.2382

data = load('our_model_NE.mat');

n = size(data.A,1);

obs_data.A_ub = data.A * 1.5; % Use multiplicative upper bound for A
obs_data.delta_c = data.delta_c;  % Natural complementary recovery rate
obs_data.n = n;  % Number of nodes
obs_data.p = data.p;   % Observations
obs_data.A_z = (data.A == 0);   % Zero entries in A (prior knowledge)

delta_lim = [0.2*ones(n,1), data.delta_c];   % Bounds for recovery rates
lambda = '';
delta = '';
costs = '';
budget = C; % total budget
year = ['"2003": [';'"2004": [';'"2005": [';'"2006": [';'"2007": [';'"2008": [';'"2009": [';'"2010": [';'"2011": [';'"2012": [';'"2013": [';'"2014": [';'"2015": ['];
start = [1,15,67,119,172,224,276,328,380,432,485,537,589];
T = [14,66,118,171,223,275,327,379,431,484,536,588,619];   % Use only p(1) to p(8)
for i = 1:1
    [delta_rob, lambda_rob, g_rob] = robust_allocation_exp_v6(obs_data, 1:n, budget, delta_lim, T(1,i), start(1,i));    
    lambda = strcat(lambda, year(i,:));
    delta = strcat(delta, year(i,:));
    costs = strcat(costs, year(i,:));
    disp(delta_rob(1,1));
    disp(num2str(delta_rob(1,1)));
    for j = 1:6
        delta = strcat(delta, strcat(num2str(delta_rob(j,1)), ',')); % optimal recover rate
        costs = strcat(costs, strcat(num2str(g_rob(j,1)), ','));
    end
%     lambda = strcat(strcat(lambda, num2str(lambda_rob)), '],');
%     delta = strcat(strcat(delta, num2str(delta_rob(7,1))), '],');
%     costs = strcat(costs, strcat(num2str(g_rob(7,1)), '],'));
    lambda = lambda_rob;
    delta = delta_rob(7,1);
    costs = g_rob(7,1);
end
disp('lambda');
disp(lambda);
disp('delta');
disp(delta);
disp('costs');
disp(costs);
disp(class([delta, lambda, costs]))

