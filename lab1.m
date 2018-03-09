%% Question 1

A = -1*[105 3.5 3.5; 0 103.5 3.5; 0 0 103.5];
b = -1*[12000; 18000; 20000];

f = [1 1 1]

[x, val] = linprog(f, A, b)


%% Question 2

load('lab1_prices.mat')

rets=(prices(2:end,:)./prices(1:end-1,:))-1;
mu=mean(rets);
Q=cov(rets);

A = [];
b = [];
Aeq = [mu;ones(1,50)];
beq = [0.0025;1;];
lb = zeros(1,50);

[x_pred, val] = quadprog(Q, [], A, b, Aeq, beq, [], [])