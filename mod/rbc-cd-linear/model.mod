var Consumption, Capital, Productivity;

varexo EfficiencyInnovation;

parameters beta, alpha, delta, rho, sigma;

beta = .985;
alpha = 1/3;
delta = alpha/10;
rho = .9;
sigma = .01;

model;
    1/Consumption = beta/Consumption(1)*(alpha*Productivity(1)*Capital^(alpha-1)+1-delta);
    Capital = Productivity*Capital(-1)^alpha+(1-delta)*Capital(-1)-Consumption;
    Productivity = Productivity(-1)^rho*exp(sigma*EfficiencyInnovation);
end;

shocks;
    var EfficiencyInnovation = 1;
end;

steady_state_model;
  Productivity = 1;
  Capital = (Productivity*alpha/(1/beta-1+delta))^(1/(1-alpha));
  Consumption = Productivity*Capital^alpha-delta*Capital;
end;

steady;
check;

stoch_simul(periods=10000,order=1);
innovation = oo_.exo_simul;
endogenous = oo_.endo_simul;
save('rbcdata', 'innovation', 'endogenous');
