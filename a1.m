%% Problem 2 
% part a
X = [ones(1,10);
    0.09 -0.01 -0.16 -0.15 0.25 -0.01 0.04 -0.11 0.1 -0.04;
    0.47 0.87 0.49 0.65 0.61 0.27 0.17 -0.18 -0.04 0.77;];
 y = [0.56 0.65 0.32 0.35 0.57 0.18 0.22 -0.11 0.13 0.35];
 
 [b,bint,r,rint,stats] = regress(transpose(y), transpose(X)); 
 
%  part b
mu = geomean(1+transpose(X))-1 % expected factor return
Q = cov(transpose(X)) % factor covariance matrix with an extra row and column of 0s

y_predicted = transpose(b)*X % prediction based on trained regressors
residual = y-y_predicted % residual between predicted return and actual asset return

%ideal environment condition1: cov(ei,fj) = 0
cov_e_f1 = cov(residual, X(2,1:10)) % covariance between residual and f1
cov_e_f2 = cov(residual, X(3,1:10)) % covariance between residual and f2

% part c
Q_asset = cov(transpose(y)) % variance of asset from raw data only

Q_error = cov(residual) % variance of errors
variance_asset = b(2)^2 * Q(2,2) + b(3)^2 * Q(3,3) + 2*b(2)*b(3)*Q(2,3) + Q_error
% from in-class formula as shown in Q2 written part



%% problem 5
Q = [0.013909129	-0.001346772	-0.001148452;
    -0.001346772	0.014843382	0.005354323;    
    -0.001148452	0.005354323	0.001963267];
f = []; 
Aeq = [1 1 1; 0.063936159	-0.024638781	0.010061038]; 
% budget constraint and target return constraint
beq = [1; 0.035];
A = []%-1*[0.063936159	-0.024638781	0.010061038];
b = []%[-0.035];

lb = [0 0 0]; 

[x_i, val_i] = quadprog(Q, f, A, b, Aeq, beq, [], []) % allow shorting
[x_ii, val_ii] = quadprog(Q, f, A, b, Aeq, beq, lb, []) % no shorting
