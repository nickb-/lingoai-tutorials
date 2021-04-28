//
// Simple Linear Growth Trend
//

data {
  int<lower=0> N;
  vector[N] yield;
  vector[N] year;
}
parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
  real<lower=0> eta;
  real<lower=0> gamma[2];
  real<lower=0,upper=1> lambda;
  real<lower=0> sigma;
}

model {
  
  // Prior model
  alpha ~ normal(0, 10);
  beta ~ normal(0, 5);
  eta ~ normal(0, 5);
  gamma ~ normal(0, 5);
  
  lambda ~ beta(10,10);
  sigma ~ normal(0, 5);
  
  for (n in 1:N) {
    target += log_mix(
      lambda,
      normal_lpdf(yield[n] | alpha + gamma[1] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma),
      normal_lpdf(yield[n] | alpha + gamma[2] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma)
    );
  }
  
}
generated quantities {
  matrix[N,2] yhat;
  
  for (n in 1:N) {
    yhat[n,1] = normal_rng(alpha + gamma[1] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma);
    yhat[n,2] = normal_rng(alpha + gamma[2] * (1 + exp(beta * eta)) / (1 + exp(beta * (eta - year[n]))), sigma);
  }
}
