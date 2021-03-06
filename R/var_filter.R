#' Variable Filter
#'
#' This function filter variables base on the specified conditions, including minimum iv, maximum na percentage and maximum element percentage.
#'
#' @param dt A data frame with both x (predictor/feature) and y (response/label) variables.
#' @param y Name of y variable.
#' @param x Name of x variables. Default NULL If x is NULL, all variables exclude y will counted as x variables.
#' @param iv_limit The minimum IV of each kept variable, default 0.02.
#' @param na_perc_limit The maximum NA percent of each kept variable, default 0.95.
#' @param ele_perc_limit The maximum element (excluding NAs) percentage in each kept variable, default 0.95.
#' @param var_rm Name vector of force removed variables, default NULL.
#' @param var_kp Name vector of force kept variables, default NULL.
#' @return A data.table with y and selected x variables
#'
#' @examples
#' # Load German credit data
#' data(germancredit)
#'
#' # variable filter
#' dt_selected <- var_filter(germancredit, y = "creditability")
#'
#' @import data.table
#' @export
#'
var_filter <- function(dt, y, x = NULL, iv_limit = 0.02, na_perc_limit = 0.95, ele_perc_limit = 0.95, var_rm = NULL, var_kp = NULL) {
  info_value = variable = NULL # no visible binding for global variable

  # conditions # https://adv-r.hadley.nz/debugging
  if (!is.data.frame(dt)) stop("Incorrect inputs; dt should be a dataframe.")
  if (ncol(dt) <=1) stop("Incorrect inputs; dt should have at least two columns.")
  if (!(y %in% names(dt))) stop(paste0("Incorrect inputs; there is no \"", y, "\" column in dt."))

  # set dt as data.table
  dt <- setDT(dt)
  # x variable names
  if (is.null(x)) x <- setdiff(names(dt), y)


  # -iv
  iv_list <- iv(dt, y, x)
  # -na percentage
  na_perc <- dt[, lapply(.SD, function(a) sum(is.na(a))/length(a)), .SDcols = x]
  # -percentage limit
  ele_perc <- dt[, lapply(.SD, function(a) max(table(a)/sum(!is.na(a)))), .SDcols = x]


  # remove na_perc>95 | ele_perc>0.95 | iv<0.02
  var_kept <- list(
    as.character( iv_list[info_value >= iv_limit, variable] ),
    names(na_perc[,na_perc <= na_perc_limit, with=FALSE]),
    names(ele_perc[,ele_perc <= ele_perc_limit, with=FALSE])
  )
  x_selected <- intersect(var_kept[[1]], var_kept[[2]])
  x_selected <- intersect(x_selected, var_kept[[3]])

  # remove variables
  if (!is.null(var_rm))  x_selected <- setdiff(x_selected, var_rm)
  # add kept variable
  if (!is.null(var_kp))  x_selected <- unique(c(x_selected, var_kp))

  # return
  dt_sel <- dt[, c(x_selected, y), with=FALSE ]
  return(dt_sel)

}

