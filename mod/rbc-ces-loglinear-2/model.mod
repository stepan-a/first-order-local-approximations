var Capital, Output, Labour, Consumption, Efficiency ;

varexo EfficiencyInnovation;

parameters beta, theta, tau, alpha, Epsilon, delta, rho, effstar, sigma;


beta    =  0.990;
theta   =  0.357;
tau     = 30.000;
alpha   =  0.450;
delta   =  0.020;
rho     =  0.950;
effstar =  1.500;
sigma   =  0.010;
Epsilon =  0.500;


model;

#Psi = (Epsilon-1)/Epsilon;

  exp(Efficiency)/exp(STEADY_STATE(Efficiency)) = (exp(Efficiency(-1))/exp(STEADY_STATE(Efficiency)))^rho*exp(sigma*EfficiencyInnovation);

  exp(Output) = exp(Efficiency)*(alpha*exp(Capital(-1))^Psi+(1-alpha)*exp(Labour)^Psi)^(1/Psi);

  exp(Consumption) + exp(Capital) - exp(Output) - (1-delta)*exp(Capital(-1));

  ((1-theta)/theta)*(exp(Consumption)/(1-exp(Labour))) - (1-alpha)*exp(Efficiency)^((1-Psi))*(alpha*(exp(Capital(-1))/exp(Labour))^Psi+1-alpha)^((1-Psi)/Psi);

  (((exp(Consumption)^theta)*((1-exp(Labour))^(1-theta)))^(1-tau))/exp(Consumption)
  - beta*(exp(Consumption(1))^theta*(1-exp(Labour(1)))^(1-theta))^(1-tau)/exp(Consumption(1))*(alpha*exp(Efficiency(1))^Psi*(exp(Output(1))/exp(Capital))^(1-Psi)+1-delta);

end;

steady_state_model;
    Efficiency = log(effstar);
    psi = (Epsilon-1)/Epsilon;
    Output_per_unit_of_Capital = ( (1/beta-1+delta) / (alpha*effstar^psi) )^(1/(1-psi));
    Consumption_per_unit_of_Capital = Output_per_unit_of_Capital-delta;
    Labour_per_unit_of_Capital =  ((Output_per_unit_of_Capital/exp(Efficiency))^psi-alpha)^(1/psi)/(1-alpha)^(1/psi);
    gamma_1 = theta*(1-alpha)/(1-theta)*(Output_per_unit_of_Capital/Labour_per_unit_of_Capital)^(1-psi);
    gamma_2 = (Output_per_unit_of_Capital-delta)/Labour_per_unit_of_Capital;
    Labour = -log(1+gamma_2/gamma_1);
    Output_per_unit_of_Labour=Output_per_unit_of_Capital/Labour_per_unit_of_Capital;
    Consumption_per_unit_of_Labour=Consumption_per_unit_of_Capital/Labour_per_unit_of_Capital;
    ShareOfCapital= alpha^(1/(1-psi))*effstar^psi/(1/beta-1+delta)^(psi/(1-psi));
    Consumption = log(Consumption_per_unit_of_Labour)+Labour;
    Capital = Labour-log(Labour_per_unit_of_Capital);
    Output = log(Output_per_unit_of_Capital)+Capital;
end;

shocks;
    var EfficiencyInnovation = 1;
end;

steady;
check;

stoch_simul(periods=10000,order=1);
innovation = oo_.exo_simul;
endogenous = oo_.endo_simul;
save('rbcdata', 'innovation', 'endogenous');
