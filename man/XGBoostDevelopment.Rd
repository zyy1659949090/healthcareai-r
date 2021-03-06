% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xgboost-development.R
\docType{class}
\name{XGBoostDevelopment}
\alias{XGBoostDevelopment}
\title{Compare predictive models, created on your data}
\format{An object of class \code{R6ClassGenerator} of length 24.}
\usage{
XGBoostDevelopment(type, df, grainCol, predictedCol, 
impute, debug, cores, modelName, xgb_params, xgb_nrounds)
}
\arguments{
\item{type}{The type of model. Currently requires 'multiclass'.}

\item{df}{Dataframe whose columns are used for calc.}

\item{grainCol}{Optional. The dataframe's column that has IDs pertaining to 
the grain. No ID columns are truly needed for this step.}

\item{predictedCol}{Column that you want to predict. If you're doing
classification then this should be Y/N.}

\item{impute}{Set all-column imputation to T or F.
If T, this uses mean replacement for numeric columns
and most frequent for factorized columns.
F leads to removal of rows containing NULLs.
Values are saved for deployment.}

\item{debug}{Provides the user extended output to the console, in order
to monitor the calculations throughout. Use T or F.}

\item{cores}{Number of cores you'd like to use. Defaults to 2.}

\item{modelName}{Optional string. Can specify the model name. If used, you must load the same one in the deploy step.}

\item{xgb_params}{A list, containing optional xgboost parameters. The full list of params can be found at
\url{http://xgboost.readthedocs.io/en/latest/parameter.html}.}

\item{xgb_nrounds}{Number of rounds to use for boosting.}
}
\description{
This step allows you to create an XGBoost classification model, based on
your data. Use model type 'multiclass' with 2 or more classes. XGBoost is an ensemble model,
well suited to non-linear data and very fast. Can be parameter-dependent.
}
\section{Methods}{
 
The above describes params for initializing a new XGBoostDevelopment class with 
\code{$new()}. Individual methods are documented below.
}

\section{\code{$new()}}{

Initializes a new XGBoost development class using the 
parameters saved in \code{p}, documented above. This method loads, cleans, and prepares data for
model training. \cr
\emph{Usage:} \code{$new(p)}
}

\section{\code{$run()}}{

Trains model, displays predictions and class-wise performance. \cr
\emph{Usage:} \code{$new()}
}

\section{\code{$getPredictions()}}{

Returns the predictions from test data. \cr
\emph{Usage:} \code{$getPredictions()} \cr
}

\section{\code{$generateConfusionMatrix()}}{

Returns the confusion matrix and statistics generated during model development. \cr
\emph{Usage:} \code{$getConfusionMatrix()} \cr
}

\examples{

#### Example using csv dataset ####
ptm <- proc.time()
library(healthcareai)

# 1. Load data. Categorical columns should be characters.
csvfile <- system.file("extdata", 
                      "dermatology_multiclass_data.csv", 
                      package = "healthcareai")

 # Replace csvfile with 'path/file'
df <- read.csv(file = csvfile, 
              header = TRUE, 
              stringsAsFactors = FALSE,
              na.strings = c("NULL", "NA", "", "?"))

str(df) # check the types of columns

# 2. Develop and save model
set.seed(42)
p <- SupervisedModelDevelopmentParams$new()
p$df <- df
p$type <- "multiclass"
p$impute <- TRUE
p$grainCol <- "PatientID"
p$predictedCol <- "target"
p$debug <- FALSE
p$cores <- 1
# xgb_params must be a list with all of these things in it. 
# if you would like to tweak parameters, go for it! 
# Leave objective and eval_metric as they are.
p$xgb_params <- list("objective" = "multi:softprob",
                  "eval_metric" = "mlogloss",
                  "max_depth" = 6, # max depth of each learner
                  "eta" = 0.1, # learning rate
                  "silent" = 0, # verbose output when set to 1
                  "nthread" = 2) # number of processors to use

# Run model
boost <- XGBoostDevelopment$new(p)
boost$run()

# Get output data 
outputDF <- boost$getPredictions()
head(outputDF)

print(proc.time() - ptm)

}
\references{
\url{http://healthcareai-r.readthedocs.io}
}
\seealso{
Information on the example dataset can be found at: 
\url{http://archive.ics.uci.edu/ml/datasets/dermatology/}

Information on the xgboost parameters can be found at:
\url{https://github.com/dmlc/xgboost/blob/master/doc/parameter.md}

\code{\link{selectData}}
}
\keyword{datasets}
