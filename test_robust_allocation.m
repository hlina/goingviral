function  [delta_rob, lambda_rob, g_rob] = test_robust_allocation(C, index, file)

data = load(file);

n = size(data.A,1);

obs_data.A_ub = data.A * 1.5; % Use multiplicative upper bound for A
obs_data.delta_c = data.delta_c;  % Natural complementary recovery rate
obs_data.n = n;  % Number of nodes
obs_data.p = data.p;   % Observations
obs_data.A_z = (data.A == 0);   % Zero entries in A (prior knowledge)

delta_lim = [0.05*ones(n,1), data.delta_c];   % Bounds for recovery rates
budget = C; % total budget
start = [45,98,150,202,254,306,358,411,463,515,567];
T = [97,149,201,253,305,357,410,462,514,566,618];
[delta_rob, lambda_rob, g_rob] = robust_allocation_exp_v6(obs_data, 1:n, budget, delta_lim, T(1,index), start(1,index));    

