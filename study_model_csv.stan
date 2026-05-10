data {
  int<lower=1> n;
  int<lower=1> p;
  int<lower=1> q;
  int<lower=1> n_readers;
  int<lower=2> K;

  int<lower=0> n_obs_ratings;
  array[n_obs_ratings] int<lower=1, upper=n> case_id;
  array[n_obs_ratings] int<lower=1, upper=p> feat_id;
  array[n_obs_ratings] int<lower=1, upper=n_readers> reader_id;
  array[n_obs_ratings] int<lower=1, upper=K> rating;

  array[n] int<lower=0, upper=1> Y;

  matrix[n, q] Z_obs;
  int<lower=0> n_mis_z;
  array[n_mis_z] int<lower=1, upper=n> mis_z_case;
  array[n_mis_z] int<lower=1, upper=q> mis_z_var;
}

parameters {
  matrix[n, p] X_raw;
  cholesky_factor_corr[p] L_C_X;

  cholesky_factor_corr[q] L_C_Z;

  vector[n_mis_z] Z_mis;

  real beta0;
  vector[p] beta;
  vector[q] gamma;

  real mu_a;
  real<lower=0> sigma_a;
  matrix[p, n_readers] alpha_raw;

  array[p, n_readers] ordered[K - 1] c;
}

transformed parameters {
  matrix[n, p] X;
  matrix[n, q] Z_complete;
  matrix[p, n_readers] alpha;
  matrix[p, n_readers] a;

  X = X_raw * L_C_X';
  Z_complete = Z_obs;

  for (m in 1:n_mis_z) {
    Z_complete[mis_z_case[m], mis_z_var[m]] = Z_mis[m];
  }

  alpha = mu_a + sigma_a * alpha_raw;
  for (j in 1:p) {
    for (r in 1:n_readers) {
      a[j, r] = exp(alpha[j, r]);
    }
  }
}

model {
  beta0 ~ normal(0, 2.5);
  beta ~ normal(0, 1.5);
  gamma ~ normal(0, 1.5);

  mu_a ~ normal(0, 1);
  sigma_a ~ normal(0, 0.5);
  to_vector(alpha_raw) ~ normal(0, 1);

  L_C_X ~ lkj_corr_cholesky(2);
  L_C_Z ~ lkj_corr_cholesky(2);

  to_vector(X_raw) ~ normal(0, 1);

  // Prior model for full Z rows; observed entries are conditioned on by replacing only missing cells.
  for (i in 1:n) {
    Z_complete[i] ~ multi_normal_cholesky(rep_vector(0, q), L_C_Z);
  }

  for (j in 1:p) {
    for (r in 1:n_readers) {
      c[j, r] ~ normal(0, 2);
    }
  }

  for (m in 1:n_obs_ratings) {
    int i = case_id[m];
    int j = feat_id[m];
    int r = reader_id[m];
    real eta = a[j, r] * X[i, j];
    rating[m] ~ ordered_logistic(eta, c[j, r]);
  }

  for (i in 1:n) {
    Y[i] ~ bernoulli_logit(beta0 + dot_product(beta, to_vector(X[i])) + dot_product(gamma, to_vector(Z_complete[i])));
  }
}

generated quantities {
  corr_matrix[p] C_X;
  corr_matrix[q] C_Z;
  vector[n] prob_y;

  C_X = multiply_lower_tri_self_transpose(L_C_X);
  C_Z = multiply_lower_tri_self_transpose(L_C_Z);

  for (i in 1:n) {
    prob_y[i] = inv_logit(beta0 + dot_product(beta, to_vector(X[i])) + dot_product(gamma, to_vector(Z_complete[i])));
  }
}
