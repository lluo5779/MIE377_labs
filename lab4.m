
load('lab2data.mat')

rets=(prices(2:end,:)./prices(1:end-1,:))-1;
mu= geomean(rets+1)-1;
Q=cov(rets);

sp500ret = (sp500price(2:end,:)./sp500price(1:end-1,:))-1;
targetRet = geomean(sp500ret+1)-1;

alpha = 0.05;

[x_optimal, val] = robustMVO(Q, mu, targetRet, alpha);
    


function [x_optimal, val] = robustMVO(Q, mu, targetRet, alpha)

    n = size(Q,1); 
    epilson = chi2inv((1-alpha),n);
    theta = diag(diag(Q));

    clear model

    % Quadratic term in objective function. extra zeros inserted for binary
    % variables
    model.Q = sparse([Q zeros(n,1);
        zeros(1,n+1)]);
    % linear term in objective function
    model.obj = [zeros(1,n+1)];
    % target return constraint, budget constraint, and lower and upper
    % bound constraints
    model.A = sparse([-1*mu epilson; ones(1,n) 0]);
    
    % RHS of contraints
    model.rhs = [-1*targetRet;1];
    % Define equality and inequalities for each constraint
    sense = ['<';'='];
    model.sense = sense;
    % Variable type: first half is continuous, second half binary
%     model.vtype = [repmat('C', 1, n) repmat('B', 1, n);];
    
    model.quadcon(1).Qc = sparse([theta zeros(n,1);
        zeros(1,n) -1]);
    model.quadcon(1).q  = zeros(n+1,1);
    model.quadcon(1).rhs = 0;


    % Save model in local file
    gurobi_write(model, 'qcp.lp');

    % Obtain results
    results = gurobi(model);
    
    for j=1:n
        fprintf('%s %e\n',  results.x(j))
    end

    fprintf('Obj: %e\n', results.objval);

    % Retrieve x optimal from results
    x_optimal = results.x(1:n,1);
    val = results.objval;
end

