### Function for writing histograms of summary statistics ###

hist.writer <- function(summary_statistic, post_values, post_pred_dist){

  post_mean <- mean(unlist(post_values))

  grDevices::pdf(file = paste0(summary_statistic, ".pdf")) # start pdf
  graphics::hist(unlist(post_pred_dist), breaks = 20, main = summary_statistic, xlab = "") # plot histogram
  graphics::abline(v = post_mean, col = "red") # add line for posterior comparison
  grDevices::dev.off() # close pdf

}
