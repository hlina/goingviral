function [delta, lambda, g] = robust_allocation_exp_v6(obs_data, Vs, C, delta_lim, T, start)

% Observation uncertainty set is derived from AM-GM inequality
% Compared to v4: Added the set of observable sensors Vs (e.g. [1 3 4])
% Compared to v5: Added bounds on A => no sparsity constraint is needed

DEBUG = false;

A_ub = obs_data.A_ub; % refers to betaIJ, something we need to guess
% A_lb = obs_data.A_lb;
delta_c_nat = obs_data.delta_c;  % <nx1 double>
n = obs_data.n;
p = obs_data.p;
Cmax = 50000000;
assert(size(delta_lim,1) == n); % checking to see if thing inside () is true, if not it stops the program
assert(size(delta_lim,2) == 2); % 2 because upper and lower bound

% binary vector indicating the observable sensors
is_obs = zeros(n,1); % binary thing to see if Vs is observable or not
is_obs(Vs) = 1;

% generate the coefficient matrices that define the uncertainty set

% from upper bound
F_ub = -eye(n);  % same for all i, make identity matrix the size of n
G_ub = cell(1,n); % x by y by z array with empty spaces
for i = 1:n
    G_ub{i} = A_ub(i,:)';
end

% from lower bound
% F_lb = eye(n);
% G_lb = cell(1,n);
% for i = 1:n
%     G_lb{i} = -A_lb(i,:)';
% end

% % from sparsity
% F_sp = cell(1,n);
% G_sp = cell(1,n);
% for i = 1:n
%     F_sp{i} = -A_z(i,:);
%     G_sp{i} = 0;
% end

% from observation
F_obs = cell(1,n);
G_obs = cell(1,n);

for i = 1:n
    if is_obs(i) && T ~= 0                
        F_obs{i} = zeros(T-start+1,n);
        F_obs{i}(:,Vs) = -p(Vs,start:T)';
        P_frac = (p(i,start+1:T+1) - p(i,start:T) * delta_c_nat(i)) ./ (1 - p(i,start:T));
        assert(all(P_frac(:) <= 1));
        G_obs{i} = n * (1 - (1 - P_frac).^(1/n))'; % equation 18        
    else
        F_obs{i} = [];
        G_obs{i} = []; % same thing as Delta hat
    end
end

% combine all
F = cell(1,n);
G = cell(1,n);
num_constr = zeros(n,1);
for i = 1:n
    F{i} = [F_ub; F_obs{i}];
    %disp('F{i}');
    %disp(F{i});
    G{i} = [G_ub{i}; G_obs{i}];
    %disp('G{i}');
    %disp(G{i});
    num_constr(i) = size(F{i}, 1);   
end

max_num_constr = max(num_constr);
p = [622,646,8406,1553,306,214,659];
P = sum(p);
cvx_begin 
    cvx_solver mosek
    variables u2(n) delta2(n) lambda2 nu(max_num_constr,n) v(n)
    expression g(n)
    for i = 1:n
        if abs(delta_lim(i,1) - delta_lim(i,2)) < 1e-6
            g(i) = 0;
        else
            g(i) = (exp(-delta2(i)) - 1/delta_lim(i,2))/(1/delta_lim(i,1) - 1/delta_lim(i,2)) * (p(i)/P)*Cmax;
        end
    end
    minimize( exp(lambda2) )
    subject to
        sum(u2) == 0;
        for i = 1:n
            v(i) + exp(delta2(i) - lambda2) <= 1;
            F{i}' * nu(1:num_constr(i),i) + exp(u2 - u2(i) - lambda2) <= 0;
            G{i}' * nu(1:num_constr(i),i) <= v(i);

            exp(delta2(i)) >= log(delta_lim(i,1));
            exp(delta2(i)) <= log(delta_lim(i,2));            
        end
        
        sum(g) <= C;        
        nu >= 0;
        
cvx_end

% print cost
for i=1:n
    disp(g(i) / (.5*n));
end

delta = exp(delta2);
lambda = exp(lambda2);


% if DEBUG    % for debug only
%     data = load('data/epidemic_dis_01.mat');
%     W = diag(data.beta)*data.A;
%     w = W(1,:)';
%     
%     keyboard;
% end

