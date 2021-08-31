ggplot(data = gs_prop, aes(x= rank, y= proportion, color = as.character(year))) + 
  geom_line(size = 2.25, alpha = .8) +
  theme(legend.position = 'none') +
  xlab('Rank') +
  ylab('Total Movement') +
  coord_cartesian(ylim = c(0, .75), xlim = c(0, nrow(gs_prop))) +
  scale_y_continuous(breaks = c(0.0, 0.25, .50, .75)) +
  theme_bw()

ggplot(data = gs_prop, aes(x= rank, y= proportion, color = as.character(year))) + 
  geom_line(size = 2.25, alpha = .8) +
  theme(legend.position = 'none') +
  xlab('Rank') +
  ylab('Total Movement') +
  coord_cartesian(ylim = c(0, .75), xlim = c(0, nrow(gs_prop))) +
  scale_y_continuous(breaks = c(0.0, 0.25, .50, .75)) +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), #axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())



df_prop <- gs_prop
df_prop <- order_year(df_prop, all_years)
df_prop$rank <- c(1:nrow(df_prop))
all_df_prop <<- df_prop

df_prop$proportion + 0.2


labs <- tibble(yr = 2006:2017, x = c(1, 13, 38, 46, 59, 78, 87, 94, 99, 103.5, 109, 115), 
                      y = c(0.3577, 0.1805, 0.3264, 0.2285, 0.1694, 0.2198, 0.3269, 
                            0.4913, 0.6699, 0.2832, 0.2231, 0.7014))


ggplot() + 
  geom_line(data = df_prop, aes(x= rank, y= proportion, color = as.character(year)),
            size = 2.25, alpha = .8) +
  geom_label(data = labs, aes(x = x, y = y, label = yr)) + 
  theme(legend.position = 'none') +
  xlab('Rank') +
  ylab('Total Movement') +
  coord_cartesian(ylim = c(0, .75), xlim = c(0, nrow(df_prop))) +
  scale_y_continuous(breaks = c(0.0, 0.25, .50, .75)) +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), #axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  scale_color_manual(values=cc) +
  theme(legend.position="none")




df_lorenz <- df_prop %>% get_lorenz_values() %>% adjust_lorenz_values()
all_df_lorenz <<- df_lorenz

b <- ggplot(df_lorenz, aes(x=p, y=L, color =  as.character(year))) + geom_line() +
  scale_color_manual(values = cc) +
  xlab('Cumulative % of Movement Observations') +
  ylab('Total Movement') +
  geom_abline(linetype = 'dashed') +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -1) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -2) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -3) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -4) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -5) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -6) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -7) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -8) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -9) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -10) +
  geom_abline(linetype = 'dashed', slope = 1, intercept = -11) +
  theme_bw() +
  theme(legend.position="none") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
