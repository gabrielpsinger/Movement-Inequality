inc <-f_mainheader$inc

library(ineq)
library(tidyverse)


lorenz <- Lc(inc)
lorenz_df <- tibble(prop_pop = lorenz$p, income = lorenz$L) %>% 
  mutate(prop_equality = prop_pop)


p1 <- ggplot(lorenz_df, aes(x = prop_pop, y = income)) +
  geom_ribbon(aes(ymax = prop_equality, ymin = income), fill = "yellow") +
  geom_line() +
  geom_abline(slope = 1, intercept = 0) +
  scale_x_continuous("\nCumulative proportion of population") +
  scale_y_continuous("Cumulative proportion of income\n") +
  theme_minimal() +
  coord_equal() +
  annotate("text", 0.53, 0.32, label = "Inequality\ngap") +
  annotate("text", 0.5, 0.6, label = "Complete equality line", angle = 45) + 
  ggtitle (
    str_wrap("Cumulative distribution of New Zealand individual weekly income from all sources", 46))



Gini(inc)                   # 0.51

# if completely constant each week
Gini(inc * 52)              # 0.51

# create incomes that simulate each week being a random pull from the pool
random_incomes <- tibble(
  income = sample(inc, 52 * length(inc), replace = TRUE),
  person = rep(1:length(inc), 52)) %>%  
  group_by(person) %>%
  summarise(income = sum(income))

Gini(random_incomes$income) # 0.09


sim_gini <- function(n, reps = 1000){
  results <- tibble(
    trial = 1:reps,
    estimate = numeric(reps))
  
  set.seed(123) # for reproducibility
  for(i in 1:reps){
    results[i, "estimate"] <- 
      Gini(sample(inc, n, replace = TRUE))
  }
  
  print(results %>%
          ggplot(aes(x = estimate)) +
          geom_density() +
          geom_rug() +
          theme_minimal() +
          ggtitle(paste("Distribution of estimated Gini coefficient, n =", n)))
  
  # grid.text(paste0("Standard error: ", round(sd(results$estimate), 3)), 0.8, 0.6, 
  #           gp = gpar( fontsize = 9))
  # 
  # grid.text(paste0("95% Confidence interval:\n", 
  #                  paste(round(quantile(results$estimate, c(0.025, 0.975)), 3), collapse = ", ")), 0.8, 0.5, 
  #           gp = gpar( fontsize = 9))
}

sim_gini(30)

sim_gini(1000)

sim_gini(30000)
