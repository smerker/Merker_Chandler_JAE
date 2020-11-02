#load data required for n-mixture models
load("JAE-data.gzip")

library(rjags)

## format data
jd.cawa.pb <- list(ySpeciesA=cawa.count.3D2, #counts at each point
                   wind=wind3D2,# wind during surveys
                   noise=noise3D2, # noise during surveys
                   date=date3D.pbs2,# date of count
                   time=time3D2.mat, # time of day
                   climate=climate.var.new, # principle component of PRISM data
                   treatment=treat.mat, # treatment variable,
                   nSites=nrow(treat.mat), # 71 sites
                   nIntervals=c(4,4,4,4), # survey periods
                   T=length(cawa.count.3D2[1,1,])) #years
str(jd.cawa.pb)

## initial values
ji.cawa.pb <- function() list(NSpeciesA=matrix(10, nrow(treat.mat), 4), 
                              beta0a=rnorm(1), beta1a=rnorm(1))
## parameters of interest
jp.cawa.pb <- c("beta0a", "beta1a",
                "alpha0a", "alpha1a", "alpha2a", "alpha3a","alpha4a",
                "lambda0a", "lambda1a", "lambda2a", "lambda3a", "deviance")

## Compiles the model 
load.module("dic")
jm.cawa.pb<- jags.model(file="Abundance.jag", data=jd.cawa.pb, inits=ji.cawa.pb, n.chains=2) #compiles an abundance model

## Draw posterior samples
jc.cawa.pb <- coda.samples(jm.cawa.pb, jp.cawa.pb, n.iter=100) # change n.iter to something like 50000, set 100 for testing

## WAIC
waic.cawa.pb <- jags.samples(jm.cawa.pb, c("deviance", "WAIC"), type="mean", n.iter=100)
waic.cawa.pbu <- lapply(waic.cawa.pb, unclass)
waic.cawa.pb2 <- sapply(waic.cawa.pbu, sum)
WAIC.pb <- unname(waic.cawa.pb2["deviance"] + waic.cawa.pb2["WAIC"])
WAIC.pb

#create summary statistics
jc.sum.cawa.pb<-summary(jc.cawa.pb)

#summary statistics
jc.sum.cawa.pb


