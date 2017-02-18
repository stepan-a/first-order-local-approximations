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

  Efficiency/STEADY_STATE(Efficiency) = (Efficiency(-1)/STEADY_STATE(Efficiency))^rho*exp(sigma*EfficiencyInnovation);

  Output = Efficiency*(alpha*Capital(-1)^Psi+(1-alpha)*Labour^Psi)^(1/Psi);

  Consumption + Capital - Output - (1-delta)*Capital(-1);

  ((1-theta)/theta)*(Consumption/(1-Labour)) - (1-alpha)*Efficiency^((1-Psi))*(alpha*(Capital(-1)/Labour)^Psi+1-alpha)^((1-Psi)/Psi);

  (((Consumption^theta)*((1-Labour)^(1-theta)))^(1-tau))/Consumption
  - beta*(Consumption(1)^theta*(1-Labour(1))^(1-theta))^(1-tau)/Consumption(1)*(alpha*Efficiency(1)^Psi*(Output(1)/Capital)^(1-Psi)+1-delta);

end;

steady_state_model;
    Efficiency = effstar;
    psi = (Epsilon-1)/Epsilon;
    Output_per_unit_of_Capital = ( (1/beta-1+delta) / (alpha*effstar^psi) )^(1/(1-psi));
    Consumption_per_unit_of_Capital = Output_per_unit_of_Capital-delta;
    Labour_per_unit_of_Capital =  ((Output_per_unit_of_Capital/Efficiency)^psi-alpha)^(1/psi)/(1-alpha)^(1/psi);
    gamma_1 = theta*(1-alpha)/(1-theta)*(Output_per_unit_of_Capital/Labour_per_unit_of_Capital)^(1-psi);
    gamma_2 = (Output_per_unit_of_Capital-delta)/Labour_per_unit_of_Capital;
    Labour = 1/(1+gamma_2/gamma_1);
    Output_per_unit_of_Labour=Output_per_unit_of_Capital/Labour_per_unit_of_Capital;
    Consumption_per_unit_of_Labour=Consumption_per_unit_of_Capital/Labour_per_unit_of_Capital;
    ShareOfCapital= alpha^(1/(1-psi))*effstar^psi/(1/beta-1+delta)^(psi/(1-psi));
    Consumption = Consumption_per_unit_of_Labour*Labour;
    Capital = Labour/Labour_per_unit_of_Capital;
    Output = Output_per_unit_of_Capital*Capital;
end;

shocks;
    var EfficiencyInnovation = 1;
end;

steady;
check;

stoch_simul(periods=10000,order=1,loglinear);
innovation = oo_.exo_simul;
endogenous = oo_.endo_simul;
save('rbcdata', 'innovation', 'endogenous');
