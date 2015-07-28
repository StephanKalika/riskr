#' Calculate Kolmogorov-Smirnov statistic
#'
#' @param score A numeric vector containing scores or probabilities
#' @param target A numeric binary vector (0, 1)
#' @return The KS statistic
#' @examples
#' data(predictions)
#' 
#' score <- predictions$score
#' target <- predictions$target
#' 
#' ks(score, target)
#' @export
ks <- function(score, target){
  
  stopifnot(
    setequal(target, c(0, 1)),
    length(target) == length(score)
  )
  
  
  suppressMessages(library("ROCR"))
  
  pred <- prediction(score, target)
  
  perf <- performance(pred, "tpr", "fpr")
  
  ks <- max(abs(attr(perf, "y.values")[[1]] - attr(perf, "x.values")[[1]]))
  
  return(as.numeric(ks))
}

#' Calculate Kolmogorov-Smirnov statistic
#'
#' @param score1 A numeric vector containing scores or probabilities
#' @param score2 A numeric vector containing scores or probabilities
#' @return The KS statistic
#' @examples
#' data(predictions)
#' 
#' score <- predictions$score
#' target <- predictions$target
#' 
#' score1 <- score[target == 1]
#' score1 <- score[target != 1]
#' 
#' ks2(score, target)
#' @export
ks2 <- function(score1, score2){
  
  value <- as.numeric(suppressWarnings(ks.test(score1, score2)[["statistic"]]))
  
  return(value)
}


#' Calculate Area Under ROC Curve
#'
#' @param score A numeric vector containing scores or probabilities
#' @param target A numeric binary vector (0, 1)
#' @return The AUROC Curve
#' @examples
#' data(predictions)
#' 
#' score <- predictions$score
#' target <- predictions$target
#' 
#' aucroc(score, target)
#' @export
aucroc <- function(score, target){
  
  stopifnot(
    setequal(target, c(0, 1)),
    length(target) == length(score)
  )
  
  
  suppressMessages(library("ROCR"))
  
  pred <- prediction(score, target)
  
  perf <- performance(pred, "tpr", "fpr")
  
  aucroc <- attr(performance(pred, "auc"), "y.values")[[1]]
  
  return(aucroc)
}

#' Calculate Gini Coefficient
#'
#' @param score A numeric vector containing scores or probabilities
#' @param target A numeric binary vector (0, 1)
#' @return The Gini Coefficient
#' @examples
#' data(predictions)
#' 
#' score <- predictions$score
#' target <- predictions$target
#' 
#' gini(score, target)
#' @references https://www.kaggle.com/wiki/RCodeForGini
#' @export
gini <- function(score, target){
  
  # gini <- 2*as.numeric(aucroc(score, target)) - 1
  stopifnot(
    setequal(target, c(0, 1)),
    length(target) == length(score)
  )
  
  ginidf <- function(score, target){
    
    suppressMessages(library("dplyr"))
    
    df <- data_frame(score, target) %>% 
      arrange(desc(score)) %>% 
      mutate(random = seq(nrow(.))/nrow(.),
             cumPosFound = cumsum(target),
             Lorentz = cumPosFound/sum(target),
             gini = Lorentz - random)
    
    df %>% summarise(sum(gini)) %>% as.numeric()
    
  }
  
  gini <- ginidf(score, target)/ ginidf(target, target)
  
  return(gini)
}

#' Calculate Gains
#'
#' @param score A numeric vector containing scores or probabilities
#' @param target A numeric binary vector (0, 1)
#' @param percents Values to calculate the gain
#' @return The Gini Coefficient
#' @examples
#' data(predictions)
#' 
#' score <- predictions$score
#' target <- predictions$target
#' 
#' gain(score, target)
#' @export
gain <- function(score, target, percents = c(0.10, 0.20, 0.30, 0.40, 0.50)){
  
  stopifnot(
    setequal(target, c(0, 1)),
    length(target) == length(score)
  )
  
  library("scales")
  
  g <- ecdf(score[target == 0])(quantile(score, percents))
  
  names(g) <- percent(percents)
  
  g
}

#' Summary of Performance
#'
#' @param score A numeric vector containing scores or probabilities
#' @param target A numeric binary vector (0, 1)
#' @return A 1 row data frame with the summary of the performance.
#' @examples
#' data(predictions)
#' 
#' score <- predictions$score
#' target <- predictions$target
#' 
#' perf(score, target)
#' @export
perf <- function(score, target){
  
  res <- c(count = length(score),
           target_count = length(score[target == 1]),
           target_rate = mean(target),
           ks = ks(score, target),
           aucroc = aucroc(score, target),
           gini = gini(score, target))
  
  res <- data.frame(t(res))
  
  return(res)

}

