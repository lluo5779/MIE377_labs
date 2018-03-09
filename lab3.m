clear model

rets=prices(2:end,:)./prices(1:end-1,:)-1;
sp500ret=sp500price(2:end,1)./sp500price(1:end-1,1)-1;

mu_SP = geomean(1+sp500ret)-1;

mu = geomean(1+rets) -1;

names = [tickers(1:50) tickers(1:50)] 

model.Q = sparse(2*[cov(rets) zeros(50,50); zeros(50,100)]);
model.A = sparse([-1*mu, zeros(1,50); 
    ones(1,50), zeros(1,50); 
    zeros(1,50), ones(1,50);
    -1*eye(50) 0.05*eye(50);
    eye(50), -0.2*eye(50)]);


model.obj = [zeros(1,100)];
model.rhs = [-1*mu_SP; 1; 10; zeros(100,1)];
sense = [repmat('<', 1, 103)];
sense(1,[2,3]) = '='
model.sense = sense

model.vtype = [repmat('C', 50, 1) repmat('B', 50, 1);];

gurobi_write(model, 'qp.lp'); % mip.lp

results = gurobi(model)

for v=1:length(names)
    fprintf('%s %e\n', names{v}, results.x(v));
end

fprintf('Obj: %e\n', results.objval);



results  = gurobi(model);

for v=1:length(names)
    fprintf('%s %e\n', names{v}, results.x(v));
end

fprintf('Obj: %e\n', results.objval);