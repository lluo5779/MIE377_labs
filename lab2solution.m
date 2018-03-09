clear
clc

load('lab2data.mat')
%compute returns, factor models use returns not prices
rets=prices(2:end,:)./prices(1:end-1,:)-1;
sp500ret=sp500price(2:end,1)./sp500price(1:end-1,1)-1;

%historical estimates are used in creating the factor model (performing the regression)

%observed historical sp500 expected return, isnt used for anything
sp_h_exp=mean(sp500ret);
%observed historical sp500 volatility
sp_h_stdev=var(sp500ret)^.5;

%CAPM regresses asset i minus the risk free rate onto the market minus the riskfree rate

%riskfree rate is one basis point per week
rf=.0001;

%setup X for regression
X = [ones(210,1) (sp500ret-rf)];
%perform the regression
for i=1:50
    temp=cov(rets(:,i)-rf,sp500ret-rf);
    %this is the covariance divided by the variance of the market
    beta(1,i)=temp(2,1)/(sp_h_stdev^2);
    
    %you can confirm that this is the same as performing an ordinary least
    %squares linear regression using 
    %a) the regress function
    temp = regress((rets(:,i)-rf),X);
    betaRegress(1,i)= temp(2);
    
    %b) the regress function closed form solution
    temp = inv(X'*X)*(X'*(rets(:,i)-rf));
    betaOLS(1,i) = temp(2);
    
    %think about why we had to setup X and not just plug in (sp500ret-rf)!
    
    %after finding beta we can compute the error term for asset i, be
    %careful not to name your variable "error" as this is also a MATLAB
    %function handle
    errcalc=rets(:,i)-(rf+beta(1,i)*(sp500ret-rf));
    %now compute variance of the error term
    varerr(1,i)=var(errcalc);            
end


%now that we have fit the CAPM model, we can compute the forecasted
%expected return and covariances by using the predicted SP500 expected
%return and risk

%forecasted sp500 expected return
sp_f_exp=0.0013;
%forecasted sp500 volatility
sp_f_stdev=0.028;


%perform the forecast for expected return
for i=1:50
    mu_CAPM_forecast(1,i)=rf+beta(1,i)*(sp_f_exp-rf);
end

%perform the forecast for covariance
for i=1:50
    for j=1:50
        if i==j         %when i=j on the diagonal we must also add error variance
            Q_CAPM_forecast(i,j)=(beta(1,i)^2)*sp_f_stdev^2+varerr(1,i);
        elseif i~=j     %when i not equal j the calculation is simpler
            Q_CAPM_forecast(i,j)=beta(1,i)*beta(1,j)*sp_f_stdev^2;
        end
    end
end


clearvars i temp j

%% you can now use Q_CAPM_forecast and mu_CAPM_forecast to perform MVO
%note that these estimates are different than the simple mu and Q estimates
%used in lab1
mu=mean(rets);
Q=cov(rets);

%the rest is left to you since MVO code can be found in the lab 1 solutions










