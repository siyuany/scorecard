% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/woebin.R
\name{woebin_ply}
\alias{woebin_ply}
\title{Application of Binning}
\usage{
woebin_ply(dt, bins, print_step = TRUE)
}
\arguments{
\item{dt}{A data frame.}

\item{bins}{Binning information generated by \code{woebin}.}

\item{print_step}{Logical. If it is TRUE, print the variable name  when converting data into woe.}
}
\value{
Binning information
}
\description{
\code{woebin_ply} converts original input data into woe values based on the binning information generated by \code{woebin}.
}
\examples{
# load germancredit data
data(germancredit)

# Example I
dt <- germancredit[, c("creditability", "credit.amount", "purpose")]

# binning for dt
bins <- woebin(dt, y = "creditability")

# converting original value to woe
dt_woe <- woebin_ply(dt, bins=bins)

\dontrun{
# Example II
# binning for germancredit dataset
bins_germancredit <- woebin(germancredit, y="creditability")

# converting the values of germancredit into woe
# bins is a list which generated from woebin()
germancredit_woe <- woebin_ply(germancredit, bins_germancredit)

# bins is a dataframe
bins_df <- data.table::rbindlist(bins_germancredit)
germancredit_woe <- woebin_ply(germancredit, bins_df)
}

}
\seealso{
\code{\link{woebin}}, \code{\link{woebin_plot}}
}
