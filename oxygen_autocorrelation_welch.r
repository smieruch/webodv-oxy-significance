
# --------------------------------------------------
# 1. Load data
# --------------------------------------------------

data1 <- read.table("oxygen_bottle_hot_1999_2000.txt", header = FALSE)
data2 <- read.table("oxygen_bottle_hot_2019_2020.txt", header = FALSE)

colnames(data1) <- c("time", "oxygen")
colnames(data2) <- c("time", "oxygen")

# Convert decimal years to days
decimal_to_days <- function(t) {
    year <- floor(t)
    ## test leap year
    days_in_year <- ifelse(
    (year %% 4 == 0 & year %% 100 != 0) | year %% 400 == 0,
    366, 365
    )

  as.numeric(as.Date(paste0(year, "-01-01")) -
             as.Date("1970-01-01")) +
    (t - year) * days_in_year
}

data1$time <- decimal_to_days(data1$time)
data2$time <- decimal_to_days(data2$time)

# Basic statistics
cat("Period 1:", nrow(data1), "observations\n")
cat("Period 2:", nrow(data2), "observations\n")

#print(data1)



# --------------------------------------------------
# 2. Edelson-Krolik autocorrelation
# --------------------------------------------------

autocorrelation <- function(data) {

  x <- data$oxygen
  t <- data$time

  mu <- mean(x)
  sigma <- sd(x)

  cat("Mean:", mu, "\n")
  cat("Standard deviation:", sigma, "\n")


  # Calculate time differences for all unique pairs

    n <- length(x)
    
    dt <- numeric()
    udcf <- numeric()
    
    
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      dt <- c(dt, abs(t[j] - t[i]))

      udcf <- c(udcf,
      (x[i] - mu) * (x[j] - mu) / sigma^2)

    }
  }

    
  # Select pairs with time differences of 0-1 days

  selected <- dt >= 0 & dt < 1

  rho <- mean(udcf[selected])

  cat("Number of selected pairs:", sum(selected), "\n")
  cat("Autocorrelation (0-1 days):", rho, "\n")

    
  # Effective sample size

  n_eff <- n * (1 - rho) / (1 + rho)

  cat("Number of observations:", n, "\n")
  cat("Effective sample size:", n_eff, "\n")

    
  return(c(n = n, n_eff = n_eff, mu = mu, sigma = sigma, s = sigma/sqrt(n_eff)))


    
}

# Apply to both datasets

result1 <- autocorrelation(data1)
result2 <- autocorrelation(data2)

print(result1)
print(result2)



# --------------------------------------------------
# 4. Welch t-test
# --------------------------------------------------

mu1 <- result1["mu"]
mu2 <- result2["mu"]

sigma1 <- result1["sigma"]
sigma2 <- result2["sigma"]

n1 <- result1["n_eff"]
n2 <- result2["n_eff"]

# Standard error of the difference
se <- sqrt(sigma1^2 / n1 + sigma2^2 / n2)

# Welch t-statistic
t_value <- (mu1 - mu2) / se

cat("Welch t-statistic:", t_value, "\n")



# Welch-Satterthwaite degrees of freedom

v1 <- sigma1^2 / n1
v2 <- sigma2^2 / n2

df <- (v1 + v2)^2 /
      (v1^2 / (n1 - 1) + v2^2 / (n2 - 1))

cat("Degrees of freedom:", df, "\n")


# Two-sided p-value

p_value <- 2 * pt(-abs(t_value), df = df)

cat("p-value:", p_value, "\n")
