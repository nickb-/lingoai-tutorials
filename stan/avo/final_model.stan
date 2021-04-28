//
// Simple Linear Growth Trend
//

data {
  int<lower=0> N;
  vector[N] yield;
  vector[N] year;
}
parameters {
  // Long-term growth model
  real<lower=0> alpha;
  real<lower=0> rho[2];
  real<lower=0> delta[2];
  
  // Growth model
  real<lower=0> beta;
  real<lower=0> eta;
  real<lower=0> gamma[2];
  
  real<lower=0,upper=1> lambda;
  real<lower=0> sigma[2];
}

model {
  
  // Prior long-term growth model
  alpha ~ normal(0, 20);
  rho ~ normal(0, 5);
  delta ~ normal(0, 5);
  
  // Prior growth model
  beta ~ normal(0, 1);
  eta ~ normal(0, 5);
  gamma ~ normal(0, 5);
  
  lambda ~ beta(10,10);
  sigma ~ normal(0, 5);
  
  for (n in 1:N) {
    target += log_mix(
      lambda,
      normal_lpdf(yield[n] | alpha + rho[1] * (delta[1] - year[n]) + gamma[1] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma[1]),
      normal_lpdf(yield[n] | alpha + rho[2] * (delta[2] - year[n]) + gamma[2] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma[2])
    );
  }
  
}
generated quantities {
  matrix[N,2] yhat;
  
  for (n in 1:N) {
    yhat[n,1] = normal_rng(alpha + rho[1] * (delta[1] - year[n]) + gamma[1] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma[1]);
    yhat[n,2] = normal_rng(alpha + rho[2] * (delta[2] - year[n]) + gamma[2] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma[2]);
  }
}
