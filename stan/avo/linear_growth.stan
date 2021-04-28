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
  real<lower=0> sigma;
}

model {
  
  // Prior model
  alpha ~ normal(50, 25);
  beta ~ normal(0, 20);
  sigma ~ normal(0, 5);
  
  yield ~ normal(alpha + beta*year, sigma);
}
generated quantities {
  vector[N] yhat;
  for (n in 1:N) {
    yhat[n] = normal_rng(alpha + beta*year[n], sigma);
  }
}
