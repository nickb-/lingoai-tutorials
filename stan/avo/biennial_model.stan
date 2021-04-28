//
// Simple Linear Growth Trend
//

data {
  int<lower=0> N;
  vector[N] yield;
  vector[N] year;
}
parameters {
  real<lower=0> alpha[2];
  real<lower=0> beta[2];
  real<lower=0,upper=1> lambda;
  real<lower=0> sigma;
}

model {
  
  // Prior model
  alpha ~ normal(50, 25);
  beta ~ normal(0, 20);
  lambda ~ beta(10,10);
  sigma ~ normal(0, 5);
  
  for (n in 1:N) {
    target += log_mix(
      lambda,
      normal_lpdf(yield[n] | alpha[1] + beta[1]*year[n], sigma),
      normal_lpdf(yield[n] | alpha[1] + beta[1]*year[n], sigma)
    );
  }
  
}
generated quantities {
  matrix[N,2] yhat;
  
  for (n in 1:N) {
    yhat[n,1] = normal_rng(alpha[1] + beta[1]*year[n], sigma);
    yhat[n,2] = normal_rng(alpha[2] + beta[2]*year[n], sigma);
  }
}
