var Consumption, Capital, Productivity;

varexo EfficiencyInnovation;

parameters beta, alpha, delta, rho, sigma;

beta = .985;
alpha = 1/3;
delta = alpha/10;
rho = .9;
sigma = .01;

model;
    1/exp(Consumption) = beta/exp(Consumption(1))*(alpha*exp(Productivity(1))*exp(Capital)^(alpha-1)+1-delta);
    exp(Capital) = exp(Productivity)*exp(Capital(-1))^alpha+(1-delta)*exp(Capital(-1))-exp(Consumption);
    exp(Productivity) = exp(Productivity(-1))^rho*exp(sigma*EfficiencyInnovation);
end;

shocks;
    var EfficiencyInnovation = 1;
end;

steady_state_model;
  Productivity = 0;
  Capital = (1/(1-alpha))*log(alpha/(1/beta-1+delta));
  Consumption = log(exp(Capital)^alpha-delta*exp(Capital));
end;

steady;
check;

stoch_simul(periods=10000,order=1);
innovation = oo_.exo_simul;
endogenous = oo_.endo_simul;
save('rbcdata', 'innovation', 'endogenous');
