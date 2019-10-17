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
ggplot(data = df_prop, aes(x= rank, y= proportion, color = as.character(year))) + 
  geom_line(size = 2.25, alpha = .8) +
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
