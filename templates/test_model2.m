function [delta_rob, lambda_rob, cost] = test_model(C, i, file, network)

data = load(file);

n = size(data.A,1);

obs_data.A_ub = data.A * 1.5; % Use multiplicative upper bound for A
obs_data.delta_c = data.delta_c;  % Natural complementary recovery rate
obs_data.n = n;  % Number of nodes
obs_data.p = data.p;   % Observations
obs_data.A_z = (data.A == 0);   % Zero entries in A (prior knowledge)

if (network == 0)
	delta_lim = [0.1*ones(n,1), data.delta_c];   % Bounds for recovery rates
elseif (network == 1)
	delta_lim = [0.1*ones(n,1), data.delta_c];   % Bounds for recovery rates
else
	delta_lim = [0.2*ones(n,1), data.delta_c];   % Bounds for recovery rates
end
start = [45,98,150,202,254,306,358,411,463,515,567];
ended = [97,149,201,253,305,357,410,462,514,566,618];
[delta_rob, lambda_rob, cost] = model(obs_data, 1:n, C, delta_lim, ended(1,i), start(1,i), network);
%display(lambda_rob);
%display(delta_rob);
%display(cost);

